# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph_with_op

proc sum(a, b: int): int = a + b
proc maximum(a, b: int): int = max(a, b)
proc xorValue(a, b: int): int = a xor b
let zeroGraph = initFunctionalGraph_with_op(@[0], @[0], sum, 0)
let maxGraph = initFunctionalGraph_with_op(@[0], @[7], maximum, low(int))
let xorGraph = initFunctionalGraph_with_op(@[0], @[7], xorValue, 0)
for k in [high(int)-2, high(int)-1, high(int)]:
    doAssert zeroGraph.prod(0, k) == 0
    doAssert zeroGraph.prod(0, k, false) == 0
    doAssert maxGraph.prod(0, k) == 7
    doAssert maxGraph.prod(0, k, false) == 7
    doAssert xorGraph.prod(0, k) == (if (k and 1) == 0: 7 else: 0)
    doAssert xorGraph.prod(0, k, false) == (if (k and 1) == 1: 7 else: 0)

let cycleGraph = initFunctionalGraph_with_op(@[1, 2, 0], @[1, 2, 4], xorValue, 0)
for start in 0..2:
    for k in [0, 1, 2, 5, 6, high(int)-2, high(int)-1, high(int)]:
        var expected = 0
        for offset in 0..<int((uint(k)+1'u) mod 6'u):
            expected = expected xor [1, 2, 4][(start+offset) mod 3]
        doAssert cycleGraph.prod(start, k) == expected
        expected = 0
        for offset in 0..<int(uint(k) mod 6'u):
            expected = expected xor [1, 2, 4][(start+offset+1) mod 3]
        doAssert cycleGraph.prod(start, k, false) == expected

let next = @[1, 2, 0, 2, 3]
let values = @[1, 2, 4, 8, 16]
let tailGraph = initFunctionalGraph_with_op(next, values, maximum, low(int))
for start in 0..<next.len:
    var vertex = start
    var expected = low(int)
    for k in 0..30:
        expected = max(expected, values[vertex])
        doAssert tailGraph.prod(start, k) == expected
        vertex = next[vertex]
    doAssert tailGraph.prod(start, high(int)) == expected
echo "Hello World"
