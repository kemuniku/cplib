when not declared CPLIB_COLLECTIONS_HASHTABLE:
    const CPLIB_COLLECTIONS_HASHTABLE* = 1
    import bitops, sequtils, hashes
    type State = enum
        empty, active, inactive
    type Node[K, V] = object
        state: State
        value: (K, V)
    type HashTable*[K, V] = object
        values*: seq[Node[K, V]]
        len: int
        fill: int
        mask: int
    proc vlen(x: int): int = (if x == 0: 4 else: 1 shl (fastLog2(x) + 2))
    proc len*[K, V](self: HashTable[K, V]): int = self.len
    proc initHashTable*[K, V](): HashTable[K, V] =
        var vlen = 4
        return HashTable[K, V](values: newSeqWith(vlen, Node[K, V](state: State.empty)), len: 0, fill: 0, mask: vlen - 1)
    proc initHashTable*[K, V](capacity: int): HashTable[K, V] =
        var vlen = capacity.vlen
        return HashTable[K, V](values: newSeqWith(vlen, Node[K, V](state: State.empty)), len: 0, fill: 0, mask: vlen - 1)
    iterator pairs*[K, V](self: HashTable[K, V]): (K, V) =
        for item in self.values:
            if item.state == State.active: yield item.value
    iterator keys*[K, V](self: HashTable[K, V]): K =
        for item in self.values:
            if item.state == State.active: yield item.value[0]
    iterator values*[K, V](self: HashTable[K, V]): V =
        for item in self.values:
            if item.state == State.active: yield item.value[1]
    proc find[K, V](self: HashTable[K, V], x: K): int =
        var sh: int = hash(x) and self.mask
        while self.values[sh].state != State.empty and self.values[sh].value[0] != x:
            sh = (sh + 1) and self.mask
        return sh
    proc add_item[K, V](self: var HashTable[K, V], key: K, val: V) =
        var pos = self.find(key)
        if self.values[pos].state == State.active:
            self.values[pos].value[1] = val
            return
        self.len += 1
        self.fill += 1
        self.values[pos].value = (key, val)
        self.values[pos].state = State.active
    proc resize[K, V](self: var HashTable[K, V]) =
        var vlen = self.len.vlen
        var vi = newSeq[Node[K, V]](vlen)
        self.mask = vlen - 1
        self.len = 0
        self.fill = 0
        swap(vi, self.values)
        for item in vi:
            if item.state == State.empty: continue
            var (key, val) = item.value
            self.add_item(key, val)
    proc incl*[K, V](self: var HashTable[K, V], val: (K, V)) =
        self.add_item(val)
        if self.fill.vlen > self.values.len: self.resize
        # if self.fill > self.values.len div HASHSET_INCL_RESIZE_RATIO: self.resize
    proc contains*[K, V](self: var HashTable[K, V], key: K): bool = (self.values[self.find(key)].state == State.active)
    proc hasKey*[K, V](self: var HashTable[K, V], key: K): bool = self.contains(key)
    proc `[]`*[K, V](self: HashTable[K, V], key: K): V =
        var pos = self.find(key)
        assert self.values[pos].state == State.active, "Key \"" & $key & "\" not found"
        return self.values[pos].value[1]
    proc `[]`*[K, V](self: var HashTable[K, V], key: K): var V =
        var pos = self.find(key)
        assert self.values[pos].state == State.active, "Key \"" & $key & "\" not found"
        return self.values[pos].value[1]
    proc `[]=`*[K, V](self: var HashTable[K, V], key: K, val: V) =
        var pos = self.find(key)
        self.values[pos].value = (key, val)
        self.values[pos].state = State.active
        self.len += 1
        self.fill += 1
        if self.fill.vlen > self.values.len: self.resize
    proc clear*[K, V](self: var HashTable[K, V]) = self = initHashTable[K, V]()
    proc del*[K, V](self: var HashTable[K, V], key: K) =
        var pos = self.find(key)
        if self.values[pos].state != State.active: return
        self.len -= 1
        self.values[pos].state = State.inactive
    proc excl*[K, V](self: var HashTable[K, V], key: K) = self.del(key)
    proc hash*[K, V](self: HashTable[K, V]): Hash =
        for item in self.pairs:
            result = result !& hash(item)
