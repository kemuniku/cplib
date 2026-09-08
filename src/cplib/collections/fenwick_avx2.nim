## 16分岐の累積和木による、64bit整数用のFenwick treeの多分岐版です。
## amd64のAVX2対応CPUとGCC/Clangが必要です。C/C++バックエンドに対応します。
## 添字は0始まり、区間は半開区間です。整数演算は2^64を法とします。
when not declared CPLIB_COLLECTIONS_FENWICK_AVX2:
    const CPLIB_COLLECTIONS_FENWICK_AVX2* = 1
    when not (defined(amd64) and (defined(gcc) or defined(clang))):
        {.error: "FenwickTreeAvx2 requires amd64 and GCC/Clang".}

    type FenwickTreeAvx2* = object
        size: int
        height: int
        offsets: array[16, int]
        data: seq[uint64]

    {.emit: """
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>

static void cplib_fw16_build(uint64_t *data, const NI *offsets, NI height, NI n) {
    /* 下段を累積和に変換しながら、完全な16要素ブロックの和を上段へ渡します。 */
    for (NI h = 0; h < height; ++h, n >>= 4) {
        uint64_t *base = data + offsets[h];
        uint64_t sum = 0;
        for (NI i = 0; i <= n; ++i) {
            if (!(i & 15)) {
                if (i) data[offsets[h + 1] + (i >> 4) - 1] = sum;
                sum = 0;
            }
            uint64_t value = base[i];
            base[i] = sum;
            sum += value;
        }
    }
}

__attribute__((target("avx2")))
static void cplib_fw16_add(uint64_t *data, const NI *offsets,
                           NI height, NI index, uint64_t delta) {
    /* 各段の16個の累積和を4要素ずつ更新します。 */
    const __m256i value = _mm256_set1_epi64x((long long)delta);
    for (NI h = 0; h < height; ++h, index >>= 4) {
        uint64_t *base = data + offsets[h] + (index & ~(NI)15);
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

static uint64_t cplib_fw16_prefix(const uint64_t *data, const NI *offsets, NI r) {
    /* 各段から1個ずつ累積和を読み出します。 */
    uint64_t sum = 0;
    for (NI h = 0; r; ++h, r >>= 4) sum += data[offsets[h] + r];
    return sum;
}
static uint64_t cplib_fw16_get(const uint64_t *data, const NI *offsets, NI l, NI r) {
    /* 左右の読み出しを並列化し、同じ祖先に達したら終了します。 */
    uint64_t sum = 0;
    for (NI h = 0; l != r; ++h, l >>= 4, r >>= 4)
        sum += data[offsets[h] + r] - data[offsets[h] + l];
    return sum;
}

""".}

    proc fw16Add(data: ptr uint64, offsets: ptr int, height, index: int,
            delta: uint64) {.importc: "cplib_fw16_add", nodecl.}
    proc fw16Build(data: ptr uint64, offsets: ptr int, height, n: int)
        {.importc: "cplib_fw16_build", nodecl.}
    proc fw16Prefix(data: ptr uint64, offsets: ptr int, r: int): uint64
        {.importc: "cplib_fw16_prefix", nodecl.}
    proc fw16Get(data: ptr uint64, offsets: ptr int, l, r: int): uint64
        {.importc: "cplib_fw16_get", nodecl.}

    proc addBits(self: var FenwickTreeAvx2, p: int, delta: uint64) =
        ## 別モジュールからも呼べるSIMD更新の入口です。
        fw16Add(addr self.data[0], addr self.offsets[0], self.height, p, delta)

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
        result.data = newSeq[uint64](size + 15)
        # コピー後も正しく動作するよう、SIMD側では非整列ロードを使います。
        let alignment = int((0'u - cast[uint](addr result.data[0])) and 127) shr 3
        for h in 0..<result.height:
            result.offsets[h] += alignment

    proc initFenwickTreeAvx2*[T: SomeInteger](values: openArray[T]): FenwickTreeAvx2 =
        ## 配列からO(n)時間・領域で構築します。符号付き・符号なし整数に対応します。
        result = initFenwickTreeAvx2(values.len)
        when sizeof(T) == sizeof(uint64):
            if values.len > 0:
                copyMem(addr result.data[result.offsets[0]], unsafeAddr values[0],
                    values.len * sizeof(uint64))
        else:
            for i, value in values:
                result.data[result.offsets[0] + i] = cast[uint64](value.uint64)
        result.build()

    proc len*(self: FenwickTreeAvx2): int {.inline.} =
        ## 要素数をO(1)で返します。
        self.size

    proc add*[T: SomeInteger](self: var FenwickTreeAvx2, p: int, delta: T) {.inline.} =
        ## a[p]にdeltaを加えます。O(log_16 n)回のSIMD更新を行います。
        assert 0 <= p and p < self.size
        self.addBits(p, cast[uint64](delta.uint64))

    proc prefixUnsigned*(self: FenwickTreeAvx2, r: int): uint64 =
        ## [0, r)の和をuint64としてO(log_16 n)で返します。
        assert 0 <= r and r <= self.size
        if r == 0: return 0
        fw16Prefix(unsafeAddr self.data[0], unsafeAddr self.offsets[0], r)

    proc prefix*(self: FenwickTreeAvx2, r: int): int64 {.inline.} =
        ## [0, r)の和をint64としてO(log_16 n)で返します。
        cast[int64](self.prefixUnsigned(r))

    proc getUnsigned*(self: FenwickTreeAvx2, l, r: int): uint64 =
        ## [l, r)の和をuint64としてO(log_16 n)で返します。
        assert 0 <= l and l <= r and r <= self.size
        if l == r: return 0
        fw16Get(unsafeAddr self.data[0], unsafeAddr self.offsets[0], l, r)

    proc get*(self: FenwickTreeAvx2, l, r: int): int64 {.inline.} =
        ## [l, r)の和をint64としてO(log_16 n)で返します。
        cast[int64](self.getUnsigned(l, r))

    proc `[]`*(self: FenwickTreeAvx2, segment: HSlice[int, int]): int64 {.inline.} =
        ## スライスの和をO(log_16 n)で返します。
        self.get(segment.a, segment.b + 1)

    proc `[]`*(self: FenwickTreeAvx2, p: int): int64 {.inline.} =
        ## a[p]をO(log_16 n)で返します。
        self.get(p, p + 1)

    proc `[]=`*[T: SomeInteger](self: var FenwickTreeAvx2, p: int, value: T) {.inline.} =
        ## a[p]をvalueに変更します。O(log_16 n)です。
        self.add(p, cast[uint64](value.uint64) - self.getUnsigned(p, p + 1))
