# verification-helper: PROBLEM https://atcoder.jp/contests/abc265/tasks/abc265_b
import sequtils, tables, sugar
import cplib/collections/segtree

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, M, T = ii()
var A = newSeqWith(N-1, ii())
var st = initSegmentTree(A, (a, b: int) => (a + b), 0)
var bonus = initTable[int, int]()
for _ in 0..<M:
    var X, Y = ii()
    bonus[X] = Y
var now = 1
for i in 0..<N-1:
    if T > st[i]:
        T -= st[i]
        now += 1
        if now in bonus:
            T += bonus[now]
    else:
        echo ("No")
        quit()
echo ("Yes")
