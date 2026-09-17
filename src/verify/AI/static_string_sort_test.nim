# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/str/static_string

proc check[T](input: seq[StaticString[T]]) =
    var expected = toSeq(0..<input.len)
    expected.sort(proc(a, b: int): int =
        for i in 0..<min(input[a].len, input[b].len):
            let c = system.cmp(input[a][i], input[b][i])
            if c != 0: return c
        let c = system.cmp(input[a].len, input[b].len)
        if c != 0: return c
        system.cmp(a, b))
    var actual = input
    actual.sortStaticStrings()
    doAssert actual.len == input.len
    for i, index in expected:
        doAssert actual[i].base == input[index].base
        doAssert actual[i].l == input[index].l
        doAssert actual[i].r == input[index].r

proc checkIntervals[T](s: StaticString[T]) =
    var parts: seq[StaticString[T]]
    for l in 0..s.len:
        for r in l..s.len:
            parts.add(s[l..<r])
            parts.add(s[l..<r].reversed)
    parts.reverse()
    check(parts)

check(newSeq[StaticString[char]]())
for n in 0..8:
    for mask in 0..<(1 shl n):
        var s = newString(n)
        for i in 0..<n: s[i] = char(ord('a') + ((mask shr i) and 1))
        checkIntervals(toStaticString(s, reversible = true))

var rng = initRand(20260917)
for trial in 0..<50:
    var values = newSeq[int](rng.rand(30))
    for v in values.mitems: v = rng.rand(10)-5
    checkIntervals(toStaticString(values, reversible = true))

check(toStaticStrings(["ab", "a", "", "ab", "abc", "a", ""]))
let s = toStaticString("banana")
var parts = [s[0..<3], s[1..<4], s[3..<6]]
parts.sortStaticStrings()
doAssert parts.mapIt($it) == @["ana", "ana", "ban"]
doAssert parts[0].l == 1 and parts[1].l == 3
var single = @[s]
single.sortStaticStrings()
doAssert single[0].l == s.l and single[0].r == s.r

echo "Hello World"
