# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/str/palindromic_tree

var pt = initPalindromicTree("ababa")
let lens = pt.nodes.mapIt(it.len).sorted
assert lens == @[-1, 0, 1, 1, 3, 3, 5]
let longest = pt.nodes.filterIt(it.len == 5)[0]
assert longest.id >= 0
assert longest.count == 1
assert pt.get_palindrome(longest) == @['a', 'b', 'a', 'b', 'a']
pt.update_count()
let aNode = pt.nodes.filterIt(it.len == 1 and pt.get_palindrome(it) == @['a'])[0]
assert aNode.count == 3

let intPt = initPalindromicTree(@[0, 2, 0], 0..2)
let intLongest = intPt.nodes.filterIt(it.len == 3)[0]
assert intPt.get_palindrome(intLongest) == @[0, 2, 0]

let charPt = initPalindromicTree(['a', 'b', 'a'])
let charLongest = charPt.nodes.filterIt(it.len == 3)[0]
assert charPt.get_palindrome(charLongest) == @['a', 'b', 'a']

let emptyPt = initPalindromicTree(newSeq[int](), 0..2)
assert emptyPt.nodes.mapIt(it.len) == @[-1, 0]
