# verification-helper: PROBLEM https://atcoder.jp/contests/agc023/tasks/agc023_a
import sequtils, strutils
import cplib/utils/count_subarrays_with_sum

discard stdin.readLine
let a = stdin.readLine.splitWhitespace.map(parseBiggestInt)
echo count_subarrays_with_sum(a, 0'i64)
