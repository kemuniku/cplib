---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/double_ended_palindromic_tree.nim
    title: cplib/str/double_ended_palindromic_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/double_ended_palindromic_tree.nim
    title: cplib/str/double_ended_palindromic_tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import random, sets\nimport cplib/str/double_ended_palindromic_tree\n\nproc check(tree:\
    \ DoubleEndedPalindromicTree, values: seq[int]) =\n    var palindromes = initHashSet[seq[int]]()\n\
    \    var total = 0'i64\n    var prefix, suffix = 0\n    for l in 0..<values.len:\n\
    \        for r in l..<values.len:\n            var palindrome = true\n       \
    \     for i in 0..<(r - l + 1) div 2:\n                if values[l + i] != values[r\
    \ - i]:\n                    palindrome = false\n                    break\n \
    \           if palindrome:\n                palindromes.incl(values[l..r])\n \
    \               inc total\n                if l == 0: prefix = max(prefix, r +\
    \ 1)\n                if r == values.high: suffix = max(suffix, r - l + 1)\n \
    \   doAssert tree.len == values.len\n    doAssert tree.isEmpty == (values.len\
    \ == 0)\n    doAssert tree.count_distinct_palindromes == palindromes.len\n   \
    \ doAssert tree.count_palindromes == total\n    doAssert tree.longest_prefix_palindrome\
    \ == prefix\n    doAssert tree.longest_suffix_palindrome == suffix\n\nblock:\n\
    \    var tree = initDoubleEndedPalindromicTree()\n    tree.check(@[])\n    for\
    \ front in [false, true]:\n        var caught = false\n        try:\n        \
    \    if front: tree.pop_front()\n            else: tree.pop_back()\n        except\
    \ IndexDefect:\n            caught = true\n        doAssert caught\n        tree.check(@[])\n\
    \    tree.push_back('a')\n    tree.push_front('b')\n    tree.push_back('b')\n\
    \    tree.check(@[1, 0, 1])\n    tree.pop_front()\n    tree.check(@[0, 1])\n \
    \   tree.pop_back()\n    tree.pop_front()\n    tree.check(@[])\n\nblock:\n   \
    \ for s in [\"\", \"a\", \"aa\", \"ab\", \"abacaba\", \"abcbabca\", \"aaaaaa\"\
    , \"ababbaba\"]:\n        var values: seq[int]\n        for c in s: values.add(ord(c)\
    \ - ord('a'))\n        initDoubleEndedPalindromicTree(s).check(values)\n     \
    \   initDoubleEndedPalindromicTree(values).check(values)\n    initDoubleEndedPalindromicTree(['A',\
    \ 'B', 'A'], 'A', 2).check(@[0, 1, 0])\n    initDoubleEndedPalindromicTree([0,\
    \ 255, 0], 256).check(@[0, 255, 0])\n    var bytes = initDoubleEndedPalindromicTree(256,\
    \ '\\0')\n    bytes.push_front('\\0')\n    bytes.push_back('\\255')\n    bytes.push_front('\\\
    255')\n    bytes.check(@[255, 0, 255])\n\nproc exhaust(tree: var DoubleEndedPalindromicTree,\
    \ values: seq[int], remaining: int) =\n    tree.check(values)\n    if remaining\
    \ == 0: return\n    for value in 0..1:\n        tree.push_front(value)\n     \
    \   exhaust(tree, @[value] & values, remaining - 1)\n        tree.pop_front()\n\
    \        tree.push_back(value)\n        exhaust(tree, values & @[value], remaining\
    \ - 1)\n        tree.pop_back()\n    if values.len > 0:\n        tree.pop_front()\n\
    \        exhaust(tree, values[1..<values.len], remaining - 1)\n        tree.push_front(values[0])\n\
    \        tree.pop_back()\n        exhaust(tree, values[0..<values.high], remaining\
    \ - 1)\n        tree.push_back(values[^1])\n    tree.check(values)\n\nblock:\n\
    \    for capacity in [0, 1, 16]:\n        var tree = initDoubleEndedPalindromicTree(2,\
    \ capacity = capacity)\n        exhaust(tree, @[], 7)\n\nvar rng = initRand(20260926)\n\
    for sigma in [1, 2, 3, 26, 256]:\n    var tree = initDoubleEndedPalindromicTree(sigma)\n\
    \    var values: seq[int]\n    for step in 0..<6000:\n        var operation =\
    \ rng.rand(3)\n        if values.len == 0: operation = rng.rand(1)\n        if\
    \ values.len >= 48: operation = 2 + rng.rand(1)\n        let value = rng.rand(sigma\
    \ - 1)\n        case operation\n        of 0:\n            tree.push_front(value)\n\
    \            values.insert(value, 0)\n        of 1:\n            tree.push_back(value)\n\
    \            values.add(value)\n        of 2:\n            tree.pop_front()\n\
    \            values.delete(0)\n        else:\n            tree.pop_back()\n  \
    \          discard values.pop()\n        tree.check(values)\n    while values.len\
    \ > 0:\n        if rng.rand(1) == 0:\n            tree.pop_front()\n         \
    \   values.delete(0)\n        else:\n            tree.pop_back()\n           \
    \ discard values.pop()\n        tree.check(values)\n\nblock:\n    const n = 100000\n\
    \    var tree = initDoubleEndedPalindromicTree(2)\n    for i in 1..n:\n      \
    \  if i mod 2 == 0: tree.push_front(0)\n        else: tree.push_back(0)\n    \
    \    doAssert tree.count_distinct_palindromes == i\n        doAssert tree.count_palindromes\
    \ == int64(i) * int64(i + 1) div 2\n    for _ in 0..<10000:\n        tree.push_back(1)\n\
    \        doAssert tree.longest_suffix_palindrome == 1\n        doAssert tree.count_palindromes\
    \ == int64(n) * int64(n + 1) div 2 + 1\n        tree.pop_back()\n        tree.push_front(1)\n\
    \        doAssert tree.longest_prefix_palindrome == 1\n        tree.pop_front()\n\
    \    for i in countdown(n, 1):\n        doAssert tree.longest_prefix_palindrome\
    \ == i\n        doAssert tree.longest_suffix_palindrome == i\n        if i mod\
    \ 2 == 0: tree.pop_front()\n        else: tree.pop_back()\n        doAssert tree.count_distinct_palindromes\
    \ == i - 1\n        doAssert tree.count_palindromes == int64(i) * int64(i - 1)\
    \ div 2\n    tree.check(@[])\n\nblock:\n    var tree = initDoubleEndedPalindromicTree(3)\n\
    \    var values: seq[int]\n    for i in 0..<20000:\n        let value = i mod\
    \ 3\n        if i mod 1000 < 500:\n            tree.push_back(value)\n       \
    \     values.add(value)\n            if values.len > 12:\n                tree.pop_front()\n\
    \                values.delete(0)\n        else:\n            tree.push_front(value)\n\
    \            values.insert(value, 0)\n            if values.len > 12:\n      \
    \          tree.pop_back()\n                discard values.pop()\n        tree.check(values)\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/double_ended_palindromic_tree.nim
  - cplib/str/double_ended_palindromic_tree.nim
  isVerificationFile: true
  path: verify/AI/double_ended_palindromic_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-28 04:29:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/double_ended_palindromic_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/double_ended_palindromic_tree_test.nim
- /verify/verify/AI/double_ended_palindromic_tree_test.nim.html
title: verify/AI/double_ended_palindromic_tree_test.nim
---
