---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_random_test.nim
    title: verify/AI/persistent_unionfind_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_random_test.nim
    title: verify/AI/persistent_unionfind_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_test.nim
    title: verify/AI/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_unionfind_test.nim
    title: verify/AI/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_unionfind_test.nim
    title: verify/collections/persistent_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/persistent_unionfind_test.nim
    title: verify/collections/persistent_unionfind_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND:\n    const CPLIB_COLLECTIONS_PERSISTENT_UNIONFIND*\
    \ = 1\n    import bitops\n\n    const PersistentUFBranchBits = 4\n    const PersistentUFBranchSize\
    \ = 1 shl PersistentUFBranchBits\n    const PersistentUFBranchMask = PersistentUFBranchSize\
    \ - 1\n    type\n        PersistentUFNode = array[PersistentUFBranchSize, int32]\n\
    \        PersistentUFPool = ref object\n            # \u540C\u3058\u521D\u671F\
    \u72B6\u614B\u304B\u3089\u6D3E\u751F\u3057\u305F\u7248\u3067\u5171\u6709\u3059\
    \u308B\u8FFD\u8A18\u5C02\u7528\u30D7\u30FC\u30EB\u3002\n            # \u500B\u3005\
    \u306E\u7248\u306E\u7834\u68C4\u3067\u306F\u89E3\u653E\u305B\u305A\u3001\u5168\
    \u3066\u306E\u7248\u306E\u7834\u68C4\u6642\u306B\u307E\u3068\u3081\u3066\u89E3\
    \u653E\u3059\u308B\u3002\n            nodes: seq[PersistentUFNode]\n        PersistentUnionFind*\
    \ = ref object\n            count*: int\n            size: int\n            height:\
    \ int\n            node: int32\n            pool: PersistentUFPool\n\n    proc\
    \ initPersistentUnionFind*(N: int): PersistentUnionFind =\n        assert N >=\
    \ 0 and N.int64 <= int32.high.int64\n        result = PersistentUnionFind(count:\
    \ N, size: N,\n            pool: PersistentUFPool(nodes: newSeq[PersistentUFNode](1)))\n\
    \        if N > 1:\n            result.height = (fastLog2(N - 1) div PersistentUFBranchBits)\
    \ * PersistentUFBranchBits\n\n    proc get(self: PersistentUnionFind, index: int):\
    \ int32 {.inline.} =\n        # node == 0 \u306F\u672A\u66F4\u65B0\u306E\u90E8\
    \u5206\u6728\uFF08\u5168\u8981\u7D20 -1\uFF09\u3092\u8868\u3059\u3002\n      \
    \  var node = self.node\n        var shift = self.height\n        while node !=\
    \ 0 and shift > 0:\n            node = self.pool.nodes[node.int][(index shr shift)\
    \ and PersistentUFBranchMask]\n            shift -= PersistentUFBranchBits\n \
    \       if node == 0:\n            return -1\n        return self.pool.nodes[node.int][index\
    \ and PersistentUFBranchMask]\n\n    proc rootAndSize(self: PersistentUnionFind,\
    \ x: int): tuple[root: int, size: int32] {.inline.} =\n        assert x >= 0 and\
    \ x < self.size\n        var x = x\n        var value = self.get(x)\n        while\
    \ value >= 0:\n            x = value.int\n            value = self.get(x)\n  \
    \      return (x, value)\n\n    proc copyNode(pool: PersistentUFPool, node: int32,\
    \ shift: int): int32 {.inline.} =\n        var data = pool.nodes[node.int]\n \
    \       if node == 0 and shift == 0:\n            for value in data.mitems:\n\
    \                value = -1\n        assert pool.nodes.len < int32.high.int\n\
    \        result = pool.nodes.len.int32\n        pool.nodes.add(data)\n\n    proc\
    \ setOne(pool: PersistentUFPool, node: int32, shift, index: int, value: int32):\
    \ int32 =\n        result = pool.copyNode(node, shift)\n        let slot = (index\
    \ shr shift) and PersistentUFBranchMask\n        if shift == 0:\n            pool.nodes[result.int][slot]\
    \ = value\n        else:\n            # \u518D\u5E30\u4E2D\u306B nodes \u304C\u518D\
    \u78BA\u4FDD\u3055\u308C\u308B\u305F\u3081\u3001\u4EE3\u5165\u5148\u306E\u53C2\
    \u7167\u3092\u4FDD\u6301\u3057\u306A\u3044\u3002\n            let child = pool.setOne(pool.nodes[result.int][slot],\
    \ shift - PersistentUFBranchBits, index, value)\n            pool.nodes[result.int][slot]\
    \ = child\n\n    # 2\u70B9\u306E\u66F4\u65B0\u7D4C\u8DEF\u304C\u5171\u901A\u3059\
    \u308B\u90E8\u5206\u306F\u4E00\u5EA6\u3060\u3051\u30B3\u30D4\u30FC\u3059\u308B\
    \u3002\n    proc setTwo(pool: PersistentUFPool, node: int32, shift, x, y: int,\
    \ xv, yv: int32): int32 =\n        result = pool.copyNode(node, shift)\n     \
    \   let xs = (x shr shift) and PersistentUFBranchMask\n        let ys = (y shr\
    \ shift) and PersistentUFBranchMask\n        if shift == 0:\n            pool.nodes[result.int][xs]\
    \ = xv\n            pool.nodes[result.int][ys] = yv\n        elif xs == ys:\n\
    \            let child = pool.setTwo(pool.nodes[result.int][xs], shift - PersistentUFBranchBits,\
    \ x, y, xv, yv)\n            pool.nodes[result.int][xs] = child\n        else:\n\
    \            let xc = pool.setOne(pool.nodes[result.int][xs], shift - PersistentUFBranchBits,\
    \ x, xv)\n            pool.nodes[result.int][xs] = xc\n            let yc = pool.setOne(pool.nodes[result.int][ys],\
    \ shift - PersistentUFBranchBits, y, yv)\n            pool.nodes[result.int][ys]\
    \ = yc\n\n    proc root*(self: PersistentUnionFind, x: int): int =\n        return\
    \ self.rootAndSize(x).root\n\n    proc issame*(self: PersistentUnionFind, x: int,\
    \ y: int): bool =\n        return self.rootAndSize(x).root == self.rootAndSize(y).root\n\
    \n    proc unite*(self: PersistentUnionFind, x: int, y: int): PersistentUnionFind\
    \ =\n        var a = self.rootAndSize(x)\n        var b = self.rootAndSize(y)\n\
    \        result = PersistentUnionFind(count: self.count, size: self.size,\n  \
    \          height: self.height, node: self.node, pool: self.pool)\n        if\
    \ a.root == b.root:\n            return\n        if a.size > b.size:\n       \
    \     swap(a, b)\n        result.node = self.pool.setTwo(self.node, self.height,\n\
    \            a.root, b.root, a.size + b.size, a.root.int32)\n        dec result.count\n\
    \n    proc siz*(self: PersistentUnionFind, x: int): int =\n        return -self.rootAndSize(x).size.int\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/persistent_unionfind.nim
  requiredBy: []
  timestamp: '2026-09-06 11:24:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/persistent_unionfind_test.nim
  - verify/collections/persistent_unionfind_test.nim
  - verify/AI/persistent_unionfind_test.nim
  - verify/AI/persistent_unionfind_test.nim
  - verify/AI/persistent_unionfind_random_test.nim
  - verify/AI/persistent_unionfind_random_test.nim
documentation_of: cplib/collections/persistent_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_unionfind.nim
- /library/cplib/collections/persistent_unionfind.nim.html
title: cplib/collections/persistent_unionfind.nim
---
