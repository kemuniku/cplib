## 非ゼロワードをSIMDで探索します。範囲は[lo, hi)、見つからなければhiを返します。
{.emit: """
#ifndef CPLIB_BITSET_SEARCH_IMPL
#define CPLIB_BITSET_SEARCH_IMPL
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
__attribute__((target("avx2"))) static size_t cplib_bs_search_next_4(const uint64_t *x, size_t lo, size_t hi) {
const size_t missing = hi;
while (hi-lo >= 4) {
size_t i = lo;
__m256i v = _mm256_loadu_si256((const __m256i *)(x+i));
__m256i zero = _mm256_cmpeq_epi64(v, _mm256_setzero_si256());
unsigned mask = (~(unsigned)_mm256_movemask_pd(_mm256_castsi256_pd(zero))) & 15u;
if (mask) return i + __builtin_ctz(mask);
lo += 4;
}
while (lo < hi) { if (x[lo]) return lo; ++lo; }
return missing;
}
__attribute__((target("avx2"))) static size_t cplib_bs_search_prev_4(const uint64_t *x, size_t lo, size_t hi) {
const size_t missing = hi;
while (hi-lo >= 4) {
size_t i = hi-4;
__m256i v = _mm256_loadu_si256((const __m256i *)(x+i));
__m256i zero = _mm256_cmpeq_epi64(v, _mm256_setzero_si256());
unsigned mask = (~(unsigned)_mm256_movemask_pd(_mm256_castsi256_pd(zero))) & 15u;
if (mask) return i + 31u-__builtin_clz(mask);
hi -= 4;
}
while (hi > lo) { --hi; if (x[hi]) return hi; }
return missing;
}
__attribute__((target("avx512f"))) static size_t cplib_bs_search_next_8(const uint64_t *x, size_t lo, size_t hi) {
const size_t missing = hi;
while (hi-lo >= 8) {
size_t i = lo;
__m512i v = _mm512_loadu_si512((const void *)(x+i));
unsigned mask = (unsigned)_mm512_test_epi64_mask(v,v);
if (mask) return i + __builtin_ctz(mask);
lo += 8;
}
while (lo < hi) { if (x[lo]) return lo; ++lo; }
return missing;
}
__attribute__((target("avx512f"))) static size_t cplib_bs_search_prev_8(const uint64_t *x, size_t lo, size_t hi) {
const size_t missing = hi;
while (hi-lo >= 8) {
size_t i = hi-8;
__m512i v = _mm512_loadu_si512((const void *)(x+i));
unsigned mask = (unsigned)_mm512_test_epi64_mask(v,v);
if (mask) return i + 31u-__builtin_clz(mask);
hi -= 8;
}
while (hi > lo) { --hi; if (x[hi]) return hi; }
return missing;
}
static size_t cplib_bs_search_next(const uint64_t *x, size_t lo, size_t hi) {
if (hi-lo >= 8 && __builtin_cpu_supports("avx512f")) return cplib_bs_search_next_8(x,lo,hi);
return cplib_bs_search_next_4(x,lo,hi);
}
static size_t cplib_bs_search_prev(const uint64_t *x, size_t lo, size_t hi) {
if (hi-lo >= 8 && __builtin_cpu_supports("avx512f")) return cplib_bs_search_prev_8(x,lo,hi);
return cplib_bs_search_prev_4(x,lo,hi);
}
#endif
""".}

proc rawSearchNextWordAvx2(x: ptr uint64, lo, hi: csize_t): csize_t {.importc: "cplib_bs_search_next_4", nodecl.}

proc rawSearchNextWordAvx512(x: ptr uint64, lo, hi: csize_t): csize_t {.importc: "cplib_bs_search_next", nodecl.}

proc rawSearchPrevWordAvx2(x: ptr uint64, lo, hi: csize_t): csize_t {.importc: "cplib_bs_search_prev_4", nodecl.}

proc rawSearchPrevWordAvx512(x: ptr uint64, lo, hi: csize_t): csize_t {.importc: "cplib_bs_search_prev", nodecl.}

# iteratorの展開先でも呼べるよう、Cカーネルは通常のNim手続きで包みます。
proc searchNextWordAvx2(x: ptr uint64, lo, hi: csize_t): csize_t =
    ## 非ゼロワードを探索し、なければhiを返します。O(1 + hi-lo)。
    rawSearchNextWordAvx2(x, lo, hi)

proc searchNextWordAvx512(x: ptr uint64, lo, hi: csize_t): csize_t =
    ## 非ゼロワードを探索し、なければhiを返します。O(1 + hi-lo)。
    rawSearchNextWordAvx512(x, lo, hi)

proc searchPrevWordAvx2(x: ptr uint64, lo, hi: csize_t): csize_t =
    ## 非ゼロワードを探索し、なければhiを返します。O(1 + hi-lo)。
    rawSearchPrevWordAvx2(x, lo, hi)

proc searchPrevWordAvx512(x: ptr uint64, lo, hi: csize_t): csize_t =
    ## 非ゼロワードを探索し、なければhiを返します。O(1 + hi-lo)。
    rawSearchPrevWordAvx512(x, lo, hi)
