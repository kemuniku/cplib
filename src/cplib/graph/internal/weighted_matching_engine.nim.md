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
    path: cplib/graph/general_weighted_matching.nim
    title: cplib/graph/general_weighted_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching.nim
    title: cplib/graph/general_weighted_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching_sparse.nim
    title: cplib/graph/general_weighted_matching_sparse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching_sparse.nim
    title: cplib/graph/general_weighted_matching_sparse.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_sparse_test.nim
    title: verify/AI/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_sparse_test.nim
    title: verify/AI/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_test.nim
    title: verify/AI/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_test.nim
    title: verify/AI/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/weighted_matching_structure_test.nim
    title: verify/AI/weighted_matching_structure_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/weighted_matching_structure_test.nim
    title: verify/AI/weighted_matching_structure_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_sparse_test.nim
    title: verify/graph/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_sparse_test.nim
    title: verify/graph/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_test.nim
    title: verify/graph/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_test.nim
    title: verify/graph/general_weighted_matching_test.nim
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
  code: "## \u6700\u5927\u91CD\u307F\u30DE\u30C3\u30C1\u30F3\u30B0\u306E\u4E3B\u53CC\
    \u5BFE\u63A2\u7D22\u3002\n## \u82B1\u3092\u56FA\u5B9A\u9806\u306E\u5B50\u3068\u5DE1\
    \u56DE\u8FBA\u3067\u8868\u3057\u3001\u57FA\u70B9\u306E\u5909\u66F4\u306F\u9802\
    \u70B9\u5217\u306E\u4E26\u3079\u66FF\u3048\u3092\u4F34\u308F\u306A\u3044\u3002\
    \n## \u758E\u30B0\u30E9\u30D5\u3067\u306F\u9802\u70B9\u5217\u3092AVL\u6728\u3067\
    \u9023\u7D50\u30FB\u5206\u5272\u3057\u3001\u53CC\u5BFE\u5024\u3068\u6700\u5C0F\
    \u4F59\u88D5\u3092\u9045\u5EF6\u66F4\u65B0\u3059\u308B\u3002\n## \u5BC6\u30B0\u30E9\
    \u30D5\u3067\u306F\u6240\u5C5E\u914D\u5217\u3068\u6210\u5206\u9593\u306E\u6700\
    \u5C0F\u8FBA\u3092\u4F7F\u3046\u3002\nwhen not declared CPLIB_GRAPH_INTERNAL_WEIGHTED_MATCHING_ENGINE:\n\
    \    const CPLIB_GRAPH_INTERNAL_WEIGHTED_MATCHING_ENGINE* = 1\n    import heapqueue\n\
    \    import cplib/graph/graph\n\n    const MatchingInfinity = high(int64)\n  \
    \  type\n        MatchingDirection = tuple[src, dst: int]\n        MatchingEdge\
    \ = tuple[src, dst: int, weight: int64]\n        MatchingColor = enum\n      \
    \      mcHidden, mcIdle, mcEven, mcOdd\n        MatchingComponent = object\n \
    \           live: bool\n            parent, count, first, base, pivot, root, version:\
    \ int\n            color: MatchingColor\n            dual, changed: int64\n  \
    \          previous: MatchingDirection\n            children: seq[int]\n     \
    \       cycle: seq[MatchingDirection]\n            ends, members, direct: seq[int]\n\
    \            bestVertex, crossEdge: int\n            best, cross: int64\n    \
    \    MatchingLeaf = object\n            left, right, parent, height, count, owner:\
    \ int\n            potential, lazy, offer, minimum: int64\n            edge, arg:\
    \ int\n        MatchingEvent = tuple[time: int64, kind, component, version, edge:\
    \ int]\n        MatchingMachine[fast: static bool] = object\n            n, serial,\
    \ queueHead: int\n            time: int64\n            arcs: seq[MatchingEdge]\n\
    \            adjacency: seq[seq[int]]\n            components: seq[MatchingComponent]\n\
    \            leaves: seq[MatchingLeaf]\n            free, mate, queue, marked:\
    \ seq[int]\n            currentVisit: int\n            heap: HeapQueue[MatchingEvent]\n\
    \            pending: seq[MatchingEvent]\n            heapReady: bool\n      \
    \      owner: seq[int]\n            between: seq[seq[int]]\n\n    proc slope(color:\
    \ MatchingColor): int64 {.inline.} =\n        ## \u5916\u5074\u30FB\u5185\u5074\
    \u30FB\u672A\u5230\u9054\u306E\u9802\u70B9\u306E\u53CC\u5BFE\u5024\u306E\u5909\
    \u5316\u7387\u3092\u8FD4\u3059\u3002\n        case color\n        of mcEven: -1'i64\n\
    \        of mcOdd: 1'i64\n        else: 0'i64\n\n    proc reverse(edge: MatchingDirection):\
    \ MatchingDirection {.inline.} =\n        ## \u8FBA\u306E\u5411\u304D\u3092\u53CD\
    \u8EE2\u3059\u308B\u3002\n        (edge.dst, edge.src)\n\n    proc apply[fast:\
    \ static bool](s: var MatchingMachine[fast], root: int, delta: int64) =\n    \
    \    ## AVL\u90E8\u5206\u6728\u306E\u53CC\u5BFE\u5024\u3068\u6700\u5C0F\u4F59\u88D5\
    \u3092\u4E00\u62EC\u66F4\u65B0\u3059\u308B\u3002O(1)\u3002\n        if root ==\
    \ 0 or delta == 0: return\n        s.leaves[root].potential += delta\n       \
    \ s.leaves[root].lazy += delta\n        if s.leaves[root].minimum != MatchingInfinity:\n\
    \            s.leaves[root].minimum += delta\n\n    proc push[fast: static bool](s:\
    \ var MatchingMachine[fast], root: int) =\n        ## \u4FDD\u7559\u3057\u3066\
    \u3044\u308B\u53CC\u5BFE\u5024\u306E\u66F4\u65B0\u3092\u5B50\u3078\u4F1D\u3048\
    \u308B\u3002O(1)\u3002\n        let delta = s.leaves[root].lazy\n        if delta\
    \ == 0: return\n        s.apply(s.leaves[root].left, delta)\n        s.apply(s.leaves[root].right,\
    \ delta)\n        s.leaves[root].lazy = 0\n\n    proc pull[fast: static bool](s:\
    \ var MatchingMachine[fast], root: int) =\n        ## AVL\u7BC0\u70B9\u306E\u9AD8\
    \u3055\u30FB\u8981\u7D20\u6570\u30FB\u6700\u5C0F\u4F59\u88D5\u3092\u518D\u8A08\
    \u7B97\u3059\u308B\u3002O(1)\u3002\n        let l = s.leaves[root].left\n    \
    \    let r = s.leaves[root].right\n        s.leaves[root].height = 1 + max(s.leaves[l].height,\
    \ s.leaves[r].height)\n        s.leaves[root].count = 1 + s.leaves[l].count +\
    \ s.leaves[r].count\n        var best = MatchingInfinity\n        var arg = 0\n\
    \        if s.leaves[root].edge >= 0:\n            best = s.leaves[root].potential\
    \ + s.leaves[root].offer\n            arg = root\n        for child in [l, r]:\n\
    \            if child != 0 and s.leaves[child].minimum < best:\n             \
    \   best = s.leaves[child].minimum\n                arg = s.leaves[child].arg\n\
    \        s.leaves[root].minimum = best\n        s.leaves[root].arg = arg\n\n \
    \   proc attach[fast: static bool](s: var MatchingMachine[fast], root, child:\
    \ int, right: bool) =\n        ## \u5B50\u3078\u306E\u30EA\u30F3\u30AF\u3068\u9006\
    \u5411\u304D\u306E\u89AA\u30EA\u30F3\u30AF\u3092\u540C\u6642\u306B\u66F4\u65B0\
    \u3059\u308B\u3002\n        if right: s.leaves[root].right = child\n        else:\
    \ s.leaves[root].left = child\n        if child != 0: s.leaves[child].parent =\
    \ root\n\n    proc rotate[fast: static bool](s: var MatchingMachine[fast], root:\
    \ int, left: bool): int =\n        ## \u4E00\u56DE\u306E\u56DE\u8EE2\u3067\u3001\
    \u9802\u70B9\u5217\u306E\u9806\u5E8F\u3092\u4FDD\u3061\u306A\u304C\u3089AVL\u6728\
    \u3092\u7D44\u307F\u66FF\u3048\u308B\u3002\n        s.push(root)\n        result\
    \ = if left: s.leaves[root].right else: s.leaves[root].left\n        s.push(result)\n\
    \        if left:\n            s.attach(root, s.leaves[result].left, true)\n \
    \           s.attach(result, root, false)\n        else:\n            s.attach(root,\
    \ s.leaves[result].right, false)\n            s.attach(result, root, true)\n \
    \       s.leaves[result].parent = 0\n        s.pull(root)\n        s.pull(result)\n\
    \n    proc balance[fast: static bool](s: var MatchingMachine[fast], root: int):\
    \ int =\n        ## \u5DE6\u53F3\u306E\u9AD8\u3055\u306E\u5DEE\u3092\u89E3\u6D88\
    \u3059\u308B\u3002O(1)\u3002\n        s.pull(root)\n        s.leaves[root].parent\
    \ = 0\n        let l = s.leaves[root].left\n        let r = s.leaves[root].right\n\
    \        if s.leaves[l].height > s.leaves[r].height + 1:\n            if s.leaves[s.leaves[l].right].height\
    \ > s.leaves[s.leaves[l].left].height:\n                let child = s.rotate(l,\
    \ true)\n                s.attach(root, child, false)\n            return s.rotate(root,\
    \ false)\n        if s.leaves[r].height > s.leaves[l].height + 1:\n          \
    \  if s.leaves[s.leaves[r].left].height > s.leaves[s.leaves[r].right].height:\n\
    \                let child = s.rotate(r, false)\n                s.attach(root,\
    \ child, true)\n            return s.rotate(root, true)\n        root\n\n    proc\
    \ join[fast: static bool](s: var MatchingMachine[fast], l, middle, r: int): int\
    \ =\n        ## \u4E00\u7BC0\u70B9\u3092\u9593\u306B\u631F\u3093\u3067\u4E8C\u3064\
    \u306EAVL\u6728\u3092\u9023\u7D50\u3059\u308B\u3002O(\u9AD8\u3055\u306E\u5DEE\
    +1)\u3002\n        if s.leaves[l].height > s.leaves[r].height + 1:\n         \
    \   s.push(l)\n            let child = s.join(s.leaves[l].right, middle, r)\n\
    \            s.attach(l, child, true)\n            return s.balance(l)\n     \
    \   if s.leaves[r].height > s.leaves[l].height + 1:\n            s.push(r)\n \
    \           let child = s.join(l, middle, s.leaves[r].left)\n            s.attach(r,\
    \ child, false)\n            return s.balance(r)\n        s.attach(middle, l,\
    \ false)\n        s.attach(middle, r, true)\n        s.leaves[middle].parent =\
    \ 0\n        s.pull(middle)\n        middle\n\n    proc split[fast: static bool](s:\
    \ var MatchingMachine[fast], root, count: int): tuple[left, right: int] =\n  \
    \      ## \u9802\u70B9\u5217\u3092\u5148\u982Dcount\u500B\u3068\u6B8B\u308A\u306B\
    \u5206\u5272\u3059\u308B\u3002O(log V)\u3002\n        if root == 0: return\n \
    \       s.push(root)\n        let l = s.leaves[root].left\n        let r = s.leaves[root].right\n\
    \        let size = s.leaves[l].count\n        s.leaves[root].left = 0\n     \
    \   s.leaves[root].right = 0\n        s.leaves[root].parent = 0\n        if count\
    \ <= size:\n            let parts = s.split(l, count)\n            result.left\
    \ = parts.left\n            result.right = s.join(parts.right, root, r)\n    \
    \    else:\n            let parts = s.split(r, count - size - 1)\n           \
    \ result.left = s.join(l, root, parts.left)\n            result.right = parts.right\n\
    \        if result.left != 0: s.leaves[result.left].parent = 0\n        if result.right\
    \ != 0: s.leaves[result.right].parent = 0\n\n    proc concatenate[fast: static\
    \ bool](s: var MatchingMachine[fast], l, r: int): int =\n        ## \u4E8C\u3064\
    \u306E\u9802\u70B9\u5217\u3092\u9023\u7D50\u3059\u308B\u3002O(log V)\u3002\n \
    \       if l == 0:\n            if r != 0: s.leaves[r].parent = 0\n          \
    \  return r\n        if r == 0:\n            s.leaves[l].parent = 0\n        \
    \    return l\n        let parts = s.split(l, s.leaves[l].count - 1)\n       \
    \ s.join(parts.left, parts.right, r)\n\n    proc top[fast: static bool](s: MatchingMachine[fast],\
    \ vertex: int): int {.inline.} =\n        ## \u9802\u70B9\u3092\u542B\u3080\u6700\
    \u4E0A\u4F4D\u306E\u82B1\u3092\u8FD4\u3059\u3002\u5BC6\u7248O(1)\u3001\u758E\u7248\
    O(log V)\u3002\n        when fast:\n            var root = vertex\n          \
    \  while s.leaves[root].parent != 0: root = s.leaves[root].parent\n          \
    \  s.leaves[root].owner\n        else: s.owner[vertex]\n\n    proc potential[fast:\
    \ static bool](s: MatchingMachine[fast], vertex: int): int64 {.inline.} =\n  \
    \      ## \u6642\u523B\u306E\u9805\u3092\u9664\u3044\u305F\u9802\u70B9\u306E\u53CC\
    \u5BFE\u5024\u3092\u8FD4\u3059\u3002\u5BC6\u7248O(1)\u3001\u758E\u7248O(log V)\u3002\
    \n        result = s.leaves[vertex].potential\n        when fast:\n          \
    \  var v = s.leaves[vertex].parent\n            while v != 0:\n              \
    \  result += s.leaves[v].lazy\n                v = s.leaves[v].parent\n\n    proc\
    \ rank[fast: static bool](s: MatchingMachine[fast], vertex: int): int =\n    \
    \    ## \u9802\u70B9\u306E\u3001\u6240\u5C5E\u3059\u308BAVL\u6728\u306E\u4E2D\u3067\
    \u306E\u4F4D\u7F6E\u3092\u8FD4\u3059\u3002O(log V)\u3002\n        result = s.leaves[s.leaves[vertex].left].count\n\
    \        var v = vertex\n        while s.leaves[v].parent != 0:\n            let\
    \ p = s.leaves[v].parent\n            if s.leaves[p].right == v:\n           \
    \     result += s.leaves[s.leaves[p].left].count + 1\n            v = p\n\n  \
    \  proc childIndex[fast: static bool](s: MatchingMachine[fast], b, vertex: int):\
    \ int =\n        ## \u6307\u5B9A\u9802\u70B9\u3092\u542B\u3080\u76F4\u63A5\u306E\
    \u5B50\u306E\u6DFB\u5B57\u3092\u8FD4\u3059\u3002\u5BC6\u7248O(1)\u3001\u758E\u7248\
    O(log V)\u3002\n        when fast:\n            let index = s.rank(vertex) - s.rank(s.components[b].first)\n\
    \            var l = 0\n            var r = s.components[b].ends.len\n       \
    \     while l < r:\n                let m = (l + r) div 2\n                if\
    \ index < s.components[b].ends[m]: r = m\n                else: l = m + 1\n  \
    \          l\n        else: s.components[b].direct[vertex]\n\n    iterator vertices[fast:\
    \ static bool](s: MatchingMachine[fast], b: int): int =\n        ## \u6700\u4E0A\
    \u4F4D\u306E\u82B1\u306E\u9802\u70B9\u3092\u5217\u6319\u3059\u308B\u3002O(\u9802\
    \u70B9\u6570)\u3002\n        when fast:\n            var stack: seq[int]\n   \
    \         var current = s.components[b].root\n            while current != 0 or\
    \ stack.len > 0:\n                if current != 0:\n                    stack.add(current)\n\
    \                    current = s.leaves[current].left\n                else:\n\
    \                    current = stack.pop()\n                    yield current\n\
    \                    current = s.leaves[current].right\n        else:\n      \
    \      for v in s.components[b].members: yield v\n\n    proc shift[fast: static\
    \ bool](s: var MatchingMachine[fast], b: int, delta: int64) =\n        ## \u4E00\
    \u3064\u306E\u82B1\u306E\u9802\u70B9\u53CC\u5BFE\u5024\u3092\u4E00\u62EC\u66F4\
    \u65B0\u3059\u308B\u3002\u5BC6\u7248O(\u9802\u70B9\u6570)\u3001\u758E\u7248O(1)\u3002\
    \n        when fast: s.apply(s.components[b].root, delta)\n        else:\n   \
    \         for v in s.components[b].members: s.leaves[v].potential += delta\n \
    \           if s.components[b].best != MatchingInfinity: s.components[b].best\
    \ += delta\n\n    proc touch[fast: static bool](s: var MatchingMachine[fast],\
    \ b: int) =\n        ## \u82B1\u306E\u53CC\u5BFE\u5024\u3092\u73FE\u5728\u306E\
    \u6642\u523B\u306B\u305D\u308D\u3048\u308B\u3002\n        if b > s.n:\n      \
    \      s.components[b].dual -= 2 * slope(s.components[b].color) * (s.time - s.components[b].changed)\n\
    \        s.components[b].changed = s.time\n\n    proc invalidate[fast: static\
    \ bool](s: var MatchingMachine[fast], b: int) =\n        ## \u53E4\u3044\u30A4\
    \u30D9\u30F3\u30C8\u3092\u7121\u52B9\u5316\u3059\u308B\u305F\u3081\u3001\u82B1\
    \u306E\u4E16\u4EE3\u756A\u53F7\u3092\u66F4\u65B0\u3059\u308B\u3002\n        inc\
    \ s.serial\n        s.components[b].version = s.serial\n\n    proc bestOffer[fast:\
    \ static bool](s: MatchingMachine[fast], b: int): tuple[value: int64, vertex:\
    \ int] =\n        ## \u82B1\u3078\u5165\u308B\u8FBA\u306E\u3046\u3061\u6700\u5C0F\
    \u306E\u4F59\u88D5\u3092\u4E0E\u3048\u308B\u5019\u88DC\u3092\u8FD4\u3059\u3002\
    O(1)\u3002\n        when fast:\n            let root = s.components[b].root\n\
    \            (s.leaves[root].minimum, s.leaves[root].arg)\n        else: (s.components[b].best,\
    \ s.components[b].bestVertex)\n\n    proc schedule[fast: static bool](s: var MatchingMachine[fast],\
    \ event: MatchingEvent) =\n        ## \u521D\u56DE\u8D70\u67FB\u306E\u30A4\u30D9\
    \u30F3\u30C8\u306F\u307E\u3068\u3081\u3066\u84C4\u3048\u3001\u4EE5\u5F8C\u306F\
    \u30D2\u30FC\u30D7\u306B\u8FFD\u52A0\u3059\u308B\u3002\n        if s.heapReady:\
    \ s.heap.push(event)\n        else: s.pending.add(event)\n\n    proc scheduleOffer[fast:\
    \ static bool](s: var MatchingMachine[fast], b: int) =\n        ## \u672A\u5230\
    \u9054\u306E\u82B1\u306B\u5165\u308B\u5019\u88DC\u3092\u30A4\u30D9\u30F3\u30C8\
    \u3068\u3057\u3066\u767B\u9332\u3059\u308B\u3002\u758E\u7248O(log V)\u3002\n \
    \       when fast:\n            if s.components[b].color != mcIdle: return\n \
    \           let candidate = s.bestOffer(b)\n            s.invalidate(b)\n    \
    \        if candidate.vertex != 0:\n                s.schedule((candidate.value,\
    \ 0, b, s.components[b].version, s.leaves[candidate.vertex].edge))\n\n    proc\
    \ offer[fast: static bool](s: var MatchingMachine[fast], vertex, edge: int, value:\
    \ int64) {.inline.} =\n        ## \u5916\u5074\u9802\u70B9\u304B\u3089\u306E\u5019\
    \u88DC\u3092\u66F4\u65B0\u3059\u308B\u3002\u5BC6\u7248O(1)\u3001\u758E\u7248O(log\
    \ V)\u3002\n        if s.leaves[vertex].edge >= 0 and value >= s.leaves[vertex].offer:\
    \ return\n        let b = s.top(vertex)\n        when fast:\n            var path\
    \ = @[vertex]\n            while s.leaves[path[^1]].parent != 0: path.add(s.leaves[path[^1]].parent)\n\
    \            for i in countdown(path.high, 0): s.push(path[i])\n            s.leaves[vertex].offer\
    \ = value\n            s.leaves[vertex].edge = edge\n            for v in path:\
    \ s.pull(v)\n        else:\n            s.leaves[vertex].offer = value\n     \
    \       s.leaves[vertex].edge = edge\n            let key = s.leaves[vertex].potential\
    \ + value\n            if key < s.components[b].best:\n                s.components[b].best\
    \ = key\n                s.components[b].bestVertex = vertex\n        s.scheduleOffer(b)\n\
    \n    proc edgeTime[fast: static bool](s: MatchingMachine[fast], edge: int): int64\
    \ {.inline.} =\n        ## \u4E8C\u3064\u306E\u5916\u5074\u9802\u70B9\u3092\u7D50\
    \u3076\u8FBA\u304C\u30BF\u30A4\u30C8\u306B\u306A\u308B\u6642\u523B\u3092\u8FD4\
    \u3059\u3002\n        let e = s.arcs[edge]\n        (s.potential(e.src) + s.potential(e.dst)\
    \ - 2 * e.weight) div 2\n\n    proc activateCross[fast: static bool](s: var MatchingMachine[fast],\
    \ b: int) =\n        ## \u5BC6\u7248\u3067\u3001\u5916\u5074\u306E\u82B1\u540C\
    \u58EB\u306E\u6700\u5C0F\u8FBA\u3092\u66F4\u65B0\u3059\u308B\u3002O(V)\u3002\n\
    \        when not fast:\n            s.components[b].cross = MatchingInfinity\n\
    \            s.components[b].crossEdge = -1\n            for c in 1..<s.components.len:\n\
    \                if c == b or s.components[c].color != mcEven: continue\n    \
    \            let edge = s.between[b][c]\n                if edge < 0: continue\n\
    \                let time = s.edgeTime(edge)\n                if time < s.components[b].cross:\n\
    \                    s.components[b].cross = time\n                    s.components[b].crossEdge\
    \ = edge\n                if time < s.components[c].cross:\n                 \
    \   s.components[c].cross = time\n                    s.components[c].crossEdge\
    \ = edge\n\n    proc label[fast: static bool](s: var MatchingMachine[fast], b:\
    \ int, color: MatchingColor) =\n        ## \u82B1\u306E\u30E9\u30D9\u30EB\u3068\
    \u53CC\u5BFE\u5024\u306E\u5909\u5316\u7387\u3092\u5909\u66F4\u3057\u3001\u5FC5\
    \u8981\u306A\u63A2\u7D22\u3092\u767B\u9332\u3059\u308B\u3002\n        let old\
    \ = s.components[b].color\n        s.touch(b)\n        s.shift(b, (slope(old)\
    \ - slope(color)) * s.time)\n        s.components[b].color = color\n        s.invalidate(b)\n\
    \        if color == mcEven and old != mcEven:\n            when not fast:\n \
    \               # \u5916\u5074\u540C\u58EB\u306E\u5019\u88DC\u306F\u3001\u767B\
    \u9332\u3057\u305F\u9802\u70B9\u306E\u8D70\u67FB\u4E2D\u306B\u307E\u3068\u3081\
    \u3066\u66F4\u65B0\u3059\u308B\u3002\n                s.components[b].cross =\
    \ MatchingInfinity\n                s.components[b].crossEdge = -1\n         \
    \   for v in s.vertices(b): s.queue.add(v)\n        elif color == mcIdle:\n  \
    \          s.scheduleOffer(b)\n        elif color == mcOdd and b > s.n:\n    \
    \        when fast:\n                s.schedule((s.time + s.components[b].dual\
    \ div 2, 2, b, s.components[b].version, -1))\n\n    proc ancestor[fast: static\
    \ bool](s: var MatchingMachine[fast], left, right: int): int =\n        ## \u4E8C\
    \u672C\u306E\u4EA4\u4E92\u8DEF\u3092\u4EA4\u4E92\u306B\u305F\u3069\u308A\u3001\
    \u5171\u901A\u7956\u5148\u3092\u8FD4\u3059\u3002\u7570\u306A\u308B\u6728\u306A\
    \u30890\u3002\n        inc s.currentVisit\n        var a = left\n        var b\
    \ = right\n        while a != 0 or b != 0:\n            if a != 0:\n         \
    \       if s.marked[a] == s.currentVisit: return a\n                s.marked[a]\
    \ = s.currentVisit\n                let entry = s.components[a].previous\n   \
    \             if entry.src == 0: a = 0\n                else:\n              \
    \      let inner = s.top(entry.src)\n                    a = s.top(s.components[inner].previous.src)\n\
    \            swap(a, b)\n\n    proc branch[fast: static bool](s: MatchingMachine[fast],\
    \ start, finish: int): tuple[nodes: seq[int], edges: seq[MatchingDirection]] =\n\
    \        ## \u5916\u5074\u306E\u82B1\u304B\u3089\u7956\u5148\u307E\u3067\u306E\
    \u4EA4\u4E92\u8DEF\u3092\u3001\u4E0A\u5411\u304D\u306B\u5217\u6319\u3059\u308B\
    \u3002\n        var current = start\n        while current != finish:\n      \
    \      result.nodes.add(current)\n            let matched = s.components[current].previous\n\
    \            result.edges.add(matched.reverse())\n            current = s.top(matched.src)\n\
    \            result.nodes.add(current)\n            let unmatched = s.components[current].previous\n\
    \            result.edges.add(unmatched.reverse())\n            current = s.top(unmatched.src)\n\
    \n    proc contract[fast: static bool](s: var MatchingMachine[fast], x, y, common:\
    \ int) =\n        ## \u4EA4\u4E92\u8DEF\u4E8C\u672C\u3068\u4E00\u8FBA\u3092\u5947\
    \u9589\u8DEF\u306B\u3057\u3001\u82B1\u3068\u3057\u3066\u7E2E\u7D04\u3059\u308B\
    \u3002\n        let a = s.branch(s.top(x), common)\n        let b = s.branch(s.top(y),\
    \ common)\n        let id = s.free.pop()\n        var flower = MatchingComponent(live:\
    \ true, base: s.components[common].base,\n            first: s.components[common].first,\
    \ previous: s.components[common].previous,\n            changed: s.time, best:\
    \ MatchingInfinity, cross: MatchingInfinity, crossEdge: -1)\n        flower.children.add(common)\n\
    \        for i in countdown(a.nodes.high, 0):\n            flower.cycle.add(a.edges[i].reverse())\n\
    \            flower.children.add(a.nodes[i])\n        flower.cycle.add((x, y))\n\
    \        for i, child in b.nodes:\n            flower.children.add(child)\n  \
    \          flower.cycle.add(b.edges[i])\n        when not fast: flower.direct\
    \ = newSeq[int](s.n + 1)\n        for i, child in flower.children:\n         \
    \   s.label(child, mcEven)\n            s.touch(child)\n            s.components[child].color\
    \ = mcHidden\n            s.components[child].parent = id\n            s.invalidate(child)\n\
    \            flower.count += s.components[child].count\n            flower.ends.add(flower.count)\n\
    \            when fast:\n                flower.root = s.concatenate(flower.root,\
    \ s.components[child].root)\n            else:\n                for v in s.components[child].members:\n\
    \                    flower.members.add(v)\n                    flower.direct[v]\
    \ = i\n                    s.owner[v] = id\n        when fast:\n            s.leaves[flower.root].owner\
    \ = id\n        else:\n            for other in 1..<s.components.len:\n      \
    \          if not s.components[other].live: continue\n                var chosen\
    \ = -1\n                var value = MatchingInfinity\n                for child\
    \ in flower.children:\n                    let edge = s.between[child][other]\n\
    \                    if edge < 0: continue\n                    let e = s.arcs[edge]\n\
    \                    let key = s.potential(e.src) + s.potential(e.dst) - 2 * e.weight\n\
    \                    if key < value:\n                        value = key\n  \
    \                      chosen = edge\n                s.between[id][other] = chosen\n\
    \                s.between[other][id] = chosen\n        flower.color = mcEven\n\
    \        s.components[id] = move(flower)\n        s.invalidate(id)\n        s.activateCross(id)\n\
    \n    proc cycleEdge[fast: static bool](s: MatchingMachine[fast], b, index, direction:\
    \ int): MatchingDirection =\n        ## \u5DE1\u56DE\u8FBA\u3092\u6307\u5B9A\u3055\
    \u308C\u305F\u5411\u304D\u3067\u8FD4\u3059\u3002\n        if direction == 1: s.components[b].cycle[index]\n\
    \        else:\n            let previous = (index + s.components[b].children.len\
    \ - 1) mod s.components[b].children.len\n            s.components[b].cycle[previous].reverse()\n\
    \n    proc expose[fast: static bool](s: var MatchingMachine[fast], component,\
    \ vertex: int) =\n        ## \u6307\u5B9A\u9802\u70B9\u3092\u82B1\u306E\u57FA\u70B9\
    \u306B\u3057\u3001\u5185\u90E8\u306E\u4EA4\u4E92\u8DEF\u3092\u53CD\u8EE2\u3059\
    \u308B\u3002\u518D\u5E30\u306F\u4F7F\u308F\u306A\u3044\u3002\n        var tasks\
    \ = @[(kind: 0, a: component, b: vertex)]\n        while tasks.len > 0:\n    \
    \        let task = tasks.pop()\n            if task.kind == 1:\n            \
    \    s.mate[task.a] = task.b\n                s.mate[task.b] = task.a\n      \
    \          continue\n            let b = task.a\n            let v = task.b\n\
    \            if b <= s.n:\n                s.mate[v] = 0\n                continue\n\
    \            let target = s.childIndex(b, v)\n            let count = s.components[b].children.len\n\
    \            var at = s.components[b].pivot\n            let distance = (target\
    \ - at + count) mod count\n            let direction = if distance mod 2 == 0:\
    \ 1 else: -1\n            while at != target:\n                let next = (at\
    \ + direction + count) mod count\n                let edge = s.cycleEdge(b, at,\
    \ direction)\n                tasks.add((1, edge.src, edge.dst))\n           \
    \     tasks.add((0, s.components[b].children[next], edge.dst))\n             \
    \   tasks.add((0, s.components[b].children[at], edge.src))\n                at\
    \ = (next + direction + count) mod count\n            tasks.add((0, s.components[b].children[target],\
    \ v))\n            s.components[b].pivot = target\n            s.components[b].base\
    \ = v\n\n    proc augment[fast: static bool](s: var MatchingMachine[fast], x,\
    \ y: int) =\n        ## \u7570\u306A\u308B\u6839\u3092\u7D50\u3076\u4E8C\u672C\
    \u306E\u4EA4\u4E92\u8DEF\u3092\u8A18\u9332\u3057\u3001\u305D\u306E\u30DE\u30C3\
    \u30C1\u8FBA\u3092\u53CD\u8EE2\u3059\u308B\u3002\n        var bases: seq[tuple[component,\
    \ vertex: int]]\n        var selected = @[(x, y)]\n        for endpoint in [x,\
    \ y]:\n            var v = endpoint\n            while true:\n               \
    \ let b = s.top(v)\n                bases.add((b, v))\n                let incoming\
    \ = s.components[b].previous\n                if incoming.src == 0: break\n  \
    \              let inner = s.top(incoming.src)\n                let edge = s.components[inner].previous\n\
    \                bases.add((inner, edge.dst))\n                selected.add((edge.src,\
    \ edge.dst))\n                v = edge.src\n        for item in bases: s.expose(item.component,\
    \ item.vertex)\n        for edge in selected:\n            s.mate[edge[0]] = edge[1]\n\
    \            s.mate[edge[1]] = edge[0]\n\n    proc grow[fast: static bool](s:\
    \ var MatchingMachine[fast], x, y: int) =\n        ## \u672A\u5230\u9054\u306E\
    \u82B1\u3068\u3001\u305D\u306E\u30DE\u30C3\u30C1\u5148\u3092\u4EA4\u4E92\u6728\
    \u306B\u8FFD\u52A0\u3059\u308B\u3002\n        let b = s.top(y)\n        let z\
    \ = s.mate[s.components[b].base]\n        assert z != 0, \"\u672A\u30DE\u30C3\u30C1\
    \u306E\u82B1\u306F\u63A2\u7D22\u958B\u59CB\u6642\u306B\u6839\u3068\u3057\u3066\
    \u767B\u9332\u3055\u308C\u307E\u3059\"\n        s.components[b].previous = (x,\
    \ y)\n        s.label(b, mcOdd)\n        let next = s.top(z)\n        s.components[next].previous\
    \ = (s.components[b].base, z)\n        s.label(next, mcEven)\n\n    proc expand[fast:\
    \ static bool](s: var MatchingMachine[fast], b: int) =\n        ## \u5185\u5074\
    \u306E\u82B1\u3092\u5206\u5272\u3057\u3001\u5165\u53E3\u304B\u3089\u57FA\u70B9\
    \u307E\u3067\u306E\u5076\u6570\u9577\u306E\u4EA4\u4E92\u8DEF\u3092\u5FA9\u5143\
    \u3059\u308B\u3002\n        let entry = s.components[b].previous\n        let\
    \ first = s.childIndex(b, entry.dst)\n        let finish = s.components[b].pivot\n\
    \        let count = s.components[b].children.len\n        let distance = (finish\
    \ - first + count) mod count\n        let direction = if distance mod 2 == 0:\
    \ 1 else: -1\n        var colors = newSeq[MatchingColor](count)\n        var incoming\
    \ = newSeq[MatchingDirection](count)\n        for color in colors.mitems: color\
    \ = mcIdle\n        var at = first\n        colors[at] = mcOdd\n        incoming[at]\
    \ = entry\n        while at != finish:\n            let next = (at + direction\
    \ + count) mod count\n            colors[next] = if colors[at] == mcOdd: mcEven\
    \ else: mcOdd\n            incoming[next] = s.cycleEdge(b, at, direction)\n  \
    \          at = next\n        when fast:\n            var remaining = s.components[b].root\n\
    \            for child in s.components[b].children:\n                let parts\
    \ = s.split(remaining, s.components[child].count)\n                s.components[child].root\
    \ = parts.left\n                s.leaves[parts.left].owner = child\n         \
    \       remaining = parts.right\n        else:\n            for child in s.components[b].children:\n\
    \                s.components[child].best = MatchingInfinity\n               \
    \ s.components[child].bestVertex = 0\n                for v in s.components[child].members:\n\
    \                    s.owner[v] = child\n                    if s.leaves[v].edge\
    \ >= 0:\n                        let key = s.leaves[v].potential + s.leaves[v].offer\n\
    \                        if key < s.components[child].best:\n                \
    \            s.components[child].best = key\n                            s.components[child].bestVertex\
    \ = v\n        s.components[b].color = mcHidden\n        s.invalidate(b)\n   \
    \     for i, child in s.components[b].children:\n            s.components[child].parent\
    \ = 0\n            s.components[child].color = mcOdd\n            s.components[child].changed\
    \ = s.time\n            s.components[child].previous = incoming[i]\n         \
    \   s.label(child, colors[i])\n        s.components[b] = MatchingComponent(color:\
    \ mcHidden)\n        s.free.add(b)\n\n    proc nextEvent[fast: static bool](s:\
    \ var MatchingMachine[fast]): MatchingEvent =\n        ## \u6B21\u306E\u6709\u52B9\
    \u306A\u30A4\u30D9\u30F3\u30C8\u3092\u8FD4\u3059\u3002\u5BC6\u7248O(V)\u3001\u758E\
    \u7248\u306F\u4E00\u53D6\u308A\u51FA\u3057O(log V)\u3002\n        result = (MatchingInfinity,\
    \ -1, 0, 0, -1)\n        when fast:\n            if not s.heapReady:\n       \
    \         s.heap = toHeapQueue(s.pending)\n                s.pending.setLen(0)\n\
    \                s.heapReady = true\n            while s.heap.len > 0:\n     \
    \           let event = s.heap.pop()\n                if event.kind == 1:\n  \
    \                  let edge = s.arcs[event.edge]\n                    if s.top(edge.src)\
    \ != s.top(edge.dst): return event\n                else:\n                  \
    \  let b = event.component\n                    if not s.components[b].live or\
    \ s.components[b].parent != 0: continue\n                    if s.components[b].version\
    \ != event.version: continue\n                    let color = if event.kind ==\
    \ 0: mcIdle else: mcOdd\n                    if s.components[b].color == color:\
    \ return event\n        else:\n            for b in 1..<s.components.len:\n  \
    \              case s.components[b].color\n                of mcIdle:\n      \
    \              let candidate = s.bestOffer(b)\n                    if candidate.value\
    \ < result.time:\n                        result = (candidate.value, 0, b, 0,\
    \ s.leaves[candidate.vertex].edge)\n                of mcEven:\n             \
    \       if s.components[b].cross < result.time:\n                        result\
    \ = (s.components[b].cross, 1, b, 0, s.components[b].crossEdge)\n            \
    \    of mcOdd:\n                    if b > s.n:\n                        let time\
    \ = s.components[b].changed + s.components[b].dual div 2\n                   \
    \     if time < result.time: result = (time, 2, b, 0, -1)\n                of\
    \ mcHidden: discard\n\n    iterator outgoing[fast: static bool](s: MatchingMachine[fast],\
    \ u: int): int =\n        ## \u9802\u70B9\u304B\u3089\u51FA\u308B\u8FBA\u756A\u53F7\
    \u3092\u5217\u6319\u3059\u308B\u3002\u5BC6\u7248\u3067\u306F\u9023\u7D9A\u914D\
    \u7F6E\u3092\u5229\u7528\u3059\u308B\u3002\n        when fast:\n            for\
    \ id in s.adjacency[u]: yield id\n        else:\n            if s.adjacency[u].len\
    \ > 0:\n                let first = s.adjacency[u][0]\n                for id\
    \ in first..<first + s.adjacency[u].len: yield id\n\n    proc scan[fast: static\
    \ bool](s: var MatchingMachine[fast]): bool =\n        ## \u65B0\u3057\u304F\u5916\
    \u5074\u306B\u306A\u3063\u305F\u9802\u70B9\u3092\u8D70\u67FB\u3057\u3001\u6642\
    \u523B\u3092\u9032\u3081\u305A\u306B\u4F7F\u3048\u308B\u8FBA\u3092\u76F4\u3061\
    \u306B\u51E6\u7406\u3059\u308B\u3002\n        while s.queueHead < s.queue.len:\n\
    \            let u = s.queue[s.queueHead]\n            inc s.queueHead\n     \
    \       var source = s.top(u)\n            let p = s.potential(u)\n          \
    \  for id in s.outgoing(u):\n                let edge = s.arcs[id]\n         \
    \       let dest = s.top(edge.dst)\n                if source == dest: continue\n\
    \                if s.components[dest].color == mcEven:\n                    let\
    \ time = (p + s.potential(edge.dst) - 2 * edge.weight) div 2\n               \
    \     if time == s.time:\n                        let common = s.ancestor(source,\
    \ dest)\n                        if common == 0:\n                           \
    \ s.augment(u, edge.dst)\n                            return true\n          \
    \              s.contract(u, edge.dst, common)\n                        source\
    \ = s.top(u)\n                    else:\n                        when fast: s.schedule((time,\
    \ 1, 0, 0, id))\n                        else:\n                            if\
    \ time < s.components[source].cross:\n                                s.components[source].cross\
    \ = time\n                                s.components[source].crossEdge = id\n\
    \                            if time < s.components[dest].cross:\n           \
    \                     s.components[dest].cross = time\n                      \
    \          s.components[dest].crossEdge = id\n                else:\n        \
    \            s.offer(edge.dst, id, p - 2 * edge.weight)\n                    if\
    \ s.components[dest].color == mcIdle:\n                        if p + s.potential(edge.dst)\
    \ - 2 * edge.weight == s.time:\n                            s.grow(u, edge.dst)\n\
    \n    proc finishStage[fast: static bool](s: var MatchingMachine[fast]) =\n  \
    \      ## \u53CC\u5BFE\u5024\u3092\u73FE\u5728\u6642\u523B\u3067\u78BA\u5B9A\u3057\
    \u3001\u6B21\u306E\u63A2\u7D22\u306E\u6642\u523B\u539F\u70B9\u3078\u79FB\u3059\
    \u3002\n        for b in 1..<s.components.len:\n            if not s.components[b].live\
    \ or s.components[b].parent != 0: continue\n            s.touch(b)\n         \
    \   s.shift(b, slope(s.components[b].color) * s.time)\n            s.components[b].color\
    \ = mcIdle\n            s.components[b].changed = 0\n        s.time = 0\n\n  \
    \  proc stage[fast: static bool](s: var MatchingMachine[fast]): bool =\n     \
    \   ## \u5897\u52A0\u8DEF\u3092\u4E00\u3064\u6C42\u3081\u308B\u3002\u5BC6\u7248\
    O(V^2)\u3001\u758E\u7248O(E log V)\u3002\n        s.queue.setLen(0)\n        s.queueHead\
    \ = 0\n        s.heap.clear()\n        s.pending.setLen(0)\n        s.heapReady\
    \ = false\n        for v in 1..s.n:\n            s.leaves[v].edge = -1\n     \
    \       s.leaves[v].minimum = MatchingInfinity\n            s.leaves[v].arg =\
    \ 0\n        for b in 1..<s.components.len:\n            s.components[b].best\
    \ = MatchingInfinity\n            s.components[b].bestVertex = 0\n           \
    \ s.components[b].cross = MatchingInfinity\n            s.components[b].crossEdge\
    \ = -1\n            s.components[b].previous = (0, 0)\n        var deadline =\
    \ MatchingInfinity\n        for b in 1..<s.components.len:\n            if s.components[b].color\
    \ != mcIdle: continue\n            let v = s.components[b].base\n            if\
    \ s.mate[v] == 0:\n                deadline = min(deadline, s.potential(v))\n\
    \                s.label(b, mcEven)\n        if deadline == MatchingInfinity:\
    \ return false\n        while true:\n            if s.scan():\n              \
    \  s.finishStage()\n                return true\n            let event = s.nextEvent()\n\
    \            if event.time >= deadline:\n                s.time = deadline\n \
    \               s.finishStage()\n                return false\n            assert\
    \ event.time >= s.time, \"\u30A4\u30D9\u30F3\u30C8\u6642\u523B\u306F\u5F8C\u623B\
    \u308A\u3067\u304D\u307E\u305B\u3093\"\n            s.time = event.time\n    \
    \        case event.kind\n            of 0:\n                let edge = s.arcs[event.edge]\n\
    \                s.grow(edge.src, edge.dst)\n            of 1:\n             \
    \   let edge = s.arcs[event.edge]\n                let common = s.ancestor(s.top(edge.src),\
    \ s.top(edge.dst))\n                if common == 0:\n                    s.augment(edge.src,\
    \ edge.dst)\n                    s.finishStage()\n                    return true\n\
    \                s.contract(edge.src, edge.dst, common)\n            of 2: s.expand(event.component)\n\
    \            else: assert false, \"\u672A\u77E5\u306E\u30A4\u30D9\u30F3\u30C8\u3067\
    \u3059\"\n\n    proc independentWeightedMatching*[T: SomeSignedInt](g: WeightedUnDirectedGraph[T]\
    \ or WeightedUnDirectedStaticGraph[T], fast: static bool): tuple[weight: int64,\
    \ matching: seq[tuple[u, v: int]]] =\n        ## \u6574\u6570\u91CD\u307F\u306E\
    \u6700\u5927\u91CD\u307F\u30DE\u30C3\u30C1\u30F3\u30B0\u3092\u6C42\u3081\u308B\
    \u3002\u516C\u958B\u30E2\u30B8\u30E5\u30FC\u30EB\u4E8C\u7A2E\u985E\u304B\u3089\
    \u5229\u7528\u3059\u308B\u5171\u901A\u5B9F\u88C5\u3002\n        when g is StaticGraphTypes:\
    \ g.static_graph_initialized_check()\n        var indices = newSeq[int](g.len)\n\
    \        var vertices = @[-1]\n        var largest = 0'i64\n        for edge in\
    \ g.edge_info:\n            if edge.src == edge.dst or edge.cost <= 0: continue\n\
    \            largest = max(largest, int64(edge.cost))\n            for v in [edge.src,\
    \ edge.dst]:\n                if indices[v] == 0:\n                    indices[v]\
    \ = vertices.len\n                    vertices.add(v)\n        let n = vertices.len\
    \ - 1\n        if n == 0: return\n        assert largest <= high(int64) div 4\
    \ div int64(n), \"\u8FBA\u91CD\u307F\u304Cint64\u3067\u5B89\u5168\u306B\u8A08\u7B97\
    \u3067\u304D\u308B\u7BC4\u56F2\u3092\u8D85\u3048\u3066\u3044\u307E\u3059\"\n \
    \       let capacity = 2 * n + 1\n        var s = MatchingMachine[fast](n: n,\
    \ components: newSeq[MatchingComponent](capacity),\n            leaves: newSeq[MatchingLeaf](n\
    \ + 1), mate: newSeq[int](n + 1),\n            adjacency: newSeq[seq[int]](n +\
    \ 1), marked: newSeq[int](capacity))\n        when not fast:\n            s.owner\
    \ = newSeq[int](n + 1)\n            s.between = newSeq[seq[int]](capacity)\n \
    \           for row in s.between.mitems:\n                row = newSeq[int](capacity)\n\
    \                for x in row.mitems: x = -1\n        for b in countdown(capacity\
    \ - 1, n + 1): s.free.add(b)\n        for v in 1..n:\n            s.components[v]\
    \ = MatchingComponent(live: true, count: 1, first: v, base: v,\n             \
    \   root: v, color: mcIdle, best: MatchingInfinity, cross: MatchingInfinity, crossEdge:\
    \ -1)\n            s.leaves[v] = MatchingLeaf(height: 1, count: 1, owner: v, potential:\
    \ largest,\n                minimum: MatchingInfinity, edge: -1)\n           \
    \ when not fast:\n                s.components[v].members = @[v]\n           \
    \     s.owner[v] = v\n        when fast:\n            var raw = newSeq[seq[tuple[vertex:\
    \ int, weight: int64]]](n + 1)\n            for edge in g.edge_info:\n       \
    \         if edge.src == edge.dst or edge.cost <= 0: continue\n              \
    \  let u = indices[edge.src]\n                let v = indices[edge.dst]\n    \
    \            raw[u].add((v, int64(edge.cost)))\n                raw[v].add((u,\
    \ int64(edge.cost)))\n            var seen = newSeq[int](n + 1)\n            var\
    \ position = newSeq[int](n + 1)\n            for u in 1..n:\n                for\
    \ edge in raw[u]:\n                    let v = edge.vertex\n                 \
    \   if seen[v] != u:\n                        seen[v] = u\n                  \
    \      position[v] = s.arcs.len\n                        s.adjacency[u].add(s.arcs.len)\n\
    \                        s.arcs.add((u, v, edge.weight))\n                   \
    \ else:\n                        let id = position[v]\n                      \
    \  s.arcs[id].weight = max(s.arcs[id].weight, edge.weight)\n            raw =\
    \ @[]\n        else:\n            for edge in g.edge_info:\n                if\
    \ edge.src == edge.dst or edge.cost <= 0: continue\n                let a = indices[edge.src]\n\
    \                let b = indices[edge.dst]\n                for endpoints in [(a,\
    \ b), (b, a)]:\n                    let (u, v) = endpoints\n                 \
    \   let id = s.between[u][v]\n                    if id < 0:\n               \
    \         s.between[u][v] = s.arcs.len\n                        s.adjacency[u].add(s.arcs.len)\n\
    \                        s.arcs.add((u, v, int64(edge.cost)))\n              \
    \      else:\n                        s.arcs[id].weight = max(s.arcs[id].weight,\
    \ int64(edge.cost))\n        when not fast:\n            # \u540C\u3058\u9802\u70B9\
    \u304B\u3089\u51FA\u308B\u8FBA\u3092\u884C\u5148\u9806\u306B\u9023\u7D9A\u914D\
    \u7F6E\u3057\u3001\u8D70\u67FB\u6642\u306E\u5C40\u6240\u6027\u3092\u9AD8\u3081\
    \u308B\u3002\n            var ordered = newSeqOfCap[MatchingEdge](s.arcs.len)\n\
    \            for u in 1..n:\n                s.adjacency[u].setLen(0)\n      \
    \          for v in 1..n:\n                    let id = s.between[u][v]\n    \
    \                if id < 0: continue\n                    s.between[u][v] = ordered.len\n\
    \                    s.adjacency[u].add(ordered.len)\n                    ordered.add(s.arcs[id])\n\
    \            s.arcs = move(ordered)\n        # \u6700\u5927\u91CD\u307F\u306E\u8FBA\
    \u3060\u3051\u3067\u4F5C\u308B\u521D\u671F\u30DE\u30C3\u30C1\u30F3\u30B0\u306F\
    \u3001\u305D\u306E\u8FBA\u6570\u306B\u5BFE\u3057\u3066\u65E2\u306B\u6700\u9069\
    \u3002\n        for edge in s.arcs:\n            if edge.weight == largest and\
    \ s.mate[edge.src] == 0 and s.mate[edge.dst] == 0:\n                s.mate[edge.src]\
    \ = edge.dst\n                s.mate[edge.dst] = edge.src\n        while s.stage():\
    \ discard\n        for u in 1..n:\n            let v = s.mate[u]\n           \
    \ if u >= v: continue\n            for id in s.adjacency[u]:\n               \
    \ if s.arcs[id].dst == v:\n                    result.weight += s.arcs[id].weight\n\
    \                    break\n            result.matching.add((min(vertices[u],\
    \ vertices[v]), max(vertices[u], vertices[v])))\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/internal/weighted_matching_engine.nim
  requiredBy:
  - cplib/graph/general_weighted_matching.nim
  - cplib/graph/general_weighted_matching.nim
  - cplib/graph/general_weighted_matching_sparse.nim
  - cplib/graph/general_weighted_matching_sparse.nim
  timestamp: '2026-09-29 03:00:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/general_weighted_matching_sparse_test.nim
  - verify/graph/general_weighted_matching_sparse_test.nim
  - verify/graph/general_weighted_matching_test.nim
  - verify/graph/general_weighted_matching_test.nim
  - verify/AI/general_weighted_matching_sparse_test.nim
  - verify/AI/general_weighted_matching_sparse_test.nim
  - verify/AI/general_weighted_matching_test.nim
  - verify/AI/general_weighted_matching_test.nim
  - verify/AI/weighted_matching_structure_test.nim
  - verify/AI/weighted_matching_structure_test.nim
documentation_of: cplib/graph/internal/weighted_matching_engine.nim
layout: document
redirect_from:
- /library/cplib/graph/internal/weighted_matching_engine.nim
- /library/cplib/graph/internal/weighted_matching_engine.nim.html
title: cplib/graph/internal/weighted_matching_engine.nim
---
