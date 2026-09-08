# verification-helper: PROBLEM https://judge.yosupo.jp/problem/division_of_big_integers

include cplib/tmpl/fastio
import cplib/math/bigint

let queryCount = input(int)
for _ in 0 ..< queryCount:
    let a = initBigInt(input(string))
    let b = initBigInt(input(string))
    let (quotient, remainder) = divmod(a, b)
    print(quotient, remainder)
