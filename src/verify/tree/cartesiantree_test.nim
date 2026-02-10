# verification-helper: PROBLEM https://judge.yosupo.jp/problem/cartesian_tree
include prelude
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/tree/cartesiantree
var N = ii()
var A = newseqwith(N,ii())
var car_tree = A.cartesian_tree_tuple()
echo (0..<N).toseq().mapit(if car_tree[it].p != -1 : car_tree[it].p else : it).join(" ")
