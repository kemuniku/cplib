# verification-helper: PROBLEM https://atcoder.jp/contests/abc233/tasks/abc233_d
import sequtils, strutils
import cplib/utils/count_subarrays_with_sum

let nk = stdin.readLine.splitWhitespace.map(parseBiggestInt)
let a = stdin.readLine.splitWhitespace.map(parseBiggestInt)
echo count_subarrays_with_sum(a, nk[1])
