---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/math/int128


    let a = parseInt128("123456789012345678901234567890")

    let b = parseInt128("10")

    assert $a == "123456789012345678901234567890"

    assert $(a + b) == "123456789012345678901234567900"

    assert $((a + b) - a) == "10"

    assert $(b * b) == "100"

    assert $(parseInt128("100") div b) == "10"

    assert $(parseInt128("103") mod b) == "3"

    assert (parseInt128("5") & parseInt128("3")).to_int == 1

    assert (parseInt128("5") | parseInt128("2")).to_int == 7

    assert (parseInt128("5") ^ parseInt128("1")).to_int == 4

    assert (parseInt128("1") << parseInt128("5")).to_int == 32

    assert (parseInt128("32") >> parseInt128("2")).to_int == 8

    assert -b < b

    assert abs(-b) == b

    assert cmp(b, parseInt128("10")) == 0

    assert pow(parseInt128("2"), parseInt128("10")).to_int == 1024

    assert pow(parseInt128("2"), parseInt128("10"), parseInt128("1000")).to_int ==
    24

    '
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/int128_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/int128_test.nim
layout: document
redirect_from:
- /verify/verify/AI/int128_test.nim
- /verify/verify/AI/int128_test.nim.html
title: verify/AI/int128_test.nim
---
