when not declared CPLIB_COLLECTIONS_DYNAMIC_LICHAOTREE:
    const CPLIB_COLLECTIONS_DYNAMIC_LICHAOTREE* = 1
    import options
    import cplib/math/int128

    type
        DynamicLiChaoNode = object
            a, b: int
            left, right: int32
            hasLine: bool
        DynamicLiChaoTree* = ref object
            nodes: seq[DynamicLiChaoNode]
            lower, upper: int

    proc initDynamicLiChaoTree*(l, r: int): DynamicLiChaoTree =
        ## 整数領域[l,r)の最小値木を初期化します。座標登録は不要。O(1)。
        if l >= r:
            raise newException(ValueError, "領域はl < rである必要があります")
        DynamicLiChaoTree(lower: l, upper: r,
            nodes: @[DynamicLiChaoNode(left: -1, right: -1)])

    proc checkTree(self: DynamicLiChaoTree) =
        ## 初期化済みの木であることを確認します。O(1)。
        if self.isNil:
            raise newException(ValueError, "木が初期化されていません")

    proc node_count*(self: DynamicLiChaoTree): int =
        ## 現在のノード数を返します。O(1)。
        self.checkTree()
        self.nodes.len

    proc midpoint(l, r: int): int =
        ## 差と和を128bitで計算して中点を返します。O(1)。
        (to_Int128(l) + (to_Int128(r) - to_Int128(l)) div 2).to_int

    proc lineValue(a, b, x: int): Int128 =
        ## 積と和を128bitで計算します。O(1)。
        to_Int128(a) * to_Int128(x) + to_Int128(b)

    proc child(self: DynamicLiChaoTree, now: int, right: bool): int =
        ## 指定した子だけを必要に応じて生成します。償却O(1)。
        result = int(if right: self.nodes[now].right else: self.nodes[now].left)
        if result >= 0: return
        if self.nodes.len >= int(high(int32)):
            raise newException(ValueError, "ノード数がint32の上限に達しました")
        result = self.nodes.len
        self.nodes.add(DynamicLiChaoNode(left: -1, right: -1))
        if right: self.nodes[now].right = int32(result)
        else: self.nodes[now].left = int32(result)

    proc insertLine(self: DynamicLiChaoTree, a, b, start, lo, hi: int) =
        ## 指定部分木に直線を追加します。O(log U)、新規ノードは高々1個。
        var a = a
        var b = b
        var now = start
        var l = lo
        var r = hi
        while true:
            if not self.nodes[now].hasLine:
                self.nodes[now].a = a
                self.nodes[now].b = b
                self.nodes[now].hasLine = true
                return
            let left = lineValue(a, b, l) < lineValue(self.nodes[now].a, self.nodes[now].b, l)
            let right = lineValue(a, b, r - 1) < lineValue(self.nodes[now].a, self.nodes[now].b, r - 1)
            if left == right:
                if left:
                    self.nodes[now].a = a
                    self.nodes[now].b = b
                return
            let m = midpoint(l, r)
            let mid = lineValue(a, b, m) < lineValue(self.nodes[now].a, self.nodes[now].b, m)
            if mid:
                swap(a, self.nodes[now].a)
                swap(b, self.nodes[now].b)
            if left != mid:
                now = self.child(now, false)
                r = m
            else:
                now = self.child(now, true)
                l = m

    proc add_line*(self: DynamicLiChaoTree, a, b: int) =
        ## 領域全体にax+bを追加します。償却O(log U)、新規ノードは高々1個。
        self.checkTree()
        self.insertLine(a, b, 0, self.lower, self.upper)

    proc insertSegment(self: DynamicLiChaoTree, a, b, now, ql, qr, l, r: int) =
        ## 被覆区間にだけ直線を追加します。償却O(log²U)。
        if ql <= l and r <= qr:
            self.insertLine(a, b, now, l, r)
            return
        let m = midpoint(l, r)
        if ql < m:
            self.insertSegment(a, b, self.child(now, false), ql, qr, l, m)
        if m < qr:
            self.insertSegment(a, b, self.child(now, true), ql, qr, m, r)

    proc add_segment*(self: DynamicLiChaoTree, a, b, l, r: int) =
        ## ax+bを[l,r)と領域の共通部分に追加します。l>=rは無操作。償却O(log²U)。
        self.checkTree()
        let ql = max(l, self.lower)
        let qr = min(r, self.upper)
        if ql < qr:
            self.insertSegment(a, b, 0, ql, qr, self.lower, self.upper)

    proc get_min*(self: DynamicLiChaoTree, x: int): Option[int] =
        ## xの最小値を返します。未被覆はnone、領域外・int範囲外はValueError。O(log U)。
        self.checkTree()
        if x < self.lower or self.upper <= x:
            raise newException(ValueError, "クエリ座標が領域外です")
        var now = 0
        var l = self.lower
        var r = self.upper
        var found = false
        var best: Int128
        while now >= 0:
            if self.nodes[now].hasLine:
                let value = lineValue(self.nodes[now].a, self.nodes[now].b, x)
                if not found or value < best:
                    found = true
                    best = value
            let m = midpoint(l, r)
            if x < m:
                now = int(self.nodes[now].left)
                r = m
            else:
                now = int(self.nodes[now].right)
                l = m
        if found:
            if best < to_Int128(low(int)) or to_Int128(high(int)) < best:
                raise newException(ValueError, "最小値がintの範囲に収まりません")
            result = some(best.to_int)
