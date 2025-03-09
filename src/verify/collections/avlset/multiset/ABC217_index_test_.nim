# verification-helper: PROBLEM https://atcoder.jp/contests/abc217/tasks/abc217_d
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import options
import cplib/collections/avlset
var L, Q = ii()
var s = initAvlSortedMultiSet(@[0, L])
for i in 0..<Q:
    var c, x = ii()
    if c == 1:
        s.incl(x)
    else:
        var i = s.index(x)
        echo(s[i] - s[i-1])
