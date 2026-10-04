---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/double_ended_palindromic_tree.nim
    title: cplib/str/double_ended_palindromic_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/double_ended_palindromic_tree.nim
    title: cplib/str/double_ended_palindromic_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/palindromes_in_deque
    links:
    - https://judge.yosupo.jp/problem/palindromes_in_deque
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/palindromes_in_deque\n\
    include cplib/tmpl/fastio\nimport cplib/str/double_ended_palindromic_tree\n\n\
    let q = ii()\nvar tree = initDoubleEndedPalindromicTree(capacity = q)\nfor _ in\
    \ 0..<q:\n    case ii()\n    of 0: tree.push_front(si()[0])\n    of 1: tree.push_back(si()[0])\n\
    \    of 2: tree.pop_front()\n    of 3: tree.pop_back()\n    else: discard\n  \
    \  print(tree.count_distinct_palindromes,\n        tree.longest_prefix_palindrome,\
    \ tree.longest_suffix_palindrome)\n"
  dependsOn:
  - cplib/str/double_ended_palindromic_tree.nim
  - cplib/str/double_ended_palindromic_tree.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/str/double_ended_palindromic_tree_test.nim
  requiredBy: []
  timestamp: '2026-10-01 03:10:25+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/double_ended_palindromic_tree_test.nim
layout: document
redirect_from:
- /verify/verify/str/double_ended_palindromic_tree_test.nim
- /verify/verify/str/double_ended_palindromic_tree_test.nim.html
title: verify/str/double_ended_palindromic_tree_test.nim
---
