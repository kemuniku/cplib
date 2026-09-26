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
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/mo_test.nim
    title: verify/AI/mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/mo_test.nim
    title: verify/AI/mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tree_mo_test.nim
    title: verify/AI/tree_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tree_mo_test.nim
    title: verify/AI/tree_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
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
  code: "when not declared CPLIB_UTILS_MO:\n    const CPLIB_UTILS_MO* = 1\n    import\
    \ math, algorithm\n    import cplib/graph/graph\n    type Mo* = object\n     \
    \   width*: int\n        N, Q: int\n        qli: seq[seq[int]]\n        size:\
    \ int\n\n    proc initMo*(N, Q: int, width = max(1, int(1.0 * float(N) / max(1.0,\
    \ sqrt(float(Q) * 2.0 / 3.0))))): Mo =\n        ## \u9577\u3055N\u3001\u30AF\u30A8\
    \u30EA\u6570Q\u3092\u60F3\u5B9A\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u3002\
    O(N / width)\u3002\n        result.width = width\n        result.N = N\n     \
    \   result.Q = Q\n        let qlisize = N div width + 1\n        result.qli =\
    \ newSeq[seq[int]](qlisize)\n\n    proc insert*(self: var Mo, l, r: int) =\n \
    \       ## \u5EA7\u6A19(l, r)\u3092\u767B\u9332\u3059\u308B\u3002l > r\u3084\u8CA0\
    \u306Er\u3082\u8A31\u5BB9\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        ##\
    \ l\u3068\u30AF\u30A8\u30EA\u756A\u53F7\u306F\u975E\u8CA020bit\u3001r\u306F\u7B26\
    \u53F7\u4ED8\u304D24bit\u3067\u683C\u7D0D\u3059\u308B\u3002\n        assert 0\
    \ <= l and l <= self.N and l < (1 shl 20)\n        assert -(1 shl 23) <= r and\
    \ r < (1 shl 23) and r <= self.N\n        assert self.size < (1 shl 20)\n    \
    \    self.qli[l div self.width].add((r shl 40) or ((l) shl 20) or self.size)\n\
    \        self.size += 1\n\n    template run*(self: var Mo, add_left, add_right,\
    \ delete_left, delete_right, remember: untyped) =\n        ## \u767B\u9332\u3057\
    \u305F\u533A\u9593\u3092\u51E6\u7406\u3059\u308B\u3002\u30BD\u30FC\u30C8O(Q log\
    \ Q)\u3001\u7AEF\u70B9\u79FB\u52D5O(N\xB2 / width + Q * width)\u3002\n       \
    \ block:\n            {.push checks: off.}\n            # \u30ED\u30FC\u30AB\u30EB\
    \u306B\u4FDD\u6301\u3057\u305F\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u547C\
    \u3073\u51FA\u3057\u5074\u3067\u6700\u9069\u5316\u3067\u304D\u308B\u3088\u3046\
    \u306B\u3059\u308B\u3002\n            proc executeMo(solver: var Mo) =\n     \
    \           ## \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u4E00\u5EA6\u305A\u3064\
    \u8A55\u4FA1\u3057\u3001\u767B\u9332\u9806\u306E\u756A\u53F7\u3067\u7D50\u679C\
    \u3092\u901A\u77E5\u3059\u308B\u3002\n                let callbackAddLeft = add_left\n\
    \                let callbackAddRight = add_right\n                let callbackDeleteLeft\
    \ = delete_left\n                let callbackDeleteRight = delete_right\n    \
    \            let callbackRemember = remember\n                var nl = 0\n   \
    \             var nr = 0\n                const mask2 = ((1 shl 20)-1) shl 20\n\
    \                const mask3 = ((1 shl 20)-1)\n                for i in 0..<len(solver.qli):\n\
    \                    if len(solver.qli[i]) == 0:\n                        continue\n\
    \                    sort(solver.qli[i])\n                    if (i and 1) ==\
    \ 1:\n                        reverse(solver.qli[i])\n                    for\
    \ x in solver.qli[i]:\n                        let ri = x shr 40\n           \
    \             let li = (x and mask2) shr 20\n                        let idx =\
    \ x and mask3\n                        while nl > li: nl.dec; callbackAddLeft(nl)\n\
    \                        while nr < ri: callbackAddRight(nr); nr.inc\n       \
    \                 while nl < li: callbackDeleteLeft(nl); nl.inc\n            \
    \            while nr > ri: nr.dec; callbackDeleteRight(nr)\n                \
    \        callbackRemember(idx)\n            executeMo(self)\n            {.pop.}\n\
    \n    type TreeMo* = object\n        width*: int\n        tour, first: seq[int]\n\
    \        queries: seq[tuple[left, right, idx: int]]\n\n    iterator treeMoNeighbors(g:\
    \ UnDirectedGraph or seq[seq[int]], u: int): int =\n        ## \u6728\u306E\u96A3\
    \u63A5\u9802\u70B9\u3092\u5217\u6319\u3059\u308B\u3002O(deg(u))\u3002\n      \
    \  when g is seq[seq[int]]:\n            for v in g[u]: yield v\n        else:\n\
    \            for (v, _) in g.to_and_cost(u): yield v\n\n    proc initTreeMo*(g:\
    \ UnDirectedGraph or seq[seq[int]], Q: int,\n            root: int = 0, width:\
    \ int = 0): TreeMo =\n        ## \u7121\u5411\u6728g\u306E\u30D1\u30B9\u30AF\u30A8\
    \u30EAQ\u500B\u3092\u60F3\u5B9A\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u3002\
    \u6642\u9593\u30FB\u7A7A\u9593O(N)\u3002\n        ## \u96A3\u63A5\u30EA\u30B9\u30C8\
    \u306F\u4E21\u65B9\u5411\u306E\u8FBA\u3092\u542B\u3081\u3001\u9759\u7684\u30B0\
    \u30E9\u30D5\u306Fbuild\u3057\u3066\u304A\u304F\u3053\u3068\u3002\u91CD\u307F\u306F\
    \u53C2\u7167\u3057\u306A\u3044\u3002\n        ## \u5E450\u306A\u3089Euler tour\u306E\
    \u9577\u3055\u3068Q\u304B\u3089\u5E45\u3092\u6C7A\u3081\u308B\u3002root\u306F\
    run\u958B\u59CB\u6642\u306E1\u9802\u70B9\u30D1\u30B9\u3002\n        assert g.len\
    \ > 0 and 0 <= root and root < g.len\n        assert Q >= 0 and width >= 0\n \
    \       result.first = newSeq[int](g.len)\n        for v in 0..<g.len: result.first[v]\
    \ = -1\n        result.tour = newSeqOfCap[int](2 * g.len - 1)\n        var stack\
    \ = @[(vertex: root, parent: -1)]\n        while stack.len > 0:\n            let\
    \ (u, p) = stack.pop()\n            if u == -1:\n                result.tour.add(p)\n\
    \                continue\n            assert 0 <= u and u < g.len\n         \
    \   assert result.first[u] == -1, \"g\u306F\u7121\u5411\u6728\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n            result.first[u] = result.tour.len\n\
    \            result.tour.add(u)\n            for v in treeMoNeighbors(g, u):\n\
    \                if v != p:\n                    stack.add((vertex: -1, parent:\
    \ u))\n                    stack.add((vertex: v, parent: u))\n        assert result.tour.len\
    \ == 2 * g.len - 1, \"g\u306F\u9023\u7D50\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        let estimated = int(float(result.tour.len) / max(1.0,\
    \ sqrt(float(Q) * 2.0 / 3.0)))\n        result.width = if width == 0: max(1, estimated)\
    \ else: min(width, result.tour.len)\n\n    proc insert*(self: var TreeMo, u, v:\
    \ int): int {.discardable.} =\n        ## \u4E21\u7AEF\u3092\u542B\u3080\u7121\
    \u5411\u30D1\u30B9(u, v)\u3092\u767B\u9332\u3057\u30010\u59CB\u307E\u308A\u306E\
    \u767B\u9332\u756A\u53F7\u3092\u8FD4\u3059\u3002\u511F\u5374O(1)\u3002\n     \
    \   assert 0 <= u and u < self.first.len and 0 <= v and v < self.first.len\n \
    \       let a = self.first[u]\n        let b = self.first[v]\n        result =\
    \ self.queries.len\n        self.queries.add((min(a, b), max(a, b), result))\n\
    \n    template run*(self: var TreeMo, add, delete, remember: untyped) =\n    \
    \    ## \u5E38\u306B1\u672C\u306E\u30D1\u30B9\u3092\u7DAD\u6301\u3057\u3066\u51E6\
    \u7406\u3057\u3001\u767B\u9332\u756A\u53F7\u3092remember\u306B\u6E21\u3059\u3002\
    \u7D42\u4E86\u6642\u306Froot\u306E1\u9802\u70B9\u306B\u623B\u3059\u3002\n    \
    \    ## \u547C\u3073\u51FA\u3057\u524D\u306B\u72B6\u614B\u3092root\u306E1\u9802\
    \u70B9\u30D1\u30B9\u306B\u521D\u671F\u5316\u3059\u308B\u3053\u3068\u3002\u521D\
    \u671F\u9802\u70B9\u3092\u8FFD\u52A0\u3059\u308B\u30B3\u30FC\u30EB\u30D0\u30C3\
    \u30AF\u306F\u547C\u3070\u306A\u3044\u3002\n        ## add(u, v)\u306F\u7AEF\u70B9\
    u\u306B\u8FBA(u, v)\u3068\u9802\u70B9v\u3092\u8FFD\u52A0\u3057\u3001delete(u,\
    \ v)\u306F\u8FBA(u, v)\u3068\u7AEF\u70B9v\u3092\u524A\u9664\u3059\u308B\u3002\n\
    \        ## \u3069\u3061\u3089\u306E\u7AEF\u306B\u3082\u64CD\u4F5C\u3059\u308B\
    \u305F\u3081\u3001\u56DE\u7B54\u306F\u30D1\u30B9\u306E\u5411\u304D\u3084\u8FFD\
    \u52A0\u9806\u306B\u3088\u3089\u306A\u3044\u3053\u3068\u3002\n        ## remember\u306F\
    \u72B6\u614B\u3092\u5909\u66F4\u305B\u305A\u3001\u7D50\u679C\u3092\u767B\u9332\
    \u756A\u53F7\u3067\u4FDD\u5B58\u3059\u308B\u3053\u3068\u3002\u5B9F\u884C\u4E2D\
    \u306B\u767B\u9332\u5185\u5BB9\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\
    \u3002\n        ## \u5E45B\u3067\u30BD\u30FC\u30C8O(Q log Q)\u3001\u8FFD\u52A0\
    \u30FB\u524A\u9664O(N\xB2/B + QB + N)\u56DE\u3001\u8FFD\u52A0\u9818\u57DFO(N +\
    \ Q)\u3002\n        block:\n            proc executeTreeMo(solver: var TreeMo)\
    \ =\n                ## \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u4E00\u5EA6\
    \u305A\u3064\u8A55\u4FA1\u3057\u3001Euler tour\u4E0A\u3067\u4E21\u7AEF\u3092\u52D5\
    \u304B\u3059\u3002\n                assert solver.width > 0, \"initTreeMo\u3067\
    \u521D\u671F\u5316\u3057\u3066\u304F\u3060\u3055\u3044\"\n                let\
    \ callbackAdd = add\n                let callbackDelete = delete\n           \
    \     let callbackRemember = remember\n                if solver.queries.len ==\
    \ 0: return\n                let width = solver.width\n                solver.queries.sort(proc(a,\
    \ b: tuple[left, right, idx: int]): int =\n                    result = cmp(a.left\
    \ div width, b.left div width)\n                    if result == 0:\n        \
    \                result = cmp(a.right, b.right)\n                        if ((a.left\
    \ div width) and 1) != 0: result = -result\n                    if result == 0:\
    \ result = cmp(a.idx, b.idx)\n                )\n                var contains\
    \ = newSeq[bool](solver.first.len)\n                contains[solver.tour[0]] =\
    \ true\n                var left, right: int\n                template moveEndpoint(position,\
    \ target: int) =\n                    ## Euler tour\u306B\u6CBF\u3063\u3066\u7AEF\
    \u70B9\u3092\u79FB\u52D5\u3057\u3001\u5404\u64CD\u4F5C\u306E\u524D\u5F8C\u3067\
    \u30D1\u30B9\u3092\u7DAD\u6301\u3059\u308B\u3002\n                    while position\
    \ != target:\n                        let step = if position < target: 1 else:\
    \ -1\n                        let u = solver.tour[position]\n                \
    \        let v = solver.tour[position + step]\n                        if contains[v]:\n\
    \                            callbackDelete(v, u)\n                          \
    \  contains[u] = false\n                        else:\n                      \
    \      callbackAdd(u, v)\n                            contains[v] = true\n   \
    \                     position += step\n                for query in solver.queries:\n\
    \                    moveEndpoint(left, query.left)\n                    moveEndpoint(right,\
    \ query.right)\n                    callbackRemember(query.idx)\n            \
    \    moveEndpoint(left, 0)\n                moveEndpoint(right, 0)\n         \
    \   executeTreeMo(self)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/utils/mo.nim
  requiredBy:
  - verify/utils/mo_test_.nim
  - verify/utils/mo_test_.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/math/combination_prefix_sum.nim
  timestamp: '2026-09-27 00:37:04+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_kth_smallest_test.nim
  - verify/collections/range_kth_smallest_test.nim
  - verify/AI/tree_mo_test.nim
  - verify/AI/tree_mo_test.nim
  - verify/AI/mo_test.nim
  - verify/AI/mo_test.nim
  - verify/math/combination_prefix_sum_test.nim
  - verify/math/combination_prefix_sum_test.nim
documentation_of: cplib/utils/mo.nim
layout: document
redirect_from:
- /library/cplib/utils/mo.nim
- /library/cplib/utils/mo.nim.html
title: cplib/utils/mo.nim
---
