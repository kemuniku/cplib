# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb_128bit
import cplib/math/int128
import strutils
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

var t = ii()
var ans = newSeq[Int128](t)
for i in 0..<t:
    var a, b = si().parseInt128
    ans[i] = a + b
echo ans.join("\n")
