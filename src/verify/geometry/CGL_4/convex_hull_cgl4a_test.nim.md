---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':question:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':question:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':question:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':question:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':question:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':question:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':question:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_A\n\
    include cplib/geometry/polygon\nimport sequtils, strformat\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n = ii()\nproc get(): Point[int] = initPoint(ii(),\
    \ ii())\nvar v = newSeqWith(n, get())\nvar ans = convex_hull(v, false)\necho ans.len\n\
    var ps = (10001, 10001)\nvar s = 0\nfor i in 0..<ans.len:\n    if ps > (ans.v[i].y,\
    \ ans.v[i].x):\n        s = i\n        ps = (ans.v[i].y, ans.v[i].x)\nfor i in\
    \ 0..<ans.len:\n    var pi = ans.v[(i+s) mod ans.len]\n    echo &\"{pi.x} {pi.y}\"\
    \n"
  dependsOn:
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
  requiredBy: []
  timestamp: '2025-03-09 17:42:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
- /verify/verify/geometry/CGL_4/convex_hull_cgl4a_test.nim.html
title: verify/geometry/CGL_4/convex_hull_cgl4a_test.nim
---
