when not declared CPLIB_COLLECTIONS_HASHTABLE:
    const CPLIB_COLLECTIONS_HASHTABLE* = 1
    import bitops, sequtils, hashes
    type State = enum
        empty, active, inactive
    type Node[T] = object
        state: State
        value: T
        # value: T or typeof(nil)
    type HashSet*[T] = object
        values*: seq[Node[T]]
        len: int
        fill: int
        mask: int
    proc vlen(x: int): int = (if x == 0: 4 else: 1 shl (fastLog2(x) + 2))
    proc initHashSet*[T](): HashSet[T] =
        var vlen = 4
        HashSet[T](values: newSeqWith(vlen, Node[T](state: State.empty)), len: 0, fill: 0, mask: vlen - 1)
    iterator items*[T](self: HashSet[T]): T =
        for item in self.values:
            if item.state == State.active: yield item.value
    proc find[T](self: HashSet[T], x: T): int =
        var sh: int = hash(x) and self.mask
        while self.values[sh].state != State.empty and self.values[sh].value != x:
            sh = (sh + 1) and self.mask
        return sh
    proc add_item[T](self: var HashSet[T], val: T) =
        var pos = self.find(val)
        if self.values[pos].state == State.active: return
        self.len += 1
        self.fill += 1
        self.values[pos].value = val
        self.values[pos].state = State.active
    proc resize[T](self: var HashSet[T]) =
        var vlen = self.len.vlen
        var vi = newSeq[Node[T]](vlen)
        self.mask = vlen - 1
        self.len = 0
        self.fill = 0
        swap(vi, self.values)
        for item in vi:
            if item.state == State.empty: continue
            var val = item.value
            self.add_item(val)
    proc incl*[T](self: var HashSet[T], val: T) =
        self.add_item(val)
        if self.fill.vlen > self.values.len: self.resize
        # if self.fill > self.values.len div HASHSET_INCL_RESIZE_RATIO: self.resize
    proc contains*[T](self: var HashSet[T], val: T): bool = (self.values[self.find(val)].state == State.active)
    proc remove_item[T](self: var HashSet[T], val: T) =
        var pos = self.find(val)
        if self.values[pos].state != State.active: return
        self.len -= 1
        self.values[pos].state = State.inactive
    proc excl*[T](self: var HashSet[T], val: T) =
        self.remove_item(val)
        # if self.fill < self.values.len * HASHSET_INCL_RESIZE_RATIO: self.resize
    proc toHashSet*[T](a: openArray[T]): HashSet[T] =
        result = initHashSet[T]()
        for item in a: result.incl(item)
