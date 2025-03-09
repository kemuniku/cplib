# verification-helper: PROBLEM https://atcoder.jp/contests/abc286/tasks/abc286_ex
# verification-helper: ERROR 1e-6
import sequtils, strutils, std/math
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/intersect
import cplib/geometry/distance

var n = stdin.readLine.parseInt
proc get(): (int, int) =
    var s = stdin.readLine.split.map(parseInt)
    return (s[0], s[1])
var v = newSeqWith(n, initPoint(get()))
var s = initPoint(get())
var t = initPoint(get())
proc valid(): bool =
    for i in 0..<n:
        var p1 = v[i]
        var p2 = v[(i+1) mod n]
        if intersect(initSegment(s, t), initSegment(p1, p2)): return true
    return false
if not valid():
    echo sqrt(float(norm(s - t)))
    quit()
var vi = convex_hull(v & @[s, t])
var pos: int
for i in 0..<vi.len:
    if vi.v[i] == s: (pos = i; break)
vi.v = vi.v[pos..<vi.len] & vi.v[0..<pos]
for i in 0..<vi.len:
    if vi.v[i] == t: (pos = i; break)
var a1, a2 = 0.0
for i in 0..<pos:
    a1 += float(norm(vi.v[i], vi.v[i+1])).sqrt

for i in 1..<(vi.len-pos):
    a2 += float(norm(vi.v[^(i)], vi.v[^(i+1)])).sqrt
a2 += float(norm(vi.v[^1], vi.v[0])).sqrt
echo min(a1, a2)
