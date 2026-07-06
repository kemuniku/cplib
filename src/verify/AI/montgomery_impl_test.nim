# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/modint/montgomery_impl

type Mint = StaticMontgomeryModint[17u32]
assert Mint.umod == 17u32
assert Mint.mod == 17
assert Mint.get_M == 17u32
assert Mint.get_param[0] == 17u32
assert get_r(17u32) * 17u32 == 1u32
assert get_n2(17u32) < 17u32

var a = init(Mint, 20)
assert a.val == 3
a += 20
assert a.val == 6
a -= 10
assert a.val == 13
a *= 4
assert a.val == 1
a /= 1
assert a.val == 1
assert inv(init(Mint, 5)).val == 7
assert (-init(Mint, 3)).val == 14

type DMint = DynamicMontgomeryModint[101u32]
DMint.setMod(19)
assert DMint.umod == 19u32
var b = init(DMint, -2)
assert b.val == 17
b += 5
assert b.val == 3
