---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_linear_add_range_min.nim
    title: cplib/collections/range_linear_add_range_min.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_linear_add_range_min.nim
    title: cplib/collections/range_linear_add_range_min.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/range_linear_add_range_min
    links:
    - https://judge.yosupo.jp/problem/range_linear_add_range_min
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_linear_add_range_min\n\
    import sequtils\nimport cplib/collections/range_linear_add_range_min\n\nproc scanf(formatstr:\
    \ cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\", addr result)\n\nlet n = ii()\nlet q = ii()\nlet a = newSeqWith(n, ii())\n\
    let seg = initRangeLinearAddRangeMin(a)\nfor _ in 0..<q:\n    let t = ii()\n \
    \   let l = ii()\n    let r = ii()\n    if t == 0:\n        let b = ii()\n   \
    \     let c = ii()\n        seg.add(l..<r, b, c)\n    else:\n        echo seg[l..<r]\n"
  dependsOn:
  - cplib/collections/range_linear_add_range_min.nim
  - cplib/collections/range_linear_add_range_min.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/collections/range_linear_add_range_min_test.nim
  requiredBy: []
  timestamp: '2026-09-09 00:03:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_linear_add_range_min_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_linear_add_range_min_test.nim
- /verify/verify/collections/range_linear_add_range_min_test.nim.html
title: verify/collections/range_linear_add_range_min_test.nim
---
