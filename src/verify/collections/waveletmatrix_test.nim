# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest
import cplib/collections/waveletmatrix
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var N,Q = ii()
var A = newseqwith(N,ii())
var WM = initWaveletMatrix(A)

for _ in 0..<(Q):
    var l,r,k = ii()
    stdout.writeLine WM.kth_smallest(l,r,k)