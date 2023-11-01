when not declared CPLIB_STRING_UTILS:
    const CPLIB_STRING_UTILS* = 1
    import sequtils
    proc run_length_encode*[T](a: seq[T]): seq[(T, int)] =
        for i in 0..<len(a):
            if result.len == 0:
                result.add((a[i], 1))
                continue
            if result[^1][0] == a[i]: result[^1][1] += 1
            else: result.add((a[i], 1))

    proc run_length_encode*(s: string): seq[(char, int)] =
        var a = s.items.toSeq
        return run_length_encode(a)
