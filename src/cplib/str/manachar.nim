when not declared CPLIB_STR_MANACHAR:
    const CPLIB_STR_MANACHAR* = 1
    import sequtils
    proc manachar*[T](s: seq[T]): seq[int] =
        result = newSeq[int](s.len)
        result[0] = 0
        var c = 0
        for i in 0..<s.len:
            var l = 2*c - i
            if l in 0..<s.len and i + result[l] < c + result[c]:
                result[i] = result[l]
            else:
                var j = c + result[c] - i
                while i-j >= 0 and i+j < s.len and s[i-j] == s[i+j]: j += 1
                result[i] = j
                c = i
    proc manachar*(s: string): seq[int] = manachar(s.toSeq)
