# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product
{.checks:off.}
import cplib/modint/modint
import cplib/matrix/matrix
import sequtils,strutils

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type mint = modint998244353_montgomery
var N,M,K = ii()
var A = newSeqWith(N,newSeqWith(M,mint(ii()))).toMatrix()
var B = newSeqWith(M,newSeqWith(K,mint(ii()))).toMatrix()
var C = A*B
for i in 0..<N:
    echo C[i].join(" ")