# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/eratosthenes
import cplib/math/isprime
import random, sequtils

const Limit = 3_000_000
var reference = newSeq[bool](Limit + 1)
for i in 2..Limit:
    reference[i] = true
for p in 2..Limit:
    if p > Limit div p:
        break
    if reference[p]:
        for j in countup(p * p, Limit, p):
            reference[j] = false

proc checkRange(low, high: int) =
    let sieve = initSegmentedEratosthenes(low, high)
    var expected: seq[int]
    for n in low..high:
        doAssert sieve.is_prime(n) == reference[n]
        if reference[n]:
            expected.add(n)
    doAssert toSeq(sieve.items()) == expected
    doAssert get_primes(low, high + 1) == expected
    doAssert sieve.count_primes() == expected.len
    doAssert sieve.byte_size() == high div 30 - low div 30 + 1
    doAssert not sieve.is_prime(low - 1)
    doAssert not sieve.is_prime(high + 1)

let full = initEratosthenes(Limit)
var count = 0
for n in 0..Limit:
    doAssert full.is_prime(n) == reference[n]
    if reference[n]:
        inc count
let listed = toSeq(full.items())
doAssert get_primes(Limit) == listed
for n in [-10, -1, 0, 1]:
    doAssert get_primes(n) == newSeq[int]()
doAssert get_primes(2) == @[2]
doAssert get_primes(2, 3) == @[2]
doAssert get_primes(7, 19) == @[7, 11, 13, 17]
doAssert get_primes(-10, 8) == @[2, 3, 5, 7]
for bounds in [(7, 7), (8, 7), (-10, 2), (low(int), low(int)), (high(int), high(int))]:
    doAssert get_primes(bounds[0], bounds[1]) == newSeq[int]()
doAssert get_primes(29) == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
doAssert get_primes(30) == get_primes(29)
doAssert get_primes(31) == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31]
doAssert listed.len == count
doAssert full.count_primes() == count
for i, p in listed:
    doAssert reference[p]
    if i > 0:
        doAssert listed[i - 1] < p
doAssert not full.is_prime(-1)
doAssert not full.is_prime(Limit + 1)

for low in 0..150:
    for width in 0..60:
        checkRange(low, low + width)
for limit in 0..100:
    let sieve = initEratosthenes(limit)
    for n in 0..limit:
        doAssert sieve.is_prime(n) == reference[n]
for boundary in [32_768 * 30, 2 * 32_768 * 30, 47 * 47, 53 * 53, 997 * 997]:
    checkRange(boundary - 61, boundary + 61)
checkRange(12345, 2_345_678)
var rng = initRand(20260913)
for _ in 0..<100:
    let low = rng.rand(0..Limit - 20_000)
    checkRange(low, low + rng.rand(0..20_000))

when sizeof(int) >= 8:
    for low in [int(999_999_999_900), int(1_000_006_000_000)]:
        let sieve = initSegmentedEratosthenes(low, low + 2000)
        var expected: seq[int]
        for n in low..low + 2000:
            let prime = isprime(n)
            doAssert sieve.is_prime(n) == prime
            if prime:
                expected.add(n)
        doAssert toSeq(sieve.items()) == expected
        doAssert get_primes(low, low + 2001) == expected
        doAssert sieve.count_primes() == expected.len

echo "Hello World"
