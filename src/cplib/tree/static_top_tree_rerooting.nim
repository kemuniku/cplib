when not declared CPLIB_TREE_STATIC_TOP_TREE_REROOTING:
    const CPLIB_TREE_STATIC_TOP_TREE_REROOTING* = 1

    import cplib/tree/static_top_tree
    import cplib/graph/graph
    export static_top_tree

    type RerootingStaticTopTreeDP*[X] = object
        ## Dynamic, all-directions tree DP.  `forward` is parent-to-child and
        ## `backward` is child-to-parent for every leaf cluster.
        ##
        ## Operation orientations are:
        ## - `rake(forward, forward) -> forward`
        ## - `rake2(backward, forward) -> backward`
        ## - `compress(forward, forward) -> forward`
        ## - `compress2(backward, backward) -> backward`
        ## - `compress3(backward, forward) -> backward`
        topology*: StaticTopTree
        forward*, backward*: seq[X]
        compress, rake, rake2, compress2, compress3: proc(a, b: X): X

    type DynamicRerootingTreeDP*[X] = RerootingStaticTopTreeDP[X]

    proc pull[X](self: var RerootingStaticTopTreeDP[X], k: int) {.inline.} =
        let l = self.topology.left[k]
        let r = self.topology.right[k]
        if self.topology.isCompress[k]:
            self.forward[k] = self.compress(self.forward[l], self.forward[r])
            self.backward[k] = self.compress2(self.backward[r], self.backward[l])
        else:
            self.forward[k] = self.rake(self.forward[l], self.forward[r])
            self.backward[k] = self.compress3(self.backward[l], self.forward[r])

    proc initRerootingStaticTopTreeDP*[X](topology: StaticTopTree,
            single: proc(v: int): (X, X),
            compress, rake, rake2, compress2, compress3: proc(a, b: X): X):
            RerootingStaticTopTreeDP[X] =
        result.topology = topology
        result.compress = compress
        result.rake = rake
        result.rake2 = rake2
        result.compress2 = compress2
        result.compress3 = compress3
        result.forward = newSeq[X](topology.clusterCount)
        result.backward = newSeq[X](topology.clusterCount)
        for v in 0..<topology.n:
            (result.forward[v], result.backward[v]) = single(v)
        for k in topology.n..<topology.clusterCount: result.pull(k)

    proc initRerootingStaticTopTreeDP*[X](g: UnDirectedGraph,
            single: proc(v: int): (X, X),
            compress, rake, rake2, compress2, compress3: proc(a, b: X): X,
            root: int = 0): RerootingStaticTopTreeDP[X] =
        initRerootingStaticTopTreeDP(initStaticTopTree(g, root), single,
            compress, rake, rake2, compress2, compress3)

    proc initDynamicRerootingTreeDP*[X](topology: StaticTopTree,
            single: proc(v: int): (X, X),
            compress, rake, rake2, compress2, compress3: proc(a, b: X): X):
            DynamicRerootingTreeDP[X] =
        initRerootingStaticTopTreeDP(topology, single, compress, rake,
            rake2, compress2, compress3)

    proc initDynamicRerootingTreeDP*[X](g: UnDirectedGraph,
            single: proc(v: int): (X, X),
            compress, rake, rake2, compress2, compress3: proc(a, b: X): X,
            root: int = 0): DynamicRerootingTreeDP[X] =
        initRerootingStaticTopTreeDP(g, single, compress, rake,
            rake2, compress2, compress3, root)

    proc set*[X](self: var RerootingStaticTopTreeDP[X], v: int,
                 x: (X, X)) =
        assert v in 0..<self.topology.n
        self.forward[v] = x[0]
        self.backward[v] = x[1]
        var k = self.topology.parent[v]
        while k != -1:
            self.pull(k)
            k = self.topology.parent[k]

    proc prodAll*[X](self: RerootingStaticTopTreeDP[X], v: int): X =
        ## Returns the aggregate when the tree is rooted at `v` in O(log N).
        assert v in 0..<self.topology.n
        var i = v
        var a = self.backward[i]
        var b, c: X
        var hasA = true
        var hasB = false
        var hasC = false
        while true:
            let p = self.topology.parent[i]
            if p == -1: break
            let l = self.topology.left[p]
            let r = self.topology.right[p]
            if self.topology.isCompress[p]:
                if l == i:
                    if hasB: b = self.compress(b, self.forward[r])
                    else:
                        b = self.forward[r]
                        hasB = true
                else:
                    if hasA: a = self.compress2(a, self.backward[l])
                    else:
                        a = self.backward[l]
                        hasA = true
            else:
                if l == i:
                    if not hasA:
                        if hasB: b = self.rake(b, self.forward[r])
                        else:
                            b = self.forward[r]
                            hasB = true
                    else:
                        a = self.compress3(a, self.forward[r])
                else:
                    if not hasA:
                        assert hasC and hasB
                        c = self.compress3(c, b)
                        hasA = false
                        b = self.forward[l]
                        hasB = true
                    else:
                        if hasB: a = self.rake2(a, b)
                        if hasC: c = self.compress2(c, a)
                        else:
                            c = a
                            hasC = true
                        hasA = false
                        b = self.forward[l]
                        hasB = true
            i = p
        if hasB: a = self.rake2(a, b)
        if hasC: result = self.compress2(c, a)
        else: result = a
