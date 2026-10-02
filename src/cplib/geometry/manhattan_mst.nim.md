---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/manhattan_mst_random_test.nim
    title: verify/geometry/manhattan_mst_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/manhattan_mst_random_test.nim
    title: verify/geometry/manhattan_mst_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/manhattan_mst_test.nim
    title: verify/geometry/manhattan_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/manhattan_mst_test.nim
    title: verify/geometry/manhattan_mst_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_MANHATTAN_MST:\n    const CPLIB_GEOMETRY_MANHATTAN_MST*\
    \ = 1\n    import algorithm\n    import cplib/geometry/base\n    import cplib/collections/unionfind\n\
    \n    proc manhattan_mst*[T: SomeSignedInt](points: openArray[Point[T]]): seq[(int,\
    \ int)] =\n        ## \u30DE\u30F3\u30CF\u30C3\u30BF\u30F3\u8DDD\u96E2\u306E\u6700\
    \u5C0F\u5168\u57DF\u6728\u3092\u3001\u5165\u529B\u306E\u9802\u70B9\u756A\u53F7\
    \u306E\u7D44\u3067\u8FD4\u3059\u3002O(N log N)\u6642\u9593\u3001O(N)\u9818\u57DF\
    \u3002\n        ## \u5EA7\u6A19\u306E\u7D76\u5BFE\u5024\u306Fhigh(int64) div 4\u4EE5\
    \u4E0B\u3002\u5185\u90E8\u8A08\u7B97\u306Fint64\u3067\u884C\u3046\u3002\n    \
    \    ## \u91CD\u8907\u70B9\u3082\u5225\u9802\u70B9\u3068\u3057\u3066\u6271\u3044\
    \u3001N <= 1\u306A\u3089\u7A7A\u5217\u3092\u8FD4\u3059\u3002\u5165\u529B\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\n        const bound = high(int64) div 4\n\
    \        var sites = newSeq[tuple[y, x: int64, id: int]](points.len)\n       \
    \ for i, p in points:\n            let x = int64(p.x)\n            let y = int64(p.y)\n\
    \            assert -bound <= x and x <= bound, \"x\u5EA7\u6A19\u306E\u7D76\u5BFE\
    \u5024\u304C\u5927\u304D\u3059\u304E\u307E\u3059\"\n            assert -bound\
    \ <= y and y <= bound, \"y\u5EA7\u6A19\u306E\u7D76\u5BFE\u5024\u304C\u5927\u304D\
    \u3059\u304E\u307E\u3059\"\n            sites[i] = (y, x, i)\n        if points.len\
    \ <= 1:\n            return @[]\n\n        proc cmpSite(a, b: tuple[y, x: int64,\
    \ id: int]): int =\n            ## y\u5EA7\u6A19\u3001x\u5EA7\u6A19\u306E\u9806\
    \u306B\u6BD4\u8F03\u3059\u308B\u3002\n            if a.y != b.y: cmp(a.y, b.y)\
    \ else: cmp(a.x, b.x)\n\n        sites.sort(cmpSite)\n        let uf = initUnionFind(points.len)\n\
    \        result = newSeqOfCap[(int, int)](points.len - 1)\n        var uniqueCount\
    \ = 0\n        for p in sites:\n            if uniqueCount > 0 and sites[uniqueCount\
    \ - 1].x == p.x and sites[uniqueCount - 1].y == p.y:\n                let u =\
    \ sites[uniqueCount - 1].id\n                uf.unite(u, p.id)\n             \
    \   result.add((min(u, p.id), max(u, p.id)))\n            else:\n            \
    \    sites[uniqueCount] = p\n                inc uniqueCount\n        sites.setLen(uniqueCount)\n\
    \        if uniqueCount == 1:\n            return\n\n        var ranks = newSeq[array[2,\
    \ int]](points.len)\n        var sizes: array[2, int]\n        var keys = newSeq[tuple[value:\
    \ int64, id: int]](sites.len)\n        for diagonal in 0..<2:\n            for\
    \ i, p in sites:\n                keys[i] = (if diagonal == 0: (p.x - p.y, p.id)\
    \ else: (p.x + p.y, p.id))\n            keys.sort(proc(a, b: tuple[value: int64,\
    \ id: int]): int = cmp(a.value, b.value))\n            for i, key in keys:\n \
    \               if i == 0 or keys[i - 1].value != key.value:\n               \
    \     inc sizes[diagonal]\n                ranks[key.id][diagonal] = sizes[diagonal]\n\
    \n        var candidates = newSeqOfCap[tuple[weight: int64, u, v: int]](4 * sites.len)\n\
    \        var fenwick = newSeq[tuple[score: int64, id: int]](max(sizes[0], sizes[1])\
    \ + 1)\n        for direction in 0..<4:\n            if direction mod 2 == 0:\n\
    \                if direction == 2:\n                    for p in sites.mitems:\n\
    \                        p.x = -p.x\n                        swap(p.x, p.y)\n\
    \                    sites.sort(cmpSite)\n            else:\n                #\
    \ \u540C\u3058y\u306E\u533A\u9593\u3092\u53CD\u8EE2\u3059\u308C\u3070\u3001x\u306E\
    \u7B26\u53F7\u53CD\u8EE2\u5F8C\u306E\u6574\u5217\u9806\u306B\u306A\u308B\u3002\
    \n                var first = 0\n                while first < sites.len:\n  \
    \                  var last = first + 1\n                    while last < sites.len\
    \ and sites[last].y == sites[first].y:\n                        inc last\n   \
    \                 sites.reverse(first, last - 1)\n                    first =\
    \ last\n                for p in sites.mitems:\n                    p.x = -p.x\n\
    \            let diagonal = direction mod 2\n            let size = sizes[diagonal]\n\
    \            for k in 0..size:\n                fenwick[k] = (low(int64), -1)\n\
    \            for p in sites:\n                var index = ranks[p.id][diagonal]\n\
    \                # x-y, -(x+y), -(x-y), -(x+y)\u306E\u9806\u306B\u5727\u7E2E\u6E08\
    \u307F\u306E\u9806\u4F4D\u3092\u4F7F\u3046\u3002\n                if direction\
    \ != 0:\n                    index = size + 1 - index\n                var best\
    \ = (score: low(int64), id: -1)\n                var k = index\n             \
    \   while k > 0:\n                    if fenwick[k].score > best.score:\n    \
    \                    best = fenwick[k]\n                    k -= k and -k\n  \
    \              let score = p.x + p.y\n                if best.id >= 0:\n     \
    \               candidates.add((score - best.score, p.id, best.id))\n        \
    \        k = index\n                while k <= size:\n                    # \u7956\
    \u5148\u306E\u6700\u5927\u5024\u3082\u3053\u308C\u4EE5\u4E0A\u306A\u306E\u3067\
    \u3001\u66F4\u65B0\u4E0D\u8981\u306A\u3089\u6253\u3061\u5207\u308C\u308B\u3002\
    \n                    if score <= fenwick[k].score:\n                        break\n\
    \                    fenwick[k] = (score, p.id)\n                    k += k and\
    \ -k\n\n        candidates.sort(proc(a, b: tuple[weight: int64, u, v: int]): int\
    \ = cmp(a.weight, b.weight))\n        for edge in candidates:\n            if\
    \ not uf.issame(edge.u, edge.v):\n                uf.unite(edge.u, edge.v)\n \
    \               result.add((min(edge.u, edge.v), max(edge.u, edge.v)))\n     \
    \           if uf.count == 1:\n                    break\n\n    proc manhattan_mst*[T:\
    \ SomeSignedInt](points: openArray[(T, T)]): seq[(int, int)] =\n        ## \u5EA7\
    \u6A19\u306E\u7D44\u304B\u3089\u30DE\u30F3\u30CF\u30C3\u30BF\u30F3\u6700\u5C0F\
    \u5168\u57DF\u6728\u3092\u6C42\u3081\u308B\u3002\u5236\u7D04\u3068\u8A08\u7B97\
    \u91CF\u306FPoint\u7248\u3068\u540C\u3058\u3002\n        var converted = newSeq[Point[T]](points.len)\n\
    \        for i, p in points:\n            converted[i] = initPoint(p)\n      \
    \  manhattan_mst(converted)\n"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: false
  path: cplib/geometry/manhattan_mst.nim
  requiredBy: []
  timestamp: '2026-09-30 07:06:44+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/manhattan_mst_test.nim
  - verify/geometry/manhattan_mst_test.nim
  - verify/geometry/manhattan_mst_random_test.nim
  - verify/geometry/manhattan_mst_random_test.nim
documentation_of: cplib/geometry/manhattan_mst.nim
layout: document
redirect_from:
- /library/cplib/geometry/manhattan_mst.nim
- /library/cplib/geometry/manhattan_mst.nim.html
title: cplib/geometry/manhattan_mst.nim
---
