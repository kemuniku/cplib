---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_bfs_test.nim
    title: verify/AI/implicit_bfs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/implicit_bfs_test.nim
    title: verify/AI/implicit_bfs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/implicit_bfs_tree_diameter_test.nim
    title: verify/utils/implicit_bfs_tree_diameter_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/implicit_bfs_tree_diameter_test.nim
    title: verify/utils/implicit_bfs_tree_diameter_test.nim
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
  code: "when not declared CPLIB_UTILS_IMPLICIT_BFS:\n    const CPLIB_UTILS_IMPLICIT_BFS*\
    \ = 1\n\n    import algorithm, deques, tables, sets\n    import cplib/utils/constants\n\
    \n    # \u72B6\u614B\u306F hash \u3068 == \u304C\u5229\u7528\u3067\u304D\u3001\
    \u63A2\u7D22\u4E2D\u306B\u5024\u304C\u5909\u5316\u3057\u306A\u3044\u3053\u3068\
    \u3092\u4EEE\u5B9A\u3059\u308B\u3002\n    # \u5168\u63A2\u7D22\u3067\u306F\u5230\
    \u9054\u7BC4\u56F2\u304C\u6709\u9650\u3001\u9014\u4E2D\u7D42\u4E86\u3067\u306F\
    \u7D42\u4E86\u307E\u3067\u306E\u63A2\u7D22\u304C\u6709\u9650\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308B\u3002\n    # \u8DDD\u96E2\u306F int \u306E\u7BC4\
    \u56F2\u5185\u3092\u4EEE\u5B9A\u3059\u308B\u3002V \u306F\u63A2\u7D22\u9802\u70B9\
    \u6570\u3001E \u306F\u5217\u6319\u8FBA\u6570\u3001S \u306F\u59CB\u70B9\u5217\u306E\
    \u9577\u3055\u3002\n    # hash/\u6BD4\u8F03/\u5404\u8FBA\u306E\u751F\u6210\u304C\
    \u5B9A\u6570\u6642\u9593\u306A\u3089\u671F\u5F85\u6642\u9593 O(S + V + E)\u3001\
    \u7A7A\u9593 O(V)\uFF08callback \u306E\u751F\u6210\u9818\u57DF\u3092\u9664\u304F\
    \uFF09\u3002\n\n    type\n        ImplicitBfsAdjacent*[T] = proc(v: T): seq[T]\
    \ {.closure.}\n        ImplicitBfsFinish*[T] = proc(v: T): bool {.closure.}\n\n\
    \    proc restore_implicit_bfs*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T]):\
    \ tuple[costs: Table[T, int], prev: Table[T, T]] =\n        ## \u5404\u59CB\u70B9\
    \u306E\u8DDD\u96E2\u3092 0 \u3068\u3057\u3066 BFS \u3067\u5230\u9054\u7BC4\u56F2\
    \u3092\u63A2\u7D22\u3057\u3001\u8FBA\u6570\u3068\u89AA\u3092\u8FD4\u3059\u3002\
    \n        ## \u91CD\u8907\u59CB\u70B9\u306F\u7121\u8996\u3057\u3001\u59CB\u70B9\
    \u306F prev \u306B\u542B\u3081\u306A\u3044\u3002\u7A7A\u59CB\u70B9\u306A\u3089\
    \u4E21 Table \u306F\u7A7A\u3002\n        var queue = initDeque[T]()\n        result.costs\
    \ = initTable[T, int]()\n        result.prev = initTable[T, T]()\n        for\
    \ s in start:\n            if not result.costs.hasKey(s):\n                result.costs[s]\
    \ = 0\n                queue.addLast(s)\n        while queue.len > 0:\n      \
    \      let vertex = queue.popFirst()\n            let cost = result.costs[vertex]\n\
    \            for next in adjacent(vertex):\n                if not result.costs.hasKey(next):\n\
    \                    result.costs[next] = cost + 1\n                    result.prev[next]\
    \ = vertex\n                    queue.addLast(next)\n\n    proc implicit_bfs*[T](start:\
    \ openArray[T], adjacent: ImplicitBfsAdjacent[T]): Table[T, int] =\n        ##\
    \ \u5404\u59CB\u70B9\u304B\u3089\u306E\u6700\u5C0F\u8FBA\u6570\u3092\u8FD4\u3059\
    \u3002\u5230\u9054\u4E0D\u80FD\u306A\u9802\u70B9\u306F Table \u306B\u542B\u307E\
    \u308C\u306A\u3044\u3002\n        restore_implicit_bfs(start, adjacent).costs\n\
    \n    proc implicit_bfs_until*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T],\
    \ finish: ImplicitBfsFinish[T], INF: int = INF64): int =\n        ## \u521D\u3081\
    \u3066 finish \u3092\u6E80\u305F\u3059\u9802\u70B9\u307E\u3067\u306E\u6700\u5C0F\
    \u8FBA\u6570\u3092\u8FD4\u3059\u3002\n        ## \u59CB\u70B9\u3082\u5224\u5B9A\
    \u3057\u3001\u8A72\u5F53\u9802\u70B9\u304C\u306A\u3044\u5834\u5408\uFF08\u7A7A\
    \u59CB\u70B9\u3092\u542B\u3080\uFF09\u306F INF \u3092\u8FD4\u3059\u3002\n    \
    \    var\n            queue = initDeque[T]()\n            costs = initTable[T,\
    \ int]()\n        for s in start:\n            if not costs.hasKey(s):\n     \
    \           costs[s] = 0\n                queue.addLast(s)\n        while queue.len\
    \ > 0:\n            let vertex = queue.popFirst()\n            let cost = costs[vertex]\n\
    \            if finish(vertex):\n                return cost\n            for\
    \ next in adjacent(vertex):\n                if not costs.hasKey(next):\n    \
    \                costs[next] = cost + 1\n                    queue.addLast(next)\n\
    \        return INF\n\n    proc shortest_path_implicit_bfs*[T](start: openArray[T],\
    \ goal: openArray[T], adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path:\
    \ seq[T], cost: int] =\n        ## \u3044\u305A\u308C\u304B\u306E goal \u306B\u6700\
    \u3082\u8FD1\u3044\u59CB\u70B9\u304B\u3089\u306E\u7D4C\u8DEF\u3068\u8DDD\u96E2\
    \u3092\u8FD4\u3059\u3002\n        ## \u6700\u77ED\u8DDD\u96E2\u78BA\u5B9A\u6642\
    \u306B\u7D42\u4E86\u3059\u308B\u3002\u5230\u9054\u4E0D\u80FD\u306F (\u7A7A\u7D4C\
    \u8DEF, INF)\u3001\u7A7A\u7D42\u70B9\u306A\u3089\u63A2\u7D22\u3057\u306A\u3044\
    \u3002\n        ## \u7D42\u70B9\u6570 G \u306E\u96C6\u5408\u5316\u306B\u671F\u5F85\
    \u6642\u9593\u30FB\u7A7A\u9593 O(G)\u3001\u7D42\u70B9\u5224\u5B9A\u306B\u671F\u5F85\
    \ O(1) \u3092\u8FFD\u52A0\u3059\u308B\u3002\n        ## \u91CD\u8907\u7D42\u70B9\
    \u306F\u7121\u8996\u3057\u3001\u540C\u8DDD\u96E2\u306E\u7D42\u70B9\u30FB\u7D4C\
    \u8DEF\u306E\u9078\u629E\u306F\u4FDD\u8A3C\u3057\u306A\u3044\u3002\n        if\
    \ goal.len == 0:\n            return (@[], INF)\n        var goals = initHashSet[T]()\n\
    \        for g in goal:\n            goals.incl(g)\n        var\n            queue\
    \ = initDeque[T]()\n            costs = initTable[T, int]()\n            prev\
    \ = initTable[T, T]()\n        for s in start:\n            if not costs.hasKey(s):\n\
    \                costs[s] = 0\n                queue.addLast(s)\n        while\
    \ queue.len > 0:\n            let vertex = queue.popFirst()\n            let cost\
    \ = costs[vertex]\n            if vertex in goals:\n                result.cost\
    \ = cost\n                var current = vertex\n                result.path.add(current)\n\
    \                while prev.hasKey(current):\n                    current = prev[current]\n\
    \                    result.path.add(current)\n                result.path.reverse()\n\
    \                return\n            for next in adjacent(vertex):\n         \
    \       if not costs.hasKey(next):\n                    costs[next] = cost + 1\n\
    \                    prev[next] = vertex\n                    queue.addLast(next)\n\
    \        result.cost = INF\n        result.path = @[]\n\n    proc shortest_path_implicit_bfs*[T](start:\
    \ openArray[T], goal: T, adjacent: ImplicitBfsAdjacent[T], INF: int = INF64):\
    \ tuple[path: seq[T], cost: int] =\n        ## \u591A\u59CB\u70B9\u30FB\u5358\u4E00\
    \u7D42\u70B9\u7248\u3002\u6700\u3082\u8FD1\u3044\u59CB\u70B9\u304B\u3089\u306E\
    \u7D4C\u8DEF\u3068\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_implicit_bfs(start,\
    \ [goal], adjacent, INF)\n\n    proc shortest_path_implicit_bfs*[T](start: T,\
    \ goal: openArray[T], adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path:\
    \ seq[T], cost: int] =\n        ## \u5358\u4E00\u59CB\u70B9\u30FB\u591A\u7D42\u70B9\
    \u7248\u3002\u6700\u3082\u8FD1\u3044\u7D42\u70B9\u307E\u3067\u306E\u7D4C\u8DEF\
    \u3068\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        shortest_path_implicit_bfs([start],\
    \ goal, adjacent, INF)\n\n    proc restore_implicit_bfs*[T](start: T, adjacent:\
    \ ImplicitBfsAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =\n\
    \        ## \u5358\u4E00\u59CB\u70B9\u7248\u3002\u8DDD\u96E2\u30FB\u5FA9\u5143\
    \u306F\u591A\u59CB\u70B9\u7248\u3068\u540C\u3058\u3002\n        restore_implicit_bfs([start],\
    \ adjacent)\n\n    proc implicit_bfs*[T](start: T, adjacent: ImplicitBfsAdjacent[T]):\
    \ Table[T, int] =\n        ## \u5358\u4E00\u59CB\u70B9\u304B\u3089\u5230\u9054\
    \u53EF\u80FD\u306A\u5404\u9802\u70B9\u307E\u3067\u306E\u6700\u5C0F\u8FBA\u6570\
    \u3092\u8FD4\u3059\u3002\n        implicit_bfs([start], adjacent)\n\n    proc\
    \ implicit_bfs_until*[T](start: T, adjacent: ImplicitBfsAdjacent[T], finish: ImplicitBfsFinish[T],\
    \ INF: int = INF64): int =\n        ## \u5358\u4E00\u59CB\u70B9\u7248\u3002\u7D42\
    \u4E86\u6761\u4EF6\u30FB\u8FD4\u308A\u5024\u306F\u591A\u59CB\u70B9\u7248\u3068\
    \u540C\u3058\u3002\n        implicit_bfs_until([start], adjacent, finish, INF)\n\
    \n    proc shortest_path_implicit_bfs*[T](start, goal: T, adjacent: ImplicitBfsAdjacent[T],\
    \ INF: int = INF64): tuple[path: seq[T], cost: int] =\n        ## \u5358\u4E00\
    \u59CB\u70B9\u304B\u3089 goal \u307E\u3067\u306E\u7D4C\u8DEF\u3068\u8FBA\u6570\
    \u3092\u8FD4\u3059\u3002\n        shortest_path_implicit_bfs([start], goal, adjacent,\
    \ INF)\n\n    proc implicit_bfs_until*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T],\
    \ finish: openArray[T], INF: int = INF64): int =\n        ## \u3044\u305A\u308C\
    \u304B\u306E\u7D42\u70B9 finish \u3078\u306E\u6700\u77ED\u8DDD\u96E2\u304C\u78BA\
    \u5B9A\u3057\u305F\u6642\u70B9\u3067\u7D42\u4E86\u3057\u3001\u305D\u306E\u8DDD\
    \u96E2\u3092\u8FD4\u3059\u3002\n        ## \u7D42\u70B9\u6570 G \u306E\u96C6\u5408\
    \u5316\u306B\u671F\u5F85\u6642\u9593\u30FB\u7A7A\u9593 O(G)\u3001\u5224\u5B9A\u306B\
    \u671F\u5F85 O(1) \u3092\u8FFD\u52A0\u3059\u308B\u3002\n        ## \u91CD\u8907\
    \u7D42\u70B9\u306F\u7121\u8996\u3057\u3001\u7A7A\u7D42\u70B9\u306A\u3089\u63A2\
    \u7D22\u305B\u305A INF \u3092\u8FD4\u3059\u3002\n        if finish.len == 0:\n\
    \            return INF\n        var goals = initHashSet[T]()\n        for g in\
    \ finish:\n            goals.incl(g)\n        let predicate: ImplicitBfsFinish[T]\
    \ = proc(v: T): bool = v in goals\n        implicit_bfs_until(start, adjacent,\
    \ predicate, INF)\n\n    proc implicit_bfs_until*[T](start: T, adjacent: ImplicitBfsAdjacent[T],\
    \ finish: openArray[T], INF: int = INF64): int =\n        ## \u5358\u4E00\u59CB\
    \u70B9\u30FB\u591A\u7D42\u70B9\u7248\u3002\u6700\u3082\u8FD1\u3044\u7D42\u70B9\
    \u3078\u306E\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        implicit_bfs_until([start],\
    \ adjacent, finish, INF)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/utils/implicit_bfs.nim
  requiredBy: []
  timestamp: '2026-10-05 12:14:47+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/implicit_bfs_tree_diameter_test.nim
  - verify/utils/implicit_bfs_tree_diameter_test.nim
  - verify/AI/implicit_bfs_test.nim
  - verify/AI/implicit_bfs_test.nim
documentation_of: cplib/utils/implicit_bfs.nim
layout: document
redirect_from:
- /library/cplib/utils/implicit_bfs.nim
- /library/cplib/utils/implicit_bfs.nim.html
title: cplib/utils/implicit_bfs.nim
---
