---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/sqrt_heuristic_for_floor_sum.nim
    title: cplib/math/sqrt_heuristic_for_floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/sqrt_heuristic_for_floor_sum.nim
    title: cplib/math/sqrt_heuristic_for_floor_sum.nim
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
    echo \"Hello World\"\n\nimport algorithm\nimport cplib/math/sqrt_heuristic_for_floor_sum\n\
    \nlet parts = sqrt_heuristic_for_floor_sum(3, 1, 10, 7)\nvar got: seq[(int, int)]\n\
    for part in parts:\n  for t in 0..<part.n:\n    got.add((part.x + part.dx * t,\
    \ part.y + part.dy * t))\ngot.sort()\nvar expected: seq[(int, int)]\nfor k in\
    \ 0..<10:\n  expected.add((k, (3 * k + 1) mod 7))\nassert got == expected\n"
  dependsOn:
  - cplib/math/sqrt_heuristic_for_floor_sum.nim
  - cplib/math/sqrt_heuristic_for_floor_sum.nim
  isVerificationFile: true
  path: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/sqrt_heuristic_for_floor_sum_test.nim
- /verify/verify/AI/sqrt_heuristic_for_floor_sum_test.nim.html
title: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
---
