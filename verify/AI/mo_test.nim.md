---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
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
    echo \"Hello World\"\n\nimport cplib/utils/mo\n\nlet a = @[1, 2, 3, 4, 5]\nvar\
    \ solver = initMo(a.len, 3, 2)\nsolver.insert(0, 3)\nsolver.insert(1, 5)\nsolver.insert(2,\
    \ 4)\n\nvar cur = 0\nvar ans = newSeq[int](3)\nsolver.run(\n  proc(i: int) = cur\
    \ += a[i],\n  proc(i: int) = cur += a[i],\n  proc(i: int) = cur -= a[i],\n  proc(i:\
    \ int) = cur -= a[i],\n  proc(idx: int) = ans[idx] = cur\n)\n\nassert ans == @[6,\
    \ 14, 7]\n"
  dependsOn:
  - cplib/utils/mo.nim
  - cplib/utils/mo.nim
  isVerificationFile: true
  path: verify/AI/mo_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/mo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/mo_test.nim
- /verify/verify/AI/mo_test.nim.html
title: verify/AI/mo_test.nim
---
