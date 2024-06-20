# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb_128bit
include cplib/math/int128
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var t = ii()
for i in 0..<t:
    var a = read_and_parse_int128()
    var b = read_and_parse_int128()
    put(a + b)
