# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph_with_op

proc minimum(a, b: int): int = min(a, b)
proc nonnegative(value: int): bool = value >= 0
proc impossible(value: int): bool = value > 10
let singleton = initFunctionalGraph_with_op(@[0], @[7], minimum, high(int))
for limit in [0, 1, 2, high(int)-1, high(int)]:
    doAssert singleton.move_while(nonnegative, 0, limit) == limit
    doAssert singleton.move_while(impossible, 0, limit) == 0

let tail = initFunctionalGraph_with_op(@[1, 2, 2], @[0, 0, 0], minimum, high(int))
for start in 0..2:
    for limit in [0, 1, 2, high(int)-1, high(int)]:
        doAssert tail.move_while(nonnegative, start, limit) == limit

let next = @[1, 2, 0, 2, 3]
let values = @[6, 2, 4, 8, 1]
let testGraph = initFunctionalGraph_with_op(next, values, minimum, high(int))
for start in 0..<next.len:
    for threshold in 0..9:
        let predicate = proc(value: int): bool = value >= threshold
        for limit in 0..60:
            var vertex = start
            var current = high(int)
            var expected = limit
            for step in 0..limit:
                current = min(current, values[vertex])
                if not predicate(current):
                    expected = step
                    break
                vertex = next[vertex]
            doAssert testGraph.move_while(predicate, start, limit) == expected
        var vertex = start
        var current = high(int)
        var expected = high(int)
        for step in 0..10:
            current = min(current, values[vertex])
            if not predicate(current):
                expected = step
                break
            vertex = next[vertex]
        doAssert testGraph.move_while(predicate, start, high(int)) == expected
echo "Hello World"
