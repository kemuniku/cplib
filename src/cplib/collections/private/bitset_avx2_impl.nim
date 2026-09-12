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

CPLIB_BS_AVX2 static void cplib_bs_andnot(uint64_t *dst, const uint64_t *x,
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
CPLIB_BS_AVX2 static void cplib_bs_select(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_orand(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_andor(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_xorand(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_majority(uint64_t *dst, const uint64_t *x,
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

CPLIB_BS_AVX2 static void cplib_bs_xnor(uint64_t *dst, const uint64_t *x,
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
CPLIB_BS_COUNT_RANGE(cplib_bs_popcount_range, cplib_bs_popcount, x[i])
CPLIB_BS_COUNT_RANGE(cplib_bs_andpopcount_range, cplib_bs_andpopcount, x[i] & y[i])
CPLIB_BS_COUNT_RANGE(cplib_bs_orpopcount_range, cplib_bs_orpopcount, x[i] | y[i])
CPLIB_BS_COUNT_RANGE(cplib_bs_xorpopcount_range, cplib_bs_xorpopcount, x[i] ^ y[i])
#undef CPLIB_BS_COUNT_RANGE

CPLIB_BS_AVX2 static void cplib_bs_from_string_char(uint64_t *dst, const void *source,
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

CPLIB_BS_AVX2 static void cplib_bs_from_string_equal(uint64_t *dst, const void *source,
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

CPLIB_BS_AVX2 static int cplib_bs_intersects(const uint64_t *x, const uint64_t *y, size_t n) {
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

CPLIB_BS_AVX2 static int cplib_bs_subset(const uint64_t *x, const uint64_t *y, size_t n) {
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

CPLIB_BS_AVX2 static void cplib_bs_set_range(uint64_t *x, size_t l, size_t r) {
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

CPLIB_BS_AVX2 static void cplib_bs_clear_range(uint64_t *x, size_t l, size_t r) {
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

CPLIB_BS_AVX2 static void cplib_bs_flip_range(uint64_t *x, size_t l, size_t r) {
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

#undef CPLIB_BS_AVX2
#endif
""".}

proc avxAnd(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs_and", nodecl.}
proc avxAndNot(dst, x, y: ptr uint64, n: csize_t) {.importc: "cplib_bs_andnot", nodecl.}
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

proc avxSelectAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_select", nodecl.}

proc avxOrAndAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_orand", nodecl.}

proc avxAndOrAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_andor", nodecl.}

proc avxXorAndAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_xorand", nodecl.}

proc avxMajority(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_majority", nodecl.}

proc avxXnorAssign(dst, x, y, z: ptr uint64, n: csize_t) {.importc: "cplib_bs_xnor", nodecl.}

proc avxPopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs_popcount_range", nodecl.}

proc avxAndpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs_andpopcount_range", nodecl.}

proc avxOrpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs_orpopcount_range", nodecl.}

proc avxXorpopcountRange(x, y: ptr uint64, l, r: csize_t): csize_t {.importc: "cplib_bs_xorpopcount_range", nodecl.}

proc avxFromStringChar(dst: ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t) {.importc: "cplib_bs_from_string_char", nodecl.}

proc avxFromStringEqual(dst: ptr uint64, source, reference: pointer, match: uint8, length, words: csize_t) {.importc: "cplib_bs_from_string_equal", nodecl.}

proc avxIntersects(x, y: ptr uint64, n: csize_t): cint {.importc: "cplib_bs_intersects", nodecl.}

proc avxSubset(x, y: ptr uint64, n: csize_t): cint {.importc: "cplib_bs_subset", nodecl.}

proc avxSetRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs_set_range", nodecl.}

proc avxClearRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs_clear_range", nodecl.}

proc avxFlipRange(x: ptr uint64, l, r: csize_t) {.importc: "cplib_bs_flip_range", nodecl.}
