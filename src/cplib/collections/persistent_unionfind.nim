
when not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:
    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND* = 1
    import algorithm, sequtils, bitops
    import cplib/collections/persistent_array
    type PersistentUnionFind* = ref object
        count*: int
        par_or_siz: PersistentArray[6,int]

    proc initPersistentUnionFind*(N: int): PersistentUnionFind =
        result = PersistentUnionFind(count: N, par_or_siz: initPersistentArray(newseqwith(N,-1),6))
    proc root*(self: PersistentUnionFind, x: int): int =
        var c = self.par_or_siz[x]
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
            if(result.par_or_siz[x] > result.par_or_siz[y]):
                swap(x, y)
            result.par_or_siz = result.par_or_siz.change_value(x,result.par_or_siz[x] + result.par_or_siz[y])
            result.par_or_siz = result.par_or_siz.change_value(y,x)
            result.count -= 1
    proc siz*(self: PersistentUnionFind, x: int): int =
        var x = self.root(x)
        return -(self.par_or_siz[x])