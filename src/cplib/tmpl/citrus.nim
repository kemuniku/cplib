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
    import options
    import hashes
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
                    for i in 0..<s.len():
                        yield s[i..i]
                else:
                    if s.isEmptyOrWhitespace: continue
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
    proc `fmtprint`*(x: int or string or char or bool): string = return $x
    proc `fmtprint`*(x: float or float32 or float64): string = return &"{x:.16f}"
    proc `fmtprint`*[T](x: seq[T] or Deque[T] or HashSet[T] or set[T]): string = return x.toSeq.join(" ")
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
    proc print*(prop: tuple[f: File, sepc: string, endc: string, flush: bool], args: varargs[string, `fmtprint`]) =
        for i in 0..<len(args):
            prop.f.write(&"{args[i]}")
            if i != len(args) - 1: prop.f.write(prop.sepc) else: prop.f.write(prop.endc)
        if prop.flush: prop.f.flushFile()
    proc print*(args: varargs[string, `fmtprint`]) = print((f: stdout, sepc: " ", endc: "\n", flush: false), args)
    const LOCAL_DEBUG{.booldefine.} = false
    macro getSymbolName(x: typed): string = x.toStrLit
    macro debug*(args: varargs[untyped]): untyped =
        when LOCAL_DEBUG:
            result = newNimNode(nnkStmtList, args)
            template prop(e: string = ""): untyped = (f: stderr, sepc: "", endc: e, flush: true)
            for i, arg in args:
                if arg.kind == nnkStrLit:
                    result.add(quote do: print(prop(), "\"", `arg`, "\""))
                else:
                    result.add(quote do: print(prop(": "), getSymbolName(`arg`)))
                    result.add(quote do: print(prop(), `arg`))
                if i != args.len - 1: result.add(quote do: print(prop(), ", "))
                else: result.add(quote do: print(prop(), "\n"))
        else:
            return (quote do: discard)
    proc `%`*(x: SomeInteger, y: SomeInteger): int =
        result = x mod y
        if y > 0 and result < 0: result += y
        if y < 0 and result > 0: result += y
    proc `//`*(x: SomeInteger, y: SomeInteger): int =
        result = x div y
        if y > 0 and result * y > x: result -= 1
        if y < 0 and result * y < x: result -= 1
    proc `^`*(x: SomeInteger, y: SomeInteger): int = x xor y
    proc `&`*(x: SomeInteger, y: SomeInteger): int = x and y
    proc `|`*(x: SomeInteger, y: SomeInteger): int = x or y
    proc `>>`*(x: SomeInteger, y: SomeInteger): int = x shr y
    proc `<<`*(x: SomeInteger, y: SomeInteger): int = x shl y
    proc `%=`*(x: var SomeInteger, y: SomeInteger): void = x = x % y
    proc `//=`*(x: var SomeInteger, y: SomeInteger): void = x = x // y
    proc `^=`*(x: var SomeInteger, y: SomeInteger): void = x = x ^ y
    proc `&=`*(x: var SomeInteger, y: SomeInteger): void = x = x & y
    proc `|=`*(x: var SomeInteger, y: SomeInteger): void = x = x | y
    proc `>>=`*(x: var SomeInteger, y: SomeInteger): void = x = x >> y
    proc `<<=`*(x: var SomeInteger, y: SomeInteger): void = x = x << y
    proc `[]`*(x, n: int): bool = (x and (1 shl n)) != 0
    proc `[]=`*(x: var int, n: int, i: bool) =
        if i: x = x or (1 << n)
        else: (if x[n]: x = x xor (1 << n))
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
    include cplib/math/isqrt
    proc chmax*[T](x: var T, y: T): bool {.discardable.} = (if x < y: (x = y; return true; ) return false)
    proc chmin*[T](x: var T, y: T): bool {.discardable.} = (if x > y: (x = y; return true; ) return false)
    proc `max=`*[T](x: var T, y: T) = x = max(x, y)
    proc `min=`*[T](x: var T, y: T) = x = min(x, y)
    proc at*(x: char, a = '0'): int = int(x) - int(a)
    proc Yes*(b: bool = true): void = print(if b: "Yes" else: "No")
    proc No*(b: bool = true): void = Yes(not b)
    proc YES_upper*(b: bool = true): void = print(if b: "YES" else: "NO")
    proc NO_upper*(b: bool = true): void = Yes_upper(not b)
    const DXY* = [(0, -1), (0, 1), (-1, 0), (1, 0)]
    const DDXY* = [(1, -1), (1, 0), (1, 1), (0, -1), (0, 1), (-1, -1), (-1, 0), (-1, 1)]
    macro exit*(statement: untyped): untyped = (quote do: (`statement`; quit()))
    proc initHashSet[T](): Hashset[T] = initHashSet[T](0)
