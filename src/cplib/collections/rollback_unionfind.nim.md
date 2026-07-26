---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/collections/rollback_uf_abc302ex_test_.nim
    title: verify/collections/rollback_uf_abc302ex_test_.nim
  - icon: ':warning:'
    path: verify/collections/rollback_uf_abc302ex_test_.nim
    title: verify/collections/rollback_uf_abc302ex_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_unionfind_test.nim
    title: verify/AI/rollback_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_unionfind_test.nim
    title: verify/AI/rollback_unionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/rollbackuf_yosupo_snap_test.nim
    title: verify/collections/rollbackuf_yosupo_snap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/rollbackuf_yosupo_snap_test.nim
    title: verify/collections/rollbackuf_yosupo_snap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/rollbackuf_yosupo_test.nim
    title: verify/collections/rollbackuf_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/rollbackuf_yosupo_test.nim
    title: verify/collections/rollbackuf_yosupo_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_ROLLBACK_UNIONFIND:\n    const CPLIB_COLLECTIONS_ROLLBACK_UNIONFIND*\
    \ = 1\n    import sequtils, strformat\n    type RollbackUnionFind* = object\n\
    \        count: int\n        par_or_siz: seq[int32]\n        history: seq[(int,\
    \ int32)]\n        snap: int\n    proc count*(self: RollbackUnionFind): int =\
    \ self.count\n    proc get_state*(self: RollbackUnionFind): int = (self.history.len\
    \ shr 1)\n    proc initRollbackUnionFind*(n: int): RollbackUnionFind =\n     \
    \   RollbackUnionFind(count: n, par_or_siz: newSeqWith(n, -1'i32), history: newSeq[(int,\
    \ int32)](), snap: 0)\n    proc root_i32(self: RollbackUnionFind, x: int): int32\
    \ = (if self.par_or_siz[x] < 0: x.int32 else: self.root_i32(self.par_or_siz[x].int))\n\
    \    proc root*(self: RollbackUnionFind, x: int): int = self.root_i32(x).int\n\
    \    proc issame*(self: RollbackUnionFind, x, y: int): bool = self.root_i32(x)\
    \ == self.root_i32(y)\n    proc unite*(self: var RollbackUnionFind, x, y: int):\
    \ bool {.discardable.} =\n        var x = self.root_i32(x)\n        var y = self.root_i32(y)\n\
    \        var sx = self.par_or_siz[x.int]\n        var sy = self.par_or_siz[y.int]\n\
    \        self.history.add((x.int, sx))\n        self.history.add((y.int, sy))\n\
    \        if x == y: return false\n        if sx > sy: swap(x, y)\n        let\
    \ xi = x.int\n        let yi = y.int\n        self.par_or_siz[xi] += self.par_or_siz[yi]\n\
    \        self.par_or_siz[yi] = x\n        return true\n    proc undo*(self: var\
    \ RollbackUnionFind) =\n        assert self.history.len > 0, \"Can't undo because\
    \ Unionfind is already initial state.\"\n        for i in 0..<2:\n           \
    \ var (x, sx) = self.history.pop\n            self.par_or_siz[x] = sx\n      \
    \  if self.snap > self.get_state: self.snap = 0\n    proc snapshot*(self: var\
    \ RollbackUnionFind) = self.snap = self.get_state\n    proc clear_snapshot*(self:\
    \ var RollbackUnionFind) = self.snap = 0\n    proc rollback*(self: var RollbackUnionFind,\
    \ state: int = -1) =\n        var state = (if state == -1: self.snap else: state)\
    \ shl 1\n        assert state <= self.history.len, &\"Rollback state must be the\
    \ same or smaller than current state. state: {state}, self.history.len: {self.history.len}\"\
    \n        while state < self.history.len: self.undo()\n    proc siz*(self: RollbackUnionFind,\
    \ x: int): int =\n        var x = self.root_i32(x)\n        return (-self.par_or_siz[x.int]).int\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/rollback_unionfind.nim
  requiredBy:
  - verify/collections/rollback_uf_abc302ex_test_.nim
  - verify/collections/rollback_uf_abc302ex_test_.nim
  timestamp: '2026-07-09 02:51:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/rollback_unionfind_test.nim
  - verify/AI/rollback_unionfind_test.nim
  - verify/collections/rollbackuf_yosupo_test.nim
  - verify/collections/rollbackuf_yosupo_test.nim
  - verify/collections/rollbackuf_yosupo_snap_test.nim
  - verify/collections/rollbackuf_yosupo_snap_test.nim
documentation_of: cplib/collections/rollback_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/rollback_unionfind.nim
- /library/cplib/collections/rollback_unionfind.nim.html
title: cplib/collections/rollback_unionfind.nim
---
