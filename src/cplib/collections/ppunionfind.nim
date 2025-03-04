when not declared CPLIB_COLLECTIONS_PARTIALPERSISTENTUNIONFIND:
    const CPLIB_COLLECTIONS_PARTIALPERSISTENTUNIONFIND* = 1
    import sequtils,algorithm
    type PartialPersistentUnionFind* = object
        par_or_siz : seq[int] #0以上のとき、親の頂点番号を表す。0未満のとき、-(集合のサイズ)を表す。
        time : seq[int] # 親との辺がつながった時間を表す。-1のとき、rootである。
        size_time : seq[seq[int]]
        size_value : seq[seq[int]] # ある時点での頂点xがrootとなる集合の大きさ
        last : int 

    proc initPartialPersistentUnionFind*(N:int): PartialPersistentUnionFind=
        result.par_or_siz = newSeqWith(N,-1)
        result.time = newseqwith(N,-1)
        result.size_time = newseqwith(N,@[-1])
        result.size_value = newseqwith(N,@[1])
        result.last = -1

    proc root*(self:var PartialPersistentUnionFind,x:int,t:int):int=
        var now = x
        while self.time[now] != -1 and self.time[now] <= t:
            now = self.par_or_siz[now]
        return now

    proc root*(self:var PartialPersistentUnionFind,x:int):int=
        return self.root(x,self.last)

    proc unite*(self:var PartialPersistentUnionFind,u,v,t:int):bool {.discardable.}=
        assert self.last <= t
        self.last = t
        var u = self.root(u)
        var v = self.root(v)
        if u == v:
            return false
        if self.par_or_siz[u] > self.par_or_siz[v]:
            swap(u,v)
        self.par_or_siz[u] += self.par_or_siz[v]
        self.par_or_siz[v] = u
        self.size_time[u].add(t)
        self.size_value[u].add(-self.par_or_siz[u])
        self.time[v] = t
        return true

    proc unite*(self:var PartialPersistentUnionFind,u,v:int):int {.discardable.}=
        self.unite(u,v,self.last+1)
        return self.last

    proc issame*(self:var PartialPersistentUnionFind,u,v,t:int):bool=
        return self.root(u,t) == self.root(v,t)

    proc issame*(self:var PartialPersistentUnionFind,u,v:int):bool=
        return self.root(u) == self.root(v)

    proc size*(self:var PartialPersistentUnionFind,x,t:int):int=
        assert t >= -1
        var x = self.root(x,t)
        return self.size_value[x][self.size_time[x].upperBound(t)-1]

    proc size*(self:var PartialPersistentUnionFind,x:int):int=
        return self.size(x,self.last)

    proc when_unite*(self:var PartialPersistentUnionFind,u,v:int):int=
        ## 頂点uとvが連結になった時間を返す。
        ## 連結ではない場合、-2が返る(最悪か？ 時刻-1を開始にしてしまったため仕方なく...)
        var tu : seq[int] = @[u]
        var u = u
        var tv : seq[int] = @[v]
        var v = v
        while self.par_or_siz[u] >= 0:
            u = self.par_or_siz[u]
            tu.add(u)
        while self.par_or_siz[v] >= 0:
            v = self.par_or_siz[v]
            tv.add(v)
        if u != v:
            return -2
        while len(tu) > 0 and len(tv) > 0 and tu[^1] == tv[^1]:
            discard tu.pop()
            discard tv.pop()
        result = -1
        if len(tu) != 0:
            result = max(result,self.time[tu[^1]])
        if len(tv) != 0:
            result = max(result,self.time[tv[^1]])


    proc size_ge(self:var PartialPersistentUnionFind,x,size:int):int=
        ## xが属する集合のサイズがsizeを超える時間を返す
        if size <= 1:
            return -1
        var now = x
        while self.time[now] != -1:
            now = self.par_or_siz[now]
            if self.size_value[now][^1] >= size:
                return self.size_time[now][self.size_value[now].lowerBound(size)]




