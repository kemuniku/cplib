# verification-helper: PROBLEM https://judge.yosupo.jp/problem/palindromes_in_deque
import strutils
import cplib/str/double_ended_palindromic_tree

let q = stdin.readLine.parseInt
var tree = initDoubleEndedPalindromicTree()
var output = newStringOfCap(q * 12)
for _ in 0..<q:
    let query = stdin.readLine.splitWhitespace
    case query[0]
    of "0": tree.push_front(query[1][0])
    of "1": tree.push_back(query[1][0])
    of "2": tree.pop_front()
    of "3": tree.pop_back()
    else: discard
    output.add($tree.count_distinct_palindromes & " " &
        $tree.longest_prefix_palindrome & " " & $tree.longest_suffix_palindrome & "\n")
stdout.write(output)
