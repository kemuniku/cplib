# verification-helper: PROBLEM https://atcoder.jp/contests/abc324/tasks/abc324_b
include cplib/math/primefactor
import strutils

var n = stdin.readLine.parseInt
for (k, v) in primefactor_tuple(n):
    if k != 2 and k != 3:
        echo "No"
        quit()
echo "Yes"

