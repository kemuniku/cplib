# verification-helper: PROBLEM https://judge.yosupo.jp/problem/area_of_union_of_rectangles
import cplib/utils/area_of_union_of_rectangles
include cplib/tmpl/sheep
var N = ii()

var tmp : seq[(int,int,int,int)]

for _ in range(N):
    var l,d,r,u = ii()
    tmp.add((l,d,r,u))

print area_of_union_of_rectangles(tmp)
