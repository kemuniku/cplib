# verification-helper: PROBLEM https://atcoder.jp/contests/abc042/tasks/arc058_b
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/modint/modint
import cplib/math/combination
type mint = modint_barrett
mint.setMod(1000000007)

var h, w, a, b = ii()
var c = initCombination[mint](h+w)
proc get(h, w: int): mint = c.ncr(h+w-2, h-1)
var ans = mint(0)
for i in b+1..w:
    ans += get(h-a, i) * get(a, w-i+1)
echo ans
