---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc217/tasks/abc217_d
    links:
    - https://atcoder.jp/contests/abc217/tasks/abc217_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc217/tasks/abc217_d\n\
    import cplib/collections/avlset\nimport options\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nvar L, Q = ii()\nvar st = initAvlSortedMultiset[int]()\nst.incl(0)\n\
    st.incl(L)\nfor i in 0..<Q:\n    var c, x = ii()\n    if c == 1:\n        st.incl(x)\n\
    \    else:\n        var l = st.lt(x)\n        var r = st.gt(x)\n        echo r.get()-l.get()\n"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  isVerificationFile: true
  path: verify/collections/avlset/ABC217_gtlt_test.nim
  requiredBy: []
  timestamp: '2024-06-07 12:16:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/ABC217_gtlt_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/ABC217_gtlt_test.nim
- /verify/verify/collections/avlset/ABC217_gtlt_test.nim.html
title: verify/collections/avlset/ABC217_gtlt_test.nim
---
