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
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_negative_test.nim
    title: verify/AI/warshall_floyd_negative_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_negative_test.nim
    title: verify/AI/warshall_floyd_negative_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_test.nim
    title: verify/AI/warshall_floyd_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_test.nim
    title: verify/AI/warshall_floyd_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/warshall_floyd_aoj_test.nim
    title: verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/warshall_floyd_aoj_test.nim
    title: verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/warshall_floyd_aoj_test.nim
    title: verify/graph/static/warshall_floyd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/warshall_floyd_aoj_test.nim
    title: verify/graph/static/warshall_floyd_aoj_test.nim
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
  code: "when not declared CPLIB_GRAPH_WARSHALLFLOYD:\n    const CPLIB_GRAPH_WARSHALLFLOYD*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ sequtils\n    import cplib/graph/warshall_floyd_negative\n    proc warshall_floyd_inplace_run[T](d:\
    \ var seq[seq[T]], zero, inf: T): bool =\n        ## \u6B63\u65B9\u96A3\u63A5\u884C\
    \u5217\u3092\u6700\u77ED\u8DDD\u96E2\u3067\u4E0A\u66F8\u304D\u3057\u3001\u8CA0\
    \u9589\u8DEF\u306E\u6709\u7121\u3092\u8FD4\u3059\u3002O(V^3)\u3002\u8CA0\u9589\
    \u8DEF\u691C\u51FA\u6642\u306F\u9014\u4E2D\u306E\u884C\u5217\u3092\u6B8B\u3059\
    \u3002\n        let n = d.len\n        for i in 0..<n:\n            assert d[i].len\
    \ == n, \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        for i in 0..<n:\n      \
    \      d[i][i] = min(d[i][i], zero)\n        for i in 0..<n:\n            if d[i][i]\
    \ < zero:\n                return true\n        for k in 0..<n:\n            for\
    \ i in 0..<n:\n                for j in 0..<n:\n                    if d[i][k]\
    \ != inf and d[k][j] != inf:\n                        d[i][j] = min(d[i][j], d[i][k]\
    \ + d[k][j])\n            for i in 0..<n:\n                if d[i][i] < zero:\n\
    \                    return true\n        return false\n\n    proc warshall_floyd_inplace_impl[T](d:\
    \ var seq[seq[T]], zero, inf: T) =\n        ## \u8DDD\u96E2\u884C\u5217\u3092\u5B8C\
    \u6210\u3055\u305B\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u306B\u3059\u308B\u3002O(V^3)\u3002\n        if warshall_floyd_inplace_run(d,\
    \ zero, inf):\n            warshall_floyd_negative_finish(d, zero, inf, warshall_floyd_inplace_run[T])\n\
    \n    proc warshall_floyd_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero,\
    \ inf: T): seq[seq[T]] =\n        ## \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\
    \u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\
    \u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\n        result\
    \ = newSeqWith(g.len, newSeqWith(g.len, inf))\n        for i in 0..<g.len:\n \
    \           result[i][i] = zero\n            for (j, cost) in g.to_and_cost(i):\n\
    \                result[i][j] = min(result[i][j], cost)\n        warshall_floyd_inplace_impl(result,\
    \ zero, inf)\n\n    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int]\
    \ or UnWeightedGraph, zero: int = 0, inf: int = INF64): seq[seq[int]] =\n    \
    \    ## \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero,\
    \ inf)\n\n    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32],\
    \ zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =\n        ## \u5168\
    \u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\
    \u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F\
    -inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero, inf)\n\n \
    \   proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float\
    \ = 0.0, inf: float = 1e100): seq[seq[float]] =\n        ## \u5168\u70B9\u5BFE\
    \u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\
    \n        return warshall_floyd_impl(g, zero, inf)\n\n    proc warshall_floyd*(g:\
    \ DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf:\
    \ float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u5168\u70B9\u5BFE\u6700\
    \u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\
    \n        return warshall_floyd_impl(g, zero, inf)\n\n    proc warshall_floyd*[T](g:\
    \ WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =\n        ##\
    \ \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\
    \u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\
    \u306F-inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero, inf)\n\
    \n    proc warshall_floyd_matrix_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]]\
    \ =\n        ## \u6B63\u65B9\u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\
    \u6700\u77ED\u8DEF\u3092\u6C42\u3081\u308B\u3002\u6642\u9593O(V^3)\u3001\u8FFD\
    \u52A0\u9818\u57DFO(V^2)\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\
    \u3002\n        var d = newSeqWith(a.len, newSeqWith(a.len, inf))\n        for\
    \ i in 0..<a.len:\n            assert a[i].len == a.len, \"\u96A3\u63A5\u884C\u5217\
    \u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n            for j in 0..<a.len:\n                d[i][j] = a[i][j]\n\
    \        warshall_floyd_inplace_impl(d, zero, inf)\n        return d\n\n    proc\
    \ warshall_floyd*(a: seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]]\
    \ =\n        ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd*(a: seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32): seq[seq[int32]] =\n        ## \u96A3\u63A5\u884C\u5217\u304B\
    \u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\
    \u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\
    \u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\
    \u3002\n        return warshall_floyd_matrix_impl(a, zero, inf)\n\n    proc warshall_floyd*(a:\
    \ seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =\n\
    \        ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd*(a: seq[seq[float32]], zero: float32 =\
    \ 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u96A3\u63A5\
    \u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092O(V^3)\u3067\
    \u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\
    \u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\u306F\u5909\u66F4\
    \u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a, zero, inf)\n\
    \n    proc warshall_floyd*[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =\n \
    \       ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\
    \u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_run[T](d: var seq[seq[T]],\
    \ zero, inf: T) =\n        ## \u975E\u8CA0\u8FBA\u3092\u524D\u63D0\u306B\u3001\
    \u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3067\u8DDD\u96E2\u884C\u5217\u3092\
    \u66F4\u65B0\u3059\u308B\u3002O(V^3)\u3002\n        for k in 0..<d.len:\n    \
    \        for i in 0..<d.len:\n                if d[i][k] != inf:\n           \
    \         for j in 0..<d.len:\n                        if d[k][j] != inf:\n  \
    \                          d[i][j] = min(d[i][j], d[i][k] + d[k][j])\n\n    proc\
    \ warshall_floyd_nonnegative_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero,\
    \ inf: T): seq[seq[T]] =\n        ## \u975E\u8CA0\u8FBA\u306E\u30B0\u30E9\u30D5\
    \u304B\u3089\u8DDD\u96E2\u884C\u5217\u3092\u6C42\u3081\u308B\u3002\u6642\u9593\
    O(V^3)\u3001\u8FFD\u52A0\u9818\u57DFO(V^2)\u3002\n        result = newSeqWith(g.len,\
    \ newSeqWith(g.len, inf))\n        for i in 0..<g.len:\n            result[i][i]\
    \ = zero\n            for (j, cost) in g.to_and_cost(i):\n                result[i][j]\
    \ = min(result[i][j], cost)\n        warshall_floyd_nonnegative_run(result, zero,\
    \ inf)\n\n    proc warshall_floyd_nonnegative_inplace_impl[T](d: var seq[seq[T]],\
    \ zero, inf: T) =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u6B63\u65B9\
    \u96A3\u63A5\u884C\u5217\u3092\u6700\u77ED\u8DDD\u96E2\u3067\u4E0A\u66F8\u304D\
    \u3059\u308B\u3002O(V^3)\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3057\u3001\u8CA0\
    \u9589\u8DEF\u691C\u67FB\u306F\u884C\u308F\u306A\u3044\u3002\n        for i in\
    \ 0..<d.len:\n            assert d[i].len == d.len, \"\u96A3\u63A5\u884C\u5217\
    \u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        for i in 0..<d.len:\n            d[i][i] = zero\n    \
    \    warshall_floyd_nonnegative_run(d, zero, inf)\n\n    proc warshall_floyd_nonnegative_impl[T](a:\
    \ seq[seq[T]], zero, inf: T): seq[seq[T]] =\n        ## \u975E\u8CA0\u8FBA\u306E\
    \u6B63\u65B9\u96A3\u63A5\u884C\u5217\u304B\u3089\u8DDD\u96E2\u884C\u5217\u3092\
    \u6C42\u3081\u308B\u3002\u6642\u9593O(V^3)\u3001\u8FFD\u52A0\u9818\u57DFO(V^2)\u3002\
    \u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        result = newSeqWith(a.len,\
    \ newSeqWith(a.len, inf))\n        for i in 0..<a.len:\n            assert a[i].len\
    \ == a.len, \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n            for j in 0..<a.len:\n\
    \                result[i][j] = a[i][j]\n        warshall_floyd_nonnegative_inplace_impl(result,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*(g: DynamicGraph[int] or StaticGraph[int]\
    \ or UnWeightedGraph or seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]]\
    \ =\n        ## \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092\
    O(V^3)\u3067\u8FD4\u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306F\
    zero\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return\
    \ warshall_floyd_nonnegative_impl(g, zero, inf)\n\n    proc warshall_floyd_nonnegative*(g:\
    \ DynamicGraph[int32] or StaticGraph[int32] or seq[seq[int32]], zero: int32 =\
    \ 0.int32, inf: int32 = INF32): seq[seq[int32]] =\n        ## \u975E\u8CA0\u8FBA\
    \u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\u3002\
    \u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*(g: DynamicGraph[float] or\
    \ StaticGraph[float] or seq[seq[float]], zero: float = 0.0, inf: float = 1e100):\
    \ seq[seq[float]] =\n        ## \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\
    \u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\
    \u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\
    \n        return warshall_floyd_nonnegative_impl(g, zero, inf)\n\n    proc warshall_floyd_nonnegative*(g:\
    \ DynamicGraph[float32] or StaticGraph[float32] or seq[seq[float32]], zero: float32\
    \ = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u975E\u8CA0\
    \u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\
    \u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*[T](g: WeightedGraph[T] or\
    \ UnWeightedGraph or seq[seq[T]], zero, inf: T): seq[seq[T]] =\n        ## \u975E\
    \u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\
    \u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_inplace*(d: var seq[seq[int]], zero: int\
    \ = 0, inf: int = INF64) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf:\
    \ float = 1e100) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\
    \u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\u4E0D\
    \u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\
    \u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n    proc\
    \ warshall_floyd_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf:\
    \ float32 = 1e30'f32) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*[T](d: var seq[seq[T]], zero, inf: T) =\n   \
    \     ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\
    \u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\n     \
    \   warshall_floyd_inplace_impl(d, zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d:\
    \ var seq[seq[int]], zero: int = 0, inf: int = INF64) =\n        ## \u8CA0\u9589\
    \u8DEF\u304C\u306A\u3044\u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\
    \u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306F\
    inf\u3001\u5BFE\u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\
    \u3002\n        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)\n\n    proc\
    \ warshall_floyd_nonnegative_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32) =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\
    \u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\
    \u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\
    \u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float]],\
    \ zero: float = 0.0, inf: float = 1e100) =\n        ## \u8CA0\u9589\u8DEF\u304C\
    \u306A\u3044\u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\
    \u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\
    \u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n     \
    \   warshall_floyd_nonnegative_inplace_impl(d, zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d:\
    \ var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =\n\
    \        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\u63A5\u884C\u5217\u3092\
    O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\
    \u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\
    \u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*[T](d: var seq[seq[T]],\
    \ zero, inf: T) =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\u63A5\
    \u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\
    \u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\
    \u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n"
  dependsOn:
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/warshall_floyd.nim
  requiredBy: []
  timestamp: '2026-09-14 16:47:56+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/warshall_floyd_aoj_test.nim
  - verify/graph/static/warshall_floyd_aoj_test.nim
  - verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - verify/graph/dynamic/warshall_floyd_aoj_test.nim
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_test.nim
  - verify/AI/warshall_floyd_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
documentation_of: cplib/graph/warshall_floyd.nim
layout: document
redirect_from:
- /library/cplib/graph/warshall_floyd.nim
- /library/cplib/graph/warshall_floyd.nim.html
title: cplib/graph/warshall_floyd.nim
---
