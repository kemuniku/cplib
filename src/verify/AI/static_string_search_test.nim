# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/str/static_string
import cplib/str/static_string_search

proc literalPositions[T](s, pattern: StaticString[T]): seq[int] =
    if pattern.len > s.len:
        return
    for start in 0..s.len-pattern.len:
        var matches = true
        for i in 0..<pattern.len:
            if s[start+i] != pattern[i]:
                matches = false
                break
        if matches:
            result.add(start)

proc checkSearch[T](search: StaticStringSearch[T], s, pattern: StaticString[T]) =
    let expected = literalPositions(s, pattern)
    doAssert search.contains(s, pattern) == (expected.len > 0)
    doAssert search.count(s, pattern) == expected.len
    doAssert (pattern in s) == (expected.len > 0)
    doAssert (pattern notin s) == (expected.len == 0)
    doAssert s.count(pattern) == expected.len
    let target = search[s]
    doAssert (pattern in target) == (expected.len > 0)
    doAssert (pattern notin target) == (expected.len == 0)
    doAssert target.count(pattern) == expected.len
    var actual: seq[int]
    for position in target.findAll(pattern):
        actual.add(position)
    doAssert actual == expected
    actual.setLen(0)
    for position in s.findAll(pattern):
        actual.add(position)
    doAssert actual == expected

proc checkIntervals[T](s: StaticString[T]) =
    let search = initStaticStringSearch(s.base)
    var parts: seq[StaticString[T]]
    for l in 0..s.len:
        for r in l..s.len:
            parts.add(s[l..<r])
            if s.base.reversible:
                parts.add(s[l..<r].reversed)
    for a in parts:
        for b in parts:
            checkSearch(search, a, b)
    clearStaticStringSearchCache(s.base)

block:
    let parts = toStaticStrings(["banana", "ana", "apple"])
    doAssert parts[1] in parts[0]
    doAssert parts[2] notin parts[0]
    let cached = initStaticStringSearch(parts[0].base)
    doAssert cached == initStaticStringSearch(parts[0].base)
    doAssert parts[0].count(parts[1]) == 2
    doAssert cached == initStaticStringSearch(parts[0].base)
    var positions: seq[int]
    for position in parts[0].findAll(parts[1]):
        clearStaticStringSearchCache()
        positions.add(position)
    doAssert positions == @[1, 3]
    doAssert cached != initStaticStringSearch(parts[0].base)
    doAssert cached.contains(parts[0], parts[1])
    clearStaticStringSearchCache()

block:
    let a = toStaticString("banana")
    let b = toStaticString("banana")
    let numbers = toStaticString([1, 2, 1, 2])
    let first = initStaticStringSearch(a.base)
    let second = initStaticStringSearch(b.base)
    let numeric = initStaticStringSearch(numbers.base)
    doAssert first != second
    doAssert a[1..<4] in a
    doAssert b[1..<4] in b
    doAssert numbers[0..<2] in numbers
    doAssert first == initStaticStringSearch(a.base)
    doAssert second == initStaticStringSearch(b.base)
    doAssert numeric == initStaticStringSearch(numbers.base)
    clearStaticStringSearchCache(a.base)
    clearStaticStringSearchCache(a.base)
    doAssert first != initStaticStringSearch(a.base)
    doAssert second == initStaticStringSearch(b.base)
    doAssert numeric == initStaticStringSearch(numbers.base)
    clearStaticStringSearchCache()
    clearStaticStringSearchCache()
    doAssert first.contains(a, a[1..<4])
    doAssert second != initStaticStringSearch(b.base)
    doAssert numeric != initStaticStringSearch(numbers.base)
    clearStaticStringSearchCache()

for n in 0..5:
    for mask in 0..<(1 shl n):
        var text = newString(n)
        for i in 0..<n:
            text[i] = char(ord('a') + ((mask shr i) and 1))
        for reversible in [false, true]:
            checkIntervals(toStaticString(text, reversible))

for text in ["banana", "aaaaaa", "\x00\xFF\x80\x00\xFF", "a$b$$a"]:
    for reversible in [false, true]:
        checkIntervals(toStaticString(text, reversible))

checkIntervals(toStaticString(newSeq[int](), true))
checkIntervals(toStaticString(@[-5, 3, -5, 3, -5, 8], true))

let strings = toStaticStrings(["banana", "ana", "nan", "apple", "", "a", "aa"], true)
let search = initStaticStringSearch(strings[0].base)
for s in strings:
    for pattern in strings:
        checkSearch(search, s, pattern)
        checkSearch(search, s.reversed, pattern)
doAssert search.contains(strings[0], strings[1])
doAssert not search.contains(strings[0][0..<3], strings[1])
doAssert not search.contains(strings[0][3..<6], strings[2])
doAssert not search.contains(strings[5], strings[6])

doAssert search.count(strings[0], strings[1]) == 2
var positions: seq[int]
for position in search.findAll(strings[0][1..<6], strings[1]):
    positions.add(position)
doAssert positions == @[0, 2]
var yielded = 0
for position in search[strings[0]].findAll(strings[1]):
    doAssert position == 1
    inc yielded
    break
doAssert yielded == 1

var rng = initRand(20260926)
for n in [63, 64, 65, 127, 128, 129, 511]:
    var values = newSeq[int](n)
    for value in values.mitems:
        value = rng.rand(4) - 2
    let s = toStaticString(values, true)
    let search = initStaticStringSearch(s.base)
    for trial in 0..<1000:
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let pl = rng.rand(n)
        let pr = rng.rand(pl..min(n, pl + 12))
        var a = s[l..<r]
        var b = s[pl..<pr]
        if rng.rand(1) == 1: a = a.reversed
        if rng.rand(1) == 1: b = b.reversed
        checkSearch(search, a, b)
    clearStaticStringSearchCache(s.base)

template expectAssertion(body: untyped) =
    block:
        var rejected = false
        try:
            body
        except AssertionDefect:
            rejected = true
        doAssert rejected

let one = toStaticString("a")
let another = toStaticString("a")
let oneSearch = initStaticStringSearch(one.base)
for s in [one, one[0..<0], another, another[0..<0]]:
    for pattern in [one, one[0..<0], another, another[0..<0]]:
        if s.base == one.base and pattern.base == one.base:
            continue
        expectAssertion:
            discard oneSearch.contains(s, pattern)
        expectAssertion:
            discard oneSearch.count(s, pattern)
        expectAssertion:
            discard pattern in oneSearch[s]
        expectAssertion:
            discard pattern notin oneSearch[s]
        expectAssertion:
            for position in oneSearch.findAll(s, pattern):
                discard position
        if s.base != pattern.base:
            expectAssertion:
                discard pattern in s
            expectAssertion:
                discard pattern notin s
            expectAssertion:
                discard s.count(pattern)
            expectAssertion:
                for position in s.findAll(pattern):
                    discard position

expectAssertion:
    discard oneSearch[another]
expectAssertion:
    discard oneSearch[another[0..<0]]

clearStaticStringSearchCache()
echo "Hello World"
