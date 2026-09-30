# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/palindromic_tree_table
import tables, random, strutils, hashes

proc isPalindrome[T](a: seq[T]): bool =
    for i in 0..<a.len div 2:
        if a[i] != a[a.len - 1 - i]: return false
    true

proc check[T](pt: var TablePalindromicTree[T], a: seq[T]) =
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
        for value, child in parent.link.pairs:
            inc edges
            doAssert child.parent == parent
            doAssert child.character == value
            doAssert pt.nodes[child.id] == child
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

proc exercise[T](alphabet: openArray[T], seed: int64) =
    var rng = initRand(seed)
    for trial in 0..<20:
        var pt = initTablePalindromicTree[T]()
        var a: seq[T]
        pt.check(a)
        for length in 1..30:
            let value = alphabet[rng.rand(0..<alphabet.len)]
            a.add(value)
            doAssert pt.add(value) == pt.last_node
            pt.check(a)
        var rebuilt = initTablePalindromicTree(a)
        rebuilt.check(a)

exercise(['a', 'A', '\0', char(255)], 8127)
exercise([-100, -1, 0, int.high], 9312)
exercise(["left", "right", "middle"], 4517)
exercise([(1, true), (2, false), (1, false)], 6213)

type Token = object
    value: int

proc hash(token: Token): Hash = Hash(0)

exercise([Token(value: 1), Token(value: 2), Token(value: 3)], 7519)

var repeated = initTablePalindromicTree(repeat('a', 20000))
repeated.update_count()
for node in repeated.nodes:
    if node.len > 0:
        doAssert node.count == repeated.len - node.len + 1

doAssert repeated.add('b').len == 1
repeated.update_count()
doAssert repeated.last_node.count == 1
doAssert repeated.nodes[2].count == 20000

let characterTree = initTablePalindromicTree("ababa")
doAssert characterTree.last_node.character == 'a'
doAssert characterTree.last_node.get_palindrome() == @['a', 'b', 'a', 'b', 'a']

echo "Hello World"
