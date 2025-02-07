when not declared CPLIB_COLLECTIONS_TOPK_SUM_HEAPQ:
    const CPLIB_COLLECTIONS_TOPK_SUM_HEAPQ* = 1
    import heapqueue
    import algorithm
    import cplib/collections/deletable_heapqueue
    type TopK_sum_heapq = ref object
        G : Deletable_HeapQueue[int]
        L : Deletable_HeapQueue[int]
        sm : int
        topk : int
        k : int

    proc initTopKHeapq*(v:seq[int],k:int):TopK_sum_heapq=
        result = TopK_sum_heapq(G:initDeletableHeapQueue[int](),L:initDeletableHeapQueue[int](),sm:0,topk:0,k:k)
        var v = v.sorted()
        for i in 0..<k:
            result.G.push(v[i])
            result.sm += v[i]
            result.topk += v[i]
        for i in k..<len(v):
            result.L.push(-v[i])
            result.sm += v[i]


    proc incl*(self:TopK_sum_heapq,x:int)=
        self.sm += x
        if len(self.G) < self.k:
            self.topk += x
            self.G.push(x)
        elif self.k == 0:
            self.L.push(-x)
        elif self.G[0] <= x:
            self.topk += x
            self.G.push(x)
            var tmp = self.G.pop()
            self.L.push(-tmp)
            self.topk -= tmp
        else:
            self.L.push(-x)

    proc excl*(self:TopK_sum_heapq,x:int)=
        self.sm -= x
        if self.k == 0:
            self.L.delete(-x)
        elif self.G[0] <= x:
            self.topk -= x
            self.G.delete(x)
            if len(self.L) > 0:
                var tmp = -self.L.pop()
                self.G.push(tmp)
                self.topk += tmp
        else:
            self.L.delete(-x)

    proc addK*(self:TopK_sum_heapq)=
        var tmp = -self.L.pop()
        self.topk += tmp
        self.k += 1
        self.G.push(tmp)