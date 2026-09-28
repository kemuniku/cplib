# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/multiplicative_prefix_sum
import cplib/modint/modint

type Mint = modint1000000007_barrett
for root in [65, 100, 257, 1000]:
    for n in [root * root - 1, root * root, root * root + 1,
              root * (root + 1) - 1, root * (root + 1), root * (root + 1) + 1]:
        let x = init(Mint, n)
        let constant = multiplicativePrefixSum(n, @[init(Mint, 1)],
            proc(p, e: int): Mint = init(Mint, 1))
        doAssert constant == x
        let square = multiplicativePrefixSum(n, @[init(Mint, 0), init(Mint, 0), init(Mint, 1)],
            proc(p, e: int): Mint = init(Mint, p).pow(2 * e))
        doAssert square == x * (x + 1) * (2 * x + 1) / 6

echo "Hello World"
