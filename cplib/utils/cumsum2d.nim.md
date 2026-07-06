---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/cumsum2d_test.nim
    title: verify/AI/cumsum2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/cumsum2d_test.nim
    title: verify/AI/cumsum2d_test.nim
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
  code: "when not declared CPLIB_UTILS_CUMSUM2D:\n    const CPLIB_UTILS_CUMSUM2D*\
    \ = 1\n    import sequtils\n\n    type Cumsum2D* = ref object\n        B : seq[seq[int]]\n\
    \        H : int\n        W : int\n    \n    proc toCumSum2D*(X:openArray[seq[int]]):Cumsum2D=\n\
    \        var H = len(X)\n        var W = if H != 0 : len(X[0]) else: 0\n     \
    \   var B = newseqwith(H+1,newseqwith(W+1,0))\n        for i in 1..H:\n      \
    \      for j in 1..W:\n                B[i][j] = B[i-1][j] + B[i][j-1] - B[i-1][j-1]\
    \ + X[i-1][j-1]\n\n        result = Cumsum2D(B:B,H:H,W:W)\n    \n    proc query*(self:Cumsum2D,il,ir,jl,jr:int):int=\n\
    \        # i in [il,ir) j in [jl,jr)\u3092\u6E80\u305F\u3059\u3088\u3046\u306A\
    \u30DE\u30B9\u306E\u7DCF\u548C\n        return self.B[ir][jr] - self.B[ir][jl]\
    \ - self.B[il][jr] + self.B[il][jl]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/cumsum2d.nim
  requiredBy: []
  timestamp: '2026-07-06 04:42:52+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/cumsum2d_test.nim
  - verify/AI/cumsum2d_test.nim
documentation_of: cplib/utils/cumsum2d.nim
layout: document
redirect_from:
- /library/cplib/utils/cumsum2d.nim
- /library/cplib/utils/cumsum2d.nim.html
title: cplib/utils/cumsum2d.nim
---
