# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, math, random
import cplib/math/garner
import cplib/math/crt
import cplib/math/bigint

proc normalized(a, m: int): int =
    result = a mod m
    if result < 0: result += m

proc inverseBig(a, m: BigInt): BigInt =
    var u = a
    var v = m
    var x = initBigInt(1)
    var y = initBigInt(0)
    while v != 0:
        let q = u div v
        (u, v) = (v, u - q * v)
        (x, y) = (y, x - q * y)
    doAssert u == 1
    result = x mod m
    if result < 0: result += m

proc oracle(r, m: seq[int], target: int): int =
    var product = initBigInt(1)
    for modulus in m: product *= initBigInt(modulus)
    var sum = initBigInt(0)
    for i in 0..<m.len:
        if m[i] == 1: continue
        let modulus = initBigInt(m[i])
        let cofactor = product div modulus
        sum += initBigInt(r[i]) * cofactor * inverseBig(cofactor, modulus)
    var solution = sum mod product
    if solution < 0: solution += product
    for i in 0..<m.len:
        doAssert (solution mod initBigInt(m[i])).toInt() == normalized(r[i], m[i])
    return (solution mod initBigInt(target)).toInt()

var checks = 0
proc check(r, m: seq[int], target: int) =
    let expected = oracle(r, m, target)
    doAssert garner(r, m, target) == expected
    var rr = r
    var mm = m
    rr.reverse()
    mm.reverse()
    doAssert garner(rr, mm, target) == expected
    doAssert r.len == m.len
    inc checks

doAssert garner([], [], 7) == 0
doAssert garner([2, 3, 2], [3, 5, 7], 100) == 23
doAssert garner([2, 3, 2], [3, 5, 7], 6) == 5
doAssert garner([-1, -1], [3, 5], 7) == 0
doAssert garner([low(int), high(int)], [1, 1], high(int)) == 0

for a in 1..12:
    for b in 1..12:
        if gcd(a, b) != 1: continue
        for r0 in 0..<a:
            for r1 in 0..<b:
                var solution = -1
                for x in 0..<a * b:
                    if x mod a == r0 and x mod b == r1:
                        doAssert solution == -1
                        solution = x
                doAssert solution >= 0
                doAssert oracle(@[r0, r1], @[a, b], a * b) == solution
                doAssert crt([r0, r1], [a, b]) == (solution, a * b)
                for target in [1, 2, 3, 6, 7, 12, 17, a, b, a * b, a * b + 1]:
                    doAssert garner([r0, r1], [a, b], target) == solution mod target
                    doAssert garner([r0 - a, r1 - b], [a, b], target) == solution mod target
                    inc checks

let boundaries = @[low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
let sets = @[@[high(int), high(int) - 1], @[high(int), 2],
    @[high(int) - 1, high(int) - 2], @[1, 1, high(int)],
    @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61,
      67, 71, 73, 79, 83, 89, 97, 101],
    @[1_000_000_007, 1_000_000_009, 998_244_353, high(int), high(int) - 1]]
for moduli in sets:
    for a in boundaries:
        for b in boundaries:
            var residues = newSeq[int](moduli.len)
            for i in 0..<residues.len: residues[i] = if i mod 2 == 0: a else: b
            for target in [1, 2, 6, 998_244_353, high(int) - 1, high(int)]:
                check(residues, moduli, target)

var rng = initRand(247)
let pool = @[1, 2, 3, 5, 7, 11, 97, 65537, 998_244_353,
    1_000_000_007, 1_000_000_009, high(int), high(int) - 1]
for iteration in 0..<1000:
    var residues, moduli: seq[int]
    for i in 0..<rng.rand(0..10):
        let candidate = pool[rng.rand(pool.high)]
        var coprime = true
        for m in moduli:
            if gcd(m, candidate) != 1: coprime = false
        if coprime:
            moduli.add(candidate)
            residues.add(if i mod 3 == 0: boundaries[rng.rand(boundaries.high)]
                else: rng.rand(-1_000_000_000..1_000_000_000))
    let target = if iteration mod 2 == 0: pool[rng.rand(pool.high)]
        else: rng.rand(1..1_000_000_000)
    check(residues, moduli, target)
    var period = 1
    var fits = true
    for m in moduli:
        if period > high(int) div m:
            fits = false
            break
        period *= m
    if fits: doAssert garner(residues, moduli, target) == crt(residues, moduli).r mod target

proc expectInvalid(r, m: seq[int], target: int) =
    var caught = false
    try: discard garner(r, m, target)
    except ValueError: caught = true
    doAssert caught

expectInvalid(@[0], @[], 7)
expectInvalid(@[], @[1], 7)
for bad in [0, -1, low(int)]:
    expectInvalid(@[0], @[bad], 7)
    expectInvalid(@[], @[], bad)
    expectInvalid(@[0], @[2], bad)
for target in [1, 2, high(int)]:
    expectInvalid(@[0, 0], @[2, 4], target)
    expectInvalid(@[0, 1], @[3, 3], target)
    expectInvalid(@[0, 0, 0], @[2, 3, 6], target)
    expectInvalid(@[0, 0], @[high(int), high(int)], target)
    expectInvalid(@[0, 0], @[2, 0], target)

block:
    var residues = @[low(int), high(int), -1]
    var moduli = @[3, 5, 7]
    let originalR = @residues
    let originalM = @moduli
    discard garner(residues, moduli, 6)
    doAssert residues == originalR and moduli == originalM

block:
    var residues = newSeq[int](128)
    var moduli = newSeq[int](128)
    for i in 0..<128:
        residues[i] = boundaries[i mod boundaries.len]
        moduli[i] = 1
    for i, m in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]: moduli[i * 11] = m
    check(residues, moduli, high(int))

doAssert checks > 10000
echo "Hello World"
