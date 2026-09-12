---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/area_of_union_of_rectangles.nim
    title: cplib/utils/area_of_union_of_rectangles.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/area_of_union_of_rectangles.nim
    title: cplib/utils/area_of_union_of_rectangles.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/area_of_union_of_rectangles
    links:
    - https://judge.yosupo.jp/problem/area_of_union_of_rectangles
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/area_of_union_of_rectangles\n\
    import cplib/utils/area_of_union_of_rectangles\ninclude cplib/tmpl/sheep\nvar\
    \ N = ii()\n\nvar tmp : seq[(int,int,int,int)]\n\nfor _ in range(N):\n    var\
    \ l,d,r,u = ii()\n    tmp.add((l,d,r,u))\n\nprint area_of_union_of_rectangles(tmp)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/area_of_union_of_rectangles.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/area_of_union_of_rectangles.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/utils/area_of_union_of_rectangles_test.nim
  requiredBy: []
  timestamp: '2026-09-12 10:21:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/area_of_union_of_rectangles_test.nim
layout: document
redirect_from:
- /verify/verify/utils/area_of_union_of_rectangles_test.nim
- /verify/verify/utils/area_of_union_of_rectangles_test.nim.html
title: verify/utils/area_of_union_of_rectangles_test.nim
---
