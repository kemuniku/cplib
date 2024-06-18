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
    PROBLEM: https://atcoder.jp/contests/arc075/tasks/arc075_e
    links:
    - https://atcoder.jp/contests/arc075/tasks/arc075_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/arc075/tasks/arc075_e\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils\nimport cplib/collections/avlset\n\
    var N, K = ii()\nvar a = newSeqWith(N, ii()-K)\nvar now = 0\nvar st = initAvlSortedMultiset(@[0])\n\
    var ans = 0\nfor i in 0..<N:\n    now += a[i]\n    ans += st.index_right(now)\n\
    \    st.incl(now)\necho ans\n"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/avlset/index_right_test.nim
  requiredBy: []
  timestamp: '2024-06-07 12:16:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avlset/index_right_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avlset/index_right_test.nim
- /verify/verify/collections/avlset/index_right_test.nim.html
title: verify/collections/avlset/index_right_test.nim
---
