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
    path: verify/graph/remove_edge_test.nim
    title: verify/graph/remove_edge_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/remove_edge_test.nim
    title: verify/graph/remove_edge_test.nim
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
  code: "when not declared CPLIB_GRAPH_REMOVE_EDGE:\n    const CPLIB_GRAPH_REMOVE_EDGE*\
    \ = 1\n    import cplib/graph/graph\n\n    proc remove_edge*[G: DynamicGraphTypes\
    \ or StaticGraphTypes](g: G, id: int): G =\n        ## \u8FBA\u756A\u53F7 id \u306E\
    \u4E00\u8FBA\u3092\u9664\u3044\u305F\u65B0\u3057\u3044\u30B0\u30E9\u30D5\u3092\
    \u8FD4\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593 O(V + E)\u3002\n        ## \u5143\
    \u306F\u5909\u66F4\u305B\u305A\u3001\u6B8B\u308B\u8FBA\u306F\u8FFD\u52A0\u9806\
    \u306B 0 \u304B\u3089\u63A1\u756A\u3059\u308B\u3002\u9759\u7684\u30B0\u30E9\u30D5\
    \u306F\u69CB\u7BC9\u6E08\u307F\u3067\u8FD4\u3059\u3002\n        if id < 0 or id\
    \ >= g.edge_count:\n            raise newException(ValueError, \"\u8FBA\u756A\u53F7\
    \u306F 0 \u4EE5\u4E0A\u3001\u8FBA\u6570\u672A\u6E80\u3067\u6307\u5B9A\u3057\u3066\
    \u304F\u3060\u3055\u3044\")\n        new(result)\n        result.len = g.len\n\
    \        when G is DynamicGraphTypes:\n            result.edges.setLen(g.len)\n\
    \        for edgeId, e in g.edge_info:\n            if edgeId == id: continue\n\
    \            when G is UnWeightedGraph:\n                result.add_edge(e.src,\
    \ e.dst)\n            else:\n                result.add_edge(e.src, e.dst, e.cost)\n\
    \        when G is StaticGraphTypes:\n            result.build()\n\n    iterator\
    \ remove_each_edge*[G: DynamicGraphTypes or StaticGraphTypes](g: G): G =\n   \
    \     ## \u5404\u8FBA\u3092\u4E00\u672C\u305A\u3064\u9664\u3044\u305F\u65B0\u3057\
    \u3044\u30B0\u30E9\u30D5\u3092\u8FBA\u756A\u53F7\u9806\u306B\u5217\u6319\u3059\
    \u308B\u3002\u4E00\u4EF6 O(V + E)\u3001\u540C\u578B\u306E\u91CD\u8907\u306F\u9664\
    \u304B\u306A\u3044\u3002\n        for id in 0..<g.edge_count:\n            yield\
    \ g.remove_edge(id)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/remove_edge.nim
  requiredBy: []
  timestamp: '2026-10-27 08:51:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/remove_edge_test.nim
  - verify/graph/remove_edge_test.nim
documentation_of: cplib/graph/remove_edge.nim
layout: document
redirect_from:
- /library/cplib/graph/remove_edge.nim
- /library/cplib/graph/remove_edge.nim.html
title: cplib/graph/remove_edge.nim
---
