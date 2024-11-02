---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/groupunionfind_test.nim
    title: verify/collections/groupunionfind_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/groupunionfind_test.nim
    title: verify/collections/groupunionfind_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_UNIONFIND:\n    const CPLIB_COLLECTIONS_UNIONFIND*\
    \ = 1\n    import algorithm, sequtils\n    type UnionFind* = ref object\n    \
    \    count*: int\n        par_or_siz: seq[int]\n        next : seq[int]\n    proc\
    \ initUnionFind*(N: int): UnionFind =\n        result = UnionFind(count: N, par_or_siz:\
    \ newSeqwith(N, -1),next:(0..<N).toseq())\n    proc root*(self: UnionFind, x:\
    \ int): int =\n        if self.par_or_siz[x] < 0:\n            return x\n    \
    \    else:\n            self.par_or_siz[x] = self.root(self.par_or_siz[x])\n \
    \           return self.par_or_siz[x]\n    proc issame*(self: UnionFind, x: int,\
    \ y: int): bool =\n        return self.root(x) == self.root(y)\n    proc unite*(self:\
    \ UnionFind, x: int, y: int) =\n        var x = self.root(x)\n        var y =\
    \ self.root(y)\n        if(x != y):\n            swap(self.next[x],self.next[y])\n\
    \            if(self.par_or_siz[x] > self.par_or_siz[y]):\n                swap(x,\
    \ y)\n            self.par_or_siz[x] += self.par_or_siz[y]\n            self.par_or_siz[y]\
    \ = x\n            self.count -= 1\n    proc siz*(self: UnionFind, x: int): int\
    \ =\n        var x = self.root(x)\n        return -self.par_or_siz[x]\n    proc\
    \ roots*(self:UnionFind):seq[int]=\n        ## O(N)\u304B\u3051\u3066\u3001root\u306B\
    \u306A\u3063\u3066\u3044\u308B\u9802\u70B9\u3092\u5217\u6319\u3057\u307E\u3059\
    \u3002\n        ## \u6CE8\u610F:O(root\u6570)\u3067\u306A\u3044\u3053\u3068\u306B\
    \u6CE8\u610F\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        for i in 0..<len(self.par_or_siz):\n\
    \            if self.par_or_siz[i] < 0:\n                result.add(i)\n    proc\
    \ get_group*(self:UnionFind,x:int):seq[int]=\n        var now = x\n        while\
    \ true:\n            result.add(now)\n            now = self.next[now]\n     \
    \       if now == x:\n                break"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/group_unionfind.nim
  requiredBy: []
  timestamp: '2024-11-02 12:58:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/groupunionfind_test.nim
  - verify/collections/groupunionfind_test.nim
documentation_of: cplib/collections/group_unionfind.nim
layout: document
redirect_from:
- /library/cplib/collections/group_unionfind.nim
- /library/cplib/collections/group_unionfind.nim.html
title: cplib/collections/group_unionfind.nim
---
