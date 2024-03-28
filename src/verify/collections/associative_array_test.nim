# verification-helper: PROBLEM https://judge.yosupo.jp/problem/associative_array
import strutils
import cplib/collections/hashtable
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var q = ii()
var st = initHashTable[int, int]()
var ans = newSeqOfCap[int](q)
for _ in 0..<q:
    var t = ii()
    if t == 0:
        var k, v = ii()
        st[k] = v
    else:
        var k = ii()
        if k in st: ans.add(st[k])
        else: ans.add(0)
echo ans.join("\n")
