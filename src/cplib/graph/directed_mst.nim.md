---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/directed_mst_test.nim
    title: verify/AI/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/directed_mst_test.nim
    title: verify/AI/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/directed_mst_test.nim
    title: verify/graph/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/directed_mst_test.nim
    title: verify/graph/directed_mst_test.nim
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
  code: "when not declared CPLIB_GRAPH_DIRECTED_MST:\n    const CPLIB_GRAPH_DIRECTED_MST*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/math/int128\n    import\
    \ cplib/collections/lazy_leftist_heap\n    import options\n\n    when sizeof(int)\
    \ != 8:\n        {.error: \"directedMST\u306F64\u30D3\u30C3\u30C8\u74B0\u5883\u304C\
    \u5FC5\u8981\u3067\u3059\".}\n\n    type DirectedMSTResult* = object\n       \
    \ cost*: int64\n        inEdge*: seq[int]\n\n    # Int128 \u306E\u6F14\u7B97\u3092\
    \u3053\u306E\u30E2\u30B8\u30E5\u30FC\u30EB\u3067\u89E3\u6C7A\u3057\u3001\u547C\
    \u3073\u51FA\u3057\u5143\u306E\u8FFD\u52A0 import \u3092\u4E0D\u8981\u306B\u3059\
    \u308B\u3002\n    proc meldHeap(pool: var LazyLeftistHeapPool[Int128, int], a,\
    \ b: int): int {.inline.} =\n        ## \u5165\u8FBA\u30D2\u30FC\u30D7\u3092\u4F75\
    \u5408\u3059\u308B\u3002O(log E)\u3002\n        pool.meld(a, b)\n\n    proc popHeap(pool:\
    \ var LazyLeftistHeapPool[Int128, int], root: int): int {.inline.} =\n       \
    \ ## \u6700\u5C0F\u5165\u8FBA\u3092\u524A\u9664\u3057\u305F\u6839\u3092\u8FD4\u3059\
    \u3002O(log E)\u3002\n        pool.pop(root)\n\n    proc addHeap(pool: var LazyLeftistHeapPool[Int128,\
    \ int], root: int, delta: Int128) {.inline.} =\n        ## \u5165\u8FBA\u30D2\u30FC\
    \u30D7\u5168\u4F53\u3078\u91CD\u307F\u5DEE\u3092\u52A0\u3048\u308B\u3002O(1)\u3002\
    \n        pool.addAll(root, delta)\n\n    proc directedMSTFind(parent: var seq[int],\
    \ v: int): int =\n        ## \u7E2E\u7D04\u5F8C\u306E\u4EE3\u8868\u3092\u53CD\u5FA9\
    \u7684\u306B\u6C42\u3081\u3001\u7D4C\u8DEF\u5727\u7E2E\u3059\u308B\u3002\n   \
    \     result = v\n        while parent[result] >= 0: result = parent[result]\n\
    \        var v = v\n        while parent[v] >= 0:\n            let next = parent[v]\n\
    \            parent[v] = result\n            v = next\n\n    proc directedMST*[T:\
    \ SomeSignedInt](g: WeightedDirectedGraph[T] or\n            WeightedDirectedStaticGraph[T],\
    \ root: int): Option[DirectedMSTResult] =\n        ## \u6839\u304B\u3089\u5168\
    \u9802\u70B9\u3078\u5C4A\u304F\u6700\u5C0F\u6709\u5411\u5168\u57DF\u6728\u306E\
    \u30B3\u30B9\u30C8\u3068\u5404\u9802\u70B9\u3078\u306E\u8FBAID\u3092\u8FD4\u3059\
    \u3002O((V+E) log(V+E))\u3002\n        let n = g.len\n        if n <= 0 or root\
    \ < 0 or root >= n:\n            raise newException(ValueError, \"\u975E\u7A7A\
    \u30B0\u30E9\u30D5\u3068\u6709\u52B9\u306A\u6839\u304C\u5FC5\u8981\u3067\u3059\
    \")\n        if n > high(int32).int div 2:\n            raise newException(ValueError,\
    \ \"\u9802\u70B9\u6570\u304C\u5BFE\u5FDC\u7BC4\u56F2\u3092\u8D85\u3048\u3066\u3044\
    \u307E\u3059\")\n        var pool = initLazyLeftistHeapPool[Int128, int](g.edge_info.len,\
    \ zero = to_Int128(0))\n        var heap: seq[int] = newSeq[int](2 * n)\n    \
    \    var parent = newSeq[int](2 * n)\n        var contractionParent = newSeq[int](2\
    \ * n)\n        var chosen = newSeq[int](2 * n)\n        var seen = newSeq[int](2\
    \ * n)\n        for v in 0..<2 * n:\n            heap[v] = -1\n            parent[v]\
    \ = -1\n            contractionParent[v] = -1\n            chosen[v] = -1\n  \
    \      for id, e in g.edge_info:\n            if e.src < 0 or e.src >= n or e.dst\
    \ < 0 or e.dst >= n:\n                raise newException(ValueError, \"\u8FBA\u306E\
    \u7AEF\u70B9\u304C\u7BC4\u56F2\u5916\u3067\u3059\")\n            if e.dst == root\
    \ or e.src == e.dst: continue\n            let h = pool.singleton(to_Int128(e.cost),\
    \ id)\n            heap[e.dst] = pool.meldHeap(heap[e.dst], h)\n        seen[root]\
    \ = -1\n        var count = n\n        for start in 0..<n:\n            var v\
    \ = directedMSTFind(parent, start)\n            let stamp = start + 1\n      \
    \      while seen[v] == 0 or seen[v] == stamp:\n                if seen[v] ==\
    \ stamp:\n                    var cycle: seq[int]\n                    var u =\
    \ v\n                    while true:\n                        cycle.add(u)\n \
    \                       u = directedMSTFind(parent, g.edge_info[chosen[u]].src)\n\
    \                        if u == v: break\n                    let contracted\
    \ = count\n                    inc count\n                    for u in cycle:\n\
    \                        heap[contracted] = pool.meldHeap(heap[contracted], heap[u])\n\
    \                        parent[u] = contracted\n                        contractionParent[u]\
    \ = contracted\n                    v = contracted\n                seen[v] =\
    \ stamp\n                while heap[v] != -1:\n                    let id = pool.top(heap[v]).value\n\
    \                    if directedMSTFind(parent, g.edge_info[id].src) != v: break\n\
    \                    heap[v] = pool.popHeap(heap[v])\n                if heap[v]\
    \ == -1: return none(DirectedMSTResult)\n                let h = heap[v]\n   \
    \             let minimum = pool.top(h)\n                chosen[v] = minimum.value\n\
    \                let weight = minimum.key\n                heap[v] = pool.popHeap(h)\n\
    \                pool.addHeap(heap[v], -weight)\n                v = directedMSTFind(parent,\
    \ g.edge_info[chosen[v]].src)\n        var answer = DirectedMSTResult(inEdge:\
    \ newSeq[int](n))\n        for v in 0..<n: answer.inEdge[v] = -1\n        var\
    \ expanded = newSeq[bool](count)\n        var total = to_Int128(0)\n        for\
    \ v in countdown(count - 1, 0):\n            if v == root or expanded[v]: continue\n\
    \            let id = chosen[v]\n            let e = g.edge_info[id]\n       \
    \     answer.inEdge[e.dst] = id\n            total += to_Int128(e.cost)\n    \
    \        var u = e.dst\n            while u >= 0 and not expanded[u]:\n      \
    \          expanded[u] = true\n                u = contractionParent[u]\n    \
    \    if total < to_Int128(low(int64)) or total > to_Int128(high(int64)):\n   \
    \         raise newException(OverflowDefect, \"\u6700\u5C0F\u6709\u5411\u5168\u57DF\
    \u6728\u306E\u30B3\u30B9\u30C8\u304Cint64\u306E\u7BC4\u56F2\u3092\u8D85\u3048\u3066\
    \u3044\u307E\u3059\")\n        answer.cost = int64(total.to_int())\n        some(answer)\n"
  dependsOn:
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/math/int128.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/math/int128.nim
  - cplib/collections/lazy_leftist_heap.nim
  isVerificationFile: false
  path: cplib/graph/directed_mst.nim
  requiredBy: []
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/directed_mst_test.nim
  - verify/graph/directed_mst_test.nim
  - verify/AI/directed_mst_test.nim
  - verify/AI/directed_mst_test.nim
documentation_of: cplib/graph/directed_mst.nim
layout: document
redirect_from:
- /library/cplib/graph/directed_mst.nim
- /library/cplib/graph/directed_mst.nim.html
title: cplib/graph/directed_mst.nim
---
