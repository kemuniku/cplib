# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_unionfind
import cplib/collections/persistent_binary_trie

when not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:
    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND* = 1
    import algorithm, sequtils, bitops
    type PersistentUnionFind* = ref object
        count*: int
        par_or_siz: PersistentBinaryTrie
    proc initPersistentUnionFind*(N: int): PersistentUnionFind =
        result = PersistentUnionFind(count: N, par_or_siz: initPersistentBineryTrie(fastLog2(N)+1))
    proc root*(self: PersistentUnionFind, x: int): int =
        var c = self.par_or_siz.count(x)-1
        if c < 0:
            return x
        else:
            return self.root(c)
    proc issame*(self: PersistentUnionFind, x: int, y: int): bool =
        return self.root(x) == self.root(y)
    proc unite*(self: PersistentUnionFind, x: int, y: int): PersistentUnionFind =
        var x = self.root(x)
        var y = self.root(y)
        result = PersistentUnionFind(count:self.count,par_or_siz:self.par_or_siz)
        if(x != y):
            if(result.par_or_siz.count(x) > result.par_or_siz.count(y)):
                swap(x, y)
            result.par_or_siz = result.par_or_siz.incl(x,result.par_or_siz.count(y)-1)
            result.par_or_siz = result.par_or_siz.set_value(y,x+1)
            result.count -= 1
    proc siz*(self: PersistentUnionFind, x: int): int =
        var x = self.root(x)
        return -(self.par_or_siz.count(x)) + 1

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import tables
var N,Q = ii()
var UFS : Table[int,PersistentUnionFind]
UFS[-1] = initPersistentUnionFind(N)
for i in 0..<Q:
    var t,k,u,v = ii()
    if t == 0:
        UFS[i] = UFS[k].unite(u,v)
    else:
        echo if UFS[k].issame(u,v):1 else:0
