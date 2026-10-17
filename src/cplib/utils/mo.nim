when not declared CPLIB_UTILS_MO:
    const CPLIB_UTILS_MO* = 1
    import math, algorithm
    import cplib/graph/graph
    type Mo* = object
        width*: int
        N, Q, offset: int
        bounded: bool
        qli: seq[seq[int]]
        size: int

    proc initMo*(N, Q: int, width = max(1, int(1.0 * float(N) / max(1.0, sqrt(float(Q) * 2.0 / 3.0))))): Mo =
        ## 長さN、クエリ数Qを想定して初期化する。時間・空間O(N / width + 1)。
        ## 64bit int環境専用。N,Qは非負、widthは正。widthは初期化後に変更しないこと。
        assert sizeof(int) == 8
        assert N >= 0 and Q >= 0 and width > 0
        result.width = width
        result.N = N
        result.Q = Q
        let qlisize = N div width + 1
        result.qli = newSeq[seq[int]](qlisize)

    proc initMo*(domain: HSlice[int, int], Q: int, width: int = 0): Mo =
        ## 両端点の許容範囲domain（両端を含む）で初期化する。時間・空間O(D / B + 1)。
        ## D = domain.b - domain.a は0以上2^20未満。絶対座標はint全域を許容する。
        ## Qとwidthは非負。幅0ならD,Qから自動決定する。64bit int環境専用。
        assert sizeof(int) == 8
        assert domain.a <= domain.b and Q >= 0 and width >= 0
        # 符号付きの端点差を取る前に、unsignedで範囲を検査する。
        let distance = cast[uint](domain.b) - cast[uint](domain.a)
        assert distance < (1u shl 20)
        let span = int(distance)
        let blockWidth = if width == 0:
            max(1, int(float(span) / max(1.0, sqrt(float(Q) * 2.0 / 3.0))))
        else: width
        result = initMo(span, Q, blockWidth)
        result.offset = domain.a
        result.bounded = true

    proc insert*(self: var Mo, l, r: int) =
        ## 座標(l, r)を登録する。l > rも許容する。償却O(1)。
        ## domain版は両端点がdomain内。N版は0 <= l <= N、-2^23 <= r <= N。
        ## offset後のlと登録番号は非負20bit、rは符号付き24bit。登録数は2^20以下。
        assert self.width > 0
        assert self.offset <= l and l <= self.offset + self.N
        if self.bounded:
            assert self.offset <= r and r <= self.offset + self.N
        else:
            assert -(1 shl 23) <= r and r < (1 shl 23) and r <= self.N
        let li = l - self.offset
        let ri = r - self.offset
        assert li < (1 shl 20) and ri < (1 shl 23)
        assert self.size < (1 shl 20)
        let packed = (cast[uint](ri) shl 40) or (uint(li) shl 20) or uint(self.size)
        self.qli[li div self.width].add(cast[int](packed))
        self.size += 1

    template run*(self: var Mo, add_left, add_right, delete_left, delete_right, remember: untyped,
            nl: int = 0, nr: int = 0) =
        ## 指定した初期端点(nl,nr)から処理し、登録順の番号をrememberに渡す。
        ## 初期端点もinsertと同じ範囲内とする。既定は従来どおり(0,0)。domainが0を含まない場合は両方を指定する。
        ## 呼び出し側で(nl,nr)の状態を準備すること。初期化用callbackは呼ばない。
        ## callbackには元の座標を渡す。終了時は最後のクエリの状態で、初期状態には戻さない。
        ## 再実行時も初期状態を準備すること。実行中に登録内容やwidthを変更しないこと。
        ## B=width、K=登録数。走査・ソートO(D/B + K log(K+1) + 1)、移動O(D²/B + KB + D)、空間O(K + D/B + 1)。
        ## Dはdomain版の端点差、N版は負のrと初期端点を含む座標の幅（少なくともN）。
        block:
            # ローカルに保持したコールバックを呼び出し側で最適化できるようにする。
            proc executeMo(solver: var Mo, initialLeft, initialRight: int) =
                ## コールバックを一度ずつ評価し、元の座標で両端点を動かす。
                assert solver.width > 0
                assert solver.offset <= initialLeft and initialLeft <= solver.offset + solver.N
                assert initialLeft - solver.offset < (1 shl 20)
                if solver.bounded:
                    assert solver.offset <= initialRight and initialRight <= solver.offset + solver.N
                else:
                    assert -(1 shl 23) <= initialRight and initialRight < (1 shl 23) and initialRight <= solver.N
                {.push checks: off.}
                let callbackAddLeft = add_left
                let callbackAddRight = add_right
                let callbackDeleteLeft = delete_left
                let callbackDeleteRight = delete_right
                let callbackRemember = remember
                var left = initialLeft
                var right = initialRight
                const mask2 = ((1 shl 20)-1) shl 20
                const mask3 = ((1 shl 20)-1)
                for i in 0..<len(solver.qli):
                    if len(solver.qli[i]) == 0:
                        continue
                    sort(solver.qli[i])
                    if (i and 1) == 1:
                        reverse(solver.qli[i])
                    for x in solver.qli[i]:
                        let ri = (x shr 40) + solver.offset
                        let li = ((x and mask2) shr 20) + solver.offset
                        let idx = x and mask3
                        while left > li: left.dec; callbackAddLeft(left)
                        while right < ri: callbackAddRight(right); right.inc
                        while left < li: callbackDeleteLeft(left); left.inc
                        while right > ri: right.dec; callbackDeleteRight(right)
                        callbackRemember(idx)
                {.pop.}
            executeMo(self, nl, nr)

    type TreeMo* = object
        width*: int
        tour, first: seq[int]
        queries: seq[tuple[left, right, idx: int]]

    iterator treeMoNeighbors(g: UnDirectedGraph or seq[seq[int]], u: int): int =
        ## 木の隣接頂点を列挙する。O(deg(u))。
        when g is seq[seq[int]]:
            for v in g[u]: yield v
        else:
            for (v, _) in g.to_and_cost(u): yield v

    proc initTreeMo*(g: UnDirectedGraph or seq[seq[int]], Q: int,
            root: int = 0, width: int = 0): TreeMo =
        ## 無向木gのパスクエリQ個を想定して初期化する。時間・空間O(N)。
        ## 隣接リストは両方向の辺を含め、静的グラフはbuildしておくこと。重みは参照しない。
        ## 幅0ならEuler tourの長さとQから幅を決める。rootはrun開始時の1頂点パス。
        assert g.len > 0 and 0 <= root and root < g.len
        assert Q >= 0 and width >= 0
        result.first = newSeq[int](g.len)
        for v in 0..<g.len: result.first[v] = -1
        result.tour = newSeqOfCap[int](2 * g.len - 1)
        var stack = @[(vertex: root, parent: -1)]
        while stack.len > 0:
            let (u, p) = stack.pop()
            if u == -1:
                result.tour.add(p)
                continue
            assert 0 <= u and u < g.len
            assert result.first[u] == -1, "gは無向木である必要があります"
            result.first[u] = result.tour.len
            result.tour.add(u)
            for v in treeMoNeighbors(g, u):
                if v != p:
                    stack.add((vertex: -1, parent: u))
                    stack.add((vertex: v, parent: u))
        assert result.tour.len == 2 * g.len - 1, "gは連結である必要があります"
        let estimated = int(float(result.tour.len) / max(1.0, sqrt(float(Q) * 2.0 / 3.0)))
        result.width = if width == 0: max(1, estimated) else: min(width, result.tour.len)

    proc insert*(self: var TreeMo, u, v: int): int {.discardable.} =
        ## 両端を含む無向パス(u, v)を登録し、0始まりの登録番号を返す。償却O(1)。
        assert 0 <= u and u < self.first.len and 0 <= v and v < self.first.len
        let a = self.first[u]
        let b = self.first[v]
        result = self.queries.len
        self.queries.add((min(a, b), max(a, b), result))

    template run*(self: var TreeMo, add, delete, remember: untyped) =
        ## 常に1本のパスを維持して処理し、登録番号をrememberに渡す。終了時はrootの1頂点に戻す。
        ## 呼び出し前に状態をrootの1頂点パスに初期化すること。初期頂点を追加するコールバックは呼ばない。
        ## add(u, v)は端点uに辺(u, v)と頂点vを追加し、delete(u, v)は辺(u, v)と端点vを削除する。
        ## どちらの端にも操作するため、回答はパスの向きや追加順によらないこと。
        ## rememberは状態を変更せず、結果を登録番号で保存すること。実行中に登録内容を変更しないこと。
        ## 幅BでソートO(Q log Q)、追加・削除O(N²/B + QB + N)回、追加領域O(N + Q)。
        block:
            proc executeTreeMo(solver: var TreeMo) =
                ## コールバックを一度ずつ評価し、Euler tour上で両端を動かす。
                assert solver.width > 0, "initTreeMoで初期化してください"
                let callbackAdd = add
                let callbackDelete = delete
                let callbackRemember = remember
                if solver.queries.len == 0: return
                let width = solver.width
                solver.queries.sort(proc(a, b: tuple[left, right, idx: int]): int =
                    result = cmp(a.left div width, b.left div width)
                    if result == 0:
                        result = cmp(a.right, b.right)
                        if ((a.left div width) and 1) != 0: result = -result
                    if result == 0: result = cmp(a.idx, b.idx)
                )
                var contains = newSeq[bool](solver.first.len)
                contains[solver.tour[0]] = true
                var left, right: int
                template moveEndpoint(position, target: int) =
                    ## Euler tourに沿って端点を移動し、各操作の前後でパスを維持する。
                    while position != target:
                        let step = if position < target: 1 else: -1
                        let u = solver.tour[position]
                        let v = solver.tour[position + step]
                        if contains[v]:
                            callbackDelete(v, u)
                            contains[u] = false
                        else:
                            callbackAdd(u, v)
                            contains[v] = true
                        position += step
                for query in solver.queries:
                    moveEndpoint(left, query.left)
                    moveEndpoint(right, query.right)
                    callbackRemember(query.idx)
                moveEndpoint(left, 0)
                moveEndpoint(right, 0)
            executeTreeMo(self)
