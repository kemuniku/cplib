# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/str/static_string
import cplib/str/suffix_array

proc literalCmp[T](a, b: StaticString[T]): int =
    for i in 0..<min(a.len, b.len):
        let c = system.cmp(a[i], b[i])
        if c != 0: return c
    return system.cmp(a.len, b.len)

proc checkComparisons[T](s: StaticString[T]) =
    var parts: seq[StaticString[T]]
    for l in 0..s.len:
        for r in l..s.len:
            parts.add(s[l..<r])
            parts.add(s[l..<r].reversed)
    for a in parts:
        for b in parts:
            doAssert cmp(a, b) == literalCmp(a, b)
    for index in 0..<parts.len:
        let part = parts[index]
        var expected = toSeq(0..<part.len)
        expected.sort(proc(a, b: int): int = literalCmp(part[a..<part.len], part[b..<part.len]))
        let actual = part.initSuffixArray()
        doAssert actual.len == expected.len
        for i, pos in expected:
            doAssert actual[i].l == part.l + pos
            doAssert actual[i].r == part.r

for text in ["", "a", "aaaaa", "banana", "abababa", "\x00\xFF\x80\x00\xFF"]:
    let values = @text
    doAssert suffix_array(values) == suffix_array(text)
    for reversible in [false, true]:
        let a = initStaticStringBase(text, reversible)
        let b = initStaticStringBase(values, reversible)
        doAssert a.SA == b.SA
        doAssert a.LCP == b.LCP
        doAssert initSuffixArray(a).mapIt($it) == initSuffixArray(b).mapIt($it)
    checkComparisons(toStaticString(values, true))

checkComparisons(toStaticString(newSeq[int](), true))
checkComparisons(toStaticString(@[-5, 3, -5, 3, -5, 8], true))

var rng = initRand(20260917)
for trial in 0..<30:
    var text = newString(rng.rand(80))
    for c in text.mitems: c = char(rng.rand(255))
    let values = @text
    var expected = toSeq(0..<text.len)
    expected.sort(proc(a, b: int): int = system.cmp(text[a..^1], text[b..^1]))
    doAssert suffix_array(values) == expected
    doAssert toStaticString(values).base.SA.mapIt(int(it)) == expected

let one = toStaticString("a")
let another = toStaticString("a")
var rejected = false
try:
    discard cmp(one[0..<0], another[0..<0])
except AssertionDefect:
    rejected = true
doAssert rejected

echo "Hello World"
