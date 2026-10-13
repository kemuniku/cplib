# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, strutils
include cplib/collections/range_reverse_lazysegtree

type Action = object
    a, b: int
proc `==`(f, g: Action): bool {.error: "作用の等値比較を要求してはいけません".}
const identity = Action(a: 1, b: 0)
proc concat(l, r: string): string = l & r
proc mapping(f: Action, value: string): string =
    for c in value:
        result.add(char(ord('a') + (f.a * (ord(c) - ord('a')) + f.b) mod 17))
proc composition(f, g: Action): Action =
    Action(a: f.a * g.a mod 17, b: (f.a * g.b + f.b) mod 17)
proc setPriorities(node: RangeReverseLazySegmentTreeNode[string, Action]) =
    if node.isNil: return
    node.priority = 0
    setPriorities(node.left)
    setPriorities(node.right)
proc oracleApply(values: var seq[string], f: Action) =
    for value in values.mitems:
        for c in value.mitems:
            c = char(ord('a') + ((ord(c) - ord('a')) * f.a + f.b) mod 17)

for n in 0..8:
    for k in 0..n:
        var values: seq[string]
        for i in 0..<n: values.add($char(ord('a') + i))
        let seg = initRangeReverseLazySegmentTree(values, concat, "", mapping, composition, identity)
        seg.apply(0, n, Action(a: 2, b: 3))
        oracleApply(values, Action(a: 2, b: 3))
        seg.apply(0, n, Action(a: 3, b: 1))
        oracleApply(values, Action(a: 3, b: 1))
        seg.reverse(0, n)
        values.reverse()
        setPriorities(seg.root)
        let node = newNode("pq", 0'u64, identity)
        seg.root = seg.insertNode(seg.root, node, k)
        inc seg.length
        values.insert("pq", k)
        doAssert seg.fold == values.join("")
        doAssert seg.toSeq == values
        seg.apply(0, seg.len, Action(a: 4, b: 6))
        oracleApply(values, Action(a: 4, b: 6))
        seg.reverse(0, seg.len)
        values.reverse()
        seg.erase(n - k)
        values.delete(n - k)
        doAssert seg.fold == values.join("")
        doAssert seg.toSeq == values

echo "Hello World"
