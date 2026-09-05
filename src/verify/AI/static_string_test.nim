# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/str/static_string

let directlyEmpty = toStaticString("")
assert directlyEmpty.len == 0
assert $directlyEmpty == ""
assert directlyEmpty.base.SA == @[]
assert directlyEmpty.base.LCP == @[]
assert initSuffixArray(directlyEmpty).len == 0

let directlyEmptyInts = toStaticString(newSeq[int]())
assert directlyEmptyInts.len == 0
assert directlyEmptyInts.base.SA == @[]

let s = toStaticString("banana")
assert $s == "banana"
assert s.len == 6
assert s[1] == 'a'
assert $s[1..3] == "ana"
assert lcp(s[1..5], s[3..5]) == 3
assert cmp(s[1..3], s[3..5]) == 0
assert s[1..3] == s[3..5]
assert s[0..2] > s[1..3]
let sa1 = initSuffixArray(s.base).mapIt($it)
assert sa1[0] == "a"
let sa2 = initSuffixArray(s).mapIt($it)
assert sa2[0] == "a"
let ss = toStaticStrings(@["aba", "abc"])
assert ss[0].startsWith(ss[0][0..1])
assert ss[0].base.count("ab") == 2
assert ss[0].base.suffix_lowerbound("ab") < ss[0].base.suffix_upperbound("ab")

let plain = toStaticString("foobarbar")
let reversible = toStaticString("foobarbar", reversible=true)
assert reversible.base.S == "foobarbar" & "rabraboof"
assert reversible.base.SA.len == 2*reversible.len
assert reversible.base.RSA.len == 2*reversible.len
assert reversible.base.LCP.len == 2*reversible.len-1
assert initSuffixArray(reversible.base).mapIt($it) == initSuffixArray(plain.base).mapIt($it)
assert $reversible.reversed == "rabraboof"
assert $reversible[1..4].reversed == "aboo"
assert reversible.reversed.reversed == reversible
assert reversible[1..2].is_palindrome
assert not reversible[0..5].is_palindrome
assert lcs(reversible[0..5], reversible[3..8]) == 3
let empty = reversible[0..<0]
assert empty.reversed.len == 0
assert empty.is_palindrome
assert lcs(empty, reversible) == 0

let reversibleStrings = toStaticStrings(@["racecar", "racer"], reversible=true)
assert reversibleStrings[0].is_palindrome
assert not reversibleStrings[1].is_palindrome
assert $reversibleStrings[1].reversed == "recar"

let integers = toStaticString([1, 2, 1, 3, 2, 1], reversible=true)
assert integers.base.S == @[1, 2, 1, 3, 2, 1, 1, 2, 3, 1, 2, 1]
assert $integers == "1 2 1 3 2 1"
assert $integers.reversed == "1 2 3 1 2 1"
assert integers[0..2].is_palindrome
assert lcs(integers[0..2], integers[3..5]) == 2

let integerPlain = toStaticString([1, 2, 1, 2, 1])
assert integerPlain.base.count([1, 2]) == 2
let integerSA = initSuffixArray(integerPlain)
assert $integerSA[0] == "1"

let chars = toStaticString(@['a', 'b', 'a'], reversible=true)
assert $chars == "aba"
assert $chars.reversed == "aba"
assert chars.base.SA == toStaticString("aba", reversible=true).base.SA
assert chars.base.LCP == toStaticString("aba", reversible=true).base.LCP
