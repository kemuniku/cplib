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
    \ seq[T]): bool =\n    for i in 0..<a.len div 2:\n        if a[i] != a[a.len -\
    \ 1 - i]: return false\n    true\n\nproc check[T, alphabet](pt: var PalindromicTree[T,\
    \ alphabet], a: seq[T]) =\n    var palindromes: seq[seq[T]]\n    var totals, terminals,\
    \ prefixes: seq[int]\n    for right in 0..<a.len:\n        var longest = -1\n\
    \        for left in 0..right:\n            let palindrome = a[left..right]\n\
    \            if not palindrome.isPalindrome(): continue\n            var index\
    \ = palindromes.find(palindrome)\n            if index < 0:\n                index\
    \ = palindromes.len\n                palindromes.add(palindrome)\n           \
    \     totals.add(0)\n                terminals.add(0)\n            inc totals[index]\n\
    \            if longest < 0: longest = index\n        inc terminals[longest]\n\
    \        prefixes.add(longest + 2)\n    doAssert pt.len == a.len\n    doAssert\
    \ pt.nodes.len == palindromes.len + 2\n    doAssert pt.prefix_nodes.len == a.len\n\
    \    doAssert pt.nodes[0].len == -1 and pt.nodes[1].len == 0\n    doAssert pt.nodes[0].parent\
    \ == nil and pt.nodes[1].parent == nil\n    doAssert pt.nodes[0].suffix_link ==\
    \ nil\n    doAssert pt.nodes[1].suffix_link == pt.nodes[0]\n    doAssert pt.nodes[0].get_palindrome().len\
    \ == 0\n    doAssert pt.nodes[1].get_palindrome().len == 0\n    doAssert pt.last_node\
    \ == (if a.len == 0: pt.nodes[1] else: pt.prefix_nodes[^1])\n    for i, id in\
    \ prefixes:\n        doAssert pt.prefix_nodes[i] == pt.nodes[id]\n    var edges\
    \ = 0\n    for parent in pt.nodes:\n        var childCount = 0\n        for value,\
    \ child in parent.link.pairs:\n            inc childCount\n            doAssert\
    \ parent.link.hasKey(value)\n            doAssert parent.link[value] == child\n\
    \            doAssert parent.link.getOrDefault(value) == child\n            inc\
    \ edges\n            doAssert child.parent == parent\n            doAssert child.character\
    \ == value\n            doAssert pt.nodes[child.id] == child\n        doAssert\
    \ parent.link.len == childCount\n    doAssert edges == palindromes.len\n    for\
    \ i, palindrome in palindromes:\n        let node = pt.nodes[i + 2]\n        doAssert\
    \ node.id == i + 2\n        doAssert node.len == palindrome.len\n        doAssert\
    \ node.get_palindrome() == palindrome\n        doAssert pt.get_palindrome(node)\
    \ == palindrome\n        doAssert node.character == palindrome[0]\n        doAssert\
    \ node.count == terminals[i]\n        let parentId = if palindrome.len == 1: 0\n\
    \            elif palindrome.len == 2: 1\n            else: palindromes.find(palindrome[1..^2])\
    \ + 2\n        doAssert node.parent == pt.nodes[parentId]\n        var suffixId\
    \ = 1\n        for left in 1..<palindrome.len:\n            let suffix = palindrome[left..^1]\n\
    \            if suffix.isPalindrome():\n                suffixId = palindromes.find(suffix)\
    \ + 2\n                break\n        doAssert node.suffix_link == pt.nodes[suffixId]\n\
    \        doAssert node.diff == node.len - node.suffix_link.len\n        var series\
    \ = node.suffix_link\n        while series.len > 0 and series.diff == node.diff:\n\
    \            series = series.suffix_link\n        doAssert node.series_link ==\
    \ series\n    for iteration in 0..<2:\n        pt.update_count()\n        doAssert\
    \ pt.nodes[0].count == a.len\n        doAssert pt.nodes[1].count == a.len\n  \
    \      for i, total in totals:\n            doAssert pt.nodes[i + 2].count ==\
    \ total\n\nproc exercise[T: Ordinal](bounds: static[HSlice[T, T]], alphabet: openArray[T],\
    \ seed: int64) =\n    var rng = initRand(seed)\n    for trial in 0..<20:\n   \
    \     var pt = initPalindromicTree(bounds)\n        var a: seq[T]\n        pt.check(a)\n\
    \        for length in 1..30:\n            let value = alphabet[rng.rand(0..<alphabet.len)]\n\
    \            a.add(value)\n            doAssert pt.add(value) == pt.last_node\n\
    \            pt.check(a)\n        var rebuilt = initPalindromicTree(a, bounds)\n\
    \        rebuilt.check(a)\n\nexercise('\\0'..char(255), ['a', 'A', '\\0', char(255)],\
    \ 8127)\nexercise(-100..100, [-100, -1, 0, 100], 9312)\nexercise(false..true,\
    \ [false, true], 4517)\n\nvar repeated = initPalindromicTree(repeat('a', 20000))\n\
    repeated.update_count()\nfor node in repeated.nodes:\n    if node.len > 0:\n \
    \       doAssert node.count == repeated.len - node.len + 1\n\ndoAssert repeated.add('b').len\
    \ == 1\nrepeated.update_count()\ndoAssert repeated.last_node.count == 1\ndoAssert\
    \ repeated.nodes[2].count == 20000\n\nlet characterTree = initPalindromicTree(\"\
    ababa\")\ndoAssert characterTree.last_node.character == 'a'\ndoAssert characterTree.last_node.get_palindrome()\
    \ == @['a', 'b', 'a', 'b', 'a']\n\nblock:\n    var pt = initPalindromicTree('a'..'z',\
    \ capacity = 1)\n    let first = pt.add('a')\n    let root = pt.nodes[0]\n   \
    \ for i in 0..<4096: pt.add('b')\n    doAssert first == pt.nodes[2]\n    doAssert\
    \ first.parent == root\n    doAssert first.get_palindrome() == @['a']\n    doAssert\
    \ root.link.hasKey('a')\n    doAssert root.link['a'] == first\n    doAssert root.link.len\
    \ == 2\n    doAssert root.link.getOrDefault('z').isNil\n    doAssert root.link.getOrDefault('A')\
    \ == nil\n    doAssert nil == root.parent\n    var raised = false\n    try:\n\
    \        discard root.link['z']\n    except KeyError:\n        raised = true\n\
    \    doAssert raised\n    let other = initPalindromicTree(\"a\")\n    doAssert\
    \ first != other.last_node\n\nlet retained = block:\n    var pt = initPalindromicTree(\"\
    abacaba\")\n    pt.last_node\ndoAssert retained.get_palindrome() == @['a', 'b',\
    \ 'a', 'c', 'a', 'b', 'a']\ndoAssert retained.parent.len == 5\n\nblock:\n    var\
    \ pt = initPalindromicTree(0..0)\n    for i in 0..<100: pt.add(0)\n    doAssert\
    \ pt.last_node.len == 100\n    var raised = false\n    try:\n        pt.add(1)\n\
    \    except AssertionDefect:\n        raised = true\n    doAssert raised\n   \
    \ doAssert pt.len == 100\n\ntype Letter = enum\n    la, lb, lc\nlet enumTree =\
    \ initPalindromicTree([la, lb, la], la..lc)\ndoAssert enumTree.last_node.get_palindrome()\
    \ == @[la, lb, la]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/palindromic_tree.nim
  - cplib/str/palindromic_tree.nim
  isVerificationFile: true
  path: verify/str/palindromic_tree_append_test.nim
  requiredBy: []
  timestamp: '2026-10-01 03:07:49+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/palindromic_tree_append_test.nim
layout: document
redirect_from:
- /verify/verify/str/palindromic_tree_append_test.nim
- /verify/verify/str/palindromic_tree_append_test.nim.html
title: verify/str/palindromic_tree_append_test.nim
---
