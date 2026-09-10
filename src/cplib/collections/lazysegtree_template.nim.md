---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazysegtree_template_test.nim
    title: verify/AI/lazysegtree_template_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazysegtree_template_test.nim
    title: verify/AI/lazysegtree_template_test.nim
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
  code: "## \u3088\u304F\u4F7F\u3046\u533A\u9593\u66F4\u65B0\u30FB\u533A\u9593\u53D6\
    \u5F97\u3092static_op\u7248\u306E\u9045\u5EF6\u30BB\u30B0\u6728\u3067\u63D0\u4F9B\
    \u3057\u307E\u3059\u3002\n## \u64CD\u4F5C\u306B\u306Fcplib/collections/lazysegtree_static_op\u3082\
    import\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n## \u914D\u5217\u304B\u3089\u521D\
    \u671F\u5316\u3057\u3001apply(l, r, f)\u3067\u534A\u958B\u533A\u9593[l, r)\u3092\
    \u66F4\u65B0\u3057\u307E\u3059\u3002\n## get(l, r)\u307E\u305F\u306Fseg[l..<r]\u3067\
    \u53D6\u5F97\u3067\u304D\u3001\u30B9\u30E9\u30A4\u30B9\u3067\u306Eapply\u3082\u4F7F\
    \u7528\u3067\u304D\u307E\u3059\u3002\n## Index\u7248\u306E\u6975\u5024\u306F.value\u3068\
    .index\uFF08\u540C\u5024\u306A\u3089\u6700\u5DE6\u30010\u59CB\u307E\u308A\uFF09\
    \u3001\u548C\u306F.sum\u3067\u53D6\u5F97\u3057\u307E\u3059\u3002\n## Index\u7248\
    \u306E\u7A7A\u533A\u9593\u306E\u6975\u5024\u306Findex = -1\uFF08value\u306F\u672A\
    \u5B9A\u7FA9\u6271\u3044\uFF09\u3001\u548C\u306Fsum = 0, len = 0\u3067\u3059\u3002\
    \n## Index\u7248\u306E\u6975\u5024\u306E.left\u306F\u533A\u9593\u5DE6\u7AEF\u3067\
    \u3001\u533A\u9593\u5909\u66F4\u6642\u306E\u4F4D\u7F6E\u5FA9\u5143\u306B\u4F7F\
    \u7528\u3057\u307E\u3059\u3002\n## \u4E00\u70B9\u4EE3\u5165\u306FIndex\u7248\u306E\
    \u6975\u5024\u306A\u3089seg[p] = (value, p, p)\u3001\u548C\u306A\u3089seg[p] =\
    \ (value, 1)\u3067\u3059\u3002\n## \u6975\u5024\u306E\u521D\u671F\u5316\u95A2\u6570\
    \u306F\u672B\u5C3EIndex\u4ED8\u304D\u304C\u4F4D\u7F6E\u3092\u4FDD\u6301\u3057\u3001\
    \u672B\u5C3E\u306A\u3057\u306FT\u306E\u5024\u3092\u76F4\u63A5\u8FD4\u3057\u307E\
    \u3059\u3002\n## \u4F4D\u7F6E\u306A\u3057\u7248\u306FT.high/T.low\u3092\u6301\u3064\
    \u6570\u5024\u578B\u5411\u3051\u3067\u3001\u7A7A\u533A\u9593\u306F\u6700\u5C0F\
    \u5024\u306A\u3089T.high\u3001\u6700\u5927\u5024\u306A\u3089T.low\u3067\u3059\u3002\
    \n## \u4F4D\u7F6E\u306A\u3057\u7248\u306E\u4E00\u70B9\u4EE3\u5165\u306Fseg[p]\
    \ = value\u3067\u3059\u3002\n## \u4E00\u6B21\u95A2\u6570\u4F5C\u7528\u306E\u66F4\
    \u65B0\u5024\u306F(a, b)\u3067\u3001\u5404\u8981\u7D20x\u3092a*x+b\u306B\u5909\
    \u66F4\u3057\u307E\u3059\u3002\n## T\u306E\u30C7\u30D5\u30A9\u30EB\u30C8\u5024\
    \u30920\u3068\u3057\u3066\u6271\u3044\u307E\u3059\u3002\u548C\u306E\u578B\u306F\
    T\u3067\u3001\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u306B\u6CE8\u610F\u3057\
    \u3066\u304F\u3060\u3055\u3044\u3002\n## \u4F7F\u7528\u4F8B:\n##   var seg = initRangeAssignRangeMinIndex(@[3,\
    \ 1, 4])\n##   seg.apply(0, 3, 2)\n##   assert seg.get(1, 3).index == 1\n##  \
    \ var sums = initRangeAffineRangeSum(@[1, 2, 3])\n##   sums.apply(0, 3, (2, 1))\n\
    ##   assert sums.get(0, 3).sum == 15\nwhen not declared CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE:\n\
    \    const CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE* = 1\n    import cplib/collections/lazysegtree_static_op\n\
    \n    type\n        RangeExtremum*[T] = tuple[value: T, index: int, left: int]\n\
    \        RangeSum*[T] = tuple[sum: T, len: int]\n        RangeAffine*[T] = tuple[a,\
    \ b: T]\n\n    proc initRangeExtremumTreeIndex[T; isMin, isAssign: static[bool]](v:\
    \ openArray[T]): auto =\n        ## \u6975\u5024\u3068\u6700\u5DE6\u4F4D\u7F6E\
    \u3092\u4FDD\u6301\u3059\u308B\u9045\u5EF6\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002\n        proc merge(l, r: RangeExtremum[T]): RangeExtremum[T]\
    \ =\n            ## \u7A7A\u533A\u9593\u3092\u9664\u5916\u3057\u3066\u6975\u5024\
    \u3068\u6700\u5DE6\u4F4D\u7F6E\u3092\u30DE\u30FC\u30B8\u3057\u307E\u3059\u3002\
    O(1)\u3002\n            if l.index < 0: return r\n            if r.index < 0:\
    \ return l\n            when isMin:\n                result = if r.value < l.value:\
    \ r else: l\n            else:\n                result = if l.value < r.value:\
    \ r else: l\n            result.left = l.left\n        proc mapping(f: T, x: RangeExtremum[T]):\
    \ RangeExtremum[T] =\n            ## \u533A\u9593\u52A0\u7B97\u307E\u305F\u306F\
    \u533A\u9593\u5909\u66F4\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002O(1)\u3002\
    \n            result = x\n            if x.index < 0: return\n            when\
    \ isAssign:\n                result.value = f\n                result.index =\
    \ x.left\n            else:\n                result.value = x.value + f\n    \
    \    proc composition(f, g: T): T =\n            ## g\u306E\u5F8C\u306Bf\u3092\
    \u4F5C\u7528\u3055\u305B\u308B\u66F4\u65B0\u3092\u5408\u6210\u3057\u307E\u3059\
    \u3002O(1)\u3002\n            when isAssign: f\n            else: f + g\n    \
    \    var nodes = newSeq[RangeExtremum[T]](v.len)\n        for i, value in v:\n\
    \            nodes[i] = (value, i, i)\n        initLazySegmentTree[RangeExtremum[T],\
    \ T](\n            nodes, merge, (default(T), -1, -1), mapping, composition, default(T))\n\
    \n    proc initRangeAddRangeMinIndex*[T](v: openArray[T]): auto =\n        ##\
    \ \u533A\u9593\u52A0\u7B97\u30FB\u533A\u9593\u6700\u5C0F\u5024\u3068\u6700\u5DE6\
    \u4F4D\u7F6E\u306E\u53D6\u5F97\u7528\u3002\u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log\
    \ N)\u3002\n        initRangeExtremumTreeIndex[T, true, false](v)\n\n    proc\
    \ initRangeAddRangeMaxIndex*[T](v: openArray[T]): auto =\n        ## \u533A\u9593\
    \u52A0\u7B97\u30FB\u533A\u9593\u6700\u5927\u5024\u3068\u6700\u5DE6\u4F4D\u7F6E\
    \u306E\u53D6\u5F97\u7528\u3002\u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\
    \n        initRangeExtremumTreeIndex[T, false, false](v)\n\n    proc initRangeAssignRangeMinIndex*[T](v:\
    \ openArray[T]): auto =\n        ## \u533A\u9593\u5909\u66F4\u30FB\u533A\u9593\
    \u6700\u5C0F\u5024\u3068\u6700\u5DE6\u4F4D\u7F6E\u306E\u53D6\u5F97\u7528\u3002\
    \u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\n        initRangeExtremumTreeIndex[T,\
    \ true, true](v)\n\n    proc initRangeAssignRangeMaxIndex*[T](v: openArray[T]):\
    \ auto =\n        ## \u533A\u9593\u5909\u66F4\u30FB\u533A\u9593\u6700\u5927\u5024\
    \u3068\u6700\u5DE6\u4F4D\u7F6E\u306E\u53D6\u5F97\u7528\u3002\u69CB\u7BC9O(N)\u3001\
    \u64CD\u4F5CO(log N)\u3002\n        initRangeExtremumTreeIndex[T, false, true](v)\n\
    \n    proc initRangeExtremumTree[T; isMin, isAssign: static[bool]](v: openArray[T]):\
    \ auto =\n        ## \u4F4D\u7F6E\u3092\u6301\u305F\u305A\u6975\u5024\u306E\u307F\
    \u3092\u4FDD\u6301\u3059\u308B\u9045\u5EF6\u30BB\u30B0\u6728\u3092O(N)\u3067\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002\n        proc merge(l, r: T): T =\n           \
    \ ## \u4E8C\u3064\u306E\u533A\u9593\u306E\u6975\u5024\u3092\u30DE\u30FC\u30B8\u3057\
    \u307E\u3059\u3002O(1)\u3002\n            when isMin: min(l, r)\n            else:\
    \ max(l, r)\n        proc mapping(f, x: T): T =\n            ## \u533A\u9593\u52A0\
    \u7B97\u307E\u305F\u306F\u533A\u9593\u5909\u66F4\u3092\u4F5C\u7528\u3055\u305B\
    \u307E\u3059\u3002O(1)\u3002\n            when isAssign: f\n            else:\
    \ x + f\n        proc composition(f, g: T): T =\n            ## g\u306E\u5F8C\u306B\
    f\u3092\u4F5C\u7528\u3055\u305B\u308B\u66F4\u65B0\u3092\u5408\u6210\u3057\u307E\
    \u3059\u3002O(1)\u3002\n            when isAssign: f\n            else: f + g\n\
    \        var nodes = newSeq[T](v.len)\n        for i, value in v:\n          \
    \  nodes[i] = value\n        when isMin:\n            let identity = T.high\n\
    \        else:\n            let identity = T.low\n        initLazySegmentTree[T,\
    \ T](\n            nodes, merge, identity, mapping, composition, default(T))\n\
    \n    proc initRangeAddRangeMin*[T](v: openArray[T]): auto =\n        ## \u533A\
    \u9593\u52A0\u7B97\u30FB\u533A\u9593\u6700\u5C0F\u5024\u53D6\u5F97\u7528\uFF08\
    \u4F4D\u7F6E\u306A\u3057\uFF09\u3002\u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\
    \n        initRangeExtremumTree[T, true, false](v)\n\n    proc initRangeAddRangeMax*[T](v:\
    \ openArray[T]): auto =\n        ## \u533A\u9593\u52A0\u7B97\u30FB\u533A\u9593\
    \u6700\u5927\u5024\u53D6\u5F97\u7528\uFF08\u4F4D\u7F6E\u306A\u3057\uFF09\u3002\
    \u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\n        initRangeExtremumTree[T,\
    \ false, false](v)\n\n    proc initRangeAssignRangeMin*[T](v: openArray[T]): auto\
    \ =\n        ## \u533A\u9593\u5909\u66F4\u30FB\u533A\u9593\u6700\u5C0F\u5024\u53D6\
    \u5F97\u7528\uFF08\u4F4D\u7F6E\u306A\u3057\uFF09\u3002\u69CB\u7BC9O(N)\u3001\u64CD\
    \u4F5CO(log N)\u3002\n        initRangeExtremumTree[T, true, true](v)\n\n    proc\
    \ initRangeAssignRangeMax*[T](v: openArray[T]): auto =\n        ## \u533A\u9593\
    \u5909\u66F4\u30FB\u533A\u9593\u6700\u5927\u5024\u53D6\u5F97\u7528\uFF08\u4F4D\
    \u7F6E\u306A\u3057\uFF09\u3002\u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\
    \n        initRangeExtremumTree[T, false, true](v)\n\n    proc initRangeSumTree[T;\
    \ mode: static[int]](v: openArray[T]): auto =\n        ## \u548C\u3068\u533A\u9593\
    \u9577\u3092\u4FDD\u6301\u3059\u308B\u9045\u5EF6\u30BB\u30B0\u6728\u3092O(N)\u3067\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002\n        when mode == 2:\n            type\
    \ F = RangeAffine[T]\n        else:\n            type F = T\n        proc merge(l,\
    \ r: RangeSum[T]): RangeSum[T] =\n            ## \u548C\u3068\u533A\u9593\u9577\
    \u3092\u30DE\u30FC\u30B8\u3057\u307E\u3059\u3002O(1)\u3002\n            (l.sum\
    \ + r.sum, l.len + r.len)\n        proc mapping(f: F, x: RangeSum[T]): RangeSum[T]\
    \ =\n            ## \u533A\u9593\u306E\u5404\u8981\u7D20\u3078\u306E\u66F4\u65B0\
    \u3092\u548C\u306B\u53CD\u6620\u3057\u307E\u3059\u3002O(1)\u3002\n           \
    \ template scale(value: T): T =\n                ## \u533A\u9593\u9577\u3092\u639B\
    \u3051\u3001\u7D44\u307F\u8FBC\u307F\u6570\u5024\u578B\u3068modint\u306E\u53CC\
    \u65B9\u306B\u5BFE\u5FDC\u3057\u307E\u3059\u3002O(1)\u3002\n                when\
    \ T is SomeNumber: value * T(x.len)\n                else: value * x.len\n   \
    \         if x.len == 0: return x\n            when mode == 0: (x.sum + scale(f),\
    \ x.len)\n            elif mode == 1: (scale(f), x.len)\n            else: (f.a\
    \ * x.sum + scale(f.b), x.len)\n        proc composition(f, g: F): F =\n     \
    \       ## g\u306E\u5F8C\u306Bf\u3092\u4F5C\u7528\u3055\u305B\u308B\u66F4\u65B0\
    \u3092\u5408\u6210\u3057\u307E\u3059\u3002O(1)\u3002\n            when mode ==\
    \ 0: f + g\n            elif mode == 1: f\n            else: (f.a * g.a, f.a *\
    \ g.b + f.b)\n        var nodes = newSeq[RangeSum[T]](v.len)\n        for i, value\
    \ in v:\n            nodes[i] = (value, 1)\n        initLazySegmentTree[RangeSum[T],\
    \ F](\n            nodes, merge, (default(T), 0), mapping, composition, default(F))\n\
    \n    proc initRangeAddRangeSum*[T](v: openArray[T]): auto =\n        ## \u533A\
    \u9593\u52A0\u7B97\u30FB\u533A\u9593\u548C\u53D6\u5F97\u7528\u3002\u69CB\u7BC9\
    O(N)\u3001\u64CD\u4F5CO(log N)\u3002\n        initRangeSumTree[T, 0](v)\n\n  \
    \  proc initRangeAssignRangeSum*[T](v: openArray[T]): auto =\n        ## \u533A\
    \u9593\u5909\u66F4\u30FB\u533A\u9593\u548C\u53D6\u5F97\u7528\u3002\u69CB\u7BC9\
    O(N)\u3001\u64CD\u4F5CO(log N)\u3002\n        initRangeSumTree[T, 1](v)\n\n  \
    \  proc initRangeAffineRangeSum*[T](v: openArray[T]): auto =\n        ## \u533A\
    \u9593\u4E00\u6B21\u95A2\u6570\u4F5C\u7528x\u2192a*x+b\u30FB\u533A\u9593\u548C\
    \u53D6\u5F97\u7528\u3002\u69CB\u7BC9O(N)\u3001\u64CD\u4F5CO(log N)\u3002\n   \
    \     initRangeSumTree[T, 2](v)\n"
  dependsOn:
  - cplib/collections/lazysegtree_static_op.nim
  - cplib/collections/lazysegtree_static_op.nim
  isVerificationFile: false
  path: cplib/collections/lazysegtree_template.nim
  requiredBy: []
  timestamp: '2026-09-11 05:37:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lazysegtree_template_test.nim
  - verify/AI/lazysegtree_template_test.nim
documentation_of: cplib/collections/lazysegtree_template.nim
layout: document
redirect_from:
- /library/cplib/collections/lazysegtree_template.nim
- /library/cplib/collections/lazysegtree_template.nim.html
title: cplib/collections/lazysegtree_template.nim
---
