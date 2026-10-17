## int の有限等差数列。構築・添字・slice・bound・近傍・総和は時間/追加領域 O(1)。
## 値と公差と長さは int に収まる必要があり、表現不能な値は ValueError。
## Pythonの多倍長整数とは異なり、rangeの項数とsumの答えにもintの制限がある。
## 初項/末項を検査すれば全項が範囲内。差・積は符号なし整数で求めるため、
## 有効な入力で符号付き中間値のoverflowを起こさない（最小公差も可）。
## slice は Python 風の半開添字（負添字、端点の切り詰め、非零 stride）。
## sliceの新公差 step*stride は空列/単点でもintに収まる必要がある。
## Nimの[] sliceは包含添字で範囲を検査し、Python風の切り詰めは行わない。
## bound は列順の挿入位置。降順のlower/upperは > / >= の要素数を返す。
## 近傍は列の向きによらず数値の大小で選び、不在なら Option の none。
## 公差0では全項が同値、空列のboundは0、sumは0、近傍は全てnone。
## 添字/sliceの範囲外はIndexDefect。NimのC/C++ backendで利用可能。
## 使用例:
##   let p = initArithmeticRange(10, -1, -3) # 10, 7, 4, 1
##   assert p[1] == 7 and p[^1] == 1
##   assert p[1..<3].sum == 11
##   assert p.lowerBound(6) == 2 # 降順での挿入位置
##   assert p.minGe(6).get == 7 # 数値としての近傍
when not declared CPLIB_COLLECTIONS_ARITHMETIC_PROGRESSION:
    const CPLIB_COLLECTIONS_ARITHMETIC_PROGRESSION* = 1
    import options

    type ArithmeticProgression* = object
        firstValue, stepValue, count: int

    proc magnitude(x: int): uint =
        ## 最小整数も含む絶対値を符号なしで求める。O(1)。
        if x < 0: 0u - cast[uint](x) else: uint(x)

    proc checkedMultiply(x, y: int): int =
        ## 符号付き積の表現可能性を判定してから計算する。O(1)。
        let negative = (x < 0) != (y < 0)
        let limit = if negative: uint(high(int)) + 1u else: uint(high(int))
        let a = magnitude(x)
        let b = magnitude(y)
        if b != 0 and a > limit div b:
            raise newException(ValueError, "積がintの範囲外です")
        let product = a * b
        if negative: cast[int](0u - product) else: int(product)

    proc initArithmeticProgression*(first, step, len: int): ArithmeticProgression =
        ## 初項・公差・非負の項数から構築する（公差0も可）。O(1)。
        if len < 0:
            raise newException(ValueError, "項数は非負である必要があります")
        if len > 1 and step != 0:
            let room = if step > 0:
                cast[uint](high(int)) - cast[uint](first)
            else:
                cast[uint](first) - cast[uint](low(int))
            if uint(len - 1) > room div magnitude(step):
                raise newException(ValueError, "末項がintの範囲外です")
        ArithmeticProgression(firstValue: first, stepValue: step, count: len)

    proc initArithmeticRange*(start, stop: int, step: int = 1): ArithmeticProgression =
        ## Pythonのrange(start, stop, step)と同じ半開値域から構築する。O(1)。
        if step == 0:
            raise newException(ValueError, "rangeの公差は非零である必要があります")
        var count = 0u
        if (step > 0 and start < stop) or (step < 0 and start > stop):
            let distance = if step > 0:
                cast[uint](stop) - cast[uint](start)
            else:
                cast[uint](start) - cast[uint](stop)
            count = (distance - 1u) div magnitude(step) + 1u
        if count > uint(high(int)):
            raise newException(ValueError, "項数がintの範囲外です")
        initArithmeticProgression(start, step, int(count))

    proc initArithmeticRange*(stop: int): ArithmeticProgression =
        ## Pythonのrange(stop)と同じ列を構築する。O(1)。
        initArithmeticRange(0, stop)

    proc len*(self: ArithmeticProgression): int =
        ## 項数を返す。O(1)。
        self.count

    proc first*(self: ArithmeticProgression): int =
        ## 構築時の初項を返す（空列でも取得可）。O(1)。
        self.firstValue

    proc step*(self: ArithmeticProgression): int =
        ## 公差を返す。O(1)。
        self.stepValue

    proc valueAt(self: ArithmeticProgression, i: int): int =
        ## 検査済み添字の値を符号なし中間演算で求める。O(1)。
        cast[int](cast[uint](self.firstValue) + cast[uint](self.stepValue) * uint(i))

    proc `[]`*(self: ArithmeticProgression, i: int): int =
        ## 0始まりの添字、またはPython風の負添字で取得する。O(1)。
        let index = if i < 0: i + self.count else: i
        if index < 0 or index >= self.count:
            raise newException(IndexDefect, "等差数列の添字が範囲外です")
        self.valueAt(index)

    proc `[]`*(self: ArithmeticProgression, i: BackwardsIndex): int =
        ## Nimの後ろからの添字で取得する。O(1)。
        if int(i) <= 0 or int(i) > self.count:
            raise newException(IndexDefect, "等差数列の添字が範囲外です")
        self.valueAt(self.count - int(i))

    proc normalizeIndex(i, count: int, reverse: bool): int =
        ## 明示されたslice端点をPythonと同じ範囲へ正規化する。O(1)。
        let index = if i < 0: i + count else: i
        if reverse: max(-1, min(count - 1, index))
        else: max(0, min(count, index))

    proc slice*(self: ArithmeticProgression, start, stop: int,
                stride: int = 1): ArithmeticProgression =
        ## 半開添字sliceを返す。逆順で全体を取るstopは -len-1。O(1)。
        if stride == 0:
            raise newException(ValueError, "sliceのstrideは非零である必要があります")
        let a = normalizeIndex(start, self.count, stride < 0)
        let b = normalizeIndex(stop, self.count, stride < 0)
        var n = 0
        if (stride > 0 and a < b) or (stride < 0 and a > b):
            let distance = if stride > 0: b - a else: a - b
            n = int((uint(distance) - 1u) div magnitude(stride) + 1u)
        let newStep = checkedMultiply(self.stepValue, stride)
        let newFirst = if n == 0: self.firstValue else: self.valueAt(a)
        initArithmeticProgression(newFirst, newStep, n)

    proc `[]`*[A, B: int | BackwardsIndex](self: ArithmeticProgression,
                interval: HSlice[A, B]): ArithmeticProgression =
        ## Nimの包含添字slice（..<、^も可）を返す。範囲外は例外。O(1)。
        when A is BackwardsIndex:
            if int(interval.a) < 0:
                raise newException(IndexDefect, "後ろからのslice添字が負です")
        when B is BackwardsIndex:
            if int(interval.b) < 0:
                raise newException(IndexDefect, "後ろからのslice添字が負です")
        let a = when A is BackwardsIndex: self.count - int(interval.a) else: int(interval.a)
        let b = when B is BackwardsIndex: self.count - int(interval.b) else: int(interval.b)
        if a < 0 or a > self.count or b < -1 or b >= self.count or b < a - 1:
            raise newException(IndexDefect, "等差数列のsliceが範囲外です")
        let n = b - a + 1
        initArithmeticProgression(if n == 0: self.firstValue else: self.valueAt(a), self.stepValue, n)

    proc numericCount(self: ArithmeticProgression, x: int, inclusive: bool): int =
        ## 数値としてx未満（inclusiveなら以下）の要素数を返す。O(1)。
        if self.count == 0: return 0
        let last = self.valueAt(self.count - 1)
        let minimum = min(self.firstValue, last)
        let maximum = max(self.firstValue, last)
        if x < minimum or (x == minimum and not inclusive): return 0
        if x > maximum or (x == maximum and inclusive): return self.count
        if self.stepValue == 0: return 0
        let distance = cast[uint](x) - cast[uint](minimum)
        let d = magnitude(self.stepValue)
        let quotient = distance div d
        # 最大項より内側なので、項数を越える商や加算は発生しない。
        int(quotient) + (if inclusive or distance mod d != 0: 1 else: 0)

    proc lowerBound*(self: ArithmeticProgression, x: int): int =
        ## 列順でxを同値の前へ挿入する位置。降順ではxより大きい項数。O(1)。
        if self.stepValue < 0: self.count - self.numericCount(x, true)
        else: self.numericCount(x, false)

    proc upperBound*(self: ArithmeticProgression, x: int): int =
        ## 列順でxを同値の後へ挿入する位置。降順ではx以上の項数。O(1)。
        if self.stepValue < 0: self.count - self.numericCount(x, false)
        else: self.numericCount(x, true)

    proc numericAt(self: ArithmeticProgression, i: int): Option[int] =
        ## 数値昇順の添字から値を返し、範囲外ならnone。O(1)。
        if i < 0 or i >= self.count: return none(int)
        some(self.valueAt(if self.stepValue < 0: self.count - 1 - i else: i))

    proc minGe*(self: ArithmeticProgression, x: int): Option[int] =
        ## x以上の最小の値、不在ならnone。O(1)。
        self.numericAt(self.numericCount(x, false))

    proc minGt*(self: ArithmeticProgression, x: int): Option[int] =
        ## xより大きい最小の値、不在ならnone。O(1)。
        self.numericAt(self.numericCount(x, true))

    proc maxLe*(self: ArithmeticProgression, x: int): Option[int] =
        ## x以下の最大の値、不在ならnone。O(1)。
        self.numericAt(self.numericCount(x, true) - 1)

    proc maxLt*(self: ArithmeticProgression, x: int): Option[int] =
        ## x未満の最大の値、不在ならnone。O(1)。
        self.numericAt(self.numericCount(x, false) - 1)

    proc sum*(self: ArithmeticProgression): int =
        ## 総和を返す。数学的総和がintの範囲外ならValueError。O(1)。
        if self.count == 0: return 0
        let a = self.firstValue
        let b = self.valueAt(self.count - 1)
        if self.count mod 2 == 0:
            if (b > 0 and a > high(int) - b) or (b < 0 and a < low(int) - b):
                raise newException(ValueError, "総和がintの範囲外です")
            checkedMultiply(a + b, self.count div 2)
        else:
            # 奇数個の列では両端の和が偶数なので、平均を先に計算できる。
            let midpoint = a div 2 + b div 2 + (a mod 2 + b mod 2) div 2
            checkedMultiply(midpoint, self.count)
