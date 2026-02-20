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
    #入力系
    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
    proc getchar(): char {.importc: "getchar_unlocked", header: "<stdio.h>", discardable.}
    proc ii(): int {.inline.} = scanf("%lld\n", addr result)
    proc lii(N: int): seq[int] {.inline.} = newSeqWith(N, ii())
    proc si(): string {.inline.} =
        result = ""
        var c: char
        while true:
            c = getchar()
            if c == ' ' or c == '\n' or c == '\255':
                break
            result &= c
    
    # 出力系
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
    template `max=`(x, y) = x = max(x, y)
    template `min=`(x, y) = x = min(x, y)
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

    #joinが非stringでめちゃくちゃ遅いやつのパッチ
    proc join*[T: not string](a: openArray[T], sep: string = ""): string = a.mapit($it).join(sep)

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
    proc oo*(b: bool = true): void = yes(not b)

    proc takahashi(b:bool = true) : void = print(if b: "Takahashi" else: "Aoki")
    proc aoki(b:bool = true) : void = takahashi(not b)

    template dblock(body: untyped) =
        when defined(debug):
            body
