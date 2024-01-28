when not declared CPLIB_MATRIX_MATOPS:
    const CPLIB_MATRIX_MATOPS* = 1
    import sequtils, strutils
    proc rotated*[T](a: seq[seq[T]], num: int = 1): seq[seq[T]] =
        if a.len == 0: return a
        var
            h = a.len
            w = a[0].len
            num = ((num mod 4) + 4) mod 4
        if num == 0: return a
        if num == 1 or num == 3:
            result = newSeqWith(w, newSeq[int](h))
            for i in 0..<w:
                for j in 0..<h:
                    if num == 1: result[i][j] = result[h-1-j][i]
                    else: result[i][j] = result[j][w-1-i]
        else:
            result = newSeqWith(h, newSeq[int](w))
            for i in 0..<h:
                for j in 0..<w:
                    result[i][j] = result[h-1-i][w-1-j]
    proc rotated*[T](a: seq[string], num: int = 1) = a.mapIt(it.toSeq).rotated(num).mapIt(it.join(""))
    proc rotate*[T](a: var seq[seq[T]], num: int = 1) = (a = rotated(a, num))

