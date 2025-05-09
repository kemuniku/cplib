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