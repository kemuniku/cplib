---
data:
  _extendedDependsOn:
  - icon: ':x:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  - icon: ':x:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_TOPK_SUM_HEAPQ:\n    const CPLIB_COLLECTIONS_TOPK_SUM_HEAPQ*\
    \ = 1\n    import heapqueue\n    import algorithm\n    import cplib/collections/deletable_heapqueue\n\
    \    type TopK_sum_heapq = ref object\n        G : Deletable_HeapQueue[int]\n\
    \        L : Deletable_HeapQueue[int]\n        sm : int\n        topk : int\n\
    \        k : int\n\n    proc initTopKHeapq*(v:seq[int],k:int):TopK_sum_heapq=\n\
    \        result = TopK_sum_heapq(G:initDeletableHeapQueue[int](),L:initDeletableHeapQueue[int](),sm:0,topk:0,k:k)\n\
    \        var v = v.sorted()\n        for i in 0..<k:\n            result.G.push(v[i])\n\
    \            result.sm += v[i]\n            result.topk += v[i]\n        for i\
    \ in k..<len(v):\n            result.L.push(-v[i])\n            result.sm += v[i]\n\
    \n\n    proc incl*(self:TopK_sum_heapq,x:int)=\n        self.sm += x\n       \
    \ if len(self.G) < self.k:\n            self.topk += x\n            self.G.push(x)\n\
    \        elif self.k == 0:\n            self.L.push(-x)\n        elif self.G[0]\
    \ <= x:\n            self.topk += x\n            self.G.push(x)\n            var\
    \ tmp = self.G.pop()\n            self.L.push(-tmp)\n            self.topk -=\
    \ tmp\n        else:\n            self.L.push(-x)\n\n    proc excl*(self:TopK_sum_heapq,x:int)=\n\
    \        self.sm -= x\n        if self.k == 0:\n            self.L.delete(-x)\n\
    \        elif self.G[0] <= x:\n            self.topk -= x\n            self.G.delete(x)\n\
    \            if len(self.L) > 0:\n                var tmp = -self.L.pop()\n  \
    \              self.G.push(tmp)\n                self.topk += tmp\n        else:\n\
    \            self.L.delete(-x)\n\n    proc addK*(self:TopK_sum_heapq)=\n     \
    \   var tmp = -self.L.pop()\n        self.topk += tmp\n        self.k += 1\n \
    \       self.G.push(tmp)"
  dependsOn:
  - cplib/collections/deletable_heapqueue.nim
  - cplib/collections/deletable_heapqueue.nim
  isVerificationFile: false
  path: cplib/collections/topk_sum_heapq.nim
  requiredBy: []
  timestamp: '2025-03-09 17:51:55+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/topk_sum_heapq.nim
layout: document
redirect_from:
- /library/cplib/collections/topk_sum_heapq.nim
- /library/cplib/collections/topk_sum_heapq.nim.html
title: cplib/collections/topk_sum_heapq.nim
---
