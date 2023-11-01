when not declared CPLIB_TMPL_CITRUS:
    const CPLIB_TMPL_CITRUS* = 1
    {.warning[UnusedImport]: off.}
    {.hint[XDeclaredButNotUsed]: off.}
    import os
    import algorithm
    import sequtils
    import tables
    import macros
    import std/math
    import sets
    import strutils
    import strformat
    import sugar
    import streams
    import deques
    import bitops
    import heapqueue
    const MODINT998244353* = 998244353
    const MODINT1000000007* = 1000000007
    const INF* = 100100111
    const INFL* = int(3300300300300300491)
    type double* = float64
    let readNext = iterator(getsChar: bool = false): string {.closure.} =
        while true:
            var si: string
            try: si = stdin.readLine
            except EOFError: yield ""
            for s in si.split:
                if getsChar:
                    for i in 0..<s.len(): yield s[i..i]
                else:
                    yield s
    proc input*(t: typedesc[string]): string = readNext()
    proc input*(t: typedesc[char]): char = readNext(true)[0]
    proc input*(t: typedesc[int]): int = readNext().parseInt
    proc input*(t: typedesc[float]): float = readNext().parseFloat
    macro input*(t: typedesc, n: varargs[int]): untyped =
        var repStr = ""
        for arg in n:
            repStr &= &"({arg.repr}).newSeqWith "
        parseExpr(&"{repStr}input({t})")
    macro input*(ts: varargs[auto]): untyped =
        var tupStr = ""
        for t in ts:
            tupStr &= &"input({t.repr}),"
        parseExpr(&"({tupStr})")
    macro input*(n: int, ts: varargs[auto]): untyped =
        for typ in ts:
            if typ.typeKind != ntyAnything:
                error("Expected typedesc, got " & typ.repr, typ)
        parseExpr(&"({n.repr}).newSeqWith input({ts.repr})")
    proc `fmtprint`*(x: int or string or char): string = return $x
    proc `fmtprint`*(x: float or float32 or
            float64): string = return &"{x:.16f}"
    proc `fmtprint`*[T](x: seq[T] or Deque[T] or HashSet[T] or set[
            T]): string = return x.toSeq.join(" ")
    proc `fmtprint`*[T, N](x: array[T, N]): string = return x.toSeq.join(" ")
    proc `fmtprint`*[T](x: HeapQueue[T]): string =
        var q = x
        while q.len != 0:
            result &= &"{q.pop()}"
            if q.len != 0: result &= " "
    proc `fmtprint`*[T](x: CountTable[T]): string =
        result = x.pairs.toSeq.mapIt(&"{it[0]}: {it[1]}").join(" ")
    proc `fmtprint`*[K, V](x: Table[K, V]): string =
        result = x.pairs.toSeq.mapIt(&"{it[0]}: {it[1]}").join(" ")
    proc print*(prop: tuple[f: File, sepc: string, endc: string, flush: bool],
            args: varargs[string, `fmtprint`]) =
        for i in 0..<len(args):
            prop.f.write(&"{args[i]}")
            if i != len(args) - 1: prop.f.write(prop.sepc) else: prop.f.write(prop.endc)
        if prop.flush: prop.f.flushFile()
    proc print*(args: varargs[string, `fmtprint`]) = print((f: stdout,
            sepc: " ", endc: "\n", flush: false), args)
    proc inner_debug*(x: auto) = print((f: stderr, sepc: "", endc: "",
            flush: true), x)
    const LOCAL_DEBUG{.booldefine.} = false
    macro debug*(n: varargs[typed]): untyped =
        when LOCAL_DEBUG:
            result = newNimNode(nnkStmtList, n)
            for i in 0..n.len-1:
                if n[i].kind == nnkStrLit:
                    result.add(newCall("inner_debug", n[i]))
                    result.add(newCall("inner_debug", newStrLitNode(": ")))
                    result.add(newCall("inner_debug", n[i]))
                else:
                    result.add(newCall("inner_debug", toStrLit(n[i])))
                    result.add(newCall("inner_debug", newStrLitNode(": ")))
                    result.add(newCall("inner_debug", n[i]))
                if i != n.len-1:
                    result.add(newCall("inner_debug", newStrLitNode(", ")))
                else:
                    result.add(newCall("inner_debug", newStrLitNode("\n")))
        else:
            return quote do:
                discard
    proc `%`*(x: SomeInteger, y: SomeInteger): int = (((x mod y) + y) mod y)
    proc `//`*(x: int, y: int): int = ((x - (x%y)) div y)
    proc `^`*(x: int, y: int): int = x xor y
    proc `&`*(x: int, y: int): int = x and y
    proc `|`*(x: int, y: int): int = x or y
    proc `>>`*(x: int, y: int): int = x shr y
    proc `<<`*(x: int, y: int): int = x shl y
    proc `%=`*(x: var SomeInteger or int64, y: SomeInteger or
            int64): void = x = x % y
    proc `//=`*(x: var int, y: int): void = x = x // y
    proc `^=`*(x: var int, y: int): void = x = x ^ y
    proc `&=`*(x: var int, y: int): void = x = x & y
    proc `|=`*(x: var int, y: int): void = x = x | y
    proc `>>=`*(x: var int, y: int): void = x = x >> y
    proc `<<=`*(x: var int, y: int): void = x = x << y
    proc `[]`*(x: int, n: int): bool = (x and (1 shl n)) != 0

    proc pow*(a, n: int, m = INFL): int =
        var
            rev = 1
            a = a
            n = n
        while n > 0:
            if n % 2 != 0: rev = (rev * a) mod m
            if n > 1: a = (a * a) mod m
            n >>= 1
        return rev
    proc sqrt*(x: int): int =
        assert(x >= 0)
        result = int(sqrt(float64(x)))
        while result * result > x: result -= 1
        while (result+1) * (result+1) <= x: result += 1
    proc chmax*[T](x: var T, y: T): bool = (if x < y: (x = y; return true;
        ) return false)
    proc chmin*[T](x: var T, y: T): bool = (if x > y: (x = y; return true;
        ) return false)
    proc `max=`*[T](x: var T, y: T) = x = max(x, y)
    proc `min=`*[T](x: var T, y: T) = x = min(x, y)
    proc at*(x: char, a = '0'): int = int(x) - int(a)
    converter tofloat*(n: int): float = float(n)
    iterator rangeiter*(start: int, ends: int, step: int): int =
        var i = start
        if step < 0:
            while i > ends:
                yield i
                i += step
        elif step > 0:
            while i < ends:
                yield i
                i += step
    iterator rangeiter*(ends: int): int = (for i in 0..<ends: yield i)
    iterator rangeiter*(start: int, ends: int): int = (for i in
            start..<ends: yield i)
    proc Yes*(b: bool = true): void = print(if b: "Yes" else: "No")
    proc No*(b: bool = true): void = Yes(not b)
    proc YES_upper*(b: bool = true): void = print(if b: "YES" else: "NO")
    proc NO_upper*(b: bool = true): void = Yes_upper(not b)
    const DXY* = [(0, -1), (0, 1), (-1, 0), (1, 0)]
    const DDXY* = [(1, -1), (1, 0), (1, 1), (0, -1), (0, 1), (-1, -1), (-1, 0),
            (-1, 1)]
    macro exit*(statement: untyped): untyped =
        quote do:
            `statement`
            quit()
    proc vector*[T](d1, : int, default: T = T(0)): seq[T] = newSeqWith(d1, default)
    proc vv*[T](d1, d2: int, default: T = T(0)): seq[seq[T]] = newSeqWith(d1,
            newSeqWith(d2, default))
    proc vvv*[T](d1, d2, d3: int, default: T = T(0)): seq[seq[seq[
            T]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3, default)))
    proc vvvv*[T](d1, d2, d3, d4: int, default: T = T(0)): seq[seq[seq[seq[
            T]]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3, newSeqWith(d4, default))))
    proc vvvvv*[T](d1, d2, d3, d4, d5: int, default: T = T(0)): seq[seq[seq[seq[
            seq[T]]]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3,
            newSeqWith(d4, newSeqWith(d5, default)))))
    proc vvvvvv*[T](d1, d2, d3, d4, d5, d6: int, default: T = T(0)): seq[seq[
            seq[seq[seq[seq[T]]]]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(
            d3, newSeqWith(d4, newSeqWith(d5, newSeqWith(d6, default))))))
