when not declared CPLIB_TMPL_FASTIO:
    const CPLIB_TMPL_FASTIO* = 1
    {.passC: "-mavx2".}
    # mmapは明示指定時のみ使用する。旧来の無効化指定も優先して尊重する。
    when not defined(fastioMmap) or defined(fastioNoMmap):
        {.passC: "-DCPLIB_FASTIO_NO_MMAP".}
    import macros

    # 入力系
    {.emit: """
#include <cstdio>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <immintrin.h>
#include <string>
#include <sys/mman.h>
#include <sys/stat.h>

namespace cplib_fastio_input {
constexpr std::size_t buffer_size = 1U << 20;
constexpr std::size_t safe_integer_bytes = 32;

struct InputState {
  alignas(64) char buffer[buffer_size];
  std::size_t cursor;
  std::size_t length;
  const char* mapped;
  bool initialized;
};

inline InputState& input_state() {
  static InputState state = {};
  return state;
}

inline std::string& token_storage() {
  static std::string storage;
  return storage;
}

#if defined(__GNUC__) || defined(__clang__)
#define CPLIB_FASTIO_ALWAYS_INLINE inline __attribute__((always_inline))
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE \
    static inline __attribute__((always_inline))
#define CPLIB_FASTIO_UNLIKELY(condition) (__builtin_expect(!!(condition), 0))
#elif defined(_MSC_VER)
#define CPLIB_FASTIO_ALWAYS_INLINE __forceinline
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE static __forceinline
#define CPLIB_FASTIO_UNLIKELY(condition) (condition)
#else
#define CPLIB_FASTIO_ALWAYS_INLINE inline
#define CPLIB_FASTIO_NIM_ALWAYS_INLINE static inline
#define CPLIB_FASTIO_UNLIKELY(condition) (condition)
#endif

inline void initialize(InputState& state) {
  if (state.initialized) return;
  state.initialized = true;

#ifndef CPLIB_FASTIO_NO_MMAP
  struct stat st;
  const int fd = fileno(stdin);
  if (fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0) {
    void* p = mmap(nullptr, static_cast<std::size_t>(st.st_size),
                   PROT_READ, MAP_PRIVATE, fd, 0);
    if (p != MAP_FAILED) {
      state.mapped = static_cast<const char*>(p);
      state.length = static_cast<std::size_t>(st.st_size);
      madvise(const_cast<char*>(state.mapped), state.length,
              MADV_SEQUENTIAL);
    }
  }
#endif
}

inline bool refill(InputState& state) {
  state.length =
      fread_unlocked(state.buffer, 1, buffer_size, stdin);
  state.cursor = 0;
  return state.length != 0;
}

inline int get_char() {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    if (state.cursor == state.length) return -1;
    return static_cast<unsigned char>(state.mapped[state.cursor++]);
  }
  if (state.cursor == state.length && !refill(state)) return -1;
  return static_cast<unsigned char>(state.buffer[state.cursor++]);
}

inline bool has_eight_digits(const char* source) {
  // 正しい整数入力では、数字・符号・空白を上位4bitだけで判別できる。
  std::uint64_t bytes;
  std::memcpy(&bytes, source, sizeof(bytes));
  return ((bytes ^ 0x3030303030303030ULL) &
          0xf0f0f0f0f0f0f0f0ULL) == 0;
}

inline unsigned parse_eight_digits(const char* source) {
  std::uint64_t digits;
  std::memcpy(&digits, source, sizeof(digits));
  digits ^= 0x3030303030303030ULL;
  digits = (digits * ((10ULL << 8) + 1) >> 8) &
      0x00ff00ff00ff00ffULL;
  digits = (digits * ((100ULL << 16) + 1) >> 16) &
      0x0000ffff0000ffffULL;
  return static_cast<unsigned>(
      digits * ((10000ULL << 32) + 1) >> 32);
}

inline unsigned digit_at(const char* source) {
  return static_cast<unsigned>(static_cast<unsigned char>(*source)) -
         static_cast<unsigned>('0');
}

template <bool negative>
CPLIB_FASTIO_ALWAYS_INLINE bool try_parse_digits_unchecked(
        const char*& source, long long& output) {
  long long value = 0;
  if (has_eight_digits(source)) {
    const long long digits =
        static_cast<long long>(parse_eight_digits(source));
    value = negative ? value * 100000000LL - digits
                     : value * 100000000LL + digits;
    source += 8;
    if (has_eight_digits(source)) {
      const long long next_digits =
          static_cast<long long>(parse_eight_digits(source));
      value = negative ? value * 100000000LL - next_digits
                       : value * 100000000LL + next_digits;
      source += 8;
      for (int pair = 0; pair < 2; ++pair) {
        const unsigned first = digit_at(source);
        if (first >= 10U) {
          output = value;
          return true;
        }
        const unsigned second = digit_at(source + 1);
        if (second >= 10U) {
          ++source;
          output = negative
              ? value * 10 - static_cast<long long>(first)
              : value * 10 + static_cast<long long>(first);
          return true;
        }
        value = negative
            ? value * 100 - static_cast<long long>(first * 10U + second)
            : value * 100 + static_cast<long long>(first * 10U + second);
        source += 2;
      }
      if (digit_at(source) < 10U) return false;
      output = value;
      return true;
    }
  }
  for (;;) {
    const unsigned first = digit_at(source);
    if (first >= 10U) {
      output = value;
      return true;
    }
    const unsigned second = digit_at(source + 1);
    if (second >= 10U) {
      ++source;
      output = negative ? value * 10 - static_cast<long long>(first)
                        : value * 10 + static_cast<long long>(first);
      return true;
    }
    value = negative
        ? value * 100 - static_cast<long long>(first * 10U + second)
        : value * 100 + static_cast<long long>(first * 10U + second);
    source += 2;
  }
}

template <bool negative>
inline long long parse_digits_bounded(const char*& source,
                                      const char* end) {
  long long value = 0;
  while (end - source >= 8 && has_eight_digits(source)) {
    const long long digits =
        static_cast<long long>(parse_eight_digits(source));
    value = negative ? value * 100000000LL - digits
                     : value * 100000000LL + digits;
    source += 8;
  }
  while (end - source >= 2) {
    const unsigned first = digit_at(source);
    const unsigned second = digit_at(source + 1);
    if (first >= 10U) return value;
    if (second >= 10U) {
      ++source;
      return negative ? value * 10 - static_cast<long long>(first)
                      : value * 10 + static_cast<long long>(first);
    }
    value = negative
        ? value * 100 - static_cast<long long>(first * 10U + second)
        : value * 100 + static_cast<long long>(first * 10U + second);
    source += 2;
  }
  if (source != end) {
    const unsigned digit = digit_at(source);
    if (digit < 10U) {
      value = negative ? value * 10 - static_cast<long long>(digit)
                       : value * 10 + static_cast<long long>(digit);
      ++source;
    }
  }
  return value;
}

CPLIB_FASTIO_ALWAYS_INLINE bool try_parse_unsigned_digits_unchecked(
        const char*& source, unsigned long long& output) {
  unsigned long long value = 0;
  if (has_eight_digits(source)) {
    value = static_cast<unsigned long long>(parse_eight_digits(source));
    source += 8;
    if (has_eight_digits(source)) {
      value = value * 100000000ULL +
              static_cast<unsigned long long>(parse_eight_digits(source));
      source += 8;
      for (int pair = 0; pair < 2; ++pair) {
        const unsigned first = digit_at(source);
        if (first >= 10U) {
          output = value;
          return true;
        }
        const unsigned second = digit_at(source + 1);
        if (second >= 10U) {
          ++source;
          output = value * 10ULL + first;
          return true;
        }
        value = value * 100ULL + first * 10U + second;
        source += 2;
      }
      if (digit_at(source) < 10U) return false;
      output = value;
      return true;
    }
  }
  for (;;) {
    const unsigned first = digit_at(source);
    if (first >= 10U) {
      output = value;
      return true;
    }
    const unsigned second = digit_at(source + 1);
    if (second >= 10U) {
      ++source;
      output = value * 10ULL + first;
      return true;
    }
    value = value * 100ULL + first * 10U + second;
    source += 2;
  }
}

inline unsigned long long parse_unsigned_digits_bounded(
        const char*& source, const char* end) {
  unsigned long long value = 0;
  while (end - source >= 8 && has_eight_digits(source)) {
    value = value * 100000000ULL +
            static_cast<unsigned long long>(parse_eight_digits(source));
    source += 8;
  }
  while (end - source >= 2) {
    const unsigned first = digit_at(source);
    const unsigned second = digit_at(source + 1);
    if (first >= 10U) return value;
    if (second >= 10U) {
      ++source;
      return value * 10ULL + first;
    }
    value = value * 100ULL + first * 10U + second;
    source += 2;
  }
  if (source != end) {
    const unsigned digit = digit_at(source);
    if (digit < 10U) {
      value = value * 10ULL + digit;
      ++source;
    }
  }
  return value;
}

CPLIB_FASTIO_ALWAYS_INLINE long long read_mapped_at(
        const char*& source, const char* end) {
  while (source != end &&
         static_cast<unsigned char>(*source) <=
             static_cast<unsigned char>(' ')) {
    ++source;
  }
  if (source == end) return 0;
  const bool negative = *source == '-';
  if (negative || *source == '+') ++source;
  if (end - source >= static_cast<std::ptrdiff_t>(safe_integer_bytes)) {
    const char* parsed = source;
    long long value;
    const bool complete = negative
        ? try_parse_digits_unchecked<true>(parsed, value)
        : try_parse_digits_unchecked<false>(parsed, value);
    if (complete) {
      source = parsed;
      return value;
    }
  }
  return negative ? parse_digits_bounded<true>(source, end)
                  : parse_digits_bounded<false>(source, end);
}

CPLIB_FASTIO_ALWAYS_INLINE unsigned long long read_uint_mapped_at(
        const char*& source, const char* end) {
  while (source != end &&
         static_cast<unsigned char>(*source) <=
             static_cast<unsigned char>(' ')) {
    ++source;
  }
  if (source == end) return 0;
  const bool negative = *source == '-';
  if (negative || *source == '+') ++source;
  if (end - source >= static_cast<std::ptrdiff_t>(safe_integer_bytes)) {
    const char* parsed = source;
    unsigned long long value;
    if (try_parse_unsigned_digits_unchecked(parsed, value)) {
      source = parsed;
      return negative ? 0ULL - value : value;
    }
  }
  const unsigned long long value =
      parse_unsigned_digits_bounded(source, end);
  return negative ? 0ULL - value : value;
}

inline long long read_int_stream_slow(InputState& state) {
  bool negative = state.buffer[state.cursor] == '-';
  if (negative || state.buffer[state.cursor] == '+') {
    ++state.cursor;
    if (state.cursor == state.length && !refill(state)) return 0;
  }
  long long value = 0;
  for (;;) {
    while (state.cursor != state.length) {
      const unsigned digit = digit_at(state.buffer + state.cursor);
      if (digit >= 10U) return value;
      value = negative ? value * 10 - static_cast<long long>(digit)
                       : value * 10 + static_cast<long long>(digit);
      ++state.cursor;
    }
    if (!refill(state)) return value;
  }
}

inline unsigned long long read_uint_stream_slow(InputState& state) {
  const bool negative = state.buffer[state.cursor] == '-';
  if (negative || state.buffer[state.cursor] == '+') {
    ++state.cursor;
    if (state.cursor == state.length && !refill(state)) return 0;
  }
  unsigned long long value = 0;
  for (;;) {
    while (state.cursor != state.length) {
      const unsigned digit = digit_at(state.buffer + state.cursor);
      if (digit >= 10U) return negative ? 0ULL - value : value;
      value = value * 10ULL + digit;
      ++state.cursor;
    }
    if (!refill(state)) return negative ? 0ULL - value : value;
  }
}

CPLIB_FASTIO_ALWAYS_INLINE long long read_int_stream(InputState& state) {
  for (;;) {
    if (state.cursor == state.length && !refill(state)) return 0;
    while (state.cursor != state.length &&
           static_cast<unsigned char>(state.buffer[state.cursor]) <=
               static_cast<unsigned char>(' ')) {
      ++state.cursor;
    }
    if (state.cursor != state.length) break;
  }
  if (state.length - state.cursor < safe_integer_bytes) {
    return read_int_stream_slow(state);
  }
  const char* source = state.buffer + state.cursor;
  const bool negative = *source == '-';
  if (negative || *source == '+') ++source;
  long long value;
  const bool complete = negative
      ? try_parse_digits_unchecked<true>(source, value)
      : try_parse_digits_unchecked<false>(source, value);
  if (!complete) return read_int_stream_slow(state);
  state.cursor = static_cast<std::size_t>(source - state.buffer);
  return value;
}

CPLIB_FASTIO_ALWAYS_INLINE unsigned long long read_uint_stream(
        InputState& state) {
  for (;;) {
    if (state.cursor == state.length && !refill(state)) return 0;
    while (state.cursor != state.length &&
           static_cast<unsigned char>(state.buffer[state.cursor]) <=
               static_cast<unsigned char>(' ')) {
      ++state.cursor;
    }
    if (state.cursor != state.length) break;
  }
  if (state.length - state.cursor < safe_integer_bytes) {
    return read_uint_stream_slow(state);
  }
  const char* source = state.buffer + state.cursor;
  const bool negative = *source == '-';
  if (negative || *source == '+') ++source;
  unsigned long long value;
  if (!try_parse_unsigned_digits_unchecked(source, value)) {
    return read_uint_stream_slow(state);
  }
  state.cursor = static_cast<std::size_t>(source - state.buffer);
  return negative ? 0ULL - value : value;
}

CPLIB_FASTIO_ALWAYS_INLINE long long read_int() {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped == nullptr) return read_int_stream(state);
  const char* source = state.mapped + state.cursor;
  const long long value =
      read_mapped_at(source, state.mapped + state.length);
  state.cursor = static_cast<std::size_t>(source - state.mapped);
  return value;
}

CPLIB_FASTIO_ALWAYS_INLINE unsigned long long read_uint() {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped == nullptr) return read_uint_stream(state);
  const char* source = state.mapped + state.cursor;
  const unsigned long long value =
      read_uint_mapped_at(source, state.mapped + state.length);
  state.cursor = static_cast<std::size_t>(source - state.mapped);
  return value;
}

template <class T>
inline void read_int_array(T* output, std::size_t count) {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    const char* source = state.mapped + state.cursor;
    const char* const end = state.mapped + state.length;
    for (std::size_t i = 0; i < count; ++i) {
      output[i] = static_cast<T>(read_mapped_at(source, end));
    }
    state.cursor = static_cast<std::size_t>(source - state.mapped);
  } else {
    for (std::size_t i = 0; i < count; ++i) {
      output[i] = static_cast<T>(read_int_stream(state));
    }
  }
}

inline bool fastio_is_space(char value) {
  return static_cast<unsigned char>(value) <=
         static_cast<unsigned char>(' ');
}

inline void skip_spaces(const char*& source, const char* end) {
  while (source != end && fastio_is_space(*source)) ++source;
}

inline void consume_separator(const char*& source, const char* end) {
  if (source != end) {
    ++source;
    skip_spaces(source, end);
  }
}

inline unsigned parse_eight_digits_simd(const char* source) {
  const __m128i bytes = _mm_loadl_epi64(
      reinterpret_cast<const __m128i*>(source));
  const __m128i digits = _mm_sub_epi8(bytes, _mm_set1_epi8('0'));
  const __m128i pairs = _mm_maddubs_epi16(
      digits, _mm_setr_epi8(10, 1, 10, 1, 10, 1, 10, 1,
                            0, 0, 0, 0, 0, 0, 0, 0));
  const __m128i quads = _mm_madd_epi16(
      pairs, _mm_setr_epi16(100, 1, 100, 1, 0, 0, 0, 0));
  return static_cast<unsigned>(_mm_cvtsi128_si32(quads)) * 10000U +
      static_cast<unsigned>(_mm_cvtsi128_si32(_mm_srli_si128(quads, 4)));
}

// 呼び出し元で空白を除去済み。長い先頭ゼロと末尾は境界付き処理へ戻す。
inline std::uint32_t read_u32_digits(const char*& source, const char* end) {
  if (source == end) return 0;
  const bool negative = *source == '-';
  if (negative || *source == '+') ++source;
  unsigned long long value = 0;
  if (end - source >= 16) {
    if (has_eight_digits(source)) {
      value = parse_eight_digits_simd(source);
      const unsigned ninth = digit_at(source + 8);
      const unsigned tenth = digit_at(source + 9);
      if (ninth >= 10U) {
        source += 8;
      } else if (tenth >= 10U) {
        value = value * 10ULL + ninth;
        source += 9;
      } else if (digit_at(source + 10) >= 10U) {
        value = value * 100ULL + ninth * 10U + tenth;
        source += 10;
      } else {
        value = parse_unsigned_digits_bounded(source, end);
      }
    } else {
      for (;;) {
        const unsigned first = digit_at(source);
        if (first >= 10U) break;
        const unsigned second = digit_at(source + 1);
        if (second >= 10U) {
          value = value * 10ULL + first;
          ++source;
          break;
        }
        value = value * 100ULL + first * 10U + second;
        source += 2;
      }
    }
  } else {
    value = parse_unsigned_digits_bounded(source, end);
  }
  return static_cast<std::uint32_t>(negative ? 0ULL - value : value);
}

CPLIB_FASTIO_ALWAYS_INLINE std::uint32_t read_u32() {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    const char* source = state.mapped + state.cursor;
    const char* const end = state.mapped + state.length;
    skip_spaces(source, end);
    const std::uint32_t value = read_u32_digits(source, end);
    consume_separator(source, end);
    state.cursor = static_cast<std::size_t>(source - state.mapped);
    return value;
  }
  const char* source = state.buffer + state.cursor;
  const char* const end = state.buffer + state.length;
  skip_spaces(source, end);
  if (CPLIB_FASTIO_UNLIKELY(end - source <
                           static_cast<std::ptrdiff_t>(safe_integer_bytes))) {
    return static_cast<std::uint32_t>(read_uint_stream(state));
  }
  const std::uint32_t value = read_u32_digits(source, end);
  // 長い先頭ゼロがrefill境界をまたぐ場合は、元の位置から読み直す。
  if (CPLIB_FASTIO_UNLIKELY(source == end)) {
    return static_cast<std::uint32_t>(read_uint_stream(state));
  }
  consume_separator(source, end);
  state.cursor = static_cast<std::size_t>(source - state.buffer);
  return value;
}

inline bool try_read_four_nine_digit_u32(
        const char*& source, const char* end, std::uint32_t* output) {
  if (end - source < 40) return false;
  if (!fastio_is_space(source[9]) || !fastio_is_space(source[19]) ||
      !fastio_is_space(source[29]) || !fastio_is_space(source[39])) {
    return false;
  }
  const __m128i first_two = _mm_unpacklo_epi64(
      _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source)),
      _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source + 10)));
  const __m128i last_two = _mm_unpacklo_epi64(
      _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source + 20)),
      _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source + 30)));
  const __m256i bytes = _mm256_set_m128i(last_two, first_two);
  const __m256i is_digit = _mm256_and_si256(
      _mm256_cmpgt_epi8(bytes, _mm256_set1_epi8('/')),
      _mm256_cmpgt_epi8(_mm256_set1_epi8(':'), bytes));
  if (static_cast<unsigned>(_mm256_movemask_epi8(is_digit)) !=
      0xffffffffU) {
    return false;
  }

  const unsigned digit0 = digit_at(source + 8);
  const unsigned digit1 = digit_at(source + 18);
  const unsigned digit2 = digit_at(source + 28);
  const unsigned digit3 = digit_at(source + 38);
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
      _mm_setr_epi32(static_cast<int>(digit0),
                     static_cast<int>(digit1),
                     static_cast<int>(digit2),
                     static_cast<int>(digit3)));
  _mm_storeu_si128(reinterpret_cast<__m128i*>(output), values);
  source += 40;
  return true;
}

inline void read_uint_array(std::uint32_t* output, std::size_t count) {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    const char* source = state.mapped + state.cursor;
    const char* const end = state.mapped + state.length;
    skip_spaces(source, end);
    std::size_t i = 0;
    unsigned nine_digit_count = 0;
    // 最初の16要素を読みながら分布を確認し、短い整数ではAVX判定を省く。
    if (count >= 64) {
      for (; i < 16; ++i) {
        nine_digit_count += end - source >= 10 &&
            fastio_is_space(source[9]) && has_eight_digits(source) &&
            digit_at(source + 8) < 10U;
        output[i] = read_u32_digits(source, end);
        consume_separator(source, end);
      }
    }
    if (nine_digit_count >= 12) {
      while (i < count) {
        if (count - i >= 4 && try_read_four_nine_digit_u32(
                source, end, output + i)) {
          i += 4;
          skip_spaces(source, end);
        } else {
          output[i++] = read_u32_digits(source, end);
          if (i != count) consume_separator(source, end);
        }
      }
    } else {
      while (i < count) {
        output[i++] = read_u32_digits(source, end);
        if (i != count) consume_separator(source, end);
      }
    }
    state.cursor = static_cast<std::size_t>(source - state.mapped);
  } else {
    std::size_t i = 0;
    unsigned nine_digit_count = 0;
    if (count >= 64) {
      for (; i < 16; ++i) {
        output[i] = static_cast<std::uint32_t>(read_uint_stream(state));
        nine_digit_count += output[i] >= 100000000U &&
                            output[i] < 1000000000U;
      }
    }
    if (nine_digit_count >= 12) {
      while (count - i >= 4) {
        const char* source = state.buffer + state.cursor;
        const char* const end = state.buffer + state.length;
        skip_spaces(source, end);
        if (try_read_four_nine_digit_u32(source, end, output + i)) {
          state.cursor = static_cast<std::size_t>(source - state.buffer);
          i += 4;
        } else {
          state.cursor = static_cast<std::size_t>(source - state.buffer);
          // refillをまたぐ整数は既存のストリーム処理で最後まで読む。
          output[i++] = static_cast<std::uint32_t>(read_uint_stream(state));
        }
      }
    }
    for (; i < count; ++i) {
      output[i] = static_cast<std::uint32_t>(read_uint_stream(state));
    }
  }
}

template <class T>
inline void read_uint_array(T* output, std::size_t count) {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    const char* source = state.mapped + state.cursor;
    const char* const end = state.mapped + state.length;
    for (std::size_t i = 0; i < count; ++i) {
      output[i] = static_cast<T>(read_uint_mapped_at(source, end));
    }
    state.cursor = static_cast<std::size_t>(source - state.mapped);
  } else {
    for (std::size_t i = 0; i < count; ++i) {
      output[i] = static_cast<T>(read_uint_stream(state));
    }
  }
}

inline const char* read_token(std::size_t* output_length) {
  InputState& state = input_state();
  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);
  if (state.mapped != nullptr) {
    const char* source = state.mapped + state.cursor;
    const char* const end = state.mapped + state.length;
    while (source != end &&
           static_cast<unsigned char>(*source) <=
               static_cast<unsigned char>(' ')) {
      ++source;
    }
    const char* const token = source;
    while (source != end &&
           static_cast<unsigned char>(*source) >
               static_cast<unsigned char>(' ')) {
      ++source;
    }
    state.cursor = static_cast<std::size_t>(source - state.mapped);
    *output_length = static_cast<std::size_t>(source - token);
    return token;
  }

  for (;;) {
    if (state.cursor == state.length && !refill(state)) {
      *output_length = 0;
      return "";
    }
    while (state.cursor != state.length &&
           static_cast<unsigned char>(state.buffer[state.cursor]) <=
               static_cast<unsigned char>(' ')) {
      ++state.cursor;
    }
    if (state.cursor != state.length) break;
  }

  const std::size_t token_begin = state.cursor;
  while (state.cursor != state.length &&
         static_cast<unsigned char>(state.buffer[state.cursor]) >
             static_cast<unsigned char>(' ')) {
    ++state.cursor;
  }
  if (state.cursor != state.length) {
    *output_length = state.cursor - token_begin;
    return state.buffer + token_begin;
  }

  std::string& storage = token_storage();
  storage.assign(state.buffer + token_begin,
                 state.length - token_begin);
  while (refill(state)) {
    while (state.cursor != state.length &&
           static_cast<unsigned char>(state.buffer[state.cursor]) >
               static_cast<unsigned char>(' ')) {
      ++state.cursor;
    }
    storage.append(state.buffer, state.cursor);
    if (state.cursor != state.length) break;
  }
  *output_length = storage.size();
  return storage.c_str();
}

#undef CPLIB_FASTIO_UNLIKELY
#undef CPLIB_FASTIO_ALWAYS_INLINE
} // namespace cplib_fastio_input
""".}

    proc fastioGetChar(): cint {.importcpp: "cplib_fastio_input::get_char()", nodecl, inline.}
    proc fastioReadInt(): clonglong {.importcpp: "cplib_fastio_input::read_int()", nodecl, inline.}
    proc fastioReadUInt(): culonglong {.importcpp: "cplib_fastio_input::read_uint()", nodecl, inline.}
    proc fastioReadUInt32(): uint32 {.importcpp: "cplib_fastio_input::read_u32()", nodecl, inline.}
    proc fastioReadSignedArray[T: SomeSignedInt](values: ptr T, count: csize_t) {.importcpp: "cplib_fastio_input::read_int_array(@)", nodecl, inline.}
    proc fastioReadUnsignedArray[T: SomeUnsignedInt](values: ptr T, count: csize_t) {.importcpp: "cplib_fastio_input::read_uint_array(@)", nodecl, inline.}
    proc fastioReadToken(length: ptr csize_t): cstring
        {.importcpp: "cplib_fastio_input::read_token(@)", nodecl, inline.}

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
            fastioReadSignedArray(addr result[0], N.csize_t)

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
                when T is SomeSignedInt:
                    fastioReadSignedArray(addr result[0], N.csize_t)
                else:
                    fastioReadUnsignedArray(addr result[0], N.csize_t)

    proc si(): string {.inline.} =
        var length: csize_t
        let source = fastioReadToken(addr length)
        result = fastioNewStringUninit(length.int)
        if length != 0:
            copyMem(addr result[0], source, length.int)

    proc input(valueType: typedesc[string]): string {.inline.} =
        si()

    proc input(N: int, valueType: typedesc[string]): seq[string] {.inline.} =
        result = newSeq[string](N)
        for i in 0 ..< N:
            result[i] = input(string)

    # 出力系
    {.emit: """
#include <cstdio>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <type_traits>

namespace cplib_fastio_output {
struct StdoutBuffer {
  static constexpr std::size_t capacity = 1U << 16;
  alignas(64) char data[capacity];

  StdoutBuffer() { setvbuf(stdout, data, _IOFBF, capacity); }
};

static StdoutBuffer stdout_buffer;

struct FourDigits {
  char data[10000][4];
  constexpr FourDigits() : data{} {
    for (unsigned i = 0; i < 10000; ++i) {
      data[i][0] = static_cast<char>('0' + i / 1000);
      data[i][1] = static_cast<char>('0' + i / 100 % 10);
      data[i][2] = static_cast<char>('0' + i / 10 % 10);
      data[i][3] = static_cast<char>('0' + i % 10);
    }
  }
};

constexpr FourDigits four_digit_table{};

inline const FourDigits& four_digits() {
  return four_digit_table;
}

inline char* reserve_bytes(std::FILE* output, std::size_t size) {
#if defined(__GLIBC__)
  // stdio自身のバッファを使い、echo/write/flushFileとの出力順を保つ。
  if (output->_IO_write_ptr != nullptr &&
      output->_IO_write_end != nullptr &&
      static_cast<std::size_t>(output->_IO_write_end -
                               output->_IO_write_ptr) >= size) {
    return output->_IO_write_ptr;
  }
#endif
  return nullptr;
}

inline void commit_bytes(std::FILE* output, char* end) {
#if defined(__GLIBC__)
  output->_IO_write_ptr = end;
#else
  (void)output;
  (void)end;
#endif
}

inline char* write_small(char* output, unsigned value,
                         const FourDigits& table) {
  if (value >= 1000) {
    std::memcpy(output, table.data[value], 4);
    return output + 4;
  }
  if (value >= 100) {
    std::memcpy(output, table.data[value] + 1, 3);
    return output + 3;
  }
  if (value >= 10) {
    std::memcpy(output, table.data[value] + 2, 2);
    return output + 2;
  }
  *output++ = static_cast<char>('0' + value);
  return output;
}

inline char* write_four(char* output, unsigned value,
                        const FourDigits& table) {
  std::memcpy(output, table.data[value], 4);
  return output + 4;
}

inline char* write_unsigned_32(char* output, std::uint32_t value,
                               const FourDigits& table) {
  if (value < 10000U) return write_small(output, value, table);
  const std::uint32_t quotient = value / 10000U;
  const unsigned low = static_cast<unsigned>(value - quotient * 10000U);
  if (quotient < 10000U) {
    output = write_small(output, quotient, table);
    return write_four(output, low, table);
  }
  const unsigned high = quotient / 10000U;
  const unsigned middle = quotient - high * 10000U;
  output = write_small(output, high, table);
  output = write_four(output, middle, table);
  return write_four(output, low, table);
}

inline char* write_unsigned_64(char* output, std::uint64_t value,
                               const FourDigits& table) {
  if (value < 10000ULL) {
    return write_small(output, static_cast<unsigned>(value), table);
  }
  const std::uint64_t quotient1 = value / 10000ULL;
  const unsigned chunk1 = static_cast<unsigned>(value - quotient1 * 10000ULL);
  if (quotient1 < 10000ULL) {
    output = write_small(output, static_cast<unsigned>(quotient1), table);
    return write_four(output, chunk1, table);
  }
  const std::uint64_t quotient2 = quotient1 / 10000ULL;
  const unsigned chunk2 = static_cast<unsigned>(quotient1 - quotient2 * 10000ULL);
  if (quotient2 < 10000ULL) {
    output = write_small(output, static_cast<unsigned>(quotient2), table);
    output = write_four(output, chunk2, table);
    return write_four(output, chunk1, table);
  }
  const std::uint64_t quotient3 = quotient2 / 10000ULL;
  const unsigned chunk3 = static_cast<unsigned>(quotient2 - quotient3 * 10000ULL);
  if (quotient3 < 10000ULL) {
    output = write_small(output, static_cast<unsigned>(quotient3), table);
    output = write_four(output, chunk3, table);
    output = write_four(output, chunk2, table);
    return write_four(output, chunk1, table);
  }
  const std::uint64_t quotient4 = quotient3 / 10000ULL;
  const unsigned chunk4 = static_cast<unsigned>(quotient3 - quotient4 * 10000ULL);
  output = write_small(output, static_cast<unsigned>(quotient4), table);
  output = write_four(output, chunk4, table);
  output = write_four(output, chunk3, table);
  output = write_four(output, chunk2, table);
  return write_four(output, chunk1, table);
}

template <class Unsigned>
inline char* write_unsigned_dispatch(char* output, Unsigned value,
                                     const FourDigits& table,
                                     std::true_type) {
  return write_unsigned_32(output, static_cast<std::uint32_t>(value), table);
}

template <class Unsigned>
inline char* write_unsigned_dispatch(char* output, Unsigned value,
                                     const FourDigits& table,
                                     std::false_type) {
  return write_unsigned_64(output, static_cast<std::uint64_t>(value), table);
}

template <class Unsigned>
inline char* write_unsigned(char* output, Unsigned value,
                            const FourDigits& table) {
  return write_unsigned_dispatch(output, value, table,
      std::integral_constant<bool, (sizeof(Unsigned) <= 4)>{});
}

template <class Integer>
inline std::size_t join_integers(
        const Integer* values, std::size_t count, char* output,
        const char* separator, std::size_t separator_length) {
  const FourDigits& table = four_digits();
  char* cursor = output;
  using Unsigned = typename std::make_unsigned<Integer>::type;
  for (std::size_t i = 0; i < count; ++i) {
    const Integer value = values[i];
    Unsigned magnitude = static_cast<Unsigned>(value);
    if (std::is_signed<Integer>::value && value < 0) {
      *cursor++ = '-';
      magnitude = Unsigned(0) - magnitude;
    }
    cursor = write_unsigned(cursor, magnitude, table);
    if (i + 1 != count) {
      std::memcpy(cursor, separator, separator_length);
      cursor += separator_length;
    }
  }
  return static_cast<std::size_t>(cursor - output);
}

class BufferedWriter {
 public:
  static constexpr std::size_t capacity = 1U << 16;

  explicit BufferedWriter(std::FILE* output)
      : length_(0), output_(output) {}

  inline char* reserve_integer() {
    constexpr std::size_t max_integer_length = 21;
    if (capacity - length_ < max_integer_length) flush();
    return data_ + length_;
  }

  inline void commit(char* end) {
    length_ = static_cast<std::size_t>(end - data_);
  }

  inline void append(const char* source, std::size_t size) {
    if (size <= capacity - length_) {
      std::memcpy(data_ + length_, source, size);
      length_ += size;
      return;
    }
    flush();
    if (size >= capacity) {
      fwrite_unlocked(source, 1, size, output_);
    } else {
      std::memcpy(data_, source, size);
      length_ = size;
    }
  }

  inline void flush() {
    if (length_ != 0) {
      fwrite_unlocked(data_, 1, length_, output_);
      length_ = 0;
    }
  }

 private:
  char data_[capacity];
  std::size_t length_;
  std::FILE* output_;
};

template <class Integer>
inline void print_integers(std::FILE* output, const Integer* values,
                         std::size_t count,
                         const char* separator,
                         std::size_t separator_length) {
  const FourDigits& table = four_digits();
  BufferedWriter writer(output);
  using Unsigned = typename std::make_unsigned<Integer>::type;
  for (std::size_t i = 0; i < count; ++i) {
    char* cursor = writer.reserve_integer();
    const Integer value = values[i];
    Unsigned magnitude = static_cast<Unsigned>(value);
    if (std::is_signed<Integer>::value && value < 0) {
      *cursor++ = '-';
      magnitude = Unsigned(0) - magnitude;
    }
    cursor = write_unsigned(cursor, magnitude, table);
    writer.commit(cursor);
    if (i + 1 != count) writer.append(separator, separator_length);
  }
  writer.append("\n", 1);
  writer.flush();
}

template <class Integer>
inline void print_one(std::FILE* output, Integer value) {
  const FourDigits& table = four_digits();
  char buffer[22];
  char* const reserved = reserve_bytes(output, sizeof(buffer));
  char* const begin = reserved == nullptr ? buffer : reserved;
  char* cursor = begin;
  using Unsigned = typename std::make_unsigned<Integer>::type;
  Unsigned magnitude = static_cast<Unsigned>(value);
  if (std::is_signed<Integer>::value && value < 0) {
    *cursor++ = '-';
    magnitude = Unsigned(0) - magnitude;
  }
  cursor = write_unsigned(cursor, magnitude, table);
  *cursor++ = '\n';
  if (reserved != nullptr) {
    commit_bytes(output, cursor);
  } else {
    fwrite_unlocked(buffer, 1,
                    static_cast<std::size_t>(cursor - buffer), output);
  }
}

} // namespace cplib_fastio_output
""".}

    proc fastioJoinInts[T: SomeInteger](values: ptr T, count: csize_t,
            output: ptr char, separator: cstring, separatorLen: csize_t): csize_t
        {.importcpp: "cplib_fastio_output::join_integers(@)", nodecl.}
    proc fastioPrintInts[T: SomeInteger](output: File, values: ptr T,
            count: csize_t, separator: cstring, separatorLen: csize_t)
        {.importcpp: "cplib_fastio_output::print_integers(@)", nodecl.}
    proc fastioPrintInt[T: SomeInteger](output: File, value: T)
        {.importcpp: "cplib_fastio_output::print_one(@)", nodecl.}

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

    # 整数は4桁テーブルを使うC++フォーマッタへまとめて渡す。
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
                let written = fastioJoinInts(unsafeAddr a[0],
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
            fastioPrintInts(stdout, unsafeAddr a[0], a.len.csize_t,
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
            fastioPrintInt(stdout, value)
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

    # 最後の文字列引数をsepと誤認しないよう、名前付きsepはマクロで処理する。
    macro print*(args: varargs[untyped]): untyped =
        var sep = newLit(" ")
        var hasSep = false
        var values: seq[NimNode]
        for arg in args:
            if arg.kind == nnkExprEqExpr and arg[0].eqIdent("sep"):
                if hasSep:
                    error("sep can only be specified once", arg)
                sep = arg[1]
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
