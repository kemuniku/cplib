---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/xor_basis_test.nim
    title: verify/AI/xor_basis_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/xor_basis_test.nim
    title: verify/AI/xor_basis_test.nim
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
  code: "when not declared CPLIB_MATH_XOR_BASIS:\n    const CPLIB_MATH_XOR_BASIS*\
    \ = 1\n    import algorithm\n\n    type XorBasis* = ref object\n        basis*\
    \ : seq[int]\n\n    proc initXorBasis*(A:openArray[int]):XorBasis=\n        result\
    \ = XorBasis()\n        for i in 0..<len(A):\n            var e = A[i]\n     \
    \       for b in result.basis:\n                if (e xor b) < e:\n          \
    \          e = e xor b\n            if e != 0:\n                for j in 0..<len(result.basis):\n\
    \                    if (e xor result.basis[j]) < result.basis[j]:\n         \
    \               result.basis[j] = result.basis[j] xor e\n                result.basis.add(e)\n\
    \        result.basis.sort()\n\n    proc initXorBasis*():XorBasis=\n        result\
    \ = XorBasis()\n\n    proc incl*(self:XorBasis,x:int)=\n        var e = x\n  \
    \      for b in self.basis:\n            if (e xor b) < e:\n                e\
    \ = e xor b\n        if e != 0:\n            for j in 0..<len(self.basis):\n \
    \               if (e xor self.basis[j]) < self.basis[j]:\n                  \
    \  self.basis[j] = self.basis[j] xor e\n            self.basis.add(e)\n      \
    \      self.basis.sort() # <- \u307B\u3093\u307E\u304B\uFF1F\n\n    proc len_basis*(self:XorBasis):int=\n\
    \        ## \u57FA\u5E95\u306E\u672C\u6570\u3092\u8FD4\u3059\n        return len(self.basis)\n\
    \n    proc can_make*(self:XorBasis,x:int):bool=\n        ## \u57FA\u5E95\u306E\
    XOR\u548C\u3067x\u304C\u4F5C\u6210\u53EF\u80FD\u304B\uFF1F\n        var e = x\n\
    \        for b in self.basis:\n            if (e xor b) < e:\n               \
    \ e = e xor b\n        return e == 0\n\n    proc kth_smallest*(self:XorBasis,k:int):int=\n\
    \        ## \u4F5C\u6210\u53EF\u80FD\u306A\u5024\u306E\u4E2D\u3067k\u756A\u76EE\
    \u306B\u5C0F\u3055\u3044\u3082\u306E\u3092\u6C42\u3081\u307E\u3059\u3002\n   \
    \     ## \u5B58\u5728\u3057\u306A\u3044\u5834\u5408\u306F\u3001-1\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        if k >= (1 shl len(self.basis)):\n            return\
    \ -1\n        for i in 0..<len(self.basis):\n            if (k and (1 shl i))\
    \ != 0:\n                result = result xor self.basis[i]\n\n    proc lt*(self:XorBasis,x:int):int=\n\
    \        ## \u4F5C\u6210\u53EF\u80FD\u306A\u5024\u306E\u4E2D\u3067x\u672A\u6E80\
    \u306E\u5185\u6700\u5927\u306E\u3082\u306E\n        ## \u5B58\u5728\u3057\u306A\
    \u3044\u5834\u5408\u306F-1\n        if x == 0:\n            return -1\n      \
    \  for i in countdown(len(self.basis)-1,0,1):\n            if (result xor self.basis[i])\
    \ < x:\n                result = result xor self.basis[i]\n\n    proc le*(self:XorBasis,x:int):int=\n\
    \        ## \u4F5C\u6210\u53EF\u80FD\u306A\u5024\u306E\u4E2D\u3067x\u4EE5\u4E0B\
    \u306E\u5185\u6700\u5927\u306E\u3082\u306E\n        for i in countdown(len(self.basis)-1,0,1):\n\
    \            if (result xor self.basis[i]) <= x:\n                result = result\
    \ xor self.basis[i]\n\n    proc index*(self:XorBasis,x:int):int=\n        ## \u4F5C\
    \u6210\u53EF\u80FD\u306A\u5024\u306E\u4E2D\u3067x\u304C\u5C0F\u3055\u3044\u65B9\
    \u304B\u3089\u4F55\u756A\u76EE\u304B\n        ## \u3069\u306E\u57FA\u5E95\u3092\
    \u4F7F\u3046\u304B\u3082\u30B3\u30EC\u306E\u7D50\u679C\u3092seq[bool]\u3068\u3057\
    \u3066\u898B\u308C\u3070\u308F\u304B\u308B\n        var x = x\n        for i in\
    \ 0..<len(self.basis):\n            if (x xor self.basis[i]) < x:\n          \
    \      x = x xor self.basis[i]\n                result += (1 shl i)\n\n    proc\
    \ xor_min*(self:XorBasis,x:int):int=\n        ## \u4F5C\u6210\u53EF\u80FD\u306A\
    \u5024\u306E\u4E2D\u3067x\u3068xor\u3092\u53D6\u3063\u305F\u3068\u304D\u306B\u5024\
    \u304C\u6700\u5C0F\u3068\u306A\u308B\u3082\u306E\u3092\u6C42\u3081\u308B\n   \
    \     result = x\n        for i in countdown(len(self.basis)-1,0,1):\n       \
    \     if (result xor self.basis[i]) < result:\n                result = result\
    \ xor self.basis[i]\n        result = result xor x\n\n    proc xor_kth*(self:XorBasis,x:int,k:int):int=\n\
    \        ## \u4F5C\u6210\u53EF\u80FD\u306A\u5024\u306E\u4E2D\u3067x\u3068xor\u3092\
    \u53D6\u3063\u305F\u3068\u304D\u306Bk\u756A\u76EE\u306B\u5C0F\u3055\u304F\u306A\
    \u308B\u3082\u306E\n        ## \u5B58\u5728\u3057\u306A\u3044\u306A\u3089\u3070\
    -1\u3092\u8FD4\u3059\u3002\n        if k >= (1 shl len(self.basis)):\n       \
    \     return -1\n        \n        var v = self.xor_min(x) xor x\n        for\
    \ i in countdown(len(self.basis)-1,0,1):\n            if (v xor self.basis[i])\
    \ < v:\n                v = v xor self.basis[i]\n        return (v xor self.kth_smallest(k))\
    \ xor x\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/xor_basis.nim
  requiredBy: []
  timestamp: '2026-07-07 07:24:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/xor_basis_test.nim
  - verify/AI/xor_basis_test.nim
documentation_of: cplib/math/xor_basis.nim
layout: document
redirect_from:
- /library/cplib/math/xor_basis.nim
- /library/cplib/math/xor_basis.nim.html
title: cplib/math/xor_basis.nim
---
