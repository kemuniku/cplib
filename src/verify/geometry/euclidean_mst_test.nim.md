---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/euclidean_mst.nim
    title: cplib/geometry/euclidean_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/euclidean_mst.nim
    title: cplib/geometry/euclidean_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/euclidean_mst
    links:
    - https://judge.yosupo.jp/problem/euclidean_mst
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/euclidean_mst\n\
    import cplib/geometry/euclidean_mst\ninclude cplib/tmpl/fastio\n\nlet n = ii()\n\
    var points = newSeq[(int, int)](n)\nfor i in 0..<n:\n    points[i] = (ii(), ii())\n\
    for (u, v) in euclidean_mst(points):\n    echo u, \" \", v\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/math/int128.nim
  - cplib/tmpl/fastio.nim
  - cplib/collections/unionfind.nim
  - cplib/geometry/euclidean_mst.nim
  - cplib/collections/unionfind.nim
  - cplib/geometry/euclidean_mst.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/geometry/euclidean_mst_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:45:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/euclidean_mst_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/euclidean_mst_test.nim
- /verify/verify/geometry/euclidean_mst_test.nim.html
title: verify/geometry/euclidean_mst_test.nim
---
