when not declared CPLIB_COLLECTIONS_PERMUTATION:
    const CPLIB_COLLECTIONS_PERMUTATION* = 1

    ## 0..<Nの不変順列。構築は時間・領域O(N)、問い合わせはO(1)。
    ## 入力をコピーし、内部配列を公開しない。空順列・default値も許す。
    ## サイクルIDは最小要素の昇順、位置は最小要素から順列を辿った順。
    ## cycleは指定要素から始まるコピーで時間・追加領域O(サイクル長)。
    ## applyPowは負の指数（逆順列）とlow/high(int)を含む全intに対応。
    ## 不正な順列はValueError、不正な要素・添字はIndexDefect。
    type Permutation* = object
        values: seq[int]
        inverse: seq[int]
        cycleIds: seq[int]
        positions: seq[int]
        cycles: seq[seq[int]]

    proc initPermutation*(p: openArray[int]): Permutation =
        ## 重複・範囲外を拒否して順列を構築する。時間・領域O(N)。
        let n = p.len
        result.values = newSeq[int](n)
        result.inverse = newSeq[int](n)
        result.cycleIds = newSeq[int](n)
        result.positions = newSeq[int](n)
        for i in 0..<n:
            result.inverse[i] = -1
            result.cycleIds[i] = -1
        for i, x in p:
            if x < 0 or x >= n:
                raise newException(ValueError, "順列の要素が範囲外です")
            if result.inverse[x] != -1:
                raise newException(ValueError, "順列の要素が重複しています")
            result.values[i] = x
            result.inverse[x] = i
        for start in 0..<n:
            if result.cycleIds[start] != -1:
                continue
            let cid = result.cycles.len
            var vertices: seq[int]
            var x = start
            while result.cycleIds[x] == -1:
                result.cycleIds[x] = cid
                result.positions[x] = vertices.len
                vertices.add(x)
                x = result.values[x]
            result.cycles.add(vertices)

    proc checkVertex(self: Permutation, x: int) =
        ## 要素・添字の範囲を検査する。O(1)。
        if x < 0 or x >= self.values.len:
            raise newException(IndexDefect, "順列の要素・添字が範囲外です")

    proc len*(self: Permutation): int =
        ## 順列の長さを返す。O(1)。
        self.values.len

    proc `[]`*(self: Permutation, i: int): int =
        ## 0始まりのi番目の値p[i]を返す。O(1)。
        self.checkVertex(i)
        self.values[i]

    proc index*(self: Permutation, x: int): int =
        ## p[i]=xとなる唯一の添字iを返す。O(1)。
        self.checkVertex(x)
        self.inverse[x]

    proc cycleId*(self: Permutation, x: int): int =
        ## xの所属サイクルIDを返す。O(1)。
        self.checkVertex(x)
        self.cycleIds[x]

    proc cyclePosition*(self: Permutation, x: int): int =
        ## 所属サイクルの最小要素から辿ったxの位置を返す。O(1)。
        self.checkVertex(x)
        self.positions[x]

    proc cycleLen*(self: Permutation, x: int): int =
        ## xの所属サイクル長を返す。O(1)。
        self.checkVertex(x)
        self.cycles[self.cycleIds[x]].len

    proc applyPow*(self: Permutation, x, k: int): int =
        ## xへ順列をk回作用させる。負なら逆順列を作用させる。O(1)。
        self.checkVertex(x)
        let cid = self.cycleIds[x]
        let size = self.cycles[cid].len
        var shift = k mod size
        if shift < 0:
            shift += size
        let pos = self.positions[x]
        let target = if shift >= size-pos: shift-(size-pos) else: pos+shift
        self.cycles[cid][target]

    iterator cycleItems*(self: Permutation, x: int): int =
        ## xから順列を辿り所属サイクルを一周列挙する。時間O(長さ)、追加領域O(1)。
        self.checkVertex(x)
        var now = x
        for i in 0..<self.cycles[self.cycleIds[x]].len:
            yield now
            now = self.values[now]

    proc cycle*(self: Permutation, x: int): seq[int] =
        ## xから始まる所属サイクルのコピーを返す。時間・追加領域O(長さ)。
        self.checkVertex(x)
        result = newSeqOfCap[int](self.cycleLen(x))
        for v in self.cycleItems(x):
            result.add(v)
