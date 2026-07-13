# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/eratosthenes

for n in 0..6:
    let sieve = initEratosthenes(n)
    assert sieve.primeList == (if n < 2: @[] else: @[2, 3, 5][0..<(if n < 3: 1 elif n < 5: 2 else: 3)])

let sieve = initEratosthenes(1_000_000)
assert sieve.primeList[0..9] == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
assert sieve.countPrimes == 78_498
assert sieve[999_983]
assert not sieve[999_981]
assert not sieve[-1]
assert not sieve[1_000_001]

let segmented = initSegmentedEratosthenes(999_900, 1_000_100)
assert segmented.primeList == @[
    999_907, 999_917, 999_931, 999_953, 999_959, 999_961,
    999_979, 999_983, 1_000_003, 1_000_033, 1_000_037,
    1_000_039, 1_000_081, 1_000_099
]
assert segmented.countPrimes == 14
assert segmented[999_983]
assert not segmented[1_000_000]

for left in 0..100:
    for right in left..100:
        let small = initSegmentedEratosthenes(left, right)
        var expected: seq[int]
        for p in sieve.primes:
            if left <= p and p <= right:
                expected.add(p)
        assert small.primeList == expected
