# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/combination
import cplib/modint/modint
import atcoder/modint as acl

proc check[M](modulus, limit: int) =
    let c = initCombination[M](limit)
    doAssert c.fact.len == limit + 1
    doAssert c.inv.len == limit + 1
    doAssert c.fact_inv.len == limit + 1
    var expected = 1
    for i in 0..limit:
        if i > 0: expected = expected * i mod modulus
        doAssert c.fact[i].val.int == expected
        if i > 0 and i < modulus:
            doAssert (c.inv[i] * i).val == 1
        if i < modulus:
            doAssert (c.fact[i] * c.fact_inv[i]).val == 1
        else:
            doAssert c.fact[i].val == 0
            doAssert c.inv[i].val == 0
            doAssert c.fact_inv[i].val == 0
    var row = @[1]
    for n in 0..min(limit, modulus - 1):
        for k in 0..n:
            doAssert c.ncr(n, k).val.int == row[k]
            doAssert (c.ncr(n, k) * c.ncr_inv(n, k)).val == 1
        var next = newSeq[int](row.len + 1)
        next[0] = 1
        next[^1] = 1
        for k in 1..<row.len: next[k] = (row[k-1] + row[k]) mod modulus
        row = next

for modulus in [2, 3, 5, 101, 998244353]:
    modint_barrett.setMod(modulus)
    acl.modint.setMod(modulus)
    for limit in [0, 1, 5, 100, 101, 110]:
        check[modint_barrett](modulus, limit)
        check[acl.modint](modulus, limit)
for modulus in [3, 5, 101, 998244353]:
    modint_montgomery.setMod(modulus)
    for limit in [0, 1, 5, 100, 101, 110]:
        check[modint_montgomery](modulus, limit)
check[modint998244353_barrett](998244353, 110)
check[modint998244353_montgomery](998244353, 110)
check[acl.modint998244353](998244353, 110)
echo "Hello World"

for modulus in [8, 25]:
    acl.modint.setMod(modulus)
    for limit in [0, 1, 5, 100, 110]:
        let c = initCombination[acl.modint](limit)
        var fact = newSeq[int](limit + 1)
        var invs = newSeq[int](limit + 1)
        var factInv = newSeq[int](limit + 1)
        fact[0] = 1
        factInv[0] = 1
        if limit >= 1:
            fact[1] = 1
            invs[1] = 1
            factInv[1] = 1
        for i in 2..limit:
            fact[i] = fact[i-1] * i mod modulus
            invs[i] = (modulus - invs[modulus mod i] * (modulus div i) mod modulus) mod modulus
            factInv[i] = factInv[i-1] * invs[i] mod modulus
        for i in 0..limit:
            doAssert c.fact[i].val.int == fact[i]
            doAssert c.inv[i].val.int == invs[i]
            doAssert c.fact_inv[i].val.int == factInv[i]
