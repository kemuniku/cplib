---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_callbacks_test.nim
    title: verify/utils/digit_dp_callbacks_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_callbacks_test.nim
    title: verify/utils/digit_dp_callbacks_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_initial_state_test.nim
    title: verify/utils/digit_dp_initial_state_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_initial_state_test.nim
    title: verify/utils/digit_dp_initial_state_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_test.nim
    title: verify/utils/digit_dp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/digit_dp_test.nim
    title: verify/utils/digit_dp_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_DIGIT_DP:\n    const CPLIB_UTILS_DIGIT_DP*\
    \ = 1\n\n    import algorithm, options, tables\n\n    type\n        DigitDpTransition*[S]\
    \ = proc(pos: int, state: S, digit: int): Option[S] {.closure.}\n        DigitDpDirectTransition*[S]\
    \ = proc(pos: int, state: S, digit: int): S {.closure.}\n        DigitDpInitialState*[S]\
    \ = proc(firstDigit, digitCount: int): S {.closure.}\n        DigitDpOptionalInitialState*[S]\
    \ = proc(firstDigit, digitCount: int): Option[S] {.closure.}\n\n    proc digitDp*[S,\
    \ T](digits: openArray[int], initialState: S,\n                        next: DigitDpTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## 0\u4EE5\u4E0A\u3001digits\u3067\u8868\u3057\u305F\u4E0A\u9650\u4EE5\u4E0B\
    \u306E\u6574\u6570\u3092\u3001\u6700\u7D42\u72B6\u614B\u3054\u3068\u306B\u6570\
    \u3048\u308B\u3002\n        ## digits\u306F\u4E0A\u4F4D\u6841\u304B\u3089\u4E26\
    \u3079\u305F\u7A7A\u3067\u306A\u3044\u914D\u5217\u3067\u3001base >= 2\u3001\u5404\
    \u6841\u306F0..<base\u3002\n        ## \u5168\u6570\u3092digits.len\u6841\u306B\
    0\u57CB\u3081\u3057\u3001\u5148\u982D\u306E0\u3082next\u306B\u6E21\u3059\u3002\
    \u6574\u65700\u3082\u542B\u3080\u3002\n        ## next(pos, state, digit)\u306E\
    pos\u306F\u5DE6\u304B\u30890\u59CB\u307E\u308A\u3067\u3001none(S)\u306F\u9077\u79FB\
    \u4E0D\u53EF\u3002\n        ## S\u306B\u306Fhash\u3068==\u304C\u5FC5\u8981\u3067\
    \u3001Table\u306B\u683C\u7D0D\u3057\u305F\u72B6\u614B\u306F\u5F8C\u304B\u3089\u5909\
    \u66F4\u3057\u306A\u3044\u3002\n        ## T\u306B\u306F\u52A0\u7B97\u304C\u5FC5\
    \u8981\u3067\u3001zero\u3068one\u306B\u306F\u500B\u6570\u306E0\u30681\u3092\u6E21\
    \u3059\u3002\n        ## \u5230\u9054\u4E0D\u80FD\u306A\u72B6\u614B\u306F\u8FD4\
    \u308A\u5024\u306B\u542B\u307E\u308C\u306A\u3044\u3002\u5230\u9054\u3057\u305F\
    \u72B6\u614B\u306F\u500B\u6570\u304Czero\u3067\u3082\u6B8B\u308B\u3002\n     \
    \   ## \u6841\u6570L\u3001\u5404\u5C64\u306E\u6700\u5927\u72B6\u614B\u6570K\u3001\
    \u57FA\u6570B\u3068\u3057\u3066\u3001\u671F\u5F85\u6642\u9593O(LKB)\u3001\u8FFD\
    \u52A0\u9818\u57DFO(K)\u3002\n        ## \u4E0A\u8A18\u306F\u72B6\u614B\u306E\u30CF\
    \u30C3\u30B7\u30E5\u30FB\u6BD4\u8F03\u3001\u9077\u79FB\u3001\u500B\u6570\u306E\
    \u52A0\u7B97\u3092O(1)\u3068\u3057\u305F\u5834\u5408\u3002\n        mixin `+`\n\
    \        assert digits.len > 0, \"\u4E0A\u9650\u306E\u6841\u914D\u5217\u306F\u7A7A\
    \u306B\u3067\u304D\u307E\u305B\u3093\"\n        assert base >= 2, \"\u57FA\u6570\
    \u306F2\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        for digit in digits:\n            assert digit >= 0 and digit < base,\
    \ \"\u5404\u6841\u306F0\u4EE5\u4E0A\u3001\u57FA\u6570\u672A\u6E80\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\n        var dp: array[2, Table[S,\
    \ T]]\n        for tight in 0..1:\n            dp[tight] = initTable[S, T]()\n\
    \        dp[1][initialState] = one\n\n        for pos, bound in digits:\n    \
    \        var nextDp: array[2, Table[S, T]]\n            for tight in 0..1:\n \
    \               nextDp[tight] = initTable[S, T]()\n            for tight in 0..1:\n\
    \                let limit = if tight == 1: bound else: base - 1\n           \
    \     for state, count in dp[tight]:\n                    for digit in 0..limit:\n\
    \                        let target = next(pos, state, digit)\n              \
    \          if target.isNone:\n                            continue\n         \
    \               let\n                            nextState = target.get\n    \
    \                        nextTight = ord(tight == 1 and digit == bound)\n    \
    \                    nextDp[nextTight][nextState] =\n                        \
    \    nextDp[nextTight].getOrDefault(nextState, zero) + count\n            swap(dp,\
    \ nextDp)\n\n        result = move(dp[0])\n        for state, count in dp[1]:\n\
    \            result[state] = result.getOrDefault(state, zero) + count\n\n    proc\
    \ digitDp*[S, T](digits: openArray[int], initialState: DigitDpOptionalInitialState[S],\n\
    \                        next: DigitDpTransition[S], zero, one: T,\n         \
    \               base: int = 10): Table[S, T] =\n        ## \u5148\u982D\u6841\u3068\
    \u5B9F\u969B\u306E\u6841\u6570\u304B\u3089\u521D\u671F\u72B6\u614B\u3092\u4F5C\
    \u308A\u3001\u4E0A\u9650\u4EE5\u4E0B\u306E\u975E\u8CA0\u6574\u6570\u3092\u6570\
    \u3048\u308B\u3002\n        ## initialState(firstDigit, digitCount)\u306F\u5148\
    \u982D\u6841\u3092\u51E6\u7406\u6E08\u307F\u306E\u72B6\u614B\u3092some\u3067\u8FD4\
    \u3059\u3002\n        ## initialState\u304Cnone(S)\u3092\u8FD4\u3057\u305F\u5148\
    \u982D\u6841\u30FB\u6841\u6570\u306E\u7D4C\u8DEF\u306F\u6570\u3048\u306A\u3044\
    \u3002\n        ## \u6841\u5408\u308F\u305B\u306E0\u306F\u98DB\u3070\u3057\u3001\
    next\u306F2\u6841\u76EE\u304B\u3089\u547C\u3076\u30020\u306FinitialState(0, 1)\u3067\
    \u6271\u3046\u3002\n        ## next\u306Epos\u306F\u4E0A\u9650\u306E\u5DE6\u7AEF\
    \u304B\u30890\u59CB\u307E\u308A\u306E\u4F4D\u7F6E\u3067\u3001\u77ED\u3044\u6570\
    \u3067\u3082\u53F3\u7AEF\u3092\u305D\u308D\u3048\u308B\u3002\n        ## initialState\u306E\
    \u547C\u3073\u51FA\u3057\u9806\u5E8F\u30FB\u56DE\u6570\u306B\u306F\u4F9D\u5B58\
    \u3057\u306A\u3044\u3053\u3068\u3002\n        ## \u578B\u306E\u8981\u4EF6\u30FB\
    \u5165\u529B\u306E\u6761\u4EF6\u306F\u3001\u521D\u671F\u72B6\u614B\u3092\u5024\
    \u3067\u6E21\u3059\u6841\u914D\u5217\u7248\u3068\u540C\u3058\u3002\n        ##\
    \ \u521D\u671F\u5316\u3082O(1)\u306A\u3089\u3001\u540C\u69D8\u306B\u671F\u5F85\
    \u6642\u9593O(LKB)\u3001\u8FFD\u52A0\u9818\u57DFO(K)\u3002\n        let digitCount\
    \ = digits.len\n        proc startOrNext(pos: int, state: Option[S], digit: int):\
    \ Option[Option[S]] =\n            ## \u672A\u958B\u59CB\u306E\u7D4C\u8DEF\u3092\
    \u521D\u671F\u5316\u3057\u3001\u958B\u59CB\u6E08\u307F\u306A\u3089\u901A\u5E38\
    \u306E\u9077\u79FB\u3092\u884C\u3046\u3002\n            if state.isSome:\n   \
    \             let target = next(pos, state.get, digit)\n                if target.isSome:\n\
    \                    return some(target)\n                return none(Option[S])\n\
    \            if digit == 0 and pos + 1 < digitCount:\n                return some(none(S))\n\
    \            let target = initialState(digit, digitCount - pos)\n            if\
    \ target.isSome:\n                return some(target)\n            none(Option[S])\n\
    \n        let counts = digitDp(digits, none(S), startOrNext, zero, one, base)\n\
    \        result = initTable[S, T]()\n        for state, count in counts:\n   \
    \         if state.isSome:\n                result[state.get] = count\n\n    proc\
    \ digitDp*[S, T](digits: openArray[int], initialState: DigitDpInitialState[S],\n\
    \                        next: DigitDpTransition[S], zero, one: T,\n         \
    \               base: int = 10): Table[S, T] =\n        ## \u5168\u958B\u59CB\u72B6\
    \u614B\u3092\u8A31\u53EF\u3059\u308B\u521D\u671F\u5316\u95A2\u6570\u3067\u3001\
    \u4E0A\u9650\u4EE5\u4E0B\u306E\u975E\u8CA0\u6574\u6570\u3092\u6570\u3048\u308B\
    \u3002\n        ## \u521D\u671F\u5316\u95A2\u6570\u306F\u5148\u982D\u6841\u3092\
    \u51E6\u7406\u6E08\u307F\u306E\u72B6\u614BS\u3092\u76F4\u63A5\u8FD4\u3057\u3001\
    next\u306F2\u6841\u76EE\u304B\u3089\u547C\u3076\u3002\n        ## \u6841\u4F4D\
    \u7F6E\u30FB\u578B\u306E\u8981\u4EF6\u30FB\u8A08\u7B97\u91CF\u306F\u3001Option\u3092\
    \u8FD4\u3059\u521D\u671F\u5316\u95A2\u6570\u306E\u7248\u3068\u540C\u3058\u3002\
    \n        proc optionalInitial(firstDigit, digitCount: int): Option[S] =\n   \
    \         ## \u521D\u671F\u72B6\u614B\u3092\u5FC5\u305A\u53D7\u7406\u3059\u308B\
    Option\u306B\u5305\u3080\u3002\n            some(initialState(firstDigit, digitCount))\n\
    \        digitDp(digits, optionalInitial, next, zero, one, base)\n\n    proc digitDpOptionalTransition[S](next:\
    \ DigitDpDirectTransition[S]): DigitDpTransition[S] =\n        ## \u72B6\u614B\
    \u3092\u76F4\u63A5\u8FD4\u3059\u9077\u79FB\u95A2\u6570\u3092\u3001\u5168\u9077\
    \u79FB\u3092\u8A31\u53EF\u3059\u308BOption\u7248\u306B\u5909\u63DB\u3059\u308B\
    \u3002\n        result = proc(pos: int, state: S, digit: int): Option[S] =\n \
    \           ## \u9077\u79FB\u5148\u3092\u5FC5\u305A\u53D7\u7406\u3059\u308BOption\u306B\
    \u5305\u3080\u3002\n            some(next(pos, state, digit))\n\n    proc digitDp*[S,\
    \ T](digits: openArray[int], initialState: S,\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u72B6\u614B\u3092\u76F4\u63A5\u8FD4\u3059next\u3067\u6570\u3048\u308B\
    \u3002\u5148\u982D\u306E0\u3092\u542B\u3080\u3059\u3079\u3066\u306E\u6841\u306B\
    \u9077\u79FB\u3059\u308B\u3002\n        digitDp(digits, initialState, digitDpOptionalTransition(next),\
    \ zero, one, base)\n\n    proc digitDp*[S, T](digits: openArray[int], initialState:\
    \ DigitDpInitialState[S],\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u521D\u671F\u5316\u30FB\u9077\u79FB\u3068\u3082\u306B\u72B6\u614B\u3092\
    \u76F4\u63A5\u8FD4\u3059\u95A2\u6570\u3067\u6570\u3048\u308B\u3002next\u306F2\u6841\
    \u76EE\u304B\u3089\u547C\u3076\u3002\n        digitDp(digits, initialState, digitDpOptionalTransition(next),\
    \ zero, one, base)\n\n    proc digitDp*[S, T](digits: openArray[int], initialState:\
    \ DigitDpOptionalInitialState[S],\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u958B\u59CB\u6642\u3060\u3051\u62D2\u5426\u3067\u304D\u308B\u521D\u671F\
    \u5316\u95A2\u6570\u3068\u3001\u72B6\u614B\u3092\u76F4\u63A5\u8FD4\u3059\u9077\
    \u79FB\u95A2\u6570\u3067\u6570\u3048\u308B\u3002\n        digitDp(digits, initialState,\
    \ digitDpOptionalTransition(next), zero, one, base)\n\n    proc digitDpDigits(digits:\
    \ SomeInteger, base: int): seq[int] =\n        ## \u975E\u8CA0\u6574\u6570\u3092\
    \u4E0A\u4F4D\u6841\u304B\u3089\u306Ebase\u9032\u6570\u306B\u5909\u63DB\u3059\u308B\
    \u3002\u6841\u6570L\u306B\u5BFE\u3057O(L)\u3002\n        assert digits >= 0, \"\
    \u4E0A\u9650\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert base >= 2, \"\u57FA\u6570\u306F2\u4EE5\u4E0A\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var value =\
    \ uint64(digits)\n        while true:\n            result.add(int(value mod uint64(base)))\n\
    \            value = value div uint64(base)\n            if value == 0:\n    \
    \            break\n        result.reverse()\n\n    proc digitDpDigits(upper:\
    \ string): seq[int] =\n        ## \u7A7A\u3067\u306A\u304410\u9032\u6587\u5B57\
    \u5217\u3092\u4E0A\u4F4D\u6841\u304B\u3089\u306E\u6841\u914D\u5217\u306B\u5909\
    \u63DB\u3059\u308B\u3002O(upper.len)\u3002\n        assert upper.len > 0, \"\u4E0A\
    \u9650\u306E\u6587\u5B57\u5217\u306F\u7A7A\u306B\u3067\u304D\u307E\u305B\u3093\
    \"\n        result = newSeq[int](upper.len)\n        for pos, digit in upper:\n\
    \            assert digit in {'0'..'9'}, \"\u4E0A\u9650\u306B\u306F10\u9032\u6570\
    \u5B57\u306E\u307F\u3092\u6307\u5B9A\u3057\u3066\u304F\u3060\u3055\u3044\"\n \
    \           result[pos] = ord(digit) - ord('0')\n\n    proc digitDp*[S, T](digits:\
    \ SomeInteger, initialState: S,\n                        next: DigitDpTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u975E\u8CA0\u6574\u6570digits\u4EE5\u4E0B\u306E\u6574\u6570\u3092\u3001\
    base\u9032\u6570\u306E\u6700\u7D42\u72B6\u614B\u3054\u3068\u306B\u6570\u3048\u308B\
    \u3002\n        ## \u4E0A\u9650\u306F\u5148\u982D\u306E0\u304C\u306A\u3044\u6841\
    \u914D\u5217\u306B\u5909\u63DB\u3057\u30010\u306F1\u6841\u306E[0]\u3068\u3057\u3066\
    \u6271\u3046\u3002\n        ## base >= 2\u3002\u6841\u6570L\u3068\u3057\u3066\u3001\
    \u5909\u63DB\u306BO(L)\u306E\u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\u3092\u4F7F\
    \u3046\u3002\n        digitDp(digitDpDigits(digits, base), initialState, next,\
    \ zero, one, base)\n\n    proc digitDp*[S, T](digits: SomeInteger, initialState:\
    \ DigitDpInitialState[S],\n                        next: DigitDpTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u5148\u982D\u6841\u3068\u5B9F\u969B\u306E\u6841\u6570\u304B\u3089\u521D\
    \u671F\u72B6\u614B\u3092\u4F5C\u308A\u3001\u975E\u8CA0\u6574\u6570digits\u4EE5\
    \u4E0B\u3092\u6570\u3048\u308B\u3002\n        ## base >= 2\u30020\u306FinitialState(0,\
    \ 1)\u3067\u6271\u3044\u3001next\u306F2\u6841\u76EE\u304B\u3089\u547C\u3076\u3002\
    \n        ## \u6841\u914D\u5217\u7248\u306B\u5BFE\u3057\u3066\u3001\u5909\u63DB\
    \u306B\u6841\u6570\u306B\u6BD4\u4F8B\u3059\u308B\u6642\u9593\u30FB\u8FFD\u52A0\
    \u9818\u57DF\u3092\u4F7F\u3046\u3002\n        digitDp(digitDpDigits(digits, base),\
    \ initialState, next, zero, one, base)\n\n    proc digitDp*[S, T](digits: SomeInteger,\
    \ initialState: DigitDpOptionalInitialState[S],\n                        next:\
    \ DigitDpTransition[S], zero, one: T,\n                        base: int = 10):\
    \ Table[S, T] =\n        ## \u958B\u59CB\u6642\u30FB\u9077\u79FB\u6642\u306B\u62D2\
    \u5426\u3067\u304D\u308B\u95A2\u6570\u3067\u3001\u975E\u8CA0\u6574\u6570digits\u4EE5\
    \u4E0B\u3092\u6570\u3048\u308B\u3002\n        digitDp(digitDpDigits(digits, base),\
    \ initialState, next, zero, one, base)\n\n    proc digitDp*[S, T](digits: SomeInteger,\
    \ initialState: S,\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u72B6\u614B\u3092\u76F4\u63A5\u8FD4\u3059next\u3067\u975E\u8CA0\u6574\
    \u6570digits\u4EE5\u4E0B\u3092\u6570\u3048\u308B\u3002\u5148\u982D\u306E0\u3082\
    \u51E6\u7406\u3059\u308B\u3002\n        digitDp(digitDpDigits(digits, base), initialState,\
    \ next, zero, one, base)\n\n    proc digitDp*[S, T](digits: SomeInteger, initialState:\
    \ DigitDpInitialState[S],\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T,\n                        base: int = 10): Table[S, T] =\n    \
    \    ## \u521D\u671F\u5316\u30FB\u9077\u79FB\u3068\u3082\u306B\u72B6\u614B\u3092\
    \u76F4\u63A5\u8FD4\u3059\u95A2\u6570\u3067\u3001\u975E\u8CA0\u6574\u6570digits\u4EE5\
    \u4E0B\u3092\u6570\u3048\u308B\u3002\n        digitDp(digitDpDigits(digits, base),\
    \ initialState, next, zero, one, base)\n\n    proc digitDp*[S, T](digits: SomeInteger,\
    \ initialState: DigitDpOptionalInitialState[S],\n                        next:\
    \ DigitDpDirectTransition[S], zero, one: T,\n                        base: int\
    \ = 10): Table[S, T] =\n        ## \u958B\u59CB\u6642\u3060\u3051\u62D2\u5426\u3067\
    \u304D\u308B\u521D\u671F\u5316\u95A2\u6570\u3068\u3001\u72B6\u614B\u3092\u76F4\
    \u63A5\u8FD4\u3059next\u3067\u6574\u6570\u4E0A\u9650\u307E\u3067\u6570\u3048\u308B\
    \u3002\n        digitDp(digitDpDigits(digits, base), initialState, next, zero,\
    \ one, base)\n\n    proc digitDp*[S, T](upper: string, initialState: S,\n    \
    \                    next: DigitDpTransition[S], zero, one: T): Table[S, T] =\n\
    \        ## 10\u9032\u6587\u5B57\u5217upper\u4EE5\u4E0B\u306E\u975E\u8CA0\u6574\
    \u6570\u3092\u6700\u7D42\u72B6\u614B\u3054\u3068\u306B\u6570\u3048\u308B\u3002\
    \n        ## upper\u306F\u6570\u5B57\u306E\u307F\u304B\u3089\u306A\u308B\u7A7A\
    \u3067\u306A\u3044\u6587\u5B57\u5217\u3067\u3001\u5148\u982D\u306E0\u3082\u51E6\
    \u7406\u3059\u308B\u3002\n        ## \u6841\u914D\u5217\u7248\u306B\u5BFE\u3057\
    \u3066\u3001\u5909\u63DB\u306BO(upper.len)\u306E\u6642\u9593\u30FB\u8FFD\u52A0\
    \u9818\u57DF\u3092\u4F7F\u3046\u3002\n        digitDp(digitDpDigits(upper), initialState,\
    \ next, zero, one)\n\n    proc digitDp*[S, T](upper: string, initialState: DigitDpInitialState[S],\n\
    \                        next: DigitDpTransition[S], zero, one: T): Table[S, T]\
    \ =\n        ## \u5148\u982D\u6841\u3068\u5B9F\u969B\u306E\u6841\u6570\u304B\u3089\
    \u521D\u671F\u72B6\u614B\u3092\u4F5C\u308A\u300110\u9032\u6587\u5B57\u5217upper\u4EE5\
    \u4E0B\u3092\u6570\u3048\u308B\u3002\n        ## upper\u306F\u6570\u5B57\u306E\
    \u307F\u304B\u3089\u306A\u308B\u7A7A\u3067\u306A\u3044\u6587\u5B57\u5217\u3067\
    \u3001\u6841\u5408\u308F\u305B\u306E0\u306F\u98DB\u3070\u3059\u3002\n        ##\
    \ \u6841\u914D\u5217\u7248\u306B\u5BFE\u3057\u3066\u3001\u5909\u63DB\u306BO(upper.len)\u306E\
    \u6642\u9593\u30FB\u8FFD\u52A0\u9818\u57DF\u3092\u4F7F\u3046\u3002\n        digitDp(digitDpDigits(upper),\
    \ initialState, next, zero, one)\n\n    proc digitDp*[S, T](upper: string, initialState:\
    \ DigitDpOptionalInitialState[S],\n                        next: DigitDpTransition[S],\
    \ zero, one: T): Table[S, T] =\n        ## \u958B\u59CB\u6642\u30FB\u9077\u79FB\
    \u6642\u306B\u62D2\u5426\u3067\u304D\u308B\u95A2\u6570\u3067\u300110\u9032\u6587\
    \u5B57\u5217upper\u4EE5\u4E0B\u3092\u6570\u3048\u308B\u3002\n        digitDp(digitDpDigits(upper),\
    \ initialState, next, zero, one)\n\n    proc digitDp*[S, T](upper: string, initialState:\
    \ S,\n                        next: DigitDpDirectTransition[S], zero, one: T):\
    \ Table[S, T] =\n        ## \u72B6\u614B\u3092\u76F4\u63A5\u8FD4\u3059next\u3067\
    10\u9032\u6587\u5B57\u5217upper\u4EE5\u4E0B\u3092\u6570\u3048\u308B\u3002\u5148\
    \u982D\u306E0\u3082\u51E6\u7406\u3059\u308B\u3002\n        digitDp(digitDpDigits(upper),\
    \ initialState, next, zero, one)\n\n    proc digitDp*[S, T](upper: string, initialState:\
    \ DigitDpInitialState[S],\n                        next: DigitDpDirectTransition[S],\
    \ zero, one: T): Table[S, T] =\n        ## \u521D\u671F\u5316\u30FB\u9077\u79FB\
    \u3068\u3082\u306B\u72B6\u614B\u3092\u76F4\u63A5\u8FD4\u3059\u95A2\u6570\u3067\
    \u300110\u9032\u6587\u5B57\u5217upper\u4EE5\u4E0B\u3092\u6570\u3048\u308B\u3002\
    \n        digitDp(digitDpDigits(upper), initialState, next, zero, one)\n\n   \
    \ proc digitDp*[S, T](upper: string, initialState: DigitDpOptionalInitialState[S],\n\
    \                        next: DigitDpDirectTransition[S], zero, one: T): Table[S,\
    \ T] =\n        ## \u958B\u59CB\u6642\u3060\u3051\u62D2\u5426\u3067\u304D\u308B\
    \u521D\u671F\u5316\u95A2\u6570\u3068\u3001\u72B6\u614B\u3092\u76F4\u63A5\u8FD4\
    \u3059next\u306710\u9032\u4E0A\u9650\u307E\u3067\u6570\u3048\u308B\u3002\n   \
    \     digitDp(digitDpDigits(upper), initialState, next, zero, one)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/digit_dp.nim
  requiredBy: []
  timestamp: '2026-10-08 10:15:47+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/digit_dp_callbacks_test.nim
  - verify/utils/digit_dp_callbacks_test.nim
  - verify/utils/digit_dp_test.nim
  - verify/utils/digit_dp_test.nim
  - verify/utils/digit_dp_initial_state_test.nim
  - verify/utils/digit_dp_initial_state_test.nim
documentation_of: cplib/utils/digit_dp.nim
layout: document
redirect_from:
- /library/cplib/utils/digit_dp.nim
- /library/cplib/utils/digit_dp.nim.html
title: cplib/utils/digit_dp.nim
---
