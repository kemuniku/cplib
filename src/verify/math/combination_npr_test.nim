# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"
import cplib/modint/modint
import cplib/math/combination

proc naive_npr(n, r, m: int): int =
    result = 1
    for i in n-r+1..n:
        result *= i
        result = result mod m

proc check_npr[ModInt]() =
    var c = initCombination[ModInt](20)
    for n in 0..20:
        for r in 0..n:
            doAssert naive_npr(n, r, int(ModInt.umod())) == c.npr(n, r).val

check_npr[modint998244353_barrett]()
check_npr[modint1000000007_barrett]()
type modint104717 = modint_barrett
modint104717.setMod(104717)
check_npr[modint104717]()
