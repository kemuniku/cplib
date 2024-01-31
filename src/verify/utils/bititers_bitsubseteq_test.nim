# verification-helper: PROBLEM https://atcoder.jp/contests/abc269/tasks/abc269_c
import cplib/utils/bititers
import sequtils, strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N = ii()
echo bitsubseteq(N).toseq().join("\n")
