# verification-helper: PROBLEM https://judge.yosupo.jp/problem/staticrmq
import sequtils
import cplib/collections/staticRMQ

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N,Q = ii()
var A = newseqwith(N,ii())
var RMQ = initRMQ(A)
for i in 0..<Q:
    var l,r = ii()
    stdout.writeLine(RMQ.query(l,r))