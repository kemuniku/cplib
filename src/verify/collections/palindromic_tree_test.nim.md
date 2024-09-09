---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/palindromic_tree.nim
    title: cplib/collections/palindromic_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/palindromic_tree.nim
    title: cplib/collections/palindromic_tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2606
    links:
    - https://yukicoder.me/problems/no/2606
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2606\nimport\
    \ strutils, sequtils, algorithm\nimport cplib/collections/palindromic_tree\n\n\
    var s = stdin.readLine.reversed.join(\"\")\nvar pt = initPalindromicTree(s)\n\
    pt.update_count\n\nvar score = newSeqWith(pt.nodes.len, 0)\nfor i in 1..<pt.nodes.len:\n\
    \    var node = pt.nodes[i]\n    score[i] = score[node[].suffix_link[].id] + node[].count\
    \ * node[].len\necho score.max\n"
  dependsOn:
  - cplib/collections/palindromic_tree.nim
  - cplib/collections/palindromic_tree.nim
  isVerificationFile: true
  path: verify/collections/palindromic_tree_test.nim
  requiredBy: []
  timestamp: '2024-09-10 01:09:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/palindromic_tree_test.nim
layout: document
redirect_from:
- /verify/verify/collections/palindromic_tree_test.nim
- /verify/verify/collections/palindromic_tree_test.nim.html
title: verify/collections/palindromic_tree_test.nim
---
