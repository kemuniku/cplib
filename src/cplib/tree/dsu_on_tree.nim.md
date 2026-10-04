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
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dsu_on_tree_test.nim
    title: verify/AI/dsu_on_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dsu_on_tree_test.nim
    title: verify/AI/dsu_on_tree_test.nim
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
  code: "when not declared CPLIB_TREE_DSU_ON_TREE:\n    ## DSU on tree\u3067\u5404\
    \u90E8\u5206\u6728\u3092\u96C6\u8A08\u3059\u308B\u3002\u901A\u5E38\u306Fadd\u3068\
    answer\u3060\u3051\u3092\u6307\u5B9A\u3059\u308B\u3002\n    ##\n    ## .. code-block::\
    \ nim\n    ##\n    ##   import cplib/tree/dsu_on_tree\n    ##   let g = @[@[1,\
    \ 2], @[0], @[0]]\n    ##   var total = 0\n    ##   var answers = newSeq[int](g.len)\n\
    \    ##   proc add(v: int) = total += v + 1\n    ##   proc answer(v: int) = answers[v]\
    \ = total\n    ##   dsuOnTree(g, add, answer)\n    ##   # answers == @[6, 2, 3]\u3001\
    total == 0\n    ##   proc clearState(v: int) = total -= v + 1\n    ##   dsuOnTree(g,\
    \ add, answer, clear = clearState, root = 0)\n    ##\n    const CPLIB_TREE_DSU_ON_TREE*\
    \ = 1\n    import cplib/tree/heavylightdecomposition\n    import cplib/utils/private/auto_rollback\n\
    \n    proc runDsuOnTree[Clear](hld: HeavyLightDecomposition, add: proc(v: int),\n\
    \            answer: proc(v: int), clear: Clear) =\n        ## HLD\u9806\u3092\
    \u9006\u304B\u3089\u8D70\u67FB\u3057\u3001\u4FDD\u6301\u4E2D\u306E\u533A\u9593\
    \u3092\u4E00\u62EC\u307E\u305F\u306F\u9802\u70B9\u3054\u3068\u306B\u7834\u68C4\
    \u3059\u308B\u3002O(N log N)\u56DE\u306E\u8FFD\u52A0\u3002\n        assert hld\
    \ != nil and hld.numVertices > 0\n        var activeLeft, activeRight: int\n \
    \       template clearActive() =\n            ## \u6B63\u5E38\u306B\u8FFD\u52A0\
    \u3057\u305F\u9802\u70B9\u3092\u7834\u68C4\u3059\u308B\u3002clear\u306E\u4F8B\u5916\
    \u6642\u306B\u306F\u518D\u5EA6\u547C\u3073\u51FA\u3055\u306A\u3044\u3002\n   \
    \         if activeLeft < activeRight:\n                let first = activeLeft\n\
    \                let last = activeRight\n                activeLeft = activeRight\n\
    \                when compiles(clear()):\n                    clear()\n      \
    \          else:\n                    for j in first..<last:\n               \
    \         clear(hld.toVtx(j))\n        try:\n            # HLD\u9806\u306E\u9006\
    \u9806\u3067\u306Flight\u90E8\u5206\u6728\u3001heavy\u90E8\u5206\u6728\u3001\u89AA\
    \u306E\u9806\u306B\u51E6\u7406\u3067\u304D\u308B\u3002\n            for i in countdown(hld.numVertices\
    \ - 1, 0):\n                let v = hld.toVtx(i)\n                let heavy =\
    \ hld.heavyChildOf(v)\n                let first = if heavy == -1: i + 1 else:\
    \ hld.subtree(heavy)[1]\n                if activeLeft == activeRight:\n     \
    \               activeLeft = first\n                    activeRight = first\n\
    \                for j in first..<hld.subtree(v)[1]:\n                    add(hld.toVtx(j))\n\
    \                    activeRight = j + 1\n                add(v)\n           \
    \     activeLeft = i\n                answer(v)\n                if hld.heavyRootOf(v)\
    \ == v:\n                    clearActive()\n        finally:\n            clearActive()\n\
    \n    proc dsuOnTree*(hld: HeavyLightDecomposition, add: proc(v: int),\n     \
    \       answer: proc(v: int), clear: proc(v: int)) =\n        ## \u5404\u9802\u70B9\
    v\u81EA\u8EAB\u3092\u542B\u3080\u90E8\u5206\u6728\u3092\u96C6\u8A08\u3057\u3001\
    answer(v)\u3092\u4E00\u5EA6\u305A\u3064\u547C\u3076\u3002add\u30FBclear\u306F\u5404\
    O(N log N)\u56DE\u3002\n        ## \u7A7A\u306E\u96C6\u8A08\u304B\u3089\u958B\u59CB\
    \u3057\u3001\u7834\u68C4\u3059\u308B\u90E8\u5206\u6728\u306E\u5404\u9802\u70B9\
    v\u306Bclear(v)\u3092\u4E00\u5EA6\u305A\u3064\u547C\u3076\u3002\u6B63\u5E38\u7D42\
    \u4E86\u6642\u306F\u7A7A\u306B\u623B\u308B\u3002\n        ## clear(v)\u306F\u9802\
    \u70B9v\u306E\u5BC4\u4E0E\u3092\u53D6\u308A\u9664\u304F\u3053\u3068\u3002\u524A\
    \u9664\u9806\u306F\u672A\u898F\u5B9A\u3067\u3001\u524A\u9664\u306E\u9014\u4E2D\
    \u306Badd\u30FBanswer\u306F\u547C\u3070\u306A\u3044\u3002\n        ## answer\u306F\
    \u96C6\u8A08\u3092\u5909\u66F4\u305B\u305A\u7B54\u3048\u3092\u4FDD\u5B58\u3059\
    \u308B\u3053\u3068\u3002\u7B54\u3048\u306F\u8FFD\u52A0\u9806\u306B\u3088\u3089\
    \u305A\u3001\u56DE\u7B54\u9806\u306F\u672A\u898F\u5B9A\u3002\n        ## \u30B3\
    \u30FC\u30EB\u30D0\u30C3\u30AF\u306B\u306F\u5143\u306E\u9802\u70B9\u756A\u53F7\
    \u3092\u6E21\u3059\u3002\u5B9F\u884C\u4E2D\u306FHLD\u3092\u5909\u66F4\u3057\u306A\
    \u3044\u3053\u3068\u3002\u81EA\u52D5\u8A18\u9332\u306F\u884C\u308F\u306A\u3044\
    \u3002\n        ## \u4F8B\u5916\u6642\u3082\u8FFD\u52A0\u6E08\u307F\u306E\u9802\
    \u70B9\u3092\u524A\u9664\u3059\u308B\u3002add\u304C\u4F8B\u5916\u3092\u9001\u51FA\
    \u3059\u308B\u5834\u5408\u3001\u305D\u306E\u547C\u3073\u51FA\u3057\u3067\u306F\
    \u72B6\u614B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\u3002\n        ##\
    \ clear\u306F\u4F8B\u5916\u3092\u9001\u51FA\u3057\u306A\u3044\u3053\u3068\u3002\
    \u5404\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u304CO(1)\u306A\u3089\u5168\u4F53O(N\
    \ log N)\u3001\u8FFD\u52A0\u7A7A\u9593O(1)\u3002\n        runDsuOnTree(hld, add,\
    \ answer, clear)\n\n    template dsuOnTree*(hld: HeavyLightDecomposition, add:\
    \ proc(v: int), answer: proc(v: int)) =\n        ## add\u306E\u5909\u66F4\u524D\
    \u306E\u5024\u3092\u8A18\u9332\u3057\u3001\u90E8\u5206\u6728\u306E\u96C6\u8A08\
    \u3092\u81EA\u52D5\u3067\u7834\u68C4\u3059\u308B\u3002add\u306FO(N log N)\u56DE\
    \u3002\n        ## \u7A7A\u306E\u96C6\u8A08\u304B\u3089\u958B\u59CB\u3059\u308B\
    \u3053\u3068\u3002\u7D42\u4E86\u30FB\u4F8B\u5916\u6642\u306F\u5B9F\u884C\u524D\
    \u306E\u5024\u306B\u623B\u3059\u3002answer\u306E\u5909\u66F4\u306F\u8A18\u9332\
    \u3057\u306A\u3044\u3002\n        ## answer(v)\u3067\u306Fv\u81EA\u8EAB\u3092\u542B\
    \u3080\u90E8\u5206\u6728\u304C\u96C6\u8A08\u3055\u308C\u308B\u3002\u96C6\u8A08\
    \u3092\u5909\u66F4\u305B\u305A\u3001\u8FFD\u52A0\u9806\u306B\u4F9D\u5B58\u3057\
    \u306A\u3044\u7B54\u3048\u3092\u4FDD\u5B58\u3059\u308B\u3053\u3068\u3002\n   \
    \     ## add\u306B\u306F\u9759\u7684\u306B\u7279\u5B9A\u3067\u304D\u308Bproc\u3092\
    \u6E21\u3059\u3002\u6570\u5024\u30FB\u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\
    \u914D\u5217\u306E\u66F4\u65B0\u306B\u5BFE\u5FDC\u3057\u3001seq\u306E\u4F38\u7E2E\
    \u306F\u672A\u5BFE\u5FDC\u3002\n        ## \u5909\u66F4\u5148\u306F\u5B9F\u884C\
    \u7D42\u4E86\u307E\u3067\u751F\u5B58\u3057\u3001add\u4EE5\u5916\u304B\u3089\u5909\
    \u66F4\u30FB\u89E3\u653E\u3057\u306A\u3044\u3053\u3068\u3002HLD\u3082\u5B9F\u884C\
    \u4E2D\u306F\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\u3002\n        ## \u914D\
    \u5217\u3054\u3068\u306B\u5224\u5B9A\u30D3\u30C3\u30C8\u5217\u3068\u4FDD\u5B58\
    \u9818\u57DF\u3092\u78BA\u4FDD\u3057\u3001\u8DB3\u308A\u306A\u3044\u3068\u304D\
    \u3060\u3051\u62E1\u5F35\u3059\u308B\u3002\u30CF\u30C3\u30B7\u30E5\u306F\u4F7F\
    \u7528\u3057\u306A\u3044\u3002\n        ## \u56FA\u5B9A\u306E\u914D\u5217\u30FB\
    \u5909\u6570\u306F\u5B9F\u884C\u958B\u59CB\u6642\u306B\u4FDD\u5B58\u5148\u3092\
    \u78BA\u8A8D\u3057\u3001\u66F4\u65B0\u3054\u3068\u306E\u9818\u57DF\u78BA\u8A8D\
    \u3092\u7701\u304F\u3002\n        ## \u540C\u3058\u9818\u57DF\u306E\u5404\u6DFB\
    \u5B57\u306F\u6B21\u306E\u7834\u68C4\u307E\u3067\u4E00\u5EA6\u3060\u3051\u4FDD\
    \u5B58\u3059\u308B\u3002\u5171\u901A\u306E\u521D\u671F\u5024\u306F\u5171\u6709\
    \u3057\u3001\u7570\u306A\u308B\u5024\u3060\u3051\u500B\u5225\u306B\u4FDD\u5B58\
    \u3059\u308B\u3002\n        ## \u5FA9\u5143\u6642\u306F\u89E6\u3063\u305F\u6DFB\
    \u5B57\u3060\u3051\u3092\u623B\u3059\u3002\u9818\u57DF\u306E\u6DF7\u5728\u30FB\
    \u518D\u5165\u306A\u3069\u3067\u5224\u5B9A\u3067\u304D\u306A\u3044\u66F4\u65B0\
    \u306F\u3001\u5909\u66F4\u306E\u305F\u3073\u306B\u5024\u3092\u4FDD\u5B58\u3059\
    \u308B\u3002\n        ## \u6642\u9593\u306F\u8D70\u67FB\u30FB\u66F4\u65B0\u30FB\
    \u4FDD\u5B58\u30FB\u5FA9\u5143\u3068\u9818\u57DF\u62E1\u5F35\u306E\u5408\u8A08\
    \u3001\u8FFD\u52A0\u7A7A\u9593\u306F\u914D\u5217\u5225\u306E\u6700\u5927\u78BA\
    \u4FDD\u91CF\u3068\u5C65\u6B74\u91CF\u306B\u6BD4\u4F8B\u3059\u308B\u3002\n   \
    \     runAutoClearImpl(hld, add, answer, runDsuOnTree)\n\n    template dsuOnTree*(g:\
    \ typed, add: proc(v: int), answer: proc(v: int), clear: proc(v: int), root: int\
    \ = 0) =\n        ## \u6728g\u3092root\u3067\u6839\u4ED8\u3051\u3066\u96C6\u8A08\
    \u3059\u308B\u3002\u624B\u52D5clear\u7248\u3002HLD\u69CB\u7BC9\u306E\u671F\u5F85\
    \u6642\u9593\u30FB\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n        ## g\u306FinitHld\u304C\
    \u53D7\u3051\u53D6\u308C\u308B\u6728\u30FB\u96A3\u63A5\u30EA\u30B9\u30C8\u3002\
    \u9759\u7684\u30B0\u30E9\u30D5\u306F\u4E8B\u524D\u306Bbuild\u3057\u3001\u8FBA\u306E\
    \u91CD\u307F\u306F\u53C2\u7167\u3057\u306A\u3044\u3002\n        block:\n     \
    \       let tree = g\n            let treeRoot = root\n            assert tree.len\
    \ > 0 and 0 <= treeRoot and treeRoot < tree.len\n            let decomposition\
    \ = initHld(tree, treeRoot)\n            dsuOnTree(decomposition, add, answer,\
    \ clear)\n\n    template dsuOnTree*(g: typed, add: proc(v: int), answer: proc(v:\
    \ int), root: int = 0) =\n        ## \u6728g\u3092root\u3067\u6839\u4ED8\u3051\
    \u3066\u96C6\u8A08\u3059\u308B\u3002\u81EA\u52D5\u5FA9\u5143\u7248\u3002HLD\u69CB\
    \u7BC9\u306E\u671F\u5F85\u6642\u9593\u30FB\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n\
    \        ## g\u306E\u6761\u4EF6\u306F\u624B\u52D5clear\u7248\u3001add\u30FBanswer\u306E\
    \u6761\u4EF6\u306FHLD\u3092\u6E21\u3059\u81EA\u52D5\u5FA9\u5143\u7248\u3068\u540C\
    \u3058\u3002\n        block:\n            let tree = g\n            let treeRoot\
    \ = root\n            assert tree.len > 0 and 0 <= treeRoot and treeRoot < tree.len\n\
    \            let decomposition = initHld(tree, treeRoot)\n            dsuOnTree(decomposition,\
    \ add, answer)\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: false
  path: cplib/tree/dsu_on_tree.nim
  requiredBy: []
  timestamp: '2026-09-30 05:10:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/dsu_on_tree_test.nim
  - verify/AI/dsu_on_tree_test.nim
documentation_of: cplib/tree/dsu_on_tree.nim
layout: document
redirect_from:
- /library/cplib/tree/dsu_on_tree.nim
- /library/cplib/tree/dsu_on_tree.nim.html
title: cplib/tree/dsu_on_tree.nim
---
