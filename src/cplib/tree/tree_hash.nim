when not declared CPLIB_TREE_TREE_HASH:
    const CPLIB_TREE_TREE_HASH* = 1
    import std/random
    import cplib/graph/graph

    const TREE_HASH_MOD* = (1'u64 shl 61) - 1
    type
        TreeHashResult* = tuple[subtree, all_roots: seq[uint64]]
        TreeHashState = tuple[hash: uint64, height: int]
    const treeHashIdentity: TreeHashState = (1'u64, -1)
    var treeHashRandom = initRand()
    var treeHashDepth: seq[uint64]

    proc treeHashMul(a, b: uint64): uint64 =
        ## 61 bit 未満の値を、128 bit 整数を使わずに乗算する。
        const mask31 = (1'u64 shl 31) - 1
        const mask30 = (1'u64 shl 30) - 1
        let
            au = a shr 31
            al = a and mask31
            bu = b shr 31
            bl = b and mask31
            mid = al * bu + au * bl
            value = au * bu * 2 + (mid shr 30) +
                ((mid and mask30) shl 31) + al * bl
        result = (value shr 61) + (value and TREE_HASH_MOD)
        if result >= TREE_HASH_MOD: result -= TREE_HASH_MOD

    proc treeHashMerge(a, b: TreeHashState): TreeHashState =
        ## 子のハッシュの積と高さの最大値をまとめる。
        (treeHashMul(a.hash, b.hash), max(a.height, b.height))

    proc treeHashVertex(a: TreeHashState): TreeHashState =
        ## 子をまとめた値に、頂点とその部分木の高さを反映する。
        result.height = a.height + 1
        result.hash = a.hash + treeHashDepth[result.height]
        if result.hash >= TREE_HASH_MOD: result.hash -= TREE_HASH_MOD

    proc treeHashImpl(g: DirectedGraph or UnDirectedGraph, root: int,
                      reroot: static[bool]): TreeHashResult =
        ## 部分木を下から計算し、必要なら親側からの寄与も伝播する。
        let n = g.len
        if n == 0: return
        assert root in 0..<n
        while treeHashDepth.len < n:
            treeHashDepth.add(treeHashRandom.rand(0'u64..TREE_HASH_MOD - 1))
        var parent = newSeq[int](n)
        for v in 0..<n: parent[v] = -2
        parent[root] = -1
        var order = @[root]
        var children = newSeq[seq[int]](n)
        var index = 0
        while index < order.len:
            let u = order[index]
            inc index
            for (v, _) in g.to_and_cost(u):
                if v == parent[u]: continue
                assert parent[v] == -2, "入力は木である必要があります"
                parent[v] = u
                children[u].add(v)
                order.add(v)
        assert order.len == n, "指定した根から全頂点に到達できる必要があります"
        var down = newSeq[TreeHashState](n)
        result.subtree = newSeq[uint64](n)
        for i in countdown(n - 1, 0):
            let u = order[i]
            var value = treeHashIdentity
            for v in children[u]: value = treeHashMerge(value, down[v])
            down[u] = treeHashVertex(value)
            result.subtree[u] = down[u].hash
        when reroot:
            var up = newSeq[TreeHashState](n)
            up[root] = treeHashIdentity
            result.all_roots = newSeq[uint64](n)
            var prefix: seq[TreeHashState]
            for u in order:
                let count = children[u].len
                prefix.setLen(count + 1)
                prefix[0] = up[u]
                for i, v in children[u]:
                    prefix[i + 1] = treeHashMerge(prefix[i], down[v])
                result.all_roots[u] = treeHashVertex(prefix[count]).hash
                var suffix = treeHashIdentity
                for i in countdown(count - 1, 0):
                    let v = children[u][i]
                    up[v] = treeHashVertex(treeHashMerge(prefix[i], suffix))
                    suffix = treeHashMerge(down[v], suffix)

    proc subtree_hash*(g: DirectedGraph or UnDirectedGraph,
                       root: int = 0): seq[uint64] =
        ## root を根とした各頂点の部分木ハッシュを O(N) 時間・領域で返す。有向木は親から子へ辺を張る。
        treeHashImpl(g, root, false).subtree

    proc tree_hash*(g: UnDirectedGraph, root: int = 0): TreeHashResult =
        ## root に対する部分木と、各頂点を根とした木全体のハッシュを O(N) 時間・領域で返す。
        treeHashImpl(g, root, true)

    proc all_roots_hash*(g: UnDirectedGraph, root: int = 0): seq[uint64] =
        ## 各頂点を根とした木全体のハッシュを O(N) 時間・領域で返す。root は計算開始点。
        tree_hash(g, root).all_roots
