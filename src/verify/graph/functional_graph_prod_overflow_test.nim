# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph_with_op

proc sum(a, b: int): int = a + b
let singleton = initFunctionalGraph_with_op(@[0], @[1], sum, 0)
for k in [0, 1, 2, 10, high(int) div 2, high(int)-2, high(int)-1]:
    doAssert singleton.prod(0, k) == k + 1
    doAssert singleton.prod(0, k, false) == k

proc concatenate(a, b: string): string = a & b
let next = @[1, 2, 0, 2, 3]
let values = @["a", "b", "c", "d", "e"]
let textGraph = initFunctionalGraph_with_op(next, values, concatenate, "")
for start in 0..<next.len:
    var expected = ""
    var expectedWithout = ""
    var vertex = start
    for k in 0..30:
        expected &= values[vertex]
        if k > 0:
            expectedWithout &= values[vertex]
        doAssert textGraph.prod(start, k) == expected
        doAssert textGraph.prod(start, k, false) == expectedWithout
        vertex = next[vertex]
echo "Hello World"
