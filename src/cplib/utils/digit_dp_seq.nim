when not declared CPLIB_UTILS_DIGIT_DP_SEQ:
    const CPLIB_UTILS_DIGIT_DP_SEQ* = 1

    import algorithm, options

    type
        DigitDpSeqResult*[S, T] = object
            lower: S
            widths: seq[int]
            data: seq[T]
            present: seq[bool]
            reached: int

    proc digitDpSeqWidths[S](lower, upper: S, widths: var seq[int], size: var int) =
        ## 各整数成分の閉区間幅と直積の大きさを、溢れを検査して求める。
        when S is SomeInteger:
            if lower > upper:
                raise newException(ValueError, "状態の下限は上限以下にしてください")
            let distance = uint64(upper) - uint64(lower)
            if distance >= uint64(high(int) - 1):
                raise newException(ValueError, "状態区間が大きすぎます")
            let width = int(distance) + 1
            if size > (high(int) - 1) div width:
                raise newException(ValueError, "状態数の積が大きすぎます")
            size *= width
            widths.add(width)
        elif S is tuple:
            for a, b in fields(lower, upper):
                digitDpSeqWidths(a, b, widths, size)
        else:
            {.error: "状態は組み込み整数、またはそのタプルにしてください".}

    proc digitDpSeqIndex[S](state, lower: S, widths: seq[int], axis: var int,
                            index, stride: var int): bool =
        ## 最初の成分を最下位として平坦化する。範囲外ならfalseを返す。
        when S is SomeInteger:
            let offset = uint64(state) - uint64(lower)
            if state < lower or offset >= uint64(widths[axis]):
                return false
            index += int(offset) * stride
            stride *= widths[axis]
            inc axis
        else:
            for a, b in fields(state, lower):
                if not digitDpSeqIndex(a, b, widths, axis, index, stride):
                    return false
        true

    proc digitDpSeqState[S](state: var S, lower: S, widths: seq[int],
                            axis: var int, index: var int) =
        ## 平坦な添字から整数またはタプルの状態を復元する。
        when S is SomeInteger:
            let offset = index mod widths[axis]
            index = index div widths[axis]
            when S is SomeSignedInt:
                state = S(cast[int64](uint64(lower) + uint64(offset)))
            else:
                state = S(uint64(lower) + uint64(offset))
            inc axis
        else:
            for a, b in fields(state, lower):
                digitDpSeqState(a, b, widths, axis, index)

    proc stateIndex*[S, T](counts: DigitDpSeqResult[S, T], state: S): int =
        ## 状態に対応するseq添字をO(成分数)で返す。範囲外はIndexDefect。
        var axis = 0
        var stride = 1
        if not digitDpSeqIndex(state, counts.lower, counts.widths, axis, result, stride):
            raise newException(IndexDefect, "状態が指定区間の外です")

    proc stateAt*[S, T](counts: DigitDpSeqResult[S, T], index: int): S =
        ## seq添字に対応する状態をO(成分数)で返す。範囲外はIndexDefect。
        if index < 0 or index >= counts.data.len:
            raise newException(IndexDefect, "状態の添字が範囲外です")
        var axis = 0
        var rest = index
        digitDpSeqState(result, counts.lower, counts.widths, axis, rest)

    proc `[]`*[S, T](counts: DigitDpSeqResult[S, T], state: S): T =
        ## 状態の個数を返す。区間内の未到達状態はzero、区間外はIndexDefect。
        counts.data[counts.stateIndex(state)]

    proc hasKey*[S, T](counts: DigitDpSeqResult[S, T], state: S): bool =
        ## 値がzeroかどうかと独立に到達性を返す。区間外ならfalse。
        var axis, index = 0
        var stride = 1
        digitDpSeqIndex(state, counts.lower, counts.widths, axis, index, stride) and counts.present[index]

    proc len*[S, T](counts: DigitDpSeqResult[S, T]): int =
        ## 到達済みの状態数をO(1)で返す。
        counts.reached

    proc toSeq*[S, T](counts: DigitDpSeqResult[S, T]): seq[T] =
        ## 全区間の値を平坦なseqとして返す。先頭成分が最も速く変わる。
        counts.data

    iterator pairs*[S, T](counts: DigitDpSeqResult[S, T]): (S, T) =
        ## 到達状態と個数を添字順に列挙する。全状態数K、成分数DとしてO(KD)。
        for index, value in counts.data:
            if counts.present[index]:
                yield (counts.stateAt(index), value)

    proc digitDpSeqImpl[S, T, I, N](digits: openArray[int], stateRange: HSlice[S, S],
                                initialState: I, next: N, zero, one: T,
                                base: int = 10): DigitDpSeqResult[S, T] =
        ## 指定区間でseq版の共通処理を行う。
        mixin `+`
        if digits.len == 0 or base < 2:
            raise newException(ValueError, "空の桁配列または不正な基数です")
        for digit in digits:
            if digit < 0 or digit >= base:
                raise newException(ValueError, "桁が基数の範囲外です")
        result.lower = stateRange.a
        var size = 1
        digitDpSeqWidths(stateRange.a, stateRange.b, result.widths, size)
        if size + 1 > (high(int) - 64) div max(sizeof(T), sizeof(int)):
            raise newException(ValueError, "seqのサイズが大きすぎます")
        let lower = result.lower
        let widths = result.widths
        proc checkedIndex(state: S): int =
            ## 指定区間外の状態を黙って捨てずに検出する。
            var axis = 0
            var stride = 1
            if not digitDpSeqIndex(state, lower, widths, axis, result, stride):
                raise newException(ValueError, "初期状態または遷移先が指定区間の外です")

        var dp, nextDp: array[2, seq[T]]
        var present, nextPresent: array[2, seq[bool]]
        var active, nextActive: array[2, seq[int]]
        for tight in 0..1:
            dp[tight] = newSeq[T](size + 1)
            nextDp[tight] = newSeq[T](size + 1)
            present[tight] = newSeq[bool](size + 1)
            nextPresent[tight] = newSeq[bool](size + 1)
        when I is S:
            let start = checkedIndex(initialState)
        else:
            let start = size
        dp[1][start] = one
        present[1][start] = true
        active[1].add(start)
        for pos, bound in digits:
            for tight in 0..1:
                for index in nextActive[tight]:
                    nextPresent[tight][index] = false
                nextActive[tight].setLen(0)
            for tight in 0..1:
                let limit = if tight == 1: bound else: base - 1
                for index in active[tight]:
                    var state: S
                    if index != size:
                        var axis = 0
                        var rest = index
                        digitDpSeqState(state, lower, widths, axis, rest)
                    for digit in 0..limit:
                        var targetIndex: int
                        when I is S:
                            let target = next(pos, state, digit)
                            when target is Option[S]:
                                if target.isNone: continue
                                targetIndex = checkedIndex(target.get)
                            else:
                                targetIndex = checkedIndex(target)
                        else:
                            if index == size:
                                if digit == 0 and pos + 1 < digits.len:
                                    targetIndex = size
                                else:
                                    let target = initialState(digit, digits.len - pos)
                                    when target is Option[S]:
                                        if target.isNone: continue
                                        targetIndex = checkedIndex(target.get)
                                    else:
                                        targetIndex = checkedIndex(target)
                            else:
                                let target = next(pos, state, digit)
                                when target is Option[S]:
                                    if target.isNone: continue
                                    targetIndex = checkedIndex(target.get)
                                else:
                                    targetIndex = checkedIndex(target)
                        let nt = ord(tight == 1 and digit == bound)
                        if not nextPresent[nt][targetIndex]:
                            nextPresent[nt][targetIndex] = true
                            nextActive[nt].add(targetIndex)
                            nextDp[nt][targetIndex] = zero
                        nextDp[nt][targetIndex] = nextDp[nt][targetIndex] + dp[tight][index]
            swap(dp, nextDp)
            swap(present, nextPresent)
            swap(active, nextActive)
        result.data = newSeq[T](size)
        result.present = newSeq[bool](size)
        for index in 0..<size:
            result.data[index] = zero
            for tight in 0..1:
                if present[tight][index]:
                    result.data[index] = result.data[index] + dp[tight][index]
                    result.present[index] = true
            if result.present[index]: inc result.reached

    proc digitDpSeqImpl[S, T, I, N](digits: SomeInteger, stateRange: HSlice[S, S],
                                initialState: I, next: N, zero, one: T,
                                base: int = 10): DigitDpSeqResult[S, T] =
        ## 非負整数上限をbase進数へ変換して数える。変換はO(桁数)。
        if digits < 0 or base < 2:
            raise newException(ValueError, "上限は非負、基数は2以上にしてください")
        var value = uint64(digits)
        var converted: seq[int]
        while true:
            converted.add(int(value mod uint64(base)))
            value = value div uint64(base)
            if value == 0: break
        converted.reverse()
        digitDpSeqImpl(converted, stateRange, initialState, next, zero, one, base)

    proc digitDpSeqImpl[S, T, I, N](upper: string, stateRange: HSlice[S, S],
                                initialState: I, next: N, zero, one: T): DigitDpSeqResult[S, T] =
        ## 10進文字列上限を数える。先頭0の扱いは桁配列版と同じ。変換はO(文字数)。
        var converted = newSeq[int](upper.len)
        for pos, digit in upper:
            if digit notin {'0'..'9'}:
                raise newException(ValueError, "上限には10進数字のみを指定してください")
            converted[pos] = ord(digit) - ord('0')
        digitDpSeqImpl(converted, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## Tableを使わず、整数または整数タプルの直積閉区間で桁DPを行う。
        ## 例: stateRange = -3..3、または (0, -2)..(9, 2)。Sは区間から推論する。
        ## 初期値Sでは先頭0も遷移する。初期化関数(firstDigit, digitCount)では
        ## 桁合わせの0を飛ばし、先頭桁を処理済みの状態から始める。0は(0, 1)で初期化。
        ## next(pos, state, digit)のposは上限の左から0始まり。関数はSかOption[S]を返す。
        ## noneは経路を拒否する。初期値・初期化結果・遷移先が区間外ならValueError。
        ## Tには加算だけが必要で、zeroは加法単位元、oneは1通りの値。到達性は別途保持する。
        ## 空桁列、不正な基数・桁、逆転区間、幅・状態数・seqサイズの溢れはValueError。
        ## 状態数Kは区間幅の積で、実際に確保できるメモリも必要。疎な区間にはTable版を推奨。
        ## L桁、基数B、成分数D、各層の到達状態数Aとして時間O(K + LABD)、領域O(K + D)。
        ## 遷移・初期化・加算をO(1)とする。呼び出し順序・回数に依存する関数は渡さない。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期値とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期値と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期値とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T, base: int = 10): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(digits, stateRange, initialState, next, zero, one, base)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期値と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期値とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期化関数と状態を直接返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            zero, one: T): DigitDpSeqResult[S, T] =
        ## 初期化関数とOptionを返す遷移で数える。条件・計算量は桁配列版と同じ。
        digitDpSeqImpl(upper, stateRange, initialState, next, zero, one)

    template digitDpSeqUnit(T: typedesc, value: static int): untyped =
        ## 型のinitがあれば優先し、なければ整数から構築する。
        when compiles(T.init(value)):
            T.init(value)
        else:
            T(value)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        ## 例: digitDpSeq(999, 0..6, 0, next, int64)。独自の単位元は明示指定版を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: openArray[int], stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](digits: SomeInteger, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T], base: int = 10): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(digits, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1), base)

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: S,
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): S {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): S {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))

    proc digitDpSeq*[S, T](upper: string, stateRange: HSlice[S, S],
                            initialState: proc(firstDigit, digitCount: int): Option[S] {.closure.},
                            next: proc(pos: int, state: S, digit: int): Option[S] {.closure.},
                            countType: typedesc[T]): DigitDpSeqResult[S, T] =
        ## 個数型を指定しzero/oneを省略する。T.init(0/1)、なければT(0/1)を使う。
        digitDpSeq(upper, stateRange, initialState, next,
            digitDpSeqUnit(T, 0), digitDpSeqUnit(T, 1))
