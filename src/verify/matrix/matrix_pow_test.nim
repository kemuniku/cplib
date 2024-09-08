# verification-helper: PROBLEM https://judge.yosupo.jp/problem/pow_of_matrix
import cplib/modint/modint
import cplib/matrix/matrix
import sequtils,strutils

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

type mint = modint998244353_montgomery
var N,K = ii()
var A = newSeqWith(N,newSeqWith(N,mint(ii()))).toMatrix()
var B = A.pow(K)
for i in 0..<N:
    echo B[i].join(" ")