---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TREE_PRUFER:\n    const CPLIB_TREE_PRUFER* = 1\n\n\
    \    import cplib/tree/tree\n    import sequtils, heapqueue\n    proc prufer_decode*(a:\
    \ seq[int]): UnWeightedTree =\n        var n = a.len + 2\n        assert a.allIt(it\
    \ in 0..<n)\n        result = initUnWeightedTree(n)\n        var cnt = newSeqWith(n,\
    \ 1)\n        for ai in a:\n            cnt[ai] += 1\n        var q = initHeapQueue[(int,\
    \ int)]()\n        for i in 0..<n:\n            q.push((cnt[i], i))\n        for\
    \ i in 0..<a.len:\n            var (c, u) = q.pop\n            while cnt[u] !=\
    \ c: (c, u) = q.pop\n            result.add_edge(u, a[i])\n            cnt[u]\
    \ -= 1\n            cnt[a[i]] -= 1\n            if cnt[u] != 0: q.push((cnt[u],\
    \ u))\n            if cnt[a[i]] != 0: q.push((cnt[a[i]], a[i]))\n        var u\
    \ = (0..<n).toSeq.filterIt(cnt[it] == 1)\n        result.add_edge(u[0], u[1])\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/prufer.nim
  requiredBy: []
  timestamp: '2023-11-16 05:02:40+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/tree/prufer.nim
layout: document
redirect_from:
- /library/cplib/tree/prufer.nim
- /library/cplib/tree/prufer.nim.html
title: cplib/tree/prufer.nim
---
