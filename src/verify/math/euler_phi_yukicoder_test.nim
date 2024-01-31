# verification-helper: PROBLEM https://yukicoder.me/problems/no/1339
import strutils
import cplib/math/euler_phi
import cplib/math/divisor
import cplib/math/powmod

var t = stdin.readLine.parseint
var ans = newSeq[int](0)
for _ in 0..<t:
    var n = stdin.readLine.parseint
    while n mod 2 == 0: n = n div 2
    while n mod 5 == 0: n = n div 5
    if n == 1:
        ans.add(1)
        continue
    for p in divisor(euler_phi(n)):
        if powmod(10, p, n) == 1:
            ans.add(p)
            break
echo ans.join("\n")
