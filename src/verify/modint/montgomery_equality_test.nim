# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import hashes, sets, tables
import cplib/modint/modint

proc checkEquality[T: MontgomeryModint]() =
    let modulus = int(T.umod)
    let zero = init(T, 0)
    var alternateZero = init(T, 1)
    alternateZero += init(T, modulus - 1)
    assert alternateZero == zero
    assert not (alternateZero != zero)
    assert hash(alternateZero) == hash(zero)
    var values = initHashSet[T]()
    var counts = initTable[T, int]()
    for i in 0..<min(modulus, 30):
        let canonical = init(T, i)
        var other = canonical
        other += alternateZero
        for value in [canonical, other, -(-other)]:
            assert value == canonical
            assert hash(value) == hash(canonical)
            values.incl(value)
            counts[value] = counts.getOrDefault(value) + 1
        assert counts[canonical] == 3
        for j in 0..<min(modulus, 30):
            assert (other == init(T, j)) == (i == j)
    assert values.len == min(modulus, 30)

checkEquality[StaticMontgomeryModint[17u32]]()
checkEquality[StaticMontgomeryModint[998244353u32]]()
checkEquality[StaticMontgomeryModint[1u32]]()
type Dynamic = DynamicMontgomeryModint[39001u32]
for modulus in [17, 19, 998244353, 1]:
    Dynamic.setMod(modulus)
    checkEquality[Dynamic]()
let a: modint998244353_montgomery = 1
let z = a + 998244352
assert z == 0
assert 0 == z
assert z != 1
