---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/runenumerate
    links:
    - https://judge.yosupo.jp/problem/runenumerate
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/runenumerate\n\
    \nimport cplib/str/run_enumerate\n\nlet s = stdin.readLine\nlet ans = run_enumerate(s)\n\
    echo ans.len\nfor (p, l, r) in ans:\n    echo p, \" \", l, \" \", r\n"
  dependsOn:
  - cplib/str/run_enumerate.nim
  - cplib/str/run_enumerate.nim
  - cplib/str/zalgorithm.nim
  - cplib/str/zalgorithm.nim
  isVerificationFile: true
  path: verify/str/run_enumerate_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-07-09 09:03:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/run_enumerate_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/str/run_enumerate_yosupo_test.nim
- /verify/verify/str/run_enumerate_yosupo_test.nim.html
title: verify/str/run_enumerate_yosupo_test.nim
---
