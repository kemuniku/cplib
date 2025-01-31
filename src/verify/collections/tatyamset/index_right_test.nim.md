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
    PROBLEM: https://atcoder.jp/contests/arc075/tasks/arc075_e
    links:
    - https://atcoder.jp/contests/arc075/tasks/arc075_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/arc075/tasks/arc075_e\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils\nimport cplib/collections/tatyamset\n\
    var N, K = ii()\nvar a = newSeqWith(N, ii()-K)\nvar now = 0\nvar st = initSortedMultiset(@[0])\n\
    var ans = 0\nfor i in 0..<N:\n    now += a[i]\n    ans += st.index_right(now)\n\
    \    st.incl(now)\necho ans\n"
  dependsOn:
  - cplib/collections/tatyamset.nim
  - cplib/collections/tatyamset.nim
  isVerificationFile: true
  path: verify/collections/tatyamset/index_right_test.nim
  requiredBy: []
  timestamp: '2024-04-23 21:11:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/tatyamset/index_right_test.nim
layout: document
redirect_from:
- /verify/verify/collections/tatyamset/index_right_test.nim
- /verify/verify/collections/tatyamset/index_right_test.nim.html
title: verify/collections/tatyamset/index_right_test.nim
---
