---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/closest_pair
    links:
    - https://judge.yosupo.jp/problem/closest_pair
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/closest_pair\n\
    import options\nimport cplib/geometry/base\nimport cplib/geometry/closest_pair\n\
    include cplib/tmpl/fastio\n\nlet t = ii()\nfor _ in 0..<t:\n    let n = ii()\n\
    \    var points = newSeq[Point[int64]](n)\n    for i in 0..<n:\n        points[i]\
    \ = initPoint(int64(ii()), int64(ii()))\n    let (u, v) = closest_pair(points).get.indices\n\
    \    echo u, \" \", v\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/geometry/closest_pair_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:16:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/closest_pair_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/closest_pair_test.nim
- /verify/verify/geometry/closest_pair_test.nim.html
title: verify/geometry/closest_pair_test.nim
---
