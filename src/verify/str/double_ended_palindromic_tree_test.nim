# verification-helper: PROBLEM https://judge.yosupo.jp/problem/palindromes_in_deque
include cplib/tmpl/fastio
import cplib/str/double_ended_palindromic_tree

let q = ii()
var tree = initDoubleEndedPalindromicTree(capacity = q)
for _ in 0..<q:
    case ii()
    of 0: tree.push_front(si()[0])
    of 1: tree.push_back(si()[0])
    of 2: tree.pop_front()
    of 3: tree.pop_back()
    else: discard
    print(tree.count_distinct_palindromes,
        tree.longest_prefix_palindrome, tree.longest_suffix_palindrome)
