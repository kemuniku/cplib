---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/push_relabel_test.nim
    title: verify/AI/push_relabel_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/push_relabel_test.nim
    title: verify/AI/push_relabel_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/push_relabel_bipartitematching_test.nim
    title: verify/graph/push_relabel_bipartitematching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/push_relabel_bipartitematching_test.nim
    title: verify/graph/push_relabel_bipartitematching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/push_relabel_test.nim
    title: verify/graph/push_relabel_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/push_relabel_test.nim
    title: verify/graph/push_relabel_test.nim
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
  code: "when not declared CPLIB_GRAPH_PUSH_RELABEL:\n    const CPLIB_GRAPH_PUSH_RELABEL*\
    \ = 1\n\n    type\n        PushRelabelEdge*[Cap] = object\n            src*, dst*:\
    \ int\n            cap*, flow*: Cap\n        PushRelabelArc[Cap] = object\n  \
    \          dst, rev: int\n            cap: Cap\n        PushRelabel*[Cap] = object\n\
    \            graph: seq[seq[PushRelabelArc[Cap]]]\n            positions: seq[tuple[src,\
    \ index: int]]\n\n    proc initPushRelabel*[Cap: SomeInteger](n: int, capacityZero:\
    \ Cap = 0): PushRelabel[Cap] =\n        ## n\u9802\u70B9\u306E\u6700\u5927\u6D41\
    \u30B0\u30E9\u30D5\u3092\u69CB\u7BC9\u3059\u308B\u3002\u5BB9\u91CF\u578B\u306E\
    \u7701\u7565\u6642\u306Fint\u3002capacityZero\u306F\u578B\u63A8\u8AD6\u7528\u3002\
    O(n)\u3002\n        assert n >= 0\n        result.graph = newSeq[seq[PushRelabelArc[Cap]]](n)\n\
    \n    proc add_edge*[Cap](g: var PushRelabel[Cap], src, dst: int, cap: Cap): int\
    \ {.discardable.} =\n        ## \u5BB9\u91CFcap\u306E\u6709\u5411\u8FBA\u3092\u8FFD\
    \u52A0\u3057\u3001\u8FBA\u756A\u53F7\u3092\u8FD4\u3059\u3002\u81EA\u5DF1\u30EB\
    \u30FC\u30D7\u30FB\u591A\u91CD\u8FBA\u3082\u53EF\u3002\u511F\u5374O(1)\u3002\n\
    \        assert src in 0..<g.graph.len and dst in 0..<g.graph.len\n        assert\
    \ cap >= Cap(0)\n        result = g.positions.len\n        let index = g.graph[src].len\n\
    \        let rev = g.graph[dst].len + ord(src == dst)\n        g.positions.add((src,\
    \ index))\n        g.graph[src].add(PushRelabelArc[Cap](dst: dst, rev: rev, cap:\
    \ cap))\n        g.graph[dst].add(PushRelabelArc[Cap](dst: src, rev: index, cap:\
    \ Cap(0)))\n\n    proc get_edge*[Cap](g: PushRelabel[Cap], i: int): PushRelabelEdge[Cap]\
    \ =\n        ## i\u756A\u76EE\u306E\u8FBA\u306E\u5BB9\u91CF\u3068\u73FE\u5728\u306E\
    \u6D41\u91CF\u3092\u8FD4\u3059\u3002O(1)\u3002\n        let (src, index) = g.positions[i]\n\
    \        let e = g.graph[src][index]\n        let flow = g.graph[e.dst][e.rev].cap\n\
    \        PushRelabelEdge[Cap](src: src, dst: e.dst, cap: e.cap + flow, flow: flow)\n\
    \n    proc get_edges*[Cap](g: PushRelabel[Cap]): seq[PushRelabelEdge[Cap]] =\n\
    \        ## \u8FFD\u52A0\u9806\u306B\u5168\u8FBA\u306E\u60C5\u5831\u3092\u8FD4\
    \u3059\u3002O(E)\u3002\n        result = newSeqOfCap[PushRelabelEdge[Cap]](g.positions.len)\n\
    \        for i in 0..<g.positions.len:\n            result.add(g.get_edge(i))\n\
    \n    proc flow*[Cap](g: var PushRelabel[Cap], src, dst: int, limit: Cap = high(Cap)):\
    \ Cap =\n        ## Highest-label Push\u2013Relabel\u6CD5\u3067limit\u4EE5\u4E0B\
    \u306E\u8FFD\u52A0\u6D41\u91CF\u3092\u8FD4\u3059\u3002\u518D\u5B9F\u884C\u53EF\
    \u3002\u5358\u7D14\u30B0\u30E9\u30D5\u3067O(V^2\u221AE)\u3001\u8FFD\u52A0\u9818\
    \u57DFO(V)\u3002\n        ## \u591A\u91CD\u8FBA\u3092\u542B\u3080\u4E00\u822C\u306E\
    \u5834\u5408\u306FO(VE+V^2\u221AE)\u3002\u8FBA\u304C\u306A\u3044\u5834\u5408\u306F\
    O(V)\u3002\n        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and\
    \ src != dst\n        assert limit >= Cap(0)\n        if limit == Cap(0):\n  \
    \          return Cap(0)\n\n        # \u4EEE\u60F3\u59CB\u70B9\u304B\u3089limit\u3060\
    \u3051\u4F9B\u7D66\u3057\u3001\u6D41\u91CF\u5236\u9650\u3068\u4F59\u5270\u6D41\
    \u306E\u5BB9\u91CF\u578B\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3092\u9632\
    \u3050\u3002\n        let source = g.graph.len\n        let sourceIndex = g.graph[src].len\n\
    \        g.graph.add(@[PushRelabelArc[Cap](dst: src, rev: sourceIndex, cap: Cap(0))])\n\
    \        g.graph[src].add(PushRelabelArc[Cap](dst: source, rev: 0, cap: limit))\n\
    \        defer:\n            g.graph[src].setLen(sourceIndex)\n            g.graph.setLen(source)\n\
    \n        let n = g.graph.len\n        let unreachable = 2 * n\n        var height\
    \ = newSeq[int](n)\n        var count = newSeq[int](unreachable + 1)\n       \
    \ var iter = newSeq[int](n)\n        var excess = newSeq[Cap](n)\n        var\
    \ bucket = newSeq[int](unreachable + 1)\n        var next = newSeq[int](n)\n \
    \       var prev = newSeq[int](n)\n        var active = newSeq[bool](n)\n    \
    \    var heightHead = newSeq[int](n)\n        var heightNext = newSeq[int](n)\n\
    \        var heightPrev = newSeq[int](n)\n        var queue = newSeq[int](n)\n\
    \        var highest = -1\n        var highestLow = -1\n        var highestFinite\
    \ = -1\n        var relabelWork = 0\n        let relabelWorkLimit = 4 * n + 2\
    \ * g.positions.len + 2\n        excess[src] = limit\n\n        template activate(vertex:\
    \ int) =\n            ## \u6B63\u306E\u4F59\u5270\u6D41\u3092\u6301\u3064\u9802\
    \u70B9\u3092\u9AD8\u3055\u5225\u306E\u30EA\u30B9\u30C8\u3078\u8FFD\u52A0\u3059\
    \u308B\u3002O(1)\u3002\n            block:\n                let v = vertex\n \
    \               if v != source and v != dst:\n                    let h = height[v]\n\
    \                    next[v] = bucket[h]\n                    prev[v] = -1\n \
    \                   if next[v] >= 0:\n                        prev[next[v]] =\
    \ v\n                    bucket[h] = v\n                    active[v] = true\n\
    \                    highest = max(highest, h)\n                    if h < n:\n\
    \                        highestLow = max(highestLow, h)\n\n        template removeActive(vertex:\
    \ int) =\n            ## \u6D3B\u6027\u9802\u70B9\u3092\u9AD8\u3055\u5225\u306E\
    \u30EA\u30B9\u30C8\u304B\u3089\u53D6\u308A\u9664\u304F\u3002O(1)\u3002\n     \
    \       block:\n                let v = vertex\n                if prev[v] < 0:\n\
    \                    bucket[height[v]] = next[v]\n                else:\n    \
    \                next[prev[v]] = next[v]\n                if next[v] >= 0:\n \
    \                   prev[next[v]] = prev[v]\n                active[v] = false\n\
    \n        template addHeight(vertex: int) =\n            ## \u7D42\u70B9\u3078\
    \u9001\u308B\u9AD8\u3055\u5E2F\u306E\u9802\u70B9\u3092\u9AD8\u3055\u5225\u306E\
    \u30EA\u30B9\u30C8\u3078\u8FFD\u52A0\u3059\u308B\u3002O(1)\u3002\n           \
    \ block:\n                let v = vertex\n                let h = height[v]\n\
    \                if h < n:\n                    heightNext[v] = heightHead[h]\n\
    \                    heightPrev[v] = -1\n                    if heightNext[v]\
    \ >= 0:\n                        heightPrev[heightNext[v]] = v\n             \
    \       heightHead[h] = v\n                    highestFinite = max(highestFinite,\
    \ h)\n\n        template removeHeight(vertex: int) =\n            ## \u7D42\u70B9\
    \u3078\u9001\u308B\u9AD8\u3055\u5E2F\u306E\u9802\u70B9\u3092\u9AD8\u3055\u5225\
    \u306E\u30EA\u30B9\u30C8\u304B\u3089\u53D6\u308A\u9664\u304F\u3002O(1)\u3002\n\
    \            block:\n                let v = vertex\n                if height[v]\
    \ < n:\n                    if heightPrev[v] < 0:\n                        heightHead[height[v]]\
    \ = heightNext[v]\n                    else:\n                        heightNext[heightPrev[v]]\
    \ = heightNext[v]\n                    if heightNext[v] >= 0:\n              \
    \          heightPrev[heightNext[v]] = heightPrev[v]\n\n        template rebuildActive()\
    \ =\n            ## \u9AD8\u3055\u306E\u4E00\u62EC\u5909\u66F4\u5F8C\u306B\u6D3B\
    \u6027\u9802\u70B9\u306E\u30EA\u30B9\u30C8\u3092\u518D\u69CB\u7BC9\u3059\u308B\
    \u3002O(V)\u3002\n            for h in 0..unreachable:\n                bucket[h]\
    \ = -1\n            highest = -1\n            highestLow = -1\n            for\
    \ v in 0..<n:\n                active[v] = false\n                if excess[v]\
    \ > Cap(0):\n                    activate(v)\n\n        template globalRelabel()\
    \ =\n            ## \u7D42\u70B9\u3078\u306E\u8DDD\u96E2\u3068\u3001\u7D42\u70B9\
    \u3078\u5C4A\u304B\u306A\u3044\u9802\u70B9\u306E\u4EEE\u60F3\u59CB\u70B9\u3078\
    \u306E\u8DDD\u96E2\u3092\u9006\u5411\u304DBFS\u3067\u6C42\u3081\u308B\u3002O(V+E)\u3002\
    \n            for v in 0..<n:\n                height[v] = unreachable\n     \
    \           iter[v] = 0\n            height[dst] = 0\n            height[source]\
    \ = n\n            for root in [dst, source]:\n                var head = 0\n\
    \                var tail = 1\n                queue[0] = root\n             \
    \   while head < tail:\n                    let v = queue[head]\n            \
    \        inc head\n                    for e in g.graph[v]:\n                \
    \        if height[e.dst] == unreachable and g.graph[e.dst][e.rev].cap > Cap(0):\n\
    \                            height[e.dst] = height[v] + 1\n                 \
    \           queue[tail] = e.dst\n                            inc tail\n      \
    \      for h in 0..unreachable:\n                count[h] = 0\n            for\
    \ h in 0..<n:\n                heightHead[h] = -1\n            highestFinite =\
    \ -1\n            for v in 0..<n:\n                inc count[height[v]]\n    \
    \            addHeight(v)\n            rebuildActive()\n            relabelWork\
    \ = 0\n\n        globalRelabel()\n        while highest >= 0:\n            if\
    \ bucket[highest] < 0:\n                # \u59CB\u70B9\u3078\u623B\u3059\u9AD8\
    \u3055\u5E2F\u304B\u3089\u3001\u7D42\u70B9\u3078\u9001\u308B\u9AD8\u3055\u5E2F\
    \u307E\u3067\u306E\u7A7A\u533A\u9593\u3092\u98DB\u3070\u3059\u3002\n         \
    \       if highest == n:\n                    highest = highestLow\n         \
    \       else:\n                    dec highest\n                    if highest\
    \ < n:\n                        highestLow = highest\n                continue\n\
    \            let v = bucket[highest]\n            removeActive(v)\n          \
    \  while excess[v] > Cap(0):\n                if iter[v] == g.graph[v].len:\n\
    \                    let old = height[v]\n                    var best = unreachable\n\
    \                    var bestIndex = 0\n                    for i, e in g.graph[v]:\n\
    \                        if e.cap > Cap(0) and height[e.dst] < best:\n       \
    \                     best = height[e.dst]\n                            bestIndex\
    \ = i\n                    # \u9AD8\u3055\u5F15\u304D\u4E0A\u3052\u6642\u306E\u8D70\
    \u67FB\u3060\u3051\u3092\u6570\u3048\u3001\u4E00\u62EC\u66F4\u65B0\u3068\u305D\
    \u308C\u306B\u4F34\u3046\u518D\u8D70\u67FB\u306E\u7DCF\u8CBB\u7528\u3092O(VE)\u306B\
    \u6291\u3048\u308B\u3002\n                    relabelWork += g.graph[v].len\n\
    \                    removeHeight(v)\n                    dec count[old]\n   \
    \                 height[v] = best + 1\n                    inc count[height[v]]\n\
    \                    addHeight(v)\n                    iter[v] = bestIndex\n \
    \                   if old < n and count[old] == 0:\n                        #\
    \ \u5168\u9802\u70B9\u3092\u8D70\u67FB\u305B\u305A\u3001\u7A7A\u306B\u306A\u3063\
    \u305F\u9AD8\u3055\u3088\u308A\u4E0A\u306E\u9802\u70B9\u3060\u3051\u3092\u79FB\
    \u3059\u3002\n                        for h in old + 1..highestFinite:\n     \
    \                       while heightHead[h] >= 0:\n                          \
    \      let u = heightHead[h]\n                                removeHeight(u)\n\
    \                                let wasActive = active[u]\n                 \
    \               if wasActive:\n                                    removeActive(u)\n\
    \                                dec count[h]\n                              \
    \  height[u] = n + 1\n                                inc count[height[u]]\n \
    \                               iter[u] = 0\n                                if\
    \ wasActive:\n                                    activate(u)\n              \
    \          highestFinite = old\n                        activate(v)\n        \
    \                break\n                else:\n                    let i = iter[v]\n\
    \                    let e = g.graph[v][i]\n                    if e.cap > Cap(0)\
    \ and height[v] == height[e.dst] + 1:\n                        let amount = min(excess[v],\
    \ e.cap)\n                        if excess[e.dst] == Cap(0):\n              \
    \              activate(e.dst)\n                        g.graph[v][i].cap -= amount\n\
    \                        g.graph[e.dst][e.rev].cap += amount\n               \
    \         excess[v] -= amount\n                        excess[e.dst] += amount\n\
    \                    else:\n                        inc iter[v]\n            if\
    \ relabelWork >= relabelWorkLimit:\n                globalRelabel()\n        return\
    \ excess[dst]\n\n    proc min_cut*[Cap](g: PushRelabel[Cap], src: int): seq[bool]\
    \ =\n        ## \u6B8B\u4F59\u30B0\u30E9\u30D5\u3067src\u304B\u3089\u5230\u9054\
    \u53EF\u80FD\u306A\u9802\u70B9\u3092\u8FD4\u3059\u3002\u6700\u5927\u6D41\u8A08\
    \u7B97\u5F8C\u306F\u6700\u5C0F\u30AB\u30C3\u30C8\u3002O(V+E)\u3002\n        assert\
    \ src in 0..<g.graph.len\n        result = newSeq[bool](g.graph.len)\n       \
    \ result[src] = true\n        var queue = @[src]\n        var head = 0\n     \
    \   while head < queue.len:\n            let v = queue[head]\n            inc\
    \ head\n            for e in g.graph[v]:\n                if e.cap > Cap(0) and\
    \ not result[e.dst]:\n                    result[e.dst] = true\n             \
    \       queue.add(e.dst)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/push_relabel.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/push_relabel_test.nim
  - verify/graph/push_relabel_test.nim
  - verify/graph/push_relabel_bipartitematching_test.nim
  - verify/graph/push_relabel_bipartitematching_test.nim
  - verify/AI/push_relabel_test.nim
  - verify/AI/push_relabel_test.nim
documentation_of: cplib/graph/push_relabel.nim
layout: document
redirect_from:
- /library/cplib/graph/push_relabel.nim
- /library/cplib/graph/push_relabel.nim.html
title: cplib/graph/push_relabel.nim
---
