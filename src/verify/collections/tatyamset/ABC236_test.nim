# verification-helper: PROBLEM https://atcoder.jp/contests/abc236/tasks/abc236_c
import cplib/collections/tatyamset
import sequtils, strutils
discard stdin.readLine
var S = stdin.readLine.split()
var T = stdin.readLine.split()
var st = initSortedMultiset(T)
for s in S:
    if s in st:
        echo "Yes"
    else:
        echo "No"
