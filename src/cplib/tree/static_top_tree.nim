when not declared CPLIB_TREE_STATIC_TOP_TREE:
    const CPLIB_TREE_STATIC_TOP_TREE* = 1

    import std/heapqueue
    import cplib/graph/graph

    type StaticTopTree* = object
        ## A balanced binary decomposition of a rooted tree.
        ## Leaves `0 ..< n` correspond to vertices (and their parent edges).
        n*, root*: int
        parent*, left*, right*: seq[int]
        isCompress*: seq[bool]
        treeParent*: seq[int]

    proc initStaticTopTree*(g: UnDirectedGraph, root: int = 0): StaticTopTree =
        ## Builds the topology in O(N log N).  Its height is O(log N).
        let n = g.len
        assert n > 0
        assert root in 0..<n
        var ans: StaticTopTree
        ans.n = n
        ans.root = root
        ans.parent = newSeq[int](n)
        ans.left = newSeq[int](n)
        ans.right = newSeq[int](n)
        ans.isCompress = newSeq[bool](n)
        ans.treeParent = newSeq[int](n)
        for i in 0..<n:
            ans.parent[i] = -1
            ans.left[i] = -1
            ans.right[i] = -1
            ans.treeParent[i] = -2

        var children = newSeq[seq[int]](n)
        var size = newSeq[int](n)
        var heavy = newSeq[int](n)
        for i in 0..<n: heavy[i] = -1

        ans.treeParent[root] = -1
        var order = @[root]
        var pos = 0
        while pos < order.len:
            let v = order[pos]
            inc pos
            for (to, _) in g.to_and_cost(v):
                if to == ans.treeParent[v]: continue
                assert ans.treeParent[to] == -2, "the graph must be a tree"
                ans.treeParent[to] = v
                children[v].add(to)
                order.add(to)
        for v in 0..<n:
            assert ans.treeParent[v] != -2, "the graph must be connected"
        for oi in countdown(n - 1, 0):
            let v = order[oi]
            size[v] = 1
            for to in children[v]:
                size[v] += size[to]
                if heavy[v] == -1 or size[to] > size[heavy[v]]:
                    heavy[v] = to

        proc newNode(l, r: int, compress: bool): int =
            result = ans.parent.len
            ans.parent.add(-1)
            ans.left.add(l)
            ans.right.add(r)
            ans.isCompress.add(compress)
            ans.parent[l] = result
            ans.parent[r] = result

        proc buildPath(head: int): (int, int) =
            var path: seq[int]
            var v = head
            while v != -1:
                path.add(v)
                v = heavy[v]

            var stack: seq[(int, int)] = @[(0, path[0])]

            proc mergeLastTwo() =
                let (h2, k2) = stack.pop()
                let (h1, k1) = stack.pop()
                stack.add((max(h1, h2) + 1, newNode(k1, k2, true)))

            for i in 1..<path.len:
                let pv = path[i - 1]
                var q: HeapQueue[(int, int)]
                # The second component is only a stable tie breaker.  The node
                # containing the heavy edge is kept as the left rake operand.
                q.push((0, path[i]))
                for c in children[pv]:
                    if c == heavy[pv]: continue
                    let (h, k) = buildPath(c)
                    q.push((h, k))
                var distinguished = path[i]
                while q.len >= 2:
                    let (h1, x0) = q.pop()
                    let (h2, y0) = q.pop()
                    var x = x0
                    var y = y0
                    if y == distinguished: swap(x, y)
                    let z = newNode(x, y, false)
                    if x == distinguished: distinguished = z
                    q.push((max(h1, h2) + 1, z))
                stack.add(q.pop())

                while true:
                    let m = stack.len
                    if m >= 3 and
                        (stack[m - 3][0] == stack[m - 2][0] or
                         stack[m - 3][0] <= stack[m - 1][0]):
                        let last = stack.pop()
                        mergeLastTwo()
                        stack.add(last)
                    elif m >= 2 and stack[m - 2][0] <= stack[m - 1][0]:
                        mergeLastTwo()
                    else:
                        break
            while stack.len >= 2: mergeLastTwo()
            result = stack[0]

        let (_, top) = buildPath(root)
        assert ans.parent.len == 2 * n - 1
        assert top == 2 * n - 2 or n == 1
        result = move(ans)

    proc len*(stt: StaticTopTree): int {.inline.} = stt.n
    proc clusterCount*(stt: StaticTopTree): int {.inline.} = stt.parent.len
    proc top*(stt: StaticTopTree): int {.inline.} = stt.parent.len - 1

    type StaticTopTreeDP*[X] = object
        ## Dynamic tree DP on a Static Top Tree.
        topology*: StaticTopTree
        data*: seq[X]
        compress: proc(a, b: X): X
        rake: proc(a, b: X): X

    type DynamicTreeDP*[X] = StaticTopTreeDP[X]

    proc pull[X](self: var StaticTopTreeDP[X], k: int) {.inline.} =
        let l = self.topology.left[k]
        let r = self.topology.right[k]
        if self.topology.isCompress[k]:
            self.data[k] = self.compress(self.data[l], self.data[r])
        else:
            self.data[k] = self.rake(self.data[l], self.data[r])

    proc initStaticTopTreeDP*[X](topology: StaticTopTree,
            single: proc(v: int): X,
            compress, rake: proc(a, b: X): X): StaticTopTreeDP[X] =
        result.topology = topology
        result.compress = compress
        result.rake = rake
        result.data = newSeq[X](topology.clusterCount)
        for v in 0..<topology.n: result.data[v] = single(v)
        for k in topology.n..<topology.clusterCount: result.pull(k)

    proc initStaticTopTreeDP*[X](g: UnDirectedGraph,
            single: proc(v: int): X,
            compress, rake: proc(a, b: X): X,
            root: int = 0): StaticTopTreeDP[X] =
        initStaticTopTreeDP(initStaticTopTree(g, root), single, compress, rake)

    proc initDynamicTreeDP*[X](topology: StaticTopTree,
            single: proc(v: int): X,
            compress, rake: proc(a, b: X): X): DynamicTreeDP[X] =
        initStaticTopTreeDP(topology, single, compress, rake)

    proc initDynamicTreeDP*[X](g: UnDirectedGraph,
            single: proc(v: int): X,
            compress, rake: proc(a, b: X): X,
            root: int = 0): DynamicTreeDP[X] =
        initStaticTopTreeDP(g, single, compress, rake, root)

    proc set*[X](self: var StaticTopTreeDP[X], v: int, x: X) =
        assert v in 0..<self.topology.n
        self.data[v] = x
        var k = self.topology.parent[v]
        while k != -1:
            self.pull(k)
            k = self.topology.parent[k]

    proc prodAll*[X](self: StaticTopTreeDP[X]): X {.inline.} =
        self.data[self.topology.top]
