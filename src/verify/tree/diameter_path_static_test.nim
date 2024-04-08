# verification-helper: PROBLEM https://atcoder.jp/contests/abc221/tasks/abc221_f
import sequtils, math
import cplib/tree/tree
import cplib/tree/diameter
import cplib/modint/modint
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
type mint = mint998244353_montgomery

var n = ii()
var g = initUnWeightedStaticTree(n)
for i in 0..<n-1:
    var u, v = ii() - 1
    g.add_edge(u, v)
g.build

var (d, path) = g.diameter_path
if d mod 2 == 0:
    var center = path[d div 2]
    var cnt = 0
    proc find_leaf(x, par, di: int) =
        if di == d div 2 - 1: cnt += 1
        for y in g[x]:
            if y == par: continue
            find_leaf(y, x, di+1)
    var t = newSeq[mint]()
    for x in g[center]:
        cnt = 0
        find_leaf(x, center, 0)
        t.add(mint(cnt + 1))
    echo (t.foldl(a * b) - t.sum + t.len - 1)
else:
    var c1 = path[d div 2]
    var c2 = path[(d+1) div 2]
    proc find_leaf(x, par, di: int): int =
        if di == d div 2: result += 1
        for y in g[x]:
            if y == par: continue
            result += find_leaf(y, x, di+1)
    var ch1 = find_leaf(c1, c2, 0)
    var ch2 = find_leaf(c2, c1, 0)
    echo (mint(ch1) * mint(ch2))
