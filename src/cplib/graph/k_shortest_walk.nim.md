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
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_shortest_walk_test.nim
    title: verify/AI/k_shortest_walk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_shortest_walk_test.nim
    title: verify/AI/k_shortest_walk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/k_shortest_walk_test.nim
    title: verify/graph/dynamic/k_shortest_walk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/k_shortest_walk_test.nim
    title: verify/graph/dynamic/k_shortest_walk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/k_shortest_walk_static_test.nim
    title: verify/graph/static/k_shortest_walk_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/k_shortest_walk_static_test.nim
    title: verify/graph/static/k_shortest_walk_static_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://www.ics.uci.edu/~eppstein/pubs/Epp-TR-94-26.pdf
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_K_SHORTEST_WALK:\n    const CPLIB_GRAPH_K_SHORTEST_WALK*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ heapqueue, algorithm\n\n    type KShortestWalkHeapNode = object\n        vertex,\
    \ left, right, rank: int\n\n    proc k_shortest_walk*[T: SomeSignedInt](G: DynamicGraph[T]\
    \ or StaticGraph[T], s, t, k: int, INF: T): seq[T] =\n        ## \u975E\u8CA0\u6574\
    \u6570\u91CD\u307F\u306Es\u304B\u3089t\u3078\u306E\u30A6\u30A9\u30FC\u30AF\u9577\
    \u3092\u6607\u9806\u3067k\u500B\u8FD4\u3059\u3002\u6642\u9593O((V+E)logV + k log\
    \ k)\u3001\u7A7A\u9593O(E+V logV+k)\u3002\n        ## \u540C\u9577\u306E\u5225\
    \u30A6\u30A9\u30FC\u30AF\u3082\u6570\u3048\u3001s == t\u3067\u306F\u7A7A\u30A6\
    \u30A9\u30FC\u30AF\u3092\u542B\u3080\u3002\u5168\u3066\u306E\u4E2D\u9593\u8A08\
    \u7B97\u304CT\u306B\u53CE\u307E\u308B\u3053\u3068\u3092\u8981\u6C42\u3059\u308B\
    \u3002\n        ## \u4E0D\u8DB3\u5206\u306FINF\u3067\u57CB\u3081\u308B\u3002INF\u306F\
    \u8FD4\u3055\u308C\u308B\u30A6\u30A9\u30FC\u30AF\u9577\u3088\u308A\u5927\u304D\
    \u3044\u5024\u3092\u6307\u5B9A\u3059\u308B\u3002StaticGraph\u306F\u4E8B\u524D\u306B\
    build\u3059\u308B\u3002\n        ## Eppstein\u6CD5: https://www.ics.uci.edu/~eppstein/pubs/Epp-TR-94-26.pdf\n\
    \        assert 0 <= s and s < G.len and 0 <= t and t < G.len\n        assert\
    \ k >= 0\n        if k == 0: return @[]\n        result = newSeq[T](k)\n     \
    \   result.fill(INF)\n        let n = G.len\n        var reverse = newSeq[seq[tuple[vertex:\
    \ int, cost: T, edge: int]]](n)\n        for u in 0..<n:\n            var edge\
    \ = 0\n            for (v, cost) in G.to_and_cost(u):\n                assert\
    \ cost >= T(0)\n                reverse[v].add((u, cost, edge))\n            \
    \    inc edge\n        var\n            dist = newSeq[T](n)\n            reached\
    \ = newSeq[bool](n)\n            settled = newSeq[bool](n)\n            parent\
    \ = newSeq[int](n)\n            treeEdge = newSeq[int](n)\n            position\
    \ = newSeq[int](n)\n            heap: seq[int]\n            order: seq[int]\n\
    \        parent.fill(-1)\n        treeEdge.fill(-1)\n        position.fill(-1)\n\
    \n        proc siftUp(vertex: int) =\n            ## \u9802\u70B9\u3092\u633F\u5165\
    \u307E\u305F\u306Fdecrease-key\u3059\u308B\u3002O(logV)\u3002\n            var\
    \ i = position[vertex]\n            if i == -1:\n                i = heap.len\n\
    \                heap.add(vertex)\n            while i > 0:\n                let\
    \ p = (i - 1) div 2\n                if dist[heap[p]] <= dist[vertex]: break\n\
    \                heap[i] = heap[p]\n                position[heap[i]] = i\n  \
    \              i = p\n            heap[i] = vertex\n            position[vertex]\
    \ = i\n\n        proc popVertex(): int =\n            ## \u6700\u77ED\u8DDD\u96E2\
    \u306E\u9802\u70B9\u3092\u53D6\u308A\u51FA\u3059\u3002O(logV)\u3002\n        \
    \    result = heap[0]\n            let last = heap.pop()\n            position[result]\
    \ = -1\n            if heap.len == 0: return\n            var i = 0\n        \
    \    while i * 2 + 1 < heap.len:\n                var child = i * 2 + 1\n    \
    \            if child + 1 < heap.len and dist[heap[child + 1]] < dist[heap[child]]:\n\
    \                    inc child\n                if dist[last] <= dist[heap[child]]:\
    \ break\n                heap[i] = heap[child]\n                position[heap[i]]\
    \ = i\n                i = child\n            heap[i] = last\n            position[last]\
    \ = i\n\n        reached[t] = true\n        siftUp(t)\n        while heap.len\
    \ > 0:\n            let v = popVertex()\n            settled[v] = true\n     \
    \       order.add(v)\n            for e in reverse[v]:\n                let u\
    \ = e.vertex\n                if settled[u]: continue\n                let candidate\
    \ = dist[v] + e.cost\n                if not reached[u] or candidate < dist[u]:\n\
    \                    reached[u] = true\n                    dist[u] = candidate\n\
    \                    parent[u] = v\n                    treeEdge[u] = e.edge\n\
    \                    siftUp(u)\n        if not reached[s]: return\n        result[0]\
    \ = dist[s]\n        if k == 1: return\n\n        var local = newSeq[seq[tuple[delta:\
    \ T, dest: int]]](n)\n        for u in order:\n            var edge = 0\n    \
    \        for (v, cost) in G.to_and_cost(u):\n                if reached[v] and\
    \ edge != treeEdge[u]:\n                    local[u].add((cost + dist[v] - dist[u],\
    \ v))\n                inc edge\n            # \u5404\u9802\u70B9\u306E\u975E\u6728\
    \u8FBA\u3092\u7DDA\u5F62\u6642\u9593\u3067\u30D2\u30FC\u30D7\u5316\u3059\u308B\
    \u3002\n            for start in countdown(local[u].len div 2 - 1, 0):\n     \
    \           var i = start\n                let value = local[u][i]\n         \
    \       while i * 2 + 1 < local[u].len:\n                    var child = i * 2\
    \ + 1\n                    if child + 1 < local[u].len and local[u][child + 1].delta\
    \ < local[u][child].delta:\n                        inc child\n              \
    \      if value.delta <= local[u][child].delta: break\n                    local[u][i]\
    \ = local[u][child]\n                    i = child\n                local[u][i]\
    \ = value\n\n        var nodes = @[KShortestWalkHeapNode()]\n        var roots\
    \ = newSeq[int](n)\n        proc meld(a, b: int): int =\n            ## \u6700\
    \u5C0F\u975E\u6728\u8FBA\u3092\u6301\u3064\u6C38\u7D9Aleftist heap\u3092\u4F75\
    \u5408\u3059\u308B\u3002O(logV)\u3002\n            if a == 0: return b\n     \
    \       if b == 0: return a\n            var x = a\n            var y = b\n  \
    \          if local[nodes[y].vertex][0].delta < local[nodes[x].vertex][0].delta:\n\
    \                swap(x, y)\n            var node = nodes[x]\n            node.right\
    \ = meld(node.right, y)\n            if nodes[node.left].rank < nodes[node.right].rank:\n\
    \                swap(node.left, node.right)\n            node.rank = nodes[node.right].rank\
    \ + 1\n            result = nodes.len\n            nodes.add(node)\n\n       \
    \ # \u78BA\u5B9A\u9806\u306A\u3089\u30BC\u30ED\u91CD\u307F\u8FBA\u304C\u3042\u3063\
    \u3066\u3082\u89AA\u306E\u30D2\u30FC\u30D7\u306F\u69CB\u7BC9\u6E08\u307F\u306B\
    \u306A\u308B\u3002\n        for u in order:\n            if parent[u] != -1: roots[u]\
    \ = roots[parent[u]]\n            if local[u].len > 0:\n                let node\
    \ = nodes.len\n                nodes.add(KShortestWalkHeapNode(vertex: u, rank:\
    \ 1))\n                roots[u] = meld(roots[u], node)\n\n        var queue =\
    \ initHeapQueue[tuple[cost: T, node, vertex, index: int]]()\n        proc pushRoot(cost:\
    \ T, root: int) =\n            ## \u6B21\u306E\u975E\u6728\u8FBA\u3092\u8FFD\u52A0\
    \u3057\u305F\u5019\u88DC\u3092\u767B\u9332\u3059\u308B\u3002O(log k)\u3002\n \
    \           if root != 0:\n                let u = nodes[root].vertex\n      \
    \          queue.push((cost + local[u][0].delta, root, u, 0))\n\n        pushRoot(dist[s],\
    \ roots[s])\n        var count = 1\n        while queue.len > 0 and count < k:\n\
    \            let candidate = queue.pop()\n            result[count] = candidate.cost\n\
    \            inc count\n            if count == k: break\n            let u =\
    \ candidate.vertex\n            let i = candidate.index\n            let edge\
    \ = local[u][i]\n            let base = candidate.cost - edge.delta\n        \
    \    if candidate.node != 0:\n                pushRoot(base, nodes[candidate.node].left)\n\
    \                pushRoot(base, nodes[candidate.node].right)\n            for\
    \ child in [i * 2 + 1, i * 2 + 2]:\n                if child < local[u].len:\n\
    \                    queue.push((base + local[u][child].delta, 0, u, child))\n\
    \            pushRoot(candidate.cost, roots[edge.dest])\n\n    proc k_shortest_walk*[T:\
    \ SomeSignedInt](G: DynamicGraph[T] or StaticGraph[T], s, t, k: int): seq[T] =\n\
    \        ## \u4E0D\u8DB3\u5206\u309264\u30D3\u30C3\u30C8\u578B\u3067\u306FINF64\u3001\
    32\u30D3\u30C3\u30C8\u578B\u3067\u306FINF32\u3001\u305D\u308C\u3088\u308A\u5C0F\
    \u3055\u3044\u578B\u3067\u306Fhigh(T)\u3067\u57CB\u3081\u308B\u3002\n        when\
    \ sizeof(T) >= 8:\n            G.k_shortest_walk(s, t, k, T(INF64))\n        elif\
    \ sizeof(T) >= 4:\n            G.k_shortest_walk(s, t, k, T(INF32))\n        else:\n\
    \            G.k_shortest_walk(s, t, k, high(T))\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/k_shortest_walk.nim
  requiredBy: []
  timestamp: '2026-09-13 10:19:10+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/k_shortest_walk_static_test.nim
  - verify/graph/static/k_shortest_walk_static_test.nim
  - verify/graph/dynamic/k_shortest_walk_test.nim
  - verify/graph/dynamic/k_shortest_walk_test.nim
  - verify/AI/k_shortest_walk_test.nim
  - verify/AI/k_shortest_walk_test.nim
documentation_of: cplib/graph/k_shortest_walk.nim
layout: document
redirect_from:
- /library/cplib/graph/k_shortest_walk.nim
- /library/cplib/graph/k_shortest_walk.nim.html
title: cplib/graph/k_shortest_walk.nim
---
