# verification-helper: PROBLEM https://atcoder.jp/contests/abc170/tasks/abc170_e
import cplib/collections/deletable_heapqueue
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N,Q = ii()
var A:seq[int]
var B:seq[int]
var hqs = newseqwith(200001,initDeletableHeapQueue[int]())
var now = initDeletableHeapQueue[int]()
for i in 0..<N:
    var a = ii()
    var b = ii()
    A.add(a)
    B.add(b)
    hqs[b].push(-a)


for i in 1..200000:
    if len(hqs[i]) > 0:
        now.push(-hqs[i][0])

for i in 0..<Q:
    var C = ii()-1
    var D = ii()
    now.delete(-hqs[B[C]][0])
    if len(hqs[D]) >= 1:
        now.delete(-hqs[D][0])
    hqs[B[C]].delete(-A[C])
    hqs[D].push(-A[C])
    if len(hqs[B[C]]) >= 1:
        now.push(-hqs[B[C]][0])
    now.push(-hqs[D][0])
    B[C] = D
    echo now[0]


