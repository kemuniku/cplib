---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/convolution/xor_convolution_test.nim
    title: verify/convolution/xor_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/xor_convolution_test.nim
    title: verify/convolution/xor_convolution_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import bitops\nproc FastHadamardTransForm*[T](u:var seq[T])=\n    var n =\
    \ len(u)\n    var i = 1\n    while i<n:\n        for j in 0..<(n):\n         \
    \   if (j and i) == 0:\n                var x = u[j]\n                var y =\
    \ u[j+i]\n                u[j] = x+y\n                u[j+i] = x-y\n        i\
    \ = i shl 1\n\nproc xorConvolution*[T](u,v:seq[T]):seq[T]=\n    var u = u;var\
    \ v = v;\n    FastHadamardTransForm(u)\n    FastHadamardTransForm(v)\n    for\
    \ i in 0..<len(u):\n        u[i] *= v[i]\n    FastHadamardTransForm(u)\n    when\
    \ T is int:\n        var k = (len(u)-1).fastLog2() + 1\n        assert len(u)\
    \ == (1 shl k)\n        for i in 0..<len(u):\n            u[i] = u[i] shr k\n\
    \        return u\n    else:\n        var inv = T(1)/T(len(u))\n        for i\
    \ in 0..<len(u):\n            u[i] *= inv\n        return u\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/convolution/xor_convolution.nim
  requiredBy: []
  timestamp: '2025-03-09 17:38:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/convolution/xor_convolution_test.nim
  - verify/convolution/xor_convolution_test.nim
documentation_of: cplib/convolution/xor_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/xor_convolution.nim
- /library/cplib/convolution/xor_convolution.nim.html
title: cplib/convolution/xor_convolution.nim
---
