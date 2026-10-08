when not declared CPLIB_UTILS_DIGIT_DP:
    const CPLIB_UTILS_DIGIT_DP* = 1

    import algorithm, options, tables

    type
        DigitDpTransition*[S] = proc(pos: int, state: S, digit: int): Option[S] {.closure.}
        DigitDpDirectTransition*[S] = proc(pos: int, state: S, digit: int): S {.closure.}
        DigitDpInitialState*[S] = proc(firstDigit, digitCount: int): S {.closure.}
        DigitDpOptionalInitialState*[S] = proc(firstDigit, digitCount: int): Option[S] {.closure.}

    proc digitDp*[S, T](digits: openArray[int], initialState: S,
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 0以上、digitsで表した上限以下の整数を、最終状態ごとに数える。
        ## digitsは上位桁から並べた空でない配列で、base >= 2、各桁は0..<base。
        ## 全数をdigits.len桁に0埋めし、先頭の0もnextに渡す。整数0も含む。
        ## next(pos, state, digit)のposは左から0始まりで、none(S)は遷移不可。
        ## Sにはhashと==が必要で、Tableに格納した状態は後から変更しない。
        ## Tには加算が必要で、zeroとoneには個数の0と1を渡す。
        ## 到達不能な状態は返り値に含まれない。到達した状態は個数がzeroでも残る。
        ## 桁数L、各層の最大状態数K、基数Bとして、期待時間O(LKB)、追加領域O(K)。
        ## 上記は状態のハッシュ・比較、遷移、個数の加算をO(1)とした場合。
        mixin `+`
        assert digits.len > 0, "上限の桁配列は空にできません"
        assert base >= 2, "基数は2以上である必要があります"
        for digit in digits:
            assert digit >= 0 and digit < base, "各桁は0以上、基数未満である必要があります"

        var dp: array[2, Table[S, T]]
        for tight in 0..1:
            dp[tight] = initTable[S, T]()
        dp[1][initialState] = one

        for pos, bound in digits:
            var nextDp: array[2, Table[S, T]]
            for tight in 0..1:
                nextDp[tight] = initTable[S, T]()
            for tight in 0..1:
                let limit = if tight == 1: bound else: base - 1
                for state, count in dp[tight]:
                    for digit in 0..limit:
                        let target = next(pos, state, digit)
                        if target.isNone:
                            continue
                        let
                            nextState = target.get
                            nextTight = ord(tight == 1 and digit == bound)
                        nextDp[nextTight][nextState] =
                            nextDp[nextTight].getOrDefault(nextState, zero) + count
            swap(dp, nextDp)

        result = move(dp[0])
        for state, count in dp[1]:
            result[state] = result.getOrDefault(state, zero) + count

    proc digitDp*[S, T](digits: openArray[int], initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 先頭桁と実際の桁数から初期状態を作り、上限以下の非負整数を数える。
        ## initialState(firstDigit, digitCount)は先頭桁を処理済みの状態をsomeで返す。
        ## initialStateがnone(S)を返した先頭桁・桁数の経路は数えない。
        ## 桁合わせの0は飛ばし、nextは2桁目から呼ぶ。0はinitialState(0, 1)で扱う。
        ## nextのposは上限の左端から0始まりの位置で、短い数でも右端をそろえる。
        ## initialStateの呼び出し順序・回数には依存しないこと。
        ## 型の要件・入力の条件は、初期状態を値で渡す桁配列版と同じ。
        ## 初期化もO(1)なら、同様に期待時間O(LKB)、追加領域O(K)。
        let digitCount = digits.len
        proc startOrNext(pos: int, state: Option[S], digit: int): Option[Option[S]] =
            ## 未開始の経路を初期化し、開始済みなら通常の遷移を行う。
            if state.isSome:
                let target = next(pos, state.get, digit)
                if target.isSome:
                    return some(target)
                return none(Option[S])
            if digit == 0 and pos + 1 < digitCount:
                return some(none(S))
            let target = initialState(digit, digitCount - pos)
            if target.isSome:
                return some(target)
            none(Option[S])

        let counts = digitDp(digits, none(S), startOrNext, zero, one, base)
        result = initTable[S, T]()
        for state, count in counts:
            if state.isSome:
                result[state.get] = count

    proc digitDp*[S, T](digits: openArray[int], initialState: DigitDpInitialState[S],
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 全開始状態を許可する初期化関数で、上限以下の非負整数を数える。
        ## 初期化関数は先頭桁を処理済みの状態Sを直接返し、nextは2桁目から呼ぶ。
        ## 桁位置・型の要件・計算量は、Optionを返す初期化関数の版と同じ。
        proc optionalInitial(firstDigit, digitCount: int): Option[S] =
            ## 初期状態を必ず受理するOptionに包む。
            some(initialState(firstDigit, digitCount))
        digitDp(digits, optionalInitial, next, zero, one, base)

    proc digitDpOptionalTransition[S](next: DigitDpDirectTransition[S]): DigitDpTransition[S] =
        ## 状態を直接返す遷移関数を、全遷移を許可するOption版に変換する。
        result = proc(pos: int, state: S, digit: int): Option[S] =
            ## 遷移先を必ず受理するOptionに包む。
            some(next(pos, state, digit))

    proc digitDp*[S, T](digits: openArray[int], initialState: S,
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 状態を直接返すnextで数える。先頭の0を含むすべての桁に遷移する。
        digitDp(digits, initialState, digitDpOptionalTransition(next), zero, one, base)

    proc digitDp*[S, T](digits: openArray[int], initialState: DigitDpInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 初期化・遷移ともに状態を直接返す関数で数える。nextは2桁目から呼ぶ。
        digitDp(digits, initialState, digitDpOptionalTransition(next), zero, one, base)

    proc digitDp*[S, T](digits: openArray[int], initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 開始時だけ拒否できる初期化関数と、状態を直接返す遷移関数で数える。
        digitDp(digits, initialState, digitDpOptionalTransition(next), zero, one, base)

    proc digitDpDigits(digits: SomeInteger, base: int): seq[int] =
        ## 非負整数を上位桁からのbase進数に変換する。桁数Lに対しO(L)。
        assert digits >= 0, "上限は非負である必要があります"
        assert base >= 2, "基数は2以上である必要があります"
        var value = uint64(digits)
        while true:
            result.add(int(value mod uint64(base)))
            value = value div uint64(base)
            if value == 0:
                break
        result.reverse()

    proc digitDpDigits(upper: string): seq[int] =
        ## 空でない10進文字列を上位桁からの桁配列に変換する。O(upper.len)。
        assert upper.len > 0, "上限の文字列は空にできません"
        result = newSeq[int](upper.len)
        for pos, digit in upper:
            assert digit in {'0'..'9'}, "上限には10進数字のみを指定してください"
            result[pos] = ord(digit) - ord('0')

    proc digitDp*[S, T](digits: SomeInteger, initialState: S,
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 非負整数digits以下の整数を、base進数の最終状態ごとに数える。
        ## 上限は先頭の0がない桁配列に変換し、0は1桁の[0]として扱う。
        ## base >= 2。桁数Lとして、変換にO(L)の時間・追加領域を使う。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](digits: SomeInteger, initialState: DigitDpInitialState[S],
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 先頭桁と実際の桁数から初期状態を作り、非負整数digits以下を数える。
        ## base >= 2。0はinitialState(0, 1)で扱い、nextは2桁目から呼ぶ。
        ## 桁配列版に対して、変換に桁数に比例する時間・追加領域を使う。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](digits: SomeInteger, initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 開始時・遷移時に拒否できる関数で、非負整数digits以下を数える。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](digits: SomeInteger, initialState: S,
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 状態を直接返すnextで非負整数digits以下を数える。先頭の0も処理する。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](digits: SomeInteger, initialState: DigitDpInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 初期化・遷移ともに状態を直接返す関数で、非負整数digits以下を数える。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](digits: SomeInteger, initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T,
                        base: int = 10): Table[S, T] =
        ## 開始時だけ拒否できる初期化関数と、状態を直接返すnextで整数上限まで数える。
        digitDp(digitDpDigits(digits, base), initialState, next, zero, one, base)

    proc digitDp*[S, T](upper: string, initialState: S,
                        next: DigitDpTransition[S], zero, one: T): Table[S, T] =
        ## 10進文字列upper以下の非負整数を最終状態ごとに数える。
        ## upperは数字のみからなる空でない文字列で、先頭の0も処理する。
        ## 桁配列版に対して、変換にO(upper.len)の時間・追加領域を使う。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)

    proc digitDp*[S, T](upper: string, initialState: DigitDpInitialState[S],
                        next: DigitDpTransition[S], zero, one: T): Table[S, T] =
        ## 先頭桁と実際の桁数から初期状態を作り、10進文字列upper以下を数える。
        ## upperは数字のみからなる空でない文字列で、桁合わせの0は飛ばす。
        ## 桁配列版に対して、変換にO(upper.len)の時間・追加領域を使う。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)

    proc digitDp*[S, T](upper: string, initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpTransition[S], zero, one: T): Table[S, T] =
        ## 開始時・遷移時に拒否できる関数で、10進文字列upper以下を数える。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)

    proc digitDp*[S, T](upper: string, initialState: S,
                        next: DigitDpDirectTransition[S], zero, one: T): Table[S, T] =
        ## 状態を直接返すnextで10進文字列upper以下を数える。先頭の0も処理する。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)

    proc digitDp*[S, T](upper: string, initialState: DigitDpInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T): Table[S, T] =
        ## 初期化・遷移ともに状態を直接返す関数で、10進文字列upper以下を数える。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)

    proc digitDp*[S, T](upper: string, initialState: DigitDpOptionalInitialState[S],
                        next: DigitDpDirectTransition[S], zero, one: T): Table[S, T] =
        ## 開始時だけ拒否できる初期化関数と、状態を直接返すnextで10進上限まで数える。
        digitDp(digitDpDigits(upper), initialState, next, zero, one)
