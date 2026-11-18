# verification-helper: PROBLEM https://judge.yosupo.jp/problem/longest_increasing_subsequence
import sequtils, strutils
import cplib/utils/lis

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

let n = ii()
let a = newSeqWith(n, ii())
let indices = restore_lis_index(a)
let values = restore_lis(a)
doAssert indices.len == lis(a)
doAssert values.len == indices.len
for i in 0..<indices.len:
    doAssert values[i] == a[indices[i]]
echo indices.len
echo indices.join(" ")
