## C++・amd64・GCC/Clangでは符号付き32/64ビット整数をAVX2で処理する。
## AVX2非対応CPUではスカラー処理へ切り替え、他の型とCバックエンドにも対応する。
when not declared CPLIB_COLLECTIONS_STATICRMQ:
    const CPLIB_COLLECTIONS_STATICRMQ* = 1
    import bitops
    # https://maspypy.com/library-checker-static-rmq
    const staticRMQBlockShift = 6
    const staticRMQBlockSize = 1 shl staticRMQBlockShift
    const staticRMQCpp = defined(cpp) and defined(amd64) and (defined(gcc) or defined(clang))
    when staticRMQCpp:
        {.emit: """
#include <immintrin.h>
#include <algorithm>
#include <limits>

namespace cplib_static_rmq {
constexpr NI shift = """ & $staticRMQBlockShift & """;
constexpr NI block_size = NI(1) << shift;
#define CPLIB_RMQ_AVX __attribute__((target("avx2")))

static inline bool avx_available() {
    // AVX2対応CPUか判定し、検証時にはスカラー処理を強制できる。
#ifdef CPLIB_STATIC_RMQ_NO_AVX2
    return false;
#else
    return __builtin_cpu_supports("avx2");
#endif
}

template<int Width> struct Lanes;
template<> struct Lanes<4> {
    CPLIB_RMQ_AVX static inline __m256i minimum(__m256i a, __m256i b) {
        // 符号付き32ビット整数を8個まとめて比較する。
        return _mm256_min_epi32(a, b);
    }
    CPLIB_RMQ_AVX static inline __m256i broadcast(NI32 x) {
        // 同じ値を全レーンに複製する。
        return _mm256_set1_epi32(x);
    }
    CPLIB_RMQ_AVX static inline __m256i reverse(__m256i x) {
        // レーンの順序を反転する。
        return _mm256_permutevar8x32_epi32(x, _mm256_setr_epi32(7,6,5,4,3,2,1,0));
    }
    CPLIB_RMQ_AVX static inline __m256i prefix(__m256i x) {
        // 8レーン内の累積最小値を並列に計算する。
        const __m256i inf = broadcast(std::numeric_limits<NI32>::max());
        __m256i y = _mm256_permutevar8x32_epi32(x, _mm256_setr_epi32(0,0,1,2,3,4,5,6));
        x = minimum(x, _mm256_blend_epi32(inf, y, 0xfe));
        y = _mm256_permutevar8x32_epi32(x, _mm256_setr_epi32(0,0,0,1,2,3,4,5));
        x = minimum(x, _mm256_blend_epi32(inf, y, 0xfc));
        y = _mm256_permutevar8x32_epi32(x, _mm256_setr_epi32(0,0,0,0,0,1,2,3));
        return minimum(x, _mm256_blend_epi32(inf, y, 0xf0));
    }
    CPLIB_RMQ_AVX static inline __m256i last(__m256i x) {
        // 最後のレーンを全レーンに複製する。
        return _mm256_permutevar8x32_epi32(x, _mm256_set1_epi32(7));
    }
    CPLIB_RMQ_AVX static inline NI32 reduce(__m256i x) {
        // 8レーンの最小値を1個の整数にまとめる。
        __m128i y = _mm_min_epi32(_mm256_castsi256_si128(x), _mm256_extracti128_si256(x, 1));
        y = _mm_min_epi32(y, _mm_shuffle_epi32(y, 0x4e));
        y = _mm_min_epi32(y, _mm_shuffle_epi32(y, 0xb1));
        return _mm_cvtsi128_si32(y);
    }
};
template<> struct Lanes<8> {
    CPLIB_RMQ_AVX static inline __m256i minimum(__m256i a, __m256i b) {
        // AVX2にない符号付き64ビット最小値を比較と選択で求める。
        return _mm256_blendv_epi8(a, b, _mm256_cmpgt_epi64(a, b));
    }
    CPLIB_RMQ_AVX static inline __m256i broadcast(NI64 x) {
        // 同じ値を全レーンに複製する。
        return _mm256_set1_epi64x(x);
    }
    CPLIB_RMQ_AVX static inline __m256i reverse(__m256i x) {
        // レーンの順序を反転する。
        return _mm256_permute4x64_epi64(x, 0x1b);
    }
    CPLIB_RMQ_AVX static inline __m256i prefix(__m256i x) {
        // 4レーン内の累積最小値を並列に計算する。
        const __m256i inf = broadcast(std::numeric_limits<NI64>::max());
        __m256i y = _mm256_permute4x64_epi64(x, 0x90);
        x = minimum(x, _mm256_blend_epi32(inf, y, 0xfc));
        y = _mm256_permute4x64_epi64(x, 0x40);
        return minimum(x, _mm256_blend_epi32(inf, y, 0xf0));
    }
    CPLIB_RMQ_AVX static inline __m256i last(__m256i x) {
        // 最後のレーンを全レーンに複製する。
        return _mm256_permute4x64_epi64(x, 0xff);
    }
    CPLIB_RMQ_AVX static inline NI64 reduce(__m256i x) {
        // 4レーンの最小値を1個の整数にまとめる。
        x = minimum(x, _mm256_permute4x64_epi64(x, 0x4e));
        x = minimum(x, _mm256_permute4x64_epi64(x, 0xb1));
        return _mm_cvtsi128_si64(_mm256_castsi256_si128(x));
    }
};

template<class T> CPLIB_RMQ_AVX static T scan(const T* p, NI n) {
    // 区間内だけをロードし、端数は末尾のベクトルと重ねて処理する。
    using V = Lanes<sizeof(T)>;
    constexpr NI width = 32 / sizeof(T);
    __m256i x = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(p));
    for (NI i = width; i + width <= n; i += width)
        x = V::minimum(x, _mm256_loadu_si256(reinterpret_cast<const __m256i*>(p + i)));
    if (n % width != 0)
        x = V::minimum(x, _mm256_loadu_si256(reinterpret_cast<const __m256i*>(p + n - width)));
    return V::reduce(x);
}

template<class T> static void build_scalar(const T* data, T* prefix, T* suffix, T** rows, NI n) {
    // 各ブロックの累積最小値とブロック間のスパーステーブルを構築する。
    T* table = rows[0];
    const NI blocks = ((n - 1) >> shift) + 1;
    for (NI first = 0; first < n; first += block_size) {
        const NI end = std::min(first + block_size, n);
        prefix[first] = data[first];
        for (NI i = first + 1; i < end; ++i) prefix[i] = std::min(prefix[i-1], data[i]);
        suffix[end-1] = data[end-1];
        for (NI i = end - 1; i > first; --i) suffix[i-1] = std::min(suffix[i], data[i-1]);
        table[first >> shift] = prefix[end-1];
    }
    T* previous = table;
    NI level = 1;
    for (NI distance = 1; distance * 2 <= blocks; distance *= 2, ++level) {
        T* next = rows[level];
        const NI length = blocks - distance * 2 + 1;
        for (NI i = 0; i < length; ++i) next[i] = std::min(previous[i], previous[i + distance]);
        previous = next;
    }
}

template<class T> CPLIB_RMQ_AVX static void build_avx(const T* data, T* prefix, T* suffix, T** rows, NI n) {
    // 累積最小値とスパーステーブルの構築をAVX2で並列化する。
    using V = Lanes<sizeof(T)>;
    constexpr NI width = 32 / sizeof(T);
    T* table = rows[0];
    const NI blocks = ((n - 1) >> shift) + 1;
    NI first = 0;
    for (; first + block_size <= n; first += block_size) {
        __m256i carry = V::broadcast(std::numeric_limits<T>::max());
        for (NI i = first; i < first + block_size; i += width) {
            __m256i x = V::prefix(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(data + i)));
            x = V::minimum(x, carry);
            _mm256_storeu_si256(reinterpret_cast<__m256i*>(prefix + i), x);
            carry = V::last(x);
        }
        carry = V::broadcast(std::numeric_limits<T>::max());
        for (NI i = first + block_size; i > first; i -= width) {
            __m256i x = V::reverse(_mm256_loadu_si256(reinterpret_cast<const __m256i*>(data + i - width)));
            x = V::minimum(V::prefix(x), carry);
            _mm256_storeu_si256(reinterpret_cast<__m256i*>(suffix + i - width), V::reverse(x));
            carry = V::last(x);
        }
        table[first >> shift] = prefix[first + block_size - 1];
    }
    if (first < n) {
        prefix[first] = data[first];
        for (NI i = first + 1; i < n; ++i) prefix[i] = std::min(prefix[i-1], data[i]);
        suffix[n-1] = data[n-1];
        for (NI i = n - 1; i > first; --i) suffix[i-1] = std::min(suffix[i], data[i-1]);
        table[first >> shift] = prefix[n-1];
    }
    T* previous = table;
    NI level = 1;
    for (NI distance = 1; distance * 2 <= blocks; distance *= 2, ++level) {
        T* next = rows[level];
        const NI length = blocks - distance * 2 + 1;
        NI i = 0;
        for (; i + width <= length; i += width) {
            __m256i a = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(previous + i));
            __m256i b = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(previous + i + distance));
            _mm256_storeu_si256(reinterpret_cast<__m256i*>(next + i), V::minimum(a, b));
        }
        for (; i < length; ++i) next[i] = std::min(previous[i], previous[i + distance]);
        previous = next;
    }
}

template<class T> static void build(const T* data, T* prefix, T* suffix, T** rows, NI n) {
    // CPUに対応した構築処理を選ぶ。
    if (avx_available()) build_avx(data, prefix, suffix, rows, n);
    else build_scalar(data, prefix, suffix, rows, n);
}

template<class T> static T scan_dispatch(const T* data, NI n) {
    // CPUに対応したブロック内の最小値走査を選ぶ。
    if (avx_available()) return scan(data, n);
    T result = data[0];
    for (NI i = 1; i < n; ++i) result = std::min(result, data[i]);
    return result;
}
#undef CPLIB_RMQ_AVX
}

extern "C" void cplib_static_rmq_build_i32(void* data, void* prefix, void* suffix, void* rows, NI n) {
    // 32ビット整数用の構築処理をNimから呼び出す。
    cplib_static_rmq::build(static_cast<const NI32*>(data), static_cast<NI32*>(prefix),
        static_cast<NI32*>(suffix), static_cast<NI32**>(rows), n);
}
extern "C" void cplib_static_rmq_build_i64(void* data, void* prefix, void* suffix, void* rows, NI n) {
    // 64ビット整数用の構築処理をNimから呼び出す。
    cplib_static_rmq::build(static_cast<const NI64*>(data), static_cast<NI64*>(prefix),
        static_cast<NI64*>(suffix), static_cast<NI64**>(rows), n);
}
extern "C" NI32 cplib_static_rmq_scan_i32(void* data, NI n) {
    // 32ビット整数用の問い合わせをNimから呼び出す。
    return cplib_static_rmq::scan_dispatch(static_cast<const NI32*>(data), n);
}
extern "C" NI64 cplib_static_rmq_scan_i64(void* data, NI n) {
    // 64ビット整数用の問い合わせをNimから呼び出す。
    return cplib_static_rmq::scan_dispatch(static_cast<const NI64*>(data), n);
}
""".}
        proc staticRMQBuild32(data, prefix, suffix, rows: pointer, n: int) {.importc: "cplib_static_rmq_build_i32".}
        proc staticRMQBuild64(data, prefix, suffix, rows: pointer, n: int) {.importc: "cplib_static_rmq_build_i64".}
        proc staticRMQScan32(data: pointer, n: int): int32 {.importc: "cplib_static_rmq_scan_i32", noSideEffect, codegenDecl: "__attribute__((pure)) $# $#$#".}
        proc staticRMQScan64(data: pointer, n: int): int64 {.importc: "cplib_static_rmq_scan_i64", noSideEffect, codegenDecl: "__attribute__((pure)) $# $#$#".}

    when declared(newSeqUninit):
        template staticRMQUninit(T: typedesc, length: int): untyped =
            ## 未初期化の整数列を確保する。
            newSeqUninit[T](length)
    else:
        template staticRMQUninit(T: typedesc, length: int): untyped =
            ## Nim 1.6で未初期化の整数列を確保する。
            newSeqUninitialized[T](length)

    type StaticRMQ*[T] = object
        table: seq[seq[T]]
        prefix_product, suffix_product, V: seq[T]

    proc initRMQ*[T](V: openArray[T]): StaticRMQ[T] =
        ## 配列をコピーし、区間最小値のテーブルを構築する。
        let n = V.len
        if n == 0: return
        result.V = @V
        let blocks = ((n - 1) shr staticRMQBlockShift) + 1
        let levels = fastLog2(blocks) + 1
        template allocate(length: int): seq[T] =
            ## 整数型の実行時構築では直後に全要素を設定するためゼロ初期化を省く。
            when T is int or T is int32 or T is int64:
                when nimvm: newSeq[T](length)
                else: staticRMQUninit(T, length)
            else: newSeq[T](length)
        result.prefix_product = allocate(n)
        result.suffix_product = allocate(n)
        result.table = newSeq[seq[T]](levels)
        for k in 0..<levels:
            result.table[k] = allocate(blocks - (1 shl k) + 1)
        when staticRMQCpp and (T is int or T is int32 or T is int64):
            when nimvm: discard
            else:
                var rows = newSeq[ptr T](levels)
                for k in 0..<levels: rows[k] = addr result.table[k][0]
                when sizeof(T) == 4:
                    staticRMQBuild32(addr result.V[0], addr result.prefix_product[0],
                        addr result.suffix_product[0], addr rows[0], n)
                else:
                    staticRMQBuild64(addr result.V[0], addr result.prefix_product[0],
                        addr result.suffix_product[0], addr rows[0], n)
                return
        for b in 0..<blocks:
            let first = b shl staticRMQBlockShift
            let last = min(first + staticRMQBlockSize, n) - 1
            result.prefix_product[first] = V[first]
            for i in first+1..last:
                result.prefix_product[i] = min(result.prefix_product[i-1], V[i])
            result.suffix_product[last] = V[last]
            for i in countdown(last-1, first):
                result.suffix_product[i] = min(result.suffix_product[i+1], V[i])
<<<<<<< Updated upstream
            result.table[0][b] = result.suffix_product[first]
        for k in 1..<result.table.len:
            result.table[k] = newSeq[T](blocks - (1 shl k) + 1)
            for i in 0..<result.table[k].len:
                result.table[k][i] = min(result.table[k-1][i], result.table[k-1][i + (1 shl (k-1))])
    proc query*[T](rmq: StaticRMQ[T], l, r: int): T {.inline.} =
        ## 半開区間 [l, r) の最小値を返す。
        assert 0 <= l and l < r and r <= rmq.V.len
=======
            result.table[0][b] = result.prefix_product[last]
        for k in 1..<levels:
            let distance = 1 shl (k - 1)
            for i in 0..<result.table[k].len:
                result.table[k][i] = min(result.table[k-1][i], result.table[k-1][i + distance])

    {.push boundChecks: off, overflowChecks: off.}
    proc query*[T](RMQ: StaticRMQ[T], l, r: int): T {.inline.} =
        ## 半開区間 [l, r) の最小値を返す。
        assert 0 <= l and l < r and r <= RMQ.V.len
>>>>>>> Stashed changes
        let last = r - 1
        let a = l shr staticRMQBlockShift
        let b = last shr staticRMQBlockShift
        if a == b:
<<<<<<< Updated upstream
            result = rmq.V[l]
            for i in l+1..last:
                result = min(result, rmq.V[i])
            return
        result = min(rmq.suffix_product[l], rmq.prefix_product[last])
        if a + 1 < b:
            let k = fastLog2(b - a - 1)
            result = min(result, min(rmq.table[k][a + 1], rmq.table[k][b - (1 shl k)]))
=======
            when staticRMQCpp and (T is int or T is int32 or T is int64):
                when nimvm: discard
                else:
                    if r - l >= 32 div sizeof(T):
                        when sizeof(T) == 4:
                            return T(staticRMQScan32(unsafeAddr RMQ.V[l], r - l))
                        else:
                            return T(staticRMQScan64(unsafeAddr RMQ.V[l], r - l))
            result = RMQ.V[l]
            for i in l+1..last: result = min(result, RMQ.V[i])
            return
        result = min(RMQ.suffix_product[l], RMQ.prefix_product[last])
        if a + 1 < b:
            let k = fastLog2(b - a - 1)
            result = min(result, min(RMQ.table[k][a + 1], RMQ.table[k][b - (1 shl k)]))
    {.pop.}
>>>>>>> Stashed changes
