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
    PROBLEM: https://judge.yosupo.jp/problem/static_convex_hull
    links:
    - https://judge.yosupo.jp/problem/static_convex_hull
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_convex_hull\n\
    import cplib/geometry/base\nimport cplib/geometry/polygon\n\nproc scanf(formatstr:\
    \ cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii(): int64 {.inline.} = scanf(\"\
    %lld\", addr result)\n\nlet t = int(ii())\nfor caseIndex in 0..<t:\n    let n\
    \ = int(ii())\n    var points = newSeq[Point[int64]](n)\n    for i in 0..<n:\n\
    \        let x = ii()\n        let y = ii()\n        points[i] = initPoint(x,\
    \ y)\n    let answer = convex_hull(points, true)\n    echo answer.len\n    for\
    \ p in answer:\n        echo p.x, \" \", p.y\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/geometry/static_convex_hull_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:20:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/static_convex_hull_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/static_convex_hull_test.nim
- /verify/verify/geometry/static_convex_hull_test.nim.html
title: verify/geometry/static_convex_hull_test.nim
---
