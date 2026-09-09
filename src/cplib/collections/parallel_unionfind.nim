when not declared CPLIB_COLLECTIONS_PARALLEL_UNIONFIND:
    const CPLIB_COLLECTIONS_PARALLEL_UNIONFIND* = 1
    import sequtils

    type ParallelUnionFind* = ref object
        data: seq[int32]
        offsets: seq[int]
        n, components: int

    proc initParallelUnionFind*(N: int): ParallelUnionFind =
        ## N頂点で初期化します。時間・空間 O(N log N)。
        assert N >= 0
        result = ParallelUnionFind(n: N, components: N)
        var total = 0
        var width = 1
        while width <= N:
            result.offsets.add(total)
            let size = N - width + 1
            assert size <= high(int32).int - total
            total += size
            if width > N div 4: break
            width *= 4
        result.data = newSeqWith(total, -1'i32)

    proc find(self: ParallelUnionFind, x: int): int {.inline.} =
        ## 内部の頂点の代表を経路圧縮で求めます。償却 O(α(N))。
        result = x
        while self.data[result] >= 0:
            result = self.data[result].int
        var cur = x
        while cur != result:
            let next = self.data[cur].int
            self.data[cur] = result.int32
            cur = next

    proc root*(self: ParallelUnionFind, x: int): int =
        ## xの属する成分の代表を返します。償却 O(α(N))。
        assert 0 <= x and x < self.n
        self.find(x)

    proc issame*(self: ParallelUnionFind, x, y: int): bool =
        ## xとyが同じ成分に属するかを返します。償却 O(α(N))。
        self.root(x) == self.root(y)

    proc siz*(self: ParallelUnionFind, x: int): int =
        ## xの属する成分の頂点数を返します。償却 O(α(N))。
        -self.data[self.root(x)].int

    proc count*(self: ParallelUnionFind): int =
        ## 連結成分数を返します。O(1)。
        self.components

    proc roots*(self: ParallelUnionFind): seq[int] =
        ## 各成分の代表を列挙します。O(N)。
        result = newSeqOfCap[int](self.components)
        for x in 0..<self.n:
            if self.data[x] < 0: result.add(x)

    proc uniteBlock(self: ParallelUnionFind, p, dis, layer: int,
                    onMerge: proc(x, y: int) {.closure.}) =
        ## 長さ4^layerの区間を結合し、必要な場合だけ下の層へ伝播します。
        let base = self.offsets[layer]
        var x = self.find(base + p)
        var y = self.find(base + p + dis)
        if x == y: return
        if self.data[x] > self.data[y]: swap(x, y)
        if layer == 0 and onMerge != nil:
            onMerge(x, y)
        self.data[x] += self.data[y]
        self.data[y] = x.int32
        if layer == 0:
            dec self.components
            return
        let step = 1 shl (2 * layer - 2)
        for i in 0..<4:
            self.uniteBlock(p + i * step, dis, layer - 1, onMerge)

    proc unite*(self: ParallelUnionFind, a, b, len: int,
                onMerge: proc(x, y: int) {.closure.} = nil): int {.discardable.} =
        ## 各i in 0..<lenについてa+iとb+iを結合し、実際の結合回数を返します。
        ## Q回の区間結合の合計 O(N log N α(N) + Q log N)（コールバックの処理を除く）。
        ## onMerge(x, y)は結合直前に呼び、結合後はxが代表になります。
        ## コールバックからこの構造への結合操作は行わないでください。
        assert 0 <= a and a <= self.n and 0 <= b and b <= self.n
        assert 0 <= len and len <= self.n - a and len <= self.n - b
        if a == b or len == 0: return 0
        let la = min(a, b)
        let dis = max(a, b) - la
        var layer = 0
        var width = 1
        while width <= (len - 1) div 4:
            inc layer
            width *= 4
        let before = self.components
        var remaining = len
        while remaining > 0:
            remaining = max(0, remaining - width)
            self.uniteBlock(la + remaining, dis, layer, onMerge)
        before - self.components

    proc unite*(self: ParallelUnionFind, a, b: int,
                onMerge: proc(x, y: int) {.closure.} = nil): bool {.discardable.} =
        ## 2頂点を結合し、異なる成分を結合したかを返します。償却 O(α(N))。
        self.unite(a, b, 1, onMerge) != 0

    proc copy*(self: ParallelUnionFind): ParallelUnionFind =
        ## 独立なコピーを返します。時間・空間 O(N log N)。
        ParallelUnionFind(data: self.data, offsets: self.offsets,
                         n: self.n, components: self.components)
