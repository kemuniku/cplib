# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/palindromic_tree
import random, strutils

proc isPalindrome[T](a: seq[T], first, last: int): bool =
    for i in 0..<(last - first + 1) div 2:
        if a[first + i] != a[last - i]: return false
    return true

proc check[T, alphabet](pt: PalindromicTree[T, alphabet]) =
    doAssert pt.nodes[0].diff == 0
    doAssert pt.nodes[1].diff == 0
    doAssert pt.nodes[0].series_link == nil
    doAssert pt.nodes[1].series_link == pt.nodes[0]
    for node in pt.nodes[2..<pt.nodes.len]:
        let a = pt.get_palindrome(node)
        var suffixLengths: seq[int]
        for length in countdown(a.len - 1, 0):
            if isPalindrome(a, a.len - length, a.len - 1):
                suffixLengths.add(length)
        let expectedDiff = a.len - suffixLengths[0]
        var expectedLength = 0
        for i in 0..<suffixLengths.len - 1:
            if suffixLengths[i] - suffixLengths[i + 1] != expectedDiff:
                expectedLength = suffixLengths[i]
                break
        doAssert node.diff == expectedDiff
        doAssert node.series_link != nil
        doAssert node.series_link.len == expectedLength
        doAssert pt.get_palindrome(node.series_link) == a[a.len - expectedLength..<a.len]
        if expectedLength == 0:
            doAssert node.series_link == pt.nodes[1]

proc exhaust(a: var seq[int], sigma, remaining: int) =
    initPalindromicTree(a, 0..2).check()
    if remaining == 0: return
    for value in 0..<sigma:
        a.add(value)
        exhaust(a, sigma, remaining - 1)
        a.setLen(a.len - 1)

var a: seq[int]
exhaust(a, 2, 10)
exhaust(a, 3, 7)
for s in ["", "a", "aaaaaa", "abababa", "abacaba", "aabbaa", "abcbaabcba"]:
    initPalindromicTree(s).check()
initPalindromicTree(['A', 'B', 'A', 'B', 'A'], 'A'..'Z').check()
initPalindromicTree(@[0, 100, 0, 100, 0], 0..100).check()

var rng = initRand(812731)
for trial in 0..<300:
    var values = newSeq[int](rng.rand(1..100))
    for value in values.mitems:
        value = rng.rand(0..3)
    initPalindromicTree(values, 0..3).check()

let repeated = initPalindromicTree(repeat('a', 20000))
for node in repeated.nodes[2..<repeated.nodes.len]:
    doAssert node.diff == 1
    doAssert node.series_link == repeated.nodes[1]

echo "Hello World"
