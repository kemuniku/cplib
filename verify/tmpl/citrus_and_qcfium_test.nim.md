---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/qcfium.nim
    title: cplib/tmpl/qcfium.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/qcfium.nim
    title: cplib/tmpl/qcfium.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/aplusb
    links:
    - https://judge.yosupo.jp/problem/aplusb
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb

    import strscans

    import cplib/tmpl/citrus

    include cplib/tmpl/qcfium


    var a, b: int

    discard stdin.readLine.scanf("$i $i", a, b)

    echo a + b

    '
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/tmpl/qcfium.nim
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/qcfium.nim
  - cplib/math/isqrt.nim
  - cplib/tmpl/citrus.nim
  isVerificationFile: true
  path: verify/tmpl/citrus_and_qcfium_test.nim
  requiredBy: []
  timestamp: '2024-02-08 04:44:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tmpl/citrus_and_qcfium_test.nim
layout: document
redirect_from:
- /verify/verify/tmpl/citrus_and_qcfium_test.nim
- /verify/verify/tmpl/citrus_and_qcfium_test.nim.html
title: verify/tmpl/citrus_and_qcfium_test.nim
---
