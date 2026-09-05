when not declared CPLIB_TMPL_SHEEP:
    const CPLIB_TMPL_SHEEP* = 1
    {.warning[UnusedImport]: off.}
    {.hint[XDeclaredButNotUsed]: off.}
    import algorithm
    import sequtils
    import tables
    import macros
    import math
    import sets
    import strutils
    import strformat
    import sugar
    import heapqueue
    import streams
    import deques
    import bitops
    import std/lenientops
    import options
    include cplib/tmpl/fastio
    macro getSymbolName(x: typed): string = x.toStrLit
    macro debug*(args: varargs[untyped]): untyped =
        when defined(debug):
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
    #chmin,chmax
    template `max=`(x, y) =
        let yVal = y # yが計算式の場合に評価を1回にするため
        if x < yVal:
            x = yVal

    template `min=`(x, y) =
        let yVal = y
        if x > yVal:
            x = yVal
    proc chmin[T](x: var T, y: T):bool=
        if x > y:
            x = y
            return true
        return false
    proc chmax[T](x: var T, y: T):bool=
        if x < y:
            x = y
            return true
        return false
    #bit演算
    proc `%`*(x: int, y: int): int =
        result = x mod y
        if y > 0 and result < 0: result += y
        if y < 0 and result > 0: result += y
    proc `//`*(x: int, y: int): int{.inline.} =
        result = x div y
        if y > 0 and result * y > x: result -= 1
        if y < 0 and result * y < x: result -= 1
    proc `%=`(x: var int, y: int): void = x = x%y
    proc `//=`(x: var int, y: int): void = x = x//y
    proc `**`(x: int, y: int): int = x^y
    proc `**=`(x: var int, y: int): void = x = x^y
    proc `^`(x: int, y: int): int = x xor y
    proc `|`(x: int, y: int): int = x or y
    proc `&`(x: int, y: int): int = x and y
    proc `>>`(x: int, y: int): int = x shr y
    proc `<<`(x: int, y: int): int = x shl y
    proc `~`(x: int): int = not x
    proc `^=`(x: var int, y: int): void = x = x ^ y
    proc `&=`(x: var int, y: int): void = x = x & y
    proc `|=`(x: var int, y: int): void = x = x | y
    proc `>>=`(x: var int, y: int): void = x = x >> y
    proc `<<=`(x: var int, y: int): void = x = x << y
    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0
    #便利な変換
    proc `!`(x: char, a = '0'): int = int(x)-int(a)
    #定数
    include cplib/utils/constants
    const INF = INF64
    #converter

    #range
    iterator range(start: int, ends: int, step: int): int =
        var i = start
        if step < 0:
            while i > ends:
                yield i
                i += step
        elif step > 0:
            while i < ends:
                yield i
                i += step
    iterator range(ends: int): int = (for i in 0..<ends: yield i)
    iterator range(start: int, ends: int): int = (for i in
            start..<ends: yield i)

    proc dump[T](arr:seq[seq[T]])=
        for i in 0..<len(arr):
            echo arr[i]

    proc sum(slice:HSlice[int,int]):int=
        return (slice.a+slice.b)*len(slice)//2
    
    proc `<`[T](l,r:seq[T]):bool=
        for i in 0..<min(len(l),len(r)):
            if l[i] > r[i]:
                return false
            elif l[i] < r[i]:
                return true
        return len(l) < len(r)
    
    # Yes/No
    proc yes*(b: bool = true): void = print(if b: "Yes" else: "No")

    template dblock(body: untyped) =
        when defined(debug):
            block:
                body
