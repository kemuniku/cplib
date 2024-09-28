# verification-helper: PROBLEM https://atcoder.jp/contests/abc236/tasks/abc236_c
import cplib/collections/avlset
import strutils
discard stdin.readLine
var S = stdin.readLine.split()
var T = stdin.readLine.split()
var st = initAvlSortedset(T)
for s in S:
    if s in st:
        echo "Yes"
    else:
        echo "No"
