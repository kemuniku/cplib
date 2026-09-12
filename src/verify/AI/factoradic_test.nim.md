---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/factoradic.nim
    title: cplib/math/factoradic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/factoradic.nim
    title: cplib/math/factoradic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import algorithm, random, sequtils, hashes, sets, tables\nimport cplib/math/factoradic\n\
    import cplib/math/bigint\n\ntemplate expectAssertion(body: untyped) =\n    block:\n\
    \        var caught = false\n        try:\n            body\n        except AssertionDefect:\n\
    \            caught = true\n        doAssert caught\n\ntemplate expectZeroDivision(body:\
    \ untyped) =\n    block:\n        var caught = false\n        try:\n         \
    \   body\n        except DivByZeroDefect:\n            caught = true\n       \
    \ doAssert caught\n\nlet zero = initFactoradic(0)\ndoAssert default(Factoradic)\
    \ == zero\ndoAssert initFactoradic(newSeq[int]()) == zero\ndoAssert initFactoradic(@[0,\
    \ 0, 0]) == zero\ndoAssert zero.digits == newSeq[int]()\ndoAssert zero.toInt()\
    \ == 0\ndoAssert zero.toBigInt() == initBigInt(0)\ndoAssert default(Factoradic).toBigInt()\
    \ == initBigInt(0)\ndoAssert initFactoradic(4).toBigInt() is BigInt\ndoAssert\
    \ $zero == \"0\"\ndoAssert $default(Factoradic) == \"0\"\ndoAssert $initFactoradic(@[0,\
    \ 0, 0]) == \"0\"\ndoAssert $permutationRank(@[2, 0, 1]) == \"4\"\ndoAssert zero.toPermutation(0)\
    \ == newSeq[int]()\ndoAssert zero.toPermutation(1) == @[0]\ndoAssert initFactoradic(@[0,\
    \ 0, 2]).toInt() == 4\ndoAssert permutationRank(@[2, 0, 1]).digits == @[0, 0,\
    \ 2]\ndoAssert initFactoradic(4).toPermutation(3) == @[2, 0, 1]\ndoAssert initFactoradic(4).toInt()\
    \ is int\ndoAssert initFactoradic(4).toInt(int64) is int64\n\nblock:\n    var\
    \ expected = 1'i64\n    for n in 0..20:\n        if n > 0: expected *= int64(n)\n\
    \        doAssert factorialFactoradic(n).toInt(int64) == expected\n    doAssert\
    \ factorialFactoradic(0) == factorialFactoradic(1)\n    doAssert factorialFactoradic(5).toInt()\
    \ == 120\n    expectAssertion: discard factorialFactoradic(-1)\n\nblock:\n   \
    \ var modulus = 1\n    for k in 0..8:\n        if k > 0: modulus *= k\n      \
    \  for value in 0..1000:\n            let x = initFactoradic(value)\n        \
    \    let remainder = x.modFactorial(k)\n            doAssert remainder == initFactoradic(value\
    \ mod modulus)\n            doAssert x.toInt() == value\n    doAssert zero.modFactorial(0)\
    \ == zero\n    doAssert default(Factoradic).modFactorial(10) == zero\n    doAssert\
    \ initFactoradic(123).modFactorial(high(int)) == initFactoradic(123)\n    expectAssertion:\
    \ discard zero.modFactorial(-1)\n\nblock:\n    doAssert (initFactoradic(100) mod\
    \ 7) is int\n    for value in 0..1000:\n        let x = initFactoradic(value)\n\
    \        for modulus in 1..100:\n            doAssert x mod modulus == value mod\
    \ modulus\n    for modulus in [1, 2, 7, 1_000_000_007, high(int) - 1, high(int)]:\n\
    \        doAssert zero mod modulus == 0\n        doAssert default(Factoradic)\
    \ mod modulus == 0\n        for value in [0, 1, high(int) div 2, high(int) - 1,\
    \ high(int)]:\n            doAssert initFactoradic(value) mod modulus == value\
    \ mod modulus\n        var factorial = initBigInt(1)\n        for n in 0..100:\n\
    \            if n > 0: factorial *= initBigInt(n)\n            let x = factorialFactoradic(n)\n\
    \            for offset in [0, 1, 123, high(int)]:\n                let expected\
    \ = (factorial + initBigInt(offset)) mod initBigInt(modulus)\n               \
    \ doAssert system.`$`((x + offset) mod modulus) == $expected\n    expectZeroDivision:\
    \ discard zero mod 0\n    doAssert zero mod -1 == 0\n\nproc checkMixedComparison[T:\
    \ SomeInteger](a: Factoradic, b: T, expected: int) =\n    doAssert cmp(a, b) ==\
    \ expected\n    doAssert cmp(b, a) == -expected\n    doAssert (a < b) == (expected\
    \ < 0)\n    doAssert (a <= b) == (expected <= 0)\n    doAssert (a > b) == (expected\
    \ > 0)\n    doAssert (a >= b) == (expected >= 0)\n    doAssert (a == b) == (expected\
    \ == 0)\n    doAssert (a != b) == (expected != 0)\n    doAssert (b < a) == (expected\
    \ > 0)\n    doAssert (b <= a) == (expected >= 0)\n    doAssert (b > a) == (expected\
    \ < 0)\n    doAssert (b >= a) == (expected <= 0)\n    doAssert (b == a) == (expected\
    \ == 0)\n    doAssert (b != a) == (expected != 0)\n\nfor a in 0..100:\n    for\
    \ b in -100..100:\n        checkMixedComparison(initFactoradic(a), b, cmp(a, b))\n\
    \nblock:\n    var seen = initHashSet[Factoradic]()\n    var values = initTable[Factoradic,\
    \ int]()\n    for value in 0..100:\n        let a = initFactoradic(value)\n  \
    \      let b = initFactoradic(a.digits & @[0, 0])\n        doAssert hash(a) ==\
    \ hash(b)\n        seen.incl(a)\n        seen.incl(b)\n        values[a] = value\n\
    \        doAssert b in seen\n        doAssert values[b] == value\n    doAssert\
    \ seen.len == 101\n    doAssert hash(default(Factoradic)) == hash(zero)\n    let\
    \ large = factorialFactoradic(100)\n    seen.incl(large)\n    values[large] =\
    \ 123\n    doAssert large + 1 - 1 in seen\n    doAssert values[large + 1 - 1]\
    \ == 123\n    doAssert large + 1 notin seen\n\nproc checkInteger[T: SomeInteger]()\
    \ =\n    for value in [T(0), T(1), high(T) div 2, high(T) - 1, high(T)]:\n   \
    \     doAssert initFactoradic(value).toInt(T) == value\n        doAssert initFactoradic(value).toBigInt()\
    \ == initBigInt(value)\n        doAssert $initFactoradic(value) == system.`$`(value)\n\
    \        checkMixedComparison(initFactoradic(value), value, 0)\n        checkMixedComparison(initFactoradic(value)\
    \ + 1, value, 1)\n        if value > 0:\n            checkMixedComparison(initFactoradic(value)\
    \ - 1, value, -1)\n    checkMixedComparison(factorialFactoradic(100), high(T),\
    \ 1)\n    when T is SomeSignedInt:\n        checkMixedComparison(zero, low(T),\
    \ 1)\n    expectAssertion:\n        discard (initFactoradic(high(T)) + initFactoradic(1)).toInt(T)\n\
    \ncheckInteger[int]()\ncheckInteger[int8]()\ncheckInteger[int16]()\ncheckInteger[int32]()\n\
    checkInteger[int64]()\ncheckInteger[uint]()\ncheckInteger[uint8]()\ncheckInteger[uint16]()\n\
    checkInteger[uint32]()\ncheckInteger[uint64]()\n\nproc checkIntegerArithmetic[T:\
    \ SomeInteger]() =\n    let maximum = initFactoradic(high(T))\n    doAssert zero\
    \ + high(T) == maximum\n    doAssert high(T) + zero == maximum\n    doAssert maximum\
    \ - high(T) == zero\n    doAssert high(T) - maximum == zero\n    let doubled =\
    \ maximum + high(T)\n    doAssert doubled - high(T) == maximum\n    var value\
    \ = maximum\n    value += high(T)\n    doAssert value == doubled\n    value -=\
    \ high(T)\n    doAssert value == maximum\n    when T is SomeSignedInt:\n     \
    \   let magnitude = zero - low(T)\n        doAssert magnitude == maximum + 1\n\
    \        doAssert magnitude + low(T) == zero\n        doAssert low(T) + magnitude\
    \ == zero\n        value = zero\n        value -= low(T)\n        doAssert value\
    \ == magnitude\n        value += low(T)\n        doAssert value == zero\n    \
    \    doAssert (low(T) - zero).toInt(T) == low(T)\n\ncheckIntegerArithmetic[int]()\n\
    checkIntegerArithmetic[int8]()\ncheckIntegerArithmetic[int16]()\ncheckIntegerArithmetic[int32]()\n\
    checkIntegerArithmetic[int64]()\ncheckIntegerArithmetic[uint]()\ncheckIntegerArithmetic[uint8]()\n\
    checkIntegerArithmetic[uint16]()\ncheckIntegerArithmetic[uint32]()\ncheckIntegerArithmetic[uint64]()\n\
    \nfor a in -100..100:\n    for b in -100..100:\n        let x = initFactoradic(a)\n\
    \        doAssert (x + b).toInt() == a + b\n        doAssert (b + x).toInt() ==\
    \ a + b\n        var value = x\n        value += b\n        doAssert value ==\
    \ initFactoradic(a + b)\n        doAssert (x - b).toInt() == a - b\n        value\
    \ = x\n        value -= b\n        doAssert value == initFactoradic(a - b)\n \
    \       doAssert (b - x).toInt() == b - a\n\nfor a in 0..200:\n    for b in 0..200:\n\
    \        let x = initFactoradic(a)\n        let y = initFactoradic(b)\n      \
    \  doAssert $(x + y) == $(a + b)\n        doAssert cmp(x, y) == cmp(a, b)\n  \
    \      doAssert (x < y) == (a < b)\n        doAssert (x <= y) == (a <= b)\n  \
    \      doAssert (x > y) == (a > b)\n        doAssert (x >= y) == (a >= b)\n  \
    \      doAssert (x == y) == (a == b)\n        doAssert (x != y) == (a != b)\n\
    \        doAssert (x + y).toInt() == a + b\n        doAssert (x + y).digits ==\
    \ initFactoradic(a + b).digits\n        var z = x\n        z += y\n        doAssert\
    \ z == x + y\n        z -= y\n        doAssert z == x\n        doAssert x.toInt()\
    \ == a\n        doAssert (x - y).toInt() == a - b\n        doAssert x - y == initFactoradic(a\
    \ - b)\n\nfor n in 0..8:\n    var p = toSeq(0..<n)\n    var rank = 0\n    while\
    \ true:\n        let value = permutationRank(p)\n        doAssert value.toInt()\
    \ == rank\n        doAssert value == initFactoradic(rank)\n        doAssert value.toPermutation(n)\
    \ == p\n        inc rank\n        if not p.nextPermutation(): break\n    expectAssertion:\n\
    \        discard initFactoradic(rank).toPermutation(n)\n\nblock:\n    let n =\
    \ 100_000\n    let maximum = initFactoradic(toSeq(0..<n))\n    let one = initFactoradic(1)\n\
    \    var factorialDigits = newSeq[int](n + 1)\n    factorialDigits[n] = 1\n  \
    \  let factorial = initFactoradic(factorialDigits)\n    doAssert factorialFactoradic(n)\
    \ == factorial\n    doAssert factorial.modFactorial(n) == zero\n    doAssert maximum.modFactorial(n)\
    \ == maximum\n    doAssert maximum.modFactorial(n - 1) == factorialFactoradic(n\
    \ - 1) - 1\n    doAssert (factorial + 123).modFactorial(n) == initFactoradic(123)\n\
    \    doAssert maximum < factorial\n    doAssert factorial > maximum\n    doAssert\
    \ cmp(maximum, maximum) == 0\n    doAssert maximum - one < maximum\n    doAssert\
    \ factorial + one > factorial\n    doAssert maximum + one == factorial\n    doAssert\
    \ factorial - one == maximum\n    doAssert maximum - maximum == zero\n    doAssert\
    \ permutationRank(toSeq(countdown(n - 1, 0))) == maximum\n    doAssert maximum.toPermutation(n)\
    \ == toSeq(countdown(n - 1, 0))\n    var p = toSeq(0..<n)\n    var rng = initRand(123456)\n\
    \    rng.shuffle(p)\n    doAssert permutationRank(p).toPermutation(n) == p\n \
    \   expectAssertion:\n        discard factorial.toInt()\n\nblock:\n    var digits\
    \ = newSeq[int](101)\n    digits[100] = 1\n    let factorial = initFactoradic(digits)\n\
    \    let expected = \"93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000\"\
    \n    doAssert $factorial == expected\n    var product = initBigInt(1)\n    for\
    \ n in 1..100: product *= initBigInt(n)\n    doAssert factorial.toBigInt() ==\
    \ product\n    doAssert (factorial + 123).toBigInt() == product + initBigInt(123)\n\
    \    doAssert $(factorial + initFactoradic(1)) == expected[0..^2] & \"1\"\n\n\
    block:\n    var source = @[0, 1, 2]\n    let value = initFactoradic(source)\n\
    \    source[1] = 0\n    var copy = value.digits\n    copy[2] = 0\n    doAssert\
    \ value.digits == @[0, 1, 2]\n    var twice = value\n    twice += twice\n    doAssert\
    \ twice.toInt() == 10\n    twice -= twice\n    doAssert twice == zero\n\nblock:\n\
    \    doAssert cmp(default(Factoradic), initFactoradic(@[0, 0, 0])) == 0\n    let\
    \ values = @[120, 5, 0, 24, 1, 6, 5, 119]\n    var actual = values.mapIt(initFactoradic(it))\n\
    \    actual.sort()\n    doAssert actual.mapIt(it.toInt()) == values.sorted()\n\
    \    actual.sort(cmp)\n    doAssert actual.mapIt(it.toInt()) == values.sorted()\n\
    \ndoAssert initFactoradic(-1).toInt() == -1\nexpectAssertion: discard initFactoradic(@[1])\n\
    expectAssertion: discard initFactoradic(@[0, 2])\nexpectAssertion: discard initFactoradic(@[0,\
    \ -1])\nexpectAssertion: discard permutationRank(@[0, 0])\nexpectAssertion: discard\
    \ permutationRank(@[-1])\nexpectAssertion: discard permutationRank(@[1])\nexpectAssertion:\
    \ discard zero.toPermutation(-1)\n\nblock:\n    doAssert initFactoradic(initBigInt(0))\
    \ == zero\n    doAssert initFactoradic(initBigInt(-1)).toInt() == -1\n    for\
    \ a in 0..100:\n        for b in 0..100:\n            let x = initFactoradic(a)\n\
    \            let y = initFactoradic(b)\n            doAssert initFactoradic(x.toBigInt())\
    \ == x\n            doAssert x * y == a * b\n            var value = x\n     \
    \       value *= y\n            doAssert value == x * y\n            if b > 0:\n\
    \                let division = divmod(x, y)\n                doAssert division.quotient\
    \ == a div b\n                doAssert division.remainder == a mod b\n       \
    \         doAssert x div y == division.quotient\n                doAssert x mod\
    \ y == division.remainder\n                value = x\n                `div=`(value,\
    \ y)\n                doAssert value == division.quotient\n                value\
    \ = x\n                `mod=`(value, y)\n                doAssert value == division.remainder\n\
    \            doAssert x == a\n            doAssert y == b\n\nblock:\n    let a\
    \ = factorialFactoradic(100) + 123\n    let b = factorialFactoradic(50) + 7\n\
    \    doAssert initFactoradic(a.toBigInt()) == a\n    let product = a * b\n   \
    \ doAssert product.toBigInt() == a.toBigInt() * b.toBigInt()\n    doAssert product\
    \ div b == a\n    doAssert product mod b == zero\n    let division = divmod(a,\
    \ b)\n    doAssert division.quotient * b + division.remainder == a\n    doAssert\
    \ division.remainder < b\n    doAssert division.quotient == a div b\n    doAssert\
    \ division.remainder == a mod b\n    doAssert a div a == 1\n    doAssert a mod\
    \ a == 0\n    var value = a\n    value *= value\n    doAssert value == a * a\n\
    \    `div=`(value, value)\n    doAssert value == 1\n    `mod=`(value, value)\n\
    \    doAssert value == 0\n\nfor value in [zero, initFactoradic(1), factorialFactoradic(100)]:\n\
    \    expectZeroDivision: discard divmod(value, zero)\n    expectZeroDivision:\
    \ discard value div zero\n    expectZeroDivision: discard value mod zero\n   \
    \ var copy = value\n    expectZeroDivision: `div=`(copy, zero)\n    doAssert copy\
    \ == value\n    expectZeroDivision: `mod=`(copy, zero)\n    doAssert copy == value\n\
    \nblock:\n    for a in 0..50:\n        for b in 0..50:\n            let x = initFactoradic(a)\n\
    \            doAssert x * b == a * b\n            doAssert b * x == a * b\n  \
    \          var value = x\n            value *= b\n            doAssert value ==\
    \ a * b\n            if b > 0:\n                doAssert x div b == a div b\n\
    \                let division = divmod(x, b)\n                doAssert division.quotient\
    \ == a div b\n                doAssert division.remainder == a mod b\n       \
    \         doAssert division.remainder is int\n                value = x\n    \
    \            `div=`(value, b)\n                doAssert value == a div b\n   \
    \             value = x\n                `mod=`(value, b)\n                doAssert\
    \ value == a mod b\n            if a > 0:\n                doAssert b div x ==\
    \ b div a\n                doAssert b mod x == b mod a\n                let division\
    \ = divmod(b, x)\n                doAssert division.quotient == b div a\n    \
    \            doAssert division.remainder == b mod a\n\n    let large = factorialFactoradic(100)\
    \ + 123\n    for b in [1, 7, high(int)]:\n        doAssert (large * b) div b ==\
    \ large\n        doAssert (b * large) div large == b\n        let division = divmod(large,\
    \ b)\n        doAssert division.quotient * b + division.remainder == large\n \
    \       doAssert division.remainder == large mod b\n        doAssert b div large\
    \ == 0\n        doAssert b mod large == b\n        doAssert divmod(b, large).remainder\
    \ == b\n    for x in [zero, initFactoradic(1), large]:\n        expectZeroDivision:\
    \ discard x div 0\n        expectZeroDivision: discard divmod(x, 0)\n        doAssert\
    \ x * -1 == -x\n        doAssert -1 * x == -x\n        doAssert x div -1 == -x\n\
    \        doAssert divmod(x, -1).quotient == -x\n        if x != 0:\n         \
    \   doAssert -1 // x == -1\n            doAssert -1 % x == x - 1\n           \
    \ doAssert -1 div x == (if x == 1: -1 else: 0)\n            doAssert -1 mod x\
    \ == (if x == 1: 0 else: -1)\n            doAssert divmod(-1, x).remainder ==\
    \ x - 1\n        var value = x\n        expectZeroDivision: `div=`(value, 0)\n\
    \        expectZeroDivision: `mod=`(value, 0)\n        doAssert value == x\n \
    \       value *= -1\n        doAssert value == -x\n    expectZeroDivision: discard\
    \ 1 div zero\n    expectZeroDivision: discard 1 mod zero\n    expectZeroDivision:\
    \ discard divmod(1, zero)\n\nblock:\n    var rng = initRand(987654)\n    for iteration\
    \ in 0..<100:\n        var digits = newSeq[int](rng.rand(2..100))\n        for\
    \ i in 1..<digits.len: digits[i] = rng.rand(i)\n        let x = initFactoradic(digits)\n\
    \        let b = if iteration mod 2 == 0: high(int) - iteration else: rng.rand(1..1000000)\n\
    \        let expected = x.toBigInt()\n        doAssert (x * b).toBigInt() == expected\
    \ * initBigInt(b)\n        let division = divmod(x, b)\n        let expectedDivision\
    \ = divmod(expected, initBigInt(b))\n        doAssert division.quotient.toBigInt()\
    \ == expectedDivision.quotient\n        doAssert initBigInt(division.remainder)\
    \ == expectedDivision.remainder\n        doAssert x.toBigInt() == expected\n \
    \   let huge = factorialFactoradic(100_000) - 1\n    for b in [1, 2, 12345, high(int)]:\n\
    \        let product = huge * b\n        doAssert product div b == huge\n    \
    \    let division = divmod(huge, b)\n        doAssert division.quotient * b +\
    \ division.remainder == huge\n        doAssert division.remainder == huge mod\
    \ b\n        doAssert b div huge == 0\n        doAssert b mod huge == b\n    doAssert\
    \ huge * 0 == 0\n\nblock:\n    var rng = initRand(246810)\n    for n in [31, 32,\
    \ 33, 34, 63, 64, 65, 66, 127, 128, 129, 257, 1025, 4097]:\n        var digits\
    \ = newSeq[int](n)\n        for i in 1..<n: digits[i] = rng.rand(i)\n        digits[^1]\
    \ = n - 1\n        let a = initFactoradic(digits)\n        var expected = initBigInt(0)\n\
    \        for i in countdown(n - 1, 1):\n            expected = expected * initBigInt(i\
    \ + 1) + initBigInt(digits[i])\n        doAssert a.toBigInt() == expected\n  \
    \      doAssert initFactoradic(expected) == a\n        let b = initFactoradic(digits[0..<n\
    \ div 2]) + 1\n        let expectedB = b.toBigInt()\n        doAssert (a * b).toBigInt()\
    \ == expected * expectedB\n        let division = divmod(a, b)\n        let expectedDivision\
    \ = divmod(expected, expectedB)\n        doAssert division.quotient.toBigInt()\
    \ == expectedDivision.quotient\n        doAssert division.remainder.toBigInt()\
    \ == expectedDivision.remainder\n        doAssert a div b == division.quotient\n\
    \        doAssert a mod b == division.remainder\n        var factorial = initBigInt(1)\n\
    \        for i in 1..n: factorial *= initBigInt(i)\n        let f = factorialFactoradic(n)\n\
    \        for delta in [-1, 0, 1]:\n            doAssert initFactoradic(factorial\
    \ + initBigInt(delta)) == f + delta\n            doAssert (f + delta).toBigInt()\
    \ == factorial + initBigInt(delta)\n\nblock:\n    let huge = factorialFactoradic(100_000)\
    \ - 1\n    for value in [0, 1, 7, high(int)]:\n        let small = initFactoradic(value)\n\
    \        doAssert huge * small == huge * value\n        doAssert small * huge\
    \ == value * huge\n        doAssert small div huge == 0\n        doAssert small\
    \ mod huge == small\n        doAssert divmod(small, huge).remainder == small\n\
    \        if value > 0:\n            let division = divmod(huge, small)\n     \
    \       doAssert division.quotient == huge div value\n            doAssert division.remainder\
    \ == huge mod value\n            doAssert huge div small == division.quotient\n\
    \            doAssert huge mod small == division.remainder\n    doAssert huge\
    \ div huge == 1\n    doAssert huge mod huge == 0\n    doAssert divmod(huge, huge).quotient\
    \ == 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/powmod.nim
  - cplib/math/factoradic.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/factoradic.nim
  - cplib/math/inner_math.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/math/bigint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/bigint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/AI/factoradic_test.nim
  requiredBy: []
  timestamp: '2026-09-13 02:58:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/factoradic_test.nim
layout: document
redirect_from:
- /verify/verify/AI/factoradic_test.nim
- /verify/verify/AI/factoradic_test.nim.html
title: verify/AI/factoradic_test.nim
---
