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
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/euclidean_mst_test.nim
    title: verify/AI/euclidean_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/euclidean_mst_test.nim
    title: verify/AI/euclidean_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/euclidean_mst_test.nim
    title: verify/geometry/euclidean_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/euclidean_mst_test.nim
    title: verify/geometry/euclidean_mst_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_EUCLIDEAN_MST:\n    const CPLIB_GEOMETRY_EUCLIDEAN_MST*\
    \ = 1\n    import algorithm\n    import cplib/geometry/base\n    import cplib/collections/unionfind\n\
    \    import cplib/math/int128\n\n    type EuclideanMstQuadEdge = object\n    \
    \    next: array[4, int]\n        vertex: array[2, int]\n\n    proc euclidean_mst*[T:\
    \ SomeSignedInt](points: openArray[Point[T]]): seq[(int, int)] =\n        ## \u5E73\
    \u9762\u4E0A\u306E\u70B9\u306E\u30E6\u30FC\u30AF\u30EA\u30C3\u30C9\u6700\u5C0F\
    \u5168\u57DF\u6728\u3092\u3001\u5165\u529B\u306E\u9802\u70B9\u756A\u53F7\u306E\
    \u7D44\u3067\u8FD4\u3059\u3002O(N log N)\u6642\u9593\u3001O(N)\u9818\u57DF\u3002\
    \n        ## \u5EA7\u6A19\u306F\u7D76\u5BFE\u502410^9\u4EE5\u4E0B\u306E\u7B26\u53F7\
    \u4ED8\u304D\u6574\u6570\u3002\u91CD\u8907\u70B9\u3082\u5225\u9802\u70B9\u3068\
    \u3057\u3066\u6271\u3044\u3001N <= 1\u306A\u3089\u7A7A\u5217\u3092\u8FD4\u3059\
    \u3002\n        ## \u5E7E\u4F55\u5224\u5B9A\u306F\u6574\u6570\u3067\u53B3\u5BC6\
    \u306B\u884C\u3046\u3002Int128\u3092\u4F7F\u3046\u305F\u3081C++\u30D0\u30C3\u30AF\
    \u30A8\u30F3\u30C9\u304C\u5FC5\u8981\u3002\n        var sortedPoints = newSeq[tuple[x,\
    \ y: int64, id: int]](points.len)\n        for i, p in points:\n            let\
    \ x = int64(p.x)\n            let y = int64(p.y)\n            assert -1_000_000_000'i64\
    \ <= x and x <= 1_000_000_000'i64,\n                \"x\u5EA7\u6A19\u306E\u7D76\
    \u5BFE\u5024\u306F10^9\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n            assert -1_000_000_000'i64 <= y and y <= 1_000_000_000'i64,\n\
    \                \"y\u5EA7\u6A19\u306E\u7D76\u5BFE\u5024\u306F10^9\u4EE5\u4E0B\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n            sortedPoints[i]\
    \ = (x, y, i)\n        if points.len <= 1:\n            return @[]\n        sortedPoints.sort()\n\
    \        result = newSeqOfCap[(int, int)](points.len - 1)\n        var sites =\
    \ newSeqOfCap[tuple[x, y: int64, id: int]](points.len)\n        for p in sortedPoints:\n\
    \            if sites.len > 0 and sites[^1].x == p.x and sites[^1].y == p.y:\n\
    \                result.add((sites[^1].id, p.id))\n            else:\n       \
    \         sites.add(p)\n        if sites.len == 1:\n            return\n\n   \
    \     var edges = newSeqOfCap[EuclideanMstQuadEdge](3 * sites.len)\n        var\
    \ unused: seq[int]\n\n        proc rotate(e: int): int =\n            ## \u8FBA\
    \u3092\u53CC\u5BFE\u5074\u307890\u5EA6\u56DE\u8EE2\u3059\u308B\u3002\n       \
    \     (e and not 3) or ((e + 1) and 3)\n\n        proc onext(e: int): int =\n\
    \            ## \u540C\u3058\u59CB\u70B9\u3092\u6301\u3064\u6B21\u306E\u53CD\u6642\
    \u8A08\u56DE\u308A\u306E\u8FBA\u3092\u8FD4\u3059\u3002\n            edges[e shr\
    \ 2].next[e and 3]\n\n        proc origin(e: int): int =\n            ## \u6709\
    \u5411\u8FBA\u306E\u59CB\u70B9\u3092\u8FD4\u3059\u3002\n            edges[e shr\
    \ 2].vertex[(e shr 1) and 1]\n\n        proc destination(e: int): int =\n    \
    \        ## \u6709\u5411\u8FBA\u306E\u7D42\u70B9\u3092\u8FD4\u3059\u3002\n   \
    \         origin(e xor 2)\n\n        proc oprev(e: int): int =\n            ##\
    \ \u540C\u3058\u59CB\u70B9\u3092\u6301\u3064\u6B21\u306E\u6642\u8A08\u56DE\u308A\
    \u306E\u8FBA\u3092\u8FD4\u3059\u3002\n            rotate(onext(rotate(e)))\n\n\
    \        proc lnext(e: int): int =\n            ## \u5DE6\u5074\u306E\u9762\u306E\
    \u5883\u754C\u306B\u6CBF\u3063\u3066\u6B21\u306E\u8FBA\u3092\u8FD4\u3059\u3002\
    \n            rotate(onext(rotate(e) xor 2))\n\n        proc splice(a, b: int)\
    \ =\n            ## 2\u8FBA\u306E\u59CB\u70B9\u5468\u308A\u306E\u63A5\u7D9A\u3068\
    \u53CC\u5BFE\u5074\u306E\u63A5\u7D9A\u3092\u4EA4\u63DB\u3059\u308B\u3002\n   \
    \         let alpha = rotate(onext(a))\n            let beta = rotate(onext(b))\n\
    \            swap(edges[a shr 2].next[a and 3], edges[b shr 2].next[b and 3])\n\
    \            swap(edges[alpha shr 2].next[alpha and 3], edges[beta shr 2].next[beta\
    \ and 3])\n\n        proc makeEdge(u, v: int): int =\n            ## \u5B64\u7ACB\
    \u3057\u305F\u8FBA\u3092\u4F5C\u308B\u3002\u524A\u9664\u6E08\u307F\u9818\u57DF\
    \u3092\u518D\u5229\u7528\u3057\u3066\u9818\u57DF\u3092O(N)\u306B\u4FDD\u3064\u3002\
    \n            var index: int\n            if unused.len > 0:\n               \
    \ index = unused.pop()\n            else:\n                index = edges.len\n\
    \                edges.add(EuclideanMstQuadEdge())\n            result = index\
    \ shl 2\n            edges[index] = EuclideanMstQuadEdge(\n                next:\
    \ [result, result + 3, result + 2, result + 1], vertex: [u, v])\n\n        proc\
    \ connect(a, b: int): int =\n            ## a\u306E\u7D42\u70B9\u304B\u3089b\u306E\
    \u59CB\u70B9\u3078\u3001\u5171\u901A\u306E\u9762\u3092\u5206\u5272\u3059\u308B\
    \u8FBA\u3092\u8FFD\u52A0\u3059\u308B\u3002\n            result = makeEdge(destination(a),\
    \ origin(b))\n            splice(result, lnext(a))\n            splice(result\
    \ xor 2, b)\n\n        proc removeEdge(e: int) =\n            ## \u8FBA\u3092\u4E21\
    \u7AEF\u306E\u63A5\u7D9A\u304B\u3089\u5916\u3057\u3066\u9818\u57DF\u3092\u56DE\
    \u53CE\u3059\u308B\u3002\n            splice(e, oprev(e))\n            splice(e\
    \ xor 2, oprev(e xor 2))\n            edges[e shr 2].vertex[0] = -1\n        \
    \    unused.add(e shr 2)\n\n        proc orientation(a, b, c: int): int64 =\n\
    \            ## 3\u70B9\u306E\u5411\u304D\u3092\u5916\u7A4D\u3067\u6C42\u3081\u308B\
    \u3002\u6B63\u306A\u3089\u53CD\u6642\u8A08\u56DE\u308A\u3002\n            (sites[b].x\
    \ - sites[a].x) * (sites[c].y - sites[a].y) -\n                (sites[b].y - sites[a].y)\
    \ * (sites[c].x - sites[a].x)\n\n        proc leftOf(p, e: int): bool =\n    \
    \        ## \u70B9\u304C\u6709\u5411\u8FBA\u306E\u5DE6\u5074\u306B\u3042\u308B\
    \u304B\u3092\u5224\u5B9A\u3059\u308B\u3002\n            orientation(origin(e),\
    \ destination(e), p) > 0\n\n        proc rightOf(p, e: int): bool =\n        \
    \    ## \u70B9\u304C\u6709\u5411\u8FBA\u306E\u53F3\u5074\u306B\u3042\u308B\u304B\
    \u3092\u5224\u5B9A\u3059\u308B\u3002\n            orientation(origin(e), destination(e),\
    \ p) < 0\n\n        proc inCircle(a, b, c, d: int): bool =\n            ## \u53CD\
    \u6642\u8A08\u56DE\u308A\u306E3\u70B9\u306E\u5916\u63A5\u5186\u306E\u5185\u90E8\
    \u306Bd\u304C\u3042\u308B\u304B\u3092\u53B3\u5BC6\u306B\u5224\u5B9A\u3059\u308B\
    \u3002\n            let ax = sites[a].x - sites[d].x\n            let ay = sites[a].y\
    \ - sites[d].y\n            let bx = sites[b].x - sites[d].x\n            let\
    \ by = sites[b].y - sites[d].y\n            let cx = sites[c].x - sites[d].x\n\
    \            let cy = sites[c].y - sites[d].y\n            let det = to_Int128(ax\
    \ * ax + ay * ay) * to_Int128(bx * cy - by * cx) -\n                to_Int128(bx\
    \ * bx + by * by) * to_Int128(ax * cy - ay * cx) +\n                to_Int128(cx\
    \ * cx + cy * cy) * to_Int128(ax * by - ay * bx)\n            det > 0\n\n    \
    \    proc triangulate(first, last: int): (int, int) =\n            ## \u534A\u958B\
    \u533A\u9593\u3092Delaunay\u5206\u5272\u3057\u3001\u5DE6\u53F3\u7AEF\u306E\u51F8\
    \u5305\u8FBA\u3092\u8FD4\u3059\u3002O(M log M)\u6642\u9593\u3002\n           \
    \ if last - first <= 3:\n                let a = makeEdge(first, first + 1)\n\
    \                if last - first == 2:\n                    return (a, a xor 2)\n\
    \                let b = makeEdge(first + 1, first + 2)\n                splice(a\
    \ xor 2, b)\n                let turn = orientation(first, first + 1, first +\
    \ 2)\n                if turn == 0:\n                    return (a, b xor 2)\n\
    \                let c = connect(b, a)\n                if turn > 0:\n       \
    \             return (a, b xor 2)\n                return (c xor 2, c)\n\n   \
    \         let middle = (first + last) shr 1\n            var (leftOuter, leftInner)\
    \ = triangulate(first, middle)\n            var (rightInner, rightOuter) = triangulate(middle,\
    \ last)\n            while true:\n                if leftOf(origin(rightInner),\
    \ leftInner):\n                    leftInner = lnext(leftInner)\n            \
    \    elif rightOf(origin(leftInner), rightInner):\n                    rightInner\
    \ = onext(rightInner xor 2)\n                else:\n                    break\n\
    \            var baseEdge = connect(rightInner xor 2, leftInner)\n           \
    \ if origin(leftInner) == origin(leftOuter):\n                leftOuter = baseEdge\
    \ xor 2\n            if origin(rightInner) == origin(rightOuter):\n          \
    \      rightOuter = baseEdge\n\n            while true:\n                var left\
    \ = onext(baseEdge xor 2)\n                if rightOf(destination(left), baseEdge):\n\
    \                    while inCircle(destination(baseEdge), origin(baseEdge),\n\
    \                            destination(left), destination(onext(left))):\n \
    \                       let next = onext(left)\n                        removeEdge(left)\n\
    \                        left = next\n                var right = oprev(baseEdge)\n\
    \                if rightOf(destination(right), baseEdge):\n                 \
    \   while inCircle(destination(baseEdge), origin(baseEdge),\n                \
    \            destination(right), destination(oprev(right))):\n               \
    \         let next = oprev(right)\n                        removeEdge(right)\n\
    \                        right = next\n                let leftValid = rightOf(destination(left),\
    \ baseEdge)\n                let rightValid = rightOf(destination(right), baseEdge)\n\
    \                if not leftValid and not rightValid:\n                    break\n\
    \                if not leftValid or (rightValid and inCircle(destination(left),\n\
    \                        origin(left), origin(right), destination(right))):\n\
    \                    baseEdge = connect(right, baseEdge xor 2)\n             \
    \   else:\n                    baseEdge = connect(baseEdge xor 2, left xor 2)\n\
    \            (leftOuter, rightOuter)\n\n        discard triangulate(0, sites.len)\n\
    \        var candidates = newSeqOfCap[tuple[weight: int64, u, v: int]](edges.len)\n\
    \        for e in edges:\n            if e.vertex[0] < 0:\n                continue\n\
    \            let u = e.vertex[0]\n            let v = e.vertex[1]\n          \
    \  let dx = sites[u].x - sites[v].x\n            let dy = sites[u].y - sites[v].y\n\
    \            candidates.add((dx * dx + dy * dy, u, v))\n        candidates.sort()\n\
    \        let uf = initUnionFind(sites.len)\n        for edge in candidates:\n\
    \            if not uf.issame(edge.u, edge.v):\n                uf.unite(edge.u,\
    \ edge.v)\n                let u = sites[edge.u].id\n                let v = sites[edge.v].id\n\
    \                result.add((min(u, v), max(u, v)))\n                if uf.count\
    \ == 1:\n                    break\n\n    proc euclidean_mst*[T: SomeSignedInt](points:\
    \ openArray[(T, T)]): seq[(int, int)] =\n        ## \u5EA7\u6A19\u306E\u7D44\u304B\
    \u3089\u30E6\u30FC\u30AF\u30EA\u30C3\u30C9\u6700\u5C0F\u5168\u57DF\u6728\u3092\
    \u6C42\u3081\u308B\u3002\u5236\u7D04\u3068\u8A08\u7B97\u91CF\u306FPoint\u7248\u3068\
    \u540C\u3058\u3002\n        var converted = newSeq[Point[T]](points.len)\n   \
    \     for i, p in points:\n            converted[i] = initPoint(p)\n        euclidean_mst(converted)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/int128.nim
  - cplib/collections/unionfind.nim
  - cplib/math/int128.nim
  - cplib/geometry/base.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: false
  path: cplib/geometry/euclidean_mst.nim
  requiredBy: []
  timestamp: '2026-09-27 01:45:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/euclidean_mst_test.nim
  - verify/geometry/euclidean_mst_test.nim
  - verify/AI/euclidean_mst_test.nim
  - verify/AI/euclidean_mst_test.nim
documentation_of: cplib/geometry/euclidean_mst.nim
layout: document
redirect_from:
- /library/cplib/geometry/euclidean_mst.nim
- /library/cplib/geometry/euclidean_mst.nim.html
title: cplib/geometry/euclidean_mst.nim
---
