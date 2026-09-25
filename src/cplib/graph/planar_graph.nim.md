---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/planar_graph_test.nim
    title: verify/AI/planar_graph_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/planar_graph_test.nim
    title: verify/AI/planar_graph_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/random_helper_test.nim
    title: verify/AI/random_helper_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/random_helper_test.nim
    title: verify/AI/random_helper_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://www.uni-konstanz.de/algo/publications/b-lrpt-sub.pdf
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_PLANAR_GRAPH:\n    const CPLIB_GRAPH_PLANAR_GRAPH*\
    \ = 1\n    import algorithm, sequtils, sets\n    import cplib/graph/graph\n\n\
    \    # \u53C2\u8003: Ulrik Brandes\u300CThe Left-Right Planarity Test\u300D\u7B2C\
    6\u7BC0\u3002\n    # https://www.uni-konstanz.de/algo/publications/b-lrpt-sub.pdf\n\
    \    type\n        PlanarInterval = object\n            low, high: int\n     \
    \   PlanarConflict = object\n            left, right: PlanarInterval\n\n    proc\
    \ is_planar_graph*(g: UnDirectedGraph): bool =\n        ## \u7121\u5411\u30B0\u30E9\
    \u30D5\u306E\u5E73\u9762\u6027\u3092\u5224\u5B9A\u3059\u308B\u3002\u671F\u5F85\
    \ O(V log V + E) \u6642\u9593\u3001O(V + E) \u7A7A\u9593\u3002\n        ## \u91CD\
    \u307F\u30FB\u81EA\u5DF1\u30EB\u30FC\u30D7\u30FB\u591A\u91CD\u8FBA\u306F\u5224\
    \u5B9A\u306B\u5F71\u97FF\u3057\u306A\u3044\u3002\u9759\u7684\u30B0\u30E9\u30D5\
    \u306F build \u524D\u3067\u3082\u4F7F\u7528\u53EF\u80FD\u3002\n        let n =\
    \ g.len\n        var seen = initHashSet[(int, int)]()\n        var ends: seq[(int,\
    \ int)]\n        var adj = newSeq[seq[int]](n)\n        for edge in g.edge_info:\n\
    \            let u = min(edge.src, edge.dst)\n            let v = max(edge.src,\
    \ edge.dst)\n            if u == v or (u, v) in seen: continue\n            seen.incl((u,\
    \ v))\n            let id = ends.len\n            ends.add((u, v))\n         \
    \   adj[u].add(id)\n            adj[v].add(id)\n        let m = ends.len\n   \
    \     if n > 2 and m > 3 * n - 6: return false\n        var height = newSeqWith(n,\
    \ -1)\n        var parent = newSeqWith(n, -1)\n        var low = newSeq[int](m)\n\
    \        var low2 = newSeq[int](m)\n        var nesting = newSeq[int](m)\n   \
    \     var oriented = newSeq[bool](m)\n        var outgoing = newSeq[seq[int]](n)\n\
    \        var cursor = newSeq[int](n)\n        var roots: seq[int]\n\n        proc\
    \ finishEdge(e, p: int) =\n            ## \u8FBA\u306E\u5165\u308C\u5B50\u9806\
    \u3092\u6C42\u3081\u3001\u89AA\u8FBA\u306E lowpoint \u3092\u66F4\u65B0\u3059\u308B\
    \u3002O(1)\u3002\n            nesting[e] = 2 * low[e] + ord(low2[e] < height[ends[e][0]])\n\
    \            if p == -1: return\n            if low[e] < low[p]:\n           \
    \     low2[p] = min(low[p], low2[e])\n                low[p] = low[e]\n      \
    \      elif low[e] > low[p]:\n                low2[p] = min(low2[p], low[e])\n\
    \            else:\n                low2[p] = min(low2[p], low2[e])\n\n      \
    \  for root in 0..<n:\n            if height[root] != -1: continue\n         \
    \   roots.add(root)\n            height[root] = 0\n            var stack = @[root]\n\
    \            while stack.len > 0:\n                let v = stack[^1]\n       \
    \         if cursor[v] == adj[v].len:\n                    discard stack.pop()\n\
    \                    let e = parent[v]\n                    if e != -1: finishEdge(e,\
    \ parent[ends[e][0]])\n                    continue\n                let e = adj[v][cursor[v]]\n\
    \                inc cursor[v]\n                if oriented[e]: continue\n   \
    \             oriented[e] = true\n                let w = ends[e][0] xor ends[e][1]\
    \ xor v\n                ends[e] = (v, w)\n                outgoing[v].add(e)\n\
    \                low[e] = height[v]\n                low2[e] = height[v]\n   \
    \             if height[w] == -1:\n                    parent[w] = e\n       \
    \             height[w] = height[v] + 1\n                    stack.add(w)\n  \
    \              else:\n                    low[e] = height[w]\n               \
    \     finishEdge(e, parent[v])\n        for v in 0..<n:\n            outgoing[v].sort(proc(a,\
    \ b: int): int = cmp(nesting[a], nesting[b]))\n\n        let empty = PlanarInterval(low:\
    \ -1, high: -1)\n        var conflicts: seq[PlanarConflict]\n        var bottom\
    \ = newSeq[int](m)\n        var reference = newSeqWith(m, -1)\n        var lowEdge\
    \ = newSeqWith(m, -1)\n\n        proc conflicting(interval: PlanarInterval, e:\
    \ int): bool =\n            ## \u533A\u9593\u306B\u8FBA e \u3068\u540C\u3058\u5074\
    \u306B\u7F6E\u3051\u306A\u3044\u623B\u308A\u8FBA\u304C\u3042\u308B\u304B\u3092\
    \u8FD4\u3059\u3002O(1)\u3002\n            interval.high != -1 and low[interval.high]\
    \ > low[e]\n\n        proc addConstraints(e, p: int): bool =\n            ## \u623B\
    \u308A\u8FBA\u306E\u5DE6\u53F3\u306E\u5236\u7D04\u3092\u7D71\u5408\u3059\u308B\
    \u3002\u5168\u547C\u3073\u51FA\u3057\u5408\u8A08 O(E)\u3002\n            var merged\
    \ = PlanarConflict(left: empty, right: empty)\n            while true:\n     \
    \           var q = conflicts.pop()\n                if q.left.low != -1: swap(q.left,\
    \ q.right)\n                if q.left.low != -1: return false\n              \
    \  if low[q.right.low] > low[p]:\n                    if merged.right.low == -1:\n\
    \                        merged.right = q.right\n                    else:\n \
    \                       reference[merged.right.low] = q.right.high\n         \
    \           merged.right.low = q.right.low\n                else:\n          \
    \          reference[q.right.low] = lowEdge[p]\n                if conflicts.len\
    \ == bottom[e]: break\n            while conflicts.len > 0 and\n             \
    \       (conflicting(conflicts[^1].left, e) or conflicting(conflicts[^1].right,\
    \ e)):\n                var q = conflicts.pop()\n                if conflicting(q.right,\
    \ e): swap(q.left, q.right)\n                if conflicting(q.right, e): return\
    \ false\n                if merged.right.low != -1: reference[merged.right.low]\
    \ = q.right.high\n                if q.right.low != -1: merged.right.low = q.right.low\n\
    \                if merged.left.low == -1:\n                    merged.left =\
    \ q.left\n                else:\n                    reference[merged.left.low]\
    \ = q.left.high\n                merged.left.low = q.left.low\n            if\
    \ merged.left.low != -1 or merged.right.low != -1:\n                conflicts.add(merged)\n\
    \            return true\n\n        proc trimBackEdges(e: int) =\n           \
    \ ## \u89AA\u306B\u5230\u9054\u3057\u305F\u623B\u308A\u8FBA\u3092\u5236\u7D04\u304B\
    \u3089\u53D6\u308A\u9664\u304F\u3002\u5168\u547C\u3073\u51FA\u3057\u5408\u8A08\
    \ O(E)\u3002\n            let u = ends[e][0]\n            while conflicts.len\
    \ > 0:\n                let q = conflicts[^1]\n                let l = if q.left.low\
    \ == -1: high(int) else: low[q.left.low]\n                let r = if q.right.low\
    \ == -1: high(int) else: low[q.right.low]\n                if min(l, r) != height[u]:\
    \ break\n                discard conflicts.pop()\n            if conflicts.len\
    \ > 0:\n                var q = conflicts.pop()\n                while q.left.high\
    \ != -1 and ends[q.left.high][1] == u:\n                    q.left.high = reference[q.left.high]\n\
    \                if q.left.high == -1 and q.left.low != -1:\n                \
    \    reference[q.left.low] = q.right.low\n                    q.left.low = -1\n\
    \                while q.right.high != -1 and ends[q.right.high][1] == u:\n  \
    \                  q.right.high = reference[q.right.high]\n                if\
    \ q.right.high == -1 and q.right.low != -1:\n                    reference[q.right.low]\
    \ = q.left.low\n                    q.right.low = -1\n                conflicts.add(q)\n\
    \            if low[e] < height[u]:\n                let l = conflicts[^1].left.high\n\
    \                let r = conflicts[^1].right.high\n                reference[e]\
    \ = if l != -1 and (r == -1 or low[l] > low[r]): l else: r\n\n        cursor =\
    \ newSeq[int](n)\n        var entered = newSeq[bool](m)\n        for root in roots:\n\
    \            var stack = @[root]\n            while stack.len > 0:\n         \
    \       let v = stack[^1]\n                let p = parent[v]\n               \
    \ if cursor[v] == outgoing[v].len:\n                    discard stack.pop()\n\
    \                    if p != -1: trimBackEdges(p)\n                    continue\n\
    \                let e = outgoing[v][cursor[v]]\n                let w = ends[e][1]\n\
    \                if not entered[e]:\n                    entered[e] = true\n \
    \                   bottom[e] = conflicts.len\n                    if parent[w]\
    \ == e:\n                        stack.add(w)\n                        continue\n\
    \                    lowEdge[e] = e\n                    conflicts.add(PlanarConflict(left:\
    \ empty, right: PlanarInterval(low: e, high: e)))\n                if low[e] <\
    \ height[v]:\n                    if cursor[v] == 0:\n                       \
    \ lowEdge[p] = lowEdge[e]\n                    elif not addConstraints(e, p):\n\
    \                        return false\n                inc cursor[v]\n       \
    \ return true\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/planar_graph.nim
  requiredBy:
  - cplib/utils/random_helper.nim
  - cplib/utils/random_helper.nim
  timestamp: '2026-09-18 00:20:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/planar_graph_test.nim
  - verify/AI/planar_graph_test.nim
  - verify/AI/random_helper_test.nim
  - verify/AI/random_helper_test.nim
documentation_of: cplib/graph/planar_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/planar_graph.nim
- /library/cplib/graph/planar_graph.nim.html
title: cplib/graph/planar_graph.nim
---
