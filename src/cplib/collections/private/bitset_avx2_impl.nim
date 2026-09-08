## 動的版と静的版の両方で使うAVX2カーネルです。各モジュールにincludeします。
{.emit: """
#ifndef CPLIB_BITSET_AVX2_IMPL
#define CPLIB_BITSET_AVX2_IMPL
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
CPLIB_BS_BINARY(cplib_bs_and, &, _mm256_and_si256)
CPLIB_BS_BINARY(cplib_bs_or, |, _mm256_or_si256)
CPLIB_BS_BINARY(cplib_bs_xor, ^, _mm256_xor_si256)
#undef CPLIB_BS_BINARY

CPLIB_BS_AVX2 static void cplib_bs_not(uint64_t *dst, const uint64_t *x, size_t n) {
/* 256ビットずつ反転します。 */
const __m256i ones = _mm256_set1_epi64x(-1);
size_t i = 0;
for (; i + 4 <= n; i += 4)
    _mm256_storeu_si256((__m256i *)(dst + i), _mm256_xor_si256(
        _mm256_loadu_si256((const __m256i *)(x + i)), ones));
for (; i < n; ++i) dst[i] = ~x[i];
}

CPLIB_BS_AVX2 static void cplib_bs_shl(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_shr(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static inline __m256i cplib_bs_byte_counts(__m256i x) {
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
        local = _mm256_add_epi8(local, cplib_bs_byte_counts(vector)); \
    } \
    total = _mm256_add_epi64(total, _mm256_sad_epu8(local, _mm256_setzero_si256())); \
} \
uint64_t lanes[4]; \
_mm256_storeu_si256((__m256i *)lanes, total); \
size_t result = lanes[0] + lanes[1] + lanes[2] + lanes[3]; \
for (; i < n; ++i) result += __builtin_popcountll(scalar); \
return result; \
}
CPLIB_BS_COUNT(cplib_bs_popcount, x[i], a)
CPLIB_BS_COUNT(cplib_bs_andpopcount, x[i] & y[i], _mm256_and_si256(a, b))
CPLIB_BS_COUNT(cplib_bs_orpopcount, x[i] | y[i], _mm256_or_si256(a, b))
CPLIB_BS_COUNT(cplib_bs_xorpopcount, x[i] ^ y[i], _mm256_xor_si256(a, b))
#undef CPLIB_BS_COUNT

CPLIB_BS_AVX2 static uint32_t cplib_bs_bool_mask(const unsigned char *src) {
    /* 32個のboolを比較し、非ゼロの位置を32ビットのマスクに詰めます。 */
    __m256i values = _mm256_loadu_si256((const __m256i *)src);
    return ~(uint32_t)_mm256_movemask_epi8(
        _mm256_cmpeq_epi8(values, _mm256_setzero_si256()));
}

CPLIB_BS_AVX2 static void cplib_bs_from_bools(uint64_t *dst, const void *source,
                                            size_t length, size_t words) {
    /* 入力を64ビットずつ詰め、端数と入力より後ろのワードもすべて書き込みます。 */
    const unsigned char *src = (const unsigned char *)source;
    size_t i = 0, word = 0;
    for (; i + 64 <= length; i += 64) {
        uint64_t low = cplib_bs_bool_mask(src + i);
        uint64_t high = cplib_bs_bool_mask(src + i + 32);
        dst[word++] = low | (high << 32);
    }
    if (i < length) {
        uint64_t value = 0;
        size_t j = 0;
        if (length - i >= 32) {
            value = cplib_bs_bool_mask(src + i);
            j = 32;
        }
        for (; j < length - i; ++j)
            value |= (uint64_t)(src[i + j] != 0) << j;
        dst[word++] = value;
    }
    for (; word < words; ++word) dst[word] = 0;
}
#undef CPLIB_BS_AVX2
#endif
""".}

proc avxAnd(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs_and", nodecl.}
proc avxOr(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs_or", nodecl.}
proc avxXor(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs_xor", nodecl.}
proc avxNot(dst, x: ptr uint64, n: csize_t) {.importc: "cplib_bs_not", nodecl.}
proc avxShl(dst, x: ptr uint64, n, shift: csize_t) {.importc: "cplib_bs_shl", nodecl.}
proc avxShr(dst, x: ptr uint64, n, shift: csize_t) {.importc: "cplib_bs_shr", nodecl.}
proc avxPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs_popcount", nodecl.}
proc avxAndPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs_andpopcount", nodecl.}
proc avxOrPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs_orpopcount", nodecl.}
proc avxXorPopcount(x, y: ptr uint64, n: csize_t): csize_t {.importc: "cplib_bs_xorpopcount", nodecl.}
proc avxFromBools(dst: ptr uint64, src: pointer, length, words: csize_t) {.importc: "cplib_bs_from_bools", nodecl.}
