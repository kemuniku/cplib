when not declared CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND:
    const CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND* = 1
    import algorithm
    import sequtils
    type WeightedUnionFind*[T] = ref object
        count*: int
        par_or_siz: seq[int]
        potential_diff : seq[T]
    proc initWeightedUnionFind*(N: int,potential_type : typedesc = int): WeightedUnionFind[potential_type] =
        result = WeightedUnionFind[potential_type](count: N, par_or_siz: newSeqwith(N, -1),potential_diff:newseqwith(N,0.potential_type))
    proc root*[T](self: WeightedUnionFind[T], x: int): int =
        if self.par_or_siz[x] < 0:
            return x
        else:
            var r = self.root(self.par_or_siz[x])
            self.potential_diff[x] += self.potential_diff[self.par_or_siz[x]]
            self.par_or_siz[x] = r
            return r
    proc potential*[T](self:WeightedUnionFind[T],x:int):T=
        discard self.root(x)
        return self.potential_diff[x]
    proc issame*[T](self: WeightedUnionFind[T], x: int, y: int): bool =
        return self.root(x) == self.root(y)
    proc diff*[T](self:WeightedUnionFind[T],x,y:int):T=
        assert self.root(x) == self.root(y)
        return self.potential_diff[y]-self.potential_diff[x]
    proc unite*[T](self: WeightedUnionFind[T], x: int, y: int, w:T):bool=
        ## potential[y]-potential[x] = wとなるように辺を張ります
        ## 正しく辺が張れるならば、true,そうでないならばfalseを返します
        var w = w + self.potential(x) - self.potential(y)
        var x = self.root(x)
        var y = self.root(y)
        if(x != y):
            if(self.par_or_siz[x] > self.par_or_siz[y]):
                swap(x, y)
                w = -w
            self.par_or_siz[x] += self.par_or_siz[y]
            self.par_or_siz[y] = x
            self.count -= 1
            self.potential_diff[y] = w
            return true
        else:
            return w == 0
    proc siz*[T](self: WeightedUnionFind[T], x: int): int =
        var x = self.root(x)
        return -self.par_or_siz[x]