when not declared CPLIB_COLLECTIONS_FENWICK_AVX2:
    const CPLIB_COLLECTIONS_FENWICK_AVX2* = 1
    when not (defined(amd64) and (defined(gcc) or defined(clang))):
        {.error: "FenwickTreeAvx2 requires amd64 and GCC/Clang".}

    type FenwickTreeAvx2* = object
        size: int
        height: int
        offsets: array[16, int]
        data: seq[int]

    {.emit: """
#include <immintrin.h>
#include <stddef.h>

static NI cplib_fw16_sum(NI a, NI b) {
    /* SIMDと同じ桁あふれ動作を、符号付き整数の未定義動作なしで行います。 */
    NI value;
    __builtin_add_overflow(a, b, &value);
    return value;
}
static NI cplib_fw16_diff(NI a, NI b) {
    /* 減算も下位64bitを保持します。 */
    NI value;
    __builtin_sub_overflow(a, b, &value);
    return value;
}

static void cplib_fw16_build(NI *data, const NI *offsets, NI height, NI n) {
    /* 下段を累積和に変換しながら、完全な16要素ブロックの和を上段へ渡します。 */
    for (NI h = 0; h < height; ++h, n >>= 4) {
        NI *base = data + offsets[h];
        NI sum = 0;
        for (NI i = 0; i <= n; ++i) {
            if (!(i & 15)) {
                if (i) data[offsets[h + 1] + (i >> 4) - 1] = sum;
                sum = 0;
            }
            NI value = base[i];
            base[i] = sum;
            sum = cplib_fw16_sum(sum, value);
        }
    }
}

__attribute__((target("avx2")))
static void cplib_fw16_add(NI *data, const NI *offsets,
                           NI height, NI index, NI delta) {
    /* 各段の16個の累積和を4要素ずつ更新します。 */
    const __m256i value = _mm256_set1_epi64x((long long)delta);
    for (NI h = 0; h < height; ++h, index >>= 4) {
        NI *base = data + offsets[h] + (index & ~(NI)15);
        const __m256i pos = _mm256_set1_epi64x(index & 15);
        for (int k = 0; k < 16; k += 4) {
            const __m256i mask = _mm256_cmpgt_epi64(
                _mm256_setr_epi64x(k, k + 1, k + 2, k + 3), pos);
            __m256i *p = (__m256i *)(base + k);
            _mm256_storeu_si256(p, _mm256_add_epi64(
                _mm256_loadu_si256(p), _mm256_and_si256(mask, value)));
        }
    }
}

static NI cplib_fw16_prefix(const NI *data, const NI *offsets, NI r) {
    /* 各段から1個ずつ累積和を読み出します。 */
    NI sum = 0;
    for (NI h = 0; r; ++h, r >>= 4) sum = cplib_fw16_sum(sum, data[offsets[h] + r]);
    return sum;
}
static NI cplib_fw16_get(const NI *data, const NI *offsets, NI l, NI r) {
    /* 左右の読み出しを並列化し、同じ祖先に達したら終了します。 */
    NI sum = 0;
    for (NI h = 0; l != r; ++h, l >>= 4, r >>= 4)
        sum = cplib_fw16_sum(sum, cplib_fw16_diff(data[offsets[h] + r], data[offsets[h] + l]));
    return sum;
}

""".}

    proc fw16Add(data: ptr int, offsets: ptr int, height, index: int,
            delta: int) {.importc: "cplib_fw16_add", nodecl.}
    proc fw16Build(data: ptr int, offsets: ptr int, height, n: int)
        {.importc: "cplib_fw16_build", nodecl.}
    proc fw16Prefix(data: ptr int, offsets: ptr int, r: int): int
        {.importc: "cplib_fw16_prefix", nodecl.}
    proc fw16Get(data: ptr int, offsets: ptr int, l, r: int): int
        {.importc: "cplib_fw16_get", nodecl.}

    proc build(self: var FenwickTreeAvx2) =
        ## 初期値を格納済みの配列から、全段の累積和をO(n)で構築します。
        fw16Build(addr self.data[0], addr self.offsets[0], self.height, self.size)

    proc initFenwickTreeAvx2*(n: int): FenwickTreeAvx2 =
        ## 長さnの零配列から構築します。O(n)時間、約16n/15個の64bit整数を使います。
        assert n >= 0
        result.size = n
        var m = n
        var size = 0
        while true:
            result.offsets[result.height] = size
            inc result.height
            size += (m + 16) and not 15
            m = m shr 4
            if m == 0: break
        result.data = newSeq[int](size + 15)
        # コピー後も正しく動作するよう、SIMD側では非整列ロードを使います。
        let alignment = int((0'u - cast[uint](addr result.data[0])) and 127) shr 3
        for h in 0..<result.height:
            result.offsets[h] += alignment

    proc initFenwickTreeAvx2*(values: openArray[int]): FenwickTreeAvx2 =
        ## int配列からO(n)時間・領域で構築します。
        result = initFenwickTreeAvx2(values.len)
        if values.len > 0:
            copyMem(addr result.data[result.offsets[0]], unsafeAddr values[0],
                values.len * sizeof(int))
        result.build()

    proc len*(self: FenwickTreeAvx2): int {.inline.} =
        ## 要素数をO(1)で返します。
        self.size

    proc add*(self: var FenwickTreeAvx2, p: int, delta: int) =
        ## a[p]にdeltaを加えます。O(log_16 n)回のSIMD更新を行います。
        assert 0 <= p and p < self.size
        fw16Add(addr self.data[0], addr self.offsets[0], self.height, p, delta)

    proc prefix*(self: FenwickTreeAvx2, r: int): int =
        ## [0, r)の和をintとしてO(log_16 n)で返します。
        assert 0 <= r and r <= self.size
        if r == 0: return 0
        fw16Prefix(unsafeAddr self.data[0], unsafeAddr self.offsets[0], r)

    proc get*(self: FenwickTreeAvx2, l, r: int): int =
        ## [l, r)の和をintとしてO(log_16 n)で返します。
        assert 0 <= l and l <= r and r <= self.size
        if l == r: return 0
        fw16Get(unsafeAddr self.data[0], unsafeAddr self.offsets[0], l, r)

    proc `[]`*(self: FenwickTreeAvx2, segment: HSlice[int, int]): int {.inline.} =
        ## スライスの和をO(log_16 n)で返します。
        self.get(segment.a, segment.b + 1)

    proc `[]`*(self: FenwickTreeAvx2, p: int): int {.inline.} =
        ## a[p]をO(log_16 n)で返します。
        self.get(p, p + 1)

    proc `[]=`*(self: var FenwickTreeAvx2, p: int, value: int) {.inline.} =
        ## a[p]をvalueに変更します。O(log_16 n)です。
        self.add(p, value -% self.get(p, p + 1))
