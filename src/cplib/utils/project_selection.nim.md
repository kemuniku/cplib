---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/k_project_selection.nim
    title: cplib/utils/k_project_selection.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_project_selection_test.nim
    title: verify/AI/k_project_selection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_project_selection_test.nim
    title: verify/AI/k_project_selection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/project_selection_test.nim
    title: verify/AI/project_selection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/project_selection_test.nim
    title: verify/AI/project_selection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/k_project_selection_abc326g_test.nim
    title: verify/utils/k_project_selection_abc326g_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/k_project_selection_abc326g_test.nim
    title: verify/utils/k_project_selection_abc326g_test.nim
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
  code: "when not declared CPLIB_UTILS_PROJECT_SELECTION:\n    const CPLIB_UTILS_PROJECT_SELECTION*\
    \ = 1\n    import cplib/graph/maxflow\n\n    type\n        ProjectSelectionTermKind\
    \ = enum\n            psUnary, psPair, psAllGain, psForce, psImply\n        ProjectSelectionTerm[Cost]\
    \ = object\n            kind: ProjectSelectionTermKind\n            i, j: int\n\
    \            value: bool\n            costs: array[4, Cost]\n            ids:\
    \ seq[int]\n        ProjectSelection*[Cost] = object\n            n: int\n   \
    \         terms: seq[ProjectSelectionTerm[Cost]]\n        ProjectSelectionResult*[Cost]\
    \ = object\n            feasible*: bool\n            min_cost*: Cost\n       \
    \     assignment*: seq[bool]\n\n    proc psAdd[Cost: SomeSignedInt](a, b: Cost):\
    \ Cost =\n        ## \u52A0\u7B97\u306E\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\
    \u3092\u691C\u67FB\u3059\u308B\u3002O(1)\u3002\n        if (b > 0 and a > high(Cost)\
    \ - b) or (b < 0 and a < low(Cost) - b):\n            raise newException(OverflowDefect,\
    \ \"ProjectSelection\u306E\u52A0\u7B97\u304C\u5BB9\u91CF\u578B\u306E\u7BC4\u56F2\
    \u3092\u8D85\u3048\u307E\u3059\")\n        a + b\n\n    proc psSub[Cost: SomeSignedInt](a,\
    \ b: Cost): Cost =\n        ## \u6E1B\u7B97\u306E\u30AA\u30FC\u30D0\u30FC\u30D5\
    \u30ED\u30FC\u3092\u691C\u67FB\u3059\u308B\u3002O(1)\u3002\n        if (b > 0\
    \ and a < low(Cost) + b) or (b < 0 and a > high(Cost) + b):\n            raise\
    \ newException(OverflowDefect, \"ProjectSelection\u306E\u6E1B\u7B97\u304C\u5BB9\
    \u91CF\u578B\u306E\u7BC4\u56F2\u3092\u8D85\u3048\u307E\u3059\")\n        a - b\n\
    \n    proc initProjectSelection*(n: int, costType: typedesc[SomeSignedInt] = int):\
    \ ProjectSelection[costType] =\n        ## n\u500B\u306E\u4E8C\u5024\u5909\u6570\
    \u3092\u4F5C\u308B\u3002\u8CBB\u7528\uFF0D\u5229\u76CA\u3092\u6700\u5C0F\u5316\
    \u3059\u308B\u3002costType\u306E\u7701\u7565\u6642\u306Fint\u3002O(1)\u3002\n\
    \        if n < 0:\n            raise newException(ValueError, \"\u5909\u6570\u306E\
    \u500B\u6570\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\")\n        result.n = n\n\n    proc psCheckIndex[Cost](opt: ProjectSelection[Cost],\
    \ i: int) =\n        ## \u5143\u306E\u5909\u6570\u306E\u6DFB\u5B57\u3092\u691C\
    \u67FB\u3059\u308B\u3002O(1)\u3002\n        if i < 0 or i >= opt.n:\n        \
    \    raise newException(ValueError, \"\u5909\u6570\u756A\u53F7\u304C\u7BC4\u56F2\
    \u5916\u3067\u3059: \" & $i)\n\n    proc psCheckWeight[Cost](w: Cost) =\n    \
    \    ## \u8CBB\u7528\u30FB\u5229\u76CA\u306E\u5927\u304D\u3055\u3092\u691C\u67FB\
    \u3059\u308B\u3002O(1)\u3002\n        if w < 0:\n            raise newException(ValueError,\
    \ \"\u8CBB\u7528\u30FB\u5229\u76CA\u306E\u5927\u304D\u3055\u306F\u975E\u8CA0\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n\n    proc add_unary_cost*[Cost](opt:\
    \ var ProjectSelection[Cost], i: int, c0, c1: Cost) =\n        ## x[i]\u304Cfalse/true\u306E\
    \u3068\u304D\u306E\u8CBB\u7528c0/c1\u3092\u52A0\u7B97\u3059\u308B\u3002\u8CA0\u5024\
    \u3082\u53EF\u3002\u511F\u5374O(1)\u3002\n        opt.psCheckIndex(i)\n      \
    \  opt.terms.add(ProjectSelectionTerm[Cost](kind: psUnary, i: i, costs: [c0, c1,\
    \ Cost(0), Cost(0)]))\n\n    proc add_cost*[Cost](opt: var ProjectSelection[Cost],\
    \ i: int, value: bool, w: Cost) =\n        ## x[i] == value\u306E\u3068\u304D\u8CBB\
    \u7528w\u3092\u52A0\u7B97\u3059\u308B\u3002\u8CA0\u5024\u306F\u5229\u76CA\u3068\
    \u306A\u308B\u3002\u511F\u5374O(1)\u3002\n        if value: opt.add_unary_cost(i,\
    \ Cost(0), w)\n        else: opt.add_unary_cost(i, w, Cost(0))\n\n    proc add_gain*[Cost](opt:\
    \ var ProjectSelection[Cost], i: int, value: bool, w: Cost) =\n        ## x[i]\
    \ == value\u306E\u3068\u304D\u5229\u76CAw\u3092\u52A0\u7B97\u3059\u308B\u3002\u8CA0\
    \u5024\u306F\u8CBB\u7528\u3068\u306A\u308B\u3002\u511F\u5374O(1)\u3002\n     \
    \   opt.add_cost(i, value, psSub(Cost(0), w))\n\n    proc add_pair_cost*[Cost](opt:\
    \ var ProjectSelection[Cost], i, j: int, c00, c01, c10, c11: Cost) =\n       \
    \ ## (x[i],x[j])\u306E4\u901A\u308A\u306E\u8CBB\u7528\u3092\u52A0\u7B97\u3059\u308B\
    \u3002\u52A3\u30E2\u30B8\u30E5\u30E9\u6027\u304C\u5FC5\u8981\u3002\u511F\u5374\
    O(1)\u3002\n        opt.psCheckIndex(i)\n        opt.psCheckIndex(j)\n       \
    \ if i == j:\n            opt.add_unary_cost(i, c00, c11)\n            return\n\
    \        let a = psSub(c01, c00)\n        let b = psSub(c11, c10)\n        if\
    \ a < b:\n            raise newException(ValueError, \"\u5909\u6570 \" & $i &\
    \ \", \" & $j &\n                \" \u306E\u30B3\u30B9\u30C8\u8868\u304C\u52A3\
    \u30E2\u30B8\u30E5\u30E9\u6761\u4EF6 c00 + c11 <= c01 + c10 \u3092\u6E80\u305F\
    \u3057\u307E\u305B\u3093: \" &\n                $[c00, c01, c10, c11])\n     \
    \   discard psSub(a, b)\n        opt.terms.add(ProjectSelectionTerm[Cost](kind:\
    \ psPair, i: i, j: j, costs: [c00, c01, c10, c11]))\n\n    proc add_cost_if_true_false*[Cost](opt:\
    \ var ProjectSelection[Cost], i, j: int, w: Cost) =\n        ## x[i]\u304Ctrue\u304B\
    \u3064x[j]\u304Cfalse\u306A\u3089\u975E\u8CA0\u306E\u8CBB\u7528w\u3092\u52A0\u7B97\
    \u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        psCheckWeight(w)\n        opt.add_pair_cost(i,\
    \ j, Cost(0), Cost(0), w, Cost(0))\n\n    proc add_cost_if_different*[Cost](opt:\
    \ var ProjectSelection[Cost], i, j: int, w: Cost) =\n        ## x[i] != x[j]\u306A\
    \u3089\u975E\u8CA0\u306E\u8CBB\u7528w\u3092\u52A0\u7B97\u3059\u308B\u3002\u511F\
    \u5374O(1)\u3002\n        psCheckWeight(w)\n        opt.add_pair_cost(i, j, Cost(0),\
    \ w, w, Cost(0))\n\n    proc add_gain_if_all*[Cost](opt: var ProjectSelection[Cost],\
    \ ids: openArray[int], value: bool, w: Cost) =\n        ## \u5168\u5909\u6570\u304C\
    value\u306A\u3089\u975E\u8CA0\u306E\u5229\u76CAw\u3092\u52A0\u7B97\u3059\u308B\
    \u3002\u7A7A\u96C6\u5408\u306A\u3089\u5E38\u306B\u5229\u76CA\u30022\u5909\u6570\
    \u4EE5\u4E0B\u306F\u88DC\u52A9\u9802\u70B9\u4E0D\u8981\u3002O(|ids|)\u3002\n \
    \       psCheckWeight(w)\n        for i in ids: opt.psCheckIndex(i)\n        if\
    \ w == 0: return\n        if ids.len == 1:\n            opt.add_gain(ids[0], value,\
    \ w)\n        elif ids.len == 2:\n            if value:\n                opt.add_pair_cost(ids[0],\
    \ ids[1], Cost(0), Cost(0), Cost(0), -w)\n            else:\n                opt.add_pair_cost(ids[0],\
    \ ids[1], -w, Cost(0), Cost(0), Cost(0))\n        else:\n            opt.terms.add(ProjectSelectionTerm[Cost](kind:\
    \ psAllGain, value: value, costs: [w, Cost(0), Cost(0), Cost(0)], ids: @ids))\n\
    \n    proc force*[Cost](opt: var ProjectSelection[Cost], i: int, value: bool)\
    \ =\n        ## x[i]\u3092value\u306B\u56FA\u5B9A\u3059\u308B\u3002\u511F\u5374\
    O(1)\u3002\n        opt.psCheckIndex(i)\n        opt.terms.add(ProjectSelectionTerm[Cost](kind:\
    \ psForce, i: i, value: value))\n\n    proc imply*[Cost](opt: var ProjectSelection[Cost],\
    \ i, j: int) =\n        ## x[i]\u304Ctrue\u306A\u3089x[j]\u3082true\u3068\u306A\
    \u308B\u5236\u7D04\u3092\u8FFD\u52A0\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n\
    \        ## x[i]\u304Cfalse\u306A\u3089x[j]\u3082false\u3092\u3084\u308A\u305F\
    \u3044\u306A\u3089\u3001imply(j,i)\u3067ok\n        opt.psCheckIndex(i)\n    \
    \    opt.psCheckIndex(j)\n        opt.terms.add(ProjectSelectionTerm[Cost](kind:\
    \ psImply, i: i, j: j))\n\n    proc equal*[Cost](opt: var ProjectSelection[Cost],\
    \ i, j: int) =\n        ## x[i] == x[j]\u3068\u306A\u308B\u5236\u7D04\u3092\u8FFD\
    \u52A0\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        opt.psCheckIndex(i)\n\
    \        opt.psCheckIndex(j)\n        opt.imply(i, j)\n        opt.imply(j, i)\n\
    \n    proc solve*[Cost](opt: ProjectSelection[Cost]): ProjectSelectionResult[Cost]\
    \ =\n        ## \u6700\u5C0F\u8CBB\u7528\u3068\u5272\u5F53\u3092\u8FD4\u3059\u3002\
    \u77DB\u76FE\u6642\u306Ffeasible=false\u3067\u4ED6\u306E\u5024\u306F\u7121\u52B9\
    \u3002\u88DC\u52A9\u9802\u70B9\u8FBC\u307F\u3067O(V^2 E)\u3002\u518D\u5B9F\u884C\
    \u53EF\u3002\n        let source = opt.n\n        let sink = opt.n + 1\n     \
    \   var vertexCount = opt.n + 2\n        var edges: seq[tuple[src, dst: int, cap:\
    \ Cost]]\n        var hardEdges: seq[tuple[src, dst: int]]\n        var offset\
    \ = Cost(0)\n        var total = Cost(0)\n        proc edge(src, dst: int, cap:\
    \ Cost) =\n            ## \u6709\u9650\u5BB9\u91CF\u306E\u8FBA\u3068\u305D\u306E\
    \u7DCF\u548C\u3092\u8A18\u9332\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n     \
    \       if src != dst and cap > 0:\n                total = psAdd(total, cap)\n\
    \                edges.add((src, dst, cap))\n        proc unary(i: int, c0, c1:\
    \ Cost) =\n            ## \u5358\u9805\u8CBB\u7528\u3092\u5B9A\u6570\u3068\u975E\
    \u8CA0\u5BB9\u91CF\u306B\u5206\u89E3\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n\
    \            offset = psAdd(offset, min(c0, c1))\n            if c0 <= c1: edge(i,\
    \ sink, psSub(c1, c0))\n            else: edge(source, i, psSub(c0, c1))\n   \
    \     for term in opt.terms:\n            let c = term.costs\n            case\
    \ term.kind\n            of psUnary:\n                unary(term.i, c[0], c[1])\n\
    \            of psPair:\n                offset = psAdd(offset, c[0])\n      \
    \          unary(term.i, Cost(0), psSub(c[3], c[1]))\n                unary(term.j,\
    \ Cost(0), psSub(c[1], c[0]))\n                edge(term.i, term.j, psSub(psSub(c[1],\
    \ c[0]), psSub(c[3], c[2])))\n            of psAllGain:\n                if c[0]\
    \ == 0: continue\n                if term.ids.len == 0:\n                    offset\
    \ = psSub(offset, c[0])\n                else:\n                    let aux =\
    \ vertexCount\n                    inc vertexCount\n                    if term.value:\n\
    \                        unary(aux, Cost(0), -c[0])\n                        for\
    \ i in term.ids: hardEdges.add((aux, i))\n                    else:\n        \
    \                unary(aux, -c[0], Cost(0))\n                        for i in\
    \ term.ids: hardEdges.add((i, aux))\n            of psForce:\n               \
    \ if term.value: hardEdges.add((source, term.i))\n                else: hardEdges.add((term.i,\
    \ sink))\n            of psImply:\n                if term.i != term.j: hardEdges.add((term.i,\
    \ term.j))\n        var infinity = Cost(0)\n        if hardEdges.len > 0:\n  \
    \          infinity = psAdd(total, Cost(1))\n        var graph = initMaxFlow[Cost](vertexCount)\n\
    \        for e in edges: graph.add_edge(e.src, e.dst, e.cap)\n        for e in\
    \ hardEdges: graph.add_edge(e.src, e.dst, infinity)\n        let limit = if hardEdges.len\
    \ > 0: infinity else: total\n        let flow = graph.flow(source, sink, limit)\n\
    \        if hardEdges.len > 0 and flow == infinity:\n            return\n    \
    \    result.feasible = true\n        result.min_cost = psAdd(offset, flow)\n \
    \       let cut = graph.min_cut(source)\n        result.assignment = newSeq[bool](opt.n)\n\
    \        for i in 0..<opt.n: result.assignment[i] = cut[i]\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/graph/maxflow.nim
  isVerificationFile: false
  path: cplib/utils/project_selection.nim
  requiredBy:
  - cplib/utils/k_project_selection.nim
  - cplib/utils/k_project_selection.nim
  timestamp: '2026-09-14 12:19:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/k_project_selection_abc326g_test.nim
  - verify/utils/k_project_selection_abc326g_test.nim
  - verify/AI/k_project_selection_test.nim
  - verify/AI/k_project_selection_test.nim
  - verify/AI/project_selection_test.nim
  - verify/AI/project_selection_test.nim
documentation_of: cplib/utils/project_selection.nim
layout: document
redirect_from:
- /library/cplib/utils/project_selection.nim
- /library/cplib/utils/project_selection.nim.html
title: cplib/utils/project_selection.nim
---
