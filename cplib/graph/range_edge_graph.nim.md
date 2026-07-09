---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
  code: "when not declared CPLIB_RANGE_EDGE_GRAPH:\n    const CPLIB_RANGE_EDGE_GRAPH*\
    \ = 1\n    import cplib/graph/graph\n    type\n        RangeEdgeGraphNode = object\n\
    \            l, r: int\n            left, right: int\n            inId, outId:\
    \ int\n\n        Range_Edge_Graph*[T] = ref object\n            G*: WeightedDirectedGraph[T]\n\
    \            n*: int\n            baseLen*: int\n            zero: T\n       \
    \     root: int\n            nodes: seq[RangeEdgeGraphNode]\n\n    proc graph*[T](G:\
    \ Range_Edge_Graph[T]): WeightedDirectedGraph[T] = G.G\n    proc len*[T](G: Range_Edge_Graph[T]):\
    \ int = G.G.len\n    proc original_len*[T](G: Range_Edge_Graph[T]): int = G.n\n\
    \    proc base_len*[T](G: Range_Edge_Graph[T]): int = G.baseLen\n\n    proc initWeightedRangeGraph*[T](N:\
    \ int, zero: T): Range_Edge_Graph[T] =\n        # \u5143\u9802\u70B9\u3092 in/out\
    \ \u30BB\u30B0\u6728\u306E\u8449\u3068\u3057\u3066\u5171\u6709\u3057\u3001\u5185\
    \u90E8\u30CE\u30FC\u30C9\u3060\u3051\u3092\u8FFD\u52A0\u3059\u308B\u3002\n   \
    \     assert N >= 0\n        let baseLen = if N == 0: 0 else: 3 * N - 2\n    \
    \    result = Range_Edge_Graph[T](\n            G: initWeightedDirectedGraph(baseLen,\
    \ T),\n            n: N,\n            baseLen: baseLen,\n            zero: zero,\n\
    \            root: -1,\n            nodes: @[]\n        )\n        if N == 0:\
    \ return\n\n        var nextId = N\n        let self = result\n        proc build(l,\
    \ r: int): int =\n            let idx = self.nodes.len\n            self.nodes.add(RangeEdgeGraphNode(\n\
    \                l: l, r: r,\n                left: -1, right: -1,\n         \
    \       inId: l, outId: l\n            ))\n            if r - l == 1:\n      \
    \          return idx\n\n            let inId = nextId\n            inc nextId\n\
    \            let outId = nextId\n            inc nextId\n            self.nodes[idx].inId\
    \ = inId\n            self.nodes[idx].outId = outId\n\n            let m = (l\
    \ + r) shr 1\n            let left = build(l, m)\n            let right = build(m,\
    \ r)\n            self.nodes[idx].left = left\n            self.nodes[idx].right\
    \ = right\n\n            self.G.add_edge(inId, self.nodes[left].inId, zero)\n\
    \            self.G.add_edge(inId, self.nodes[right].inId, zero)\n           \
    \ self.G.add_edge(self.nodes[left].outId, outId, zero)\n            self.G.add_edge(self.nodes[right].outId,\
    \ outId, zero)\n            return idx\n\n        result.root = build(0, N)\n\
    \        assert nextId == baseLen\n\n    proc initWeightedRangeGraph*(N: int):\
    \ Range_Edge_Graph[int] =\n        initWeightedRangeGraph(N, 0)\n\n    proc initWeightedRangeGraph*[T](N:\
    \ int, edgetype: typedesc[T]): Range_Edge_Graph[T] =\n        var zero: T\n  \
    \      initWeightedRangeGraph(N, zero)\n\n    proc validateRange[T](G: Range_Edge_Graph[T],\
    \ l, r: int) =\n        assert 0 <= l and l <= r and r <= G.n\n\n    proc validatePoint[T](G:\
    \ Range_Edge_Graph[T], v: int) =\n        assert 0 <= v and v < G.n\n\n    proc\
    \ connectRangeToVertex[T](G: Range_Edge_Graph[T], idx, l, r, to: int, cost: T)\
    \ =\n        let node = G.nodes[idx]\n        if r <= node.l or node.r <= l:\n\
    \            return\n        if l <= node.l and node.r <= r:\n            G.G.add_edge(node.outId,\
    \ to, cost)\n            return\n        G.connectRangeToVertex(node.left, l,\
    \ r, to, cost)\n        G.connectRangeToVertex(node.right, l, r, to, cost)\n\n\
    \    proc connectVertexToRange[T](G: Range_Edge_Graph[T], src, idx, l, r: int,\
    \ cost: T) =\n        let node = G.nodes[idx]\n        if r <= node.l or node.r\
    \ <= l:\n            return\n        if l <= node.l and node.r <= r:\n       \
    \     G.G.add_edge(src, node.inId, cost)\n            return\n        G.connectVertexToRange(src,\
    \ node.left, l, r, cost)\n        G.connectVertexToRange(src, node.right, l, r,\
    \ cost)\n\n    proc add_range_to_range_edge*[T](G: Range_Edge_Graph[T], from_l,\
    \ from_r, to_l, to_r: int, cost: T) =\n        G.validateRange(from_l, from_r)\n\
    \        G.validateRange(to_l, to_r)\n        if from_l == from_r or to_l == to_r:\n\
    \            return\n\n        let fromNode = G.G.len\n        let toNode = G.G.len\
    \ + 1\n        G.G.len += 2\n        G.G.edges.add(newSeq[(int32, T)]())\n   \
    \     G.G.edges.add(newSeq[(int32, T)]())\n        G.connectRangeToVertex(G.root,\
    \ from_l, from_r, fromNode, G.zero)\n        G.G.add_edge(fromNode, toNode, cost)\n\
    \        G.connectVertexToRange(toNode, G.root, to_l, to_r, G.zero)\n\n    proc\
    \ add_edge*[T](G: Range_Edge_Graph[T], from_l, from_r, to_l, to_r: int, cost:\
    \ T) =\n        G.add_range_to_range_edge(from_l, from_r, to_l, to_r, cost)\n\n\
    \    proc add_point_to_range_edge*[T](G: Range_Edge_Graph[T], src, to_l, to_r:\
    \ int, cost: T) =\n        G.validatePoint(src)\n        G.validateRange(to_l,\
    \ to_r)\n        if to_l == to_r:\n            return\n        G.connectVertexToRange(src,\
    \ G.root, to_l, to_r, cost)\n\n    proc add_range_to_point_edge*[T](G: Range_Edge_Graph[T],\
    \ from_l, from_r, to: int, cost: T) =\n        G.validateRange(from_l, from_r)\n\
    \        G.validatePoint(to)\n        if from_l == from_r:\n            return\n\
    \        G.connectRangeToVertex(G.root, from_l, from_r, to, cost)\n\n    proc\
    \ add_point_to_point_edge*[T](G: Range_Edge_Graph[T], src, to: int, cost: T) =\n\
    \        G.validatePoint(src)\n        G.validatePoint(to)\n        G.G.add_edge(src,\
    \ to, cost)\n\n    proc add_edge*[T](G: Range_Edge_Graph[T], src, to: int, cost:\
    \ T) =\n        G.add_point_to_point_edge(src, to, cost)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/range_edge_graph.nim
  requiredBy: []
  timestamp: '2026-07-07 08:18:56+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/range_edge_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/range_edge_graph.nim
- /library/cplib/graph/range_edge_graph.nim.html
title: cplib/graph/range_edge_graph.nim
---
