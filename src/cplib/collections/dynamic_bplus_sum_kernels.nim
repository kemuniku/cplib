when not declared CPLIB_COLLECTIONS_DYNAMIC_BPLUS_SUM_KERNELS:
    const CPLIB_COLLECTIONS_DYNAMIC_BPLUS_SUM_KERNELS* = 1
    when defined(cplibDynamicBitVectorPortable):
        {.passC: "-DCPLIB_SUM_PORTABLE".}
    {.emit: """
#include <stdint.h>
#if !defined(CPLIB_SUM_PORTABLE) && (defined(__x86_64__) || defined(__i386__)) && (defined(__GNUC__) || defined(__clang__))
#include <immintrin.h>
#define CPLIB_SUM_AVX2 1
__attribute__((target("avx2")))
static void cplib_sum_shift_avx2(uint64_t *p, int n, uint64_t delta, int direction) {
    const __m256i d = _mm256_set1_epi64x((int64_t)delta);
    if (direction > 0) {
        int i = n;
        for (; i >= 4; i -= 4) {
            __m256i v = _mm256_loadu_si256((const __m256i *)(p+i-4));
            _mm256_storeu_si256((__m256i *)(p+i-3), _mm256_add_epi64(v,d));
        }
        while (i > 0) { --i; p[i+1] = p[i]+delta; }
    } else {
        int i=0, offset = direction < 0;
        for (; i+4 <= n; i+=4) {
            __m256i v = _mm256_loadu_si256((const __m256i *)(p+i+offset));
            _mm256_storeu_si256((__m256i *)(p+i), _mm256_add_epi64(v,d));
        }
        for (; i<n; ++i) p[i] = p[i+offset]+delta;
    }
}
__attribute__((target("avx2")))
static void cplib_sum_adjust_avx2(int32_t *sizes, uint64_t *sums, int n, int sizeDelta, uint64_t delta) {
    const __m256i d = _mm256_set1_epi64x((int64_t)delta);
    const __m128i sd = _mm_set1_epi32(sizeDelta);
    int i=0;
    for (;i+4<=n;i+=4) {
        __m256i v = _mm256_loadu_si256((const __m256i *)(sums+i));
        _mm256_storeu_si256((__m256i *)(sums+i),_mm256_add_epi64(v,d));
        if(sizeDelta) {
            __m128i s = _mm_loadu_si128((const __m128i *)(sizes+i));
            _mm_storeu_si128((__m128i *)(sizes+i),_mm_add_epi32(s,sd));
        }
    }
    for(;i<n;++i) { sizes[i]+=sizeDelta; sums[i]+=delta; }
}
#else
#define CPLIB_SUM_AVX2 0
#endif
#ifdef __cplusplus
extern "C" {
#endif
void cplib_sum_shift(uint64_t *p, int n, uint64_t delta, int direction, int avx2) {
#if CPLIB_SUM_AVX2
    if (avx2) { cplib_sum_shift_avx2(p,n,delta,direction); return; }
#endif
    if (direction > 0) {
        for (int i=n; i>0; ) { --i; p[i+1]=p[i]+delta; }
    } else {
        int offset = direction < 0;
        for (int i=0; i<n; ++i) p[i]=p[i+offset]+delta;
    }
}
void cplib_sum_adjust(int32_t *sizes, uint64_t *sums, int n, int sizeDelta, uint64_t delta, int avx2) {
#if CPLIB_SUM_AVX2
    if(avx2) { cplib_sum_adjust_avx2(sizes,sums,n,sizeDelta,delta); return; }
#endif
    for(int i=0;i<n;++i) { sizes[i]+=sizeDelta; sums[i]+=delta; }
}
#ifdef __cplusplus
}
#endif
""".}
    proc sumShiftRaw*(p: ptr uint64, n: cint, delta: uint64, direction, avx2: cint) {.importc: "cplib_sum_shift".}
        ## 累積和の加算と左右への移動を同時に行う。内部専用、容量は呼出側が保証する。
    proc sumAdjustRaw*(sizes: ptr int32, sums: ptr uint64, n, sizeDelta: cint, delta: uint64, avx2: cint) {.importc: "cplib_sum_adjust".}
        ## 内部ノードの累積個数・累積和の差分を同時に反映する。内部専用。
