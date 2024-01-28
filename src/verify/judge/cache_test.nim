# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/lesson/1/ALDS1/1/ALDS1_1_B
import strscans, std/math

var x, y: int
discard stdin.readLine.scanf("$i $i", x, y)
discard x
echo gcd(x, y)
