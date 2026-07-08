when not declared CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND:
    const CPLIB_COLLECTIONS_WEIGHTED_UNIONFIND* = 1
    import algorithm
    import sequtils
    type WeightedUnionFind*[T] = ref object
        count*: int
        par_or_siz: seq[int32]
        potential_diff : seq[T]
    proc initWeightedUnionFind*(N: int,potential_type : typedesc = int): WeightedUnionFind[potential_type] =
        result = WeightedUnionFind[potential_type](count: N, par_or_siz: newSeqwith(N, -1'i32),potential_diff:newseqwith(N,0.potential_type))
    proc root_i32[T](self: WeightedUnionFind[T], x: int): int32 =
        if self.par_or_siz[x] < 0:
            return x.int32
        else:
            let p = self.par_or_siz[x].int
            var r = self.root_i32(p)
            self.potential_diff[x] += self.potential_diff[p]
            self.par_or_siz[x] = r
            return r
    proc root*[T](self: WeightedUnionFind[T], x: int): int =
        return self.root_i32(x).int
    proc potential*[T](self:WeightedUnionFind[T],x:int):T=
        discard self.root_i32(x)
        return self.potential_diff[x]
    proc issame*[T](self: WeightedUnionFind[T], x: int, y: int): bool =
        return self.root_i32(x) == self.root_i32(y)
    proc diff*[T](self:WeightedUnionFind[T],x,y:int):T=
        assert self.root_i32(x) == self.root_i32(y)
        return self.potential_diff[y]-self.potential_diff[x]
    proc unite*[T](self: WeightedUnionFind[T], x: int, y: int, w:T):bool=
        ## potential[y]-potential[x] = wとなるように辺を張ります
        ## 正しく辺が張れるならば、true,そうでないならばfalseを返します
        var w = w + self.potential(x) - self.potential(y)
        var x = self.root_i32(x)
        var y = self.root_i32(y)
        if(x != y):
            if(self.par_or_siz[x.int] > self.par_or_siz[y.int]):
                swap(x, y)
                w = -w
            let xi = x.int
            let yi = y.int
            self.par_or_siz[xi] += self.par_or_siz[yi]
            self.par_or_siz[yi] = x
            self.count -= 1
            self.potential_diff[yi] = w
            return true
        else:
            return w == 0
    proc siz*[T](self: WeightedUnionFind[T], x: int): int =
        var x = self.root_i32(x)
        return (-self.par_or_siz[x.int]).int
