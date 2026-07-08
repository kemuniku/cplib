
when not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:
    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND* = 1
    import algorithm, sequtils, bitops
    import cplib/collections/persistent_array
    type PersistentUnionFind* = ref object
        count*: int
        par_or_siz: PersistentArray[6,int32]

    proc initPersistentUnionFind*(N: int): PersistentUnionFind =
        result = PersistentUnionFind(count: N, par_or_siz: initPersistentArray(newseqwith(N,-1'i32),6))
    proc root_i32(self: PersistentUnionFind, x: int): int32 =
        var c = self.par_or_siz[x]
        if c < 0:
            return x.int32
        else:
            return self.root_i32(c.int)
    proc root*(self: PersistentUnionFind, x: int): int =
        return self.root_i32(x).int
    proc issame*(self: PersistentUnionFind, x: int, y: int): bool =
        return self.root_i32(x) == self.root_i32(y)
    proc unite*(self: PersistentUnionFind, x: int, y: int): PersistentUnionFind =
        var x = self.root_i32(x)
        var y = self.root_i32(y)
        result = PersistentUnionFind(count:self.count,par_or_siz:self.par_or_siz)
        if(x != y):
            if(result.par_or_siz[x.int] > result.par_or_siz[y.int]):
                swap(x, y)
            let xi = x.int
            let yi = y.int
            result.par_or_siz = result.par_or_siz.change_value(xi,result.par_or_siz[xi] + result.par_or_siz[yi])
            result.par_or_siz = result.par_or_siz.change_value(yi,x)
            result.count -= 1
    proc siz*(self: PersistentUnionFind, x: int): int =
        var x = self.root_i32(x)
        return (-(self.par_or_siz[x.int])).int
