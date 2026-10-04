---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/project_selection.nim
    title: cplib/utils/project_selection.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_project_selection_test.nim
    title: verify/AI/k_project_selection_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/k_project_selection_test.nim
    title: verify/AI/k_project_selection_test.nim
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
  code: "when not declared CPLIB_UTILS_K_PROJECT_SELECTION:\n    const CPLIB_UTILS_K_PROJECT_SELECTION*\
    \ = 1\n    import cplib/utils/project_selection\n\n    type\n        KProjectSelection*[Cost]\
    \ = object\n            sizes, starts: seq[int]\n            binary: ProjectSelection[Cost]\n\
    \        KProjectSelectionResult*[Cost] = object\n            feasible*: bool\n\
    \            min_cost*: Cost\n            assignment*: seq[int]\n\n    proc kpsSub[Cost:\
    \ SomeSignedInt](a, b: Cost): Cost =\n        ## \u8CBB\u7528\u306E\u5DEE\u3092\
    \u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3092\u691C\u67FB\u3057\u3066\u6C42\
    \u3081\u308B\u3002O(1)\u3002\n        if (b > 0 and a < low(Cost) + b) or (b <\
    \ 0 and a > high(Cost) + b):\n            raise newException(OverflowDefect, \"\
    KProjectSelection\u306E\u6E1B\u7B97\u304C\u8CBB\u7528\u578B\u306E\u7BC4\u56F2\u3092\
    \u8D85\u3048\u307E\u3059\")\n        a - b\n\n    proc initKProjectSelection*(sizes:\
    \ openArray[int], costType: typedesc[SomeSignedInt] = int): KProjectSelection[costType]\
    \ =\n        ## \u5404\u5909\u6570\u306E\u5024\u57DF\u30920..<sizes[i]\u3068\u3059\
    \u308B\u3002\u5404\u30B5\u30A4\u30BA\u306F\u6B63\u3002\u578B\u306E\u7701\u7565\
    \u6642\u306Fint\u3002O(n + \u03A3sizes[i])\u3002\n        result.sizes = @sizes\n\
    \        result.starts = newSeq[int](sizes.len)\n        var count = 2\n     \
    \   for i, k in sizes:\n            if k <= 0:\n                raise newException(ValueError,\
    \ \"\u5024\u57DF\u306E\u30B5\u30A4\u30BA\u306F\u6B63\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059: \" & $i)\n            if count > high(int) - (k\
    \ - 1):\n                raise newException(OverflowDefect, \"\u95BE\u5024\u5909\
    \u6570\u306E\u500B\u6570\u304Cint\u306E\u7BC4\u56F2\u3092\u8D85\u3048\u307E\u3059\
    \")\n            result.starts[i] = count\n            count += k - 1\n      \
    \  result.binary = initProjectSelection(count, costType)\n        result.binary.force(0,\
    \ false)\n        result.binary.force(1, true)\n        for i, k in sizes:\n \
    \           for t in 2..<k:\n                result.binary.imply(result.starts[i]\
    \ + t - 1, result.starts[i] + t - 2)\n\n    proc initKProjectSelection*(n, k:\
    \ int, costType: typedesc[SomeSignedInt] = int): KProjectSelection[costType] =\n\
    \        ## n\u5909\u6570\u305D\u308C\u305E\u308C\u306E\u5024\u57DF\u30920..<k\u3068\
    \u3059\u308B\u3002n\u306F\u975E\u8CA0\u3001k\u306F\u6B63\u3002O(nk)\u3002\n  \
    \      if n < 0 or k <= 0:\n            raise newException(ValueError, \"\u5909\
    \u6570\u6570\u306F\u975E\u8CA0\u3001\u5024\u57DF\u306E\u30B5\u30A4\u30BA\u306F\
    \u6B63\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n      \
    \  var sizes = newSeq[int](n)\n        for i in 0..<n: sizes[i] = k\n        initKProjectSelection(sizes,\
    \ costType)\n\n    proc kpsCheckIndex[Cost](opt: KProjectSelection[Cost], i: int)\
    \ =\n        ## \u5143\u306E\u5909\u6570\u306E\u6DFB\u5B57\u3092\u691C\u67FB\u3059\
    \u308B\u3002O(1)\u3002\n        if i < 0 or i >= opt.sizes.len:\n            raise\
    \ newException(ValueError, \"\u5909\u6570\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\
    \u3059: \" & $i)\n\n    proc kpsGe[Cost](opt: KProjectSelection[Cost], i, lower:\
    \ int): int =\n        ## x[i] >= lower\u3092\u8868\u3059\u5185\u90E8\u5909\u6570\
    \u3092\u8FD4\u3059\u30020\u3068sizes[i]\u306F\u5B9A\u6570\u6761\u4EF6\u3002O(1)\u3002\
    \n        opt.kpsCheckIndex(i)\n        if lower < 0 or lower > opt.sizes[i]:\n\
    \            raise newException(ValueError, \"\u4E0B\u5074\u306E\u95BE\u5024\u306F\
    0..sizes[i]\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\")\n \
    \       if lower == 0: return 1\n        if lower == opt.sizes[i]: return 0\n\
    \        opt.starts[i] + lower - 1\n\n    proc kpsGt[Cost](opt: KProjectSelection[Cost],\
    \ i, upper: int): int =\n        ## x[i] > upper\u3092\u8868\u3059\u5185\u90E8\
    \u5909\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        opt.kpsCheckIndex(i)\n\
    \        if upper < -1 or upper >= opt.sizes[i]:\n            raise newException(ValueError,\
    \ \"\u4E0A\u5074\u306E\u95BE\u5024\u306F-1..<sizes[i]\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\")\n        opt.kpsGe(i, upper + 1)\n\n    proc\
    \ add_unary_cost*[Cost](opt: var KProjectSelection[Cost], i: int, costs: openArray[Cost])\
    \ =\n        ## x[i] == v\u306E\u8CBB\u7528costs[v]\u3092\u52A0\u7B97\u3059\u308B\
    \u3002\u8CA0\u5024\u3082\u53EF\u3002O(sizes[i])\u3002\n        opt.kpsCheckIndex(i)\n\
    \        if costs.len != opt.sizes[i]:\n            raise newException(ValueError,\
    \ \"\u5358\u9805\u8CBB\u7528\u8868\u306E\u9577\u3055\u304C\u5024\u57DF\u306E\u30B5\
    \u30A4\u30BA\u3068\u4E00\u81F4\u3057\u307E\u305B\u3093\")\n        var diffs =\
    \ newSeq[Cost](costs.len - 1)\n        for t in 1..<costs.len: diffs[t - 1] =\
    \ kpsSub(costs[t], costs[t - 1])\n        opt.binary.add_unary_cost(0, costs[0],\
    \ costs[0])\n        for t in 1..<costs.len:\n            opt.binary.add_unary_cost(opt.kpsGe(i,\
    \ t), Cost(0), diffs[t - 1])\n\n    proc add_cost*[Cost](opt: var KProjectSelection[Cost],\
    \ i, value: int, w: Cost) =\n        ## x[i] == value\u306E\u3068\u304D\u8CBB\u7528\
    w\u3092\u52A0\u7B97\u3059\u308B\u3002\u8CA0\u5024\u306F\u5229\u76CA\u3068\u306A\
    \u308B\u3002O(sizes[i])\u3002\n        opt.kpsCheckIndex(i)\n        if value\
    \ < 0 or value >= opt.sizes[i]:\n            raise newException(ValueError, \"\
    \u5024\u304C\u5024\u57DF\u5916\u3067\u3059\")\n        var costs = newSeq[Cost](opt.sizes[i])\n\
    \        costs[value] = w\n        opt.add_unary_cost(i, costs)\n\n    proc add_gain*[Cost](opt:\
    \ var KProjectSelection[Cost], i, value: int, w: Cost) =\n        ## x[i] == value\u306E\
    \u3068\u304D\u5229\u76CAw\u3092\u52A0\u7B97\u3059\u308B\u3002\u8CA0\u5024\u306F\
    \u8CBB\u7528\u3068\u306A\u308B\u3002O(sizes[i])\u3002\n        opt.add_cost(i,\
    \ value, kpsSub(Cost(0), w))\n\n    proc add_pair_cost*[Cost](opt: var KProjectSelection[Cost],\
    \ i, j: int, costs: openArray[seq[Cost]]) =\n        ## \u8CBB\u7528costs[x[i]][x[j]]\u3092\
    \u52A0\u7B97\u3059\u308B\u3002\u7570\u306A\u308B\u5909\u6570\u3067\u306FMonge\u6027\
    \u304C\u5FC5\u8981\u3002O(sizes[i] sizes[j])\u3002\n        opt.kpsCheckIndex(i)\n\
    \        opt.kpsCheckIndex(j)\n        let ki = opt.sizes[i]\n        let kj =\
    \ opt.sizes[j]\n        if costs.len != ki:\n            raise newException(ValueError,\
    \ \"2\u5909\u6570\u8CBB\u7528\u8868\u306E\u884C\u6570\u304C\u5024\u57DF\u306E\u30B5\
    \u30A4\u30BA\u3068\u4E00\u81F4\u3057\u307E\u305B\u3093\")\n        for row in\
    \ costs:\n            if row.len != kj:\n                raise newException(ValueError,\
    \ \"2\u5909\u6570\u8CBB\u7528\u8868\u306E\u5217\u6570\u304C\u5024\u57DF\u306E\u30B5\
    \u30A4\u30BA\u3068\u4E00\u81F4\u3057\u307E\u305B\u3093\")\n        if i == j:\n\
    \            var diagonal = newSeq[Cost](ki)\n            for a in 0..<ki: diagonal[a]\
    \ = costs[a][a]\n            opt.add_unary_cost(i, diagonal)\n            return\n\
    \        var rowDiffs = newSeq[Cost](ki - 1)\n        var colDiffs = newSeq[Cost](kj\
    \ - 1)\n        var mixed = newSeq[seq[Cost]](ki - 1)\n        for a in 1..<ki:\
    \ rowDiffs[a - 1] = kpsSub(costs[a][0], costs[a - 1][0])\n        for b in 1..<kj:\
    \ colDiffs[b - 1] = kpsSub(costs[0][b], costs[0][b - 1])\n        for a in 1..<ki:\n\
    \            mixed[a - 1] = newSeq[Cost](kj - 1)\n            for b in 1..<kj:\n\
    \                let left = kpsSub(costs[a][b], costs[a][b - 1])\n           \
    \     let right = kpsSub(costs[a - 1][b], costs[a - 1][b - 1])\n             \
    \   if left > right:\n                    raise newException(ValueError, \"\u5909\
    \u6570 \" & $i & \", \" & $j &\n                        \" \u306E\u8CBB\u7528\u8868\
    \u304CMonge\u6761\u4EF6\u3092\u6E80\u305F\u3057\u307E\u305B\u3093: \u96A3\u63A5\
    \u30BB\u30EB\u306E\u53F3\u4E0B = (\" & $a & \", \" & $b & \")\")\n           \
    \     mixed[a - 1][b - 1] = kpsSub(right, left)\n        opt.binary.add_unary_cost(0,\
    \ costs[0][0], costs[0][0])\n        for a in 1..<ki: opt.binary.add_unary_cost(opt.kpsGe(i,\
    \ a), Cost(0), rowDiffs[a - 1])\n        for b in 1..<kj: opt.binary.add_unary_cost(opt.kpsGe(j,\
    \ b), Cost(0), colDiffs[b - 1])\n        for a in 1..<ki:\n            for b in\
    \ 1..<kj:\n                let w = mixed[a - 1][b - 1]\n                if w !=\
    \ 0:\n                    opt.binary.add_pair_cost(opt.kpsGe(i, a), opt.kpsGe(j,\
    \ b), Cost(0), Cost(0), Cost(0), -w)\n\n    proc add_cost_if_ge_lt*[Cost](opt:\
    \ var KProjectSelection[Cost], i, lower_i, j, lower_j: int, w: Cost) =\n     \
    \   ## x[i] >= lower_i\u304B\u3064x[j] < lower_j\u306A\u3089\u975E\u8CA0\u306E\
    \u8CBB\u7528w\u3092\u52A0\u7B97\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n    \
    \    let a = opt.kpsGe(i, lower_i)\n        let b = opt.kpsGe(j, lower_j)\n  \
    \      opt.binary.add_cost_if_true_false(a, b, w)\n\n    proc add_gain_if_all_ge*[Cost](opt:\
    \ var KProjectSelection[Cost], conditions: openArray[tuple[variable, threshold:\
    \ int]], w: Cost) =\n        ## \u5168\u6761\u4EF6x[variable] >= threshold\u3092\
    \u6E80\u305F\u3059\u3068\u975E\u8CA0\u306E\u5229\u76CAw\u3002\u7A7A\u306A\u3089\
    \u5E38\u306B\u5229\u76CA\u3002O(|conditions|)\u3002\n        var ids: seq[int]\n\
    \        for c in conditions: ids.add(opt.kpsGe(c.variable, c.threshold))\n  \
    \      opt.binary.add_gain_if_all(ids, true, w)\n\n    proc add_gain_if_all_le*[Cost](opt:\
    \ var KProjectSelection[Cost], conditions: openArray[tuple[variable, threshold:\
    \ int]], w: Cost) =\n        ## \u5168\u6761\u4EF6x[variable] <= threshold\u3092\
    \u6E80\u305F\u3059\u3068\u975E\u8CA0\u306E\u5229\u76CAw\u3002\u7A7A\u306A\u3089\
    \u5E38\u306B\u5229\u76CA\u3002O(|conditions|)\u3002\n        var ids: seq[int]\n\
    \        for c in conditions: ids.add(opt.kpsGt(c.variable, c.threshold))\n  \
    \      opt.binary.add_gain_if_all(ids, false, w)\n\n    proc set_min*[Cost](opt:\
    \ var KProjectSelection[Cost], i, lower: int) =\n        ## x[i] >= lower\u3092\
    \u5F37\u5236\u3059\u308B\u3002lower == sizes[i]\u306A\u3089\u5B9F\u884C\u4E0D\u80FD\
    \u3002\u511F\u5374O(1)\u3002\n        opt.binary.force(opt.kpsGe(i, lower), true)\n\
    \n    proc set_max*[Cost](opt: var KProjectSelection[Cost], i, upper: int) =\n\
    \        ## x[i] <= upper\u3092\u5F37\u5236\u3059\u308B\u3002upper == -1\u306A\
    \u3089\u5B9F\u884C\u4E0D\u80FD\u3002\u511F\u5374O(1)\u3002\n        opt.binary.force(opt.kpsGt(i,\
    \ upper), false)\n\n    proc force*[Cost](opt: var KProjectSelection[Cost], i,\
    \ value: int) =\n        ## x[i] == value\u3092\u5F37\u5236\u3059\u308B\u3002\u511F\
    \u5374O(1)\u3002\n        opt.kpsCheckIndex(i)\n        if value < 0 or value\
    \ >= opt.sizes[i]:\n            raise newException(ValueError, \"\u56FA\u5B9A\u3059\
    \u308B\u5024\u304C\u5024\u57DF\u5916\u3067\u3059\")\n        opt.set_min(i, value)\n\
    \        opt.set_max(i, value)\n\n    proc imply*[Cost](opt: var KProjectSelection[Cost],\
    \ i, lower_i, j, lower_j: int) =\n        ## x[i] >= lower_i\u306A\u3089x[j] >=\
    \ lower_j\u3092\u5F37\u5236\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        let\
    \ a = opt.kpsGe(i, lower_i)\n        let b = opt.kpsGe(j, lower_j)\n        opt.binary.imply(a,\
    \ b)\n\n    proc solve*[Cost](opt: KProjectSelection[Cost]): KProjectSelectionResult[Cost]\
    \ =\n        ## \u6700\u5C0F\u8CBB\u7528\u3068\u6574\u6570\u306E\u5272\u5F53\u3092\
    \u8FD4\u3059\u3002\u77DB\u76FE\u6642\u306Ffeasible=false\u3002\u5185\u90E8\u30B0\
    \u30E9\u30D5\u3067O(V^2 E)\u3002\u518D\u5B9F\u884C\u53EF\u3002\n        let answer\
    \ = opt.binary.solve()\n        if not answer.feasible: return\n        result.feasible\
    \ = true\n        result.min_cost = answer.min_cost\n        result.assignment\
    \ = newSeq[int](opt.sizes.len)\n        for i, k in opt.sizes:\n            for\
    \ t in 1..<k:\n                if answer.assignment[opt.kpsGe(i, t)]: inc result.assignment[i]\n"
  dependsOn:
  - cplib/utils/project_selection.nim
  - cplib/graph/maxflow.nim
  - cplib/graph/maxflow.nim
  - cplib/utils/project_selection.nim
  isVerificationFile: false
  path: cplib/utils/k_project_selection.nim
  requiredBy: []
  timestamp: '2026-09-14 12:19:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/k_project_selection_abc326g_test.nim
  - verify/utils/k_project_selection_abc326g_test.nim
  - verify/AI/k_project_selection_test.nim
  - verify/AI/k_project_selection_test.nim
documentation_of: cplib/utils/k_project_selection.nim
layout: document
redirect_from:
- /library/cplib/utils/k_project_selection.nim
- /library/cplib/utils/k_project_selection.nim.html
title: cplib/utils/k_project_selection.nim
---
