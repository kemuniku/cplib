---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/tatyamset.nim
    title: cplib/collections/tatyamset.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc217/tasks/abc217_d
    links:
    - https://atcoder.jp/contests/abc217/tasks/abc217_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc217/tasks/abc217_d\n\
    import cplib/collections/tatyamset\nimport options\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nvar L, Q = ii()\nvar st = initSortedMultiset[int]()\nst.incl(0)\nst.incl(L)\n\
    for i in 0..<Q:\n    var c, x = ii()\n    if c == 1:\n        st.incl(x)\n   \
    \ else:\n        var l = st.lt(x)\n        var r = st.gt(x)\n        echo r.get()-l.get()\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/collections/tatyamset/ABC217_gtlt_test.nim
  requiredBy: []
  timestamp: '2024-04-23 21:11:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/tatyamset/ABC217_gtlt_test.nim
layout: document
redirect_from:
- /verify/verify/collections/tatyamset/ABC217_gtlt_test.nim
- /verify/verify/collections/tatyamset/ABC217_gtlt_test.nim.html
title: verify/collections/tatyamset/ABC217_gtlt_test.nim
---
