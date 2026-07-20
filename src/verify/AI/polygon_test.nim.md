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
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/geometry/base\nimport cplib/geometry/polygon\n\
    import cplib/math/fractions\n\nlet square = initPolygon(@[initPoint(0, 0), initPoint(2,\
    \ 0), initPoint(2, 2), initPoint(0, 2)])\nassert square.len == 4\nassert square.toSeq\
    \ == @[initPoint(0, 0), initPoint(2, 0), initPoint(2, 2), initPoint(0, 2)]\nassert\
    \ square.area == 8\nassert square.is_convex\nassert square.is_convex_ccw\nassert\
    \ square.on_edge(initPoint(1, 0))\nassert square.contains(initPoint(1, 1))\nassert\
    \ square.contains(initPoint(1, 0))\nassert not square.contains(initPoint(1, 0),\
    \ true)\nassert not square.contains(initPoint(3, 3))\n\nlet fpoly = initPolygon(@[\n\
    \  initPoint(initFraction(0), initFraction(0)),\n  initPoint(initFraction(1),\
    \ initFraction(0)),\n  initPoint(initFraction(0), initFraction(1)),\n])\nassert\
    \ fpoly.area == initFraction(1, 2)\n\nlet hull = convex_hull(@[initPoint(0, 0),\
    \ initPoint(1, 1), initPoint(0, 1), initPoint(1, 0)])\nassert hull.len == 4\n\
    assert hull.area.abs == 2\n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/polygon_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/polygon_test.nim
layout: document
redirect_from:
- /verify/verify/AI/polygon_test.nim
- /verify/verify/AI/polygon_test.nim.html
title: verify/AI/polygon_test.nim
---
