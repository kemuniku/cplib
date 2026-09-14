# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/math/isprime

assert not isprime(1)
assert isprime(2)
assert isprime(97)
assert not isprime(91)
assert isprime(1_000_000_007)
assert not isprime(low(int))
assert not isprime(-1)
assert not isprime(0)
for n in [3, 5, 13, 19, 73, 193, 407521, 299210837]:
    assert isprime(n)
when sizeof(int) == 8:
    assert isprime(2_305_843_009_213_693_951.int)
    assert isprime(9_223_372_036_854_775_783.int)
    assert not isprime(high(int))
    assert not isprime(341_550_071_728_321.int)
    assert not isprime(3_825_123_056_546_413_051.int)
    assert not isprime(1_000_000_014_000_000_049.int)

proc testIntegerType[T: SomeInteger]() =
    assert not isprime(T(0))
    assert not isprime(T(1))
    assert isprime(T(2))
    assert isprime(T(97))
    assert not isprime(T(91))

testIntegerType[int]()
testIntegerType[int8]()
testIntegerType[int16]()
testIntegerType[int32]()
testIntegerType[int64]()
testIntegerType[uint]()
testIntegerType[uint8]()
testIntegerType[uint16]()
testIntegerType[uint32]()
testIntegerType[uint64]()

assert isprime(18_446_744_073_709_551_557u64)
assert not isprime(high(uint64))
assert not isprime(9_223_372_036_854_775_808u64)
assert not isprime(18_446_744_030_759_878_681u64)
when sizeof(uint) == 8:
    assert isprime(18_446_744_073_709_551_557u64.uint)
    assert not isprime(high(uint))

var composite: array[10001, bool]
for n in 2..10000:
    if not composite[n]:
        for multiple in countup(n * 2, 10000, n):
            composite[multiple] = true
    assert isprime(n.uint) == not composite[n]
