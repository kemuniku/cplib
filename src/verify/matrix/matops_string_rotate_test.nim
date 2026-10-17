# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils, strutils
import cplib/matrix/matops

proc oracle(a: seq[string], num: int): seq[string] =
    result = a
    var h = a.len
    var w = if h == 0: 0 else: a[0].len
    var turns = num mod 4
    if turns < 0: turns += 4
    for step in 0..<turns:
        result.reverse()
        var columns = newSeq[string](w)
        for row in result:
            for c, value in row:
                columns[c].add(value)
        result = columns
        swap(h, w)

proc check(a: seq[string], num: int) =
    let saved = a
    let expected = oracle(a, num)
    var actual = a.rotated(num)
    doAssert actual == expected
    doAssert actual == a.mapIt(it.toSeq).rotated(num).mapIt(it.join(""))
    doAssert a == saved
    var inplace = a
    inplace.rotate(num)
    doAssert inplace == expected
    doAssert a == saved
    if actual.len > 0:
        if actual[0].len > 0:
            actual[0][0] = char(ord(actual[0][0]) xor 255)
        else:
            actual[0].add('x')
        doAssert a == saved
        doAssert inplace == expected

let rectangle = @["abc", "def"]
doAssert rectangle.rotated() == @["da", "eb", "fc"]
doAssert rectangle.rotated(0) == rectangle
doAssert rectangle.rotated(2) == @["fed", "cba"]
doAssert rectangle.rotated(3) == @["cf", "be", "ad"]
doAssert rectangle.rotated(-1) == @["cf", "be", "ad"]
var defaultRotate = rectangle
defaultRotate.rotate()
doAssert defaultRotate == rectangle.rotated()
doAssert newSeq[string]().rotated() == newSeq[string]()
doAssert @["", ""].rotated(0) == @["", ""]
doAssert @["", ""].rotated(1) == newSeq[string]()
doAssert @["", ""].rotated(2) == @["", ""]
doAssert @["", ""].rotated(3) == newSeq[string]()

let turns = @[-9, -8, -7, -6, -5, -4, -3, -2, -1, 0, 1, 2, 3,
              4, 5, 6, 7, 8, 9, low(int), low(int)+1, high(int)-1, high(int)]
for h in 0..16:
    for w in 0..16:
        var a = newSeq[string](h)
        for i in 0..<h:
            a[i] = newString(w)
            for j in 0..<w:
                a[i][j] = char((i*17+j) mod 256)
        for num in turns:
            check(a, num)

var rng = initRand(428)
for trial in 0..<500:
    let h = rng.rand(65)
    let w = rng.rand(65)
    var a = newSeq[string](h)
    for i in 0..<h:
        a[i] = newString(w)
        for j in 0..<w:
            a[i][j] = char(rng.rand(255))
    for num in -4..4:
        check(a, num)
    if h > 0 and w > 0:
        var b = a
        for step in 0..<4: b.rotate()
        doAssert b == a
        doAssert a.rotated(1).rotated(-1) == a

for (h, w) in [(1, 1025), (1025, 1), (31, 129), (129, 31), (257, 257)]:
    var a = newSeq[string](h)
    for i in 0..<h:
        a[i] = newString(w)
        for j in 0..<w: a[i][j] = char((i+j) mod 256)
    for num in turns: check(a, num)

var bytes = newString(256)
for i in 0..255: bytes[i] = char(i)
for num in turns:
    check(@[bytes], num)
    check(@["\x00\xFF", "\x80\x01"], num)
    check(@["あ", "い"], num)

static:
    doAssert @["abc", "def"].rotated(-1) == @["cf", "be", "ad"]
    doAssert @["", ""].rotated(2) == @["", ""]

echo "Hello World"
