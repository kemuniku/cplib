when not declared CPLIB_MATRIX_MATOPS:
    const CPLIB_MATRIX_MATOPS* = 1
    import sequtils, strutils
    proc rotated*[T](a: seq[seq[T]], num: int = 1): seq[seq[T]] =
        if a.len == 0: return a
        proc smod(n, m: int): int = (result = n mod m; if result < 0: result += m)
        var h = a.len
        var w = a[0].len
        var num = smod(num, 4)
        if num == 0: return a
        if num == 1 or num == 3:
            result = newSeqWith(w, newSeq[T](h))
            for i in 0..<w:
                for j in 0..<h:
                    if num == 1: result[i][j] = a[h-1-j][i]
                    else: result[i][j] = a[j][w-1-i]
        else:
            result = newSeqWith(h, newSeq[T](w))
            for i in 0..<h:
                for j in 0..<w:
                    result[i][j] = a[h-1-i][w-1-j]
    proc transposed*[T](a: seq[seq[T]]): seq[seq[T]] =
        if a.len == 0: return a
        var h = a.len
        var w = a[0].len
        result = newSeqWith(w, newSeq[T](h))
        for i in 0..<w:
            for j in 0..<h:
                result[i][j] = a[j][i]
    proc trimmed*[T](a: seq[seq[T]], zero: T): seq[seq[T]] =
        result = a
        for i in 0..<4:
            result = result.rotated
            while result.len > 0 and result[^1].allIt(it == zero): discard result.pop
    proc rotated*(a: seq[string], num: int = 1): seq[string] = a.mapIt(it.toSeq).rotated(num).mapIt(it.join(""))
    proc rotate*[T](a: var seq[seq[T]], num: int = 1) = (a = rotated(a, num))
    proc rotate*(a: var seq[string], num: int = 1) = (a = rotated(a, num))
    proc transposed*(a: seq[string]): seq[string] = a.mapIt(it.toSeq).transposed.mapIt(it.join(""))
    proc transpose*[T](a: var seq[seq[T]]) = (a = a.transposed)
    proc transpose*(a: var seq[string]) = (a = a.transposed)
    proc trimmed*(a: seq[string], zero: char = '0'): seq[string] = a.mapIt(it.toSeq).trimmed(zero).mapIt(it.join(""))
    proc trim*[T](a: var seq[seq[T]], zero: T) = (a = trimmed(a, zero))
    proc trim*(a: var seq[string], zero: char = '0') = (a = trimmed(a, zero))
