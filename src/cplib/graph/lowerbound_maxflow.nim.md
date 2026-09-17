---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowerbound_maxflow_test.nim
    title: verify/AI/lowerbound_maxflow_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowerbound_maxflow_test.nim
    title: verify/AI/lowerbound_maxflow_test.nim
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
  code: "when not declared CPLIB_GRAPH_LOWERBOUND_MAXFLOW:\n    const CPLIB_GRAPH_LOWERBOUND_MAXFLOW*\
    \ = 1\n    import cplib/graph/maxflow\n\n    type\n        LowerBoundMaxFlowEdge*[Cap]\
    \ = object\n            src*, dst*: int\n            lower*, upper*, flow*: Cap\n\
    \        LowerBoundMaxFlow*[Cap] = object\n            n: int\n            edges:\
    \ seq[LowerBoundMaxFlowEdge[Cap]]\n            solved: bool\n\n    proc initLowerBoundMaxFlow*[Cap:\
    \ SomeSignedInt](n: int, capacityZero: Cap = 0): LowerBoundMaxFlow[Cap] =\n  \
    \      ## n\u9802\u70B9\u306E\u4E0B\u9650\u6D41\u91CF\u3064\u304D\u6700\u5927\u6D41\
    \u30B0\u30E9\u30D5\u3092\u69CB\u7BC9\u3059\u308B\u3002\u5BB9\u91CF\u578B\u306E\
    \u7701\u7565\u6642\u306Fint\u3002O(1)\u3002\n        ## capacityZero\u306F\u578B\
    \u63A8\u8AD6\u7528\u3002\u5BB9\u91CF\u578B\u306B\u306F\u7B26\u53F7\u3064\u304D\
    \u6574\u6570\u3092\u6307\u5B9A\u3059\u308B\u3002\n        assert n >= 0, \"n\u306F\
    \u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       result.n = n\n\n    proc add_edge*[Cap](g: var LowerBoundMaxFlow[Cap],\
    \ src, dst: int, lower, upper: Cap): int {.discardable.} =\n        ## \u6D41\u91CF\
    \u306E\u4E0B\u9650lower\u3001\u4E0A\u9650upper\u306E\u6709\u5411\u8FBA\u3092\u8FFD\
    \u52A0\u3057\u3001\u8FBA\u756A\u53F7\u3092\u8FD4\u3059\u3002\u511F\u5374O(1)\u3002\
    \n        assert src in 0..<g.n and dst in 0..<g.n, \"\u9802\u70B9\u756A\u53F7\
    \u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        assert Cap(0) <= lower and lower\
    \ <= upper, \"0 <= lower <= upper\u304C\u5FC5\u8981\u3067\u3059\"\n        result\
    \ = g.edges.len\n        g.edges.add(LowerBoundMaxFlowEdge[Cap](src: src, dst:\
    \ dst, lower: lower, upper: upper))\n        g.solved = false\n\n    proc flow*[Cap](g:\
    \ var LowerBoundMaxFlow[Cap], src, dst: int): Cap =\n        ## \u4E0B\u9650\u3092\
    \u6E80\u305F\u3059\u975E\u8CA0\u306Esrc-dst\u6700\u5927\u6D41\u91CF\u3092\u8FD4\
    \u3059\u3002\u5B9F\u73FE\u4E0D\u53EF\u80FD\u306A\u3089-1\u3002O(V^2(V+E))\u3002\
    \n        ## \u547C\u3073\u51FA\u3059\u305F\u3073\u306B\u6700\u521D\u304B\u3089\
    \u8A08\u7B97\u3059\u308B\u3002\u8CA0\u306E\u6D41\u91CF\u306E\u307F\u5B9F\u73FE\
    \u53EF\u80FD\u306A\u5834\u5408\u3082-1\u3092\u8FD4\u3059\u3002\n        ## \u5404\
    \u9802\u70B9\u306E\u4E0B\u9650\u6D41\u91CF\u306E\u53CE\u652F\u306E\u4E2D\u9593\
    \u5024\u3001\u6B63\u306E\u53CE\u652F\u306E\u7DCF\u548C\u3001\u6700\u5927\u6D41\
    \u91CF\u306FCap\u306B\u53CE\u307E\u308B\u3053\u3068\u3002\n        assert src\
    \ in 0..<g.n and dst in 0..<g.n and src != dst, \"\u9802\u70B9\u756A\u53F7\u304C\
    \u7BC4\u56F2\u5916\u304B\u3001\u59CB\u70B9\u3068\u7D42\u70B9\u304C\u540C\u3058\
    \u3067\u3059\"\n        g.solved = false\n        var auxiliary = initMaxFlow[Cap](g.n\
    \ + 2)\n        var balance = newSeq[Cap](g.n)\n        for e in g.edges:\n  \
    \          auxiliary.add_edge(e.src, e.dst, e.upper - e.lower)\n            if\
    \ e.src != e.dst:\n                balance[e.src] -= e.lower\n               \
    \ balance[e.dst] += e.lower\n        let back = auxiliary.add_edge(dst, src, high(Cap))\n\
    \        var required = Cap(0)\n        for v in 0..<g.n:\n            if balance[v]\
    \ > Cap(0):\n                auxiliary.add_edge(g.n, v, balance[v])\n        \
    \        required += balance[v]\n            elif balance[v] < Cap(0):\n     \
    \           auxiliary.add_edge(v, g.n + 1, -balance[v])\n        if auxiliary.flow(g.n,\
    \ g.n + 1, required) != required:\n            return Cap(-1)\n        let initial\
    \ = auxiliary.get_edge(back).flow\n        # \u88DC\u52A9\u8FBA\u3092\u9664\u304D\
    \u3001\u4E0A\u4E0B\u9650\u306E\u7BC4\u56F2\u5185\u3067\u6D41\u91CF\u3092\u5897\
    \u6E1B\u3067\u304D\u308B\u6B8B\u4F59\u30B0\u30E9\u30D5\u3092\u69CB\u7BC9\u3059\
    \u308B\u3002\n        var residual = initMaxFlow[Cap](g.n)\n        for i, e in\
    \ g.edges:\n            let extra = auxiliary.get_edge(i).flow\n            residual.add_edge(e.src,\
    \ e.dst, e.upper - e.lower - extra)\n            residual.add_edge(e.dst, e.src,\
    \ extra)\n        result = initial + residual.flow(src, dst, high(Cap) - initial)\n\
    \        for i in 0..<g.edges.len:\n            g.edges[i].flow = g.edges[i].lower\
    \ + auxiliary.get_edge(i).flow -\n                residual.get_edge(2 * i + 1).flow\
    \ + residual.get_edge(2 * i).flow\n        g.solved = true\n\n    proc get_edge*[Cap](g:\
    \ LowerBoundMaxFlow[Cap], i: int): LowerBoundMaxFlowEdge[Cap] =\n        ## flow\u6210\
    \u529F\u5F8C\u306Ei\u756A\u76EE\u306E\u8FBA\u306E\u4E0A\u4E0B\u9650\u3068\u6D41\
    \u91CF\u3092\u8FD4\u3059\u3002\u8FBA\u306E\u8FFD\u52A0\u5F8C\u306F\u518D\u8A08\
    \u7B97\u304C\u5FC5\u8981\u3002O(1)\u3002\n        assert g.solved, \"\u5148\u306B\
    flow\u3067\u5B9F\u73FE\u53EF\u80FD\u306A\u6D41\u308C\u3092\u6C42\u3081\u3066\u304F\
    \u3060\u3055\u3044\"\n        g.edges[i]\n\n    proc get_edges*[Cap](g: LowerBoundMaxFlow[Cap]):\
    \ seq[LowerBoundMaxFlowEdge[Cap]] =\n        ## flow\u6210\u529F\u5F8C\u306E\u5168\
    \u8FBA\u306E\u4E0A\u4E0B\u9650\u3068\u6D41\u91CF\u3092\u8FFD\u52A0\u9806\u306B\
    \u8FD4\u3059\u3002O(E)\u3002\n        assert g.solved, \"\u5148\u306Bflow\u3067\
    \u5B9F\u73FE\u53EF\u80FD\u306A\u6D41\u308C\u3092\u6C42\u3081\u3066\u304F\u3060\
    \u3055\u3044\"\n        for e in g.edges:\n            result.add(e)\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/graph/maxflow.nim
  isVerificationFile: false
  path: cplib/graph/lowerbound_maxflow.nim
  requiredBy: []
  timestamp: '2026-09-16 22:30:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lowerbound_maxflow_test.nim
  - verify/AI/lowerbound_maxflow_test.nim
documentation_of: cplib/graph/lowerbound_maxflow.nim
layout: document
redirect_from:
- /library/cplib/graph/lowerbound_maxflow.nim
- /library/cplib/graph/lowerbound_maxflow.nim.html
title: cplib/graph/lowerbound_maxflow.nim
---
