# verification-helper: PROBLEM https://yukicoder.me/problems/no/8030
include cplib/tmpl/sheep
import cplib/math/isprime

var N = ii()
for i in 0..<N:
    let x = ii()
    if isprime(x):
        echo x, " ", 1
    else:
        echo x, " ", 0
