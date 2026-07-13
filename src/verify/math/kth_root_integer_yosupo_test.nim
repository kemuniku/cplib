# verification-helper: PROBLEM https://judge.yosupo.jp/problem/kth_root_integer
import cplib/math/kth_root_integer
import strutils

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}

var t: int
scanf("%d", addr t)
var answers = newSeq[string](t)
for i in 0..<t:
    var
        a: uint64
        k: int
    scanf("%llu %d", addr a, addr k)
    answers[i] = $kth_root_integer(a, k)
stdout.write(answers.join("\n"))
stdout.write("\n")
