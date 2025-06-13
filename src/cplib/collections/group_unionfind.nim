when not declared CPLIB_COLLECTIONS_UNIONFIND:
    const CPLIB_COLLECTIONS_UNIONFIND* = 1
    import algorithm, sequtils
    type UnionFind* = ref object
        count*: int
        par_or_siz: seq[int]
        next : seq[int]
        edge_cnt : seq[int]
    proc initUnionFind*(N: int): UnionFind =
        result = UnionFind(count: N, par_or_siz: newSeqwith(N, -1),next:(0..<N).toseq(),edge_cnt:newseqwith(N,0))
    proc root*(self: UnionFind, x: int): int =
        if self.par_or_siz[x] < 0:
            return x
        else:
            self.par_or_siz[x] = self.root(self.par_or_siz[x])
            return self.par_or_siz[x]
    proc issame*(self: UnionFind, x: int, y: int): bool =
        return self.root(x) == self.root(y)
    proc unite*(self: UnionFind, x: int, y: int) =
        var x = self.root(x)
        var y = self.root(y)
        if(x != y):
            swap(self.next[x],self.next[y])
            if(self.par_or_siz[x] > self.par_or_siz[y]):
                swap(x, y)
            self.par_or_siz[x] += self.par_or_siz[y]
            self.par_or_siz[y] = x
            self.edge_cnt[x] += self.edge_cnt[y]
            self.count -= 1
        self.edge_cnt[x] += 1
    proc siz*(self: UnionFind, x: int): int =
        var x = self.root(x)
        return -self.par_or_siz[x]
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
        var x = self.root(x)
        return self.edge_cnt[x]
    proc is_tree*(self: UnionFind, x: int): bool =
        ## xの属する連結成分が木かどうかを返します。
        var x = self.root(x)
        return self.edge_cnt[x] == self.siz(x) - 1
    proc is_namori*(self: UnionFind, x: int): bool =
        ## xの属する連結成分がなもりグラフかどうかを返します。
        var x = self.root(x)
        return self.edge_cnt[x] == self.siz(x)
    proc has_cycle*(self: UnionFind, x: int): bool =
        ## xの属する連結成分にサイクルがあるかどうかを返します。
        var x = self.root(x)
        return self.edge_cnt[x] >= self.siz(x)