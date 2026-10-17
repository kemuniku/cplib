# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_count_distinct
import algorithm, sequtils, strutils
import cplib/utils/mo

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld\n", addr result)

let N = ii()
let Q = ii()
let values = newSeqWith(N, ii())
let coordinates = values.sorted().deduplicate(true)
let compressed = values.mapIt(coordinates.lowerBound(it))
var solver = initMo(-N..0, Q)
for i in 0..<Q:
    let l = ii()
    let r = ii()
    solver.insert(l - N, r - N)

var frequency = newSeq[int](coordinates.len)
var distinctCount = 0
var answers = newSeq[int](Q)
proc addValue(coordinate: int) =
    let id = compressed[coordinate + N]
    if frequency[id] == 0: inc distinctCount
    inc frequency[id]
proc deleteValue(coordinate: int) =
    let id = compressed[coordinate + N]
    dec frequency[id]
    if frequency[id] == 0: dec distinctCount
proc remember(idx: int) = answers[idx] = distinctCount

solver.run(addValue, addValue, deleteValue, deleteValue, remember, nl = -N, nr = -N)
echo answers.join("\n")
