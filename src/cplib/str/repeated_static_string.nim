when not declared CPLIB_STR_REPEATED_STATIC_STRING:
    const CPLIB_STR_REPEATED_STATIC_STRING* = 1
    import cplib/str/static_string
    import cplib/str/fixedlength_merged_static_string

    type RepeatedStaticString*[T] = object
        ## `period` を無限に繰り返した列の先頭 `size` 要素を表す。
        period*: StaticString[T]
        size*: int

    proc initRepeatedStaticString*[T](S: StaticString[T], k: Natural): RepeatedStaticString[T] {.inline.} =
        ## SSS... の先頭 k 文字を構築する。
        assert k == 0 or len(S) > 0
        result.period = S
        result.size = int(k)

    proc len*[T](S: RepeatedStaticString[T]): int {.inline.} =
        result = S.size

    proc `[]`*[T](S: RepeatedStaticString[T], idx: Natural): T {.inline.} =
        assert idx < len(S)
        result = S.period[idx mod len(S.period)]

    proc infiniteLcp[T](S, U: StaticString[T]): int {.inline.} =
        ## 2つの無限列が異なるなら、そのLCPはSTとTSのLCPに等しい。
        ## 2つの無限列が等しい場合は high(int) を返す。
        assert S.base == U.base
        assert len(S) > 0 and len(U) > 0
        result = lcp(S & U, U & S)
        if result == len(S)+len(U):
            result = high(int)

    proc lcp*[T](S, U: RepeatedStaticString[T]): int {.inline.} =
        assert S.period.base == U.period.base
        result = min(len(S), len(U))
        if result == 0:
            return
        result = min(result, infiniteLcp(S.period, U.period))

    proc lcp*[T](S: RepeatedStaticString[T], U: StaticString[T]): int {.inline.} =
        assert S.period.base == U.base
        result = min(len(S), len(U))
        if result == 0:
            return
        result = min(result, infiniteLcp(S.period, U))

    proc lcp*[T](S: StaticString[T], U: RepeatedStaticString[T]): int {.inline.} =
        result = lcp(U, S)

    proc compareFromLcp[A, B](left: A, right: B, commonPrefix: int): int {.inline.} =
        let commonLength = min(len(left), len(right))
        if commonPrefix == commonLength:
            if len(left) == len(right):
                return 0
            if len(left) < len(right):
                return -1
            return 1
        if left[commonPrefix] < right[commonPrefix]:
            return -1
        return 1

    proc cmp*[T](S, U: RepeatedStaticString[T]): int {.inline.} =
        result = compareFromLcp(S, U, lcp(S, U))

    proc cmp*[T](S: RepeatedStaticString[T], U: StaticString[T]): int {.inline.} =
        result = compareFromLcp(S, U, lcp(S, U))

    proc cmp*[T](S: StaticString[T], U: RepeatedStaticString[T]): int {.inline.} =
        result = compareFromLcp(S, U, lcp(S, U))

    proc `<`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) < 0
    proc `>`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) > 0
    proc `<=`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) <= 0
    proc `>=`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) >= 0
    proc `==`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} =
        len(S) == len(U) and lcp(S, U) == len(S)

    proc `<`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} = cmp(S, U) < 0
    proc `>`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} = cmp(S, U) > 0
    proc `<=`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} = cmp(S, U) <= 0
    proc `>=`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} = cmp(S, U) >= 0
    proc `==`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} =
        len(S) == len(U) and lcp(S, U) == len(S)

    proc `<`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) < 0
    proc `>`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) > 0
    proc `<=`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) <= 0
    proc `>=`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) >= 0
    proc `==`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = U == S

    proc `$`*[T](S: RepeatedStaticString[T]): string =
        when T is char:
            result = newString(len(S))
            for i in 0..<len(S):
                result[i] = S[i]
        else:
            for i in 0..<len(S):
                if i > 0:
                    result &= " "
                result &= $S[i]
