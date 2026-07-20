---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/topk_sum_heapq.nim
    title: cplib/collections/topk_sum_heapq.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/topk_sum_heapq.nim
    title: cplib/collections/topk_sum_heapq.nim
  - icon: ':warning:'
    path: verify/collections/deletable_heapqueue_test_.nim
    title: verify/collections/deletable_heapqueue_test_.nim
  - icon: ':warning:'
    path: verify/collections/deletable_heapqueue_test_.nim
    title: verify/collections/deletable_heapqueue_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/deletable_heapqueue_test.nim
    title: verify/AI/deletable_heapqueue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/deletable_heapqueue_test.nim
    title: verify/AI/deletable_heapqueue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/topk_sum_heapq_test.nim
    title: verify/AI/topk_sum_heapq_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/topk_sum_heapq_test.nim
    title: verify/AI/topk_sum_heapq_test.nim
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
  code: "## \u5B58\u5728\u3057\u306A\u3044\u8981\u7D20\u3092\u6D88\u305D\u3046\u3068\
    \u3059\u308B\u3068\u30D0\u30B0\u308B\u306E\u3067\u6CE8\u610F\nwhen not declared\
    \ CPLIB_COLLECTIONS_DELETABLE_HEAPQUEUE:\n    const CPLIB_COLLECTIONS_DELETABLE_HEAPQUEUE*\
    \ = 1\n    import heapqueue\n    type Deletable_HeapQueue*[T] = object\n     \
    \   hq : HeapQueue[T]\n        dlhq : HeapQueue[T]\n\n    proc initDeletableHeapQueue*[T]():Deletable_HeapQueue[T]=\n\
    \        Deletable_HeapQueue[T](hq:initHeapQueue[T](),dlhq:initHeapQueue[T]())\n\
    \n    proc toDeletableHeapQueue*[T](v:openArray[T]):Deletable_HeapQueue[T]=\n\
    \        Deletable_HeapQueue[T](hq:(@v).toHeapQueue(),dlhq:initHeapQueue[T]())\n\
    \n    proc `[]`*[T](self:var Deletable_HeapQueue[T],i:Natural):T=\n        assert\
    \ i == 0\n        return self.hq[i]\n\n    proc delete*[T](self:var Deletable_HeapQueue[T],x:T)=\n\
    \        self.dlhq.push(x)\n        while len(self.dlhq) != 0 and len(self.hq)\
    \ != 0 and self.dlhq[0] == self.hq[0]:\n            discard self.dlhq.pop()\n\
    \            discard self.hq.pop()\n\n    proc push*[T](self:var Deletable_HeapQueue[T],x:T)=\n\
    \        self.hq.push(x)\n\n\n    proc pop*[T](self:var Deletable_HeapQueue[T]):T=\n\
    \        result = self.hq.pop()\n        while len(self.dlhq) != 0 and len(self.hq)\
    \ != 0 and self.dlhq[0] == self.hq[0]:\n            discard self.dlhq.pop()\n\
    \            discard self.hq.pop()\n\n    proc len*[T](self:var Deletable_HeapQueue[T]):int=\n\
    \        return len(self.hq)-len(self.dlhq)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/deletable_heapqueue.nim
  requiredBy:
  - cplib/collections/topk_sum_heapq.nim
  - cplib/collections/topk_sum_heapq.nim
  - verify/collections/deletable_heapqueue_test_.nim
  - verify/collections/deletable_heapqueue_test_.nim
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/deletable_heapqueue_test.nim
  - verify/AI/deletable_heapqueue_test.nim
  - verify/AI/topk_sum_heapq_test.nim
  - verify/AI/topk_sum_heapq_test.nim
documentation_of: cplib/collections/deletable_heapqueue.nim
layout: document
redirect_from:
- /library/cplib/collections/deletable_heapqueue.nim
- /library/cplib/collections/deletable_heapqueue.nim.html
title: cplib/collections/deletable_heapqueue.nim
---
