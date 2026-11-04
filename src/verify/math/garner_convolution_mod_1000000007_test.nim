# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod_1000000007

import sequtils, strutils
import cplib/convolution/convolution
import cplib/math/garner

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

const
    targetMod = 1_000_000_007
    moduli = [754_974_721, 167_772_161, 469_762_049]

let n = ii()
let m = ii()
let a = newSeqWith(n, ii())
let b = newSeqWith(m, ii())
let c0 = convolution[moduli[0]](a, b)
let c1 = convolution[moduli[1]](a, b)
let c2 = convolution[moduli[2]](a, b)
var answer = newSeq[int](n + m - 1)
for i in 0..<answer.len:
    answer[i] = garner([c0[i], c1[i], c2[i]], moduli, targetMod)
echo answer.join(" ")
