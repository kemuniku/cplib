# verification-helper: PROBLEM https://atcoder.jp/contests/abc348/tasks/abc348_c
import tables, sequtils
import cplib/collections/defaultdict
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)


var n = ii()
var d = initDefaultDict[int, int](1000_000_000_000.int)
for _ in 0..<n:
    var a, c = ii()
    d[c] = min(d[c], a)
echo d.values.toseq.max
