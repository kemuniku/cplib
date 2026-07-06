---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/imos2d_test.nim
    title: verify/AI/imos2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/imos2d_test.nim
    title: verify/AI/imos2d_test.nim
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
  code: "when not declared CPLIB_UTILS_IMOS2D:\n    const CPLIB_UTILS_IMOS2D* = 1\n\
    \    import sequtils\n\n    type Imos2D* = ref object\n        B : seq[seq[int]]\n\
    \        H : int\n        W : int\n    \n    proc initImos2D*(H,W:int):Imos2D=\n\
    \        return Imos2D(B:newseqwith(H+1,newseqwith(W+1,0)),H:H,W:W)\n    \n  \
    \  proc rectangle_add*(self:Imos2D,il,ir,jl,jr,x:int)=\n        # i in [il,ir)\
    \ j in [jl,jr)\u3092\u6E80\u305F\u3059\u3088\u3046\u306A\u30DE\u30B9\u306Bx\u3092\
    \u52A0\u7B97\u3059\u308B\n        self.B[il][jl] += x\n        self.B[il][jr]\
    \ -= x\n        self.B[ir][jl] -= x\n        self.B[ir][jr] += x\n    \n    proc\
    \ build*(self:Imos2D):seq[seq[int]]=\n        result = newseqwith(self.H,newseqwith(self.W,0))\n\
    \        for i in 0..<(self.H):\n            for j in 0..<(self.W):\n        \
    \        result[i][j] = self.B[i][j]\n                if i != 0:\n           \
    \         result[i][j] += result[i-1][j]\n                if j != 0:\n       \
    \             result[i][j] += result[i][j-1]\n                if i != 0 and j\
    \ != 0:\n                    result[i][j] -= result[i-1][j-1]\n        return\
    \ result\n\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/imos2d.nim
  requiredBy: []
  timestamp: '2026-05-26 04:57:32+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/imos2d_test.nim
  - verify/AI/imos2d_test.nim
documentation_of: cplib/utils/imos2d.nim
layout: document
redirect_from:
- /library/cplib/utils/imos2d.nim
- /library/cplib/utils/imos2d.nim.html
title: cplib/utils/imos2d.nim
---
