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
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
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
    ERROR: 1e-8
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_G
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_G
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_G\n\
    # verification-helper: ERROR 1e-8\ninclude cplib/geometry/circle\nimport algorithm,\
    \ strformat\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc number(): float = scanf(\"%lf\", addr result)\nproc integer(): int = scanf(\"\
    %lld\", addr result)\nproc point(): Point[float] = initPoint(number(), number())\n\
    proc compare(a, b: Point[float]): int =\n    if a.x != b.x: cmp(a.x, b.x)\n  \
    \  else: cmp(a.y, b.y)\nproc output(points: seq[Point[float]]) =\n    var sorted\
    \ = points\n    sorted.sort(compare)\n    for i, p in sorted:\n        if i >\
    \ 0: stdout.write(\" \")\n        stdout.write(&\"{p.x:.10f} {p.y:.10f}\")\n \
    \   stdout.write(\"\\n\")\nlet a = initCircle(point(), number())\nlet b = initCircle(point(),\
    \ number())\nvar outputPoints: seq[Point[float]]\nfor t in common_tangents(a,\
    \ b).tangents: outputPoints.add(t.first)\noutputPoints.sort(compare)\nfor p in\
    \ outputPoints: echo &\"{p.x:.10f} {p.y:.10f}\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: true
  path: verify/geometry/CGL_7/circle_common_tangents_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_7/circle_common_tangents_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_7/circle_common_tangents_test.nim
- /verify/verify/geometry/CGL_7/circle_common_tangents_test.nim.html
title: verify/geometry/CGL_7/circle_common_tangents_test.nim
---
