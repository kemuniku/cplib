## 動的版と固定長版で共有するAVX2/AVX-512カーネルです。実行時に命令を選択します。
{.emit: """
#ifndef CPLIB_BITSET_AVX512_IMPL
#define CPLIB_BITSET_AVX512_IMPL
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
#define CPLIB_BS_AVX2 __attribute__((target("avx2")))

#define CPLIB_BS_BINARY(name, scalar, vector) \
CPLIB_BS_AVX2 static void name(uint64_t *dst, const uint64_t *x, \
                           const uint64_t *y, size_t n) { \
/* 256ビットずつ論理演算し、残りを64ビットずつ処理します。 */ \
size_t i = 0; \
for (; i + 4 <= n; i += 4) { \
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i)); \
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \
    _mm256_storeu_si256((__m256i *)(dst + i), vector(a, b)); \
} \
for (; i < n; ++i) dst[i] = x[i] scalar y[i]; \
}
CPLIB_BS_BINARY(cplib_bs512_and_avx2, &, _mm256_and_si256)
CPLIB_BS_BINARY(cplib_bs512_or_avx2, |, _mm256_or_si256)
CPLIB_BS_BINARY(cplib_bs512_xor_avx2, ^, _mm256_xor_si256)
#undef CPLIB_BS_BINARY

CPLIB_BS_AVX2 static void cplib_bs512_andnot_avx2(uint64_t *dst, const uint64_t *x,
                                       const uint64_t *y, size_t n) {
/* 256ビットずつ差集合を求め、残りを64ビットずつ処理します。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_andnot_si256(b, a));
}
for (; i < n; ++i) dst[i] = x[i] & ~y[i];
}

CPLIB_BS_AVX2 static void cplib_bs512_not_avx2(uint64_t *dst, const uint64_t *x, size_t n) {
/* 256ビットずつ反転します。 */
const __m256i ones = _mm256_set1_epi64x(-1);
size_t i = 0;
for (; i + 4 <= n; i += 4)
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(
        _mm256_loadu_si256((const __m256i *)(x + i)), ones));
for (; i < n; ++i) dst[i] = ~x[i];
}

CPLIB_BS_AVX2 static void cplib_bs512_shl_avx2(uint64_t *dst, const uint64_t *x,
                                 size_t n, size_t shift) {
/* ゼロ初期化済みの別領域へ左シフトし、隣接ワードからの桁上がりも処理します。 */
const size_t offset = shift >> 6;
const unsigned bits = shift & 63;
const size_t count = n - offset;
size_t i = 0;
if (bits == 0) {
    for (; i + 4 <= count; i += 4)
        _mm256_storeu_si256((__m256i *)(dst + offset + i),
            _mm256_loadu_si256((const __m256i *)(x + i)));
    for (; i < count; ++i) dst[offset + i] = x[i];
    return;
}
const __m128i left = _mm_cvtsi32_si128(bits);
const __m128i right = _mm_cvtsi32_si128(64 - bits);
dst[offset] = x[0] << bits;
i = 1;
for (; i + 4 <= count; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(x + i - 1));
    _mm256_storeu_si256((__m256i *)(dst + offset + i), _mm256_or_si256(
        _mm256_sll_epi64(a, left), _mm256_srl_epi64(b, right)));
}
for (; i < count; ++i)
    dst[offset + i] = (x[i] << bits) | (x[i - 1] >> (64 - bits));
}

CPLIB_BS_AVX2 static void cplib_bs512_shr_avx2(uint64_t *dst, const uint64_t *x,
                                 size_t n, size_t shift) {
/* ゼロ初期化済みの別領域へ右シフトし、隣接ワードからの桁下がりも処理します。 */
const size_t offset = shift >> 6;
const unsigned bits = shift & 63;
const size_t count = n - offset;
size_t i = 0;
if (bits == 0) {
    for (; i + 4 <= count; i += 4)
        _mm256_storeu_si256((__m256i *)(dst + i),
            _mm256_loadu_si256((const __m256i *)(x + offset + i)));
    for (; i < count; ++i) dst[i] = x[offset + i];
    return;
}
const __m128i right = _mm_cvtsi32_si128(bits);
const __m128i left = _mm_cvtsi32_si128(64 - bits);
for (; i + 4 < count; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + offset + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(x + offset + i + 1));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_or_si256(
        _mm256_srl_epi64(a, right), _mm256_sll_epi64(b, left)));
}
for (; i + 1 < count; ++i)
    dst[i] = (x[offset + i] >> bits) | (x[offset + i + 1] << (64 - bits));
dst[count - 1] = x[n - 1] >> bits;
}

CPLIB_BS_AVX2 static inline __m256i cplib_bs512_byte_counts(__m256i x) {
/* 4ビットの参照表から各バイトの立っているビット数を求めます。 */
const __m256i table = _mm256_setr_epi8(
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4,
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);
const __m256i mask = _mm256_set1_epi8(15);
return _mm256_add_epi8(
    _mm256_shuffle_epi8(table, _mm256_and_si256(x, mask)),
    _mm256_shuffle_epi8(table, _mm256_and_si256(_mm256_srli_epi16(x, 4), mask)));
}

#define CPLIB_BS_COUNT(name, scalar, vector) \
CPLIB_BS_AVX2 static size_t name(const uint64_t *x, const uint64_t *y, size_t n) { \
/* 16ベクトルごとにバイトの和を64ビットへ集約し、桁あふれを防ぎます。 */ \
__m256i total = _mm256_setzero_si256(); \
size_t i = 0; \
while (i + 4 <= n) { \
    __m256i local = _mm256_setzero_si256(); \
    size_t end = n - i < 64 ? n : i + 64; \
    for (; i + 4 <= end; i += 4) { \
        __m256i a = _mm256_loadu_si256((const __m256i *)(x + i)); \
        __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \
        local = _mm256_add_epi8(local, cplib_bs512_byte_counts(vector)); \
    } \
    total = _mm256_add_epi64(total, _mm256_sad_epu8(local, _mm256_setzero_si256())); \
} \
uint64_t lanes[4]; \
_mm256_storeu_si256((__m256i *)lanes, total); \
size_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3]; \
for (; i < n; ++i) result += __builtin_popcountll(scalar); \
return result; \
}
CPLIB_BS_COUNT(cplib_bs512_popcount_avx2, x[i], a)
CPLIB_BS_COUNT(cplib_bs512_andpopcount_avx2, x[i] & y[i], _mm256_and_si256(a, b))
CPLIB_BS_COUNT(cplib_bs512_orpopcount_avx2, x[i] | y[i], _mm256_or_si256(a, b))
CPLIB_BS_COUNT(cplib_bs512_xorpopcount_avx2, x[i] ^ y[i], _mm256_xor_si256(a, b))
#undef CPLIB_BS_COUNT

CPLIB_BS_AVX2 static uint32_t cplib_bs512_bool_mask(const unsigned char *src) {
    /* 32個のboolを比較し、非ゼロの位置を32ビットのマスクに詰めます。 */
    __m256i values = _mm256_loadu_si256((const __m256i *)src);
    return ~(uint32_t)_mm256_movemask_epi8(
        _mm256_cmpeq_epi8(values, _mm256_setzero_si256()));
}

CPLIB_BS_AVX2 static void cplib_bs512_from_bools_avx2(uint64_t *dst, const void *source,
                                            size_t length, size_t words) {
    /* 入力を64ビットずつ詰め、端数と入力より後ろのワードもすべて書き込みます。 */
    const unsigned char *src = (const unsigned char *)source;
    size_t i = 0, word = 0;
    for (; i + 64 <= length; i += 64) {
        uint64_t low = cplib_bs512_bool_mask(src + i);
        uint64_t high = cplib_bs512_bool_mask(src + i + 32);
        dst[word++] = low | (high << 32);
    }
    if (i < length) {
        uint64_t value = 0;
        size_t j = 0;
        if (length - i >= 32) {
            value = cplib_bs512_bool_mask(src + i);
            j = 32;
        }
        for (; j < length - i; ++j)
            value |= (uint64_t)(src[i + j] != 0) << j;
        dst[word++] = value;
    }
    for (; word < words; ++word) dst[word] = 0;
}
#define CPLIB_BS_AVX512 __attribute__((target("avx512f")))

#define CPLIB_BS_BINARY(name, scalar, vector) \
CPLIB_BS_AVX512 static void name(uint64_t *dst, const uint64_t *x, \
                           const uint64_t *y, size_t n) { \
/* 512ビットずつ論理演算し、残りを64ビットずつ処理します。 */ \
size_t i = 0; \
for (; i + 8 <= n; i += 8) { \
    __m512i a = _mm512_loadu_si512((const __m512i *)(x + i)); \
    __m512i b = _mm512_loadu_si512((const __m512i *)(y + i)); \
    _mm512_storeu_si512((__m512i *)(dst + i), vector(a, b)); \
} \
for (; i < n; ++i) dst[i] = x[i] scalar y[i]; \
}
CPLIB_BS_BINARY(cplib_bs512_and_avx512, &, _mm512_and_si512)
CPLIB_BS_BINARY(cplib_bs512_or_avx512, |, _mm512_or_si512)
CPLIB_BS_BINARY(cplib_bs512_xor_avx512, ^, _mm512_xor_si512)
#undef CPLIB_BS_BINARY

CPLIB_BS_AVX512 static void cplib_bs512_andnot_avx512(uint64_t *dst, const uint64_t *x,
                                       const uint64_t *y, size_t n) {
/* 512ビットずつ差集合を求め、残りを64ビットずつ処理します。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const __m512i *)(x + i));
    __m512i b = _mm512_loadu_si512((const __m512i *)(y + i));
    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_andnot_si512(b, a));
}
for (; i < n; ++i) dst[i] = x[i] & ~y[i];
}

CPLIB_BS_AVX512 static void cplib_bs512_not_avx512(uint64_t *dst, const uint64_t *x, size_t n) {
/* 512ビットずつ反転します。 */
const __m512i ones = _mm512_set1_epi64(-1);
size_t i = 0;
for (; i + 8 <= n; i += 8)
    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_xor_si512(
        _mm512_loadu_si512((const __m512i *)(x + i)), ones));
for (; i < n; ++i) dst[i] = ~x[i];
}

CPLIB_BS_AVX512 static void cplib_bs512_shl_avx512(uint64_t *dst, const uint64_t *x,
                                 size_t n, size_t shift) {
/* ゼロ初期化済みの別領域へ左シフトし、隣接ワードからの桁上がりも処理します。 */
const size_t offset = shift >> 6;
const unsigned bits = shift & 63;
const size_t count = n - offset;
size_t i = 0;
if (bits == 0) {
    for (; i + 8 <= count; i += 8)
        _mm512_storeu_si512((__m512i *)(dst + offset + i),
            _mm512_loadu_si512((const __m512i *)(x + i)));
    for (; i < count; ++i) dst[offset + i] = x[i];
    return;
}
const __m128i left = _mm_cvtsi32_si128(bits);
const __m128i right = _mm_cvtsi32_si128(64 - bits);
dst[offset] = x[0] << bits;
i = 1;
for (; i + 8 <= count; i += 8) {
    __m512i a = _mm512_loadu_si512((const __m512i *)(x + i));
    __m512i b = _mm512_loadu_si512((const __m512i *)(x + i - 1));
    _mm512_storeu_si512((__m512i *)(dst + offset + i), _mm512_or_si512(
        _mm512_sll_epi64(a, left), _mm512_srl_epi64(b, right)));
}
for (; i < count; ++i)
    dst[offset + i] = (x[i] << bits) | (x[i - 1] >> (64 - bits));
}

CPLIB_BS_AVX512 static void cplib_bs512_shr_avx512(uint64_t *dst, const uint64_t *x,
                                 size_t n, size_t shift) {
/* ゼロ初期化済みの別領域へ右シフトし、隣接ワードからの桁下がりも処理します。 */
const size_t offset = shift >> 6;
const unsigned bits = shift & 63;
const size_t count = n - offset;
size_t i = 0;
if (bits == 0) {
    for (; i + 8 <= count; i += 8)
        _mm512_storeu_si512((__m512i *)(dst + i),
            _mm512_loadu_si512((const __m512i *)(x + offset + i)));
    for (; i < count; ++i) dst[i] = x[offset + i];
    return;
}
const __m128i right = _mm_cvtsi32_si128(bits);
const __m128i left = _mm_cvtsi32_si128(64 - bits);
for (; i + 8 < count; i += 8) {
    __m512i a = _mm512_loadu_si512((const __m512i *)(x + offset + i));
    __m512i b = _mm512_loadu_si512((const __m512i *)(x + offset + i + 1));
    _mm512_storeu_si512((__m512i *)(dst + i), _mm512_or_si512(
        _mm512_srl_epi64(a, right), _mm512_sll_epi64(b, left)));
}
for (; i + 1 < count; ++i)
    dst[i] = (x[offset + i] >> bits) | (x[offset + i + 1] << (64 - bits));
dst[count - 1] = x[n - 1] >> bits;
}


#define CPLIB_BS_COUNT512(name, scalar, vector) \
__attribute__((target("avx512f,avx512vpopcntdq"))) \
static size_t name(const uint64_t *x, const uint64_t *y, size_t n) { \
/* 64ビットごとの個数を専用命令で求め、最後に集約します。 */ \
__m512i total = _mm512_setzero_si512(); \
size_t i = 0; \
for (; i + 8 <= n; i += 8) { \
    __m512i a = _mm512_loadu_si512((const void *)(x + i)); \
    __m512i b = _mm512_loadu_si512((const void *)(y + i)); \
    total = _mm512_add_epi64(total, _mm512_popcnt_epi64(vector)); \
} \
uint64_t lanes[8]; \
_mm512_storeu_si512((void *)lanes, total); \
size_t result = 0; \
for (size_t j = 0; j < 8; ++j) result += lanes[j]; \
for (; i < n; ++i) result += __builtin_popcountll(scalar); \
return result; \
}
CPLIB_BS_COUNT512(cplib_bs512_popcount_avx512, x[i], a)
CPLIB_BS_COUNT512(cplib_bs512_andpopcount_avx512, x[i] & y[i], _mm512_and_si512(a, b))
CPLIB_BS_COUNT512(cplib_bs512_orpopcount_avx512, x[i] | y[i], _mm512_or_si512(a, b))
CPLIB_BS_COUNT512(cplib_bs512_xorpopcount_avx512, x[i] ^ y[i], _mm512_xor_si512(a, b))
#undef CPLIB_BS_COUNT512

__attribute__((target("avx512f,avx512bw")))
static void cplib_bs512_from_bools_avx512(uint64_t *dst, const void *source,
                                      size_t length, size_t words) {
/* 64個のboolを比較し、比較結果のマスクをそのまま1ワードにします。 */
const unsigned char *src = (const unsigned char *)source;
size_t i = 0, word = 0;
for (; i + 64 <= length; i += 64) {
    __m512i values = _mm512_loadu_si512((const void *)(src + i));
    dst[word++] = (uint64_t)_mm512_cmpneq_epi8_mask(values, _mm512_setzero_si512());
}
if (i < length) {
    uint64_t value = 0;
    for (size_t j = 0; j < length - i; ++j)
        value |= (uint64_t)(src[i + j] != 0) << j;
    dst[word++] = value;
}
for (; word < words; ++word) dst[word] = 0;
}

/* CPUとOSが対応する命令だけを選びます。公開APIとデータ表現は共通です。 */

static inline void cplib_bs512_and(uint64_t *dst, const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_and_avx512(dst, x, y, n);
    } else {
        cplib_bs512_and_avx2(dst, x, y, n);
    }
}

static inline void cplib_bs512_or(uint64_t *dst, const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_or_avx512(dst, x, y, n);
    } else {
        cplib_bs512_or_avx2(dst, x, y, n);
    }
}

static inline void cplib_bs512_xor(uint64_t *dst, const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_xor_avx512(dst, x, y, n);
    } else {
        cplib_bs512_xor_avx2(dst, x, y, n);
    }
}

static inline void cplib_bs512_andnot(uint64_t *dst, const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_andnot_avx512(dst, x, y, n);
    } else {
        cplib_bs512_andnot_avx2(dst, x, y, n);
    }
}

static inline void cplib_bs512_not(uint64_t *dst, const uint64_t *x, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_not_avx512(dst, x, n);
    } else {
        cplib_bs512_not_avx2(dst, x, n);
    }
}

static inline void cplib_bs512_shl(uint64_t *dst, const uint64_t *x, size_t n, size_t shift) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_shl_avx512(dst, x, n, shift);
    } else {
        cplib_bs512_shl_avx2(dst, x, n, shift);
    }
}

static inline void cplib_bs512_shr(uint64_t *dst, const uint64_t *x, size_t n, size_t shift) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_shr_avx512(dst, x, n, shift);
    } else {
        cplib_bs512_shr_avx2(dst, x, n, shift);
    }
}

static inline size_t cplib_bs512_popcount(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512vpopcntdq")) {
        return cplib_bs512_popcount_avx512(x, y, n);
    } else {
        return cplib_bs512_popcount_avx2(x, y, n);
    }
}

static inline size_t cplib_bs512_andpopcount(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512vpopcntdq")) {
        return cplib_bs512_andpopcount_avx512(x, y, n);
    } else {
        return cplib_bs512_andpopcount_avx2(x, y, n);
    }
}

static inline size_t cplib_bs512_orpopcount(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512vpopcntdq")) {
        return cplib_bs512_orpopcount_avx512(x, y, n);
    } else {
        return cplib_bs512_orpopcount_avx2(x, y, n);
    }
}

static inline size_t cplib_bs512_xorpopcount(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512vpopcntdq")) {
        return cplib_bs512_xorpopcount_avx512(x, y, n);
    } else {
        return cplib_bs512_xorpopcount_avx2(x, y, n);
    }
}

static inline void cplib_bs512_from_bools(uint64_t *dst, const void *source, size_t length, size_t words) {
    if (length >= 64 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw")) {
        cplib_bs512_from_bools_avx512(dst, source, length, words);
    } else {
        cplib_bs512_from_bools_avx2(dst, source, length, words);
    }
}
CPLIB_BS_AVX2 static void cplib_bs512_select_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(a, _mm256_and_si256(_mm256_xor_si256(a, b), c)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = (a & ~c) | (b & c);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_select_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xD8));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = (a & ~c) | (b & c);
}
}
static inline void cplib_bs512_select(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_select_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_select_avx2(dst, x, y, z, n);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_orand_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_or_si256(a, _mm256_and_si256(b, c)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a | (b & c);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_orand_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xF8));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a | (b & c);
}
}
static inline void cplib_bs512_orand(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_orand_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_orand_avx2(dst, x, y, z, n);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_andor_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_and_si256(a, _mm256_or_si256(b, c)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a & (b | c);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_andor_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xE0));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a & (b | c);
}
}
static inline void cplib_bs512_andor(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_andor_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_andor_avx2(dst, x, y, z, n);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_xorand_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(a, _mm256_and_si256(b, c)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a ^ (b & c);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_xorand_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0x78));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = a ^ (b & c);
}
}
static inline void cplib_bs512_xorand(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_xorand_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_xorand_avx2(dst, x, y, z, n);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_majority_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_or_si256(_mm256_and_si256(a, b), _mm256_and_si256(_mm256_or_si256(a, b), c)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = (a & b) | ((a | b) & c);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_majority_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xE8));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = (a & b) | ((a | b) & c);
}
}
static inline void cplib_bs512_majority(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_majority_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_majority_avx2(dst, x, y, z, n);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_xnor_avx2(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 256ビットずつ複合演算し、一時配列を作らずに書き込みます。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    __m256i c = _mm256_loadu_si256((const __m256i *)(z + i));
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(_mm256_xor_si256(a, b), _mm256_set1_epi64x(-1)));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = ~(a ^ b);
}
}

CPLIB_BS_AVX512 static void cplib_bs512_xnor_avx512(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
/* 真理値表の添字は(a << 2) | (b << 1) | cです。512ビットあたり論理演算1命令です。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_loadu_si512((const void *)(z + i));
    _mm512_storeu_si512((void *)(dst + i), _mm512_ternarylogic_epi64(a, b, c, 0xC3));
}
for (; i < n; ++i) {
    uint64_t a = x[i], b = y[i], c = z[i];
    dst[i] = ~(a ^ b);
}
}
static inline void cplib_bs512_xnor(uint64_t *dst, const uint64_t *x,
        const uint64_t *y, const uint64_t *z, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) {
        cplib_bs512_xnor_avx512(dst, x, y, z, n);
    } else {
        cplib_bs512_xnor_avx2(dst, x, y, z, n);
    }
}


#define CPLIB_BS512_UPDATE_COUNT(name, scalar, vector, truth, ternary) \
CPLIB_BS_AVX2 static size_t name##_avx2(uint64_t *x, const uint64_t *y, \
                                     const uint64_t *z, size_t bits) { \
/* 更新値を保存しながら個数を数えます。最後の不完全なワードは別途マスクします。 */ \
const size_t full = bits >> 6, rem = bits & 63; \
const size_t words = full + (rem != 0); \
__m256i total = _mm256_setzero_si256(); \
size_t i = 0; \
while (i + 4 <= full) { \
    __m256i local = _mm256_setzero_si256(); \
    const size_t end = full - i < 64 ? full : i + 64; \
    for (; i + 4 <= end; i += 4) { \
        __m256i a = _mm256_loadu_si256((const __m256i *)(x + i)); \
        __m256i b = _mm256_loadu_si256((const __m256i *)(y + i)); \
        __m256i c = ternary ? _mm256_loadu_si256((const __m256i *)(z + i)) : a; \
        __m256i value = vector; \
        local = _mm256_add_epi8(local, cplib_bs512_byte_counts(value)); \
        _mm256_storeu_si256((__m256i *)(x + i), value); \
    } \
    total = _mm256_add_epi64(total, _mm256_sad_epu8(local, _mm256_setzero_si256())); \
} \
uint64_t lanes[4]; \
_mm256_storeu_si256((__m256i *)lanes, total); \
size_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3]; \
for (; i < words; ++i) { \
    uint64_t a = x[i], b = y[i], c = ternary ? z[i] : a; \
    uint64_t value = scalar; \
    if (i == full) value &= (UINT64_C(1) << rem) - 1; \
    x[i] = value; \
    result += __builtin_popcountll(value); \
} \
return result; \
} \
__attribute__((target("avx512f,avx512vpopcntdq"))) \
static size_t name##_avx512(uint64_t *x, const uint64_t *y, const uint64_t *z, size_t bits) { \
/* 512ビットごとに論理演算・個数計算・累積を行い、一時集合を作りません。 */ \
const size_t full = bits >> 6, rem = bits & 63; \
const size_t words = full + (rem != 0); \
__m512i total = _mm512_setzero_si512(); \
size_t i = 0; \
for (; i + 8 <= full; i += 8) { \
    __m512i a = _mm512_loadu_si512((const void *)(x + i)); \
    __m512i b = _mm512_loadu_si512((const void *)(y + i)); \
    __m512i c = ternary ? _mm512_loadu_si512((const void *)(z + i)) : a; \
    __m512i value = _mm512_ternarylogic_epi64(a, b, c, truth); \
    total = _mm512_add_epi64(total, _mm512_popcnt_epi64(value)); \
    _mm512_storeu_si512((void *)(x + i), value); \
} \
uint64_t lanes[8]; \
_mm512_storeu_si512((void *)lanes, total); \
size_t result = 0; \
for (size_t j = 0; j < 8; ++j) result += lanes[j]; \
for (; i < words; ++i) { \
    uint64_t a = x[i], b = y[i], c = ternary ? z[i] : a; \
    uint64_t value = scalar; \
    if (i == full) value &= (UINT64_C(1) << rem) - 1; \
    x[i] = value; \
    result += __builtin_popcountll(value); \
} \
return result; \
} \
static inline size_t name(uint64_t *x, const uint64_t *y, const uint64_t *z, size_t bits) { \
    if (bits >= 512 && __builtin_cpu_supports("avx512f") && \
            __builtin_cpu_supports("avx512vpopcntdq")) { \
        return name##_avx512(x, y, z, bits); \
    } \
    return name##_avx2(x, y, z, bits); \
}
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_and_update_count, a & b, _mm256_and_si256(a, b), 0xC0, 0)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_or_update_count, a | b, _mm256_or_si256(a, b), 0xFC, 0)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_xor_update_count, a ^ b, _mm256_xor_si256(a, b), 0x3C, 0)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_andnot_update_count, a & ~b, _mm256_andnot_si256(b, a), 0x30, 0)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_select_update_count, (a & ~c) | (b & c), _mm256_xor_si256(a, _mm256_and_si256(_mm256_xor_si256(a, b), c)), 0xD8, 1)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_orand_update_count, a | (b & c), _mm256_or_si256(a, _mm256_and_si256(b, c)), 0xF8, 1)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_andor_update_count, a & (b | c), _mm256_and_si256(a, _mm256_or_si256(b, c)), 0xE0, 1)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_xorand_update_count, a ^ (b & c), _mm256_xor_si256(a, _mm256_and_si256(b, c)), 0x78, 1)
CPLIB_BS512_UPDATE_COUNT(cplib_bs512_xnor_update_count, ~(a ^ b), _mm256_xor_si256(_mm256_xor_si256(a, b), _mm256_set1_epi64x(-1)), 0xC3, 0)
#undef CPLIB_BS512_UPDATE_COUNT


#define CPLIB_BS_COUNT_RANGE(name, count, value) \
static inline size_t name(const uint64_t *x, const uint64_t *y, size_t l, size_t r) { \
/* 両端の部分ワードだけをマスクし、中央の完全なワードは既存のSIMDカーネルで数えます。 */ \
if (l == r) return 0; \
size_t first = l >> 6, last = (r - 1) >> 6; \
const uint64_t leftMask = UINT64_MAX << (l & 63); \
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63)); \
size_t i = first; \
if (first == last) return __builtin_popcountll((value) & leftMask & rightMask); \
size_t result = 0, end = last + 1; \
if ((l & 63) != 0) { \
    result += __builtin_popcountll((value) & leftMask); \
    ++first; \
} \
if ((r & 63) != 0) { \
    i = last; \
    result += __builtin_popcountll((value) & rightMask); \
    --end; \
} \
if (first < end) result += count(x + first, y + first, end - first); \
return result; \
}
CPLIB_BS_COUNT_RANGE(cplib_bs512_popcount_range, cplib_bs512_popcount, x[i])
CPLIB_BS_COUNT_RANGE(cplib_bs512_andpopcount_range, cplib_bs512_andpopcount, x[i] & y[i])
CPLIB_BS_COUNT_RANGE(cplib_bs512_orpopcount_range, cplib_bs512_orpopcount, x[i] | y[i])
CPLIB_BS_COUNT_RANGE(cplib_bs512_xorpopcount_range, cplib_bs512_xorpopcount, x[i] ^ y[i])
#undef CPLIB_BS_COUNT_RANGE

CPLIB_BS_AVX2 static void cplib_bs512_from_string_char_avx2(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
/* 32バイトずつ比較し、比較結果のマスクを直接ビット集合へ格納します。 */
const unsigned char *src = (const unsigned char *)source;
const unsigned char *ref = (const unsigned char *)reference;
size_t i = 0, word = 0;
while (i < length) {
    uint64_t value = 0;
    size_t j = 0, limit = length - i < 64 ? length - i : 64;
    for (; j + 32 <= limit; j += 32) {
        size_t pos = i + j;
        __m256i a = _mm256_loadu_si256((const __m256i *)(src + pos));
        __m256i b = _mm256_set1_epi8((char)match);
        uint32_t mask = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a, b));
        value |= (uint64_t)mask << j;
    }
    for (; j < limit; ++j) value |= (uint64_t)(src[i + j] == match) << j;
    dst[word++] = value;
    i += limit;
}
for (; word < words; ++word) dst[word] = 0;
}

__attribute__((target("avx512f,avx512bw")))
static void cplib_bs512_from_string_char_avx512(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
/* 64バイトの比較マスクを1ワードにします。末尾は入力範囲内だけを読みます。 */
const unsigned char *src = (const unsigned char *)source;
const unsigned char *ref = (const unsigned char *)reference;
size_t i = 0, word = 0;
for (; i + 64 <= length; i += 64) {
    __m512i a = _mm512_loadu_si512((const void *)(src + i));
    __m512i b = _mm512_set1_epi8((char)match);
    dst[word++] = (uint64_t)_mm512_cmpeq_epi8_mask(a, b);
}
if (i < length) {
    cplib_bs512_from_string_char_avx2(dst + word, src + i, NULL, match, length - i, words - word);
} else {
    for (; word < words; ++word) dst[word] = 0;
}
}
static inline void cplib_bs512_from_string_char(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
    if (length >= 64 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw")) {
        cplib_bs512_from_string_char_avx512(dst, source, reference, match, length, words);
    } else {
        cplib_bs512_from_string_char_avx2(dst, source, reference, match, length, words);
    }
}

CPLIB_BS_AVX2 static void cplib_bs512_from_string_equal_avx2(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
/* 32バイトずつ比較し、比較結果のマスクを直接ビット集合へ格納します。 */
const unsigned char *src = (const unsigned char *)source;
const unsigned char *ref = (const unsigned char *)reference;
size_t i = 0, word = 0;
while (i < length) {
    uint64_t value = 0;
    size_t j = 0, limit = length - i < 64 ? length - i : 64;
    for (; j + 32 <= limit; j += 32) {
        size_t pos = i + j;
        __m256i a = _mm256_loadu_si256((const __m256i *)(src + pos));
        __m256i b = _mm256_loadu_si256((const __m256i *)(ref + pos));
        uint32_t mask = (uint32_t)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a, b));
        value |= (uint64_t)mask << j;
    }
    for (; j < limit; ++j) value |= (uint64_t)(src[i + j] == ref[i + j]) << j;
    dst[word++] = value;
    i += limit;
}
for (; word < words; ++word) dst[word] = 0;
}

__attribute__((target("avx512f,avx512bw")))
static void cplib_bs512_from_string_equal_avx512(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
/* 64バイトの比較マスクを1ワードにします。末尾は入力範囲内だけを読みます。 */
const unsigned char *src = (const unsigned char *)source;
const unsigned char *ref = (const unsigned char *)reference;
size_t i = 0, word = 0;
for (; i + 64 <= length; i += 64) {
    __m512i a = _mm512_loadu_si512((const void *)(src + i));
    __m512i b = _mm512_loadu_si512((const void *)(ref + i));
    dst[word++] = (uint64_t)_mm512_cmpeq_epi8_mask(a, b);
}
if (i < length) {
    cplib_bs512_from_string_equal_avx2(dst + word, src + i, ref + i, match, length - i, words - word);
} else {
    for (; word < words; ++word) dst[word] = 0;
}
}
static inline void cplib_bs512_from_string_equal(uint64_t *dst, const void *source,
        const void *reference, unsigned char match, size_t length, size_t words) {
    if (length >= 64 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw")) {
        cplib_bs512_from_string_equal_avx512(dst, source, reference, match, length, words);
    } else {
        cplib_bs512_from_string_equal_avx2(dst, source, reference, match, length, words);
    }
}

CPLIB_BS_AVX2 static int cplib_bs512_intersects_avx2(const uint64_t *x, const uint64_t *y, size_t n) {
/* 結果が確定したブロックで終了し、個数は数えません。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    if (!_mm256_testz_si256(a, b)) return 1;
}
for (; i < n; ++i) if ((x[i] & y[i]) != 0) return 1;
return 0;
}

CPLIB_BS_AVX512 static int cplib_bs512_intersects_avx512(const uint64_t *x, const uint64_t *y, size_t n) {
/* 結果が確定したブロックで終了し、個数は数えません。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    if (_mm512_test_epi64_mask(a, b) != 0) return 1;
}
for (; i < n; ++i) if ((x[i] & y[i]) != 0) return 1;
return 0;
}

static inline int cplib_bs512_intersects(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) return cplib_bs512_intersects_avx512(x, y, n);
    return cplib_bs512_intersects_avx2(x, y, n);
}

CPLIB_BS_AVX2 static int cplib_bs512_subset_avx2(const uint64_t *x, const uint64_t *y, size_t n) {
/* 結果が確定したブロックで終了し、個数は数えません。 */
size_t i = 0;
for (; i + 4 <= n; i += 4) {
    __m256i a = _mm256_loadu_si256((const __m256i *)(x + i));
    __m256i b = _mm256_loadu_si256((const __m256i *)(y + i));
    if (!_mm256_testc_si256(b, a)) return 0;
}
for (; i < n; ++i) if ((x[i] & ~y[i]) != 0) return 0;
return 1;
}

CPLIB_BS_AVX512 static int cplib_bs512_subset_avx512(const uint64_t *x, const uint64_t *y, size_t n) {
/* 結果が確定したブロックで終了し、個数は数えません。 */
size_t i = 0;
for (; i + 8 <= n; i += 8) {
    __m512i a = _mm512_loadu_si512((const void *)(x + i));
    __m512i b = _mm512_loadu_si512((const void *)(y + i));
    __m512i c = _mm512_andnot_si512(b, a);
    if (_mm512_test_epi64_mask(c, c) != 0) return 0;
}
for (; i < n; ++i) if ((x[i] & ~y[i]) != 0) return 0;
return 1;
}

static inline int cplib_bs512_subset(const uint64_t *x, const uint64_t *y, size_t n) {
    if (n >= 8 && __builtin_cpu_supports("avx512f")) return cplib_bs512_subset_avx512(x, y, n);
    return cplib_bs512_subset_avx2(x, y, n);
}

CPLIB_BS_AVX2 static void cplib_bs512_set_range_avx2(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] |= mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] |= mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] |= mask; --end; }
size_t i = first;
for (; i + 4 <= end; i += 4)
    _mm256_storeu_si256((__m256i *)(x + i), _mm256_set1_epi64x(-1));
for (; i < end; ++i) { x[i] = UINT64_MAX; }
}

CPLIB_BS_AVX512 static void cplib_bs512_set_range_avx512(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] |= mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] |= mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] |= mask; --end; }
size_t i = first;
for (; i + 8 <= end; i += 8)
    _mm512_storeu_si512((void *)(x + i), _mm512_set1_epi64(-1));
for (; i < end; ++i) { x[i] = UINT64_MAX; }
}

static inline void cplib_bs512_set_range(uint64_t *x, size_t l, size_t r) {
    if (r - l >= 512 && __builtin_cpu_supports("avx512f")) cplib_bs512_set_range_avx512(x, l, r);
    else cplib_bs512_set_range_avx2(x, l, r);
}

CPLIB_BS_AVX2 static void cplib_bs512_clear_range_avx2(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] &= ~mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] &= ~mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] &= ~mask; --end; }
size_t i = first;
for (; i + 4 <= end; i += 4)
    _mm256_storeu_si256((__m256i *)(x + i), _mm256_setzero_si256());
for (; i < end; ++i) { x[i] = 0; }
}

CPLIB_BS_AVX512 static void cplib_bs512_clear_range_avx512(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] &= ~mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] &= ~mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] &= ~mask; --end; }
size_t i = first;
for (; i + 8 <= end; i += 8)
    _mm512_storeu_si512((void *)(x + i), _mm512_setzero_si512());
for (; i < end; ++i) { x[i] = 0; }
}

static inline void cplib_bs512_clear_range(uint64_t *x, size_t l, size_t r) {
    if (r - l >= 512 && __builtin_cpu_supports("avx512f")) cplib_bs512_clear_range_avx512(x, l, r);
    else cplib_bs512_clear_range_avx2(x, l, r);
}

CPLIB_BS_AVX2 static void cplib_bs512_flip_range_avx2(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] ^= mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] ^= mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] ^= mask; --end; }
size_t i = first;
for (; i + 4 <= end; i += 4)
    _mm256_storeu_si256((__m256i *)(x + i), _mm256_xor_si256(_mm256_loadu_si256((const __m256i *)(x + i)), _mm256_set1_epi64x(-1)));
for (; i < end; ++i) { x[i] = ~x[i]; }
}

CPLIB_BS_AVX512 static void cplib_bs512_flip_range_avx512(uint64_t *x, size_t l, size_t r) {
/* 両端だけをマスクし、中央の完全なワードをまとめて更新します。 */
if (l == r) return;
size_t first = l >> 6, last = (r - 1) >> 6;
uint64_t mask = UINT64_MAX << (l & 63);
const uint64_t rightMask = UINT64_MAX >> (63 - ((r - 1) & 63));
if (first == last) {
    mask &= rightMask;
    x[first] ^= mask;
    return;
}
size_t end = last + 1;
if ((l & 63) != 0) { x[first] ^= mask; ++first; }
if ((r & 63) != 0) { mask = rightMask; x[last] ^= mask; --end; }
size_t i = first;
for (; i + 8 <= end; i += 8)
    _mm512_storeu_si512((void *)(x + i), _mm512_xor_si512(_mm512_loadu_si512((const void *)(x + i)), _mm512_set1_epi64(-1)));
for (; i < end; ++i) { x[i] = ~x[i]; }
}

static inline void cplib_bs512_flip_range(uint64_t *x, size_t l, size_t r) {
    if (r - l >= 512 && __builtin_cpu_supports("avx512f")) cplib_bs512_flip_range_avx512(x, l, r);
    else cplib_bs512_flip_range_avx2(x, l, r);
}

#undef CPLIB_BS_AVX512
#undef CPLIB_BS_AVX2
#endif
""".}

proc avxAnd(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs512_and", nodecl.}
proc avxAndNot(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs512_andnot", nodecl.}
proc avxOr(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs512_or", nodecl.}
proc avxXor(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs512_xor", nodecl.}
proc avxNot(dst, x: ptr uint64, n: csize_t) {.importc: "cplib_bs512_not", nodecl.}
proc avxShl(dst, x: ptr uint64, n, shift: csize_t) {.importc: "cplib_bs512_shl", nodecl.}
proc avxShr(dst, x: ptr uint64, n, shift: csize_t) {.importc: "cplib_bs512_shr", nodecl.}
proc avxPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs512_popcount", nodecl.}
proc avxAndPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs512_andpopcount", nodecl.}
proc avxOrPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs512_orpopcount", nodecl.}
proc avxXorPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs512_xorpopcount", nodecl.}
proc avxFromBools(dst: ptr uint64, src: pointer, length, words: csize_t) {.importc: "cplib_bs512_from_bools", nodecl.}

proc avxSelectAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_select", nodecl.}

proc avxOrAndAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_orand", nodecl.}

proc avxAndOrAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_andor", nodecl.}

proc avxXorAndAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_xorand", nodecl.}

proc avxMajority(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_majority", nodecl.}

proc avxXnorAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs512_xnor", nodecl.}

proc avxAndAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_and_update_count", nodecl.}

proc avxOrAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_or_update_count", nodecl.}

proc avxXorAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_xor_update_count", nodecl.}

proc avxAndNotAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_andnot_update_count", nodecl.}

proc avxSelectAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_select_update_count", nodecl.}

proc avxOrAndAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_orand_update_count", nodecl.}

proc avxAndOrAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_andor_update_count", nodecl.}

proc avxXorAndAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_xorand_update_count", nodecl.}

proc avxXnorAssignPopcount(x, y, z: ptr uint64, bits: csize_t): csize_t {.importc: "cplib_bs512_xnor_update_count", nodecl.}

proc avxPopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs512_popcount_range", nodecl.}

proc avxAndpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs512_andpopcount_range", nodecl.}

proc avxOrpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs512_orpopcount_range", nodecl.}

proc avxXorpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs512_xorpopcount_range", nodecl.}

proc avxFromStringChar(dst: ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t) {.importc: "cplib_bs512_from_string_char", nodecl.}

proc avxFromStringEqual(dst: ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t) {.importc: "cplib_bs512_from_string_equal", nodecl.}

proc avxIntersects(x, y: ptr uint64, n: csize_t): cint {.importc: "cplib_bs512_intersects", nodecl.}

proc avxSubset(x, y: ptr uint64, n: csize_t): cint {.importc: "cplib_bs512_subset", nodecl.}

proc avxSetRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs512_set_range", nodecl.}

proc avxClearRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs512_clear_range", nodecl.}

proc avxFlipRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs512_flip_range", nodecl.}
