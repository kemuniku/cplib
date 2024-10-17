import cplib/modint/modint
import cplib/matrix/determinant
import sequtils,strutils

type mint = modint998244353_barrett

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N = ii()
var A = newSeqWith(N,newSeqWith(N,ii().mint()))
echo determinant(A)
