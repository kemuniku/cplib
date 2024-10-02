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
    path: verify/tree/rerooting_big_test.nim
    title: verify/tree/rerooting_big_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/rerooting_big_test.nim
    title: verify/tree/rerooting_big_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/rerooting_test.nim
    title: verify/tree/rerooting_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/rerooting_test.nim
    title: verify/tree/rerooting_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://trap.jp/post/1702/
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# https://trap.jp/post/1702/ \u3092\u53C2\u8003\u306B\u4F5C\u6210\nwhen not\
    \ declared CPLIB_TREE_REROOTING:\n    const CPLIB_TREE_REROOTING* = 1\n    import\
    \ cplib/graph/graph\n    import sequtils\n    proc solve_Rerooting*[E,V](G:UnWeightedUnDirectedGraph,merge\
    \ : proc(a,b:E):E,e:E,put_edge : proc(x:V,u,v:int):E,put_vertex : proc(x:E,v:int):V):seq[V]=\n\
    \        ## \u30E2\u30CE\u30A4\u30C9\u306E\u578B E   DP\u306E\u5024\u306E\u578B\
    \ V\n        ## merge:\u30E2\u30CE\u30A4\u30C9\u540C\u58EB\u306E\u30DE\u30FC\u30B8\
    \n        ## e:\u5358\u4F4D\u5143\n        ## put_edge \u8FBAu,v\u9593\u306E\u8FBA\
    \u60C5\u5831\u3092\u4ED8\u4E0E(\u9077\u79FB\u3055\u305B\u308B\u3068\u304D\u306B\
    \u3064\u3051\u305F\u3044\u3084\u3064)\n        ## put_vertex \u9802\u70B9v\u306E\
    \u9802\u70B9\u60C5\u5831\u3092\u4ED8\u4E0E(DP\u306E\u7D50\u679C\u306E\u5024\u3092\
    \u78BA\u5B9A\u3055\u305B\u308B\u3068\u304D\u306B\u3064\u3051\u305F\u3044\u3084\
    \u3064)\n        var values = newseq[seq[E]](len(G))\n        var L = newseq[seq[E]](len(G))\n\
    \        var R = newseq[seq[E]](len(G))\n        var res = newseq[V](len(G))\n\
    \        proc dfs1(x,p:int):E=\n            var values : seq[E]\n            values.add(e)\n\
    \            for y in G[x]:\n                if y != p:\n                    values.add(put_edge(put_vertex(dfs1(y,x),y),x,y))\n\
    \            values.add(e)\n            var now = e\n            var l = newseq[E](len(values))\n\
    \            var r = newseq[E](len(values))\n            for i in 0..<(len(values)):\n\
    \                now = merge(now,values[i])\n                l[i] = now\n    \
    \        now = e\n            for i in countdown((len(values))-1,0,1):\n     \
    \           now = merge(values[i],now)\n                r[i] = now\n         \
    \   L[x] = move(l)\n            R[x] = move(r)\n            return now\n     \
    \   res[0] = put_vertex(dfs1(0,-1),0)\n        proc dfs2(x,p:int,value:E)=\n \
    \           if p == -1:\n                var i = 0\n                for y in G[x]:\n\
    \                    dfs2(y,x,put_edge(put_vertex(merge(L[x][i],R[x][i+2]),x),x,y))\n\
    \                    i += 1\n            else:\n                res[x] = put_vertex(merge(L[x][^1],value),x)\n\
    \                var i = 0\n                for y in G[x]:\n                 \
    \   if y != p:\n                        dfs2(y,x,put_edge(put_vertex(merge(merge(L[x][i],R[x][i+2]),value),x),x,y))\n\
    \                        i += 1\n        dfs2(0,-1,e)\n        return res"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/rerooting.nim
  requiredBy: []
  timestamp: '2024-10-02 20:53:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/rerooting_big_test.nim
  - verify/tree/rerooting_big_test.nim
  - verify/tree/rerooting_test.nim
  - verify/tree/rerooting_test.nim
documentation_of: cplib/tree/rerooting.nim
layout: document
redirect_from:
- /library/cplib/tree/rerooting.nim
- /library/cplib/tree/rerooting.nim.html
title: cplib/tree/rerooting.nim
---
