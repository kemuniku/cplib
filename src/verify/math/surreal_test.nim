# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/math/bigint
import cplib/math/surreal

proc scaled(x: Surreal, exponent: int): int =
    doAssert x.denominatorExponent <= exponent
    (x.numerator shl (exponent - x.denominatorExponent)).toInt

block:
    var zero: Surreal
    doAssert zero.isZero and zero.sgn == 0 and $zero == "0"
    doAssert zero == initSurreal(0, high(int))
    for n in -32..32:
        for e in 0..6:
            let x = initSurreal(n, e)
            doAssert scaled(x, 6) == n * (1 shl (6-e))
            doAssert x.sgn == system.cmp(n, 0)
            doAssert x.isZero == (n == 0)
            doAssert +x == x and -(-x) == x
            doAssert x.abs == (if n < 0: -x else: x)
            doAssert x == initSurreal(n * 8, e + 3)
            if x.denominatorExponent > 0:
                doAssert x.numerator mod initBigInt(2) != initBigInt(0)
    doAssert $initSurreal(-12, 4) == "-3/2^2"
    doAssertRaises(ValueError): discard initSurreal(1, -1)
    doAssertRaises(ValueError): discard initSurreal(0, low(int))
    for n in [low(int), low(int)+1, -1, 0, 1, high(int)]:
        doAssert initSurreal(n).numerator == initBigInt(n)
    doAssert $initSurreal(high(uint64)) == "18446744073709551615"
    doAssert $(-initSurreal(low(int64))) == "9223372036854775808"

proc checkArithmetic(a, b: Surreal) =
    let ai = scaled(a, 8)
    let bi = scaled(b, 8)
    doAssert cmp(a, b) == system.cmp(ai, bi)
    doAssert (a == b) == (ai == bi)
    doAssert (a < b) == (ai < bi)
    doAssert (a <= b) == (ai <= bi)
    doAssert (a > b) == (ai > bi)
    doAssert (a >= b) == (ai >= bi)
    doAssert scaled(a+b, 8) == ai+bi
    doAssert scaled(a-b, 8) == ai-bi
    var c = a
    c += b
    doAssert c == a+b
    c -= b
    doAssert c == a
    doAssert a+b == b+a

for a in -12..12:
    for b in -12..12:
        for e in 0..4:
            for f in 0..4:
                checkArithmetic(initSurreal(a, e), initSurreal(b, f))
var rng = initRand(955)
for _ in 0..<3000:
    checkArithmetic(initSurreal(rng.rand(-10000..10000), rng.rand(0..8)),
        initSurreal(rng.rand(-10000..10000), rng.rand(0..8)))

const oracleScale = 1024
var days = @[@[0]]
var old = @[0]
for day in 1..10:
    var born = @[old[0]-oracleScale, old[^1]+oracleScale]
    for i in 0..<old.len-1:
        doAssert (old[i] + old[i+1]) mod 2 == 0
        born.add((old[i] + old[i+1]) div 2)
    days.add(born)
    old.add(born)
    old.sort()

proc oracleCut(left, right: seq[int]): int =
    for born in days:
        var found = false
        for candidate in born:
            var valid = true
            for x in left:
                if x >= candidate: valid = false
            for x in right:
                if candidate >= x: valid = false
            if valid:
                doAssert not found
                result = candidate
                found = true
        if found: return
    doAssert false

var cutCases = 0
proc checkCut(left, right: seq[int]) =
    var l, r: seq[Surreal]
    for x in left: l.add(initSurreal(x, 10))
    for x in right: r.add(initSurreal(x, 10))
    let savedL = l
    let savedR = r
    let x = surrealCut(l, r)
    doAssert scaled(x, 10) == oracleCut(left, right)
    for y in l: doAssert y < x
    for y in r: doAssert x < y
    doAssert l == savedL and r == savedR
    l.reverse()
    r.reverse()
    doAssert surrealCut(l, r) == x
    var nl, nr: seq[Surreal]
    for y in r: nl.add(-y)
    for y in l: nr.add(-y)
    doAssert surrealCut(nl, nr) == -x
    inc cutCases

checkCut(@[], @[])
for a in -64..64:
    checkCut(@[a*64], @[])
    checkCut(@[], @[a*64])
    for b in a+1..64:
        checkCut(@[a*64], @[b*64])
        checkCut(@[(a-1)*64, a*64, a*64], @[(b+1)*64, b*64, b*64])
doAssert cutCases == 16771
for _ in 0..<1000:
    let a = rng.rand(-64..63)*64
    let b = rng.rand(a div 64 + 1..64)*64
    checkCut(@[a, a-rng.rand(0..1024), a], @[b, b+rng.rand(0..1024)])
doAssertRaises(ValueError): discard surrealCut([initSurreal(0)], [initSurreal(0)])
doAssertRaises(ValueError): discard surrealCut([initSurreal(-3), initSurreal(2)], [initSurreal(1)])

block:
    let huge = parseBigInt("123456789012345678901234567890123456789012345678901234567890123456789")
    let x = initSurreal(huge)
    doAssert (x+initSurreal(1)).numerator == huge+1
    doAssert surrealCut([x], []) == x+initSurreal(1)
    doAssert surrealCut([x], [x+initSurreal(1)]) == initSurreal(huge*2+1, 1)
    for e in [31, 32, 63, 64, 127, 128, 1024, 4096]:
        let power = initBigInt(1) shl e
        doAssert initSurreal(power, e) == initSurreal(1)
        doAssert initSurreal(-power, e) == initSurreal(-1)
        let tiny = initSurreal(1, e)
        doAssert surrealCut([initSurreal(0)], [tiny]) == initSurreal(1, e+1)
        doAssert surrealCut([tiny], [initSurreal(2, e)]) == initSurreal(3, e+1)
        doAssert initSurreal(1) - tiny == initSurreal(power-1, e)
        doAssert initSurreal(1) + tiny == initSurreal(power+1, e)
        doAssert tiny+tiny == initSurreal(1, e-1)
        doAssert initSurreal(huge shl e, e+5) == initSurreal(huge, 5)
    let tiny = initSurreal(1, high(int))
    doAssert initSurreal(0) < tiny and tiny < initSurreal(1)
    doAssert -initSurreal(1) < -tiny and -tiny < initSurreal(0)
    doAssert tiny+tiny == initSurreal(1, high(int)-1)
    doAssert tiny-tiny == initSurreal(0)
    doAssert initSurreal(2, high(int)) == initSurreal(1, high(int)-1)
    doAssert surrealCut([tiny], [initSurreal(3, high(int))]) == tiny+tiny
    doAssertRaises(OverflowDefect): discard surrealCut([initSurreal(0)], [tiny])
    doAssertRaises(OverflowDefect): discard surrealCut([-tiny], [initSurreal(0)])
    var returned = x.numerator
    returned += 1
    doAssert x.numerator == huge
    var copy = x
    copy += initSurreal(1)
    doAssert x.numerator == huge

block:
    let zero = surrealCut([], [])
    let one = surrealCut([zero], [])
    let half = surrealCut([zero], [one])
    let quarter = surrealCut([zero], [half])
    doAssert half == initSurreal(1, 1) and quarter == initSurreal(1, 2)
    doAssert (one-half-quarter).sgn == 1
    doAssert half+(-half) == zero
    doAssertRaises(ValueError): discard surrealCut([zero], [zero])

echo "Hello World"
