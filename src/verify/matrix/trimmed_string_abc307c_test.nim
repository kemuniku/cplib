# verification-helper: PROBLEM https://atcoder.jp/contests/abc307/tasks/abc307_c
import cplib/matrix/matops
var s = @[stdin.readLine, stdin.readLine]
var t = s
t.rotate(2)
if s == t: echo "YES" else: echo "NO"
