# verification-helper: PROBLEM https://judge.yosupo.jp/problem/largest_rectangle

import sequtils
import cplib/utils/largest_rectangle

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

let n = ii()
let heights = newSeqWith(n, ii())
echo largest_rectangle(heights)
