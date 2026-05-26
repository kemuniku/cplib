when not declared CPLIB_UTILS_SEQIDX:
    const CPLIB_UTILS_SEQIDX* = 1

    template allItidx*(s, pred: untyped): bool =
        var result = true
        for idx{.inject.},it {.inject.} in s:
            if not pred:
                result = false
                break
        result

    template findItIdx*(s, predicate: untyped): int =
        var
            res = -1
            i = 0

        for idx{.inject.},it {.inject.} in s:
            if predicate:
                res = i
                break
            i += 1
        res

    template anyItIdx*(s, pred: untyped): bool =
        findItIdx(s, pred) != -1

    template mapItIdx*(s: typed, op: untyped): untyped =
        block:
            type OutType = typeof((
                block:
                    var it{.inject, used.}: typeof(items(s), typeOfIter);var idx{.inject, used.} : int;
                    op), typeOfProc)
            var result = newSeq[OutType](len(s))
            var idx{.inject.} = 0
            for it{.inject.} in s:
                result[idx] = op
                idx += 1
            move(result)

    template newSeqWithIdx*(len: int, init: untyped): untyped =
        block:
            var idx{.inject.} : int = 0
            type T = typeof(init)
            let newLen = len
            var result = newSeq[T](newLen)
            for i in 0 ..< newLen:
                result[i] = init
                idx += 1
            move(result)