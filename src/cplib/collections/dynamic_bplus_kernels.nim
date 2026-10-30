when not declared CPLIB_COLLECTIONS_DYNAMIC_BPLUS_KERNELS:
    const CPLIB_COLLECTIONS_DYNAMIC_BPLUS_KERNELS* = 1
    import bitops

    type BPlusKernel* = enum
        bpkScalar, bpkAvx2, bpkAvx512, bpkAuto

    when not defined(cplibDynamicBitVectorPortable) and (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
        {.emit: """
#include <immintrin.h>
#include <stdint.h>
static int cplib_bplus_support(int k) {
    __builtin_cpu_init();
    if (k == 1) return __builtin_cpu_supports("avx2") && __builtin_cpu_supports("popcnt");
    if (k == 2) return __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw") && __builtin_cpu_supports("popcnt");
    return __builtin_cpu_supports("popcnt") != 0;
}
__attribute__((target("popcnt")))
static int cplib_bplus_pop(const uint64_t *p, int n) {
    int s = 0;
    for (int i = 0; i < n; ++i) s += __builtin_popcountll(p[i]);
    return s;
}
__attribute__((target("avx2,popcnt")))
static int cplib_bplus_pop2(const uint64_t *p, int n) {
    const __m256i lut = _mm256_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4);
    const __m256i mask = _mm256_set1_epi8(15);
    __m256i sum = _mm256_setzero_si256();
    int i = 0, s = 0;
    for (; i + 4 <= n; i += 4) {
        __m256i x = _mm256_loadu_si256((const __m256i *)(p+i));
        __m256i a = _mm256_shuffle_epi8(lut, _mm256_and_si256(x,mask));
        __m256i b = _mm256_shuffle_epi8(lut, _mm256_and_si256(_mm256_srli_epi16(x,4),mask));
        sum = _mm256_add_epi64(sum, _mm256_sad_epu8(_mm256_add_epi8(a,b),_mm256_setzero_si256()));
    }
    uint64_t t[4]; _mm256_storeu_si256((__m256i *)t,sum);
    s = (int)(t[0]+t[1]+t[2]+t[3]);
    for (; i < n; ++i) s += __builtin_popcountll(p[i]);
    return s;
}
__attribute__((target("avx512f,avx512bw,popcnt")))
static int cplib_bplus_pop512(const uint64_t *p, int n) {
    const __m512i lut = _mm512_broadcast_i32x4(_mm_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4));
    const __m512i mask = _mm512_set1_epi8(15);
    __m512i sum = _mm512_setzero_si512();
    int i = 0, s;
    for (; i + 8 <= n; i += 8) {
        __m512i x = _mm512_loadu_si512((const void *)(p+i));
        __m512i a = _mm512_shuffle_epi8(lut,_mm512_and_si512(x,mask));
        __m512i b = _mm512_shuffle_epi8(lut,_mm512_and_si512(_mm512_srli_epi16(x,4),mask));
        sum = _mm512_add_epi64(sum,_mm512_sad_epu8(_mm512_add_epi8(a,b),_mm512_setzero_si512()));
    }
    s = (int)_mm512_reduce_add_epi64(sum);
    for (; i < n; ++i) s += __builtin_popcountll(p[i]);
    return s;
}
__attribute__((target("avx2")))
static int cplib_bplus_find2(const int32_t *p, int n, int32_t x) {
    int i = 0;
    for (; i + 8 <= n; i += 8) {
        unsigned m = (unsigned)_mm256_movemask_ps(_mm256_castsi256_ps(_mm256_cmpgt_epi32(_mm256_loadu_si256((const __m256i *)(p+i)),_mm256_set1_epi32(x))));
        if (m) return i + __builtin_ctz(m);
    }
    for (; i < n; ++i) if (p[i] > x) return i;
    return n;
}
__attribute__((target("avx512f")))
static int cplib_bplus_find512(const int32_t *p, int n, int32_t x) {
    int i = 0;
    for (; i + 16 <= n; i += 16) {
        unsigned m = _mm512_cmpgt_epi32_mask(_mm512_loadu_si512((const void *)(p+i)),_mm512_set1_epi32(x));
        if (m) return i + __builtin_ctz(m);
    }
    for (; i < n; ++i) if (p[i] > x) return i;
    return n;
}
__attribute__((target("avx2")))
static void cplib_bplus_add2(int32_t *p, int n, int32_t x) {
    int i=0;
    for (;i+8<=n;i+=8) _mm256_storeu_si256((__m256i *)(p+i),_mm256_add_epi32(_mm256_loadu_si256((const __m256i *)(p+i)),_mm256_set1_epi32(x)));
    for (;i<n;++i) p[i]+=x;
}
__attribute__((target("avx512f")))
static void cplib_bplus_add512(int32_t *p, int n, int32_t x) {
    int i=0;
    for (;i+16<=n;i+=16) _mm512_storeu_si512((void *)(p+i),_mm512_add_epi32(_mm512_loadu_si512((const void *)(p+i)),_mm512_set1_epi32(x)));
    for (;i<n;++i) p[i]+=x;
}
""".}
        proc supported(k: cint): cint {.importc: "cplib_bplus_support", nodecl.}
        proc popScalar(p: ptr uint64, n: cint): cint {.importc: "cplib_bplus_pop", nodecl.}
        proc pop2(p: ptr uint64, n: cint): cint {.importc: "cplib_bplus_pop2", nodecl.}
        proc pop512(p: ptr uint64, n: cint): cint {.importc: "cplib_bplus_pop512", nodecl.}
        proc find2(p: ptr int32, n, x: cint): cint {.importc: "cplib_bplus_find2", nodecl.}
        proc find512(p: ptr int32, n, x: cint): cint {.importc: "cplib_bplus_find512", nodecl.}
        proc add2(p: ptr int32, n, x: cint) {.importc: "cplib_bplus_add2", nodecl.}
        proc add512(p: ptr int32, n, x: cint) {.importc: "cplib_bplus_add512", nodecl.}
        let hasPopcnt = supported(0) != 0

    proc kernelAvailable*(k: BPlusKernel): bool =
        ## OS の拡張レジスタ対応も含め、指定 ISA を実行可能か返す。
        when not defined(cplibDynamicBitVectorPortable) and (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
            if k in {bpkAvx2, bpkAvx512}: return supported(cint(ord(k))) != 0
        else:
            if k in {bpkAvx2, bpkAvx512}: return false
        return true

    proc resolveKernel*(k: BPlusKernel): BPlusKernel =
        ## 非対応 ISA は scalar に戻す。auto は実測に基づく保守的な scalar を選ぶ。
        if k == bpkAuto or not kernelAvailable(k): bpkScalar else: k

    proc wordPopcount*(p: ptr uint64, n: int, k: BPlusKernel): int =
        ## n ワードの 1 の個数を O(n) で返す。k は resolveKernel 済みとする。
        when not defined(cplibDynamicBitVectorPortable) and (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
            case k
            of bpkAvx2: return int(pop2(p, cint(n)))
            of bpkAvx512: return int(pop512(p, cint(n)))
            else:
                if hasPopcnt: return int(popScalar(p, cint(n)))
        let a = cast[ptr UncheckedArray[uint64]](p)
        for i in 0..<n: result += popcount(a[i])

    proc prefixFind*(p: ptr int32, n, x: int, k: BPlusKernel): int =
        ## 単調な累積和で初めて x を超える位置を O(n) で返す。
        when not defined(cplibDynamicBitVectorPortable) and (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
            case k
            of bpkAvx2: return int(find2(p, cint(n), cint(x)))
            of bpkAvx512: return int(find512(p, cint(n), cint(x)))
            else: discard
        let a = cast[ptr UncheckedArray[int32]](p)
        while result < n and int(a[result]) <= x: inc result

    proc prefixAdd*(p: ptr int32, n, delta: int, k: BPlusKernel) =
        ## 累積和の連続部分に delta を O(n) で加える。
        when not defined(cplibDynamicBitVectorPortable) and (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
            case k
            of bpkAvx2:
                add2(p, cint(n), cint(delta))
                return
            of bpkAvx512:
                add512(p, cint(n), cint(delta))
                return
            else: discard
        let a = cast[ptr UncheckedArray[int32]](p)
        for i in 0..<n: a[i] += int32(delta)
