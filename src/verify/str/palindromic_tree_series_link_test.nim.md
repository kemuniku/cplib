---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/palindromic_tree.nim
    title: cplib/str/palindromic_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/palindromic_tree.nim
    title: cplib/str/palindromic_tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/str/palindromic_tree\nimport random, strutils\n\nproc isPalindrome[T](a:\
    \ seq[T], first, last: int): bool =\n    for i in 0..<(last - first + 1) div 2:\n\
    \        if a[first + i] != a[last - i]: return false\n    return true\n\nproc\
    \ check[T, alphabet](pt: PalindromicTree[T, alphabet]) =\n    doAssert pt.nodes[0].diff\
    \ == 0\n    doAssert pt.nodes[1].diff == 0\n    doAssert pt.nodes[0].series_link\
    \ == nil\n    doAssert pt.nodes[1].series_link == pt.nodes[0]\n    for node in\
    \ pt.nodes[2..<pt.nodes.len]:\n        let a = pt.get_palindrome(node)\n     \
    \   var suffixLengths: seq[int]\n        for length in countdown(a.len - 1, 0):\n\
    \            if isPalindrome(a, a.len - length, a.len - 1):\n                suffixLengths.add(length)\n\
    \        let expectedDiff = a.len - suffixLengths[0]\n        var expectedLength\
    \ = 0\n        for i in 0..<suffixLengths.len - 1:\n            if suffixLengths[i]\
    \ - suffixLengths[i + 1] != expectedDiff:\n                expectedLength = suffixLengths[i]\n\
    \                break\n        doAssert node.diff == expectedDiff\n        doAssert\
    \ node.series_link != nil\n        doAssert node.series_link.len == expectedLength\n\
    \        doAssert pt.get_palindrome(node.series_link) == a[a.len - expectedLength..<a.len]\n\
    \        if expectedLength == 0:\n            doAssert node.series_link == pt.nodes[1]\n\
    \nproc exhaust(a: var seq[int], sigma, remaining: int) =\n    initPalindromicTree(a,\
    \ 0..2).check()\n    if remaining == 0: return\n    for value in 0..<sigma:\n\
    \        a.add(value)\n        exhaust(a, sigma, remaining - 1)\n        a.setLen(a.len\
    \ - 1)\n\nvar a: seq[int]\nexhaust(a, 2, 10)\nexhaust(a, 3, 7)\nfor s in [\"\"\
    , \"a\", \"aaaaaa\", \"abababa\", \"abacaba\", \"aabbaa\", \"abcbaabcba\"]:\n\
    \    initPalindromicTree(s).check()\ninitPalindromicTree(['A', 'B', 'A', 'B',\
    \ 'A'], 'A'..'Z').check()\ninitPalindromicTree(@[0, 100, 0, 100, 0], 0..100).check()\n\
    \nvar rng = initRand(812731)\nfor trial in 0..<300:\n    var values = newSeq[int](rng.rand(1..100))\n\
    \    for value in values.mitems:\n        value = rng.rand(0..3)\n    initPalindromicTree(values,\
    \ 0..3).check()\n\nlet repeated = initPalindromicTree(repeat('a', 20000))\nfor\
    \ node in repeated.nodes[2..<repeated.nodes.len]:\n    doAssert node.diff == 1\n\
    \    doAssert node.series_link == repeated.nodes[1]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/palindromic_tree.nim
  - cplib/str/palindromic_tree.nim
  isVerificationFile: true
  path: verify/str/palindromic_tree_series_link_test.nim
  requiredBy: []
  timestamp: '2026-10-01 03:07:49+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/palindromic_tree_series_link_test.nim
layout: document
redirect_from:
- /verify/verify/str/palindromic_tree_series_link_test.nim
- /verify/verify/str/palindromic_tree_series_link_test.nim.html
title: verify/str/palindromic_tree_series_link_test.nim
---
