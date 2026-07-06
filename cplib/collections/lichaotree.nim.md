---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lichaotree_test.nim
    title: verify/AI/lichaotree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lichaotree_test.nim
    title: verify/AI/lichaotree_test.nim
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
  code: "import sequtils,algorithm\nimport cplib/utils/constants\nimport bitops\n\n\
    type LiChaoTree = ref object\n    X : seq[int]\n    A : seq[int]\n    B : seq[int]\n\
    \    lastnode : int\n\nproc initLiChaoTree*(X:openArray[int]):LiChaoTree=\n  \
    \  ## LiChaoTree\u3092\u521D\u671F\u5316\u3057\u307E\u3059\n    ## get_min\u3067\
    \u7528\u3044\u308B\u53EF\u80FD\u6027\u306E\u3042\u308BX\u3092\u914D\u5217\u3067\
    \u4E0E\u3048\u3066\u304F\u3060\u3055\u3044\u3002\n    var X = X.sorted().deduplicate(true)\n\
    \    var lastnode = 1\n    while lastnode < len(X):\n        lastnode *= 2\n \
    \   result = LiChaoTree()\n    result.X = newseqwith(lastnode+1,int(INF32))\n\
    \    for i in 0..<len(X):\n        result.X[i] = X[i]\n    result.A = newseqwith(2*lastnode,0)\n\
    \    result.B = newseqwith(2*lastnode,INF64)\n    result.lastnode = lastnode\n\
    \nproc query(self:LiChaoTree,a,b,now:int)=\n    var a = a\n    var b = b\n   \
    \ var now = now\n    var length = self.lastnode shr fastLog2(now)\n    var i =\
    \ now xor (1 shl fastLog2(now))\n    var l = i*length\n    var r = (i+1)*length\n\
    \    while true:\n        var m = (l+r) shr 1\n        var left = self.X[l]*a+b\
    \ < self.X[l]*self.A[now]+self.B[now]\n        var right = self.X[r-1]*a+b < self.X[r-1]*self.A[now]+self.B[now]\n\
    \        var mid = self.X[m]*a+b < self.X[m]*self.A[now]+self.B[now]\n\n     \
    \   if left and right:\n            self.A[now] = a\n            self.B[now] =\
    \ b\n            return\n        elif (not left) and (not right):\n          \
    \  return\n        if mid:\n            swap(a,self.A[now])\n            swap(b,self.B[now])\n\
    \        if left != mid:\n            now = now*2\n            r = m\n       \
    \ else:\n            now = now*2+1\n            l = m\n\nproc add_line*(self:LiChaoTree,a,b:int)=\n\
    \    ## \u76F4\u7DDAax+b\u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\n    ## a\u306F\
    32bit\u6574\u6570\u306B\u53CE\u307E\u308B\u3088\u3046\u306B\u3057\u3066\u304F\u3060\
    \u3055\u3044\u3002\n    self.query(a,b,1)\n\nproc add_segment*(self:LiChaoTree,a,b,l,r:int)=\n\
    \    ## \u7DDA\u5206ax+b (l<=x<r)\u3092\u8FFD\u52A0\u3057\u307E\u3059\u3002\n\
    \    ## a\u306F32bit\u6574\u6570\u306B\u53CE\u307E\u308B\u3088\u3046\u306B\u3057\
    \u3066\u304F\u3060\u3055\u3044\u3002\n    var l = self.X.lowerBound(l)\n    var\
    \ r = self.X.lowerBound(r)\n\n    var q_left = l\n    var q_right = r\n    q_left\
    \ += self.lastnode\n    q_right += self.lastnode\n    while q_left < q_right:\n\
    \        if (q_left and 1) > 0:\n            self.query(a,b,q_left)\n        \
    \    q_left += 1\n        if (q_right and 1) > 0:\n            q_right -= 1\n\
    \            self.query(a,b,q_right)\n        q_left = q_left shr 1\n        q_right\
    \ = q_right shr 1\n\nproc get_min*(self:LiChaoTree,x:int):int=\n    ## x\u306B\
    \u304A\u3051\u308B\u6700\u5C0F\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n   \
    \ ## x\u306F32bit\u6574\u6570\u306B\u53CE\u307E\u308B\u3088\u3046\u306B\u3057\u3066\
    \u304F\u3060\u3055\u3044\u3002\n    ## \u7DDA\u5206\u304C\u5B58\u5728\u3057\u306A\
    \u3044\u5834\u5408\u3001INF64\u304C\u8FD4\u308A\u307E\u3059\u3002\n    ## x\u306F\
    \u521D\u671F\u5316\u6642\u306B\u4E0E\u3048\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\u3002\n    var now = self.X.binarySearch(x)\n    assert now != -1\n\
    \    now+=self.lastnode\n    result = INF64\n    while now != 0:\n        result\
    \ = min(result,self.A[now]*x+self.B[now])\n        now = now shr 1\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/collections/lichaotree.nim
  requiredBy: []
  timestamp: '2026-07-06 04:42:52+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lichaotree_test.nim
  - verify/AI/lichaotree_test.nim
documentation_of: cplib/collections/lichaotree.nim
layout: document
redirect_from:
- /library/cplib/collections/lichaotree.nim
- /library/cplib/collections/lichaotree.nim.html
title: cplib/collections/lichaotree.nim
---
