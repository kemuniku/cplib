# verification-helper: PROBLEM https://atcoder.jp/contests/abc336/tasks/abc336_f
import cplib/collections/hashset
import cplib/matrix/matops
import sequtils, strutils, hashes, sugar, deques

var h, w: int
(h, w) = stdin.readLine.split.map(parseInt)
var s = newSeq[seq[int]](h)
for i in 0..<h: s[i] = stdin.readLine.split.map(parseInt)
var t = collect(newSeq): (for i in 0..<h: (i*w+1..i*w+w).toseq)
proc bfs(s: seq[seq[int]]): seq[seq[Hash]] =
    result = newSeqWith(11, newSeq[Hash](0))
    result[0].add(hash(s))
    var q = @[(0, s)].toDeque
    var seen = @[hash(s)].toHashSet
    while q.len > 0:
        var (d, s) = q.popFirst
        for sx in 0..1:
            for sy in 0..1:
                var si = s[sx..<sx+h-1].mapIt(it[sy..<sy+w-1]).rotated(2)
                var sn = s
                for i in 0..<h-1:
                    for j in 0..<w-1:
                        sn[sx+i][sy+j] = si[i][j]
                var sh = hash(sn)
                if sh notin seen:
                    seen.incl(sh)
                    result[d+1].add(sh)
                    if d+1 != 10:
                        q.addLast((d+1, sn))
    return result
var tb1 = bfs(s)
var tb2 = bfs(t).mapIt(it.toHashSet)
var ans = 30
for k, v in tb1:
    for si in v:
        for i in 0..10:
            if si in tb2[i]:
                ans = min(ans, i + k)
                break
echo if ans == 30: -1 else: ans
