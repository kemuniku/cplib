# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_3_C

import strutils
import cplib/utils/largest_rectangle

let tokens = stdin.readAll.splitWhitespace
let n = tokens[0].parseInt
var heights = newSeq[int64](n)
for i in 0..<n:
    heights[i] = int64(tokens[i + 1].parseBiggestInt)
echo largest_rectangle(heights)
