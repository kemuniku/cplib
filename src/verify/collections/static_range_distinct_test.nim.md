---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/static_range_distinct.nim
    title: cplib/collections/static_range_distinct.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/static_range_distinct.nim
    title: cplib/collections/static_range_distinct.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/static_range_count_distinct
    links:
    - https://judge.yosupo.jp/problem/static_range_count_distinct
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_count_distinct\n\
    import cplib/collections/static_range_distinct\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\", addr result)\nlet N = ii()\nlet Q = ii()\nlet A = newSeqWith(N, ii())\n\
    let d = initStaticRangeDistinct(A)\nfor _ in 0..<Q:\n    let l = ii()\n    let\
    \ r = ii()\n    echo d.count(l, r)\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/static_range_distinct.nim
  - cplib/collections/static_range_distinct.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  isVerificationFile: true
  path: verify/collections/static_range_distinct_test.nim
  requiredBy: []
  timestamp: '2026-10-25 20:56:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/static_range_distinct_test.nim
layout: document
redirect_from:
- /verify/verify/collections/static_range_distinct_test.nim
- /verify/verify/collections/static_range_distinct_test.nim.html
title: verify/collections/static_range_distinct_test.nim
---
