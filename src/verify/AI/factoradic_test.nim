# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils, hashes, sets, tables
import cplib/math/factoradic
import cplib/math/bigint

template expectAssertion(body: untyped) =
    block:
        var caught = false
        try:
            body
        except AssertionDefect:
            caught = true
        doAssert caught

template expectZeroDivision(body: untyped) =
    block:
        var caught = false
        try:
            body
        except DivByZeroDefect:
            caught = true
        doAssert caught

let zero = initFactoradic(0)
doAssert default(Factoradic) == zero
doAssert initFactoradic(newSeq[int]()) == zero
doAssert initFactoradic(@[0, 0, 0]) == zero
doAssert zero.digits == newSeq[int]()
doAssert zero.toInt() == 0
doAssert zero.toBigInt() == initBigInt(0)
doAssert default(Factoradic).toBigInt() == initBigInt(0)
doAssert initFactoradic(4).toBigInt() is BigInt
doAssert $zero == "0"
doAssert $default(Factoradic) == "0"
doAssert $initFactoradic(@[0, 0, 0]) == "0"
doAssert $permutationRank(@[2, 0, 1]) == "4"
doAssert zero.toPermutation(0) == newSeq[int]()
doAssert zero.toPermutation(1) == @[0]
doAssert initFactoradic(@[0, 0, 2]).toInt() == 4
doAssert permutationRank(@[2, 0, 1]).digits == @[0, 0, 2]
doAssert initFactoradic(4).toPermutation(3) == @[2, 0, 1]
doAssert initFactoradic(4).toInt() is int
doAssert initFactoradic(4).toInt(int64) is int64

block:
    var expected = 1'i64
    for n in 0..20:
        if n > 0: expected *= int64(n)
        doAssert factorialFactoradic(n).toInt(int64) == expected
    doAssert factorialFactoradic(0) == factorialFactoradic(1)
    doAssert factorialFactoradic(5).toInt() == 120
    expectAssertion: discard factorialFactoradic(-1)

block:
    var modulus = 1
    for k in 0..8:
        if k > 0: modulus *= k
        for value in 0..1000:
            let x = initFactoradic(value)
            let remainder = x.modFactorial(k)
            doAssert remainder == initFactoradic(value mod modulus)
            doAssert x.toInt() == value
    doAssert zero.modFactorial(0) == zero
    doAssert default(Factoradic).modFactorial(10) == zero
    doAssert initFactoradic(123).modFactorial(high(int)) == initFactoradic(123)
    expectAssertion: discard zero.modFactorial(-1)

block:
    doAssert (initFactoradic(100) mod 7) is int
    for value in 0..1000:
        let x = initFactoradic(value)
        for modulus in 1..100:
            doAssert x mod modulus == value mod modulus
    for modulus in [1, 2, 7, 1_000_000_007, high(int) - 1, high(int)]:
        doAssert zero mod modulus == 0
        doAssert default(Factoradic) mod modulus == 0
        for value in [0, 1, high(int) div 2, high(int) - 1, high(int)]:
            doAssert initFactoradic(value) mod modulus == value mod modulus
        var factorial = initBigInt(1)
        for n in 0..100:
            if n > 0: factorial *= initBigInt(n)
            let x = factorialFactoradic(n)
            for offset in [0, 1, 123, high(int)]:
                let expected = (factorial + initBigInt(offset)) mod initBigInt(modulus)
                doAssert system.`$`((x + offset) mod modulus) == $expected
    expectZeroDivision: discard zero mod 0
    doAssert zero mod -1 == 0

proc checkMixedComparison[T: SomeInteger](a: Factoradic, b: T, expected: int) =
    doAssert cmp(a, b) == expected
    doAssert cmp(b, a) == -expected
    doAssert (a < b) == (expected < 0)
    doAssert (a <= b) == (expected <= 0)
    doAssert (a > b) == (expected > 0)
    doAssert (a >= b) == (expected >= 0)
    doAssert (a == b) == (expected == 0)
    doAssert (a != b) == (expected != 0)
    doAssert (b < a) == (expected > 0)
    doAssert (b <= a) == (expected >= 0)
    doAssert (b > a) == (expected < 0)
    doAssert (b >= a) == (expected <= 0)
    doAssert (b == a) == (expected == 0)
    doAssert (b != a) == (expected != 0)

for a in 0..100:
    for b in -100..100:
        checkMixedComparison(initFactoradic(a), b, cmp(a, b))

block:
    var seen = initHashSet[Factoradic]()
    var values = initTable[Factoradic, int]()
    for value in 0..100:
        let a = initFactoradic(value)
        let b = initFactoradic(a.digits & @[0, 0])
        doAssert hash(a) == hash(b)
        seen.incl(a)
        seen.incl(b)
        values[a] = value
        doAssert b in seen
        doAssert values[b] == value
    doAssert seen.len == 101
    doAssert hash(default(Factoradic)) == hash(zero)
    let large = factorialFactoradic(100)
    seen.incl(large)
    values[large] = 123
    doAssert large + 1 - 1 in seen
    doAssert values[large + 1 - 1] == 123
    doAssert large + 1 notin seen

proc checkInteger[T: SomeInteger]() =
    for value in [T(0), T(1), high(T) div 2, high(T) - 1, high(T)]:
        doAssert initFactoradic(value).toInt(T) == value
        doAssert initFactoradic(value).toBigInt() == initBigInt(value)
        doAssert $initFactoradic(value) == system.`$`(value)
        checkMixedComparison(initFactoradic(value), value, 0)
        checkMixedComparison(initFactoradic(value) + 1, value, 1)
        if value > 0:
            checkMixedComparison(initFactoradic(value) - 1, value, -1)
    checkMixedComparison(factorialFactoradic(100), high(T), 1)
    when T is SomeSignedInt:
        checkMixedComparison(zero, low(T), 1)
    expectAssertion:
        discard (initFactoradic(high(T)) + initFactoradic(1)).toInt(T)

checkInteger[int]()
checkInteger[int8]()
checkInteger[int16]()
checkInteger[int32]()
checkInteger[int64]()
checkInteger[uint]()
checkInteger[uint8]()
checkInteger[uint16]()
checkInteger[uint32]()
checkInteger[uint64]()

proc checkIntegerArithmetic[T: SomeInteger]() =
    let maximum = initFactoradic(high(T))
    doAssert zero + high(T) == maximum
    doAssert high(T) + zero == maximum
    doAssert maximum - high(T) == zero
    doAssert high(T) - maximum == zero
    let doubled = maximum + high(T)
    doAssert doubled - high(T) == maximum
    var value = maximum
    value += high(T)
    doAssert value == doubled
    value -= high(T)
    doAssert value == maximum
    when T is SomeSignedInt:
        let magnitude = zero - low(T)
        doAssert magnitude == maximum + 1
        doAssert magnitude + low(T) == zero
        doAssert low(T) + magnitude == zero
        value = zero
        value -= low(T)
        doAssert value == magnitude
        value += low(T)
        doAssert value == zero
        doAssert (low(T) - zero).toInt(T) == low(T)

checkIntegerArithmetic[int]()
checkIntegerArithmetic[int8]()
checkIntegerArithmetic[int16]()
checkIntegerArithmetic[int32]()
checkIntegerArithmetic[int64]()
checkIntegerArithmetic[uint]()
checkIntegerArithmetic[uint8]()
checkIntegerArithmetic[uint16]()
checkIntegerArithmetic[uint32]()
checkIntegerArithmetic[uint64]()

for a in -100..100:
    for b in -100..100:
        let x = initFactoradic(a)
        doAssert (x + b).toInt() == a + b
        doAssert (b + x).toInt() == a + b
        var value = x
        value += b
        doAssert value == initFactoradic(a + b)
        doAssert (x - b).toInt() == a - b
        value = x
        value -= b
        doAssert value == initFactoradic(a - b)
        doAssert (b - x).toInt() == b - a

for a in 0..200:
    for b in 0..200:
        let x = initFactoradic(a)
        let y = initFactoradic(b)
        doAssert $(x + y) == $(a + b)
        doAssert cmp(x, y) == cmp(a, b)
        doAssert (x < y) == (a < b)
        doAssert (x <= y) == (a <= b)
        doAssert (x > y) == (a > b)
        doAssert (x >= y) == (a >= b)
        doAssert (x == y) == (a == b)
        doAssert (x != y) == (a != b)
        doAssert (x + y).toInt() == a + b
        doAssert (x + y).digits == initFactoradic(a + b).digits
        var z = x
        z += y
        doAssert z == x + y
        z -= y
        doAssert z == x
        doAssert x.toInt() == a
        doAssert (x - y).toInt() == a - b
        doAssert x - y == initFactoradic(a - b)

for n in 0..8:
    var p = toSeq(0..<n)
    var rank = 0
    while true:
        let value = permutationRank(p)
        doAssert value.toInt() == rank
        doAssert value == initFactoradic(rank)
        doAssert value.toPermutation(n) == p
        inc rank
        if not p.nextPermutation(): break
    expectAssertion:
        discard initFactoradic(rank).toPermutation(n)

block:
    let n = 100_000
    let maximum = initFactoradic(toSeq(0..<n))
    let one = initFactoradic(1)
    var factorialDigits = newSeq[int](n + 1)
    factorialDigits[n] = 1
    let factorial = initFactoradic(factorialDigits)
    doAssert factorialFactoradic(n) == factorial
    doAssert factorial.modFactorial(n) == zero
    doAssert maximum.modFactorial(n) == maximum
    doAssert maximum.modFactorial(n - 1) == factorialFactoradic(n - 1) - 1
    doAssert (factorial + 123).modFactorial(n) == initFactoradic(123)
    doAssert maximum < factorial
    doAssert factorial > maximum
    doAssert cmp(maximum, maximum) == 0
    doAssert maximum - one < maximum
    doAssert factorial + one > factorial
    doAssert maximum + one == factorial
    doAssert factorial - one == maximum
    doAssert maximum - maximum == zero
    doAssert permutationRank(toSeq(countdown(n - 1, 0))) == maximum
    doAssert maximum.toPermutation(n) == toSeq(countdown(n - 1, 0))
    var p = toSeq(0..<n)
    var rng = initRand(123456)
    rng.shuffle(p)
    doAssert permutationRank(p).toPermutation(n) == p
    expectAssertion:
        discard factorial.toInt()

block:
    var digits = newSeq[int](101)
    digits[100] = 1
    let factorial = initFactoradic(digits)
    let expected = "93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000"
    doAssert $factorial == expected
    var product = initBigInt(1)
    for n in 1..100: product *= initBigInt(n)
    doAssert factorial.toBigInt() == product
    doAssert (factorial + 123).toBigInt() == product + initBigInt(123)
    doAssert $(factorial + initFactoradic(1)) == expected[0..^2] & "1"

block:
    var source = @[0, 1, 2]
    let value = initFactoradic(source)
    source[1] = 0
    var copy = value.digits
    copy[2] = 0
    doAssert value.digits == @[0, 1, 2]
    var twice = value
    twice += twice
    doAssert twice.toInt() == 10
    twice -= twice
    doAssert twice == zero

block:
    doAssert cmp(default(Factoradic), initFactoradic(@[0, 0, 0])) == 0
    let values = @[120, 5, 0, 24, 1, 6, 5, 119]
    var actual = values.mapIt(initFactoradic(it))
    actual.sort()
    doAssert actual.mapIt(it.toInt()) == values.sorted()
    actual.sort(cmp)
    doAssert actual.mapIt(it.toInt()) == values.sorted()

doAssert initFactoradic(-1).toInt() == -1
expectAssertion: discard initFactoradic(@[1])
expectAssertion: discard initFactoradic(@[0, 2])
expectAssertion: discard initFactoradic(@[0, -1])
expectAssertion: discard permutationRank(@[0, 0])
expectAssertion: discard permutationRank(@[-1])
expectAssertion: discard permutationRank(@[1])
expectAssertion: discard zero.toPermutation(-1)

block:
    doAssert initFactoradic(initBigInt(0)) == zero
    doAssert initFactoradic(initBigInt(-1)).toInt() == -1
    for a in 0..100:
        for b in 0..100:
            let x = initFactoradic(a)
            let y = initFactoradic(b)
            doAssert initFactoradic(x.toBigInt()) == x
            doAssert x * y == a * b
            var value = x
            value *= y
            doAssert value == x * y
            if b > 0:
                let division = divmod(x, y)
                doAssert division.quotient == a div b
                doAssert division.remainder == a mod b
                doAssert x div y == division.quotient
                doAssert x mod y == division.remainder
                value = x
                `div=`(value, y)
                doAssert value == division.quotient
                value = x
                `mod=`(value, y)
                doAssert value == division.remainder
            doAssert x == a
            doAssert y == b

block:
    let a = factorialFactoradic(100) + 123
    let b = factorialFactoradic(50) + 7
    doAssert initFactoradic(a.toBigInt()) == a
    let product = a * b
    doAssert product.toBigInt() == a.toBigInt() * b.toBigInt()
    doAssert product div b == a
    doAssert product mod b == zero
    let division = divmod(a, b)
    doAssert division.quotient * b + division.remainder == a
    doAssert division.remainder < b
    doAssert division.quotient == a div b
    doAssert division.remainder == a mod b
    doAssert a div a == 1
    doAssert a mod a == 0
    var value = a
    value *= value
    doAssert value == a * a
    `div=`(value, value)
    doAssert value == 1
    `mod=`(value, value)
    doAssert value == 0

for value in [zero, initFactoradic(1), factorialFactoradic(100)]:
    expectZeroDivision: discard divmod(value, zero)
    expectZeroDivision: discard value div zero
    expectZeroDivision: discard value mod zero
    var copy = value
    expectZeroDivision: `div=`(copy, zero)
    doAssert copy == value
    expectZeroDivision: `mod=`(copy, zero)
    doAssert copy == value

block:
    for a in 0..50:
        for b in 0..50:
            let x = initFactoradic(a)
            doAssert x * b == a * b
            doAssert b * x == a * b
            var value = x
            value *= b
            doAssert value == a * b
            if b > 0:
                doAssert x div b == a div b
                let division = divmod(x, b)
                doAssert division.quotient == a div b
                doAssert division.remainder == a mod b
                doAssert division.remainder is int
                value = x
                `div=`(value, b)
                doAssert value == a div b
                value = x
                `mod=`(value, b)
                doAssert value == a mod b
            if a > 0:
                doAssert b div x == b div a
                doAssert b mod x == b mod a
                let division = divmod(b, x)
                doAssert division.quotient == b div a
                doAssert division.remainder == b mod a

    let large = factorialFactoradic(100) + 123
    for b in [1, 7, high(int)]:
        doAssert (large * b) div b == large
        doAssert (b * large) div large == b
        let division = divmod(large, b)
        doAssert division.quotient * b + division.remainder == large
        doAssert division.remainder == large mod b
        doAssert b div large == 0
        doAssert b mod large == b
        doAssert divmod(b, large).remainder == b
    for x in [zero, initFactoradic(1), large]:
        expectZeroDivision: discard x div 0
        expectZeroDivision: discard divmod(x, 0)
        doAssert x * -1 == -x
        doAssert -1 * x == -x
        doAssert x div -1 == -x
        doAssert divmod(x, -1).quotient == -x
        if x != 0:
            doAssert -1 div x == -1
            doAssert -1 mod x == x - 1
            doAssert divmod(-1, x).remainder == x - 1
        var value = x
        expectZeroDivision: `div=`(value, 0)
        expectZeroDivision: `mod=`(value, 0)
        doAssert value == x
        value *= -1
        doAssert value == -x
    expectZeroDivision: discard 1 div zero
    expectZeroDivision: discard 1 mod zero
    expectZeroDivision: discard divmod(1, zero)

block:
    var rng = initRand(987654)
    for iteration in 0..<100:
        var digits = newSeq[int](rng.rand(2..100))
        for i in 1..<digits.len: digits[i] = rng.rand(i)
        let x = initFactoradic(digits)
        let b = if iteration mod 2 == 0: high(int) - iteration else: rng.rand(1..1000000)
        let expected = x.toBigInt()
        doAssert (x * b).toBigInt() == expected * initBigInt(b)
        let division = divmod(x, b)
        let expectedDivision = divmod(expected, initBigInt(b))
        doAssert division.quotient.toBigInt() == expectedDivision.quotient
        doAssert initBigInt(division.remainder) == expectedDivision.remainder
        doAssert x.toBigInt() == expected
    let huge = factorialFactoradic(100_000) - 1
    for b in [1, 2, 12345, high(int)]:
        let product = huge * b
        doAssert product div b == huge
        let division = divmod(huge, b)
        doAssert division.quotient * b + division.remainder == huge
        doAssert division.remainder == huge mod b
        doAssert b div huge == 0
        doAssert b mod huge == b
    doAssert huge * 0 == 0

block:
    var rng = initRand(246810)
    for n in [31, 32, 33, 34, 63, 64, 65, 66, 127, 128, 129, 257, 1025, 4097]:
        var digits = newSeq[int](n)
        for i in 1..<n: digits[i] = rng.rand(i)
        digits[^1] = n - 1
        let a = initFactoradic(digits)
        var expected = initBigInt(0)
        for i in countdown(n - 1, 1):
            expected = expected * initBigInt(i + 1) + initBigInt(digits[i])
        doAssert a.toBigInt() == expected
        doAssert initFactoradic(expected) == a
        let b = initFactoradic(digits[0..<n div 2]) + 1
        let expectedB = b.toBigInt()
        doAssert (a * b).toBigInt() == expected * expectedB
        let division = divmod(a, b)
        let expectedDivision = divmod(expected, expectedB)
        doAssert division.quotient.toBigInt() == expectedDivision.quotient
        doAssert division.remainder.toBigInt() == expectedDivision.remainder
        doAssert a div b == division.quotient
        doAssert a mod b == division.remainder
        var factorial = initBigInt(1)
        for i in 1..n: factorial *= initBigInt(i)
        let f = factorialFactoradic(n)
        for delta in [-1, 0, 1]:
            doAssert initFactoradic(factorial + initBigInt(delta)) == f + delta
            doAssert (f + delta).toBigInt() == factorial + initBigInt(delta)

block:
    let huge = factorialFactoradic(100_000) - 1
    for value in [0, 1, 7, high(int)]:
        let small = initFactoradic(value)
        doAssert huge * small == huge * value
        doAssert small * huge == value * huge
        doAssert small div huge == 0
        doAssert small mod huge == small
        doAssert divmod(small, huge).remainder == small
        if value > 0:
            let division = divmod(huge, small)
            doAssert division.quotient == huge div value
            doAssert division.remainder == huge mod value
            doAssert huge div small == division.quotient
            doAssert huge mod small == division.remainder
    doAssert huge div huge == 1
    doAssert huge mod huge == 0
    doAssert divmod(huge, huge).quotient == 1

echo "Hello World"
