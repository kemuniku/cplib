---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/parallel_unionfind_test.nim
    title: verify/AI/parallel_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/parallel_unionfind_test.nim
    title: verify/AI/parallel_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/parallel_unionfind_test.nim
    title: verify/collections/parallel_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/parallel_unionfind_test.nim
    title: verify/collections/parallel_unionfind_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_PARALLEL_UNIONFIND:\n    const CPLIB_COLLECTIONS_PARALLEL_UNIONFIND*\
    \ = 1\n    import sequtils\n\n    type ParallelUnionFind* = ref object\n     \
    \   data: seq[int32]\n        offsets: seq[int]\n        n, components: int\n\n\
    \    proc initParallelUnionFind*(N: int): ParallelUnionFind =\n        ## N\u9802\
    \u70B9\u3067\u521D\u671F\u5316\u3057\u307E\u3059\u3002\u6642\u9593\u30FB\u7A7A\
    \u9593 O(N log N)\u3002\n        assert N >= 0\n        result = ParallelUnionFind(n:\
    \ N, components: N)\n        var total = 0\n        var width = 1\n        while\
    \ width <= N:\n            result.offsets.add(total)\n            let size = N\
    \ - width + 1\n            assert size <= high(int32).int - total\n          \
    \  total += size\n            if width > N div 4: break\n            width *=\
    \ 4\n        result.data = newSeqWith(total, -1'i32)\n\n    proc find(self: ParallelUnionFind,\
    \ x: int): int {.inline.} =\n        ## \u5185\u90E8\u306E\u9802\u70B9\u306E\u4EE3\
    \u8868\u3092\u7D4C\u8DEF\u5727\u7E2E\u3067\u6C42\u3081\u307E\u3059\u3002\u511F\
    \u5374 O(\u03B1(N))\u3002\n        result = x\n        while self.data[result]\
    \ >= 0:\n            result = self.data[result].int\n        var cur = x\n   \
    \     while cur != result:\n            let next = self.data[cur].int\n      \
    \      self.data[cur] = result.int32\n            cur = next\n\n    proc root*(self:\
    \ ParallelUnionFind, x: int): int =\n        ## x\u306E\u5C5E\u3059\u308B\u6210\
    \u5206\u306E\u4EE3\u8868\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374 O(\u03B1\
    (N))\u3002\n        assert 0 <= x and x < self.n\n        self.find(x)\n\n   \
    \ proc issame*(self: ParallelUnionFind, x, y: int): bool =\n        ## x\u3068\
    y\u304C\u540C\u3058\u6210\u5206\u306B\u5C5E\u3059\u308B\u304B\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u511F\u5374 O(\u03B1(N))\u3002\n        self.root(x) == self.root(y)\n\
    \n    proc siz*(self: ParallelUnionFind, x: int): int =\n        ## x\u306E\u5C5E\
    \u3059\u308B\u6210\u5206\u306E\u9802\u70B9\u6570\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\u511F\u5374 O(\u03B1(N))\u3002\n        -self.data[self.root(x)].int\n\n\
    \    proc count*(self: ParallelUnionFind): int =\n        ## \u9023\u7D50\u6210\
    \u5206\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.components\n\
    \n    proc roots*(self: ParallelUnionFind): seq[int] =\n        ## \u5404\u6210\
    \u5206\u306E\u4EE3\u8868\u3092\u5217\u6319\u3057\u307E\u3059\u3002O(N)\u3002\n\
    \        result = newSeqOfCap[int](self.components)\n        for x in 0..<self.n:\n\
    \            if self.data[x] < 0: result.add(x)\n\n    proc uniteBlock(self: ParallelUnionFind,\
    \ p, dis, layer: int,\n                    onMerge: proc(x, y: int) {.closure.})\
    \ =\n        ## \u9577\u30554^layer\u306E\u533A\u9593\u3092\u7D50\u5408\u3057\u3001\
    \u5FC5\u8981\u306A\u5834\u5408\u3060\u3051\u4E0B\u306E\u5C64\u3078\u4F1D\u64AD\
    \u3057\u307E\u3059\u3002\n        let base = self.offsets[layer]\n        var\
    \ x = self.find(base + p)\n        var y = self.find(base + p + dis)\n       \
    \ if x == y: return\n        if self.data[x] > self.data[y]: swap(x, y)\n    \
    \    if layer == 0 and onMerge != nil:\n            onMerge(x, y)\n        self.data[x]\
    \ += self.data[y]\n        self.data[y] = x.int32\n        if layer == 0:\n  \
    \          dec self.components\n            return\n        let step = 1 shl (2\
    \ * layer - 2)\n        for i in 0..<4:\n            self.uniteBlock(p + i * step,\
    \ dis, layer - 1, onMerge)\n\n    proc unite*(self: ParallelUnionFind, a, b, len:\
    \ int,\n                onMerge: proc(x, y: int) {.closure.} = nil): int {.discardable.}\
    \ =\n        ## \u5404i in 0..<len\u306B\u3064\u3044\u3066a+i\u3068b+i\u3092\u7D50\
    \u5408\u3057\u3001\u5B9F\u969B\u306E\u7D50\u5408\u56DE\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        ## Q\u56DE\u306E\u533A\u9593\u7D50\u5408\u306E\u5408\
    \u8A08 O(N log N \u03B1(N) + Q log N)\uFF08\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\
    \u306E\u51E6\u7406\u3092\u9664\u304F\uFF09\u3002\n        ## onMerge(x, y)\u306F\
    \u7D50\u5408\u76F4\u524D\u306B\u547C\u3073\u3001\u7D50\u5408\u5F8C\u306Fx\u304C\
    \u4EE3\u8868\u306B\u306A\u308A\u307E\u3059\u3002\n        ## \u30B3\u30FC\u30EB\
    \u30D0\u30C3\u30AF\u304B\u3089\u3053\u306E\u69CB\u9020\u3078\u306E\u7D50\u5408\
    \u64CD\u4F5C\u306F\u884C\u308F\u306A\u3044\u3067\u304F\u3060\u3055\u3044\u3002\
    \n        assert 0 <= a and a <= self.n and 0 <= b and b <= self.n\n        assert\
    \ 0 <= len and len <= self.n - a and len <= self.n - b\n        if a == b or len\
    \ == 0: return 0\n        let la = min(a, b)\n        let dis = max(a, b) - la\n\
    \        var layer = 0\n        var width = 1\n        while width <= (len - 1)\
    \ div 4:\n            inc layer\n            width *= 4\n        let before =\
    \ self.components\n        var remaining = len\n        while remaining > 0:\n\
    \            remaining = max(0, remaining - width)\n            self.uniteBlock(la\
    \ + remaining, dis, layer, onMerge)\n        before - self.components\n\n    proc\
    \ unite*(self: ParallelUnionFind, a, b: int,\n                onMerge: proc(x,\
    \ y: int) {.closure.} = nil): bool {.discardable.} =\n        ## 2\u9802\u70B9\
    \u3092\u7D50\u5408\u3057\u3001\u7570\u306A\u308B\u6210\u5206\u3092\u7D50\u5408\
    \u3057\u305F\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374 O(\u03B1(N))\u3002\
    \n        self.unite(a, b, 1, onMerge) != 0\n\n    proc copy*(self: ParallelUnionFind):\
    \ ParallelUnionFind =\n        ## \u72EC\u7ACB\u306A\u30B3\u30D4\u30FC\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(N log N)\u3002\n    \
    \    ParallelUnionFind(data: self.data, offsets: self.offsets,\n             \
    \            n: self.n, components: self.components)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/parallel_unionfind.nim
  requiredBy: []
  timestamp: '2026-09-08 16:08:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/parallel_unionfind_test.nim
  - verify/collections/parallel_unionfind_test.nim
  - verify/AI/parallel_unionfind_test.nim
  - verify/AI/parallel_unionfind_test.nim
documentation_of: cplib/collections/parallel_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/parallel_unionfind.nim
- /library/cplib/collections/parallel_unionfind.nim.html
title: cplib/collections/parallel_unionfind.nim
---
