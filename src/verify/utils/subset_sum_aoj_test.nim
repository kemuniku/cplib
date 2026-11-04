# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_5_A

import strutils
import cplib/utils/subset_sum

let tokens = stdin.readAll().splitWhitespace()
var pos = 0
proc readInt(): int =
    result = parseInt(tokens[pos])
    inc pos

let n = readInt()
var a = newSeq[int](n)
for value in a.mitems:
    value = readInt()
let q = readInt()
for i in 0..<q:
    echo (if solve_subset_sum(a, readInt()): "yes" else: "no")
