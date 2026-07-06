# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/int128

let a = parseInt128("123456789012345678901234567890")
let b = parseInt128("10")
assert $a == "123456789012345678901234567890"
assert $(a + b) == "123456789012345678901234567900"
assert $((a + b) - a) == "10"
assert $(b * b) == "100"
assert $(parseInt128("100") div b) == "10"
assert $(parseInt128("103") mod b) == "3"
assert (parseInt128("5") & parseInt128("3")).to_int == 1
assert (parseInt128("5") | parseInt128("2")).to_int == 7
assert (parseInt128("5") ^ parseInt128("1")).to_int == 4
assert (parseInt128("1") << parseInt128("5")).to_int == 32
assert (parseInt128("32") >> parseInt128("2")).to_int == 8
assert -b < b
assert abs(-b) == b
assert cmp(b, parseInt128("10")) == 0
assert pow(parseInt128("2"), parseInt128("10")).to_int == 1024
assert pow(parseInt128("2"), parseInt128("10"), parseInt128("1000")).to_int == 24
