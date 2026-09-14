when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import sequtils
    import cplib/graph/warshall_floyd_negative
    proc warshall_floyd_inplace_run[T](d: var seq[seq[T]], zero, inf: T): bool =
        ## 正方隣接行列を最短距離で上書きし、負閉路の有無を返す。O(V^3)。負閉路検出時は途中の行列を残す。
        let n = d.len
        for i in 0..<n:
            assert d[i].len == n, "隣接行列は正方行列である必要があります"
        for i in 0..<n:
            d[i][i] = min(d[i][i], zero)
        for i in 0..<n:
            if d[i][i] < zero:
                return true
        for k in 0..<n:
            for i in 0..<n:
                for j in 0..<n:
                    if d[i][k] != inf and d[k][j] != inf:
                        d[i][j] = min(d[i][j], d[i][k] + d[k][j])
            for i in 0..<n:
                if d[i][i] < zero:
                    return true
        return false

    proc warshall_floyd_inplace_impl[T](d: var seq[seq[T]], zero, inf: T) =
        ## 距離行列を完成させ、負閉路を経由できる組は-infにする。O(V^3)。
        if warshall_floyd_inplace_run(d, zero, inf):
            warshall_floyd_negative_finish(d, zero, inf, warshall_floyd_inplace_run[T])

    proc warshall_floyd_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        result = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len:
            result[i][i] = zero
            for (j, cost) in g.to_and_cost(i):
                result[i][j] = min(result[i][j], cost)
        warshall_floyd_inplace_impl(result, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph, zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd_matrix_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 正方隣接行列から全点対最短路を求める。時間O(V^3)、追加領域O(V^2)。入力は変更しない。
        var d = newSeqWith(a.len, newSeqWith(a.len, inf))
        for i in 0..<a.len:
            assert a[i].len == a.len, "隣接行列は正方行列である必要があります"
            for j in 0..<a.len:
                d[i][j] = a[i][j]
        warshall_floyd_inplace_impl(d, zero, inf)
        return d

    proc warshall_floyd*(a: seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd_nonnegative_run[T](d: var seq[seq[T]], zero, inf: T) =
        ## 非負辺を前提に、負閉路検査なしで距離行列を更新する。O(V^3)。
        for k in 0..<d.len:
            for i in 0..<d.len:
                if d[i][k] != inf:
                    for j in 0..<d.len:
                        if d[k][j] != inf:
                            d[i][j] = min(d[i][j], d[i][k] + d[k][j])

    proc warshall_floyd_nonnegative_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 非負辺のグラフから距離行列を求める。時間O(V^3)、追加領域O(V^2)。
        result = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len:
            result[i][i] = zero
            for (j, cost) in g.to_and_cost(i):
                result[i][j] = min(result[i][j], cost)
        warshall_floyd_nonnegative_run(result, zero, inf)

    proc warshall_floyd_nonnegative_inplace_impl[T](d: var seq[seq[T]], zero, inf: T) =
        ## 負閉路がない正方隣接行列を最短距離で上書きする。O(V^3)。負辺も許容し、負閉路検査は行わない。
        for i in 0..<d.len:
            assert d[i].len == d.len, "隣接行列は正方行列である必要があります"
        for i in 0..<d.len:
            d[i][i] = zero
        warshall_floyd_nonnegative_run(d, zero, inf)

    proc warshall_floyd_nonnegative_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 非負辺の正方隣接行列から距離行列を求める。時間O(V^3)、追加領域O(V^2)。入力は変更しない。
        result = newSeqWith(a.len, newSeqWith(a.len, inf))
        for i in 0..<a.len:
            assert a[i].len == a.len, "隣接行列は正方行列である必要があります"
            for j in 0..<a.len:
                result[i][j] = a[i][j]
        warshall_floyd_nonnegative_inplace_impl(result, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph or seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[int32] or StaticGraph[int32] or seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[float] or StaticGraph[float] or seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[float32] or StaticGraph[float32] or seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*[T](g: WeightedGraph[T] or UnWeightedGraph or seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[int]], zero: int = 0, inf: int = INF64) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf: float = 1e100) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*[T](d: var seq[seq[T]], zero, inf: T) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[int]], zero: int = 0, inf: int = INF64) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf: float = 1e100) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*[T](d: var seq[seq[T]], zero, inf: T) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)
