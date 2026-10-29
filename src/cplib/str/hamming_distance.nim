## 各バイトを1文字とするハミング距離。入力は同じ長さである必要があります。
## x86のGCC/ClangではAVX-512BW、AVX2、通常ループの順に実行時に選択します。
## -d:hammingDistanceScalarで通常版、-d:hammingDistanceAvx2でAVX-512を無効にできます。
## nim c / nim cppに対応し、全体への-mavx512bwなどの指定は不要です。
when not declared CPLIB_STR_HAMMING_DISTANCE:
    const CPLIB_STR_HAMMING_DISTANCE* = 1

    when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)) and not defined(hammingDistanceScalar):
        {.emit: """
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
#ifdef __cplusplus
extern "C" {
#endif

__attribute__((target("avx2,popcnt")))
static size_t cplib_hamming_avx2(const unsigned char *s, const unsigned char *t, size_t n) {
    /* 32バイトずつ比較し、不一致数を加算する。O(n)。 */
    size_t i = 0, count = 0;
    for (; n - i >= 32; i += 32) {
        __m256i a = _mm256_loadu_si256((const __m256i *)(s + i));
        __m256i b = _mm256_loadu_si256((const __m256i *)(t + i));
        unsigned int mask = (unsigned int)_mm256_movemask_epi8(_mm256_cmpeq_epi8(a, b));
        count += 32 - __builtin_popcount(mask);
    }
    for (; i < n; ++i) count += s[i] != t[i];
    return count;
}

__attribute__((target("avx512f,avx512bw,popcnt")))
static size_t cplib_hamming_avx512(const unsigned char *s, const unsigned char *t, size_t n) {
    /* 64バイトずつ比較し、端数はマスク付きロードで範囲内だけ読む。O(n)。 */
    size_t i = 0, count = 0;
    for (; n - i >= 64; i += 64) {
        __m512i a = _mm512_loadu_si512((const void *)(s + i));
        __m512i b = _mm512_loadu_si512((const void *)(t + i));
        count += __builtin_popcountll((unsigned long long)_mm512_cmpneq_epi8_mask(a, b));
    }
    if (i < n) {
        __mmask64 valid = (__mmask64)((UINT64_C(1) << (n - i)) - 1);
        __m512i a = _mm512_maskz_loadu_epi8(valid, (const void *)(s + i));
        __m512i b = _mm512_maskz_loadu_epi8(valid, (const void *)(t + i));
        count += __builtin_popcountll((unsigned long long)(_mm512_cmpneq_epi8_mask(a, b) & valid));
    }
    return count;
}

size_t cplib_hamming_distance(void *ss, void *tt, size_t n, int avx512) {
    /* CPUとOSが対応する命令セットで距離を求める。O(n)。 */
    const unsigned char *s = (const unsigned char *)ss;
    const unsigned char *t = (const unsigned char *)tt;
    if (__builtin_cpu_supports("popcnt")) {
        if (avx512 && n >= 64 && __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw"))
            return cplib_hamming_avx512(s, t, n);
        if (__builtin_cpu_supports("avx2"))
            return cplib_hamming_avx2(s, t, n);
    }
    size_t count = 0;
    for (size_t i = 0; i < n; ++i) count += s[i] != t[i];
    return count;
}
#ifdef __cplusplus
}
#endif
""".}
        proc hammingDistanceRaw(s, t: pointer, n: csize_t, avx512: cint): csize_t
            {.importc: "cplib_hamming_distance".}

    proc hammingDistance*(s, t: openArray[char]): int {.inline.} =
        ## バイト単位のハミング距離を時間O(N)、追加空間O(1)で返す。長さの不一致はValueError。
        if s.len != t.len:
            raise newException(ValueError, "文字列の長さが一致しません")
        when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)) and not defined(hammingDistanceScalar):
            if s.len >= 32:
                return int(hammingDistanceRaw(unsafeAddr s[0], unsafeAddr t[0],
                    csize_t(s.len), cint(not defined(hammingDistanceAvx2))))
        for i in 0..<s.len:
            result += int(s[i] != t[i])
