# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind

import cplib/collections/persistent_unionfind

include cplib/tmpl/fastio
import tables
var N,Q = ii()
var UFS : Table[int,PersistentUnionFind]
UFS[-1] = initPersistentUnionFind(N)
for i in 0..<Q:
    var t,k,u,v = ii()
    if t == 0:
        UFS[i] = UFS[k].unite(u,v)
    else:
        print(if UFS[k].issame(u,v):1 else:0)
