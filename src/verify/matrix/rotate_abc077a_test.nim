# verification-helper: PROBLEM https://atcoder.jp/contests/abc077/tasks/abc077_a
import cplib/matrix/matops
var s = @[stdin.readLine, stdin.readLine]
var t = s
t.rotate(2)
if s == t: echo "YES" else: echo "NO"
