when not declared CPLIB_COLLECTIONS_GROUP_UNIONFIND:
    const CPLIB_COLLECTIONS_GROUP_UNIONFIND* = 1
    import algorithm, sequtils
    type UnionFind* = ref object
        count*: int
        par_or_siz: seq[int32]
        next : seq[int]
        edge_cnt : seq[int]
    proc initUnionFind*(N: int): UnionFind =
        result = UnionFind(count: N, par_or_siz: newSeqwith(N, -1'i32),next:(0..<N).toseq(),edge_cnt:newseqwith(N,0))
    proc root_i32(self: UnionFind, x: int): int32 =
        if self.par_or_siz[x] < 0:
            return x.int32
        else:
            self.par_or_siz[x] = self.root_i32(self.par_or_siz[x].int)
            return self.par_or_siz[x]
    proc root*(self: UnionFind, x: int): int =
        return self.root_i32(x).int
    proc issame*(self: UnionFind, x: int, y: int): bool =
        return self.root_i32(x) == self.root_i32(y)
    proc unite*(self: UnionFind, x: int, y: int) =
        var x = self.root_i32(x)
        var y = self.root_i32(y)
        if(x != y):
            swap(self.next[x.int],self.next[y.int])
            if(self.par_or_siz[x.int] > self.par_or_siz[y.int]):
                swap(x, y)
            let xi = x.int
            let yi = y.int
            self.par_or_siz[xi] += self.par_or_siz[yi]
            self.par_or_siz[yi] = x
            self.edge_cnt[xi] += self.edge_cnt[yi]
            self.count -= 1
        self.edge_cnt[x.int] += 1
    proc siz*(self: UnionFind, x: int): int =
        var x = self.root_i32(x)
        return (-self.par_or_siz[x.int]).int
    proc roots*(self:UnionFind):seq[int]=
        ## O(N)かけて、rootになっている頂点を列挙します。
        ## 注意:O(root数)でないことに注意してください。
        for i in 0..<len(self.par_or_siz):
            if self.par_or_siz[i] < 0:
                result.add(i)
    proc get_group*(self:UnionFind,x:int):seq[int]=
        var now = x
        while true:
            result.add(now)
            now = self.next[now]
            if now == x:
                break
    proc groups*(self: UnionFind): seq[seq[int]] =
        for root in self.roots():
            result.add(self.get_group(root))
    proc edge_count*(self: UnionFind, x: int): int =
        ## xの属するグループの辺の数を返します。
        var x = self.root_i32(x)
        return self.edge_cnt[x.int]
    proc is_tree*(self: UnionFind, x: int): bool =
        ## xの属する連結成分が木かどうかを返します。
        var x = self.root_i32(x)
        return self.edge_cnt[x.int] == self.siz(x.int) - 1
    proc is_namori*(self: UnionFind, x: int): bool =
        ## xの属する連結成分がなもりグラフかどうかを返します。
        var x = self.root_i32(x)
        return self.edge_cnt[x.int] == self.siz(x.int)
    proc has_cycle*(self: UnionFind, x: int): bool =
        ## xの属する連結成分にサイクルがあるかどうかを返します。
        var x = self.root_i32(x)
        return self.edge_cnt[x.int] >= self.siz(x.int)
    proc copy*(self:UnionFind):UnionFind=
        result = UnionFind(count: self.count, par_or_siz: self.par_or_siz, next: self.next, edge_cnt: self.edge_cnt)
