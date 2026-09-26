---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/replayable_input.nim
    title: cplib/tmpl/replayable_input.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/replayable_input.nim
    title: cplib/tmpl/replayable_input.nim
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
    \ninclude cplib/tmpl/fastio\nimport cplib/tmpl/replayable_input\n\nreplayableInput:\n\
    \    let q = ii()\n    var sums: seq[int]\n    peekInput:\n        for _ in 0\
    \ ..< q:\n            let values = lii(2)\n            sums.add(values[0] + values[1])\n\
    \    for i in 0 ..< q:\n        let a = ii()\n        let b = input(int)\n   \
    \     doAssert a + b == sums[i]\n        print(a + b)\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/replayable_input.nim
  - cplib/tmpl/replayable_input.nim
  isVerificationFile: true
  path: verify/tmpl/replayable_input_many_aplusb_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:22:45+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tmpl/replayable_input_many_aplusb_test.nim
layout: document
redirect_from:
- /verify/verify/tmpl/replayable_input_many_aplusb_test.nim
- /verify/verify/tmpl/replayable_input_many_aplusb_test.nim.html
title: verify/tmpl/replayable_input_many_aplusb_test.nim
---
