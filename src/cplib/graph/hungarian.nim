when not declared CPLIB_GRAPH_HUNGARIAN:
    const CPLIB_GRAPH_HUNGARIAN* = 1

    type
        MinCostAssignmentResult* = object
            feasible*: bool
            cost*: int64
            columnOfRow*: seq[int]
        AssignmentWide = object
            hi, lo: uint64

    proc assignmentWide(x: int64): AssignmentWide {.inline.} =
        ## 符号付き64ビット整数を2の補数の128ビット表現へ拡張する。
        AssignmentWide(hi: (if x < 0: high(uint64) else: 0'u64), lo: cast[uint64](x))

    proc `+`(a, b: AssignmentWide): AssignmentWide {.inline.} =
        ## 下位桁の桁上がりを上位桁へ加える。
        result.lo = a.lo + b.lo
        result.hi = a.hi + b.hi + uint64(result.lo < a.lo)

    proc `-`(a, b: AssignmentWide): AssignmentWide {.inline.} =
        ## 下位桁の借りを上位桁から引く。
        result.lo = a.lo - b.lo
        result.hi = a.hi - b.hi - uint64(a.lo < b.lo)

    proc `<`(a, b: AssignmentWide): bool {.inline.} =
        ## 上位桁を符号付き、下位桁を符号なしとして比較する。
        if a.hi != b.hi: cast[int64](a.hi) < cast[int64](b.hi)
        else: a.lo < b.lo

    proc assignmentInt64(x: AssignmentWide): int64 =
        ## 最終費用の範囲を検査する。release/dangerでも範囲外はOverflowDefect。
        if not ((x.hi == 0 and x.lo <= uint64(high(int64))) or
                (x.hi == high(uint64) and x.lo >= (1'u64 shl 63))):
            raise newException(OverflowDefect, "assignment cost does not fit int64")
        cast[int64](x.lo)

    proc min_cost_assignment_wide*[T: SomeSignedInt](cost: openArray[seq[T]], allowed: openArray[seq[bool]] = []): MinCostAssignmentResult =
        ## 整数矩形N×M行列の最小費用完全行割当をHungarian法で求める。時間O(N²M)、追加領域O(N+M)。
        ## 全行を相異なる列へ割り当て、0始まりのcolumnOfRowとint64のcostを返す。負費用・同費用可。
        ## allowedを省略すると全辺を許可する。指定時は同じ形でtrueの辺だけを使う。INF値は使わない。
        ## N>Mや許可辺に完全割当がない場合はfeasible=false、cost=0、columnOfRowは空。
        ## 空行列は費用0の実行可能解。不揃いな行列・許可行列はValueError。入力は変更しない。
        ## Tは符号付き64ビット以下、N≤2³¹−1、N,M<high(int)。最適費用がint64に収まらなければOverflowDefect。
        ## 中間演算は2個のuint64による符号付き128ビットで、費用差・ポテンシャル・総和のint64溢れを避ける。
        ## 交互道は高々N行を通る。各増加の距離はO(N·2⁶³)、N回の更新を含めても中間値はO(N²·2⁶³)。
        ## 上記Nの制約で128ビットに収まり、総和はN·2⁶³以下。符号なし桁の加減算は桁上がり/借りを処理する。
        ## 各増加で未訪問列への最短路の余裕を更新し、最小余裕だけ双対変数を動かす。等号辺で増加するため最適。
        let n = cost.len
        let m = if n == 0: 0 else: cost[0].len
        if n > int(high(int32)) or n == high(int) or m == high(int):
            raise newException(ValueError, "assignment dimensions are too large")
        for row in cost:
            if row.len != m:
                raise newException(ValueError, "cost matrix must be rectangular")
        if allowed.len != 0:
            if allowed.len != n:
                raise newException(ValueError, "allowed matrix must have the same shape")
            for row in allowed:
                if row.len != m:
                    raise newException(ValueError, "allowed matrix must have the same shape")
        if n == 0:
            result.feasible = true
            return
        if n > m:
            return

        var u = newSeq[AssignmentWide](n + 1)
        var v = newSeq[AssignmentWide](m + 1)
        var p = newSeq[int](m + 1)
        var way = newSeq[int](m + 1)
        var slack = newSeq[AssignmentWide](m + 1)
        var reached = newSeq[bool](m + 1)
        var used = newSeq[bool](m + 1)
        for i in 1..n:
            p[0] = i
            for j in 0..m:
                reached[j] = false
                used[j] = false
            var j0 = 0
            while true:
                used[j0] = true
                let i0 = p[j0]
                var next = 0
                var delta: AssignmentWide
                for j in 1..m:
                    if used[j]: continue
                    if allowed.len == 0 or allowed[i0 - 1][j - 1]:
                        let reduced = assignmentWide(int64(cost[i0 - 1][j - 1])) - u[i0] - v[j]
                        if not reached[j] or reduced < slack[j]:
                            reached[j] = true
                            slack[j] = reduced
                            way[j] = j0
                    if reached[j] and (next == 0 or slack[j] < delta):
                        delta = slack[j]
                        next = j
                if next == 0:
                    return
                for j in 0..m:
                    if used[j]:
                        u[p[j]] = u[p[j]] + delta
                        if j != 0: v[j] = v[j] - delta
                    elif reached[j]:
                        slack[j] = slack[j] - delta
                j0 = next
                if p[j0] == 0: break
            while j0 != 0:
                let previous = way[j0]
                p[j0] = p[previous]
                j0 = previous

        result.columnOfRow = newSeq[int](n)
        var total: AssignmentWide
        for j in 1..m:
            if p[j] != 0:
                result.columnOfRow[p[j] - 1] = j - 1
                total = total + assignmentWide(int64(cost[p[j] - 1][j - 1]))
        result.cost = assignmentInt64(total)
        result.feasible = true

    type AssignmentInt32Backend* = enum
        assignmentScalar, assignmentSimd

    when defined(hungarianAutoVectorize):
        {.passC: "-DCPLIB_ASSIGN_AUTO_VECTORIZE".}
    when defined(hungarianForceScalar):
        {.passC: "-DCPLIB_ASSIGN_FORCE_SCALAR".}
    type AssignmentInt32TieBreak* = enum
        assignmentStable, assignmentPreferFree

    type AssignmentInt32Vector* = enum
        assignmentVectorSse, assignmentVectorAvx512, assignmentVectorAuto, assignmentVectorAvx2

    when defined(hungarianDisableAvx2):
        {.passC: "-DCPLIB_FAST_NO_AVX2".}
    when defined(hungarianDisableAvx512):
        {.passC: "-DCPLIB_FAST_NO_AVX512".}
    when defined(hungarianFastStats):
        {.passC: "-DCPLIB_FAST_STATS".}
    {.emit: """#include <stdint.h>
#include <limits.h>
#if (defined(__x86_64__) || defined(__i386__)) && (defined(__GNUC__) || defined(__clang__)) && !defined(CPLIB_ASSIGN_FORCE_SCALAR)
#include <immintrin.h>
#include <cpuid.h>
#define CPLIB_FAST_SSE 1
#endif
#if defined(__GNUC__) && !defined(__clang__) && !defined(CPLIB_ASSIGN_AUTO_VECTORIZE)
#define CPLIB_FAST_SCALAR __attribute__((optimize("no-tree-vectorize"),noinline))
#else
#define CPLIB_FAST_SCALAR
#endif
static int cplib_fast_has_sse(void) {
#if defined(CPLIB_FAST_SSE)
    return __builtin_cpu_supports("sse4.2") != 0;
#else
    return 0;
#endif
}
/* AVX2のCPU機能とXMM/YMMのOS保存対応を調べる。 */
static int cplib_fast_has_avx2(void) {
#if defined(CPLIB_FAST_SSE) && !defined(CPLIB_FAST_NO_AVX2)
    unsigned a,b,c,d,lo,hi;
    if (!__get_cpuid(1,&a,&b,&c,&d) || (c & ((1u<<26)|(1u<<27)|(1u<<28))) != ((1u<<26)|(1u<<27)|(1u<<28))) return 0;
    __asm__ volatile("xgetbv" : "=a"(lo), "=d"(hi) : "c"(0));
    if ((lo & 0x6) != 0x6) return 0;
    if (!__get_cpuid_count(7,0,&a,&b,&c,&d)) return 0;
    return (b & (1u<<5)) != 0;
#else
    return 0;
#endif
}
/* AVX命令を実行せずにCPU機能とOSのXCR0を検査する。 */
static int cplib_fast_has_avx512(void) {
#if defined(CPLIB_FAST_SSE) && !defined(CPLIB_FAST_NO_AVX512) && !defined(CPLIB_FAST_NO_AVX2)
    unsigned a,b,c,d,lo,hi;
    if (!__get_cpuid(1,&a,&b,&c,&d) || (c & ((1u<<26)|(1u<<27)|(1u<<28))) != ((1u<<26)|(1u<<27)|(1u<<28))) return 0;
    __asm__ volatile("xgetbv" : "=a"(lo), "=d"(hi) : "c"(0));
    if ((lo & 0xe6) != 0xe6) return 0;
    if (!__get_cpuid_count(7,0,&a,&b,&c,&d)) return 0;
    return (b & ((1u<<5)|(1u<<16))) == ((1u<<5)|(1u<<16));
#else
    return 0;
#endif
}
/* 未訪問列を緩和し、同値なら最小列番号のargminを返す。 */
static CPLIB_FAST_SCALAR int64_t cplib_fast_scalar(
    const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, const int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    int64_t best = INT64_MAX, next = 0;
    for (int64_t j = 1; j <= m; ++j) {
        if (used[j]) continue;
        if (!allowed || allowed[j-1]) {
            int64_t reduced = ((int64_t)cost[j-1] + INT64_C(2147483648)) - ui - v[j];
            if (reduced < slack[j]) { slack[j] = reduced; way[j] = j0; }
        }
        if (slack[j] < best || (preferFree && next && slack[j] == best && p[next] && !p[j])) { best = slack[j]; next = j; }
    }
    *delta = best;
    return next;
}
#if defined(CPLIB_FAST_SSE)
/* 64ビット2列ずつ緩和・way更新・argminを実行する。末尾はスカラー処理。 */
__attribute__((target("sse4.2"),noinline))
static int64_t cplib_fast_sse(
    const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, const int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    const __m128i inf = _mm_set1_epi64x(INT64_MAX), zero = _mm_setzero_si128();
    const __m128i offset = _mm_set1_epi64x(INT64_C(2147483648) - ui);
    const __m128i prev = _mm_set1_epi64x(j0);
    __m128i best = inf, indices = zero, bestFree = zero;
    int64_t j = 1;
    for (; j + 1 <= m; j += 2) {
        __m128i active = _mm_cmpeq_epi64(_mm_loadu_si128((const __m128i*)(used+j)), zero);
        __m128i edge = allowed ? _mm_set_epi64x(allowed[j] ? -1LL : 0LL, allowed[j-1] ? -1LL : 0LL) : _mm_set1_epi64x(-1LL);
        __m128i c = _mm_cvtepi32_epi64(_mm_loadl_epi64((const __m128i*)(cost+j-1)));
        __m128i reduced = _mm_sub_epi64(_mm_add_epi64(c, offset), _mm_loadu_si128((const __m128i*)(v+j)));
        __m128i old = _mm_loadu_si128((const __m128i*)(slack+j));
        __m128i improve = _mm_and_si128(_mm_and_si128(active, edge), _mm_cmpgt_epi64(old, reduced));
        __m128i value = _mm_blendv_epi8(old, reduced, improve);
        _mm_storeu_si128((__m128i*)(slack+j), value);
        __m128i oldway = _mm_loadu_si128((const __m128i*)(way+j));
        _mm_storeu_si128((__m128i*)(way+j), _mm_blendv_epi8(oldway, prev, improve));
        __m128i freeCol = _mm_cmpeq_epi64(_mm_loadu_si128((const __m128i*)(p+j)), zero);
        __m128i better = _mm_cmpgt_epi64(best, value);
        if (preferFree) better = _mm_or_si128(better, _mm_and_si128(_mm_cmpeq_epi64(best, value), _mm_andnot_si128(bestFree, freeCol)));
        better = _mm_and_si128(active, _mm_andnot_si128(_mm_cmpeq_epi64(value, inf), better));
        bestFree = _mm_blendv_epi8(bestFree, freeCol, better);
        best = _mm_blendv_epi8(best, value, better);
        indices = _mm_blendv_epi8(indices, _mm_set_epi64x(j+1, j), better);
    }
    int64_t b[2], ix[2];
    _mm_storeu_si128((__m128i*)b, best); _mm_storeu_si128((__m128i*)ix, indices);
    int64_t next = ix[0], value = b[0];
    if (b[1] < value || (b[1] == value && ix[1] && (!next || (preferFree && p[next] && !p[ix[1]]) || ((!preferFree || (!p[next] == !p[ix[1]])) && ix[1] < next)))) { value = b[1]; next = ix[1]; }
    if (j <= m && !used[j]) {
        if (!allowed || allowed[j-1]) {
            int64_t reduced = ((int64_t)cost[j-1] + INT64_C(2147483648)) - ui - v[j];
            if (reduced < slack[j]) { slack[j] = reduced; way[j] = j0; }
        }
        if (slack[j] < value || (preferFree && next && slack[j] == value && p[next] && !p[j])) { value = slack[j]; next = j; }
    }
    *delta = value;
    return next;
}
#else
#define cplib_fast_sse cplib_fast_scalar
#endif

/* 根行専用: 初期化・最初の緩和・argminを一回の列走査に融合する。 */
static CPLIB_FAST_SCALAR int64_t cplib_fast_init_scalar(
    const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    int64_t best = INT64_MAX, next = 0;
    for (int64_t j = 1; j <= m; ++j) {
        used[j] = 0; way[j] = 0;
        slack[j] = (!allowed || allowed[j-1]) ? ((int64_t)cost[j-1] + INT64_C(2147483648)) - ui - v[j] : INT64_MAX;
        if (slack[j] < best || (preferFree && next && slack[j] == best && p[next] && !p[j])) { best = slack[j]; next = j; }
    }
    *delta = best;
    return next;
}
#if defined(CPLIB_FAST_SSE)
/* 64ビット2列ずつ緩和・way更新・argminを実行する。末尾はスカラー処理。 */
__attribute__((target("sse4.2"),noinline))
static int64_t cplib_fast_init_sse(
    const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    const __m128i inf = _mm_set1_epi64x(INT64_MAX), zero = _mm_setzero_si128();
    const __m128i offset = _mm_set1_epi64x(INT64_C(2147483648) - ui);
    const __m128i prev = _mm_set1_epi64x(j0);
    __m128i best = inf, indices = zero, bestFree = zero;
    int64_t j = 1;
    for (; j + 1 <= m; j += 2) {
        __m128i active = _mm_set1_epi64x(-1LL);
        __m128i edge = allowed ? _mm_set_epi64x(allowed[j] ? -1LL : 0LL, allowed[j-1] ? -1LL : 0LL) : _mm_set1_epi64x(-1LL);
        __m128i c = _mm_cvtepi32_epi64(_mm_loadl_epi64((const __m128i*)(cost+j-1)));
        __m128i reduced = _mm_sub_epi64(_mm_add_epi64(c, offset), _mm_loadu_si128((const __m128i*)(v+j)));
        __m128i value = _mm_blendv_epi8(inf, reduced, edge);
        _mm_storeu_si128((__m128i*)(slack+j), value);
        _mm_storeu_si128((__m128i*)(way+j), zero);
        _mm_storeu_si128((__m128i*)(used+j), zero);
        __m128i freeCol = _mm_cmpeq_epi64(_mm_loadu_si128((const __m128i*)(p+j)), zero);
        __m128i better = _mm_cmpgt_epi64(best, value);
        if (preferFree) better = _mm_or_si128(better, _mm_and_si128(_mm_cmpeq_epi64(best, value), _mm_andnot_si128(bestFree, freeCol)));
        better = _mm_and_si128(active, _mm_andnot_si128(_mm_cmpeq_epi64(value, inf), better));
        bestFree = _mm_blendv_epi8(bestFree, freeCol, better);
        best = _mm_blendv_epi8(best, value, better);
        indices = _mm_blendv_epi8(indices, _mm_set_epi64x(j+1, j), better);
    }
    int64_t b[2], ix[2];
    _mm_storeu_si128((__m128i*)b, best); _mm_storeu_si128((__m128i*)ix, indices);
    int64_t next = ix[0], value = b[0];
    if (b[1] < value || (b[1] == value && ix[1] && (!next || (preferFree && p[next] && !p[ix[1]]) || ((!preferFree || (!p[next] == !p[ix[1]])) && ix[1] < next)))) { value = b[1]; next = ix[1]; }
    if (j <= m) {
        used[j] = 0; way[j] = 0;
        slack[j] = (!allowed || allowed[j-1]) ? ((int64_t)cost[j-1] + INT64_C(2147483648)) - ui - v[j] : INT64_MAX;
        if (slack[j] < value || (preferFree && next && slack[j] == value && p[next] && !p[j])) { value = slack[j]; next = j; }
    }
    *delta = value;
    return next;
}
#else
#define cplib_fast_init_sse cplib_fast_init_scalar
#endif

/* 入力値の最小値だけを32ビットで比較する。差・双対・距離の演算は64ビットのまま。 */
static int32_t cplib_fast_row_min_scalar(const int32_t *row, int64_t m) {
    int32_t best = row[0];
    for (int64_t j = 1; j < m; ++j) if (row[j] < best) best = row[j];
    return best;
}
#if defined(CPLIB_FAST_SSE)
__attribute__((target("sse4.2"),noinline))
static int32_t cplib_fast_row_min_sse(const int32_t *row, int64_t m) {
    __m128i best = _mm_set1_epi32(INT32_MAX);
    int64_t j = 0;
    for (; j+3 < m; j += 4) best = _mm_min_epi32(best, _mm_loadu_si128((const __m128i*)(row+j)));
    best = _mm_min_epi32(best, _mm_shuffle_epi32(best, _MM_SHUFFLE(1,0,3,2)));
    best = _mm_min_epi32(best, _mm_shuffle_epi32(best, _MM_SHUFFLE(2,3,0,1)));
    int32_t value = _mm_cvtsi128_si32(best);
    for (; j < m; ++j) if (row[j] < value) value = row[j];
    return value;
}
#else
#define cplib_fast_row_min_sse cplib_fast_row_min_scalar
#endif

/* 4列の64ビット緩和。AVX-512とは別のtarget関数に閉じ込める。 */
#if defined(CPLIB_FAST_SSE) && !defined(CPLIB_FAST_NO_AVX2)
__attribute__((target("avx2"),noinline))
static int64_t cplib_fast_avx2(const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta, int initialize) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    const __m256i inf = _mm256_set1_epi64x(INT64_MAX), zero = _mm256_setzero_si256();
    const __m256i offset = _mm256_set1_epi64x(INT64_C(2147483648)-ui);
    const __m256i previous = _mm256_set1_epi64x(j0);
    __m256i best = inf, indices = zero, bestFree = zero;
    __m256i columns = _mm256_setr_epi64x(1,2,3,4);
    int64_t j = 1;
    for (; j <= m-3; j += 4) {
        __m256i active = initialize ? _mm256_set1_epi64x(-1) : _mm256_cmpeq_epi64(_mm256_loadu_si256((const __m256i*)(used+j)),zero);
        __m256i edge = allowed ? _mm256_setr_epi64x(allowed[j-1] ? -1LL : 0LL,allowed[j] ? -1LL : 0LL,
            allowed[j+1] ? -1LL : 0LL,allowed[j+2] ? -1LL : 0LL) : _mm256_set1_epi64x(-1);
        __m256i c = _mm256_cvtepi32_epi64(_mm_loadu_si128((const __m128i*)(cost+j-1)));
        __m256i reduced = _mm256_sub_epi64(_mm256_add_epi64(c,offset),_mm256_loadu_si256((const __m256i*)(v+j)));
        __m256i value;
        if (initialize) {
            value = _mm256_blendv_epi8(inf,reduced,edge);
            _mm256_storeu_si256((__m256i*)(slack+j),value);
            _mm256_storeu_si256((__m256i*)(way+j),zero);
            _mm256_storeu_si256((__m256i*)(used+j),zero);
        } else {
            __m256i old = _mm256_loadu_si256((const __m256i*)(slack+j));
            __m256i improve = _mm256_and_si256(_mm256_and_si256(active,edge),_mm256_cmpgt_epi64(old,reduced));
            value = _mm256_blendv_epi8(old,reduced,improve);
            _mm256_storeu_si256((__m256i*)(slack+j),value);
            __m256i oldway = _mm256_loadu_si256((const __m256i*)(way+j));
            _mm256_storeu_si256((__m256i*)(way+j),_mm256_blendv_epi8(oldway,previous,improve));
        }
        __m256i freeCol = _mm256_cmpeq_epi64(_mm256_loadu_si256((const __m256i*)(p+j)),zero);
        __m256i better = _mm256_cmpgt_epi64(best,value);
        if (preferFree) better = _mm256_or_si256(better,_mm256_and_si256(_mm256_cmpeq_epi64(value,best),_mm256_andnot_si256(bestFree,freeCol)));
        better = _mm256_and_si256(active,_mm256_andnot_si256(_mm256_cmpeq_epi64(value,inf),better));
        bestFree = _mm256_blendv_epi8(bestFree,freeCol,better);
        best = _mm256_blendv_epi8(best,value,better);
        indices = _mm256_blendv_epi8(indices,columns,better);
        columns = _mm256_add_epi64(columns,_mm256_set1_epi64x(4));
    }
    int64_t values[4], ids[4], next = 0, value = INT64_MAX;
    _mm256_storeu_si256((__m256i*)values,best); _mm256_storeu_si256((__m256i*)ids,indices);
    for (int lane = 0; lane < 4; ++lane) {
        int64_t col = ids[lane];
        if (col && (!next || values[lane] < value || (values[lane] == value &&
            ((preferFree && p[next] && !p[col]) || ((!preferFree || (!p[next] == !p[col])) && col < next))))) {
            next = col; value = values[lane];
        }
    }
    for (; j <= m; ++j) {
        if (initialize) {
            used[j] = 0; way[j] = 0;
            slack[j] = (!allowed || allowed[j-1]) ? ((int64_t)cost[j-1]+INT64_C(2147483648))-ui-v[j] : INT64_MAX;
        } else {
            if (used[j]) continue;
            if (!allowed || allowed[j-1]) {
                int64_t reduced = ((int64_t)cost[j-1]+INT64_C(2147483648))-ui-v[j];
                if (reduced < slack[j]) { slack[j] = reduced; way[j] = j0; }
            }
        }
        if (slack[j] < value || (preferFree && next && slack[j] == value && p[next] && !p[j])) { value=slack[j]; next=j; }
    }
    *delta = value;
    return next;
}
/* 行最小値は入力値の比較だけなので8列のint32を用いる。 */
__attribute__((target("avx2"),noinline))
static int32_t cplib_fast_row_min_avx2(const int32_t *row, int64_t m) {
    __m256i best = _mm256_set1_epi32(INT32_MAX);
    int64_t j = 0;
    for (; j <= m-8; j+=8) best = _mm256_min_epi32(best,_mm256_loadu_si256((const __m256i*)(row+j)));
    int32_t values[8], value = INT32_MAX;
    _mm256_storeu_si256((__m256i*)values,best);
    for (int lane = 0; lane < 8; ++lane) if (values[lane] < value) value=values[lane];
    for (; j < m; ++j) if (row[j] < value) value=row[j];
    return value;
}
#else
static int64_t cplib_fast_avx2(const int32_t *cost, const void *allowed, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta, int initialize) {
    return initialize ? cplib_fast_init_sse(cost,allowed,m,ui,v,used,p,preferFree,slack,way,j0,delta)
        : cplib_fast_sse(cost,allowed,m,ui,v,used,p,preferFree,slack,way,j0,delta);
}
#define cplib_fast_row_min_avx2 cplib_fast_row_min_sse
#endif

/* 8列の64ビット緩和。初回は距離・used・way初期化も融合する。 */
#if defined(CPLIB_FAST_SSE) && !defined(CPLIB_FAST_NO_AVX512) && !defined(CPLIB_FAST_NO_AVX2)
__attribute__((target("avx512f"),noinline))
static int64_t cplib_fast_avx512(const int32_t *cost, const void *allowedData, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta, int initialize) {
    const unsigned char *allowed = (const unsigned char*)allowedData;
    const __m512i inf = _mm512_set1_epi64(INT64_MAX), zero = _mm512_setzero_si512();
    const __m512i offset = _mm512_set1_epi64(INT64_C(2147483648)-ui);
    const __m512i previous = _mm512_set1_epi64(j0);
    __m512i best = inf, indices = zero;
    __m512i columns = _mm512_setr_epi64(1,2,3,4,5,6,7,8);
    __mmask8 bestFree = 0;
    int64_t j = 1;
    for (; j <= m-7; j += 8) {
        __mmask8 active = initialize ? 0xff : _mm512_cmpeq_epi64_mask(_mm512_loadu_si512(used+j),zero);
        __mmask8 edge = 0xff;
        if (allowed) edge = (__mmask8)~_mm_movemask_epi8(_mm_cmpeq_epi8(_mm_loadl_epi64((const __m128i*)(allowed+j-1)),_mm_setzero_si128()));
        __m512i c = _mm512_cvtepi32_epi64(_mm256_loadu_si256((const __m256i*)(cost+j-1)));
        __m512i reduced = _mm512_sub_epi64(_mm512_add_epi64(c,offset),_mm512_loadu_si512(v+j));
        __m512i value;
        if (initialize) {
            value = _mm512_mask_mov_epi64(inf,edge,reduced);
            _mm512_storeu_si512(slack+j,value);
            _mm512_storeu_si512(way+j,zero);
            _mm512_storeu_si512(used+j,zero);
        } else {
            __m512i old = _mm512_loadu_si512(slack+j);
            __mmask8 improve = active & edge & _mm512_cmplt_epi64_mask(reduced,old);
            value = _mm512_mask_mov_epi64(old,improve,reduced);
            _mm512_mask_storeu_epi64(slack+j,improve,reduced);
            _mm512_mask_storeu_epi64(way+j,improve,previous);
        }
        __mmask8 freeCol = _mm512_cmpeq_epi64_mask(_mm512_loadu_si512(p+j),zero);
        __mmask8 better = _mm512_cmplt_epi64_mask(value,best);
        if (preferFree) better |= _mm512_cmpeq_epi64_mask(value,best) & freeCol & ~bestFree;
        better &= active & _mm512_cmpneq_epi64_mask(value,inf);
        bestFree = (bestFree & ~better) | (freeCol & better);
        best = _mm512_mask_mov_epi64(best,better,value);
        indices = _mm512_mask_mov_epi64(indices,better,columns);
        columns = _mm512_add_epi64(columns,_mm512_set1_epi64(8));
    }
    int64_t values[8], ids[8], next = 0, value = INT64_MAX;
    _mm512_storeu_si512(values,best); _mm512_storeu_si512(ids,indices);
    for (int lane = 0; lane < 8; ++lane) {
        int64_t col = ids[lane];
        if (col && (!next || values[lane] < value || (values[lane] == value &&
            ((preferFree && p[next] && !p[col]) || ((!preferFree || (!p[next] == !p[col])) && col < next))))) {
            next = col; value = values[lane];
        }
    }
    for (; j <= m; ++j) {
        if (initialize) {
            used[j] = 0; way[j] = 0;
            slack[j] = (!allowed || allowed[j-1]) ? ((int64_t)cost[j-1]+INT64_C(2147483648))-ui-v[j] : INT64_MAX;
        } else {
            if (used[j]) continue;
            if (!allowed || allowed[j-1]) {
                int64_t reduced = ((int64_t)cost[j-1]+INT64_C(2147483648))-ui-v[j];
                if (reduced < slack[j]) { slack[j] = reduced; way[j] = j0; }
            }
        }
        if (slack[j] < value || (preferFree && next && slack[j] == value && p[next] && !p[j])) { value=slack[j]; next=j; }
    }
    *delta = value;
    return next;
}
/* 最小値の比較だけ16列ずつ行い、ポテンシャル等の算術は64ビットを保つ。 */
__attribute__((target("avx512f"),noinline))
static int32_t cplib_fast_row_min_avx512(const int32_t *row, int64_t m) {
    __m512i best = _mm512_set1_epi32(INT32_MAX);
    int64_t j = 0;
    for (; j <= m-16; j+=16) best = _mm512_min_epi32(best,_mm512_loadu_si512(row+j));
    int32_t value = _mm512_reduce_min_epi32(best);
    for (; j < m; ++j) if (row[j] < value) value=row[j];
    return value;
}
#else
static int64_t cplib_fast_avx512(const int32_t *cost, const void *allowed, int64_t m,
    int64_t ui, const int64_t *v, int64_t *used, const int64_t *p, int preferFree,
    int64_t *slack, int64_t *way, int64_t j0, int64_t *delta, int initialize) {
    return initialize ? cplib_fast_init_sse(cost,allowed,m,ui,v,used,p,preferFree,slack,way,j0,delta)
        : cplib_fast_sse(cost,allowed,m,ui,v,used,p,preferFree,slack,way,j0,delta);
}
#define cplib_fast_row_min_avx512 cplib_fast_row_min_sse
#endif

/* 距離を絶対値で保持し、増加が確定した時だけ訪問列の双対変数を更新する。 */
static int cplib_fast_solve(const void *costData, const void *allowedData,
    int64_t n, int64_t m, int simd, int preferFree, int fused, int greedy,
    int64_t *u, int64_t *v, int64_t *p, int64_t *way,
    int64_t *dist, int64_t *used, int64_t *visited, int64_t *matched, int64_t *stats) {
    const int32_t *const *cost = (const int32_t *const*)costData;
    const void *const *allowed = (const void *const*)allowedData;
    if (greedy && !allowed) {
        for (int64_t i = 1; i <= n; ++i) {
            int32_t minimum = simd == 3 ? cplib_fast_row_min_avx2(cost[i-1],m) : simd == 2 ? cplib_fast_row_min_avx512(cost[i-1],m) : simd ? cplib_fast_row_min_sse(cost[i-1],m) : cplib_fast_row_min_scalar(cost[i-1],m);
            u[i] = (int64_t)minimum + INT64_C(2147483648);
#ifdef CPLIB_FAST_STATS
            stats[3] += m;
#endif
            for (int64_t j = 1; j <= m; ++j) {
#ifdef CPLIB_FAST_STATS
                ++stats[4];
#endif
                if (!p[j] && cost[i-1][j-1] == minimum) { p[j] = i; matched[i] = 1; break; }
            }
        }
    }
    for (int64_t i = 1; i <= n; ++i) {
        if (matched[i]) continue;
        p[0] = i;
        if (!fused) for (int64_t j = 0; j <= m; ++j) { dist[j] = INT64_MAX; used[j] = 0; }
        int64_t j0 = 0, distance = 0, count = 0;
        for (;;) {
            used[j0] = 1;
            int64_t row = p[j0];
            int64_t next;
            if (fused && !j0) {
                next = simd == 3 ? cplib_fast_avx2(cost[row-1], allowed ? allowed[row-1] : 0, m,
                    u[row], v, used, p, preferFree, dist, way, 0, &distance, 1) : simd == 2 ? cplib_fast_avx512(cost[row-1], allowed ? allowed[row-1] : 0, m,
                    u[row], v, used, p, preferFree, dist, way, 0, &distance, 1) : simd ? cplib_fast_init_sse(cost[row-1], allowed ? allowed[row-1] : 0, m,
                    u[row], v, used, p, preferFree, dist, way, 0, &distance)
                    : cplib_fast_init_scalar(cost[row-1], allowed ? allowed[row-1] : 0, m,
                    u[row], v, used, p, preferFree, dist, way, 0, &distance);
            } else next = simd == 3 ? cplib_fast_avx2(cost[row-1], allowed ? allowed[row-1] : 0, m,
                u[row]-distance, v, used, p, preferFree, dist, way, j0, &distance, 0) : simd == 2 ? cplib_fast_avx512(cost[row-1], allowed ? allowed[row-1] : 0, m,
                u[row]-distance, v, used, p, preferFree, dist, way, j0, &distance, 0) : simd ? cplib_fast_sse(cost[row-1], allowed ? allowed[row-1] : 0, m,
                u[row] - distance, v, used, p, preferFree, dist, way, j0, &distance)
                : cplib_fast_scalar(cost[row-1], allowed ? allowed[row-1] : 0, m,
                u[row] - distance, v, used, p, preferFree, dist, way, j0, &distance);
#ifdef CPLIB_FAST_STATS
            ++stats[0]; stats[1] += m;
#endif
            if (!next) return 0;
            j0 = next;
            if (!p[j0]) break;
            visited[count++] = j0;
        }
        u[i] += distance;
        for (int64_t k = 0; k < count; ++k) {
            int64_t col = visited[k], delta = distance - dist[col];
            u[p[col]] += delta; v[col] -= delta;
        }
#ifdef CPLIB_FAST_STATS
        stats[2] += count + 1;
#endif
        while (j0) { int64_t prev = way[j0]; p[j0] = p[prev]; j0 = prev; }
    }
    return 1;
}
""".}
    proc solveFast(cost, allowed: pointer, n, m: int64, simd, preferFree, fused, greedy: cint,
                   u, v, p, way, dist, used, visited, matched, stats: ptr int64): cint
                   {.importc: "cplib_fast_solve", nodecl.}

    proc probeSse(): cint {.importc: "cplib_fast_has_sse", nodecl.}
    proc assignment_int32_simd_available*(): bool =
        ## 比較用SSE4.2経路の利用可否を返す。
        probeSse() != 0

    proc probeAvx2(): cint {.importc: "cplib_fast_has_avx2", nodecl.}
    proc probeAvx512(): cint {.importc: "cplib_fast_has_avx512", nodecl.}
    let assignmentInt32Avx2Ready = probeAvx2() != 0
    let assignmentInt32Avx512Ready = probeAvx512() != 0

    proc assignment_int32_avx2_available*(): bool =
        ## モジュール初期化時にCPUとOSを検査した結果を返す。
        assignmentInt32Avx2Ready

    proc assignment_int32_avx512_available*(): bool =
        ## モジュール初期化時にCPUとOSを検査した結果を返す。
        assignmentInt32Avx512Ready

    proc assignment_int32_vector_backend*(requested: AssignmentInt32Vector): AssignmentInt32Vector =
        ## 自動選択はAVX-512、AVX2の順。明示要求が非対応ならValueError。
        case requested
        of assignmentVectorSse:
            return assignmentVectorSse
        of assignmentVectorAvx512:
            if assignment_int32_avx512_available(): return assignmentVectorAvx512
            raise newException(ValueError, "AVX-512 requested but CPU/OS support is unavailable")
        of assignmentVectorAvx2:
            if assignment_int32_avx2_available(): return assignmentVectorAvx2
            raise newException(ValueError, "AVX2 requested but CPU/OS support is unavailable")
        of assignmentVectorAuto:
            if assignment_int32_avx512_available(): return assignmentVectorAvx512
            if assignment_int32_avx2_available(): return assignmentVectorAvx2
            raise newException(ValueError, "automatic int32 assignment requires AVX2 CPU/OS support")

    proc min_cost_assignment_int32_fast*(cost: openArray[seq[int32]],
            allowed: openArray[seq[bool]] = [],
            backend: AssignmentInt32Backend = assignmentSimd,
            tieBreak: AssignmentInt32TieBreak = assignmentPreferFree,
            fuseInitialization: bool = true, greedyDense: bool = true,
            vector: AssignmentInt32Vector = assignmentVectorAuto): MinCostAssignmentResult =
        ## int32費用の最小割当。遅延双対更新で時間O(N²M)、追加領域O(N+M)。
        ## 既定はAVX-512、AVX2の順に自動選択。両方非対応ならValueError。
        ## N<=32767。内部は全てint64。禁則辺・不能・形状検査は既存int32版と同じ。
        ## 同距離では未割当列を優先するため、同じ最適費用でも割当列は既存版と異なりうる。
        ## 密行列では行最小値で双対と貪欲マッチングを初期化する。
        ## assignmentStableは貪欲初期化を無効化し、最小列番号の同値規則を維持する。
        let selected = if backend == assignmentScalar: assignmentVectorSse
                       else: assignment_int32_vector_backend(vector)
        let n = cost.len
        let m = if n == 0: 0 else: cost[0].len
        if n > 32767 or n == high(int) or m == high(int):
            raise newException(ValueError, "int32 assignment requires N <= 32767 and N,M < high(int)")
        for row in cost:
            if row.len != m:
                raise newException(ValueError, "cost matrix must be rectangular")
        if allowed.len != 0:
            if allowed.len != n:
                raise newException(ValueError, "allowed matrix must have the same shape")
            for row in allowed:
                if row.len != m:
                    raise newException(ValueError, "allowed matrix must have the same shape")
        if n == 0:
            result.feasible = true
            return
        if n > m: return
        var rows = newSeq[ptr int32](n)
        var masks = newSeq[pointer](if allowed.len == 0: 0 else: n)
        for i in 0..<n:
            rows[i] = unsafeAddr cost[i][0]
            if masks.len != 0: masks[i] = cast[pointer](unsafeAddr allowed[i][0])
        var u = newSeq[int64](n+1)
        var v = newSeq[int64](m+1)
        var p = newSeq[int64](m+1)
        var way = newSeq[int64](m+1)
        var dist = newSeq[int64](m+1)
        var used = newSeq[int64](m+1)
        var visited = newSeq[int64](n)
        var matched = newSeq[int64](n+1)
        var stats: array[5, int64]
        let simd = if backend == assignmentScalar: 0
                   elif selected == assignmentVectorAvx512: 2
                   elif selected == assignmentVectorAvx2: 3
                   elif assignment_int32_simd_available(): 1
                   else: 0
        let feasible = solveFast(addr rows[0], (if masks.len == 0: nil else: addr masks[0]),
            int64(n), int64(m), cint(simd), cint(tieBreak == assignmentPreferFree), cint(fuseInitialization), cint(greedyDense and tieBreak == assignmentPreferFree),
            addr u[0], addr v[0], addr p[0], addr way[0], addr dist[0], addr used[0],
            addr visited[0], addr matched[0], addr stats[0])
        when defined(hungarianFastStats):
            stderr.writeLine("expansions=", stats[0], " columns=", stats[1], " potentialUpdates=", stats[2], " greedyMinColumns=", stats[3], " greedyTieColumns=", stats[4])
        if feasible == 0: return
        result.columnOfRow = newSeq[int](n)
        for j in 1..m:
            if p[j] != 0:
                result.columnOfRow[int(p[j])-1] = j-1
                result.cost += int64(cost[int(p[j])-1][j-1])
        result.feasible = true

    proc min_cost_assignment_int32_avx512*(cost: openArray[seq[int32]],
            allowed: openArray[seq[bool]] = []): MinCostAssignmentResult =
        ## AVX-512を明示要求する。非対応CPU/OSではValueError。
        min_cost_assignment_int32_fast(cost, allowed, vector = assignmentVectorAvx512)

    proc min_cost_assignment_int32_avx2*(cost: openArray[seq[int32]],
            allowed: openArray[seq[bool]] = []): MinCostAssignmentResult =
        ## AVX2を明示要求する。非対応CPU/OSではValueError。
        min_cost_assignment_int32_fast(cost, allowed, vector = assignmentVectorAvx2)

    proc min_cost_assignment*[T: SomeSignedInt](cost: openArray[seq[T]],
            allowed: openArray[seq[bool]] = []): MinCostAssignmentResult =
        ## int32はAVX-512/AVX2を自動選択し、他の符号付き整数型は汎用128bit版を使う。
        ## int32経路はN<=32767、AVX2対応CPU/OSが必要。同値解の列順は汎用版と異なりうる。
        ## 型を狭める暗黙変換は行わない。時間O(N²M)、追加領域O(N+M)。
        when T is int32:
            min_cost_assignment_int32_fast(cost, allowed)
        else:
            min_cost_assignment_wide(cost, allowed)
