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
    PROBLEM: https://judge.yosupo.jp/problem/eertree
    links:
    - https://judge.yosupo.jp/problem/eertree
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/eertree\n\
    import cplib/str/palindromic_tree\nimport strutils\n\nlet s = stdin.readLine()\n\
    var pt = initPalindromicTree('a'..'z', capacity = s.len)\nfor c in s:\n    pt.add(c)\n\
    var output = newStringOfCap(s.len * 28)\noutput.addInt(pt.nodes.len - 2)\noutput.add('\\\
    n')\nfor i in 2..<pt.nodes.len:\n    let node = pt.nodes[i]\n    output.addInt(node.parent.id\
    \ - 1)\n    output.add(' ')\n    output.addInt(node.suffix_link.id - 1)\n    output.add('\\\
    n')\nfor i, node in pt.prefix_nodes:\n    if i != 0: output.add(' ')\n    output.addInt(node.id\
    \ - 1)\noutput.add('\\n')\nstdout.write(output)\n"
  dependsOn:
  - cplib/str/palindromic_tree.nim
  - cplib/str/palindromic_tree.nim
  isVerificationFile: true
  path: verify/str/palindromic_tree_eertree_test.nim
  requiredBy: []
  timestamp: '2026-10-01 03:07:49+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/palindromic_tree_eertree_test.nim
layout: document
redirect_from:
- /verify/verify/str/palindromic_tree_eertree_test.nim
- /verify/verify/str/palindromic_tree_eertree_test.nim.html
title: verify/str/palindromic_tree_eertree_test.nim
---
