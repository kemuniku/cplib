# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/rolling_hash

const oracleMod = (1u shl 61) - 1

proc oracleMul(a, b: uint): uint =
    var x = a mod oracleMod
    var y = b mod oracleMod
    while y > 0:
        if (y and 1) != 0:
            result = (result + x) mod oracleMod
        x = (x + x) mod oracleMod
        y = y shr 1

let oracleBase = initRollingHash([0, 1]).query(0..1)

proc oracleHash[T](s: openArray[T], l, r: int): uint =
    var power = 1u
    for i in l..<r:
        result = (result + oracleMul(uint(s[i]), power)) mod oracleMod
        power = oracleMul(power, oracleBase)

proc checkQueries[T](s: openArray[T]) =
    let rh = initRollingHash(s)
    for l in 0..s.len:
        for r in l..s.len:
            let expected = oracleHash(s, l, r)
            doAssert rh.query(l..<r) mod oracleMod == expected
            doAssert rh.query(l..(r-1)) mod oracleMod == expected
            if l == r:
                doAssert rh.query(l..<r) == oracleMod
    when compileOption("assertions"):
        for l in -2..s.len+2:
            for b in -3..s.len+2:
                if l >= 0 and l <= s.len and b >= -1 and b < s.len and l <= b+1:
                    continue
                var rejected = false
                try:
                    discard rh.query(l..b)
                except AssertionDefect:
                    rejected = true
                doAssert rejected
        for invalid in [int.low..int.high, 0..int.high, int.high..int.high,
                        int.low..(-1), 0..int.low, int.high..(-1)]:
            var rejected = false
            try:
                discard rh.query(invalid)
            except AssertionDefect:
                rejected = true
            doAssert rejected

for n in 0..6:
    var count = 1
    for i in 0..<n:
        count *= 3
    for mask in 0..<count:
        var values = newSeq[int](n)
        var remaining = mask
        for i in 0..<n:
            values[i] = remaining mod 3
            remaining = remaining div 3
        checkQueries(values)

checkQueries([0, 1, 1000000000, 2, 0])
checkQueries(newSeq[char]())
checkQueries(['\0', 'a', '\xff', 'a', '\0'])

for s in ["", "a", "banana", "abcabc", "\0a\xffa\0"]:
    let rh = initRollingHash(s)
    for l in 0..s.len:
        for r in l..s.len:
            doAssert rh.query(l..<r) mod oracleMod == oracleHash(s, l, r)
            if l == r:
                doAssert rh.query(l..<r) == oracleMod
    when compileOption("assertions"):
        for invalid in [1..(-1), 2..0, (-1)..0, 0..s.len, 0..int.high]:
            var rejected = false
            try:
                discard rh.query(invalid)
            except AssertionDefect:
                rejected = true
            doAssert rejected

echo "Hello World"
