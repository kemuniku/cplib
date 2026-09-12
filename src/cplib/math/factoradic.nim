## 符号付き階乗進数。digits[i] は絶対値の i! の係数で、0 <= digits[i] <= i。
## div・mod は Python と同じ床除算で、余りは除数と同符号。
## 順列は 0..<N の並べ替え、辞書順の順位は 0 始まりで扱う。
## 使用例: permutationRank(@[2, 0, 1]).toInt() == 4、
## initFactoradic(4).toPermutation(3) == @[2, 0, 1]。
when not declared CPLIB_MATH_FACTORADIC:
    const CPLIB_MATH_FACTORADIC* = 1
    import hashes
    import cplib/math/bigint

    type Factoradic* = object
        negative: bool
        data: seq[int]

    proc normalize(self: var Factoradic) =
        ## 上位の不要な 0 を取り除き、0 の符号を正に揃える。O(桁数)。
        while self.data.len > 0 and self.data[^1] == 0:
            self.data.setLen(self.data.len - 1)
        if self.data.len == 0: self.negative = false

    proc initFactoradic*(digits: openArray[int], negative: bool = false): Factoradic =
        ## 絶対値の下位桁から並べた i! の係数と符号で構築する。O(桁数)。空配列は 0。
        for i, digit in digits:
            doAssert 0 <= digit and digit <= i, "階乗進数の桁が範囲外"
        result.data = @digits
        result.negative = negative
        result.normalize()

    proc initFactoradic*[T: SomeInteger](value: T): Factoradic =
        ## 整数から構築する。O(桁数)。符号付き整数の最小値にも対応する。
        var magnitude: uint64
        when T is SomeSignedInt:
            if value < 0:
                result.negative = true
                magnitude = uint64(-(value + 1)) + 1'u64
            else:
                magnitude = uint64(value)
        else:
            magnitude = uint64(value)
        var radix = 1'u64
        while magnitude > 0:
            result.data.add(int(magnitude mod radix))
            magnitude = magnitude div radix
            inc radix

    proc abs*(self: Factoradic): Factoradic =
        ## 絶対値を返す。桁配列のコピーに O(桁数)。
        result = self
        result.negative = false

    proc `-`*(self: Factoradic): Factoradic =
        ## 符号を反転する。桁配列のコピーに O(桁数)。0 は正のまま。
        result = self
        if result.data.len > 0: result.negative = not result.negative

    proc `+`*(self: Factoradic): Factoradic =
        ## 同じ値を返す。桁配列のコピーに O(桁数)。
        self

    proc sgn*(self: Factoradic): int =
        ## 符号を -1、0、1 で返す。O(1)。
        if self.data.len == 0: 0 elif self.negative: -1 else: 1

    const FactoradicConversionBlockSize = 32

    type FactoradicProductNode = object
        first, last, left, right: int
        product: BigInt

    proc buildFactoradicProducts(nodes: var seq[FactoradicProductNode], first, last: int): int =
        ## 区間 [first, last) の基数 i+1 の積を分割統治で前計算する。
        var node = FactoradicProductNode(first: first, last: last, left: -1, right: -1)
        if last - first <= FactoradicConversionBlockSize:
            node.product = initBigInt(1)
            for i in first..<last: node.product *= initBigInt(i + 1)
        else:
            let middle = first + (last - first) div 2
            node.left = buildFactoradicProducts(nodes, first, middle)
            node.right = buildFactoradicProducts(nodes, middle, last)
            node.product = nodes[node.left].product * nodes[node.right].product
        result = nodes.len
        nodes.add(node)

    proc restoreFactoradicBlock(value: BigInt, nodes: seq[FactoradicProductNode],
            index: int, digits: var seq[int]) =
        ## 区間の積で商と余りに分け、混合基数の各桁を復元する。
        if value.isZero: return
        let node = nodes[index]
        if node.left < 0:
            var value = value
            for i in node.first..<node.last:
                if value.isZero: break
                let division = divmod(value, initBigInt(i + 1))
                digits[i] = division.remainder.toInt()
                value = division.quotient
        else:
            let division = divmod(value, nodes[node.left].product)
            restoreFactoradicBlock(division.remainder, nodes, node.left, digits)
            restoreFactoradicBlock(division.quotient, nodes, node.right, digits)

    proc initFactoradic*(value: BigInt): Factoradic =
        ## 多倍長整数を変換する。高速乗除算時 O(M(B) log(N+1))、B はビット長、N は桁数。
        if initBigInt(low(int)) <= value and value <= initBigInt(high(int)):
            return initFactoradic(value.toInt())
        result.negative = value.sgn < 0
        let value = abs(value)
        var nodes: seq[FactoradicProductNode]
        var last = FactoradicConversionBlockSize + 1
        var root = buildFactoradicProducts(nodes, 1, last)
        while nodes[root].product <= value:
            let next = 1 + 2 * (last - 1)
            let right = buildFactoradicProducts(nodes, last, next)
            nodes.add(FactoradicProductNode(first: 1, last: next, left: root, right: right,
                product: nodes[root].product * nodes[right].product))
            root = nodes.high
            last = next
        result.data = newSeq[int](last)
        restoreFactoradicBlock(value, nodes, root, result.data)
        result.normalize()

    proc factorialFactoradic*(n: int): Factoradic =
        ## N! を階乗進数で返す。O(N+1) 時間・領域。0! = 1、負の N はエラー。
        doAssert n >= 0, "階乗の引数は非負である必要がある"
        let index = max(n, 1)
        result.data = newSeq[int](index + 1)
        result.data[index] = 1

    proc modFactorial*(self: Factoradic, k: int): Factoradic =
        ## k! で割った非負の余りを返す。非負の値は O(min(桁数,k)+1)、負の値は O(k+1)。負の k はエラー。
        doAssert k >= 0, "階乗の引数は非負である必要がある"
        let size = min(self.data.len, k)
        result.data = newSeq[int](size)
        for i in 0..<size: result.data[i] = self.data[i]
        result.normalize()
        if self.negative and result.data.len > 0:
            result.data.setLen(k)
            var borrow = 0
            for i in 0..<k:
                var digit = -result.data[i] - borrow
                borrow = int(digit < 0)
                if borrow > 0: digit += i + 1
                result.data[i] = digit
            result.normalize()

    proc digits*(self: Factoradic): seq[int] =
        ## 絶対値の下位桁から並べた i! の係数を返す。0 は空配列。O(桁数)。
        result = newSeq[int](self.data.len)
        for i, digit in self.data: result[i] = digit

    proc toInt*[T: SomeInteger](self: Factoradic, kind: typedesc[T]): T =
        ## 整数型 T に O(桁数) で変換する。T の範囲外や負数の符号なし型への変換はエラー。
        var value = 0'u64
        var limit = uint64(high(T))
        when T is SomeSignedInt:
            if self.negative: inc limit
        else:
            doAssert not self.negative, "負数は符号なし整数型に変換できない"
        for i in countdown(self.data.high, 1):
            let digit = uint64(self.data[i])
            doAssert digit <= limit, "変換先の整数型の上限を超えている"
            doAssert value <= (limit - digit) div uint64(i + 1),
                "変換先の整数型の上限を超えている"
            value = value * uint64(i + 1) + digit
        when T is SomeSignedInt:
            if self.negative:
                if value == limit: return low(T)
                return -T(value)
        result = T(value)

    proc toInt*(self: Factoradic): int =
        ## int に O(桁数) で変換する。int の範囲外はエラー。
        self.toInt(int)

    proc factoradicIntMagnitude(value: int): uint64 =
        ## int の絶対値を最小値も含めて uint64 で返す。O(1)。
        if value < 0: uint64(-(value + 1)) + 1'u64 else: uint64(value)

    proc factoradicMulAddDivmod(a, b, c, divisor: uint64): tuple[quotient, remainder: uint64] =
        ## a*b+c を 128 ビットで計算して除算する。商が uint64 に収まる場合に使用する。
        var quotient, remainder: uint64
        {.emit: """
        {
            unsigned __int128 value = (unsigned __int128)`a` * `b` + `c`;
            `quotient` = value / `divisor`;
            `remainder` = value % `divisor`;
        }
        """.}
        (quotient, remainder)

    proc factoradicSignedRemainder(remainder, modulus: uint64,
            negativeDividend, negativeDivisor: bool): int =
        ## 絶対値の余りを Python と同じ除数と同符号の余りに補正する。O(1)。
        if remainder == 0: return 0
        let magnitude = if negativeDividend != negativeDivisor: modulus - remainder else: remainder
        if negativeDivisor: -int(magnitude) else: int(magnitude)

    proc `mod`*(self: Factoradic, modulus: int): int =
        ## Python と同じ余りを int で返す。O(桁数+1) 時間・O(1) 領域。0 除算は DivByZeroDefect。
        if modulus == 0:
            raise newException(DivByZeroDefect, "階乗進数の 0 除算")
        let magnitude = factoradicIntMagnitude(modulus)
        var remainder = 0'u64
        for i in countdown(self.data.high, 1):
            remainder = factoradicMulAddDivmod(remainder, uint64(i + 1),
                uint64(self.data[i]), magnitude).remainder
        factoradicSignedRemainder(remainder, magnitude, self.negative, modulus < 0)

    proc factoradicBlockValue(digits: seq[int], first, last: int): tuple[value, product: BigInt] =
        ## 各区間の値と基数の積を計算し、下位の値 + 基数の積 * 上位の値で結合する。
        if last - first <= FactoradicConversionBlockSize:
            result.value = initBigInt(0)
            result.product = initBigInt(1)
            for i in countdown(last - 1, first):
                result.value = result.value * initBigInt(i + 1) + initBigInt(digits[i])
                result.product *= initBigInt(i + 1)
        else:
            let middle = first + (last - first) div 2
            let left = factoradicBlockValue(digits, first, middle)
            let right = factoradicBlockValue(digits, middle, last)
            result.value = left.value + left.product * right.value
            result.product = left.product * right.product

    proc toBigInt*(self: Factoradic): BigInt =
        ## 多倍長整数に変換する。高速乗算時 O(M(B) log(N+1))、B はビット長、N は桁数。
        if self.data.len <= FactoradicConversionBlockSize + 1:
            result = initBigInt(0)
            for i in countdown(self.data.high, 1):
                result = result * initBigInt(i + 1) + initBigInt(self.data[i])
        else:
            result = factoradicBlockValue(self.data, 1, self.data.len).value
        if self.negative: result = -result

    proc `$`*(self: Factoradic): string =
        ## 値を十進整数として表示する。組み込み整数の上限に制限されない。
        $self.toBigInt()

    proc factoradicCmpAbs(a, b: Factoradic): int =
        ## 絶対値を比較する。桁数が異なれば O(1)、同じなら O(桁数)。
        result = cmp(a.data.len, b.data.len)
        if result != 0: return
        for i in countdown(a.data.high, 0):
            result = cmp(a.data[i], b.data[i])
            if result != 0: return

    proc cmp*(a, b: Factoradic): int =
        ## 符号付きの大小を比較する。符号や桁数が異なれば O(1)、それ以外は O(桁数)。
        if a.negative != b.negative:
            return if a.negative: -1 else: 1
        result = factoradicCmpAbs(a, b)
        if a.negative: result = -result

    proc `<`*(a, b: Factoradic): bool =
        ## a が b より小さいかを判定する。O(最大桁数)。
        cmp(a, b) < 0

    proc `<=`*(a, b: Factoradic): bool =
        ## a が b 以下かを判定する。O(最大桁数)。
        cmp(a, b) <= 0

    proc `>`*(a, b: Factoradic): bool =
        ## a が b より大きいかを判定する。O(最大桁数)。
        cmp(a, b) > 0

    proc `>=`*(a, b: Factoradic): bool =
        ## a が b 以上かを判定する。O(最大桁数)。
        cmp(a, b) >= 0

    proc hash*(self: Factoradic): Hash =
        ## 階乗進数のハッシュ値を O(桁数) で返す。
        !$ (hash(self.data) !& hash(self.negative))

    proc cmp*[T: SomeInteger](a: Factoradic, b: T): int =
        ## 整数と比較して -1、0、1 を返す。O(整数 b の階乗進数の桁数+1)。
        cmp(a, initFactoradic(b))

    proc cmp*[T: SomeInteger](a: T, b: Factoradic): int =
        ## 整数から見た大小を -1、0、1 で返す。O(整数 a の階乗進数の桁数+1)。
        -cmp(b, a)

    proc `<`*[T: SomeInteger](a: Factoradic, b: T): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) < 0

    proc `<`*[T: SomeInteger](a: T, b: Factoradic): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) < 0

    proc `<=`*[T: SomeInteger](a: Factoradic, b: T): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) <= 0

    proc `<=`*[T: SomeInteger](a: T, b: Factoradic): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) <= 0

    proc `>`*[T: SomeInteger](a: Factoradic, b: T): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) > 0

    proc `>`*[T: SomeInteger](a: T, b: Factoradic): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) > 0

    proc `>=`*[T: SomeInteger](a: Factoradic, b: T): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) >= 0

    proc `>=`*[T: SomeInteger](a: T, b: Factoradic): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) >= 0

    proc `==`*[T: SomeInteger](a: Factoradic, b: T): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) == 0

    proc `==`*[T: SomeInteger](a: T, b: Factoradic): bool =
        ## 階乗進数と整数を比較する。負の整数にも対応する。
        cmp(a, b) == 0

    proc factoradicAddAbs(a, b: Factoradic): Factoradic =
        ## 絶対値同士を加算する。O(最大桁数)。
        let size = max(a.data.len, b.data.len)
        result.data = newSeq[int](size)
        var carry = 0
        for i in 0..<size:
            var digit = carry
            if i < a.data.len: digit += a.data[i]
            if i < b.data.len: digit += b.data[i]
            result.data[i] = digit mod (i + 1)
            carry = digit div (i + 1)
        if carry > 0: result.data.add(carry)

    proc factoradicSubAbs(a, b: Factoradic): Factoradic =
        ## |a| >= |b| の絶対値同士を減算する。O(最大桁数)。
        let size = max(a.data.len, b.data.len)
        result.data = newSeq[int](size)
        var borrow = 0
        for i in 0..<size:
            var digit = -borrow
            if i < a.data.len: digit += a.data[i]
            if i < b.data.len: digit -= b.data[i]
            borrow = int(digit < 0)
            if borrow > 0: digit += i + 1
            result.data[i] = digit
        doAssert borrow == 0, "階乗進数の減算結果が負になっている"
        result.normalize()

    proc `+`*(a, b: Factoradic): Factoradic =
        ## 符号付きの階乗進数同士を加算する。O(最大桁数)。
        if a.negative == b.negative:
            result = factoradicAddAbs(a, b)
            result.negative = a.negative and result.data.len > 0
        elif factoradicCmpAbs(a, b) >= 0:
            result = factoradicSubAbs(a, b)
            result.negative = a.negative and result.data.len > 0
        else:
            result = factoradicSubAbs(b, a)
            result.negative = b.negative and result.data.len > 0

    proc `-`*(a, b: Factoradic): Factoradic =
        ## 符号付きの階乗進数同士を減算する。O(最大桁数)。
        a + (-b)

    proc `+=`*(a: var Factoradic, b: Factoradic) =
        ## 階乗進数を加算して代入する。O(最大桁数)。
        a = a + b

    proc `-=`*(a: var Factoradic, b: Factoradic) =
        ## 階乗進数を減算して代入する。O(最大桁数)。
        a = a - b

    proc `+`*[T: SomeInteger](a: Factoradic, b: T): Factoradic =
        ## 整数を加算する。O(最大桁数)。
        a + initFactoradic(b)

    proc `+`*[T: SomeInteger](a: T, b: Factoradic): Factoradic =
        ## 整数に階乗進数を加算する。O(最大桁数)。
        b + a

    proc `-`*[T: SomeInteger](a: Factoradic, b: T): Factoradic =
        ## 整数を減算する。O(最大桁数)。
        a - initFactoradic(b)

    proc `-`*[T: SomeInteger](a: T, b: Factoradic): Factoradic =
        ## 整数から階乗進数を減算する。O(最大桁数)。
        initFactoradic(a) - b

    proc `+=`*[T: SomeInteger](a: var Factoradic, b: T) =
        ## 整数を加算して代入する。O(最大桁数)。
        a = a + b

    proc `-=`*[T: SomeInteger](a: var Factoradic, b: T) =
        ## 整数を減算して代入する。O(最大桁数)。
        a = a - b

    proc `*`*(a: Factoradic, b: int): Factoradic
        ## 整数との線形時間の乗算を前方宣言する。

    proc divmod*(a: Factoradic, b: int): tuple[quotient: Factoradic, remainder: int]
        ## 整数との線形時間の除算を前方宣言する。

    proc `*`*(a, b: Factoradic): Factoradic =
        ## 高速乗算時は変換込みで O(M(B) log(N+1))。片方が int に収まれば線形時間。
        if a.data.len == 0 or b.data.len == 0: return
        if low(int) <= a and a <= high(int): return b * a.toInt()
        if low(int) <= b and b <= high(int): return a * b.toInt()
        initFactoradic(a.toBigInt() * b.toBigInt())

    proc divmod*(a, b: Factoradic): tuple[quotient, remainder: Factoradic] =
        ## Python と同じ床除算の商と余りを返す。0 除算は DivByZeroDefect。
        if b.data.len == 0:
            raise newException(DivByZeroDefect, "階乗進数の 0 除算")
        if low(int) <= b and b <= high(int):
            let division = divmod(a, b.toInt())
            return (division.quotient, initFactoradic(division.remainder))
        let order = factoradicCmpAbs(a, b)
        if order < 0:
            if a.data.len > 0 and a.negative != b.negative:
                return (initFactoradic(-1), a + b)
            return (default(Factoradic), a)
        if order == 0:
            return (initFactoradic(if a.negative != b.negative: -1 else: 1), default(Factoradic))
        let division = divmod(a.toBigInt(), b.toBigInt())
        result.quotient = initFactoradic(division.quotient)
        result.remainder = initFactoradic(division.remainder)

    proc `div`*(a, b: Factoradic): Factoradic =
        ## Python と同じ床除算の商を返す。0 除算は DivByZeroDefect。
        if b.data.len == 0:
            raise newException(DivByZeroDefect, "階乗進数の 0 除算")
        if low(int) <= b and b <= high(int): return divmod(a, b.toInt()).quotient
        let order = factoradicCmpAbs(a, b)
        if order < 0:
            return initFactoradic(if a.data.len > 0 and a.negative != b.negative: -1 else: 0)
        if order == 0: return initFactoradic(if a.negative != b.negative: -1 else: 1)
        initFactoradic(a.toBigInt() div b.toBigInt())

    proc `mod`*(a, b: Factoradic): Factoradic =
        ## Python と同じ除数と同符号の余りを返す。0 除算は DivByZeroDefect。
        if b.data.len == 0:
            raise newException(DivByZeroDefect, "階乗進数の 0 除算")
        if low(int) <= b and b <= high(int): return initFactoradic(a mod b.toInt())
        let order = factoradicCmpAbs(a, b)
        if order < 0:
            if a.data.len > 0 and a.negative != b.negative: return a + b
            return a
        if order == 0: return
        initFactoradic(a.toBigInt() mod b.toBigInt())

    proc `*=`*(a: var Factoradic, b: Factoradic) =
        ## 階乗進数を掛けて代入する。
        a = a * b

    proc `div=`*(a: var Factoradic, b: Factoradic) =
        ## 階乗進数で割った商を代入する。0 除算には DivByZeroDefect を送出する。
        a = a div b

    proc `mod=`*(a: var Factoradic, b: Factoradic) =
        ## 階乗進数で割った余りを代入する。0 除算には DivByZeroDefect を送出する。
        a = a mod b

    proc `*`*(a: Factoradic, b: int): Factoradic =
        ## 符号付き整数を掛ける。O(結果の桁数+1) 時間・領域。
        if b == 0 or a.data.len == 0: return
        result.negative = a.negative != (b < 0)
        let magnitude = factoradicIntMagnitude(b)
        result.data = newSeq[int](a.data.len)
        var carry = 0'u64
        for i, digit in a.data:
            let division = factoradicMulAddDivmod(uint64(digit), magnitude, carry, uint64(i + 1))
            result.data[i] = int(division.remainder)
            carry = division.quotient
        while carry > 0:
            let radix = uint64(result.data.len + 1)
            result.data.add(int(carry mod radix))
            carry = carry div radix

    proc `*`*(a: int, b: Factoradic): Factoradic =
        ## 符号付き整数に階乗進数を掛ける。O(結果の桁数+1)。
        b * a

    proc divmod*(a: Factoradic, b: int): tuple[quotient: Factoradic, remainder: int] =
        ## Python と同じ商と int の余りを O(入力の桁数+1) 時間・領域で返す。0 除算は DivByZeroDefect。
        if b == 0:
            raise newException(DivByZeroDefect, "階乗進数の 0 除算")
        result.quotient.data = newSeq[int](a.data.len)
        let magnitude = factoradicIntMagnitude(b)
        var remainder = 0'u64
        for i in countdown(a.data.high, 1):
            let division = factoradicMulAddDivmod(remainder, uint64(i + 1), uint64(a.data[i]), magnitude)
            result.quotient.data[i] = int(division.quotient)
            remainder = division.remainder
        result.quotient.normalize()
        if a.negative != (b < 0):
            if remainder != 0: result.quotient += 1
            result.quotient = -result.quotient
        result.remainder = factoradicSignedRemainder(remainder, magnitude, a.negative, b < 0)

    proc divmod*(a: int, b: Factoradic): tuple[quotient, remainder: Factoradic] =
        ## 整数を階乗進数で床除算する。異符号の余りの構築には O(b の桁数) が必要。0 除算は DivByZeroDefect。
        divmod(initFactoradic(a), b)

    proc `div`*(a: Factoradic, b: int): Factoradic =
        ## 整数で床除算した商を O(入力の桁数+1) 時間・領域で返す。0 除算は DivByZeroDefect。
        divmod(a, b).quotient

    proc `div`*(a: int, b: Factoradic): Factoradic =
        ## 整数を階乗進数で床除算した商を返す。O(a の階乗進数の桁数+1)。0 除算は DivByZeroDefect。
        initFactoradic(a) div b

    proc `mod`*(a: int, b: Factoradic): Factoradic =
        ## 整数を階乗進数で割った余りを返す。異符号の場合は O(b の桁数)。0 除算は DivByZeroDefect。
        divmod(a, b).remainder

    proc `*=`*(a: var Factoradic, b: int) =
        ## 符号付き整数を掛けて代入する。
        a = a * b

    proc `div=`*(a: var Factoradic, b: int) =
        ## 整数で床除算した商を代入する。0 除算は DivByZeroDefect。
        a = a div b

    proc `mod=`*(a: var Factoradic, b: int) =
        ## 整数で割った余りを階乗進数として代入する。0 除算は DivByZeroDefect。
        a = initFactoradic(a mod b)

    proc initFactoradicCounts(n: int): seq[int] =
        ## 各要素の個数が 1 の Fenwick tree を O(N) で構築する。
        result = newSeq[int](n + 1)
        for i in 1..n: result[i] = i and -i

    proc removeFactoradicValue(counts: var seq[int], value: int) =
        ## 指定した要素を Fenwick tree から取り除く。O(log N)。
        var i = value + 1
        while i < counts.len:
            dec counts[i]
            i += i and -i

    proc permutationRank*(permutation: openArray[int]): Factoradic =
        ## 0..<N の順列の辞書順順位を階乗進数で返す。O(N log N) 時間・O(N) 領域。
        let n = permutation.len
        var counts = initFactoradicCounts(n)
        var used = newSeq[bool](n)
        result.data = newSeq[int](n)
        for i, value in permutation:
            doAssert 0 <= value and value < n, "順列の要素が範囲外"
            doAssert not used[value], "順列の要素が重複している"
            used[value] = true
            var j = value
            while j > 0:
                result.data[n - 1 - i] += counts[j]
                j -= j and -j
            counts.removeFactoradicValue(value)
        result.normalize()

    proc toPermutation*(self: Factoradic, n: int): seq[int] =
        ## 辞書順で self 番目の 0..<N の順列を復元する。O(N log N) 時間・O(N) 領域。
        ## N < 0 または self >= N! はエラー。N = 0 の順位 0 は空順列。
        doAssert n >= 0, "順列の長さは非負である必要がある"
        doAssert not self.negative, "順列の順位は非負である必要がある"
        doAssert self.data.len <= n, "順位が順列の個数以上になっている"
        var counts = initFactoradicCounts(n)
        result = newSeq[int](n)
        var step = 1
        while step <= n div 2: step *= 2
        for i in 0..<n:
            let digitIndex = n - 1 - i
            var rank = if digitIndex < self.data.len: self.data[digitIndex] else: 0
            var value = 0
            var width = step
            while width > 0:
                let next = value + width
                if next <= n and counts[next] <= rank:
                    rank -= counts[next]
                    value = next
                width = width shr 1
            result[i] = value
            counts.removeFactoradicValue(value)
