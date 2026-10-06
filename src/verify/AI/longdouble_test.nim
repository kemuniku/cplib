# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/longdouble

let info = longDoubleInfo()
assert info.size == sizeof(LongDouble)
assert info.mantissaDigits > 0
assert info.decimalDigits >= info.digits
let one: LongDouble = 1
let eps = epsilonLongDouble()
assert one + eps > one
assert (one + eps) - one == eps
if info.radix == 2 and info.mantissaDigits > 53:
    assert to_float(one + eps) == 1.0
    let exact = to_longdouble(9007199254740993'i64)
    assert to_integer(exact, int64) == 9007199254740993'i64
    assert exact - 9007199254740992'i64 == 1

var x: LongDouble = 2
x += 3
x -= 1
x *= 2
x /= 4
assert x == 2
assert abs(-x) == x
assert -x < 0
assert x > 1 and x >= 2 and x <= 2
assert cmp(x, 2) == 0
assert cmp(x, 3) == -1
assert cmp(x, 1) == 1
assert to_int(parseLongDouble("-2.9")) == -2
assert to_integer(parseLongDouble("255.9"), uint8) == 255
assert to_integer(parseLongDouble("-0.9"), uint8) == 0
assert sqrt(to_longdouble(4)) == 2
assert pow(to_longdouble(2), to_longdouble(10)) == 1024
assert floor(parseLongDouble("-1.2")) == -2
assert ceil(parseLongDouble("-1.2")) == -1
assert round(parseLongDouble("-1.5")) == -2
assert trunc(parseLongDouble("-1.2")) == -1

for text in ["1.0000000000000000001", "-0", "0.1", "1e-100", "1e100",
             "9007199254740993", "0x1.000000000000001p0"]:
    let value = parseLongDouble(text)
    let restored = parseLongDouble($value)
    assert restored == value
    assert signbit(restored) == signbit(value)
for value in [maxLongDouble(), minPositiveLongDouble(),
              nextAfter(to_longdouble(0), to_longdouble(1))]:
    assert parseLongDouble($value) == value
assert parseLongDouble(" \t2.5\n") == parseLongDouble("2.5")
assert formatLongDouble(parseLongDouble("1.2345"), 3) == "1.23"

let nan = parseLongDouble("nan")
let inf = parseLongDouble("inf")
let zero = parseLongDouble("-0")
assert isNaN(nan) and isNaN(sqrt(to_longdouble(-1)))
assert isInf(inf) and isInf(one / to_longdouble(0))
assert not (nan == nan)
assert nan != nan
assert not (nan < one) and not (nan <= one)
assert not (nan > one) and not (nan >= one)
assert zero == 0 and signbit(zero) and not signbit(abs(zero))
assert signbit(parseLongDouble($zero))
assert cmp(zero, 0) == 0

for text in ["", "  ", "1x", "1 2", "1e", "1\0junk", "+", "nan()junk"]:
    var raised = false
    try: discard parseLongDouble(text)
    except ValueError: raised = true
    assert raised
for text in ["nan", "inf", "-inf", "9223372036854775808", "-9223372036854775809"]:
    var raised = false
    try: discard to_integer(parseLongDouble(text), int64)
    except RangeDefect: raised = true
    # low(int64)-1は仮数の短い環境ではlow(int64)に丸められうる。
    if text != "-9223372036854775809" or info.mantissaDigits >= 64:
        assert raised
var raised = false
try: discard cmp(nan, one)
except ValueError: raised = true
assert raised

doAssert not compiles(one mod one)
doAssert not compiles(one & one)
doAssert not compiles(one shl 1)

echo "Hello World"
