discard """
    target = "cpp"
    cmd: "nim $target --path:../src $file"
"""
import unittest
import atcoder/modint
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
            check naive_npr(n, r, int(ModInt.umod())) == c.npr(n, r).val

check_npr[modint998244353]()
check_npr[modint1000000007]()
type modint104717 = modint
modint104717.setMod(104717)
check_npr[modint104717]()
