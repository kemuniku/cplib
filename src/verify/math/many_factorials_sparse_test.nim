# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/math/many_factorials
import cplib/modint/modint
proc check[M: BarrettModint or MontgomeryModint]() =
    let p = M.umod.int
    var facts = newSeq[M](100001)
    facts[0] = init(M, 1)
    for i in 1..<facts.len: facts[i] = facts[i-1] * i
    var rng = initRand(226)
    for count in [1, 5, 8, 16, 32, 64, 65, 128]:
        var ns = newSeq[int](count)
        var expected = newSeq[M](count)
        for i in 0..<count:
            let k = rng.rand(0..100000)
            if (i and 1) == 0:
                ns[i] = k
                expected[i] = facts[k]
            else:
                ns[i] = p-1-k
                expected[i] = facts[k].inv
                if (k and 1) == 0: expected[i] = -expected[i]
        let actual = many_factorials.manyFactorials[M](ns)
        for i in 0..<count: doAssert actual[i].val == expected[i].val
check[modint998244353_barrett]()
check[modint998244353_montgomery]()
check[modint1000000007_barrett]()
check[modint1000000007_montgomery]()
echo "Hello World"
