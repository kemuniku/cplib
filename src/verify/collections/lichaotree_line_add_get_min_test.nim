# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min
import cplib/collections/lichaotree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

type Operation = tuple[kind, a, b, x: int]
const shift = 1_100_000_000
let n = ii()
let q = ii()
var operations: seq[Operation]
var coordinates: seq[int]
var shiftedCoordinates: seq[int]
for i in 0..<n:
    let a = ii()
    let b = ii()
    operations.add((0, a, b, 0))
for i in 0..<q:
    let kind = ii()
    if kind == 0:
        let a = ii()
        let b = ii()
        operations.add((0, a, b, 0))
    else:
        let x = ii()
        operations.add((1, 0, 0, x))
        coordinates.add(x)
        shiftedCoordinates.add(x + shift)
let native = initLiChaoTree(coordinates)
let shifted = initLiChaoTree(shiftedCoordinates)
for operation in operations:
    if operation.kind == 0:
        native.add_line(operation.a, operation.b)
        shifted.add_line(operation.a, operation.b - operation.a * shift)
    else:
        let answer = shifted.get_min(operation.x + shift)
        doAssert answer == native.get_min(operation.x)
        echo answer
