# verification-helper: PROBLEM https://yukicoder.me/problems/no/2686
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
include sequtils, strutils, algorithm, sugar
import cplib/collections/segtree
import cplib/collections/hashtable

var n, m, q = ii()
var a, b = newSeq[int](n)
for i in 0..<n:
    a[i] = ii()
    b[i] = ii()

proc dp(a, b: seq[int]): HashTable[(int, int), int] =
    var n = a.len
    var dp = initHashTable[(int, int), int]()
    dp[(0, 0)] = 0
    for i in 0..<n:
        var dpn = dp
        for t, v in dp:
            var (x, y) = t
            if (x+a[i], y) in dpn: dpn[(x+a[i], y)] = max(dpn[(x+a[i], y)], v + b[i])
            else: dpn[(x+a[i], y)] = v + b[i]
            if (x, y+a[i]) in dpn: dpn[(x, y+a[i])] = max(dpn[(x, y+a[i])], v + b[i])
            else: dpn[(x, y+a[i])] = v + b[i]
        swap(dp, dpn)
    return dp
var dp1 = dp(a[0..<(n div 2)], b[0..<(n div 2)])
var dp2 = dp(a[(n div 2)..<n], b[(n div 2)..<n])

var c = dp2.keys.toSeq.mapIt(it[0]).sorted.deduplicate(true)
var add = newSeqWith(c.len, newSeq[(int, int)](0))
for k, v in dp2:
    var (x, y) = k
    add[c.lowerBound(x)].add((y, v))
var seg = newSegWith(newSeqWith(c.len, int(-3e18)), max(l, r), int(-3e18))

var qi = dp1.pairs.toseq.mapIt((it[0][0], it[0][1], it[1])).sortedByIt(-it[0])
var ans = 0
var pos = 0
for (x, y, v) in qi:
    while pos < c.len and m - x >= c[pos]:
        for (yn, vn) in add[pos]:
            seg[c.lowerBound(yn)] = max(seg[c.lowerBound(yn)], vn)
        pos += 1
    var r = c.upperBound(q - y)
    ans = max(ans, seg.get(0..<r) + v)
echo ans
