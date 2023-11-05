# verification-helper: PROBLEM https://judge.yosupo.jp/problem/primality_test
include cplib/tmpl/sheep
import cplib/math/isprime

var Q = ii()

for i in 0..<Q:
    var N = ii()
    if isprime(N):
        echo "Yes"
    else:
        echo "No"