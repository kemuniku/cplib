# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/modint/barrett_impl

type Mint = StaticBarrettModint[17u32]
assert Mint.umod == 17u32
assert Mint.mod == 17
assert Mint.get_M == 17u
assert Mint.get_param[0] == 17u32
assert get_im(17u32) > 0

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

type DMint = DynamicBarrettModint[101u32]
type DMint2 = DynamicBarrettModint[102u32]
DMint.setMod(19)
DMint2.setMod(23)
assert DMint.umod == 19u32
assert DMint2.umod == 23u32
var b = init(DMint, -2)
assert b.val == 17
b += 5
assert b.val == 3
var c = init(DMint2, -2)
assert c.val == 21
c += 5
assert c.val == 3
