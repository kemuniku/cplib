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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_matching_test.nim
    title: verify/AI/general_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_matching_test.nim
    title: verify/AI/general_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_matching_tree_union_test.nim
    title: verify/AI/general_matching_tree_union_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_matching_tree_union_test.nim
    title: verify/AI/general_matching_tree_union_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_matching_test.nim
    title: verify/graph/general_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_matching_test.nim
    title: verify/graph/general_matching_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://arxiv.org/abs/1703.03998
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "## \u4E00\u822C\u7121\u5411\u30B0\u30E9\u30D5\u306E\u6700\u5927\u30DE\u30C3\
    \u30C1\u30F3\u30B0\uFF08Gabow\u6CD5\uFF09\u3002\n##\n## \u6700\u77ED\u5897\u52A0\
    \u8DEF\u306E\u9577\u3055\u3092\u53CC\u5BFE\u5909\u6570\u3068\u6642\u523B\u30D0\
    \u30B1\u30C3\u30C8\u3067\u6C42\u3081\u3001\u305D\u306E\u9577\u3055\u306E\n## \u9802\
    \u70B9\u7D20\u306A\u5897\u52A0\u8DEF\u3092\u6975\u5927\u306B\u306A\u308B\u307E\
    \u3067\u307E\u3068\u3081\u3066\u53CD\u8EE2\u3059\u308B\u3002\n## \u5404\u6BB5\u968E\
    \u306FO(V+E)\u3001\u6BB5\u968E\u6570\u306FO(sqrt V)\u3002\u5B64\u7ACB\u70B9\u306F\
    \u63A2\u7D22\u524D\u306B\u9664\u304F\u3002\n## \u53C2\u8003: https://arxiv.org/abs/1703.03998\n\
    ##\n## \u82B1\u306E\u7E2E\u7D04\u306B\u306F\u3001\u8449\u3092\u8FFD\u52A0\u3067\
    \u304D\u308B\u6728\u4E0A\u306E\u96C6\u5408\u4F75\u5408\u3092\u4F7F\u3046\u3002\
    \n## b=Theta(log V)\u9802\u70B9\u4EE5\u4E0B\u306E\u5C0F\u6728\u3092\u4FDD\u6301\
    \u3057\u3001\u7956\u5148\u3068\u672A\u4F75\u5408\u9802\u70B9\u3092\n## \u305D\u308C\
    \u305E\u308C\u6A5F\u68B0\u8A9E\u306E\u30D3\u30C3\u30C8\u30DE\u30B9\u30AF\u3067\
    \u8868\u3059\u3002\u5C0F\u6728\u5185\u306E\u554F\u3044\u5408\u308F\u305B\u306F\
    O(1)\u3002\n## \u6E80\u676F\u306B\u306A\u3063\u305F\u5C0F\u6728\u306F\u4E21\u5074\
    \u304Cb/4\u4EE5\u4E0A\u306B\u306A\u308B\u3088\u3046O(b)\u3067\u5206\u5272\u3059\
    \u308B\u305F\u3081\u3001\n## \u8449\u306E\u8FFD\u52A0\u306F\u511F\u5374O(1)\u3001\
    \u5C0F\u6728\u5883\u754C\u306E\u7DCF\u6570\u306FO(V/b)\u3002\n## \u5883\u754C\u3060\
    \u3051\u306E\u96C6\u5408\u306F\u5C0F\u3055\u3044\u5074\u306E\u6240\u5C5E\u5148\
    \u3092\u76F4\u63A5\u66F4\u65B0\u3059\u308B\u3002\n## \u554F\u3044\u5408\u308F\u305B\
    \u306FO(1)\u3001\u5168\u66F4\u65B0\u306FO((V/b) log V)=O(V)\u3067\u3001\n## \u901A\
    \u5E38\u306EUnion-Find\u306B\u3088\u308B\u9006Ackermann\u95A2\u6570\u306E\u8FFD\
    \u52A0\u56E0\u5B50\u3092\u907F\u3051\u3066\u3044\u308B\u3002\nwhen not declared\
    \ CPLIB_GRAPH_GENERAL_MATCHING:\n    const CPLIB_GRAPH_GENERAL_MATCHING* = 1\n\
    \    import bitops\n    import cplib/graph/graph\n\n    type\n        MatchingMicroTree\
    \ = object\n            vertices: seq[int]\n            outside: int\n       \
    \     live: uint64\n        MatchingTreeUnion = object\n            limit: int\n\
    \            parent, depth, blockId, position: seq[int]\n            ancestors:\
    \ seq[uint64]\n            inserted, deleted: seq[bool]\n            blocks: seq[MatchingMicroTree]\n\
    \            representative, size, first, last, next, top: seq[int]\n\n    proc\
    \ initMatchingTreeUnion(n: int): MatchingTreeUnion =\n        ## \u8449\u306E\u8FFD\
    \u52A0\u3068\u89AA\u3078\u306E\u4F75\u5408\u3092\u6271\u3046\u3002\u5168\u64CD\
    \u4F5C\u3067O(n+\u64CD\u4F5C\u6570)\u3001\u9818\u57DFO(n)\u3002\n        result.limit\
    \ = max(8, fastLog2(uint64(max(n, 2))) + 1)\n        result.parent = newSeq[int](n)\n\
    \        result.depth = newSeq[int](n)\n        result.blockId = newSeq[int](n)\n\
    \        result.position = newSeq[int](n)\n        result.ancestors = newSeq[uint64](n)\n\
    \        result.inserted = newSeq[bool](n)\n        result.deleted = newSeq[bool](n)\n\
    \        result.representative = newSeq[int](n)\n        result.size = newSeq[int](n)\n\
    \        result.first = newSeq[int](n)\n        result.last = newSeq[int](n)\n\
    \        result.next = newSeq[int](n)\n        result.top = newSeq[int](n)\n \
    \       result.blocks = @[MatchingMicroTree(vertices: @[0], outside: 0, live:\
    \ 1)]\n        result.inserted[0] = true\n        result.ancestors[0] = 1\n\n\
    \    proc microRoot(t: MatchingTreeUnion, v: int): int =\n        ## \u540C\u3058\
    \u5C0F\u6728\u5185\u306E\u672A\u4F75\u5408\u306A\u6700\u5BC4\u308A\u7956\u5148\
    \u3092\u6C42\u3081\u308B\u3002O(1)\u3002\n        let b = t.blockId[v]\n     \
    \   let mask = t.ancestors[v] and t.blocks[b].live\n        if mask == 0: t.blocks[b].outside\n\
    \        else: t.blocks[b].vertices[fastLog2(mask)]\n\n    proc makeMacro(t: var\
    \ MatchingTreeUnion, v: int) =\n        ## \u5C0F\u6728\u5883\u754C\u3092\u5927\
    \u57DF\u7684\u306A\u4F75\u5408\u306E\u5BFE\u8C61\u306B\u767B\u9332\u3059\u308B\
    \u3002O(1)\u3002\n        if t.size[v] != 0: return\n        t.representative[v]\
    \ = v\n        t.size[v] = 1\n        t.first[v] = v\n        t.last[v] = v\n\
    \        t.next[v] = -1\n        t.top[v] = v\n\n    proc mergeMacro(t: var MatchingTreeUnion,\
    \ u, v: int) =\n        ## \u5C0F\u3055\u3044\u96C6\u5408\u306E\u6240\u5C5E\u5148\
    \u3092\u66F4\u65B0\u3059\u308B\u3002\u5168\u4F75\u5408\u3067O((n/b) log n)\u3002\
    \n        var a = t.representative[u]\n        var b = t.representative[v]\n \
    \       if a == b: return\n        if t.size[a] < t.size[b]: swap(a, b)\n    \
    \    var x = t.first[b]\n        while x != -1:\n            t.representative[x]\
    \ = a\n            x = t.next[x]\n        t.next[t.last[a]] = t.first[b]\n   \
    \     t.last[a] = t.last[b]\n        t.size[a] += t.size[b]\n        if t.depth[t.top[b]]\
    \ < t.depth[t.top[a]]:\n            t.top[a] = t.top[b]\n\n    proc root(t: var\
    \ MatchingTreeUnion, v: int): int =\n        ## \u672A\u4F75\u5408\u306A\u6700\
    \u5BC4\u308A\u7956\u5148\u3092\u6C42\u3081\u308B\u3002\u5168\u554F\u3044\u5408\
    \u308F\u305B\u3068\u4F75\u5408\u3067O(n+\u64CD\u4F5C\u6570)\u3002\n        if\
    \ not t.inserted[v]: return v\n        var x = v\n        result = t.microRoot(x)\n\
    \        if t.blockId[x] == t.blockId[result]: return\n        x = t.top[t.representative[result]]\n\
    \        while true:\n            result = t.microRoot(x)\n            if t.blockId[x]\
    \ == t.blockId[result]: return\n            t.mergeMacro(result, x)\n        \
    \    x = t.top[t.representative[result]]\n\n    proc rebuildBlock(t: var MatchingTreeUnion,\
    \ b: int, vertices: seq[int], outside: int) =\n        ## \u5206\u5272\u5F8C\u306E\
    \u5C0F\u6728\u306E\u7956\u5148\u30DE\u30B9\u30AF\u3092\u518D\u69CB\u7BC9\u3059\
    \u308B\u3002O(b)\u3002\n        t.blocks[b] = MatchingMicroTree(vertices: vertices,\
    \ outside: outside)\n        for i, v in vertices:\n            t.blockId[v] =\
    \ b\n            t.position[v] = i\n        for i, v in vertices:\n          \
    \  let bit = 1'u64 shl i\n            t.ancestors[v] = bit\n            if v !=\
    \ 0 and t.blockId[t.parent[v]] == b:\n                t.ancestors[v] = t.ancestors[v]\
    \ or t.ancestors[t.parent[v]]\n            if not t.deleted[v]: t.blocks[b].live\
    \ = t.blocks[b].live or bit\n\n    proc splitBlock(t: var MatchingTreeUnion, b:\
    \ int) =\n        ## \u6E80\u676F\u306E\u5C0F\u6728\u3092\u5927\u304D\u3055b/4\u4EE5\
    \u4E0A\u306E\u4E8C\u3064\u306B\u5206\u5272\u3059\u308B\u3002O(b)\u3002\n     \
    \   let vertices = t.blocks[b].vertices\n        let count = vertices.len\n  \
    \      let outside = t.blocks[b].outside\n        var sizes = newSeq[int](count)\n\
    \        for i in countdown(count - 1, 0):\n            inc sizes[i]\n       \
    \     let v = vertices[i]\n            if v != 0 and t.blockId[t.parent[v]] ==\
    \ b:\n                sizes[t.position[t.parent[v]]] += sizes[i]\n        var\
    \ pivot = outside\n        for i, v in vertices:\n            if sizes[i] * 2\
    \ >= count: pivot = v\n        var selected = 0'u64\n        var total = 0\n \
    \       for i, v in vertices:\n            if v != 0 and t.parent[v] == pivot\
    \ and total * 4 < count:\n                selected = selected or (1'u64 shl i)\n\
    \                total += sizes[i]\n        var left, right: seq[int]\n      \
    \  for i, v in vertices:\n            if (t.ancestors[v] and selected) != 0: right.add(v)\n\
    \            else: left.add(v)\n        assert left.len > 0 and right.len > 0,\
    \ \"\u4F75\u5408\u3059\u308B\u4E21\u65B9\u306E\u5217\u306F\u7A7A\u3067\u306A\u3044\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let nb = t.blocks.len\n\
    \        t.blocks.add(MatchingMicroTree())\n        # \u6240\u5C5E\u5148\u3092\
    \u5148\u306B\u66F4\u65B0\u3057\u3001\u5883\u754C\u3092\u307E\u305F\u3050\u7956\
    \u5148\u30DE\u30B9\u30AF\u3092\u6DF7\u305C\u306A\u3044\u3002\n        for v in\
    \ right: t.blockId[v] = nb\n        t.rebuildBlock(b, left, outside)\n       \
    \ t.rebuildBlock(nb, right, pivot)\n        t.makeMacro(pivot)\n\n    proc grow(t:\
    \ var MatchingTreeUnion, parent, v: int) =\n        ## \u6728\u306B\u8449\u3092\
    \u8FFD\u52A0\u3059\u308B\u3002\u5206\u5272\u3092\u542B\u3081\u3066\u511F\u5374\
    O(1)\u3002\n        assert not t.inserted[v] and t.inserted[parent], \"\u8FFD\u52A0\
    \u3059\u308B\u9802\u70B9\u306F\u672A\u767B\u9332\u3067\u3001\u89AA\u9802\u70B9\
    \u306F\u767B\u9332\u6E08\u307F\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        t.inserted[v] = true\n        t.parent[v] = parent\n \
    \       t.depth[v] = t.depth[parent] + 1\n        let b = t.blockId[parent]\n\
    \        let i = t.blocks[b].vertices.len\n        t.blockId[v] = b\n        t.position[v]\
    \ = i\n        t.ancestors[v] = t.ancestors[parent] or (1'u64 shl i)\n       \
    \ t.blocks[b].vertices.add(v)\n        t.blocks[b].live = t.blocks[b].live or\
    \ (1'u64 shl i)\n        if i + 1 == t.limit: t.splitBlock(b)\n\n    proc joinParent(t:\
    \ var MatchingTreeUnion, v: int) =\n        ## \u9802\u70B9\u306E\u96C6\u5408\u3092\
    \u89AA\u306E\u96C6\u5408\u3078\u4F75\u5408\u3059\u308B\u3002O(1)\u3002\n     \
    \   assert v != 0 and t.inserted[v], \"\u5BFE\u8C61\u306E\u9802\u70B9\u306F0\u4EE5\
    \u5916\u306E\u767B\u9332\u6E08\u307F\u9802\u70B9\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\"\n        t.deleted[v] = true\n        let b =\
    \ t.blockId[v]\n        t.blocks[b].live = t.blocks[b].live and not (1'u64 shl\
    \ t.position[v])\n\n    type\n        MatchingSearch = object\n            n,\
    \ time, deadline, stamp, order, saved: int\n            graph: seq[seq[int]]\n\
    \            mate, potential, label, initial: seq[int]\n            link: seq[tuple[u,\
    \ v: int]]\n            queue: seq[int]\n            head: int\n            events:\
    \ seq[seq[tuple[u, v: int]]]\n            contractions: seq[tuple[v, base: int]]\n\
    \            members: seq[seq[int]]\n            tree: MatchingTreeUnion\n\n \
    \   proc base(s: var MatchingSearch, v: int): int =\n        ## \u6B63\u306E\u53CC\
    \u5BFE\u5024\u3092\u6301\u3064\u82B1\u3068\u63A2\u7D22\u4E2D\u306E\u82B1\u3092\
    \u7E2E\u7D04\u3057\u305F\u57FA\u70B9\u3092\u8FD4\u3059\u3002\n        s.tree.root(s.initial[v])\n\
    \n    proc extend(s: var MatchingSearch, x, y: int) =\n        ## \u4EA4\u4E92\
    \u6728\u3092\u975E\u30DE\u30C3\u30C1\u8FBA\u3068\u30DE\u30C3\u30C1\u8FBA\u306E\
    \u4E00\u7D44\u3060\u3051\u4F38\u3070\u3059\u3002\n        let z = s.mate[y]\n\
    \        s.tree.grow(x, y)\n        s.tree.grow(y, z)\n        s.label[y] = -1\n\
    \        s.potential[y] = s.time\n        s.link[z] = (x, y)\n        s.label[z]\
    \ = s.label[x]\n        s.potential[z] = s.time + 1\n        s.queue.add(z)\n\n\
    \    proc contract(s: var MatchingSearch, x, y: int) =\n        ## \u4EA4\u4E92\
    \u6728\u5185\u306E\u5947\u9589\u8DEF\u3092\u7E2E\u7D04\u3059\u308B\u3002\u8D70\
    \u67FB\u3059\u308B\u9802\u70B9\u6570\u306B\u6BD4\u4F8B\u3059\u308B\u6642\u9593\
    \u3002\n        var a = s.base(x)\n        var b = s.base(y)\n        dec s.stamp\n\
    \        s.label[s.mate[a]] = s.stamp\n        s.label[s.mate[b]] = s.stamp\n\
    \        while true:\n            if s.mate[b] != 0: swap(a, b)\n            a\
    \ = s.base(s.link[a].u)\n            if s.label[s.mate[a]] == s.stamp: break\n\
    \            s.label[s.mate[a]] = s.stamp\n        let ancestor = a\n        for\
    \ endpoint in [x, y]:\n            var v = s.base(endpoint)\n            while\
    \ v != ancestor:\n                let w = s.mate[v]\n                let parent\
    \ = s.base(s.link[v].u)\n                s.link[w] = (x, y)\n                s.label[w]\
    \ = s.label[x]\n                s.potential[w] = 1 + 2 * s.time - s.potential[w]\n\
    \                s.queue.add(w)\n                s.tree.joinParent(v)\n      \
    \          s.tree.joinParent(w)\n                s.contractions.add((v, ancestor))\n\
    \                s.contractions.add((w, ancestor))\n                v = parent\n\
    \n    proc shortest(s: var MatchingSearch): bool =\n        ## \u53CC\u5BFE\u5909\
    \u6570\u306E\u66F4\u65B0\u3092\u6642\u523B\u30D0\u30B1\u30C3\u30C8\u3067\u51E6\
    \u7406\u3057\u3001\u6700\u77ED\u5897\u52A0\u8DEF\u3092\u63A2\u3059\u3002O(V+E)\u3002\
    \n        s.time = 0\n        s.deadline = s.n + 1\n        s.stamp = -1\n   \
    \     s.saved = 0\n        s.queue.setLen(0)\n        s.head = 0\n        s.contractions.setLen(0)\n\
    \        s.tree = initMatchingTreeUnion(s.n + 1)\n        for u in 0..s.n:\n \
    \           s.initial[u] = u\n            s.label[u] = 0\n            s.potential[u]\
    \ = 1\n        for bucket in s.events.mitems: bucket.setLen(0)\n        for u\
    \ in 1..s.n:\n            if s.mate[u] == 0:\n                s.tree.grow(0, u)\n\
    \                s.label[u] = u\n                s.queue.add(u)\n        block\
    \ search:\n            while true:\n                while s.head < s.queue.len:\n\
    \                    let x = s.queue[s.head]\n                    inc s.head\n\
    \                    for y in s.graph[x]:\n                        if s.label[y]\
    \ > 0:\n                            let at = (s.potential[x] + s.potential[y])\
    \ div 2\n                            if s.label[x] != s.label[y]:\n          \
    \                      if at == s.time: break search\n                       \
    \         s.deadline = min(s.deadline, at)\n                            elif s.base(x)\
    \ != s.base(y):\n                                if at == s.time: s.contract(x,\
    \ y)\n                                elif at <= s.n div 2: s.events[at].add((x,\
    \ y))\n                        elif s.label[y] == 0:\n                       \
    \     let at = s.potential[x] + 1\n                            if at == s.time:\
    \ s.extend(x, y)\n                            elif at <= s.n div 2: s.events[at].add((x,\
    \ y))\n                while true:\n                    inc s.time\n         \
    \           s.saved = s.contractions.len\n                    if s.time > s.n\
    \ div 2: return false\n                    if s.time == s.deadline: break search\n\
    \                    var changed = false\n                    for e in s.events[s.time]:\n\
    \                        let (x, y) = e\n                        if s.label[y]\
    \ > 0:\n                            if s.potential[x] + s.potential[y] != 2 *\
    \ s.time: continue\n                            if s.base(x) == s.base(y): continue\n\
    \                            if s.label[x] != s.label[y]: break search\n     \
    \                       s.contract(x, y)\n                            changed\
    \ = true\n                        elif s.label[y] == 0:\n                    \
    \        s.extend(x, y)\n                            changed = true\n        \
    \            if changed: break\n        for u in 1..s.n:\n            if s.label[u]\
    \ > 0: s.potential[u] -= s.time\n            elif s.label[u] < 0: s.potential[u]\
    \ = 1 + s.time - s.potential[u]\n        true\n\n    proc rematch(s: var MatchingSearch,\
    \ v, w: int) =\n        ## \u82B1\u3092\u5C55\u958B\u3057\u306A\u304C\u3089\u5897\
    \u52A0\u8DEF\u4E0A\u306E\u30DE\u30C3\u30C1\u8FBA\u3092\u53CD\u8EE2\u3059\u308B\
    \u3002\u7D4C\u8DEF\u9577\u306B\u6BD4\u4F8B\u3059\u308B\u6642\u9593\u3002\n   \
    \     var stack = @[(v, w)]\n        while stack.len > 0:\n            let (x,\
    \ y) = stack.pop()\n            let old = s.mate[x]\n            s.mate[x] = y\n\
    \            if s.mate[old] != x: continue\n            let e = s.link[x]\n  \
    \          if e.v == s.base(e.v):\n                s.mate[old] = e.u\n       \
    \         stack.add((e.u, old))\n            else:\n                stack.add((e.v,\
    \ e.u))\n                stack.add((e.u, e.v))\n\n    proc augment(s: var MatchingSearch,\
    \ start, startBase: int): bool =\n        ## \u30BF\u30A4\u30C8\u306A\u8FBA\u3060\
    \u3051\u3067\u6DF1\u3055\u512A\u5148\u63A2\u7D22\u3057\u3001\u5897\u52A0\u8DEF\
    \u3092\u4E00\u3064\u53CD\u8EE2\u3059\u308B\u3002\n        type Frame = object\n\
    \            x, bx, edge: int\n            pending: seq[int]\n            group,\
    \ member: int\n        var stack = @[Frame(x: start, bx: startBase)]\n       \
    \ while stack.len > 0:\n            let i = stack.high\n            if stack[i].group\
    \ < stack[i].pending.len:\n                let b = stack[i].pending[stack[i].group]\n\
    \                if stack[i].member < s.members[b].len:\n                    let\
    \ v = s.members[b][stack[i].member]\n                    inc stack[i].member\n\
    \                    let bx = s.base(b)\n                    stack.add(Frame(x:\
    \ v, bx: bx))\n                else:\n                    inc stack[i].group\n\
    \                    stack[i].member = 0\n                continue\n         \
    \   let x = stack[i].x\n            let bx = stack[i].bx\n            if stack[i].edge\
    \ == s.graph[x].len:\n                stack.setLen(i)\n                continue\n\
    \            let y = s.graph[x][stack[i].edge]\n            inc stack[i].edge\n\
    \            if s.potential[x] + s.potential[y] != 0: continue\n            let\
    \ by = s.base(y)\n            if s.label[by] > 0:\n                if s.label[bx]\
    \ >= s.label[by]: continue\n                var pending: seq[int]\n          \
    \      var v = by\n                while v != bx:\n                    let w =\
    \ s.base(s.mate[v])\n                    let parent = s.base(s.link[v].u)\n  \
    \                  s.link[w] = (x, y)\n                    pending.add(w)\n  \
    \                  s.tree.joinParent(v)\n                    s.tree.joinParent(w)\n\
    \                    v = parent\n                # \u7E2E\u7D04\u3057\u305F\u7D4C\
    \u8DEF\u3092\u6839\u5074\u304B\u3089\u63A2\u7D22\u3059\u308B\u3002\n         \
    \       stack[i].pending.setLen(0)\n                for j in countdown(pending.high,\
    \ 0): stack[i].pending.add(pending[j])\n                stack[i].group = 0\n \
    \               stack[i].member = 0\n            elif s.label[by] == 0:\n    \
    \            s.label[by] = -1\n                let z = s.mate[by]\n          \
    \      if z == 0:\n                    s.rematch(x, y)\n                    s.rematch(y,\
    \ x)\n                    return true\n                let bz = s.base(z)\n  \
    \              s.tree.grow(s.initial[x], by)\n                s.tree.grow(by,\
    \ bz)\n                s.link[bz] = (x, y)\n                s.label[bz] = s.order\n\
    \                inc s.order\n                stack[i].pending = @[bz]\n     \
    \           stack[i].group = 0\n                stack[i].member = 0\n        false\n\
    \n    proc maximal(s: var MatchingSearch): int =\n        ## \u6B63\u306E\u53CC\
    \u5BFE\u5024\u3092\u6301\u3064\u82B1\u3092\u6B8B\u3057\u3001\u9802\u70B9\u7D20\
    \u306A\u6700\u77ED\u5897\u52A0\u8DEF\u306E\u6975\u5927\u96C6\u5408\u3092\u6C42\
    \u3081\u308B\u3002O(V+E)\u3002\n        for u in 0..s.n: s.initial[u] = u\n  \
    \      for i in 0..<s.saved:\n            let e = s.contractions[i]\n        \
    \    s.initial[e.v] = e.base\n        # \u7E2E\u7D04\u5C65\u6B74\u306E\u68EE\u3092\
    \u4E00\u5EA6\u305A\u3064\u305F\u3069\u308A\u3001\u5168\u9802\u70B9\u306E\u57FA\
    \u70B9\u3092\u7DDA\u5F62\u6642\u9593\u3067\u78BA\u5B9A\u3059\u308B\u3002\n   \
    \     var path: seq[int]\n        for u in 1..s.n:\n            var v = u\n  \
    \          while s.initial[v] != v:\n                path.add(v)\n           \
    \     v = s.initial[v]\n            for x in path: s.initial[x] = v\n        \
    \    path.setLen(0)\n        s.tree = initMatchingTreeUnion(s.n + 1)\n       \
    \ s.order = 1\n        for u in 0..s.n:\n            s.label[u] = 0\n        \
    \    s.members[u].setLen(0)\n        for u in 1..s.n: s.members[s.initial[u]].add(u)\n\
    \        for u in 1..s.n:\n            if s.mate[u] != 0: continue\n         \
    \   let b = s.initial[u]\n            if s.label[b] != 0: continue\n         \
    \   s.tree.grow(0, b)\n            s.label[b] = s.order\n            inc s.order\n\
    \            for v in s.members[b]:\n                if s.augment(v, b):\n   \
    \                 inc result\n                    break\n        assert result\
    \ > 0, \"result\u306F\u6B63\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n\n    proc maximum_matching*(g: UnDirectedGraph): seq[tuple[u, v: int]]\
    \ =\n        ## \u7121\u5411\u30B0\u30E9\u30D5\u306E\u6700\u5927\u30DE\u30C3\u30C1\
    \u30F3\u30B0\u306E\u9802\u70B9\u30DA\u30A2\u5217\u3092\u8FD4\u3059\u3002O(V+E\
    \ sqrt V)\u6642\u9593\u3001O(V+E)\u9818\u57DF\u3002\n        ## \u91CD\u307F\u306F\
    \u7121\u8996\u3059\u308B\u3002\u591A\u91CD\u8FBA\u3092\u8A31\u5BB9\u3057\u3001\
    \u81EA\u5DF1\u30EB\u30FC\u30D7\u306F\u7121\u8996\u3059\u308B\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        ## \u9759\u7684\u30B0\u30E9\
    \u30D5\u306Fbuild()\u5F8C\u306B\u547C\u3076\u3002\u5B64\u7ACB\u70B9\u3092\u9664\
    \u3044\u305F\u63A2\u7D22\u90E8\u5206\u306FO(E sqrt V)\u3002\n        when g is\
    \ StaticGraphTypes:\n            g.static_graph_initialized_check()\n        var\
    \ id = newSeq[int](g.len)\n        var original = @[-1]\n        for u in 0..<g.len:\n\
    \            for (v, _) in g.to_and_cost(u):\n                if u >= v: continue\n\
    \                for x in [u, v]:\n                    if id[x] == 0:\n      \
    \                  id[x] = original.len\n                        original.add(x)\n\
    \        if original.len == 1: return\n        let n = original.len - 1\n    \
    \    var s = MatchingSearch(n: n,\n            graph: newSeq[seq[int]](n + 1),\
    \ mate: newSeq[int](n + 1),\n            potential: newSeq[int](n + 1), label:\
    \ newSeq[int](n + 1),\n            initial: newSeq[int](n + 1), link: newSeq[tuple[u,\
    \ v: int]](n + 1),\n            events: newSeq[seq[tuple[u, v: int]]](n div 2\
    \ + 1),\n            members: newSeq[seq[int]](n + 1))\n        for u in 0..<g.len:\n\
    \            for (v, _) in g.to_and_cost(u):\n                if u >= v: continue\n\
    \                s.graph[id[u]].add(id[v])\n                s.graph[id[v]].add(id[u])\n\
    \        var count = 0\n        while count * 2 + 1 < n and s.shortest():\n  \
    \          count += s.maximal()\n        for u in 1..n:\n            if s.mate[u]\
    \ > u:\n                result.add((original[u], original[s.mate[u]]))\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/general_matching.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/general_matching_test.nim
  - verify/graph/general_matching_test.nim
  - verify/AI/general_matching_tree_union_test.nim
  - verify/AI/general_matching_tree_union_test.nim
  - verify/AI/general_matching_test.nim
  - verify/AI/general_matching_test.nim
documentation_of: cplib/graph/general_matching.nim
layout: document
redirect_from:
- /library/cplib/graph/general_matching.nim
- /library/cplib/graph/general_matching.nim.html
title: cplib/graph/general_matching.nim
---
