when not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:
    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND* = 1
    import bitops

    const PersistentUFBranchBits = 4
    const PersistentUFBranchSize = 1 shl PersistentUFBranchBits
    const PersistentUFBranchMask = PersistentUFBranchSize - 1
    type
        PersistentUFNode = array[PersistentUFBranchSize, int32]
        PersistentUFPool = ref object
            # 同じ初期状態から派生した版で共有する追記専用プール。
            # 個々の版の破棄では解放せず、全ての版の破棄時にまとめて解放する。
            nodes: seq[PersistentUFNode]
        PersistentUnionFind* = ref object
            count*: int
            size: int
            height: int
            node: int32
            pool: PersistentUFPool

    proc initPersistentUnionFind*(N: int): PersistentUnionFind =
        assert N >= 0 and N.int64 <= int32.high.int64
        result = PersistentUnionFind(count: N, size: N,
            pool: PersistentUFPool(nodes: newSeq[PersistentUFNode](1)))
        if N > 1:
            result.height = (fastLog2(N - 1) div PersistentUFBranchBits) * PersistentUFBranchBits

    proc get(self: PersistentUnionFind, index: int): int32 {.inline.} =
        # node == 0 は未更新の部分木（全要素 -1）を表す。
        var node = self.node
        var shift = self.height
        while node != 0 and shift > 0:
            node = self.pool.nodes[node.int][(index shr shift) and PersistentUFBranchMask]
            shift -= PersistentUFBranchBits
        if node == 0:
            return -1
        return self.pool.nodes[node.int][index and PersistentUFBranchMask]

    proc rootAndSize(self: PersistentUnionFind, x: int): tuple[root: int, size: int32] {.inline.} =
        assert x >= 0 and x < self.size
        var x = x
        var value = self.get(x)
        while value >= 0:
            x = value.int
            value = self.get(x)
        return (x, value)

    proc copyNode(pool: PersistentUFPool, node: int32, shift: int): int32 {.inline.} =
        var data = pool.nodes[node.int]
        if node == 0 and shift == 0:
            for value in data.mitems:
                value = -1
        assert pool.nodes.len < int32.high.int
        result = pool.nodes.len.int32
        pool.nodes.add(data)

    proc setOne(pool: PersistentUFPool, node: int32, shift, index: int, value: int32): int32 =
        result = pool.copyNode(node, shift)
        let slot = (index shr shift) and PersistentUFBranchMask
        if shift == 0:
            pool.nodes[result.int][slot] = value
        else:
            # 再帰中に nodes が再確保されるため、代入先の参照を保持しない。
            let child = pool.setOne(pool.nodes[result.int][slot], shift - PersistentUFBranchBits, index, value)
            pool.nodes[result.int][slot] = child

    # 2点の更新経路が共通する部分は一度だけコピーする。
    proc setTwo(pool: PersistentUFPool, node: int32, shift, x, y: int, xv, yv: int32): int32 =
        result = pool.copyNode(node, shift)
        let xs = (x shr shift) and PersistentUFBranchMask
        let ys = (y shr shift) and PersistentUFBranchMask
        if shift == 0:
            pool.nodes[result.int][xs] = xv
            pool.nodes[result.int][ys] = yv
        elif xs == ys:
            let child = pool.setTwo(pool.nodes[result.int][xs], shift - PersistentUFBranchBits, x, y, xv, yv)
            pool.nodes[result.int][xs] = child
        else:
            let xc = pool.setOne(pool.nodes[result.int][xs], shift - PersistentUFBranchBits, x, xv)
            pool.nodes[result.int][xs] = xc
            let yc = pool.setOne(pool.nodes[result.int][ys], shift - PersistentUFBranchBits, y, yv)
            pool.nodes[result.int][ys] = yc

    proc root*(self: PersistentUnionFind, x: int): int =
        return self.rootAndSize(x).root

    proc issame*(self: PersistentUnionFind, x: int, y: int): bool =
        return self.rootAndSize(x).root == self.rootAndSize(y).root

    proc unite*(self: PersistentUnionFind, x: int, y: int): PersistentUnionFind =
        var a = self.rootAndSize(x)
        var b = self.rootAndSize(y)
        result = PersistentUnionFind(count: self.count, size: self.size,
            height: self.height, node: self.node, pool: self.pool)
        if a.root == b.root:
            return
        if a.size > b.size:
            swap(a, b)
        result.node = self.pool.setTwo(self.node, self.height,
            a.root, b.root, a.size + b.size, a.root.int32)
        dec result.count

    proc siz*(self: PersistentUnionFind, x: int): int =
        return -self.rootAndSize(x).size.int
