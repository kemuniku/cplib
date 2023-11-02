# verify-helper: PROBLEM https://yukicoder.me/problems/no/9003
# verify-helper: ERROR 1e-4
import strscans, strformat

var a: float
discard stdin.readLine.scanf("$f", a)
echo "decimal"
echo &"{a:6f}"
