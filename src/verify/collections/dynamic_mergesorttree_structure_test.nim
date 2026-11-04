# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
include cplib/collections/dynamic_mergesorttree
import random

proc inspect[T](self: DynamicMergeSortTree[T], node, parent: int,
        seen: var seq[bool], ordered: var seq[T]): tuple[size, height: int] =
    if node == 0: return (0, 0)
    doAssert 0 < node and node < self.nodes.len
    doAssert not seen[node]
    seen[node] = true
    doAssert self.nodes[node].parent == parent
    let left = self.inspect(self.nodes[node].left, node, seen, ordered)
    ordered.add(self.nodes[node].key)
    let right = self.inspect(self.nodes[node].right, node, seen, ordered)
    doAssert self.nodes[node].size == left.size + right.size + 1
    doAssert self.nodes[node].height == max(left.height, right.height) + 1
    doAssert abs(left.height - right.height) <= 1
    (self.nodes[node].size, self.nodes[node].height)

proc inspectSegments[T](self: DynamicMergeSortTree[T], segment, l, r: int,
        seen: var seq[bool]) =
    var ordered, expected: seq[T]
    let actual = self.inspect(self.data[segment], 0, seen, ordered)
    for i in l..<min(r, self.len): expected.add(self[i])
    expected.sort(proc(a, b: T): int =
        if a < b: -1
        elif b < a: 1
        else: 0)
    doAssert actual.size == expected.len
    doAssert ordered == expected
    if r-l > 1:
        let mid = l + (r-l) div 2
        self.inspectSegments(segment*2, l, mid, seen)
        self.inspectSegments(segment*2+1, mid, r, seen)

proc inspectTree[T](self: DynamicMergeSortTree[T]) =
    var seen = newSeq[bool](self.nodes.len)
    seen[0] = true
    self.inspectSegments(1, 0, self.base, seen)
    for reachable in seen: doAssert reachable
    doAssert self.nodes[0].size == 0 and self.nodes[0].height == 0

const sizes = [0, 1, 2, 3, 4, 5, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65, 127, 129]
for seed, n in sizes:
    var rng = initRand(20261006 + seed)
    var a = newSeq[int](n)
    for i in 0..<n: a[i] = rng.rand(-3..3)
    let tree = initDynamicMergeSortTree(a)
    tree.inspectTree()
    for step in 0..<1500:
        if n > 0:
            let i = if step mod 3 == 0: 0
                    elif step mod 3 == 1: n-1
                    else: rng.rand(n-1)
            let value = if step mod 7 == 0: a[i]
                        elif step mod 11 == 0: low(int)
                        elif step mod 13 == 0: high(int)
                        else: rng.rand(-10000..10000)
            tree[i] = value
            a[i] = value
        if step mod 37 == 0: tree.inspectTree()
    for value in [7, 7, -100000, 100000]:
        for i in 0..<n: tree[i] = value
        tree.inspectTree()
        doAssert tree.count(0, n, value) == n
    for i in 0..<n:
        tree[i] = i
        tree.inspectTree()
    for i in countdown(n-1, 0):
        tree[i] = -i
        tree.inspectTree()

block:
    let tree = initDynamicMergeSortTree(@["b", "a", "b", "c", "a"])
    for step in 0..<1000:
        tree[step mod 5] = $step
        if step mod 37 == 0:
            GC_fullCollect()
            tree.inspectTree()

echo "Hello World"
