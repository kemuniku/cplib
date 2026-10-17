## 同じ台集合の二つのマトロイドに対する、無重み最大共通独立集合。
## 独立性 oracle は集合の要素 index を受け取り、独立なら true を返す。
## 順序によらず同じ集合には同じ結果を返し、空集合・遺伝性・交換公理を満たすこと。
## 渡される index は 0..<n の重複しない値。配列の順序は保証せず、
## 作業領域を再利用するので oracle は配列を保持・変更しないこと。
## 一般の制約 predicate や三つ以上のマトロイドには適用できない。
##
## 交換グラフで、第一のマトロイドに追加可能な要素を始点、第二に
## 追加可能な要素を終点として BFS する。集合内から集合外への辺は
## 第一、集合外から集合内への辺は第二で交換可能な場合に張る。
## 最短増加路との対称差は両方の独立性を保ち、要素数を一つ増やす。
## 増加路がなくなれば最大。重み付きの最適化は扱わない。
## 参考: https://arxiv.org/abs/1904.04129 （交換グラフと最短増加路）
##
## 利用例: 色ごとの上限を守る森（partition と graphic の交差）。
##
## .. code-block:: nim
##
##   import cplib/graph/matroid_intersection
##   import cplib/collections/unionfind
##   let edges = @[(0, 1), (1, 2), (0, 2), (2, 3)]
##   let colors = @[0, 0, 1, 1]
##   let limits = @[1, 1]
##   proc partition(items: openArray[int]): bool =
##       var counts = newSeq[int](limits.len)
##       for e in items:
##           inc counts[colors[e]]
##           if counts[colors[e]] > limits[colors[e]]: return false
##       true
##   proc graphic(items: openArray[int]): bool =
##       var uf = initUnionFind(4)
##       for e in items:
##           let (u, v) = edges[e]
##           if uf.issame(u, v): return false
##           uf.unite(u, v)
##       true
##   let forest = matroidIntersection(edges.len, partition, graphic)
##   # forest は元の edges の index。自己ループは非独立、多重辺は別要素。
##   # partition 同士なら二部マッチングなどにも使える。
when not declared CPLIB_GRAPH_MATROID_INTERSECTION:
    const CPLIB_GRAPH_MATROID_INTERSECTION* = 1

    type IndependenceOracle* = proc(items: openArray[int]): bool {.closure.}

    proc matroidIntersection*(n: int, independent1, independent2: IndependenceOracle): seq[int] =
        ## 最大共通独立集合の index を昇順で返す。n<0 は ValueError。
        ## 答えの要素数を r として oracle 呼び出し O(n(r+1)^2) 回、
        ## oracle 内部を除く時間 O(n(r+1)^2)、追加領域 O(n)。
        ## 各 oracle の最大費用 Q なら全時間 O(n(r+1)^2(1+Q))。
        ## oracle に渡す集合は高々 r+1 要素。n=0 では呼び出さない。
        ## k 要素の段階は O(n(k+1))。最後の失敗探索を含め高々 r+1 段階。
        if n < 0:
            raise newException(ValueError, "n must be nonnegative")
        var inside = newSeq[bool](n)
        var position = newSeq[int](n)
        var parent = newSeq[int](n)
        var queue = newSeqOfCap[int](n)
        var candidate = newSeqOfCap[int](n)
        while result.len < n:
            let k = result.len
            candidate.setLen(k)
            for i, e in result:
                candidate[i] = e
                position[e] = i
            queue.setLen(0)
            for e in 0..<n:
                parent[e] = -2
                if inside[e]: continue
                candidate.add(e)
                if independent1(candidate):
                    parent[e] = -1
                    queue.add(e)
                candidate.setLen(k)
            var head = 0
            var finish = -1
            while head < queue.len:
                let e = queue[head]
                inc head
                if not inside[e]:
                    candidate.add(e)
                    let sink = independent2(candidate)
                    candidate.setLen(k)
                    if sink:
                        finish = e
                        break
                    for i, f in result:
                        if parent[f] != -2: continue
                        candidate[i] = e
                        let exchange = independent2(candidate)
                        candidate[i] = f
                        if exchange:
                            parent[f] = e
                            queue.add(f)
                else:
                    let i = position[e]
                    for f in 0..<n:
                        if inside[f] or parent[f] != -2: continue
                        candidate[i] = f
                        let exchange = independent1(candidate)
                        candidate[i] = e
                        if exchange:
                            parent[f] = e
                            queue.add(f)
            if finish == -1: break
            var e = finish
            while e != -1:
                inside[e] = not inside[e]
                e = parent[e]
            result.setLen(0)
            for e in 0..<n:
                if inside[e]: result.add(e)
