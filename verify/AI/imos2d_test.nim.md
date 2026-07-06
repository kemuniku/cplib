---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/imos2d.nim
    title: cplib/utils/imos2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/imos2d.nim
    title: cplib/utils/imos2d.nim
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
    echo \"Hello World\"\n\nimport cplib/utils/imos2d\n\nlet im = initImos2D(3, 4)\n\
    im.rectangle_add(0, 2, 1, 3, 5)\nim.rectangle_add(1, 3, 2, 4, 2)\nassert im.build\
    \ == @[\n  @[0, 5, 5, 0],\n  @[0, 5, 7, 2],\n  @[0, 0, 2, 2],\n]\n"
  dependsOn:
  - cplib/utils/imos2d.nim
  - cplib/utils/imos2d.nim
  isVerificationFile: true
  path: verify/AI/imos2d_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/imos2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/imos2d_test.nim
- /verify/verify/AI/imos2d_test.nim.html
title: verify/AI/imos2d_test.nim
---
