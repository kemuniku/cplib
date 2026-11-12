## 単調増加する整数時刻で、区間内の一次関数の最小値を管理します。
## C++バックエンド用です。係数・時刻・返す最小値はintで、内部計算には128bit整数を使います。
## query(l, r)は半開区間[l, r)、query(l..r)は閉区間[l, r]を指定します。
## 参考: https://codeforces.com/blog/entry/82094
when not declared CPLIB_COLLECTIONS_KINETIC_TOURNAMENT:
    const CPLIB_COLLECTIONS_KINETIC_TOURNAMENT* = 1
    import cplib/math/int128

    type
        KineticLine = tuple[a, b: int]
        KineticNode = object
            winner: int
            melt: int
            hasMelt: bool
        KineticTournament* = ref object
            length, size, currentTime: int
            lines: seq[KineticLine]
            nodes: seq[KineticNode]

    proc value(self: KineticTournament, winner: int): Int128 {.inline.} =
        ## 1始まりの直線番号を現在時刻で評価します。O(1)。
        let line = self.lines[winner - 1]
        to_Int128(line.a) * to_Int128(self.currentTime) + to_Int128(line.b)

    proc better(self: KineticTournament, left, right: int): int {.inline.} =
        ## 値が小さい直線を選び、同値なら傾きが小さい方を優先します。0は未登録です。O(1)。
        if left == 0: return right
        if right == 0: return left
        let x = self.value(left)
        let y = self.value(right)
        if x < y or (x == y and self.lines[left - 1].a <= self.lines[right - 1].a):
            left
        else:
            right

    proc answer(self: KineticTournament, winner: int): int {.inline.} =
        ## 最小値をintに変換し、未登録ならhigh(int)を返します。O(1)。
        if winner == 0: return high(int)
        let x = self.value(winner)
        assert to_Int128(low(int)) <= x and x <= to_Int128(high(int)),
            "最小値がintの範囲に収まりません"
        x.to_int

    proc pull(self: KineticTournament, k: int) =
        ## 子の勝者と、部分木内の勝者が次に変わる時刻をまとめます。O(1)。
        let left = self.nodes[k * 2]
        let right = self.nodes[k * 2 + 1]
        let winner = self.better(left.winner, right.winner)
        self.nodes[k].winner = winner
        self.nodes[k].hasMelt = false
        if left.hasMelt and (not right.hasMelt or left.melt <= right.melt):
            self.nodes[k].melt = left.melt
            self.nodes[k].hasMelt = true
        elif right.hasMelt:
            self.nodes[k].melt = right.melt
            self.nodes[k].hasMelt = true
        if left.winner == 0 or right.winner == 0: return
        let loser = if winner == left.winner: right.winner else: left.winner
        let a = self.lines[winner - 1]
        let b = self.lines[loser - 1]
        if a.a <= b.a: return
        let numerator = to_Int128(b.b) - to_Int128(a.b)
        let denominator = to_Int128(a.a) - to_Int128(b.a)
        var nextTime = numerator div denominator
        if numerator mod denominator > 0:
            nextTime += 1
        if nextTime <= to_Int128(high(int)):
            let t = nextTime.to_int
            if not self.nodes[k].hasMelt or t < self.nodes[k].melt:
                self.nodes[k].melt = t
                self.nodes[k].hasMelt = true

    proc initKineticTournament*(n: int, initial_temperature: int = 0): KineticTournament =
        ## 未登録のn要素を指定時刻で初期化します。時間・空間O(N)。N=0も使用できます。
        assert n >= 0, "要素数は非負である必要があります"
        var size = 1
        while size < n: size *= 2
        KineticTournament(length: n, size: size, currentTime: initial_temperature,
            lines: newSeq[KineticLine](n), nodes: newSeq[KineticNode](size * 2))

    proc initKineticTournament*(lines: openArray[tuple[a, b: int]],
            initial_temperature: int = 0): KineticTournament =
        ## 各要素の直線a*T+bから指定時刻で構築します。時間・空間O(N)。
        result = initKineticTournament(lines.len, initial_temperature)
        for i, line in lines:
            result.lines[i] = line
            result.nodes[result.size + i].winner = i + 1
        for k in countdown(result.size - 1, 1):
            result.pull(k)

    proc len*(self: KineticTournament): int {.inline.} =
        ## 登録用の要素数を返します。O(1)。
        self.length

    proc temperature*(self: KineticTournament): int {.inline.} =
        ## 現在の時刻を返します。O(1)。
        self.currentTime

    proc update*(self: KineticTournament, i, a, b: int) =
        ## i番目の直線をa*T+bに差し替えます。負の係数も使用できます。O(log N)。
        assert 0 <= i and i < self.length, "添字が範囲外です"
        self.lines[i] = (a, b)
        var k = self.size + i
        self.nodes[k].winner = i + 1
        while k > 1:
            k = k shr 1
            self.pull(k)

    proc erase*(self: KineticTournament, i: int) =
        ## i番目の直線を未登録に戻します。未登録の要素にも使用できます。O(log N)。
        assert 0 <= i and i < self.length, "添字が範囲外です"
        var k = self.size + i
        self.nodes[k].winner = 0
        while k > 1:
            k = k shr 1
            self.pull(k)

    proc recompute(self: KineticTournament, k: int) =
        ## 時刻の更新で失効した部分木だけを再計算します。再計算する節点数に比例します。
        if not self.nodes[k].hasMelt or self.nodes[k].melt > self.currentTime: return
        self.recompute(k * 2)
        self.recompute(k * 2 + 1)
        self.pull(k)

    proc heaten*(self: KineticTournament, new_temperature: int) =
        ## 時刻を単調増加させます。O(1+K)、Kは再計算した節点数で、1回の最悪O(N)。
        ## 直線を変更しないQ回の時刻更新の総計はO(Q + N log^2 N)です。
        assert self.currentTime <= new_temperature, "時刻を減少させることはできません"
        self.currentTime = new_temperature
        self.recompute(1)

    proc query*(self: KineticTournament, l, r: int): int =
        ## 半開区間[l,r)の最小値を返します。空区間・全要素未登録ならhigh(int)。O(log N)。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が範囲外です"
        var left = l + self.size
        var right = r + self.size
        var winner = 0
        while left < right:
            if (left and 1) != 0:
                winner = self.better(winner, self.nodes[left].winner)
                inc left
            if (right and 1) != 0:
                dec right
                winner = self.better(winner, self.nodes[right].winner)
            left = left shr 1
            right = right shr 1
        self.answer(winner)

    proc query*(self: KineticTournament, segment: HSlice[int, int]): int =
        ## スライスで指定した区間の最小値を返します。O(log N)。
        self.query(segment.a, segment.b + 1)

    proc `[]`*(self: KineticTournament, segment: HSlice[int, int]): int =
        ## スライスで指定した区間の最小値を返します。O(log N)。
        self.query(segment)

    proc get_all*(self: KineticTournament): int =
        ## 全要素の最小値を返します。全要素未登録ならhigh(int)。O(1)。
        self.answer(self.nodes[1].winner)
