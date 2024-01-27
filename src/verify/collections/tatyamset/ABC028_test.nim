# verification-helper: PROBLEM https://atcoder.jp/contests/abc028/tasks/abc028_b
import cplib/collections/tatyamset
import strutils,sequtils
var S = initSortedMultiset(stdin.readLine().toseq())
echo @[S.count('A'),S.count('B'),S.count('C'),S.count('D'),S.count('E'),S.count('F')].join(" ")