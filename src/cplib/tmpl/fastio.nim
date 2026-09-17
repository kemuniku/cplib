when not declared CPLIB_TMPL_FASTIO:
    const CPLIB_TMPL_FASTIO* = 1
    {.passC: "-mavx2".}
    # mmapは明示指定時のみ使用する。旧来の無効化指定も優先して尊重する。
    when not defined(fastioMmap) or defined(fastioNoMmap):
        {.passC: "-DCPLIB_FASTIO_NO_MMAP".}
    import macros

    # 入力系（C/C++共通。GCC/ClangとAVX2対応CPU向け）
    {.emit: """
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <immintrin.h>
#include <stdlib.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>

#define cplib_fio_buffer_size (1U << 20)
#define cplib_fio_safe_integer_bytes 32

typedef struct {
  char buffer[cplib_fio_buffer_size] __attribute__((aligned(64)));
  size_t cursor;
  size_t length;
  const char* mapped;
  bool initialized;
} cplib_fio_InputState;

static inline cplib_fio_InputState* cplib_fio_input_state(void) {
  static cplib_fio_InputState state = {0};
  return &state;
}

// バッファ境界をまたぐトークンだけ、一時領域へ連結します。
static char* cplib_fio_token_storage;
static size_t cplib_fio_token_capacity;
static void cplib_fio_append_token(size_t* length, const char* source, size_t count) {
  // 必要なら領域を拡張してトークンを連結します。償却O(count)。
  if (count > SIZE_MAX - *length) abort();
  const size_t needed = *length + count;
  if (needed > cplib_fio_token_capacity) {
    size_t capacity = needed <= SIZE_MAX / 2 ? needed * 2 : needed;
    char* storage = (char*)realloc(cplib_fio_token_storage, capacity);
    if (storage == NULL) abort();
    cplib_fio_token_storage = storage;
    cplib_fio_token_capacity = capacity;
  }
  if (count != 0) memcpy(cplib_fio_token_storage + *length, source, count);
  *length = needed;
}

#if defined(__GNUC__) || defined(__clang__)
#define CPLIB_FASTIO_ALWAYS_INLINE static inline __attribute__((always_inline))
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE \
    static inline __attribute__((always_inline))
#define CPLIB_FASTIO_UNLIKELY(condition) (__builtin_expect(!!(condition), 0))
#elif defined(_MSC_VER)
#define CPLIB_FASTIO_ALWAYS_INLINE static __forceinline
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE static __forceinline
#define CPLIB_FASTIO_UNLIKELY(condition) (condition)
#else
#define CPLIB_FASTIO_ALWAYS_INLINE static inline
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE static inline
#define CPLIB_FASTIO_UNLIKELY(condition) (condition)
#endif

static inline void cplib_fio_initialize(cplib_fio_InputState* state) {
  if (state->initialized) return;
  state->initialized = true;

#ifndef CPLIB_FASTIO_NO_MMAP
  struct stat st;
  const int fd = fileno(stdin);
  if (fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0) {
    void* p = mmap(NULL, (size_t)(st.st_size),
                   PROT_READ, MAP_PRIVATE, fd, 0);
    if (p != MAP_FAILED) {
      state->mapped = (const char*)p;
      state->length = (size_t)(st.st_size);
      madvise((char*)(state->mapped), state->length,
              MADV_SEQUENTIAL);
    }
  }
#endif
}

static inline bool cplib_fio_refill(cplib_fio_InputState* state) {
  state->length =
      fread_unlocked(state->buffer, 1, cplib_fio_buffer_size, stdin);
  state->cursor = 0;
  return state->length != 0;
}

static inline int cplib_fio_get_char(void) {
  cplib_fio_InputState* state = cplib_fio_input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state);
  if (state->mapped != NULL) {
    if (state->cursor == state->length) return -1;
    return (unsigned char)(state->mapped[state->cursor++]);
  }
  if (state->cursor == state->length && !cplib_fio_refill(state)) return -1;
  return (unsigned char)(state->buffer[state->cursor++]);
}

static inline bool cplib_fio_has_eight_digits(const char* source) {
  // 正しい整数入力では、数字・符号・空白を上位4bitだけで判別できる。
  uint64_t bytes;
  memcpy(&bytes, source, sizeof(bytes));
  return ((bytes ^ 0x3030303030303030ULL) &
          0xf0f0f0f0f0f0f0f0ULL) == 0;
}

static inline unsigned cplib_fio_parse_eight_digits(const char* source) {
  uint64_t digits;
  memcpy(&digits, source, sizeof(digits));
  digits ^= 0x3030303030303030ULL;
  digits = (digits * ((10ULL << 8) + 1) >> 8) &
      0x00ff00ff00ff00ffULL;
  digits = (digits * ((100ULL << 16) + 1) >> 16) &
      0x0000ffff0000ffffULL;
  return (unsigned)(
      digits * ((10000ULL << 32) + 1) >> 32);
}

static inline unsigned cplib_fio_digit_at(const char* source) {
  return (unsigned)((unsigned char)*source) -
         '0';
}

// 型と符号を実体化し、桁ごとの符号判定をコンパイル時に除去します。
#define CPLIB_FASTIO_DIGITS(suffix, Value, negative) \
CPLIB_FASTIO_ALWAYS_INLINE bool cplib_fio_try_digits_##suffix( \
        const char** source, Value* output) { \
  Value value = 0; \
  if (cplib_fio_has_eight_digits(*source)) { \
    const Value digits = \
        (Value)(cplib_fio_parse_eight_digits(*source)); \
    value = negative ? value * 100000000LL - digits \
                     : value * 100000000LL + digits; \
    *source += 8; \
    if (cplib_fio_has_eight_digits(*source)) { \
      const Value next_digits = \
          (Value)(cplib_fio_parse_eight_digits(*source)); \
      value = negative ? value * 100000000LL - next_digits \
                       : value * 100000000LL + next_digits; \
      *source += 8; \
      for (int pair = 0; pair < 2; ++pair) { \
        const unsigned first = cplib_fio_digit_at(*source); \
        if (first >= 10U) { \
          *output = value; \
          return true; \
        } \
        const unsigned second = cplib_fio_digit_at(*source + 1); \
        if (second >= 10U) { \
          ++*source; \
          *output = negative \
              ? value * 10 - (Value)first \
              : value * 10 + (Value)first; \
          return true; \
        } \
        value = negative \
            ? value * 100 - (Value)(first * 10U + second) \
            : value * 100 + (Value)(first * 10U + second); \
        *source += 2; \
      } \
      if (cplib_fio_digit_at(*source) < 10U) return false; \
      *output = value; \
      return true; \
    } \
  } \
  for (;;) { \
    const unsigned first = cplib_fio_digit_at(*source); \
    if (first >= 10U) { \
      *output = value; \
      return true; \
    } \
    const unsigned second = cplib_fio_digit_at(*source + 1); \
    if (second >= 10U) { \
      ++*source; \
      *output = negative ? value * 10 - (Value)first \
                        : value * 10 + (Value)first; \
      return true; \
    } \
    value = negative \
        ? value * 100 - (Value)(first * 10U + second) \
        : value * 100 + (Value)(first * 10U + second); \
    *source += 2; \
  } \
} \
static __attribute__((noinline)) Value cplib_fio_bounded_##suffix(const char** source, \
                                      const char* end) { \
  Value value = 0; \
  while (end - *source >= 8 && cplib_fio_has_eight_digits(*source)) { \
    const Value digits = \
        (Value)(cplib_fio_parse_eight_digits(*source)); \
    value = negative ? value * 100000000LL - digits \
                     : value * 100000000LL + digits; \
    *source += 8; \
  } \
  while (end - *source >= 2) { \
    const unsigned first = cplib_fio_digit_at(*source); \
    const unsigned second = cplib_fio_digit_at(*source + 1); \
    if (first >= 10U) return value; \
    if (second >= 10U) { \
      ++*source; \
      return negative ? value * 10 - (Value)first \
                      : value * 10 + (Value)first; \
    } \
    value = negative \
        ? value * 100 - (Value)(first * 10U + second) \
        : value * 100 + (Value)(first * 10U + second); \
    *source += 2; \
  } \
  if (*source != end) { \
    const unsigned digit = cplib_fio_digit_at(*source); \
    if (digit < 10U) { \
      value = negative ? value * 10 - (Value)digit \
                       : value * 10 + (Value)digit; \
      ++*source; \
    } \
  } \
  return value; \
}
CPLIB_FASTIO_DIGITS(positive, long long, false)
CPLIB_FASTIO_DIGITS(negative, long long, true)
CPLIB_FASTIO_DIGITS(unsigned, unsigned long long, false)
#undef CPLIB_FASTIO_DIGITS

static inline unsigned long long cplib_fio_read_uint_stream_slow(cplib_fio_InputState* state) {
  const bool negative = state->buffer[state->cursor] == '-';
  if (negative || state->buffer[state->cursor] == '+') {
    ++state->cursor;
    if (state->cursor == state->length && !cplib_fio_refill(state)) return 0;
  }
  unsigned long long value = 0;
  for (;;) {
    while (state->cursor != state->length) {
      const unsigned digit = cplib_fio_digit_at(state->buffer + state->cursor);
      if (digit >= 10U) return negative ? 0ULL - value : value;
      value = value * 10ULL + digit;
      ++state->cursor;
    }
    if (!cplib_fio_refill(state)) return negative ? 0ULL - value : value;
  }
}

CPLIB_FASTIO_ALWAYS_INLINE bool cplib_fio_try_int(const char** source, long long* value, bool negative) {
  // 符号別に解析します。
  return negative ? cplib_fio_try_digits_negative(source, value)
                  : cplib_fio_try_digits_positive(source, value);
}
CPLIB_FASTIO_ALWAYS_INLINE bool cplib_fio_try_uint(const char** source, unsigned long long* value, bool negative) {
  // 解析後に符号を適用します。
  bool complete = cplib_fio_try_digits_unsigned(source, value);
  if (complete && negative) *value = 0ULL - *value;
  return complete;
}
static inline long long cplib_fio_bounded_int(const char** source, const char* end, bool negative) {
  // 終端までの符号付き整数を読み取ります。
  return negative ? cplib_fio_bounded_negative(source, end)
                  : cplib_fio_bounded_positive(source, end);
}
static inline unsigned long long cplib_fio_bounded_uint(const char** source, const char* end, bool negative) {
  // 終端までの符号なし整数を読み取ります。
  unsigned long long value = cplib_fio_bounded_unsigned(source, end);
  return negative ? 0ULL - value : value;
}

#define CPLIB_FASTIO_READ(suffix, Value, try_digits, bounded) \
CPLIB_FASTIO_ALWAYS_INLINE Value cplib_fio_read_##suffix##_mapped_at( \
        const char** source, const char* end) { \
  while (*source != end && \
         (unsigned char)(**source) <= \
             ' ') { \
    ++*source; \
  } \
  if (*source == end) return 0; \
  const bool negative = **source == '-'; \
  if (negative || **source == '+') ++*source; \
  if (end - *source >= (ptrdiff_t)cplib_fio_safe_integer_bytes) { \
    const char* parsed = *source; \
    Value value; \
    if (try_digits(&parsed, &value, negative)) { \
      *source = parsed; \
      return value; \
    } \
  } \
  const Value value = \
      bounded(source, end, negative); \
  return value; \
} \
CPLIB_FASTIO_ALWAYS_INLINE Value cplib_fio_read_##suffix##_stream( \
        cplib_fio_InputState* state) { \
  for (;;) { \
    if (state->cursor == state->length && !cplib_fio_refill(state)) return 0; \
    while (state->cursor != state->length && \
           (unsigned char)(state->buffer[state->cursor]) <= \
               ' ') { \
      ++state->cursor; \
    } \
    if (state->cursor != state->length) break; \
  } \
  if (state->length - state->cursor < cplib_fio_safe_integer_bytes) { \
    return (Value)cplib_fio_read_uint_stream_slow(state); \
  } \
  const char* source = state->buffer + state->cursor; \
  const bool negative = *source == '-'; \
  if (negative || *source == '+') ++source; \
  Value value; \
  if (!try_digits(&source, &value, negative)) { \
    return (Value)cplib_fio_read_uint_stream_slow(state); \
  } \
  state->cursor = (size_t)(source - state->buffer); \
  return value; \
} \
CPLIB_FASTIO_ALWAYS_INLINE Value cplib_fio_read_##suffix(void) { \
  cplib_fio_InputState* state = cplib_fio_input_state(); \
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state); \
  if (state->mapped == NULL) return cplib_fio_read_##suffix##_stream(state); \
  const char* source = state->mapped + state->cursor; \
  const Value value = \
      cplib_fio_read_##suffix##_mapped_at(&source, state->mapped + state->length); \
  state->cursor = (size_t)(source - state->mapped); \
  return value; \
}
CPLIB_FASTIO_READ(int, long long, cplib_fio_try_int, cplib_fio_bounded_int)
CPLIB_FASTIO_READ(uint, unsigned long long, cplib_fio_try_uint, cplib_fio_bounded_uint)
#undef CPLIB_FASTIO_READ

static inline bool cplib_fio_is_space(char value) {
  return (unsigned char)value <=
         ' ';
}

static inline void cplib_fio_skip_spaces(const char** source, const char* end) {
  while (*source != end && cplib_fio_is_space(**source)) ++*source;
}

static inline void cplib_fio_consume_separator(const char** source, const char* end) {
  if (*source != end) {
    ++*source;
    cplib_fio_skip_spaces(source, end);
  }
}

static inline unsigned cplib_fio_parse_eight_digits_simd(const char* source) {
  const __m128i bytes = _mm_loadl_epi64(
      (const __m128i*)source);
  const __m128i digits = _mm_sub_epi8(bytes, _mm_set1_epi8('0'));
  const __m128i pairs = _mm_maddubs_epi16(
      digits, _mm_setr_epi8(10, 1, 10, 1, 10, 1, 10, 1,
                            0, 0, 0, 0, 0, 0, 0, 0));
  const __m128i quads = _mm_madd_epi16(
      pairs, _mm_setr_epi16(100, 1, 100, 1, 0, 0, 0, 0));
  return (unsigned)(_mm_cvtsi128_si32(quads)) * 10000U +
      (unsigned)(_mm_cvtsi128_si32(_mm_srli_si128(quads, 4)));
}

// 呼び出し元で空白を除去済み。長い先頭ゼロと末尾は境界付き処理へ戻す。
static inline uint32_t cplib_fio_read_u32_digits(const char** source, const char* end) {
  if (*source == end) return 0;
  const bool negative = **source == '-';
  if (negative || **source == '+') ++*source;
  unsigned long long value = 0;
  if (end - *source >= 16) {
    if (cplib_fio_has_eight_digits(*source)) {
      value = cplib_fio_parse_eight_digits_simd(*source);
      const unsigned ninth = cplib_fio_digit_at(*source + 8);
      const unsigned tenth = cplib_fio_digit_at(*source + 9);
      if (ninth >= 10U) {
        *source += 8;
      } else if (tenth >= 10U) {
        value = value * 10ULL + ninth;
        *source += 9;
      } else if (cplib_fio_digit_at(*source + 10) >= 10U) {
        value = value * 100ULL + ninth * 10U + tenth;
        *source += 10;
      } else {
        value = cplib_fio_bounded_unsigned(source, end);
      }
    } else {
      for (;;) {
        const unsigned first = cplib_fio_digit_at(*source);
        if (first >= 10U) break;
        const unsigned second = cplib_fio_digit_at(*source + 1);
        if (second >= 10U) {
          value = value * 10ULL + first;
          ++*source;
          break;
        }
        value = value * 100ULL + first * 10U + second;
        *source += 2;
      }
    }
  } else {
    value = cplib_fio_bounded_unsigned(source, end);
  }
  return (uint32_t)(negative ? 0ULL - value : value);
}

CPLIB_FASTIO_ALWAYS_INLINE uint32_t cplib_fio_read_u32() {
  cplib_fio_InputState* state = cplib_fio_input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state);
  if (state->mapped != NULL) {
    const char* source = state->mapped + state->cursor;
    const char* const end = state->mapped + state->length;
    cplib_fio_skip_spaces(&source, end);
    const uint32_t value = cplib_fio_read_u32_digits(&source, end);
    cplib_fio_consume_separator(&source, end);
    state->cursor = (size_t)(source - state->mapped);
    return value;
  }
  const char* source = state->buffer + state->cursor;
  const char* const end = state->buffer + state->length;
  cplib_fio_skip_spaces(&source, end);
  if (CPLIB_FASTIO_UNLIKELY(end - source <
                           (ptrdiff_t)cplib_fio_safe_integer_bytes)) {
    return (uint32_t)(cplib_fio_read_uint_stream(state));
  }
  const uint32_t value = cplib_fio_read_u32_digits(&source, end);
  // 長い先頭ゼロがrefill境界をまたぐ場合は、元の位置から読み直す。
  if (CPLIB_FASTIO_UNLIKELY(source == end)) {
    return (uint32_t)(cplib_fio_read_uint_stream(state));
  }
  cplib_fio_consume_separator(&source, end);
  state->cursor = (size_t)(source - state->buffer);
  return value;
}

static inline bool cplib_fio_try_read_four_nine_digit_u32(
        const char** source, const char* end, uint32_t* output) {
  if (end - *source < 40) return false;
  if (!cplib_fio_is_space((*source)[9]) || !cplib_fio_is_space((*source)[19]) ||
      !cplib_fio_is_space((*source)[29]) || !cplib_fio_is_space((*source)[39])) {
    return false;
  }
  const __m128i first_two = _mm_unpacklo_epi64(
      _mm_loadl_epi64((const __m128i*)*source),
      _mm_loadl_epi64((const __m128i*)(*source + 10)));
  const __m128i last_two = _mm_unpacklo_epi64(
      _mm_loadl_epi64((const __m128i*)(*source + 20)),
      _mm_loadl_epi64((const __m128i*)(*source + 30)));
  const __m256i bytes = _mm256_set_m128i(last_two, first_two);
  const __m256i is_digit = _mm256_and_si256(
      _mm256_cmpgt_epi8(bytes, _mm256_set1_epi8('/')),
      _mm256_cmpgt_epi8(_mm256_set1_epi8(':'), bytes));
  if ((unsigned)(_mm256_movemask_epi8(is_digit)) !=
      0xffffffffU) {
    return false;
  }

  const unsigned digit0 = cplib_fio_digit_at(*source + 8);
  const unsigned digit1 = cplib_fio_digit_at(*source + 18);
  const unsigned digit2 = cplib_fio_digit_at(*source + 28);
  const unsigned digit3 = cplib_fio_digit_at(*source + 38);
  const bool ninth_digits = (digit0 < 10U) & (digit1 < 10U) &
                            (digit2 < 10U) & (digit3 < 10U);
  if (!ninth_digits) return false;

  const __m256i digits =
      _mm256_sub_epi8(bytes, _mm256_set1_epi8('0'));
  const __m256i pairs = _mm256_maddubs_epi16(
      digits, _mm256_setr_epi8(
          10, 1, 10, 1, 10, 1, 10, 1,
          10, 1, 10, 1, 10, 1, 10, 1,
          10, 1, 10, 1, 10, 1, 10, 1,
          10, 1, 10, 1, 10, 1, 10, 1));
  const __m256i quads = _mm256_madd_epi16(
      pairs, _mm256_setr_epi16(
          100, 1, 100, 1, 100, 1, 100, 1,
          100, 1, 100, 1, 100, 1, 100, 1));
  const __m256i weighted = _mm256_mullo_epi32(
      quads, _mm256_setr_epi32(
          10000, 1, 10000, 1, 10000, 1, 10000, 1));
  const __m256i sums =
      _mm256_hadd_epi32(weighted, _mm256_setzero_si256());
  const __m128i first_eight = _mm_unpacklo_epi64(
      _mm256_castsi256_si128(sums),
      _mm256_extracti128_si256(sums, 1));
  const __m128i values = _mm_add_epi32(
      _mm_mullo_epi32(first_eight, _mm_set1_epi32(10)),
      _mm_setr_epi32((int)digit0,
                     (int)digit1,
                     (int)digit2,
                     (int)digit3));
  _mm_storeu_si128((__m128i*)output, values);
  *source += 40;
  return true;
}

static inline void cplib_fio_read_u32_array(uint32_t* output, size_t count) {
  cplib_fio_InputState* state = cplib_fio_input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state);
  if (state->mapped != NULL) {
    const char* source = state->mapped + state->cursor;
    const char* const end = state->mapped + state->length;
    cplib_fio_skip_spaces(&source, end);
    size_t i = 0;
    unsigned nine_digit_count = 0;
    // 最初の16要素を読みながら分布を確認し、短い整数ではAVX判定を省く。
    if (count >= 64) {
      for (; i < 16; ++i) {
        nine_digit_count += end - source >= 10 &&
            cplib_fio_is_space(source[9]) && cplib_fio_has_eight_digits(source) &&
            cplib_fio_digit_at(source + 8) < 10U;
        output[i] = cplib_fio_read_u32_digits(&source, end);
        cplib_fio_consume_separator(&source, end);
      }
    }
    if (nine_digit_count >= 12) {
      while (i < count) {
        if (count - i >= 4 && cplib_fio_try_read_four_nine_digit_u32(&source, end, output + i)) {
          i += 4;
          cplib_fio_skip_spaces(&source, end);
        } else {
          output[i++] = cplib_fio_read_u32_digits(&source, end);
          if (i != count) cplib_fio_consume_separator(&source, end);
        }
      }
    } else {
      while (i < count) {
        output[i++] = cplib_fio_read_u32_digits(&source, end);
        if (i != count) cplib_fio_consume_separator(&source, end);
      }
    }
    state->cursor = (size_t)(source - state->mapped);
  } else {
    size_t i = 0;
    unsigned nine_digit_count = 0;
    if (count >= 64) {
      for (; i < 16; ++i) {
        output[i] = (uint32_t)(cplib_fio_read_uint_stream(state));
        nine_digit_count += output[i] >= 100000000U &&
                            output[i] < 1000000000U;
      }
    }
    if (nine_digit_count >= 12) {
      while (count - i >= 4) {
        const char* source = state->buffer + state->cursor;
        const char* const end = state->buffer + state->length;
        cplib_fio_skip_spaces(&source, end);
        if (cplib_fio_try_read_four_nine_digit_u32(&source, end, output + i)) {
          state->cursor = (size_t)(source - state->buffer);
          i += 4;
        } else {
          state->cursor = (size_t)(source - state->buffer);
          // refillをまたぐ整数は既存のストリーム処理で最後まで読む。
          output[i++] = (uint32_t)(cplib_fio_read_uint_stream(state));
        }
      }
    }
    for (; i < count; ++i) {
      output[i] = (uint32_t)(cplib_fio_read_uint_stream(state));
    }
  }
}

static inline const char* cplib_fio_read_token(size_t* output_length) {
  cplib_fio_InputState* state = cplib_fio_input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state);
  if (state->mapped != NULL) {
    const char* source = state->mapped + state->cursor;
    const char* const end = state->mapped + state->length;
    while (source != end &&
           (unsigned char)*source <=
               ' ') {
      ++source;
    }
    const char* const token = source;
    while (source != end &&
           (unsigned char)*source >
               ' ') {
      ++source;
    }
    state->cursor = (size_t)(source - state->mapped);
    *output_length = (size_t)(source - token);
    return token;
  }

  for (;;) {
    if (state->cursor == state->length && !cplib_fio_refill(state)) {
      *output_length = 0;
      return "";
    }
    while (state->cursor != state->length &&
           (unsigned char)(state->buffer[state->cursor]) <=
               ' ') {
      ++state->cursor;
    }
    if (state->cursor != state->length) break;
  }

  const size_t token_begin = state->cursor;
  while (state->cursor != state->length &&
         (unsigned char)(state->buffer[state->cursor]) >
             ' ') {
    ++state->cursor;
  }
  if (state->cursor != state->length) {
    *output_length = state->cursor - token_begin;
    return state->buffer + token_begin;
  }

  size_t length = 0;
  cplib_fio_append_token(&length, state->buffer + token_begin, state->length - token_begin);
  while (cplib_fio_refill(state)) {
    while (state->cursor != state->length &&
           (unsigned char)(state->buffer[state->cursor]) >
               ' ') {
      ++state->cursor;
    }
    cplib_fio_append_token(&length, state->buffer, state->cursor);
    if (state->cursor != state->length) break;
  }
  *output_length = length;
  return cplib_fio_token_storage;
}

#define CPLIB_FASTIO_READ_ARRAY(name, T, mapped_reader, stream_reader) \
static inline void name(void* destination, size_t count) { \
  T* output = (T*)destination; \
  cplib_fio_InputState* state = cplib_fio_input_state(); \
  if (CPLIB_FASTIO_UNLIKELY(!state->initialized)) cplib_fio_initialize(state); \
  if (state->mapped != NULL) { \
    const char* source = state->mapped + state->cursor; \
    const char* end = state->mapped + state->length; \
    for (size_t i = 0; i < count; ++i) output[i] = (T)mapped_reader(&source, end); \
    state->cursor = (size_t)(source - state->mapped); \
  } else { \
    for (size_t i = 0; i < count; ++i) output[i] = (T)stream_reader(state); \
  } \
}
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_i8_array, int8_t, cplib_fio_read_int_mapped_at, cplib_fio_read_int_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_i16_array, int16_t, cplib_fio_read_int_mapped_at, cplib_fio_read_int_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_i32_array, int32_t, cplib_fio_read_int_mapped_at, cplib_fio_read_int_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_i64_array, int64_t, cplib_fio_read_int_mapped_at, cplib_fio_read_int_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_u8_array, uint8_t, cplib_fio_read_uint_mapped_at, cplib_fio_read_uint_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_u16_array, uint16_t, cplib_fio_read_uint_mapped_at, cplib_fio_read_uint_stream)
CPLIB_FASTIO_READ_ARRAY(cplib_fio_read_u64_array, uint64_t, cplib_fio_read_uint_mapped_at, cplib_fio_read_uint_stream)
#undef CPLIB_FASTIO_READ_ARRAY

#undef CPLIB_FASTIO_UNLIKELY
#undef CPLIB_FASTIO_ALWAYS_INLINE

""".}

    proc fastioGetChar(): cint {.importc: "cplib_fio_get_char", nodecl, inline.}
    proc fastioReadInt(): clonglong {.importc: "cplib_fio_read_int", nodecl, inline.}
    proc fastioReadUInt(): culonglong {.importc: "cplib_fio_read_uint", nodecl, inline.}
    proc fastioReadUInt32(): uint32 {.importc: "cplib_fio_read_u32", nodecl, inline.}
    type FastioTokenPointer {.importc: "const char*", nodecl.} = pointer
    proc fastioReadToken(length: ptr csize_t): FastioTokenPointer
        {.importc: "cplib_fio_read_token", nodecl, inline.}
    proc fastioCopyToken(destination: pointer, source: FastioTokenPointer, length: csize_t)
            {.importc: "memcpy", nodecl, inline.}
        ## 読み取り専用の入力領域からlengthバイトをコピーします。O(length)。

    proc fastioReadArray(values: ptr int8, count: csize_t) {.importc: "cplib_fio_read_i8_array", nodecl, inline.}
    proc fastioReadArray(values: ptr int16, count: csize_t) {.importc: "cplib_fio_read_i16_array", nodecl, inline.}
    proc fastioReadArray(values: ptr int32, count: csize_t) {.importc: "cplib_fio_read_i32_array", nodecl, inline.}
    proc fastioReadArray(values: ptr int64, count: csize_t) {.importc: "cplib_fio_read_i64_array", nodecl, inline.}
    proc fastioReadArray(values: ptr uint8, count: csize_t) {.importc: "cplib_fio_read_u8_array", nodecl, inline.}
    proc fastioReadArray(values: ptr uint16, count: csize_t) {.importc: "cplib_fio_read_u16_array", nodecl, inline.}
    proc fastioReadArray(values: ptr uint32, count: csize_t) {.importc: "cplib_fio_read_u32_array", nodecl, inline.}
    proc fastioReadArray(values: ptr uint64, count: csize_t) {.importc: "cplib_fio_read_u64_array", nodecl, inline.}

    template fastioReadIntegerArray(T: typedesc, values, count: untyped) =
        ## int/uintも固定幅の型へ合わせて配列を読み込みます。O(count)。
        when T is SomeSignedInt:
            when sizeof(T) == 8: fastioReadArray(cast[ptr int64](values), count)
            elif sizeof(T) == 4: fastioReadArray(cast[ptr int32](values), count)
            else: fastioReadArray(values, count)
        else:
            when sizeof(T) == 8: fastioReadArray(cast[ptr uint64](values), count)
            elif sizeof(T) == 4: fastioReadArray(cast[ptr uint32](values), count)
            else: fastioReadArray(values, count)

    type FastioInteger = int | int8 | int16 | int32 | int64 |
        uint | uint8 | uint16 | uint32 | uint64

    when NimMajor >= 2:
        template fastioNewSeqUninit(T: typedesc, length: int): untyped =
            newSeqUninit[T](length)

        template fastioNewStringUninit(length: int): untyped =
            newStringUninit(length)
    else:
        template fastioNewSeqUninit(T: typedesc, length: int): untyped =
            newSeqUninitialized[T](length)

        template fastioNewStringUninit(length: int): untyped =
            newString(length)

    proc ii(): int {.inline,
            codegenDecl: "CPLIB_FASTIO_NIM_ALWAYS_INLINE $# $#$#".} =
        fastioReadInt().int
    proc lii(N: int): seq[int] {.inline.} =
        result = fastioNewSeqUninit(int, N)
        if N > 0:
            fastioReadIntegerArray(int, addr result[0], N.csize_t)

    # 型だけなら1要素、長さと型ならseqとして読み込む。
    proc input[T: FastioInteger](valueType: typedesc[T]): T {.inline,
            codegenDecl: "CPLIB_FASTIO_NIM_ALWAYS_INLINE $# $#$#".} =
        when T is range:
            {.error: "input supports only primitive integer types".}
        elif T is SomeSignedInt:
            T(fastioReadInt())
        elif T is uint32:
            fastioReadUInt32()
        else:
            T(fastioReadUInt())

    proc input[T: FastioInteger](N: int, valueType: typedesc[T]): seq[T] {.inline.} =
        when T is range:
            {.error: "input supports only primitive integer types".}
        else:
            result = fastioNewSeqUninit(T, N)
            if N > 0:
                fastioReadIntegerArray(T, addr result[0], N.csize_t)

    proc si(): string {.inline.} =
        var length: csize_t
        let source = fastioReadToken(addr length)
        result = fastioNewStringUninit(length.int)
        if length != 0:
            fastioCopyToken(addr result[0], source, length)

    proc input(valueType: typedesc[string]): string {.inline.} =
        si()

    proc input(N: int, valueType: typedesc[string]): seq[string] {.inline.} =
        result = newSeq[string](N)
        for i in 0 ..< N:
            result[i] = input(string)

    # 出力系
    {.emit: """
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// stdioのバッファを共有し、echo/write/flushFileとの出力順を保ちます。
static char cplib_fio_stdout_buffer[1U << 16] __attribute__((aligned(64)));
static void __attribute__((constructor)) cplib_fio_init_stdout(void) {
  // 標準出力のバッファを初期化します。O(1)。
  setvbuf(stdout, cplib_fio_stdout_buffer, _IOFBF, sizeof(cplib_fio_stdout_buffer));
}

typedef struct { char data[10000][4]; } cplib_fio_FourDigits;
// 4桁テーブルをC/C++共通の定数式で構築します。
#define CPLIB_FASTIO_D4(a,b,c,d) {'0'+a, '0'+b, '0'+c, '0'+d}
#define CPLIB_FASTIO_D3(a,b,c) CPLIB_FASTIO_D4(a,b,c,0), CPLIB_FASTIO_D4(a,b,c,1), CPLIB_FASTIO_D4(a,b,c,2), CPLIB_FASTIO_D4(a,b,c,3), CPLIB_FASTIO_D4(a,b,c,4), CPLIB_FASTIO_D4(a,b,c,5), CPLIB_FASTIO_D4(a,b,c,6), CPLIB_FASTIO_D4(a,b,c,7), CPLIB_FASTIO_D4(a,b,c,8), CPLIB_FASTIO_D4(a,b,c,9)
#define CPLIB_FASTIO_D2(a,b) CPLIB_FASTIO_D3(a,b,0), CPLIB_FASTIO_D3(a,b,1), CPLIB_FASTIO_D3(a,b,2), CPLIB_FASTIO_D3(a,b,3), CPLIB_FASTIO_D3(a,b,4), CPLIB_FASTIO_D3(a,b,5), CPLIB_FASTIO_D3(a,b,6), CPLIB_FASTIO_D3(a,b,7), CPLIB_FASTIO_D3(a,b,8), CPLIB_FASTIO_D3(a,b,9)
#define CPLIB_FASTIO_D1(a) CPLIB_FASTIO_D2(a,0), CPLIB_FASTIO_D2(a,1), CPLIB_FASTIO_D2(a,2), CPLIB_FASTIO_D2(a,3), CPLIB_FASTIO_D2(a,4), CPLIB_FASTIO_D2(a,5), CPLIB_FASTIO_D2(a,6), CPLIB_FASTIO_D2(a,7), CPLIB_FASTIO_D2(a,8), CPLIB_FASTIO_D2(a,9)
static const cplib_fio_FourDigits cplib_fio_four_digit_table = {{
  CPLIB_FASTIO_D1(0), CPLIB_FASTIO_D1(1), CPLIB_FASTIO_D1(2), CPLIB_FASTIO_D1(3), CPLIB_FASTIO_D1(4), CPLIB_FASTIO_D1(5), CPLIB_FASTIO_D1(6), CPLIB_FASTIO_D1(7), CPLIB_FASTIO_D1(8), CPLIB_FASTIO_D1(9)
}};
#undef CPLIB_FASTIO_D1
#undef CPLIB_FASTIO_D2
#undef CPLIB_FASTIO_D3
#undef CPLIB_FASTIO_D4

static inline char* cplib_fio_reserve_bytes(FILE* output, size_t size) {
#if defined(__GLIBC__)
  // stdio自身のバッファを使い、echo/write/flushFileとの出力順を保つ。
  if (output->_IO_write_ptr != NULL &&
      output->_IO_write_end != NULL &&
      (size_t)(output->_IO_write_end -
                               output->_IO_write_ptr) >= size) {
    return output->_IO_write_ptr;
  }
#endif
  return NULL;
}

static inline void cplib_fio_commit_bytes(FILE* output, char* end) {
#if defined(__GLIBC__)
  output->_IO_write_ptr = end;
#else
  (void)output;
  (void)end;
#endif
}

static inline char* cplib_fio_write_small(char* output, unsigned value,
                         const cplib_fio_FourDigits* table) {
  if (value >= 1000) {
    memcpy(output, table->data[value], 4);
    return output + 4;
  }
  if (value >= 100) {
    memcpy(output, table->data[value] + 1, 3);
    return output + 3;
  }
  if (value >= 10) {
    memcpy(output, table->data[value] + 2, 2);
    return output + 2;
  }
  *output++ = ((char)('0' + value));
  return output;
}

static inline char* cplib_fio_write_four(char* output, unsigned value,
                        const cplib_fio_FourDigits* table) {
  memcpy(output, table->data[value], 4);
  return output + 4;
}

static inline char* cplib_fio_write_unsigned_32(char* output, uint32_t value,
                               const cplib_fio_FourDigits* table) {
  if (value < 10000U) return cplib_fio_write_small(output, value, table);
  const uint32_t quotient = value / 10000U;
  const unsigned low = (unsigned)(value - quotient * 10000U);
  if (quotient < 10000U) {
    output = cplib_fio_write_small(output, quotient, table);
    return cplib_fio_write_four(output, low, table);
  }
  const unsigned high = quotient / 10000U;
  const unsigned middle = quotient - high * 10000U;
  output = cplib_fio_write_small(output, high, table);
  output = cplib_fio_write_four(output, middle, table);
  return cplib_fio_write_four(output, low, table);
}

static inline char* cplib_fio_write_unsigned_64(char* output, uint64_t value,
                               const cplib_fio_FourDigits* table) {
  if (value < 10000ULL) {
    return cplib_fio_write_small(output, (unsigned)value, table);
  }
  const uint64_t quotient1 = value / 10000ULL;
  const unsigned chunk1 = (unsigned)(value - quotient1 * 10000ULL);
  if (quotient1 < 10000ULL) {
    output = cplib_fio_write_small(output, (unsigned)quotient1, table);
    return cplib_fio_write_four(output, chunk1, table);
  }
  const uint64_t quotient2 = quotient1 / 10000ULL;
  const unsigned chunk2 = (unsigned)(quotient1 - quotient2 * 10000ULL);
  if (quotient2 < 10000ULL) {
    output = cplib_fio_write_small(output, (unsigned)quotient2, table);
    output = cplib_fio_write_four(output, chunk2, table);
    return cplib_fio_write_four(output, chunk1, table);
  }
  const uint64_t quotient3 = quotient2 / 10000ULL;
  const unsigned chunk3 = (unsigned)(quotient2 - quotient3 * 10000ULL);
  if (quotient3 < 10000ULL) {
    output = cplib_fio_write_small(output, (unsigned)quotient3, table);
    output = cplib_fio_write_four(output, chunk3, table);
    output = cplib_fio_write_four(output, chunk2, table);
    return cplib_fio_write_four(output, chunk1, table);
  }
  const uint64_t quotient4 = quotient3 / 10000ULL;
  const unsigned chunk4 = (unsigned)(quotient3 - quotient4 * 10000ULL);
  output = cplib_fio_write_small(output, (unsigned)quotient4, table);
  output = cplib_fio_write_four(output, chunk4, table);
  output = cplib_fio_write_four(output, chunk3, table);
  output = cplib_fio_write_four(output, chunk2, table);
  return cplib_fio_write_four(output, chunk1, table);
}

typedef struct {
  char data[1U << 16];
  size_t length;
  FILE* output;
} cplib_fio_BufferedWriter;

static inline void cplib_fio_writer_flush(cplib_fio_BufferedWriter* writer) {
  // 保留中のバイト列を出力します。O(length)。
  if (writer->length != 0) {
    fwrite_unlocked(writer->data, 1, writer->length, writer->output);
    writer->length = 0;
  }
}

static inline void cplib_fio_writer_append(cplib_fio_BufferedWriter* writer, const char* source, size_t size) {
  // 必要に応じてフラッシュし、バイト列を追記します。O(size)。
  if (size <= sizeof(writer->data) - writer->length) {
    memcpy(writer->data + writer->length, source, size);
    writer->length += size;
    return;
  }
  cplib_fio_writer_flush(writer);
  if (size >= sizeof(writer->data)) {
    fwrite_unlocked(source, 1, size, writer->output);
  } else {
    memcpy(writer->data, source, size);
    writer->length = size;
  }
}

// 型・符号・桁数の分岐をコンパイル時に確定させます。
#define CPLIB_FASTIO_OUTPUT(suffix, Integer, Unsigned, is_signed, write_unsigned) \
static inline char* cplib_fio_format_##suffix(char* cursor, Integer value) { \
  Unsigned magnitude = (Unsigned)value; \
  if (is_signed && value < 0) { \
    *cursor++ = '-'; \
    magnitude = (Unsigned)0 - magnitude; \
  } \
  return write_unsigned(cursor, magnitude, &cplib_fio_four_digit_table); \
} \
static inline size_t cplib_fio_join_##suffix(const void* source, size_t count, char* output, \
                                   const char* separator, size_t separator_length) { \
  const Integer* values = (const Integer*)source; \
  char* cursor = output; \
  for (size_t i = 0; i < count; ++i) { \
    cursor = cplib_fio_format_##suffix(cursor, values[i]); \
    if (i + 1 != count) { \
      memcpy(cursor, separator, separator_length); \
      cursor += separator_length; \
    } \
  } \
  return (size_t)(cursor - output); \
} \
static inline void cplib_fio_print_array_##suffix(FILE* output, const void* source, size_t count, \
                                        const char* separator, size_t separator_length) { \
  const Integer* values = (const Integer*)source; \
  cplib_fio_BufferedWriter writer; \
  writer.length = 0; \
  writer.output = output; \
  for (size_t i = 0; i < count; ++i) { \
    if (sizeof(writer.data) - writer.length < 21) cplib_fio_writer_flush(&writer); \
    char* cursor = cplib_fio_format_##suffix(writer.data + writer.length, values[i]); \
    writer.length = (size_t)(cursor - writer.data); \
    if (i + 1 != count) cplib_fio_writer_append(&writer, separator, separator_length); \
  } \
  cplib_fio_writer_append(&writer, "\n", 1); \
  cplib_fio_writer_flush(&writer); \
} \
static inline void cplib_fio_print_one_##suffix(FILE* output, Integer value) { \
  char buffer[22]; \
  char* reserved = cplib_fio_reserve_bytes(output, sizeof(buffer)); \
  char* begin = reserved == NULL ? buffer : reserved; \
  char* cursor = cplib_fio_format_##suffix(begin, value); \
  *cursor++ = '\n'; \
  if (reserved != NULL) cplib_fio_commit_bytes(output, cursor); \
  else fwrite_unlocked(buffer, 1, (size_t)(cursor - buffer), output); \
}
CPLIB_FASTIO_OUTPUT(i32, int32_t, uint32_t, true, cplib_fio_write_unsigned_32)
CPLIB_FASTIO_OUTPUT(i64, int64_t, uint64_t, true, cplib_fio_write_unsigned_64)
CPLIB_FASTIO_OUTPUT(u32, uint32_t, uint32_t, false, cplib_fio_write_unsigned_32)
CPLIB_FASTIO_OUTPUT(u64, uint64_t, uint64_t, false, cplib_fio_write_unsigned_64)
#undef CPLIB_FASTIO_OUTPUT
""".}

    template fastioOutputBindings(T: typedesc, suffix: static[string]) =
        ## 指定した固定幅整数型のC関数を結び付けます。
        proc fastioJoinInts(values: ptr T, count: csize_t, output: ptr char,
                separator: cstring, separatorLen: csize_t): csize_t
            {.importc: "cplib_fio_join_" & suffix, nodecl, inject.}
        proc fastioPrintInts(output: File, values: ptr T, count: csize_t,
                separator: cstring, separatorLen: csize_t)
            {.importc: "cplib_fio_print_array_" & suffix, nodecl, inject.}
        proc fastioPrintInt(output: File, value: T)
            {.importc: "cplib_fio_print_one_" & suffix, nodecl, inject.}
    fastioOutputBindings(int32, "i32")
    fastioOutputBindings(int64, "i64")
    fastioOutputBindings(uint32, "u32")
    fastioOutputBindings(uint64, "u64")

    template fastioOutputType(T: typedesc): typedesc =
        ## 出力関数へ渡す整数型を符号と幅を保って選びます。
        when T is SomeSignedInt:
            when sizeof(T) <= 4: int32
            else: int64
        else:
            when sizeof(T) <= 4: uint32
            else: uint64

    proc print_internal(prop: tuple[f: File, sepc: string, endc: string,
            flush: bool], args: openArray[string]) =
        for i in 0 ..< args.len:
            prop.f.write(args[i])
            if i != args.len - 1:
                prop.f.write(prop.sepc)
            else:
                prop.f.write(prop.endc)
        if prop.flush:
            prop.f.flushFile()

    proc print*(prop: tuple[f: File, sepc: string, endc: string, flush: bool],
            args: varargs[string, `$`]) =
        print_internal(prop, args)

    proc fastioPrintWithSeparator(sep: string, args: varargs[string, `$`]) =
        print_internal((f: stdout, sepc: sep, endc: "\n", flush: false), args)

    proc fastioAppendInteger[T: SomeInteger](destination: var string, value: T) =
        var magnitude: uint64
        when T is SomeSignedInt:
            let signedValue = value.int64
            if signedValue < 0:
                destination.add('-')
                magnitude = uint64(-(signedValue + 1)) + 1'u64
            else:
                magnitude = signedValue.uint64
        else:
            magnitude = value.uint64

        if magnitude == 0:
            destination.add('0')
            return
        var digits: array[20, char]
        var count = 0
        while magnitude != 0:
            digits[count] = char(ord('0') + int(magnitude mod 10))
            magnitude = magnitude div 10
            inc count
        while count != 0:
            dec count
            destination.add(digits[count])

    # 整数は4桁テーブルを使うC/C++共通フォーマッタへまとめて渡す。
    proc fastioJoinImpl[T](a: openArray[T], sep: string): string =
        when nimvm:
            result = newStringOfCap(a.len * 4)
            for i, value in a:
                if i != 0:
                    result.add(sep)
                when T is SomeInteger:
                    fastioAppendInteger(result, value)
                else:
                    result.add($value)
        else:
            if a.len == 0:
                return ""
            when T is SomeInteger and sizeof(T) in [4, 8]:
                const digits = when sizeof(T) == 8: 20
                               elif T is SomeSignedInt: 11
                               else: 10
                result = fastioNewStringUninit(
                    a.len * digits + (a.len - 1) * sep.len)
                let written = fastioJoinInts(cast[ptr fastioOutputType(T)](unsafeAddr a[0]),
                    a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)
                result.setLen(written.int)
            elif compiles(T.umod()) and compiles(a[0].val()):
                # Montgomery表現を含め、公開値へ正規化してから一括変換する。
                var canonical = fastioNewSeqUninit(uint32, a.len)
                for i, value in a:
                    canonical[i] = value.val.uint32
                result = fastioJoinImpl(canonical, sep)
            else:
                result = newStringOfCap(a.len * 4)
                for i, value in a:
                    if i != 0:
                        result.add(sep)
                    when T is SomeInteger:
                        fastioAppendInteger(result, value)
                    else:
                        result.add($value)

    proc join*[T: not string](a: openArray[T], sep: string = ""): string {.inline.} =
        fastioJoinImpl(a, sep)

    proc fastioPrintArrayImpl[T](a: openArray[T], sep: string) =
        if a.len == 0:
            stdout.write('\n')
            return
        when T is SomeInteger and sizeof(T) in [4, 8]:
            fastioPrintInts(stdout, cast[ptr fastioOutputType(T)](unsafeAddr a[0]), a.len.csize_t,
                sep.cstring, sep.len.csize_t)
        elif compiles(T.umod()) and compiles(a[0].val()):
            var canonical = fastioNewSeqUninit(uint32, a.len)
            for i, value in a:
                canonical[i] = value.val.uint32
            fastioPrintArrayImpl(canonical, sep)
        else:
            stdout.write(fastioJoinImpl(a, sep))
            stdout.write('\n')

    proc fastioPrintOneImpl[T](value: T, sep: string) =
        when T is SomeInteger and sizeof(T) in [4, 8]:
            fastioPrintInt(stdout, fastioOutputType(T)(value))
        elif compiles(T.umod()) and compiles(value.val()):
            fastioPrintInt(stdout, value.val.uint32)
        else:
            fastioPrintWithSeparator(sep, value)

    proc fastioPrintIntegerMany[T: SomeInteger](sep: string,
            values: varargs[T]) =
        fastioPrintArrayImpl(values, sep)

    # Python風に print(*X) と書くと、Xを空白区切りで1行に出力する。
    template `*`*[T](values: openArray[T]): string =
        fastioJoinImpl(values, " ")

    proc fastioSeparatorString(sep: string | char): string {.inline.} =
        ## printの区切り文字を文字列に統一する。
        $sep

    # 最後の文字列引数をsepと誤認しないよう、名前付きsepはマクロで処理する。
    macro print*(args: varargs[untyped]): untyped =
        var sep = newLit(" ")
        var hasSep = false
        var values: seq[NimNode]
        for arg in args:
            if arg.kind == nnkExprEqExpr and arg[0].eqIdent("sep"):
                if hasSep:
                    error("sep can only be specified once", arg)
                sep = newCall(bindSym"fastioSeparatorString", arg[1])
                hasSep = true
            else:
                values.add(arg)
        var splatValues: NimNode
        if values.len == 1:
            if values[0].kind == nnkPrefix and values[0][0].eqIdent("*"):
                splatValues = values[0][1]
            elif values[0].kind in nnkCallKinds and values[0].len == 3 and
                    values[0][0].eqIdent("fastioJoinImpl"):
                # オーバーロード解決時に *values が先に展開された場合。
                splatValues = values[0][1]
        if not splatValues.isNil:
            result = newCall(bindSym"fastioPrintArrayImpl", splatValues, sep)
        elif values.len == 1:
            result = newCall(bindSym"fastioPrintOneImpl", values[0], sep)
        else:
            let integerCall = newCall(bindSym"fastioPrintIntegerMany", sep)
            let fallbackCall = newCall(bindSym"fastioPrintWithSeparator", sep)
            for value in values:
                integerCall.add(value)
                fallbackCall.add(value)
            result = quote do:
                when compiles(`integerCall`):
                    `integerCall`
                else:
                    `fallbackCall`
