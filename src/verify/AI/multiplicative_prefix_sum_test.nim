# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/modint/modint
import cplib/math/multiplicative_prefix_sum

proc naive[T](limit: int, coefficients: seq[T], primePower: proc(p, e: int): T {.closure.}): seq[T] =
    result = newSeq[T](limit + 1)
    for n in 1..limit:
        var rest = n
        var value = init(T, 1)
        var p = 2
        while p <= rest div p:
            if rest mod p == 0:
                var exponent = 0
                while rest mod p == 0:
                    rest = rest div p
                    inc exponent
                if exponent == 1:
                    var primeValue = init(T, 0)
                    for i in countdown(coefficients.len - 1, 0):
                        primeValue = primeValue * p + coefficients[i]
                    value *= primeValue
                else:
                    value *= primePower(p, exponent)
            inc p
        if rest > 1:
            var primeValue = init(T, 0)
            for i in countdown(coefficients.len - 1, 0):
                primeValue = primeValue * rest + coefficients[i]
            value *= primeValue
        result[n] = result[n - 1] + value

proc check[T](coefficients: seq[T], primePower: proc(p, e: int): T {.closure.}, thorough: bool) =
    const limit = 20000
    let expected = naive(limit, coefficients, primePower)
    var queries = @[0, 1, 2, 3, 4, 8, 27, 64, 121, 256, 1024, 4095, 4096,
                    4097, 4098, 4099, 4224, 4225, 4226, 6560, 6561, 6562,
                    8191, 8192, 8193, 9408, 9409, 9410, 16383, 16384, 16385, limit]
    if thorough:
        for n in 0..80:
            queries.add(n)
        var rng = initRand(380719)
        for _ in 0..<20:
            queries.add(rng.rand(4097..limit))
    for query in queries:
        let n = query
        let callback = proc(p, e: int): T =
            doAssert e >= 2
            var power = 1
            for _ in 0..<e:
                doAssert power <= n div p
                power *= p
            primePower(p, e)
        let actual = multiplicativePrefixSum(n, coefficients, callback)
        doAssert actual == expected[n], "n=" & $n & " actual=" & $actual & " expected=" & $expected[n]

proc standard[T](thorough: bool) =
    check(@[init(T, -1), init(T, 1)], proc(p, e: int): T =
        init(T, p).pow(e - 1) * (p - 1), thorough)
    check(@[init(T, 2)], proc(p, e: int): T = init(T, e + 1), thorough)
    check(@[init(T, 1), init(T, 1)], proc(p, e: int): T =
        var value = init(T, 1)
        for _ in 0..<e:
            value = value * p + 1
        value, thorough)
    check(@[init(T, -1)], proc(p, e: int): T = init(T, 0), thorough)
    check(@[init(T, 1)], proc(p, e: int): T = init(T, 0), thorough)
    check(@[init(T, 0), init(T, 0), init(T, 1)], proc(p, e: int): T =
        init(T, p).pow(2 * e), thorough)
    check(newSeq[T](), proc(p, e: int): T = init(T, e * e + p), thorough)
    check(@[init(T, 2), init(T, -3), init(T, 4), init(T, 0), init(T, -2), init(T, 1)], proc(p, e: int): T =
        init(T, p).pow(e) + e * e - 7, thorough)

standard[modint998244353_montgomery](true)
standard[modint1000000007_barrett](false)

type Dynamic = modint_barrett
for modulus in [998244353, 1_000_000_007]:
    Dynamic.setMod(modulus)
    check(@[init(Dynamic, -1), init(Dynamic, 1), init(Dynamic, 0)], proc(p, e: int): Dynamic =
        init(Dynamic, p).pow(e - 1) * (p - 1), false)

type Mint = modint998244353_montgomery
let n = 1_000_000
let constant = multiplicativePrefixSum(n, @[init(Mint, 1)], proc(p, e: int): Mint = init(Mint, 1))
doAssert constant == init(Mint, n)
let identity = multiplicativePrefixSum(n, @[init(Mint, 0), init(Mint, 1)],
    proc(p, e: int): Mint = init(Mint, p).pow(e))
doAssert identity == init(Mint, n) * (n + 1) / 2
let totient = multiplicativePrefixSum(n, @[init(Mint, -1), init(Mint, 1)],
    proc(p, e: int): Mint = init(Mint, p).pow(e - 1) * (p - 1))
var phi = newSeq[int](n + 1)
for i in 0..n:
    phi[i] = i
for p in 2..n:
    if phi[p] == p:
        for k in countup(p, n, p):
            phi[k] -= phi[k] div p
var expected = init(Mint, 0)
for i in 1..n:
    expected += phi[i]
doAssert totient == expected

echo "Hello World"
