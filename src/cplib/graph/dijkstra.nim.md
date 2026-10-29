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
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_test.nim
    title: verify/AI/dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_test.nim
    title: verify/AI/dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_storage_test.nim
    title: verify/AI/graph_storage_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_storage_test.nim
    title: verify/AI/graph_storage_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_bfs_test.nim
    title: verify/AI/implicit_bfs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_bfs_test.nim
    title: verify/AI/implicit_bfs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_dijkstra_test.nim
    title: verify/AI/implicit_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_dijkstra_test.nim
    title: verify/AI/implicit_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dijkstra_custom_cmp_test.nim
    title: verify/graph/dijkstra_custom_cmp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dijkstra_custom_cmp_test.nim
    title: verify/graph/dijkstra_custom_cmp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dijkstra_custom_types_test.nim
    title: verify/graph/dijkstra_custom_types_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dijkstra_custom_types_test.nim
    title: verify/graph/dijkstra_custom_types_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
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
  code: "when not declared CPLIB_GRAPH_DIJKSTRA:\n    const CPLIB_GRAPH_DIJKSTRA*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ cplib/graph/restore_shortest_path_from_prev\n    import heapqueue, macros, algorithm\n\
    \n    type DijkstraQueueEntry[T] = object\n        distance: T\n        vertex:\
    \ int\n        cmp: proc(a, b: T): int\n\n    proc `<`*[T](a, b: DijkstraQueueEntry[T]):\
    \ bool =\n        ## \u8DDD\u96E2\u306E\u6BD4\u8F03\u95A2\u6570\u3067\u512A\u5148\
    \u5EA6\u3092\u6BD4\u8F03\u3057\u3001\u540C\u9806\u4F4D\u306A\u3089\u9802\u70B9\
    \u756A\u53F7\u3067\u6BD4\u8F03\u3059\u308B\u3002O(cmp)\u3002\n        let order\
    \ = a.cmp(a.distance, b.distance)\n        if order == 0: a.vertex < b.vertex\n\
    \        else: order < 0\n\n    # cmp(a, b) \u306F a \u304C\u512A\u5148\u306A\u3089\
    \u8CA0\u3001\u540C\u9806\u4F4D\u306A\u3089 0\u3001\u305D\u308C\u4EE5\u5916\u306F\
    \u6B63\u3092\u8FD4\u3059\u4E00\u8CAB\u3057\u305F\u6BD4\u8F03\u95A2\u6570\u3068\
    \u3059\u308B\u3002\n    # cmp \u3092\u7701\u7565\u3059\u308B\u5834\u5408\u306F\
    \ T \u306E < \u3068 == \u3092\u7528\u3044\u308B\u3002\n    # add(d, e) \u306F\
    \ cmp \u306E\u9806\u5E8F\u3067 d \u306B\u3064\u3044\u3066\u5358\u8ABF\u975E\u6E1B\
    \u5C11\u3067\u3001cmp(d, add(d, e)) <= 0 \u3092\u6E80\u305F\u3059\u3053\u3068\u3002\
    \n    # ZERO \u306F\u59CB\u70B9\u306E\u8DDD\u96E2\u3001INF \u306F cmp \u306E\u9806\
    \u5E8F\u3067\u5230\u9054\u53EF\u80FD\u306A\u8DDD\u96E2\u3088\u308A\u5927\u304D\
    \u3044\u5024\u3092\u6307\u5B9A\u3059\u308B\u3002\n    # add \u3068\u6BD4\u8F03\
    \u304C O(1) \u306A\u3089\u6642\u9593 O(V + (E + K) log(E + K + 2))\u3001\u7A7A\
    \u9593 O(V + E + K)\u3002K \u306F\u59CB\u70B9\u6570\u3002\n    proc restore_dijkstra*[T,\
    \ S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance:\
    \ T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): tuple[costs: seq[T],\
    \ prev: seq[int]] =\n        ## \u66F4\u65B0\u95A2\u6570 add \u3068\u6BD4\u8F03\
    \u95A2\u6570 cmp \u3067\u6700\u77ED\u8DDD\u96E2\u3068\u5FA9\u5143\u7528\u306E\u89AA\
    \u3092\u6C42\u3081\u308B\u3002\u91CD\u307F\u306A\u3057\u306E\u8FBA\u306F int \u306E\
    \ 1\u3002\n        ## T \u3068 S \u306F\u30B0\u30E9\u30D5\u30FBadd\u30FBZERO\u30FB\
    INF \u304B\u3089\u63A8\u8AD6\u3055\u308C\u308B\u3002\n        # \u9593\u63A5 import\
    \ \u3067\u3082\u30D2\u30FC\u30D7\u8981\u7D20\u306E\u6BD4\u8F03\u6F14\u7B97\u5B50\
    \u3092\u89E3\u6C7A\u3067\u304D\u308B\u3088\u3046\u306B\u3059\u308B\u3002\n   \
    \     bind `<`\n        var\n            queue = initHeapQueue[DijkstraQueueEntry[T]]()\n\
    \            costs = newSeq[T](len(G))\n            prev = newseq[int](len(G))\n\
    \        costs.fill(INF)\n        prev.fill(-1)\n        when start is int:\n\
    \            queue.push(DijkstraQueueEntry[T](distance: ZERO, vertex: start, cmp:\
    \ cmp))\n            costs[start] = ZERO\n        else:\n            for s in\
    \ start:\n                if cmp(costs[s], ZERO) == 0:\n                    continue\n\
    \                queue.push(DijkstraQueueEntry[T](distance: ZERO, vertex: s, cmp:\
    \ cmp))\n                costs[s] = ZERO\n        while len(queue) != 0:\n   \
    \         let entry = queue.pop()\n            let i = entry.vertex\n        \
    \    if cmp(costs[i], entry.distance) < 0:\n                continue\n       \
    \     for (j, c) in G.to_and_cost(i):\n                var temp = add(costs[i],\
    \ c)\n                if cmp(temp, costs[j]) < 0:\n                    prev[j]\
    \ = i\n                    costs[j] = temp\n                    queue.push(DijkstraQueueEntry[T](distance:\
    \ temp, vertex: j, cmp: cmp))\n        return (costs, prev)\n    proc dijkstra*[T,\
    \ S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance:\
    \ T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): seq[T] =\n        ##\
    \ \u66F4\u65B0\u95A2\u6570 add \u3068\u6BD4\u8F03\u95A2\u6570 cmp \u3067\u5404\
    \u9802\u70B9\u3078\u306E\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\u5230\
    \u9054\u4E0D\u80FD\u306A\u9802\u70B9\u306F INF\u3002\n        restore_dijkstra(G,\
    \ start, add, ZERO, INF, cmp).costs\n    proc shortest_path_dijkstra*[T, S](G:\
    \ WeightedGraph[S] or UnWeightedGraph, start: int, goal: int, add: proc(distance:\
    \ T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): tuple[path: seq[int],\
    \ cost: T] =\n        ## add \u3068 cmp \u3092\u7528\u3044\u3066\u7D4C\u8DEF\u3068\
    \u8DDD\u96E2\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u6642\u306E\u7D4C\
    \u8DEF\u306F\u5F93\u6765\u3069\u304A\u308A @[goal]\u3002\n        let (costs,\
    \ prev) = restore_dijkstra(G, start, add, ZERO, INF, cmp)\n        result.path\
    \ = prev.restore_shortest_path_from_prev(goal)\n        result.cost = costs[goal]\n\
    \    proc restore_dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start:\
    \ int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T): tuple[costs:\
    \ seq[T], prev: seq[int]] =\n        ## T \u306E\u901A\u5E38\u306E\u6BD4\u8F03\
    \u3092\u7528\u3044\u3066\u6700\u77ED\u8DDD\u96E2\u3068\u5FA9\u5143\u7528\u306E\
    \u89AA\u3092\u8FD4\u3059\u3002\n        restore_dijkstra(G, start, add, ZERO,\
    \ INF, system.cmp[T])\n    proc dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph,\
    \ start: int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T): seq[T]\
    \ =\n        ## T \u306E\u901A\u5E38\u306E\u6BD4\u8F03\u3092\u7528\u3044\u3066\
    \u5404\u9802\u70B9\u3078\u306E\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\
    \n        dijkstra(G, start, add, ZERO, INF, system.cmp[T])\n    proc shortest_path_dijkstra*[T,\
    \ S](G: WeightedGraph[S] or UnWeightedGraph, start: int, goal: int, add: proc(distance:\
    \ T, edge: S): T, ZERO, INF: T): tuple[path: seq[int], cost: T] =\n        ##\
    \ T \u306E\u901A\u5E38\u306E\u6BD4\u8F03\u3092\u7528\u3044\u3066\u7D4C\u8DEF\u3068\
    \u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_dijkstra(G,\
    \ start, goal, add, ZERO, INF, system.cmp[T])\n    proc restore_dijkstra_impl[T](G:\
    \ WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T):\
    \ tuple[costs: seq[T], prev: seq[int]] =\n        ## \u901A\u5E38\u306E\u52A0\u7B97\
    \u3092\u7528\u3044\u3066\u6700\u77ED\u8DDD\u96E2\u3068\u5FA9\u5143\u7528\u306E\
    \u89AA\u3092\u6C42\u3081\u308B\u3002\n        when G is UnWeightedGraph:\n   \
    \         let add = proc(distance: T, edge: int): T = distance + edge\n      \
    \  else:\n            let add = proc(distance: T, edge: T): T = distance + edge\n\
    \        restore_dijkstra(G, start, add, ZERO, INF)\n    macro declareDijkstra(name,\
    \ t, zero, inf) =\n        ## \u6570\u5024\u578B\u5411\u3051\u306B ZERO \u3068\
    \ INF \u3092\u7701\u7565\u3067\u304D\u308B\u30AA\u30FC\u30D0\u30FC\u30ED\u30FC\
    \u30C9\u3092\u751F\u6210\u3059\u308B\u3002\n        let impl_name = ident($`name`\
    \ & \"_impl\")\n        if $t == \"int\":\n            quote do:\n           \
    \     proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`] or UnWeightedGraph,\
    \ start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =\n    \
    \                ## \u901A\u5E38\u306E\u52A0\u7B97\u3092\u7528\u3044\u3066\u5404\
    \u59CB\u70B9\u304B\u3089\u6700\u77ED\u8DDD\u96E2\u3092\u6C42\u3081\u308B\u3002\
    \n                    `impl_name`(G, start, ZERO, INF)\n        else:\n      \
    \      quote do:\n                proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`],\
    \ start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =\n    \
    \                ## \u901A\u5E38\u306E\u52A0\u7B97\u3092\u7528\u3044\u3066\u5404\
    \u59CB\u70B9\u304B\u3089\u6700\u77ED\u8DDD\u96E2\u3092\u6C42\u3081\u308B\u3002\
    \n                    `impl_name`(G, start, ZERO, INF)\n    declareDijkstra(restore_dijkstra,\
    \ int, 0, INF64)\n    declareDijkstra(restore_dijkstra, int32, 0i32, INF32)\n\
    \    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)\n    declareDijkstra(restore_dijkstra,\
    \ float32, 0.0'f32, 1e30'f32)\n    proc restore_dijkstra*[T](G: WeightedGraph[T]\
    \ or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): auto =\n        ##\
    \ \u901A\u5E38\u306E\u52A0\u7B97\u3092\u7528\u3044\u3066\u6700\u77ED\u8DDD\u96E2\
    \u3068\u5FA9\u5143\u7528\u306E\u89AA\u3092\u8FD4\u3059\u3002\n        restore_dijkstra_impl(G,\
    \ start, ZERO, INF)\n    proc dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph,\
    \ start: int or seq[int], ZERO, INF: T): seq[T] =\n        ## \u901A\u5E38\u306E\
    \u52A0\u7B97\u3092\u7528\u3044\u3066\u5404\u9802\u70B9\u3078\u306E\u6700\u77ED\
    \u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        var (costs, _) = restore_dijkstra(G,\
    \ start, ZERO, INF)\n        return costs\n    declareDijkstra(dijkstra, int,\
    \ 0, INF64)\n    declareDijkstra(dijkstra, int32, 0i32, INF32)\n    declareDijkstra(dijkstra,\
    \ float, 0.0, 1e100)\n    declareDijkstra(dijkstra, float32, 0.0'f32, 1e30'f32)\n\
    \    proc dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int],\
    \ ZERO, INF: T): auto =\n        ## \u901A\u5E38\u306E\u52A0\u7B97\u3092\u7528\
    \u3044\u3066\u5404\u9802\u70B9\u3078\u306E\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\
    \u3059\u3002\n        dijkstra_impl(G, start, ZERO, INF)\n    proc shortest_path_dijkstra_impl[T](G:\
    \ WeightedGraph[T] or UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T):\
    \ tuple[path: seq[int], cost: T] =\n        ## \u901A\u5E38\u306E\u52A0\u7B97\u3092\
    \u7528\u3044\u3066\u59CB\u70B9\u304B\u3089\u7D42\u70B9\u3078\u306E\u7D4C\u8DEF\
    \u3068\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        var (costs, prev)\
    \ = restore_dijkstra(G, start, ZERO, INF)\n        result.path = prev.restore_shortest_path_from_prev(goal)\n\
    \        result.cost = costs[goal]\n    proc shortest_path_dijkstra*(G: DynamicGraph[int]\
    \ or StaticGraph[int] or UnWeightedGraph, start: int, goal: int, ZERO: int = 0,\
    \ INF: int = INF64): tuple[path: seq[int], cost: int] =\n        ## int \u306E\
    \u8DDD\u96E2\u3092\u7528\u3044\u3066\u7D4C\u8DEF\u3068\u6700\u77ED\u8DDD\u96E2\
    \u3092\u8FD4\u3059\u3002\n        shortest_path_dijkstra_impl(G, start, goal,\
    \ ZERO, INF)\n    proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32],\
    \ start: int, goal: int, ZERO: int32 = 0.int32, INF: int32 = INF32): tuple[path:\
    \ seq[int], cost: int32] =\n        ## int32 \u306E\u8DDD\u96E2\u3092\u7528\u3044\
    \u3066\u7D4C\u8DEF\u3068\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n   \
    \     shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)\n    proc shortest_path_dijkstra*(G:\
    \ DynamicGraph[float] or StaticGraph[float], start: int, goal: int, ZERO: float\
    \ = 0.0, INF: float = 1e100): tuple[path: seq[int], cost: float] =\n        ##\
    \ float \u306E\u8DDD\u96E2\u3092\u7528\u3044\u3066\u7D4C\u8DEF\u3068\u6700\u77ED\
    \u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_dijkstra_impl(G, start,\
    \ goal, ZERO, INF)\n    proc shortest_path_dijkstra*(G: DynamicGraph[float32]\
    \ or StaticGraph[float32], start: int, goal: int, ZERO: float32 = 0.0'f32, INF:\
    \ float32 = 1e30'f32): tuple[path: seq[int], cost: float32] =\n        ## float32\
    \ \u306E\u8DDD\u96E2\u3092\u7528\u3044\u3066\u7D4C\u8DEF\u3068\u6700\u77ED\u8DDD\
    \u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_dijkstra_impl(G, start,\
    \ goal, ZERO, INF)\n    proc shortest_path_dijkstra*[T](G: WeightedGraph[T] or\
    \ UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int],\
    \ cost: T] =\n        ## \u901A\u5E38\u306E\u52A0\u7B97\u3092\u7528\u3044\u3066\
    \u7D4C\u8DEF\u3068\u6700\u77ED\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_dijkstra_impl(G,\
    \ start, goal, ZERO, INF)\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/graph/dijkstra.nim
  requiredBy:
  - cplib/graph/tsp.nim
  - cplib/graph/tsp.nim
  timestamp: '2026-10-29 04:15:51+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dijkstra_custom_types_test.nim
  - verify/graph/dijkstra_custom_types_test.nim
  - verify/graph/dijkstra_custom_cmp_test.nim
  - verify/graph/dijkstra_custom_cmp_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/AI/implicit_dijkstra_test.nim
  - verify/AI/implicit_dijkstra_test.nim
  - verify/AI/dijkstra_test.nim
  - verify/AI/dijkstra_test.nim
  - verify/AI/dijkstra_radix_test.nim
  - verify/AI/dijkstra_radix_test.nim
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/implicit_bfs_test.nim
  - verify/AI/implicit_bfs_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_storage_test.nim
  - verify/AI/graph_storage_test.nim
documentation_of: cplib/graph/dijkstra.nim
layout: document
redirect_from:
- /library/cplib/graph/dijkstra.nim
- /library/cplib/graph/dijkstra.nim.html
title: cplib/graph/dijkstra.nim
---
