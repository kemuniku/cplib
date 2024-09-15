when not declared CPLIB_COLLECTIONS_STATIC_RANGE_COUNT:
    const CPLIB_COLLECTIONS_STATIC_RANGE_COUNT* = 1
    import tables,algorithm
    type StaticRangeCount[T] = object
        t : Table[T,seq[int]]

    proc initStaticRangeCount*[T](v:seq[T]):StaticRangeCount[T]=
        for i in 0..<len(v):
            if v[i] in result.t:
                result.t[v[i]].add(i)
            else:
                result.t[v[i]] = @[i]

    proc count*[T](self:var StaticRangeCount[T],l,r:int,x:T):int=
        if x notin self.t:
            return 0
        return self.t[x].lowerBound(r)-self.t[x].lowerBound(l)

    proc count*[T](self:var StaticRangeCount[T],R:HSlice[int,int],x:T):int=
        if x notin self.t:
            return 0
        return self.t[x].upperBound(R.b) - self.t[x].lowerBound(R.a)