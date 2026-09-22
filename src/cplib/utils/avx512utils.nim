## 整数配列の要素ごとの加減算・min/max・AND/OR/XORと、全体のmin/max。
## int/uintおよび8・16・32・64bit整数に対応し、加減算はビット幅で折り返す。
## array入力の2引数版はarray、openArray/seq入力は新しいseqを返す。
## 3引数版はdstを再利用する。入力とdstは完全に同じ領域でもよいが、
## 開始位置の異なる部分的な重なりは不可。長さの不一致と空列の集約はValueError。
## x86のGCC/Clangでは実行時にAVX-512F（8/16bitはBWも）を確認する。
## 非対応環境と-d:avx512utilsScalar指定時は通常のループに切り替える。
## nim c / nim cppに対応。-mavx512fなどをプログラム全体に指定する必要はない。

when not declared CPLIB_UTILS_AVX512UTILS:
    const CPLIB_UTILS_AVX512UTILS* = 1

    type Avx512Integer* = int8 | uint8 | int16 | uint16 | int32 | uint32 | int64 | uint64 | int | uint

    when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)) and not defined(avx512utilsScalar):
        const avx512utilsNative = true
        {.emit: """
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#ifdef __cplusplus
extern "C" {
#endif

int cplib_avx512_available(int bytes) {
    // OSのレジスタ保存対応も含め、必要な命令セットを確認する。O(1)。
    return __builtin_cpu_supports("avx512f") &&
        (bytes >= 4 || __builtin_cpu_supports("avx512bw"));
}

#define CPLIB_AVX_BINARY_CASE(T, BITS, OP, EXPR) \
    case OP: \
        for (; i + lanes <= n; i += lanes) { \
            __m512i x = _mm512_loadu_si512((const void*)(a + i * sizeof(T))); \
            __m512i y = _mm512_loadu_si512((const void*)(b + i * sizeof(T))); \
            _mm512_storeu_si512((void*)(d + i * sizeof(T)), EXPR); \
        } \
        if (i < n) { \
            uint64_t mask = UINT64_MAX >> (64 - (n - i)); \
            __m512i x = _mm512_maskz_loadu_epi##BITS(mask, (const void*)(a + i * sizeof(T))); \
            __m512i y = _mm512_maskz_loadu_epi##BITS(mask, (const void*)(b + i * sizeof(T))); \
            _mm512_mask_storeu_epi##BITS((void*)(d + i * sizeof(T)), mask, EXPR); \
        } \
        break;

#define CPLIB_AVX_KERNEL(NAME, T, BITS, SUFFIX, TARGET) \
__attribute__((target(TARGET))) \
void cplib_avx512_##NAME(void *aa, void *bb, void *dd, size_t n, int op) { \
    /* 同じ位置の整数演算を行い、端数はマスク付き命令で処理する。O(n)。 */ \
    const unsigned char *a = (const unsigned char*)aa, *b = (const unsigned char*)bb; \
    unsigned char *d = (unsigned char*)dd; \
    const size_t lanes = 64 / sizeof(T); \
    size_t i = 0; \
    switch (op) { \
        CPLIB_AVX_BINARY_CASE(T, BITS, 0, _mm512_add_epi##BITS(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 1, _mm512_sub_epi##BITS(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 2, _mm512_min_##SUFFIX(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 3, _mm512_max_##SUFFIX(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 4, _mm512_and_si512(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 5, _mm512_or_si512(x, y)) \
        CPLIB_AVX_BINARY_CASE(T, BITS, 6, _mm512_xor_si512(x, y)) \
    } \
} \
__attribute__((target(TARGET))) \
void cplib_avx512_reduce_##NAME(void *aa, void *dd, size_t n, int maximum) { \
    /* 複数レーンのmin/maxを集約する。n>0、O(n)。 */ \
    const unsigned char *a = (const unsigned char*)aa; \
    const size_t lanes = 64 / sizeof(T); \
    size_t i = 0; T best; memcpy(&best, a, sizeof(T)); \
    if (n >= lanes) { \
        __m512i v = _mm512_loadu_si512((const void*)a); \
        i = lanes; \
        if (maximum) { \
            for (; i + lanes <= n; i += lanes) \
                v = _mm512_max_##SUFFIX(v, _mm512_loadu_si512((const void*)(a + i * sizeof(T)))); \
        } else { \
            for (; i + lanes <= n; i += lanes) \
                v = _mm512_min_##SUFFIX(v, _mm512_loadu_si512((const void*)(a + i * sizeof(T)))); \
        } \
        T values[64 / sizeof(T)]; _mm512_storeu_si512((void*)values, v); \
        for (size_t j = 0; j < lanes; ++j) \
            if (maximum ? values[j] > best : values[j] < best) best = values[j]; \
    } \
    for (; i < n; ++i) { \
        T x; memcpy(&x, a + i * sizeof(T), sizeof(T)); \
        if (maximum ? x > best : x < best) best = x; \
    } \
    memcpy(dd, &best, sizeof(T)); \
}
CPLIB_AVX_KERNEL(i8, int8_t, 8, epi8, "avx512f,avx512bw")
CPLIB_AVX_KERNEL(u8, uint8_t, 8, epu8, "avx512f,avx512bw")
CPLIB_AVX_KERNEL(i16, int16_t, 16, epi16, "avx512f,avx512bw")
CPLIB_AVX_KERNEL(u16, uint16_t, 16, epu16, "avx512f,avx512bw")
CPLIB_AVX_KERNEL(i32, int32_t, 32, epi32, "avx512f")
CPLIB_AVX_KERNEL(u32, uint32_t, 32, epu32, "avx512f")
CPLIB_AVX_KERNEL(i64, int64_t, 64, epi64, "avx512f")
CPLIB_AVX_KERNEL(u64, uint64_t, 64, epu64, "avx512f")
#undef CPLIB_AVX_KERNEL
#undef CPLIB_AVX_BINARY_CASE
#ifdef __cplusplus
}
#endif
""".}
        proc nativeAvailable(bytes: cint): cint {.importc: "cplib_avx512_available".}
        proc binaryi8(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_i8".}
        proc reducei8(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_i8".}
        proc binaryu8(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_u8".}
        proc reduceu8(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_u8".}
        proc binaryi16(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_i16".}
        proc reducei16(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_i16".}
        proc binaryu16(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_u16".}
        proc reduceu16(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_u16".}
        proc binaryi32(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_i32".}
        proc reducei32(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_i32".}
        proc binaryu32(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_u32".}
        proc reduceu32(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_u32".}
        proc binaryi64(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_i64".}
        proc reducei64(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_i64".}
        proc binaryu64(a, b, dst: pointer, n: csize_t, op: cint) {.importc: "cplib_avx512_u64".}
        proc reduceu64(a, dst: pointer, n: csize_t, maximum: cint) {.importc: "cplib_avx512_reduce_u64".}
    else:
        const avx512utilsNative = false

    proc avx512Available*[T: Avx512Integer](): bool {.inline.} =
        ## 型Tに必要なAVX-512とOSの対応状況を返す。O(1)。
        when avx512utilsNative:
            nativeAvailable(cint(sizeof(T))) != 0
        else:
            false

    template scalarBinary(x, y: typed, op: static[int]): untyped =
        when op == 0:
            when x is SomeUnsignedInt: x + y
            else: x +% y
        elif op == 1:
            when x is SomeUnsignedInt: x - y
            else: x -% y
        elif op == 2: min(x, y)
        elif op == 3: max(x, y)
        elif op == 4: x and y
        elif op == 5: x or y
        else: x xor y

    proc binaryImpl[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T], op: static[int]) {.inline.} =
        ## 長さを検査し、SIMDまたは通常のループで演算する。O(n)。
        if a.len != b.len or a.len != dst.len:
            raise newException(ValueError, "入力と出力の長さが一致していません")
        if a.len == 0: return
        when avx512utilsNative:
            if avx512Available[T]():
                when sizeof(T) == 1:
                    when T is SomeUnsignedInt:
                        binaryu8(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                    else:
                        binaryi8(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                elif sizeof(T) == 2:
                    when T is SomeUnsignedInt:
                        binaryu16(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                    else:
                        binaryi16(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                elif sizeof(T) == 4:
                    when T is SomeUnsignedInt:
                        binaryu32(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                    else:
                        binaryi32(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                elif sizeof(T) == 8:
                    when T is SomeUnsignedInt:
                        binaryu64(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                    else:
                        binaryi64(unsafeAddr a[0], unsafeAddr b[0], addr dst[0], csize_t(a.len), cint(op))
                return
        for i in 0..<a.len:
            dst[i] = scalarBinary(a[i], b[i], op)

    proc reduceImpl[T: Avx512Integer](a: openArray[T], maximum: static[bool]): T {.inline.} =
        ## 空列を拒否し、全体のmin/maxを求める。O(n)。
        if a.len == 0:
            raise newException(ValueError, "空列の最小値・最大値は求められません")
        when avx512utilsNative:
            if avx512Available[T]():
                when sizeof(T) == 1:
                    when T is SomeUnsignedInt:
                        reduceu8(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                    else:
                        reducei8(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                elif sizeof(T) == 2:
                    when T is SomeUnsignedInt:
                        reduceu16(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                    else:
                        reducei16(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                elif sizeof(T) == 4:
                    when T is SomeUnsignedInt:
                        reduceu32(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                    else:
                        reducei32(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                elif sizeof(T) == 8:
                    when T is SomeUnsignedInt:
                        reduceu64(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                    else:
                        reducei64(unsafeAddr a[0], addr result, csize_t(a.len), cint(maximum))
                return
        result = a[0]
        for i in 1..<a.len:
            when maximum: result = max(result, a[i])
            else: result = min(result, a[i])

    proc avx512Add*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素の加算をdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 0)

    proc avx512Add*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素の加算を新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 0)

    proc avx512Add*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素の加算を同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 0)

    proc avx512Sub*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素の減算をdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 1)

    proc avx512Sub*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素の減算を新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 1)

    proc avx512Sub*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素の減算を同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 1)

    proc avx512Min*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素の最小値をdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 2)

    proc avx512Min*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素の最小値を新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 2)

    proc avx512Min*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素の最小値を同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 2)

    proc avx512Max*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素の最大値をdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 3)

    proc avx512Max*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素の最大値を新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 3)

    proc avx512Max*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素の最大値を同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 3)

    proc avx512And*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素のビットANDをdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 4)

    proc avx512And*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素のビットANDを新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 4)

    proc avx512And*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素のビットANDを同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 4)

    proc avx512Or*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素のビットORをdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 5)

    proc avx512Or*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素のビットORを新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 5)

    proc avx512Or*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素のビットORを同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 5)

    proc avx512Xor*[T: Avx512Integer](a, b: openArray[T], dst: var openArray[T]) {.inline.} =
        ## 各要素のビットXORをdstに格納する。O(n)、追加領域O(1)。完全な同一領域への上書きも可能。
        binaryImpl(a, b, dst, 6)

    proc avx512Xor*[T: Avx512Integer](a, b: openArray[T]): seq[T] =
        ## 各要素のビットXORを新しいseqで返す。時間・追加領域O(n)。
        if a.len != b.len:
            raise newException(ValueError, "入力の長さが一致していません")
        result = newSeq[T](a.len)
        binaryImpl(a, b, result, 6)

    proc avx512Xor*[I; T: Avx512Integer](a, b: array[I, T]): array[I, T] =
        ## 各要素のビットXORを同じ型のarrayで返す。時間・追加領域O(n)。
        binaryImpl(a, b, result, 6)

    proc avx512Min*[T: Avx512Integer](a: openArray[T]): T {.inline.} =
        ## 全要素の最小値を返す。O(n)、追加領域O(1)。空列はValueError。
        reduceImpl(a, false)

    proc avx512Max*[T: Avx512Integer](a: openArray[T]): T {.inline.} =
        ## 全要素の最大値を返す。O(n)、追加領域O(1)。空列はValueError。
        reduceImpl(a, true)
