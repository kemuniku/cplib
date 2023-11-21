when not declared CPLIB_COLLECTIONS_UNIONFIND:
    const CPLIB_COLLECTIONS_UNIONFIND* = 1
    import algorithm,sequtils
    type UnionFind = ref object
        count* :int
        par_or_siz :seq[int]
    proc initUnionFind*(N:int):UnionFind=
        result = UnionFind(count:N,par_or_siz:newSeqwith(N,-1))
    proc root*(self:UnionFind,x:int):int=
        if self.par_or_siz[x] < 0:
            return x
        else:
            self.par_or_siz[x] = self.root(self.par_or_siz[x])
            return self.par_or_siz[x]
    proc issame*(self:UnionFind,x:int,y:int):bool=
        return self.root(x) == self.root(y)
    proc unite*(self:UnionFind,x:int,y:int)=
        var x = self.root(x)
        var y = self.root(y)
        if(x != y):
            if(self.par_or_siz[x]>self.par_or_siz[y]):
                swap(x,y)
            self.par_or_siz[x] += self.par_or_siz[y]
            self.par_or_siz[y] = x
            self.count -= 1