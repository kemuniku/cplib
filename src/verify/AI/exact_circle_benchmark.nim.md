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
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import times, strformat\nimport cplib/geometry/base\nimport cplib/geometry/circle\n\
    import cplib/math/fractions\nlet integer = initCircle(initPoint(0, 0), initPoint(100,\
    \ 0), initPoint(0, 100))\nlet rational = initCircle(initPoint(initFraction(1,\
    \ 3), initFraction(2, 7)), 100)\nvar sum = 0\nvar start = cpuTime()\nfor i in\
    \ 0..<100000:\n    sum += ord(integer.contains(initPoint(i mod 201 - 100, (i div\
    \ 201) mod 201 - 100)))\necho &\"int: 100000 contains, CPU {cpuTime()-start:.3f}s,\
    \ checksum {sum}\"\nstart = cpuTime()\nsum = 0\nfor i in 0..<10000:\n    sum +=\
    \ ord(rational.contains(initPoint(initFraction(i mod 201 - 100, 3), initFraction((i\
    \ div 201) mod 201 - 100, 7))))\necho &\"Fraction[int]: 10000 contains, CPU {cpuTime()-start:.3f}s,\
    \ checksum {sum}\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  isVerificationFile: false
  path: verify/AI/exact_circle_benchmark.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/AI/exact_circle_benchmark.nim
layout: document
redirect_from:
- /library/verify/AI/exact_circle_benchmark.nim
- /library/verify/AI/exact_circle_benchmark.nim.html
title: verify/AI/exact_circle_benchmark.nim
---
