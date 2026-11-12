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
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/convex_polygon.nim
    title: cplib/geometry/convex_polygon.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/furthest_pair
    links:
    - https://judge.yosupo.jp/problem/furthest_pair
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/furthest_pair\n\
    include cplib/geometry/convex_polygon\nimport tables\n\nproc scanf(formatstr:\
    \ cstring): cint {.header: \"<stdio.h>\", varargs.}\nproc ii(): int = discard\
    \ scanf(\"%lld\", addr result)\nproc ll(): int64 = discard scanf(\"%lld\", addr\
    \ result)\n\nlet t = ii()\nfor _ in 0..<t:\n    let n = ii()\n    var firstIndex\
    \ = initTable[Point[int64], int]()\n    var unique: seq[Point[int64]]\n    for\
    \ i in 0..<n:\n        let x = ll()\n        let y = ll()\n        let p = initPoint(x,\
    \ y)\n        if not firstIndex.hasKey(p):\n            firstIndex[p] = i\n  \
    \          unique.add(p)\n    let answer = initConvexPolygon(convex_hull(unique)).diameter.get\n\
    \    let a = firstIndex[answer.endpoints[0]]\n    var b = firstIndex[answer.endpoints[1]]\n\
    \    # \u5168\u70B9\u540C\u4E00\u3067\u3082\u76F4\u5F84API\u306E\u7D50\u679C\u3092\
    \u4F7F\u3044\u3001\u7570\u306A\u308B\u5165\u529Bindex\u3078\u623B\u3059\u3002\n\
    \    if a == b: b = (a + 1) mod n\n    echo a, \" \", b\n"
  dependsOn:
  - cplib/geometry/convex_polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/convex_polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/geometry/furthest_pair_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:50:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/furthest_pair_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/furthest_pair_test.nim
- /verify/verify/geometry/furthest_pair_test.nim.html
title: verify/geometry/furthest_pair_test.nim
---
