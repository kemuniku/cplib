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
    PROBLEM: https://yukicoder.me/problems/no/2606
    links:
    - https://yukicoder.me/problems/no/2606
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2606\nimport\
    \ strutils, sequtils, algorithm\nimport cplib/str/palindromic_tree\n\nvar s =\
    \ stdin.readLine.reversed.join(\"\")\nvar pt = initPalindromicTree(s)\npt.update_count\n\
    \nvar score = newSeqWith(pt.nodes.len, 0)\nfor i in 1..<pt.nodes.len:\n    var\
    \ node = pt.nodes[i]\n    score[i] = score[node[].suffix_link[].id] + node[].count\
    \ * node[].len\necho score.max\n"
  dependsOn:
  - cplib/str/palindromic_tree.nim
  - cplib/str/palindromic_tree.nim
  isVerificationFile: true
  path: verify/str/palindromic_tree_test.nim
  requiredBy: []
  timestamp: '2024-09-10 01:13:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/palindromic_tree_test.nim
layout: document
redirect_from:
- /verify/verify/str/palindromic_tree_test.nim
- /verify/verify/str/palindromic_tree_test.nim.html
title: verify/str/palindromic_tree_test.nim
---
