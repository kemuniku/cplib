# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/palindromic_tree
import random, strutils

proc isPalindrome[T](a: seq[T]): bool =
    for i in 0..<a.len div 2:
        if a[i] != a[a.len - 1 - i]: return false
    true

proc check[T, alphabet](pt: var PalindromicTree[T, alphabet], a: seq[T]) =
    var palindromes: seq[seq[T]]
    var totals, terminals, prefixes: seq[int]
    for right in 0..<a.len:
        var longest = -1
        for left in 0..right:
            let palindrome = a[left..right]
            if not palindrome.isPalindrome(): continue
            var index = palindromes.find(palindrome)
            if index < 0:
                index = palindromes.len
                palindromes.add(palindrome)
                totals.add(0)
                terminals.add(0)
            inc totals[index]
            if longest < 0: longest = index
        inc terminals[longest]
        prefixes.add(longest + 2)
    doAssert pt.len == a.len
    doAssert pt.nodes.len == palindromes.len + 2
    doAssert pt.prefix_nodes.len == a.len
    doAssert pt.nodes[0].len == -1 and pt.nodes[1].len == 0
    doAssert pt.nodes[0].parent == nil and pt.nodes[1].parent == nil
    doAssert pt.nodes[0].suffix_link == nil
    doAssert pt.nodes[1].suffix_link == pt.nodes[0]
    doAssert pt.nodes[0].get_palindrome().len == 0
    doAssert pt.nodes[1].get_palindrome().len == 0
    doAssert pt.last_node == (if a.len == 0: pt.nodes[1] else: pt.prefix_nodes[^1])
    for i, id in prefixes:
        doAssert pt.prefix_nodes[i] == pt.nodes[id]
    var edges = 0
    for parent in pt.nodes:
        var childCount = 0
        for value, child in parent.link.pairs:
            inc childCount
            doAssert parent.link.hasKey(value)
            doAssert parent.link[value] == child
            doAssert parent.link.getOrDefault(value) == child
            inc edges
            doAssert child.parent == parent
            doAssert child.character == value
            doAssert pt.nodes[child.id] == child
        doAssert parent.link.len == childCount
    doAssert edges == palindromes.len
    for i, palindrome in palindromes:
        let node = pt.nodes[i + 2]
        doAssert node.id == i + 2
        doAssert node.len == palindrome.len
        doAssert node.get_palindrome() == palindrome
        doAssert pt.get_palindrome(node) == palindrome
        doAssert node.character == palindrome[0]
        doAssert node.count == terminals[i]
        let parentId = if palindrome.len == 1: 0
            elif palindrome.len == 2: 1
            else: palindromes.find(palindrome[1..^2]) + 2
        doAssert node.parent == pt.nodes[parentId]
        var suffixId = 1
        for left in 1..<palindrome.len:
            let suffix = palindrome[left..^1]
            if suffix.isPalindrome():
                suffixId = palindromes.find(suffix) + 2
                break
        doAssert node.suffix_link == pt.nodes[suffixId]
        doAssert node.diff == node.len - node.suffix_link.len
        var series = node.suffix_link
        while series.len > 0 and series.diff == node.diff:
            series = series.suffix_link
        doAssert node.series_link == series
    for iteration in 0..<2:
        pt.update_count()
        doAssert pt.nodes[0].count == a.len
        doAssert pt.nodes[1].count == a.len
        for i, total in totals:
            doAssert pt.nodes[i + 2].count == total

proc exercise[T: Ordinal](bounds: static[HSlice[T, T]], alphabet: openArray[T], seed: int64) =
    var rng = initRand(seed)
    for trial in 0..<20:
        var pt = initPalindromicTree(bounds)
        var a: seq[T]
        pt.check(a)
        for length in 1..30:
            let value = alphabet[rng.rand(0..<alphabet.len)]
            a.add(value)
            doAssert pt.add(value) == pt.last_node
            pt.check(a)
        var rebuilt = initPalindromicTree(a, bounds)
        rebuilt.check(a)

exercise('\0'..char(255), ['a', 'A', '\0', char(255)], 8127)
exercise(-100..100, [-100, -1, 0, 100], 9312)
exercise(false..true, [false, true], 4517)

var repeated = initPalindromicTree(repeat('a', 20000))
repeated.update_count()
for node in repeated.nodes:
    if node.len > 0:
        doAssert node.count == repeated.len - node.len + 1

doAssert repeated.add('b').len == 1
repeated.update_count()
doAssert repeated.last_node.count == 1
doAssert repeated.nodes[2].count == 20000

let characterTree = initPalindromicTree("ababa")
doAssert characterTree.last_node.character == 'a'
doAssert characterTree.last_node.get_palindrome() == @['a', 'b', 'a', 'b', 'a']

block:
    var pt = initPalindromicTree('a'..'z', capacity = 1)
    let first = pt.add('a')
    let root = pt.nodes[0]
    for i in 0..<4096: pt.add('b')
    doAssert first == pt.nodes[2]
    doAssert first.parent == root
    doAssert first.get_palindrome() == @['a']
    doAssert root.link.hasKey('a')
    doAssert root.link['a'] == first
    doAssert root.link.len == 2
    doAssert root.link.getOrDefault('z').isNil
    doAssert root.link.getOrDefault('A') == nil
    doAssert nil == root.parent
    var raised = false
    try:
        discard root.link['z']
    except KeyError:
        raised = true
    doAssert raised
    let other = initPalindromicTree("a")
    doAssert first != other.last_node

let retained = block:
    var pt = initPalindromicTree("abacaba")
    pt.last_node
doAssert retained.get_palindrome() == @['a', 'b', 'a', 'c', 'a', 'b', 'a']
doAssert retained.parent.len == 5

block:
    var pt = initPalindromicTree(0..0)
    for i in 0..<100: pt.add(0)
    doAssert pt.last_node.len == 100
    var raised = false
    try:
        pt.add(1)
    except AssertionDefect:
        raised = true
    doAssert raised
    doAssert pt.len == 100

type Letter = enum
    la, lb, lc
let enumTree = initPalindromicTree([la, lb, la], la..lc)
doAssert enumTree.last_node.get_palindrome() == @[la, lb, la]

echo "Hello World"
