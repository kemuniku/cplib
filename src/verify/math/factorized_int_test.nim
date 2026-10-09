# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils
import cplib/math/factorized_int

const oracleData = block:
    let generated = gorgeEx("""python3 - <<'PY'
import math, random, sys
rng = random.Random(345)
primes = [2, 3, 5, 7, 11, 13, 17, 19]
def row(a, b, af, bf):
    n = rng.randrange(0, 9)
    def encode(fs):
        return ','.join(str(p)+':'+str(e) for p,e in fs)
    quotient = str(a//b) if b and a % b == 0 else 'invalid'
    print('|'.join([str(a), str(b), encode(af), encode(bf),
                    str(a*b), str(math.gcd(a,b)), str(math.lcm(a,b)),
                    quotient, str((a>b)-(a<b)), str(n), str(a**n),
                    str(a) if -sys.maxsize-1 <= a <= sys.maxsize else 'overflow']))
def trial(a):
    a = abs(a)
    fs = []
    p = 2
    while p*p <= a:
        e = 0
        while a % p == 0:
            a //= p
            e += 1
        if e: fs.append((p,e))
        p += 1
    if a > 1: fs.append((a,1))
    return fs
for a in range(-24,25):
    for b in range(-24,25):
        row(a,b,trial(a),trial(b))
for _ in range(192):
    af = [(p,rng.randrange(0,25)) for p in primes if rng.randrange(2)]
    bf = [(p,rng.randrange(0,25)) for p in primes if rng.randrange(2)]
    a = rng.choice([-1,1])*math.prod(p**e for p,e in af)
    b = rng.choice([-1,1])*math.prod(p**e for p,e in bf)
    row(a,b,af,bf)
# 2 と 3 の冪の近接値、および 2^53 前後の浮動小数点で区別しにくい値。
for a,b,af,bf in [(2**84,3**53,[(2,84)],[(3,53)]),
                  (2**53,2**53+1,[(2,53)],[(3,1),(107,1),(28059810762433,1)])]:
    row(a,b,af,bf)
    row(-a,-b,af,bf)
PY""")
    doAssert generated.exitCode == 0, generated.output
    generated.output

proc decode(s: string, sign: int): FactorizedInt =
    var factors: seq[(int, int)]
    if s.len > 0:
        for part in s.split(','):
            let pair = part.split(':')
            factors.add((parseInt(pair[0]), parseInt(pair[1])))
    initFactorizedInt(factors, sign)

proc decimalSign(s: string): int =
    if s == "0": 0
    elif s[0] == '-': -1
    else: 1

var oracleCases = 0
for line in oracleData.splitLines:
    if line.len == 0: continue
    inc oracleCases
    let fields = line.split('|')
    let a = decode(fields[2], decimalSign(fields[0]))
    let b = decode(fields[3], decimalSign(fields[1]))
    doAssert $a == fields[0]
    doAssert $b == fields[1]
    doAssert $(a * b) == fields[4]
    if not b.isZero: doAssert (a * b) div b == a
    doAssert $gcd(a, b) == fields[5]
    doAssert $lcm(a, b) == fields[6]
    doAssert gcd(a, b) * lcm(a, b) == abs(a * b)
    if fields[7] == "invalid":
        doAssertRaises(ValueError): discard a div b
    else:
        doAssert $(a div b) == fields[7]
        doAssert (a div b) * b == a
    let comparison = parseInt(fields[8])
    doAssert cmp(a, b) == comparison
    doAssert (a < b) == (comparison < 0)
    doAssert (a <= b) == (comparison <= 0)
    doAssert (a > b) == (comparison > 0)
    doAssert (a >= b) == (comparison >= 0)
    doAssert (a == b) == (comparison == 0)
    doAssert $a.pow(parseInt(fields[9])) == fields[10]
    doAssert $(-a) == (if fields[0] == "0": "0"
        elif fields[0][0] == '-': fields[0][1..^1] else: "-" & fields[0])
    doAssert $abs(a) == (if fields[0][0] == '-': fields[0][1..^1] else: fields[0])
    if fields[11] == "overflow":
        doAssertRaises(OverflowDefect): discard a.toInt
    else:
        doAssert a.toInt == parseInt(fields[11])
        doAssert initFactorizedInt(parseInt(fields[11])) == a

doAssert oracleCases == 2597

block:
    var zero: FactorizedInt
    doAssert zero.isZero and zero.sgn == 0
    doAssert zero.primeFactors.len == 0
    doAssert zero.toInt == 0 and $zero == "0"
    doAssert zero.pow(0) == initFactorizedInt(1)
    doAssert zero.pow(high(int)) == zero
    for x in [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]:
        let f = initFactorizedInt(x)
        doAssert f.toInt == x
        doAssert $f == $x
    for exponent in 0..<sizeof(int)*8:
        let neg = initFactorizedInt(@[(2, exponent)], -1)
        if exponent < sizeof(int)*8 - 1:
            doAssert neg.toInt == -(1 shl exponent)
            doAssert (-neg).toInt == 1 shl exponent
        else:
            doAssert neg.toInt == low(int)
            doAssertRaises(OverflowDefect): discard (-neg).toInt
    doAssertRaises(OverflowDefect): discard initFactorizedInt(@[(2, sizeof(int)*8)]).toInt
    doAssertRaises(OverflowDefect): discard initFactorizedInt(@[(2147483647, 4)]).toInt

block:
    var input = @[(7, 2), (2, 0), (3, 2), (7, 1), (2, 3)]
    let x = initFactorizedInt(input, -1)
    doAssert x.primeFactors == @[(2, 3), (3, 2), (7, 3)]
    input[0] = (2, 999)
    var copy = x.primeFactors
    copy[0] = (3, 999)
    doAssert x.primeFactors == @[(2, 3), (3, 2), (7, 3)]
    var y = x
    y = y.pow(2)
    doAssert x.sgn == -1 and x.primeFactors == @[(2, 3), (3, 2), (7, 3)]
    doAssert y.primeFactors == @[(2, 6), (3, 4), (7, 6)]
    doAssert initFactorizedInt(@[(2, 0)], 0).isZero
    doAssert initFactorizedInt(@[(2, 0)], -1) == initFactorizedInt(-1)
    for bad in [@[(0, 1)], @[(1, 1)], @[(-2, 1)], @[(4, 1)], @[(9, 0)], @[(2, -1)], @[(2, low(int))]]:
        doAssertRaises(ValueError): discard initFactorizedInt(bad)
    for sign in [low(int), -2, 2, high(int)]:
        doAssertRaises(ValueError): discard initFactorizedInt(@[(2, 1)], sign)
    doAssertRaises(ValueError): discard initFactorizedInt(@[(2, 1)], 0)
    for exponent in [low(int), -1]:
        for value in [-1, 0, 1, 2]:
            doAssertRaises(ValueError): discard initFactorizedInt(value).pow(exponent)

block:
    let huge = initFactorizedInt(@[(2, high(int))])
    let next = initFactorizedInt(@[(2, high(int) - 1)])
    let one = initFactorizedInt(1)
    let zero = initFactorizedInt(0)
    doAssert huge * one == huge
    doAssert huge * zero == zero
    doAssert huge div huge == one
    doAssert huge div next == initFactorizedInt(2)
    doAssert gcd(huge, next) == next
    doAssert lcm(huge, next) == huge
    doAssert huge.pow(1) == huge
    doAssert huge.pow(0) == one
    doAssert cmp(huge, huge) == 0
    doAssert cmp(-huge, huge) == -1
    doAssertRaises(OverflowDefect): discard huge * initFactorizedInt(2)
    doAssertRaises(OverflowDefect): discard huge.pow(2)
    doAssertRaises(OverflowDefect): discard initFactorizedInt(@[(2, high(int)), (2, 1)])
    doAssertRaises(OverflowDefect): discard huge.toInt
    doAssertRaises(ValueError): discard one div huge
    doAssertRaises(ValueError): discard huge div zero
    doAssertRaises(ValueError): discard zero div zero
    doAssert huge.primeFactors == @[(2, high(int))]
    doAssert initFactorizedInt(-1).pow(high(int)) == initFactorizedInt(-1)
    doAssert initFactorizedInt(@[(2, high(int) div 2)]).pow(2).primeFactors == @[(2, high(int) - 1)]

echo "Hello World"
