when not declared CPLIB_COLLECTIONS_ROOTRANGESUMQUERY:
    const CPLIB_COLLECTIONS_ROOTRANGESUMQUERY* = 1
    import math
    import cplib/utils/backwards_index

    type RootRangeSumQuery*[T] = ref object
        blocksize: int
        localPrefix: seq[T]
        blockPrefix: seq[T]
        e: T

    proc initRootRangeSumQuery*[T](v: openArray[T], bsize: int = 0,
            e: T = 0): RootRangeSumQuery[T] =
        ## 加減算型の平方分割を構築する。時間・領域 O(N)。bsize=0 は約 sqrt(N)。
        assert bsize >= 0, "ブロック幅は0以上である必要があります"
        let width = if bsize == 0: max(v.len.float.sqrt.int, 1)
                    else: min(bsize, max(v.len, 1))
        let blocks = if v.len == 0: 0 else: (v.len - 1) div width + 1
        result = RootRangeSumQuery[T](blocksize: width,
            localPrefix: newSeq[T](v.len), blockPrefix: newSeq[T](blocks + 1), e: e)
        result.blockPrefix[0] = e
        var subtotal = e
        for i in 0..<v.len:
            subtotal = subtotal + v[i]
            result.localPrefix[i] = subtotal
            if i mod width == width - 1 or i == v.len - 1:
                let b = i div width
                result.blockPrefix[b + 1] = result.blockPrefix[b] + subtotal
                subtotal = e

    proc len*[T](self: RootRangeSumQuery[T]): int =
        ## 要素数を返す。O(1)。
        self.localPrefix.len

    proc prefix*[T](self: RootRangeSumQuery[T], r: Natural): T =
        ## 半開区間 [0,r) の和を返す。O(1)。
        assert r <= self.len, "r <= len が必要です"
        result = self.blockPrefix[r div self.blocksize]
        if r mod self.blocksize != 0:
            result = result + self.localPrefix[r - 1]

    proc get*[T](self: RootRangeSumQuery[T], l, r: Natural): T =
        ## 半開区間 [l,r) の和を返す。O(1)。
        assert l <= r and r <= self.len, "0 <= l <= r <= len が必要です"
        self.prefix(r) - self.prefix(l)

    proc get*[T](self: RootRangeSumQuery[T], segment: HSlice[int, int]): T =
        ## 両端を含む区間の和を返す。O(1)。
        assert segment.a >= 0 and segment.a <= self.len and
            segment.b >= segment.a - 1 and segment.b < self.len,
            "有効な区間を指定してください"
        self.get(segment.a, segment.b + 1)

    proc `[]`*[T](self: RootRangeSumQuery[T], segment: HSlice[int, int]): T =
        ## 両端を含む区間の和を返す。O(1)。
        self.get(segment)

    proc `[]`*[T](self: RootRangeSumQuery[T],
            index: Natural): T {.backwardsIndex.} =
        ## 一点の値を返す。O(1)。
        assert index < self.len, "index < len が必要です"
        let previous = if index mod self.blocksize == 0: self.e
                       else: self.localPrefix[index - 1]
        self.localPrefix[index] - previous

    proc update*[T](self: RootRangeSumQuery[T], index: Natural, val: T) =
        ## 一点を val に置き換える。O(B+ceil(N/B))、既定幅では O(sqrt(N))。
        assert index < self.len, "index < len が必要です"
        let delta = val - self[index]
        let start = index - index mod self.blocksize
        let finish = start + min(self.blocksize, self.len - start)
        for i in index..<finish:
            self.localPrefix[i] = self.localPrefix[i] + delta
        for b in (index div self.blocksize + 1)..<self.blockPrefix.len:
            self.blockPrefix[b] = self.blockPrefix[b] + delta

    proc `[]=`*[T](self: RootRangeSumQuery[T], index: Natural,
            val: T) {.backwardsIndex.} =
        ## 一点を val に置き換える。O(B+ceil(N/B))。
        self.update(index, val)
