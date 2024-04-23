# https://github.com/tatyam-prime/SortedSet/blob/main/SortedMultiset.py
when not declared CPLIB_COLLECTIONS_TATYAMSET:
    import algorithm, math, sequtils, sugar
    import options
    const CPLIB_COLLECTIONS_TATYAMSET* = 1

    const BUCKET_RATIO = 8
    const SPLIT_RATIO = 12
    type SortedMultiSet*[T] = ref object
        size: int
        arr*: seq[seq[T]]
    proc initSortedMultiset*[T](v: seq[T] = @[]): SortedMultiSet[T] =
        #Make a new SortedMultiset from seq. / O(N) if sorted / O(N log N)
        var v = v
        if not isSorted(v):
            v.sort()
        var n = len(v)
        var bucket_size = int(ceil(sqrt(n/BUCKET_RATIO)))
        var arr = collect(newseq): (for i in 0..<bucket_size: v[(n*i div bucket_size) ..< (n*(i+1) div bucket_size)])
        result = SortedMultiSet[T](size: n, arr: arr)

    # def __reversed__(self) -> Iterator[T]:
    #     for i in reversed(self.a):
    #         for j in reversed(i): yield j

    # def __eq__(self, other) -> bool:
    #     return list(self) == list(other)

    proc len*(self: SortedMultiSet): int =
        return self.size

    # def __repr__(self) -> str:
    #     return "SortedMultiset" + str(self.a)

    # proc `$`*(self:SortedMultiSet):string=
    #     var s = $(toseq(self))
    #     return "{" & s[1 : len(s) - 1] & "}"

    proc position[T](self: SortedMultiSet[T], x: T): (int, int) =
        #"return the bucket, index of the bucket and position in which x should be. self must not be empty."
        for i, a in 0..<self.arr.len:
            var a = self.arr[i]
            if x <= a[^1]:
                return (i, a.lowerBound(x))
        return (len(self.arr)-1, self.arr[^1].lowerBound(x))

    proc contains*[T](self: SortedMultiSet[T], x: T): bool =
        if self.size == 0: return false
        var (i, j) = self.position(x)
        return j != len(self.arr[i]) and self.arr[i][j] == x

    proc incl*[T](self: SortedMultiSet[T], x: T) =
        #"Add an element. / O(√N)"
        if self.size == 0:
            self.arr = @[@[x]]
            self.size = 1
            return
        var (b, i) = self.position(x)
        self.arr[b].insert(x, i)
        self.size += 1
        if len(self.arr[b]) > len(self.arr) * SPLIT_RATIO:
            var mid = len(self.arr[b]) shr 1
            self.arr.insert(self.arr[b][mid..<len(self.arr[b])], b+1)
            self.arr[b] = self.arr[b][0..<mid]

    proc innerpop[T](self: SortedMultiSet[T], b: int, i: int): T{.discardable.} =
        var b = b
        if b < 0:
            b = self.size + b
        var ans = self.arr[b][i]
        self.arr[b].delete(i)
        self.size -= 1
        if len(self.arr[b]) == 0: self.arr.delete(b)
        return ans

    proc excl*[T](self: SortedMultiSet[T], x: T): bool{.discardable.} =
        #"Remove an element and return True if removed. / O(√N)"
        if self.size == 0: return false
        var (b, i) = self.position(x)
        if i == len(self.arr[b]) or self.arr[b][i] != x: return false
        self.innerpop(b, i)
        return true

    proc lt*[T](self: SortedMultiSet[T], x: T): Option[T] =
        #"Find the largest element < x, or None if it doesn't exist."
        for i in countdown(len(self.arr)-1, 0, 1):
            if self.arr[i][0] < x:
                return some(self.arr[i][lowerBound(self.arr[i], x) - 1])
        return none(T)

    proc le*[T](self: SortedMultiSet[T], x: T): Option[T] =
        #"Find the largest element <= x, or None if it doesn't exist."
        for i in countdown(len(self.arr)-1, 0, 1):
            if self.arr[i][0] <= x:
                return some(self.arr[i][upperBound(self.arr[i], x) - 1])
        return none(T)

    proc gt*[T](self: SortedMultiSet[T], x: T): Option[T] =
        #"Find the smallest element > x, or None if it doesn't exist."
        for i in 0..<len(self.arr):
            if self.arr[i][^1] > x:
                return some(self.arr[i][upperBound(self.arr[i], x)])
        return none(T)

    proc ge*[T](self: SortedMultiSet[T], x: T): Option[T] =
        #"Find the smallest element >= x, or None if it doesn't exist."
        for i in 0..<len(self.arr):
            if self.arr[i][^1] >= x:
                return some(self.arr[i][lowerBound(self.arr[i], x)])
        return none(T)

    proc `[]`*[T](self: SortedMultiSet[T], i: int): T =
        var i = i
        #"Return the i-th element."
        if i < 0:
            for j in countdown(len(self.arr)-1, 0, 1):
                i += len(self.arr[j])
                if i >= 0: return self.arr[j][i]
        else:
            for j in 0..<len(self.arr):
                if i < len(self.arr[j]): return self.arr[j][i]
                i -= len(self.arr[j])
        raise newException(IndexDefect, "index " & $i & " not in 0 .. " & $(self.size-1))

    proc pop*[T](self: SortedMultiSet[T], i: int = -1): T =
        #"Pop and return the i-th element."
        var i = i
        if i < 0:
            for b in countdown(len(self.arr)-1, 0, 1):
                i += len(self.arr[b])
                if i >= 0: return self.innerpop(not b, i)
        else:
            for b in 0..<len(self.arr):
                if i < len(self.arr[b]): return self.innerpop(b, i)
                i -= len(self.arr[b])
        raise newException(IndexDefect, "index " & $i & " not in 0 .. " & $(self.size-1))

    proc index*[T](self: SortedMultiSet[T], x: T): int =
        #"Count the number of elements < x."
        for i in 0..<len(self.arr):
            if self.arr[i][^1] >= x:
                return result + lowerBound(self.arr[i], x)
            result += len(self.arr[i])

    proc index_right*[T](self: SortedMultiSet[T], x: T): int =
        #"Count the number of elements <= x."
        for i in 0..<len(self.arr):
            if self.arr[i][^1] > x:
                return result + upperBound(self.arr[i], x)
            result += len(self.arr[i])
    proc count*[T](self: SortedMultiSet[T], x: T): int =
        #"Count the number of x."
        return self.index_right(x) - self.index(x)

    iterator items*[T](self: SortedMultiSet[T]): T =
        for i in 0..<len(self.arr):
            for j in self.arr[i]:
                yield j
