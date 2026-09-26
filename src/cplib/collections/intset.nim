## 実行時に指定した整数の範囲を扱う集合です。Uは範囲の幅、kは現在の要素数です。
## uint64のビット列と非空ブロックの双方向リストを持ち、単一要素の操作は最悪O(1)です。
## itemsはO(k + 1)、次の要素の取得は最悪O(1)です。列挙順は不定で、列挙中の変更はできません。
## 初期化はO(1 + U / 64)、メモリはceil(U / 64) * (8 + 2 * sizeof(int))バイトと定数領域です。
## 範囲外の値は含まれず、削除は何もしません。範囲外への挿入はIndexDefectになります。
## 使用例::
##   import cplib/collections/intset
##   var s = initIntSet(1000) # 0..<1000
##   s.incl(42)
##   s.incl(999)
##   echo 42 in s
##   for x in s:
##     echo x
##   var t = initIntSet(-100..100)
##   t.incl(-7)
when not declared CPLIB_COLLECTIONS_INTSET:
    const CPLIB_COLLECTIONS_INTSET* = 1
    import bitops

    type
        IntSetBlock = object
            bits: uint64
            prev, next: int
        IntSet* {.byref.} = object
            blocks: seq[IntSetBlock]
            lower, size, count: int
            head: int

    proc initIntSet*(size: int): IntSet =
        ## 0..<sizeを扱う空集合を構築します。sizeは非負です。O(1 + size / 64)。
        if size < 0:
            raise newException(ValueError, "IntSet size must be non-negative")
        result.size = size
        result.blocks = newSeq[IntSetBlock]((size shr 6) + ord((size and 63) != 0))

    proc initIntSet*(bounds: Slice[int]): IntSet =
        ## 両端を含むboundsの範囲を扱う空集合を構築します。逆転した範囲は空です。O(1 + U / 64)。
        if bounds.a <= bounds.b:
            let span = cast[uint](bounds.b) - cast[uint](bounds.a)
            if span >= uint(high(int)):
                raise newException(ValueError, "IntSet range is too wide")
            result = initIntSet(int(span) + 1)
        result.lower = bounds.a

    proc len*(self: IntSet): int {.inline.} =
        ## 現在の要素数を返します。O(1)。
        self.count

    proc offset(self: IntSet, x: int): int {.inline.} =
        ## 範囲の先頭からの位置を返し、範囲外なら-1を返します。O(1)。
        if x < self.lower:
            return -1
        let delta = cast[uint](x) - cast[uint](self.lower)
        if delta >= uint(self.size):
            return -1
        int(delta)

    proc contains*(self: IntSet, x: int): bool {.inline.} =
        ## xが含まれるかを返します。範囲外はfalseです。O(1)。
        let pos = self.offset(x)
        pos >= 0 and (self.blocks[pos shr 6].bits and (1'u64 shl (pos and 63))) != 0

    proc containsOrIncl*(self: var IntSet, x: int): bool =
        ## xを挿入し、既に含まれていたかを返します。範囲外はIndexDefectです。O(1)。
        let pos = self.offset(x)
        if pos < 0:
            raise newException(IndexDefect, "IntSet value out of bounds")
        let i = pos shr 6
        let mask = 1'u64 shl (pos and 63)
        if (self.blocks[i].bits and mask) != 0:
            return true
        if self.blocks[i].bits == 0:
            self.blocks[i].prev = 0
            self.blocks[i].next = self.head
            if self.head != 0:
                self.blocks[self.head - 1].prev = i + 1
            self.head = i + 1
        self.blocks[i].bits = self.blocks[i].bits or mask
        inc self.count

    proc incl*(self: var IntSet, x: int) {.inline.} =
        ## xを挿入します。重複は無視し、範囲外はIndexDefectになります。O(1)。
        discard self.containsOrIncl(x)

    proc missingOrExcl*(self: var IntSet, x: int): bool =
        ## xを削除し、元々含まれていなかったかを返します。範囲外もtrueです。O(1)。
        let pos = self.offset(x)
        if pos < 0:
            return true
        let i = pos shr 6
        let mask = 1'u64 shl (pos and 63)
        if (self.blocks[i].bits and mask) == 0:
            return true
        self.blocks[i].bits = self.blocks[i].bits and not mask
        dec self.count
        if self.blocks[i].bits == 0:
            let prev = self.blocks[i].prev
            let next = self.blocks[i].next
            if prev == 0:
                self.head = next
            else:
                self.blocks[prev - 1].next = next
            if next != 0:
                self.blocks[next - 1].prev = prev

    proc excl*(self: var IntSet, x: int) {.inline.} =
        ## xを削除します。含まれていない値には何もしません。O(1)。
        discard self.missingOrExcl(x)

    iterator items*(self: IntSet): int =
        ## 要素を任意順に列挙します。列挙中の変更は不可です。全体O(k + 1)、1要素あたりO(1)。
        var node = self.head
        while node != 0:
            let i = node - 1
            var bits = self.blocks[i].bits
            while bits != 0:
                yield self.lower + (i * 64 + countTrailingZeroBits(bits))
                bits = bits and (bits - 1)
            node = self.blocks[i].next

    proc pop*(self: var IntSet): int =
        ## 任意の要素を1つ取り出して削除します。空集合はKeyErrorになります。O(1)。
        if self.count == 0:
            raise newException(KeyError, "IntSet is empty")
        let i = self.head - 1
        result = self.lower + (i * 64 + countTrailingZeroBits(self.blocks[i].bits))
        self.excl(result)

    proc clear*(self: var IntSet) =
        ## 範囲と確保済み領域を保って空にします。非空ブロック数をBとしてO(B + 1)。
        var node = self.head
        while node != 0:
            let i = node - 1
            node = self.blocks[i].next
            self.blocks[i] = IntSetBlock()
        self.head = 0
        self.count = 0

    proc toIntSet*(values: openArray[int], size: int): IntSet =
        ## valuesを0..<sizeの集合に変換します。O(1 + size / 64 + values.len)。
        result = initIntSet(size)
        for x in values:
            result.incl(x)

    proc toIntSet*(values: openArray[int], bounds: Slice[int]): IntSet =
        ## valuesをboundsの範囲の集合に変換します。O(1 + U / 64 + values.len)。
        result = initIntSet(bounds)
        for x in values:
            result.incl(x)

    proc `==`*(a, b: IntSet): bool =
        ## 範囲や挿入順によらず要素が等しいかを返します。O(a.len + 1)。
        if a.len != b.len:
            return false
        for x in a:
            if x notin b:
                return false
        true

    proc `$`*(self: IntSet): string =
        ## 要素を任意順に並べた文字列表現を返します。O(k + 1)。
        result = "{"
        for x in self:
            if result.len > 1:
                result.add(", ")
            result.add($x)
        result.add('}')
