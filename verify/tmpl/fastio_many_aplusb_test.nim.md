---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/many_aplusb
    links:
    - https://judge.yosupo.jp/problem/many_aplusb
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb\n\
    \ninclude cplib/tmpl/fastio\n\nlet queryCount = input(int)\nlet values = input(queryCount\
    \ * 2, int)\nfor query in 0 ..< queryCount:\n    print(values[query * 2] + values[query\
    \ * 2 + 1])\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/tmpl/fastio_many_aplusb_test.nim
  requiredBy: []
  timestamp: '2026-09-05 05:19:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tmpl/fastio_many_aplusb_test.nim
layout: document
redirect_from:
- /verify/verify/tmpl/fastio_many_aplusb_test.nim
- /verify/verify/tmpl/fastio_many_aplusb_test.nim.html
title: verify/tmpl/fastio_many_aplusb_test.nim
---
