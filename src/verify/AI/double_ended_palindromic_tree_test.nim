# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sets
import cplib/str/double_ended_palindromic_tree

proc check(tree: DoubleEndedPalindromicTree, values: seq[int]) =
    var palindromes = initHashSet[seq[int]]()
    var total = 0'i64
    var prefix, suffix = 0
    for l in 0..<values.len:
        for r in l..<values.len:
            var palindrome = true
            for i in 0..<(r - l + 1) div 2:
                if values[l + i] != values[r - i]:
                    palindrome = false
                    break
            if palindrome:
                palindromes.incl(values[l..r])
                inc total
                if l == 0: prefix = max(prefix, r + 1)
                if r == values.high: suffix = max(suffix, r - l + 1)
    doAssert tree.len == values.len
    doAssert tree.isEmpty == (values.len == 0)
    doAssert tree.count_distinct_palindromes == palindromes.len
    doAssert tree.count_palindromes == total
    doAssert tree.longest_prefix_palindrome == prefix
    doAssert tree.longest_suffix_palindrome == suffix

block:
    var tree = initDoubleEndedPalindromicTree()
    tree.check(@[])
    for front in [false, true]:
        var caught = false
        try:
            if front: tree.pop_front()
            else: tree.pop_back()
        except IndexDefect:
            caught = true
        doAssert caught
        tree.check(@[])
    tree.push_back('a')
    tree.push_front('b')
    tree.push_back('b')
    tree.check(@[1, 0, 1])
    tree.pop_front()
    tree.check(@[0, 1])
    tree.pop_back()
    tree.pop_front()
    tree.check(@[])

block:
    for s in ["", "a", "aa", "ab", "abacaba", "abcbabca", "aaaaaa", "ababbaba"]:
        var values: seq[int]
        for c in s: values.add(ord(c) - ord('a'))
        initDoubleEndedPalindromicTree(s).check(values)
        initDoubleEndedPalindromicTree(values).check(values)
    initDoubleEndedPalindromicTree(['A', 'B', 'A'], 'A', 2).check(@[0, 1, 0])
    initDoubleEndedPalindromicTree([0, 255, 0], 256).check(@[0, 255, 0])
    var bytes = initDoubleEndedPalindromicTree(256, '\0')
    bytes.push_front('\0')
    bytes.push_back('\255')
    bytes.push_front('\255')
    bytes.check(@[255, 0, 255])

proc exhaust(tree: var DoubleEndedPalindromicTree, values: seq[int], remaining: int) =
    tree.check(values)
    if remaining == 0: return
    for value in 0..1:
        tree.push_front(value)
        exhaust(tree, @[value] & values, remaining - 1)
        tree.pop_front()
        tree.push_back(value)
        exhaust(tree, values & @[value], remaining - 1)
        tree.pop_back()
    if values.len > 0:
        tree.pop_front()
        exhaust(tree, values[1..<values.len], remaining - 1)
        tree.push_front(values[0])
        tree.pop_back()
        exhaust(tree, values[0..<values.high], remaining - 1)
        tree.push_back(values[^1])
    tree.check(values)

block:
    var tree = initDoubleEndedPalindromicTree(2)
    exhaust(tree, @[], 7)

var rng = initRand(20260926)
for sigma in [1, 2, 3, 26, 256]:
    var tree = initDoubleEndedPalindromicTree(sigma)
    var values: seq[int]
    for step in 0..<6000:
        var operation = rng.rand(3)
        if values.len == 0: operation = rng.rand(1)
        if values.len >= 48: operation = 2 + rng.rand(1)
        let value = rng.rand(sigma - 1)
        case operation
        of 0:
            tree.push_front(value)
            values.insert(value, 0)
        of 1:
            tree.push_back(value)
            values.add(value)
        of 2:
            tree.pop_front()
            values.delete(0)
        else:
            tree.pop_back()
            discard values.pop()
        tree.check(values)
    while values.len > 0:
        if rng.rand(1) == 0:
            tree.pop_front()
            values.delete(0)
        else:
            tree.pop_back()
            discard values.pop()
        tree.check(values)

block:
    const n = 100000
    var tree = initDoubleEndedPalindromicTree(2)
    for i in 1..n:
        if i mod 2 == 0: tree.push_front(0)
        else: tree.push_back(0)
        doAssert tree.count_distinct_palindromes == i
        doAssert tree.count_palindromes == int64(i) * int64(i + 1) div 2
    for _ in 0..<10000:
        tree.push_back(1)
        doAssert tree.longest_suffix_palindrome == 1
        doAssert tree.count_palindromes == int64(n) * int64(n + 1) div 2 + 1
        tree.pop_back()
        tree.push_front(1)
        doAssert tree.longest_prefix_palindrome == 1
        tree.pop_front()
    for i in countdown(n, 1):
        doAssert tree.longest_prefix_palindrome == i
        doAssert tree.longest_suffix_palindrome == i
        if i mod 2 == 0: tree.pop_front()
        else: tree.pop_back()
        doAssert tree.count_distinct_palindromes == i - 1
        doAssert tree.count_palindromes == int64(i) * int64(i - 1) div 2
    tree.check(@[])

block:
    var tree = initDoubleEndedPalindromicTree(3)
    var values: seq[int]
    for i in 0..<20000:
        let value = i mod 3
        if i mod 1000 < 500:
            tree.push_back(value)
            values.add(value)
            if values.len > 12:
                tree.pop_front()
                values.delete(0)
        else:
            tree.push_front(value)
            values.insert(value, 0)
            if values.len > 12:
                tree.pop_back()
                discard values.pop()
        tree.check(values)

echo "Hello World"
