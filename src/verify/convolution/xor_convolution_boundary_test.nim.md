---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/xor_convolution.nim
    title: cplib/convolution/xor_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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
    echo \"Hello World\"\n\nimport random, sequtils\nimport cplib/convolution/xor_convolution\n\
    import cplib/modint/modint\n\nassert xorConvolution(@[2], @[3]) == @[6]\nassert\
    \ xorConvolution(@[-2], @[3]) == @[-6]\nvar singleton = @[7]\nFastHadamardTransForm(singleton)\n\
    assert singleton == @[7]\nlet a = @[modint998244353_montgomery.init(2)]\nlet b\
    \ = @[modint998244353_montgomery.init(3)]\nassert xorConvolution(a, b)[0].val\
    \ == 6\n\nvar rng = initRand(4900)\nfor power in 0..5:\n    let n = 1 shl power\n\
    \    for trial in 0..<20:\n        let a = newSeqWith(n, rng.rand(-10..10))\n\
    \        let b = newSeqWith(n, rng.rand(-10..10))\n        var expected = newSeq[int](n)\n\
    \        for i in 0..<n:\n            for j in 0..<n:\n                expected[i\
    \ xor j] += a[i] * b[j]\n        assert xorConvolution(a, b) == expected\n\ntemplate\
    \ expectAssertion(body: untyped) =\n    block:\n        var raised = false\n \
    \       try:\n            body\n        except AssertionDefect:\n            raised\
    \ = true\n        assert raised\n\nexpectAssertion:\n    discard xorConvolution(@[1,\
    \ 2], @[3])\nexpectAssertion:\n    discard xorConvolution(@[1, 2, 3], @[4, 5,\
    \ 6])\nexpectAssertion:\n    discard xorConvolution(newSeq[int](), newSeq[int]())\n\
    expectAssertion:\n    var invalid = @[1, 2, 3]\n    FastHadamardTransForm(invalid)\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/xor_convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/convolution/xor_convolution.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/convolution/xor_convolution_boundary_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:34:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/xor_convolution_boundary_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/xor_convolution_boundary_test.nim
- /verify/verify/convolution/xor_convolution_boundary_test.nim.html
title: verify/convolution/xor_convolution_boundary_test.nim
---
