# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import hashes, sets, tables
import cplib/math/factoradic
import cplib/math/bigint

let zero = initFactoradic(0)
for value in [zero, -zero, abs(zero), initFactoradic(@[0, 0, 0], true)]:
    doAssert value == zero
    doAssert value.sgn == 0
    doAssert $value == "0"
    doAssert hash(value) == hash(zero)
    doAssert value.toInt(uint64) == 0

for a in -50..50:
    let x = initFactoradic(a)
    doAssert x.toInt() == a
    doAssert x.sgn == cmp(a, 0)
    doAssert abs(x) == abs(a)
    doAssert -x == -a
    doAssert +x == x
    doAssert initFactoradic(x.digits, x.sgn < 0) == x
    doAssert initFactoradic(x.toBigInt()) == x
    for b in -50..50:
        let y = initFactoradic(b)
        doAssert cmp(x, y) == cmp(a, b)
        doAssert cmp(x, b) == cmp(a, b)
        doAssert cmp(a, y) == cmp(a, b)
        doAssert (x == y) == (a == b)
        doAssert (x < y) == (a < b)
        doAssert (x >= y) == (a >= b)
        doAssert x + y == a + b
        doAssert x - y == a - b
        doAssert x * y == a * b
        doAssert x * b == a * b
        doAssert a * y == a * b
        var assigned = x
        assigned += y
        doAssert assigned == a + b
        assigned -= y
        doAssert assigned == x
        assigned *= y
        doAssert assigned == a * b
        if b == 0: continue
        var q = a div b
        var r = a mod b
        if r != 0 and (a < 0) != (b < 0):
            dec q
            r += b
        doAssert x // y == q
        doAssert x div y == a div b
        doAssert x % y == r
        doAssert x mod y == a mod b
        doAssert x // b == q
        doAssert x div b == a div b
        doAssert x % b == r
        doAssert x mod b == a mod b
        doAssert a // y == q
        doAssert a div y == a div b
        doAssert a % y == r
        doAssert a mod y == a mod b
        let division = divmod(x, y)
        doAssert division.quotient == q
        doAssert division.remainder == r
        doAssert divmod(x, b).quotient == q
        doAssert divmod(x, b).remainder == r
        doAssert divmod(a, y).quotient == q
        doAssert divmod(a, y).remainder == r
        assigned = x
        `div=`(assigned, y)
        doAssert assigned == a div b
        assigned = x
        `mod=`(assigned, y)
        doAssert assigned == a mod b
        assigned = x
        `div=`(assigned, b)
        doAssert assigned == a div b
        assigned = x
        `mod=`(assigned, b)
        doAssert assigned == a mod b
    var factorial = 1
    for k in 0..8:
        if k > 0: factorial *= k
        let expected = ((a mod factorial) + factorial) mod factorial
        doAssert x.modFactorial(k) == expected

proc checkSignedInteger[T: SomeSignedInt]() =
    for value in [low(T), low(T) + 1, T(-1), T(0), T(1), high(T)]:
        let x = initFactoradic(value)
        doAssert x.toInt(T) == value
        doAssert x.toBigInt() == initBigInt(value)
        doAssert initFactoradic(x.toBigInt()) == x
        doAssert cmp(x, value) == 0
    doAssertRaises(AssertionDefect):
        discard (initFactoradic(low(T)) - 1).toInt(T)
    doAssertRaises(AssertionDefect):
        discard (initFactoradic(high(T)) + 1).toInt(T)

checkSignedInteger[int8]()
checkSignedInteger[int16]()
checkSignedInteger[int32]()
checkSignedInteger[int64]()
checkSignedInteger[int]()
doAssert abs(initFactoradic(low(int))) == initFactoradic(high(int)) + 1
doAssertRaises(AssertionDefect): discard initFactoradic(-1).toInt(uint)
doAssertRaises(AssertionDefect): discard initFactoradic(-1).toInt(uint64)
doAssertRaises(AssertionDefect): discard initFactoradic(-1).toPermutation(5)
doAssertRaises(AssertionDefect): discard factorialFactoradic(-1)

for a in [low(int), low(int) + 1, -7, -1, 0, 1, 7, high(int)]:
    for b in [low(int), low(int) + 1, -7, -1, 1, 7, high(int)]:
        let x = initFactoradic(a)
        let y = initFactoradic(b)
        let expected = divmod(initBigInt(a), initBigInt(b))
        doAssert (x * b).toBigInt() == initBigInt(a) * initBigInt(b)
        doAssert (x // b).toBigInt() == expected.quotient
        doAssert (x div b).toBigInt() == initBigInt(a) div initBigInt(b)
        doAssert initBigInt(x % b) == expected.remainder
        doAssert initBigInt(x mod b) == initBigInt(a) mod initBigInt(b)
        doAssert (x // y).toBigInt() == expected.quotient
        doAssert (x div y).toBigInt() == initBigInt(a) div initBigInt(b)
        doAssert (x % y).toBigInt() == expected.remainder
        doAssert (x mod y).toBigInt() == initBigInt(a) mod initBigInt(b)
        doAssert (a // y).toBigInt() == expected.quotient
        doAssert (a div y).toBigInt() == initBigInt(a) div initBigInt(b)
        doAssert (a % y).toBigInt() == expected.remainder
        doAssert (a mod y).toBigInt() == initBigInt(a) mod initBigInt(b)

block:
    let large = factorialFactoradic(2048) + 123
    let divisor = factorialFactoradic(1024) + 7
    for a in [large, -large, divisor, -divisor, zero]:
        for b in [divisor, -divisor, large, -large]:
            let division = divmod(a, b)
            doAssert division.quotient * b + division.remainder == a
            doAssert abs(division.remainder) < abs(b)
            doAssert division.remainder == 0 or division.remainder.sgn == b.sgn
            doAssert a // b == division.quotient
            doAssert a % b == division.remainder
            let truncQ = a.toBigInt() div b.toBigInt()
            let truncR = a.toBigInt() mod b.toBigInt()
            doAssert (a div b).toBigInt() == truncQ
            doAssert (a mod b).toBigInt() == truncR
            var assigned = a
            `div=`(assigned, b)
            doAssert assigned.toBigInt() == truncQ
            assigned = a
            `mod=`(assigned, b)
            doAssert assigned.toBigInt() == truncR
            doAssert initFactoradic(a.toBigInt()) == a
            doAssert (a * b).toBigInt() == a.toBigInt() * b.toBigInt()
    doAssert (-large).modFactorial(2048) == factorialFactoradic(2048) - 123
    doAssert (-factorialFactoradic(2048)).modFactorial(2048) == zero
    for value in [1, 7, high(int), low(int)]:
        let division = divmod(-large, value)
        doAssert division.quotient * value + division.remainder == -large
        doAssert division.remainder == (-large) % value

block:
    let value = factorialFactoradic(100_000) - 1
    doAssert ((-value) * low(int)) div low(int) == -value
    doAssert ((-value) * initFactoradic(low(int))) div initFactoradic(low(int)) == -value
    doAssert -1 // value == -1
    doAssert -1 % value == value - 1
    doAssert 1 // (-value) == -1
    doAssert 1 % (-value) == 1 - value
    doAssert -1 div value == 0
    doAssert -1 mod value == -1
    doAssert 1 div (-value) == 0
    doAssert 1 mod (-value) == 1
    doAssert (-value) mod value == 0
    var copied = -value
    var absolute = abs(copied)
    absolute += 1
    doAssert copied == -value
    copied += value
    doAssert copied == zero
    doAssert hash(copied) == hash(zero)

block:
    var seen = initHashSet[Factoradic]()
    var mapping = initTable[Factoradic, int]()
    for a in -100..100:
        let x = initFactoradic(a)
        seen.incl(x)
        mapping[x] = a
        let copy = initFactoradic(x.digits & @[0, 0], a < 0)
        doAssert hash(x) == hash(copy)
        doAssert copy in seen
        doAssert mapping[copy] == a
    doAssert seen.len == 201

for value in [-factorialFactoradic(100), initFactoradic(-1), zero]:
    doAssertRaises(DivByZeroDefect): discard value div 0
    doAssertRaises(DivByZeroDefect): discard value mod 0
    doAssertRaises(DivByZeroDefect): discard divmod(value, zero)
    doAssertRaises(DivByZeroDefect): discard value div zero
    doAssertRaises(DivByZeroDefect): discard value mod zero
    doAssertRaises(DivByZeroDefect): discard value // 0
    doAssertRaises(DivByZeroDefect): discard value % 0
    doAssertRaises(DivByZeroDefect): discard value // zero
    doAssertRaises(DivByZeroDefect): discard value % zero
    doAssertRaises(DivByZeroDefect): discard 1 // zero
    doAssertRaises(DivByZeroDefect): discard 1 % zero

echo "Hello World"
