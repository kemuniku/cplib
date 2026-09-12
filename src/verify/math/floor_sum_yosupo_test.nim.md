---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/floor_sum.nim
    title: cplib/math/floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/floor_sum.nim
    title: cplib/math/floor_sum.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/sum_of_floor_of_linear
    links:
    - https://judge.yosupo.jp/problem/sum_of_floor_of_linear
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/sum_of_floor_of_linear\n\
    import cplib/math/floor_sum\nimport strutils\n\nlet t = stdin.readLine.parseInt\n\
    for _ in 0..<t:\n    let query = stdin.readLine.splitWhitespace\n    echo floor_sum(query[0].parseInt,\
    \ query[1].parseInt,\n                   query[2].parseInt, query[3].parseInt)\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/math/floor_sum.nim
  - cplib/math/floor_sum.nim
  isVerificationFile: true
  path: verify/math/floor_sum_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-09-12 14:53:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/floor_sum_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/floor_sum_yosupo_test.nim
- /verify/verify/math/floor_sum_yosupo_test.nim.html
title: verify/math/floor_sum_yosupo_test.nim
---
