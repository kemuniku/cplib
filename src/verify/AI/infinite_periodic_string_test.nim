# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/infinite_periodic_string
import strutils

template expectError(errorType: typedesc, body: untyped) =
    block:
        var rejected = false
        try:
            body
        except errorType:
            rejected = true
        doAssert rejected

proc words(maxLength: int): seq[string] =
    result.add("")
    for length in 1..maxLength:
        for mask in 0..<(1 shl length):
            var word = newString(length)
            for i in 0..<length:
                word[i] = if (mask and (1 shl i)) == 0: 'a' else: 'b'
            result.add(word)

proc materialize(period: string, length: int): string =
    while result.len < length:
        result.add(period)
    result.setLen(length)

proc sign(value: int): int =
    if value < 0: -1
    elif value > 0: 1
    else: 0

let periods = words(6)
let patterns = words(7)
var infinite: seq[InfinitePeriodicString]
for i in 1..<periods.len:
    infinite.add(initInfinitePeriodicString(periods[i]))
    let actual = infinite[^1]
    let period = periods[i]
    let oracle = materialize(period, 5 * period.len + 10)
    for first in 0..(2 * period.len + 2):
        doAssert actual[first] == oracle[first]
        for length in 0..(2 * period.len + 2):
            let expected = oracle[first..<(first + length)]
            doAssert actual.slice(first, length) == expected
            doAssert actual[first..<(first + length)] == expected
    for pattern in patterns:
        let text = materialize(period, period.len + pattern.len)
        doAssert actual.contains(pattern) == text.contains(pattern)
        doAssert (pattern in actual) == text.contains(pattern)
    for c in ['a', 'b', 'c', '\0', char(255)]:
        doAssert actual.contains(c) == period.contains(c)

for i, left in infinite:
    for j, right in infinite:
        let length = periods[i + 1].len * periods[j + 1].len
        let a = materialize(periods[i + 1], length)
        let b = materialize(periods[j + 1], length)
        let expected = sign(cmp(a, b))
        doAssert cmp(left, right) == expected
        doAssert (left == right) == (expected == 0)
        doAssert (left != right) == (expected != 0)
        doAssert (left < right) == (expected < 0)
        doAssert (left <= right) == (expected <= 0)
        doAssert (left > right) == (expected > 0)
        doAssert (left >= right) == (expected >= 0)

let ab = initInfinitePeriodicString("ab")
doAssert ab == initInfinitePeriodicString("abababab")
doAssert ab.contains("babababababababa")
doAssert not ab.contains("babababababababb")
doAssert cmp(initInfinitePeriodicString("aab"), initInfinitePeriodicString("aaba")) > 0
doAssert ab[high(int)] == 'b'
doAssert ab[high(int) - 1] == 'a'
doAssert ab[high(int)..high(int)] == "b"
doAssert ab.slice(high(int), 5) == "babab"
doAssert ab.slice(high(int), 0, 0) == ""
doAssert ab[0..<0] == ""
doAssert ab[high(int)..<high(int)] == ""
doAssert ab.slice(0, InfinitePeriodicStringDefaultSliceLimit).len == InfinitePeriodicStringDefaultSliceLimit
doAssert ab[0..<InfinitePeriodicStringDefaultSliceLimit].len == InfinitePeriodicStringDefaultSliceLimit
doAssert ab.slice(0, 12, 12) == "abababababab"
doAssert ab.slice(0, InfinitePeriodicStringDefaultSliceLimit + 1,
    InfinitePeriodicStringDefaultSliceLimit + 1).len == InfinitePeriodicStringDefaultSliceLimit + 1

expectError(ValueError):
    discard initInfinitePeriodicString("")
expectError(IndexDefect):
    discard ab[-1]
expectError(IndexDefect):
    discard ab[low(int)]
expectError(IndexDefect):
    discard ab[-1..0]
expectError(IndexDefect):
    discard ab[0.. -2]
expectError(IndexDefect):
    discard ab[3..1]
expectError(IndexDefect):
    discard ab[0..low(int)]
expectError(IndexDefect):
    discard ab.slice(-1, 0)
expectError(ValueError):
    discard ab.slice(0, -1)
expectError(ValueError):
    discard ab.slice(0, 0, -1)
expectError(ValueError):
    discard ab.slice(0, 13, 12)
expectError(ValueError):
    discard ab.slice(0, high(int))
expectError(ValueError):
    discard ab.slice(0, high(int), high(int))
expectError(ValueError):
    discard ab.slice(0, high(int) div 2 + 1, high(int))
expectError(ValueError):
    discard ab[0..high(int)]
expectError(ValueError):
    discard ab[1..high(int)]
expectError(ValueError):
    discard ab[0..InfinitePeriodicStringDefaultSliceLimit]

var invalid: InfinitePeriodicString
expectError(ValueError):
    discard invalid[0]
expectError(ValueError):
    discard invalid.slice(0, 0)
expectError(ValueError):
    discard invalid[0..<0]
expectError(ValueError):
    discard invalid.contains("")
expectError(ValueError):
    discard invalid.contains('a')
expectError(ValueError):
    discard cmp(ab, invalid)
expectError(ValueError):
    discard invalid == invalid
doAssert not compiles(len(ab))
doAssert not compiles(ab[^1])
doAssert not compiles(ab[0..^1])

var original = "abc"
let owned = initInfinitePeriodicString(original)
original[0] = 'z'
original.setLen(0)
doAssert owned[0..5] == "abcabc"
var output = owned[0..5]
output[0] = 'z'
doAssert owned[0] == 'a'

var bytes = newString(256)
for i in 0..255:
    bytes[i] = char(i)
let allBytes = initInfinitePeriodicString(bytes)
for i in 0..255:
    doAssert allBytes[i] == char(i)
    doAssert allBytes.contains(char(i))
doAssert allBytes.contains("\xFF\0\x01")
doAssert not allBytes.contains("\xFF\0\x02")
doAssert initInfinitePeriodicString("\x80") > initInfinitePeriodicString("\x7F")
doAssert initInfinitePeriodicString("\xFF") > initInfinitePeriodicString("\0")

let largeA = initInfinitePeriodicString(repeat('a', 20011))
let largeB = initInfinitePeriodicString(repeat('a', 20021))
doAssert largeA == largeB
doAssert largeA.contains(repeat('a', 100001))
doAssert not largeA.contains(repeat('a', 100001) & "b")
let late = initInfinitePeriodicString(repeat('a', 20020) & "b")
doAssert late > largeA
doAssert late.contains("ba")

echo "Hello World"
