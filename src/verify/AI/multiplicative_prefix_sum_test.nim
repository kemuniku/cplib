# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/multiplicative_prefix_sum

const N = 10000
var isPrime = newSeq[bool](N + 1)
for i in 2..N:
    isPrime[i] = true
for i in 2..N:
    if isPrime[i] and i <= N div i:
        for j in countup(i * i, N, i):
            isPrime[j] = false

var primeCount = newSeq[int64](N + 1)
var primeSum = newSeq[int64](N + 1)
for i in 1..N:
    primeCount[i] = primeCount[i - 1]
    primeSum[i] = primeSum[i - 1]
    if isPrime[i]:
        inc primeCount[i]
        primeSum[i] += i

proc divisorCountNaive(n: int): int64 =
    for d in 1..n:
        if n mod d == 0:
            inc result

proc phiNaive(n: int): int64 =
    result = n
    var x = n
    var p = 2
    while p <= x div p:
        if x mod p == 0:
            result = result div p * (p - 1)
            while x mod p == 0:
                x = x div p
        inc p
    if x > 1:
        result = result div x * (x - 1)

for n in @[0, 1, 2, 10, 97, 100, 999, N]:
    let divisorSum = multiplicativePrefixSum[int64](n,
        proc(x: int): int64 = 2 * primeCount[x],
        proc(p, exponent: int): int64 = exponent.int64 + 1)
    var expectedDivisorSum = 0'i64
    for x in 1..n:
        expectedDivisorSum += divisorCountNaive(x)
    assert divisorSum == expectedDivisorSum, $n & ": " & $divisorSum & " != " & $expectedDivisorSum

    let phiSum = multiplicativePrefixSum[int64](n,
        proc(x: int): int64 = primeSum[x] - primeCount[x],
        proc(p, exponent: int): int64 =
            var power = 1'i64
            for unused in 1..<exponent:
                power *= p
            power * (p - 1))
    var expectedPhiSum = 0'i64
    for x in 1..n:
        expectedPhiSum += phiNaive(x)
    assert phiSum == expectedPhiSum
