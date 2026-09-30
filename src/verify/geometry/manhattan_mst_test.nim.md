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
    path: cplib/geometry/manhattan_mst.nim
    title: cplib/geometry/manhattan_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/manhattan_mst.nim
    title: cplib/geometry/manhattan_mst.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/manhattanmst
    links:
    - https://judge.yosupo.jp/problem/manhattanmst
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/manhattanmst\n\
    import cplib/geometry/manhattan_mst\ninclude cplib/tmpl/fastio\n\nlet n = ii()\n\
    var points = newSeq[(int64, int64)](n)\nfor i in 0..<n:\n    points[i] = (int64(ii()),\
    \ int64(ii()))\nlet edges = manhattan_mst(points)\nvar total = 0'i64\nfor (u,\
    \ v) in edges:\n    total += abs(points[u][0] - points[v][0]) + abs(points[u][1]\
    \ - points[v][1])\necho total\nfor (u, v) in edges:\n    echo u, \" \", v\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  - cplib/geometry/manhattan_mst.nim
  - cplib/tmpl/fastio.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/manhattan_mst.nim
  isVerificationFile: true
  path: verify/geometry/manhattan_mst_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:31:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/manhattan_mst_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/manhattan_mst_test.nim
- /verify/verify/geometry/manhattan_mst_test.nim.html
title: verify/geometry/manhattan_mst_test.nim
---
