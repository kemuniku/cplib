# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
include cplib/graph/general_matching

var rng = initRand(876123)
for shape in 0..<5:
    for trial in 0..<20:
        let n = rng.rand(200..2000)
        var tree = initMatchingTreeUnion(n)
        var parent = newSeq[int](n)
        var deleted = newSeq[bool](n)
        var grown = 1
        for step in 0..<3*n:
            if grown < n and (step mod 3 != 2 or rng.rand(1) == 0):
                let v = grown
                let p = case shape
                    of 0: v - 1
                    of 1: 0
                    of 2: (v - 1) div 2
                    of 3: max(0, v - 2)
                    else: rng.rand(v - 1)
                parent[v] = p
                tree.grow(p, v)
                inc grown
            elif grown > 1:
                let v = rng.rand(1..<grown)
                tree.joinParent(v)
                deleted[v] = true
            for j in 0..<5:
                let v = rng.rand(grown - 1)
                var expected = v
                while deleted[expected]: expected = parent[expected]
                doAssert tree.root(v) == expected
        for v in 1..<grown:
            tree.joinParent(v)
        for v in 0..<grown:
            doAssert tree.root(v) == 0

echo "Hello World"
