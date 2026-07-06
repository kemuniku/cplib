---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
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


    import cplib/convolution/xor_convolution


    var f = @[1, 2, 3, 4]

    FastHadamardTransForm(f)

    assert f == @[10, -2, -4, 0]

    FastHadamardTransForm(f)

    assert f == @[4, 8, 12, 16]


    assert xorConvolution(@[1, 2], @[3, 4]) == @[11, 10]

    assert xorConvolution(@[1, 0, 2, 1], @[0, 3, 1, 2]) == @[4, 8, 4, 8]

    '
  dependsOn:
  - cplib/convolution/xor_convolution.nim
  - cplib/convolution/xor_convolution.nim
  isVerificationFile: true
  path: verify/AI/xor_convolution_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/xor_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/AI/xor_convolution_test.nim
- /verify/verify/AI/xor_convolution_test.nim.html
title: verify/AI/xor_convolution_test.nim
---
