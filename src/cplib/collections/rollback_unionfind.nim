when not declared CPLIB_COLLECTIONS_ROLLBACK_UNIONFIND:
    const CPLIB_COLLECTIONS_ROLLBACK_UNIONFIND* = 1
    import sequtils, strformat
    type RollbackUnionFind* = object
        count: int
        par_or_siz: seq[int]
        history: seq[(int, int)]
        snap: int
    proc count*(self: RollbackUnionFind): int = self.count
    proc get_state*(self: RollbackUnionFind): int = (self.history.len shr 1)
    proc initRollbackUnionFind*(n: int): RollbackUnionFind =
        RollbackUnionFind(count: n, par_or_siz: newSeqWith(n, -1), history: newSeq[(int, int)](), snap: 0)
    proc root*(self: RollbackUnionFind, x: int): int = (if self.par_or_siz[x] < 0: x else: self.root(self.par_or_siz[x]))
    proc issame*(self: RollbackUnionFind, x, y: int): bool = self.root(x) == self.root(y)
    proc unite*(self: var RollbackUnionFind, x, y: int): bool {.discardable.} =
        var x = self.root(x)
        var y = self.root(y)
        var sx = self.par_or_siz[x]
        var sy = self.par_or_siz[y]
        self.history.add((x, sx))
        self.history.add((y, sy))
        if x == y: return false
        if sx > sy: swap(x, y)
        self.par_or_siz[x] += self.par_or_siz[y]
        self.par_or_siz[y] = x
        return true
    proc undo*(self: var RollbackUnionFind) =
        assert self.history.len > 0, "Can't undo because Unionfind is already initial state."
        for i in 0..<2:
            var (x, sx) = self.history.pop
            self.par_or_siz[x] = sx
        if self.snap > self.get_state: self.snap = 0
    proc snapshot*(self: var RollbackUnionFind) = self.snap = self.get_state
    proc clear_snapshot*(self: var RollbackUnionFind) = self.snap = 0
    proc rollback*(self: var RollbackUnionFind, state: int = -1) =
        var state = (if state == -1: self.snap else: state) shl 1
        assert state <= self.history.len, &"Rollback state must be the same or smaller than current state. state: {state}, self.history.len: {self.history.len}"
        while state < self.history.len: self.undo()
    proc siz*(self: RollbackUnionFind, x: int): int =
        var x = self.root(x)
        return -self.par_or_siz[x]
