when not declared CPLIB_SHEEP:
    const CPLIB_SHEEP* = 1
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
    #入力系
    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
    proc getchar(): char {.importc: "getchar_unlocked", header: "<stdio.h>", discardable.}
    proc ii(): int {.inline.} = scanf("%lld\n", addr result)
    proc si(): string {.inline.} =
        result = ""
        var c: char
        while true:
            c = getchar()
            if c == ' ' or c == '\n':
                break
            result &= c
    proc lii(long: int): seq[int] = newSeqWith(long, ii())
    #chmin,chmax
    template `max=`(x, y) = x = max(x, y)
    template `min=`(x, y) = x = min(x, y)
    #bit演算
    proc `%`(x: int, y: int): int = (((x mod y)+y) mod y)
    proc `//`(x: int, y: int): int = (((x) - (x%y)) div (y))
    proc `%=`(x: var int, y: int): void = x = x%y
    proc `//=`(x: var int, y: int): void = x = x//y
    proc `**`(x: int, y: int): int = x^y
    proc `^`(x: int, y: int): int = x xor y
    proc `|`(x: int, y: int): int = x or y
    proc `&`(x: int, y: int): int = x and y
    proc `>>`(x: int, y: int): int = x shr y
    proc `<<`(x: int, y: int): int = x shl y
    proc `^=`(x: var int, y: int): void = x = x ^ y
    proc `&=`(x: var int, y: int): void = x = x & y
    proc `|=`(x: var int, y: int): void = x = x | y
    proc `>>=`(x: var int, y: int): void = x = x >> y
    proc `<<=`(x: var int, y: int): void = x = x << y
    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0
    proc `@`(x: int): seq[int] =
        for i in 0..<64:
            if x[i]:
                result.add(i)
    #便利な変換
    proc `!`(x: char, a = '0'): int = int(x)-int(a)
    #定数
    const INF = int(3300300300300300491)
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
    #powmod
    proc pow(a, n: int, m = INF): int =
        var rev: int = 1
        var a = a
        var n = n
        while n > 0:
            if n % 2 != 0:
                rev = (rev * a) mod m
            if n > 1:
                a = (a * a) mod m
            n >>= 1
        return rev

    #ここまでテンプレート v1.1.0
