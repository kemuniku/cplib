---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/hopcroft_karp_test.nim
    title: verify/AI/hopcroft_karp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/hopcroft_karp_test.nim
    title: verify/AI/hopcroft_karp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/hopcroft_karp_test.nim
    title: verify/graph/hopcroft_karp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/hopcroft_karp_test.nim
    title: verify/graph/hopcroft_karp_test.nim
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
  code: "when not declared CPLIB_GRAPH_HOPCROFT_KARP:\n    const CPLIB_GRAPH_HOPCROFT_KARP*\
    \ = 1\n\n    type HopcroftKarp* = object\n        edges: seq[tuple[left, right:\
    \ int]]\n        leftOffset, rightOffset, leftEdges, rightEdges: seq[int]\n  \
    \      leftMatch, rightMatch: seq[int]\n        size: int\n        built: bool\n\
    \n    proc initHopcroftKarp*(left, right: int): HopcroftKarp =\n        ## \u5DE6\
    \u5074left\u9802\u70B9\u3001\u53F3\u5074right\u9802\u70B9\u306E\u4E8C\u90E8\u30B0\
    \u30E9\u30D5\u3092\u69CB\u7BC9\u3059\u308B\u3002O(left+right)\u3002\n        assert\
    \ left >= 0 and right >= 0\n        result.leftMatch = newSeq[int](left)\n   \
    \     result.rightMatch = newSeq[int](right)\n        for i in 0..<left:\n   \
    \         result.leftMatch[i] = -1\n        for i in 0..<right:\n            result.rightMatch[i]\
    \ = -1\n\n    proc add_edge*(g: var HopcroftKarp, left, right: int) =\n      \
    \  ## \u5DE6\u53F3\u305D\u308C\u305E\u308C0\u59CB\u307E\u308A\u306E\u9802\u70B9\
    \u9593\u306B\u8FBA\u3092\u8FFD\u52A0\u3059\u308B\u3002\u591A\u91CD\u8FBA\u3082\
    \u53EF\u3002\u511F\u5374O(1)\u3002\n        assert left in 0..<g.leftMatch.len\
    \ and right in 0..<g.rightMatch.len\n        g.edges.add((left, right))\n    \
    \    g.built = false\n\n    proc build(g: var HopcroftKarp) =\n        ## \u5DE6\
    \u53F3\u4E21\u65B9\u5411\u306E\u96A3\u63A5\u8FBA\u3092CSR\u5F62\u5F0F\u306B\u307E\
    \u3068\u3081\u308B\u3002\u8FBA\u8FFD\u52A0\u5F8C\u306E\u521D\u56DE\u306E\u307F\
    O(V+E)\u3002\n        if g.built:\n            return\n        let left = g.leftMatch.len\n\
    \        let right = g.rightMatch.len\n        let m = g.edges.len\n        g.leftOffset\
    \ = newSeq[int](left + 1)\n        g.rightOffset = newSeq[int](right + 1)\n  \
    \      for (v, u) in g.edges:\n            inc g.leftOffset[v]\n            inc\
    \ g.rightOffset[u]\n        for v in 1..<left:\n            g.leftOffset[v] +=\
    \ g.leftOffset[v - 1]\n        for u in 1..<right:\n            g.rightOffset[u]\
    \ += g.rightOffset[u - 1]\n        g.leftOffset[left] = m\n        g.rightOffset[right]\
    \ = m\n        g.leftEdges = newSeq[int](m)\n        g.rightEdges = newSeq[int](m)\n\
    \        for (v, u) in g.edges:\n            dec g.leftOffset[v]\n           \
    \ dec g.rightOffset[u]\n            g.leftEdges[g.leftOffset[v]] = u\n       \
    \     g.rightEdges[g.rightOffset[u]] = v\n        g.built = true\n\n    proc matching*(g:\
    \ var HopcroftKarp, useRelabel: bool = true): int {.discardable.} =\n        ##\
    \ \u6700\u5927\u30DE\u30C3\u30C1\u30F3\u30B0\u306E\u7DCF\u30B5\u30A4\u30BA\u3092\
    \u8FD4\u3059\u3002\u65E2\u5B9A\u3067\u306FGlobal relabel\u524D\u51E6\u7406\u4ED8\
    \u304D\u3002\u518D\u5B9F\u884C\u53EF\u3002O((V+E)\u221AV)\u3001\u9818\u57DFO(V+E)\u3002\
    \n        let n = g.leftMatch.len\n        let right = g.rightMatch.len\n    \
    \    let limit = min(n, right)\n        if g.size == limit:\n            return\
    \ g.size\n        g.build()\n        var dist = newSeq[int](n)\n        var queue\
    \ = newSeq[int](n)\n        if useRelabel:\n            var active = newSeq[int](right)\n\
    \            var head = 0\n            var tail = 0\n            var count = 0\n\
    \            for u in 0..<right:\n                if g.rightMatch[u] < 0 and g.rightOffset[u]\
    \ < g.rightOffset[u + 1]:\n                    active[tail] = u\n            \
    \        inc tail\n                    inc count\n            if tail == right:\n\
    \                tail = 0\n            let period = n + right\n            let\
    \ workLimit = 16 * (n + right + g.edges.len)\n            var work = 0\n     \
    \       var steps = 0\n            while count > 0 and g.size < limit and work\
    \ < workLimit:\n                if steps == 0:\n                    # \u672A\u30DE\
    \u30C3\u30C1\u306E\u5DE6\u9802\u70B9\u304B\u3089\u4EA4\u4E92\u9053\u306E\u8DDD\
    \u96E2\u3092\u8A08\u7B97\u3059\u308B\u3002\u30DE\u30C3\u30C1\u3057\u305F\u8FBA\
    \u306E\u7D44\u30921\u6BB5\u3068\u6570\u3048\u308B\u3002\n                    var\
    \ first = 0\n                    var last = 0\n                    for v in 0..<n:\n\
    \                        if g.leftMatch[v] < 0:\n                            dist[v]\
    \ = 0\n                            queue[last] = v\n                         \
    \   inc last\n                        else:\n                            dist[v]\
    \ = n\n                    work += n\n                    while first < last:\n\
    \                        let v = queue[first]\n                        inc first\n\
    \                        for i in g.leftOffset[v]..<g.leftOffset[v + 1]:\n   \
    \                         let w = g.rightMatch[g.leftEdges[i]]\n             \
    \               if w >= 0 and dist[w] == n:\n                                dist[w]\
    \ = dist[v] + 1\n                                queue[last] = w\n           \
    \                     inc last\n                        work += g.leftOffset[v\
    \ + 1] - g.leftOffset[v]\n                    steps = period\n               \
    \     if work >= workLimit:\n                        break\n                let\
    \ u = active[head]\n                inc head\n                if head == right:\n\
    \                    head = 0\n                dec count\n                dec\
    \ steps\n                var best = -1\n                var bestHeight = n\n \
    \               for i in g.rightOffset[u]..<g.rightOffset[u + 1]:\n          \
    \          inc work\n                    let v = g.rightEdges[i]\n           \
    \         if dist[v] < bestHeight:\n                        best = v\n       \
    \                 bestHeight = dist[v]\n                        if bestHeight\
    \ == 0:\n                            break\n                if best < 0:\n   \
    \                 continue\n                let previous = g.leftMatch[best]\n\
    \                if previous < 0:\n                    inc g.size\n          \
    \      else:\n                    g.rightMatch[previous] = -1\n              \
    \      active[tail] = previous\n                    inc tail\n               \
    \     if tail == right:\n                        tail = 0\n                  \
    \  inc count\n                g.leftMatch[best] = u\n                g.rightMatch[u]\
    \ = best\n                dist[best] = bestHeight + 1\n            if g.size ==\
    \ limit:\n                return g.size\n        else:\n            for v in 0..<n:\n\
    \                if g.leftMatch[v] < 0:\n                    for i in g.leftOffset[v]..<g.leftOffset[v\
    \ + 1]:\n                        let u = g.leftEdges[i]\n                    \
    \    if g.rightMatch[u] < 0:\n                            g.leftMatch[v] = u\n\
    \                            g.rightMatch[u] = v\n                           \
    \ inc g.size\n                            break\n\n        # \u524D\u51E6\u7406\
    \u304C\u8D70\u67FB\u91CF\u306E\u4E0A\u9650\u306B\u9054\u3057\u305F\u5834\u5408\
    \u3082\u3001\u6700\u77ED\u5897\u52A0\u8DEF\u3092\u51E6\u7406\u3059\u308BHK\u6CD5\
    \u3067\u5B8C\u4E86\u3055\u305B\u308B\u3002\n        var iter = newSeq[int](n)\n\
    \        var freeLeft = newSeqOfCap[int](n - g.size)\n        for v in 0..<n:\n\
    \            if g.leftMatch[v] < 0 and g.leftOffset[v] < g.leftOffset[v + 1]:\n\
    \                freeLeft.add(v)\n        while g.size < limit:\n            var\
    \ head = 0\n            var tail = 0\n            for v in 0..<n:\n          \
    \      iter[v] = g.leftOffset[v]\n                dist[v] = -1\n            for\
    \ v in freeLeft:\n                dist[v] = 0\n                queue[tail] = v\n\
    \                inc tail\n            var shortest = n\n            while head\
    \ < tail:\n                let v = queue[head]\n                inc head\n   \
    \             if dist[v] >= shortest:\n                    break\n           \
    \     for i in g.leftOffset[v]..<g.leftOffset[v + 1]:\n                    let\
    \ u = g.leftEdges[i]\n                    let w = g.rightMatch[u]\n          \
    \          if w < 0:\n                        shortest = dist[v]\n           \
    \         elif dist[w] < 0 and dist[v] < shortest:\n                        dist[w]\
    \ = dist[v] + 1\n                        queue[tail] = w\n                   \
    \     inc tail\n            if shortest == n:\n                break\n\n     \
    \       # BFS\u306E\u30AD\u30E5\u30FC\u3092DFS\u306E\u7D4C\u8DEF\u30B9\u30BF\u30C3\
    \u30AF\u3068\u3057\u3066\u518D\u5229\u7528\u3059\u308B\u3002\n            for\
    \ root in freeLeft:\n                if g.leftMatch[root] >= 0 or dist[root] !=\
    \ 0:\n                    continue\n                var depth = 0\n          \
    \      queue[0] = root\n                while depth >= 0:\n                  \
    \  let v = queue[depth]\n                    var descended = false\n         \
    \           var endpoint = -1\n                    while iter[v] < g.leftOffset[v\
    \ + 1]:\n                        let u = g.leftEdges[iter[v]]\n              \
    \          inc iter[v]\n                        let w = g.rightMatch[u]\n    \
    \                    if w < 0:\n                            if dist[v] == shortest:\n\
    \                                endpoint = u\n                              \
    \  break\n                        elif dist[v] < shortest and dist[w] == dist[v]\
    \ + 1:\n                            inc depth\n                            queue[depth]\
    \ = w\n                            descended = true\n                        \
    \    break\n                    if endpoint >= 0:\n                        while\
    \ depth >= 0:\n                            let x = queue[depth]\n            \
    \                let previous = g.leftMatch[x]\n                            g.leftMatch[x]\
    \ = endpoint\n                            g.rightMatch[endpoint] = x\n       \
    \                     endpoint = previous\n                            dist[x]\
    \ = -1\n                            dec depth\n                        inc g.size\n\
    \                        break\n                    if not descended:\n      \
    \                  dist[v] = -1\n                        dec depth\n         \
    \   var remaining = 0\n            for v in freeLeft:\n                if g.leftMatch[v]\
    \ < 0:\n                    freeLeft[remaining] = v\n                    inc remaining\n\
    \            freeLeft.setLen(remaining)\n        return g.size\n\n    proc get_matching*(g:\
    \ HopcroftKarp): seq[tuple[left, right: int]] =\n        ## \u73FE\u5728\u306E\
    \u30DE\u30C3\u30C1\u30F3\u30B0\u306E\u8FBA\u3092\u5DE6\u9802\u70B9\u9806\u3067\
    \u8FD4\u3059\u3002\u6700\u5927\u5316\u306B\u306F\u5148\u306Bmatching\u3092\u547C\
    \u3076\u3002O(left)\u3002\n        result = newSeqOfCap[tuple[left, right: int]](g.size)\n\
    \        for left, right in g.leftMatch:\n            if right >= 0:\n       \
    \         result.add((left, right))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/hopcroft_karp.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/hopcroft_karp_test.nim
  - verify/graph/hopcroft_karp_test.nim
  - verify/AI/hopcroft_karp_test.nim
  - verify/AI/hopcroft_karp_test.nim
documentation_of: cplib/graph/hopcroft_karp.nim
layout: document
redirect_from:
- /library/cplib/graph/hopcroft_karp.nim
- /library/cplib/graph/hopcroft_karp.nim.html
title: cplib/graph/hopcroft_karp.nim
---
