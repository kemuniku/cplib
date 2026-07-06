# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/str/static_string

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
