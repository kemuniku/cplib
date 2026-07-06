---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/str/palindromic_tree.nim
    title: cplib/str/palindromic_tree.nim
  - icon: ':question:'
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import algorithm, sequtils

    import cplib/str/palindromic_tree


    var pt = initPalindromicTree("ababa")

    let lens = pt.nodes.mapIt(it[].len).sorted

    assert lens == @[-1, 0, 1, 1, 3, 3, 5]

    let longest = pt.nodes.filterIt(it[].len == 5)[0]

    assert longest[].id >= 0

    assert longest[].count == 1

    assert pt.get_palindrome(longest) == @[0, 1, 0, 1, 0]

    pt.update_count()

    let aNode = pt.nodes.filterIt(it[].len == 1 and pt.get_palindrome(it) == @[0])[0]

    assert aNode[].count == 3

    '
  dependsOn:
  - cplib/str/palindromic_tree.nim
  - cplib/str/palindromic_tree.nim
  isVerificationFile: true
  path: verify/AI/palindromic_tree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/palindromic_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/palindromic_tree_test.nim
- /verify/verify/AI/palindromic_tree_test.nim.html
title: verify/AI/palindromic_tree_test.nim
---
