---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/two_sat_test.nim
    title: verify/AI/two_sat_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/two_sat_test.nim
    title: verify/AI/two_sat_test.nim
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
  code: "## \u5F0F\u304B\u3089\u5236\u7D04\u3092\u8FFD\u52A0\u3059\u308B2-SAT\u3002\
    \u5909\u6570\u756A\u53F7\u306F0\u59CB\u307E\u308A\u3067\u3001\u89E3\u306E\u9078\
    \u3073\u65B9\u306F\u4FDD\u8A3C\u3057\u306A\u3044\u3002\n## Problem2sat\u306E\u4EE3\
    \u5165\u306F\u540C\u3058\u554F\u984C\u3092\u5171\u6709\u3059\u308B\u3002solve\u5F8C\
    \u3082\u5236\u7D04\u8FFD\u52A0\u3068\u518D\u6C42\u89E3\u304C\u53EF\u80FD\u3002\
    \n## or\u3001nand\u3001xor\u3001^\u3001==\u3001!=\u3001implies\u306F\u30EA\u30C6\
    \u30E9\u30EB\u540C\u58EB\u306B\u4F7F\u7528\u3059\u308B\u3002\n## ==\u3068!=\u306F\
    bool\u3068\u306E\u6BD4\u8F03\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u30023\u500B\u4EE5\
    \u4E0A\u306E\u30EA\u30C6\u30E9\u30EB\u306EOR\u306F\u6271\u308F\u306A\u3044\u3002\
    \nwhen not declared CPLIB_GRAPH_TWO_SAT:\n    const CPLIB_GRAPH_TWO_SAT* = 1\n\
    \n    type\n        Problem2sat* = ref object\n            clauses: seq[tuple[a,\
    \ b: int]]\n            evaluated: bool\n            assignment: seq[bool]\n \
    \           solved: bool\n        Literal2sat* = object\n            problem:\
    \ Problem2sat\n            vertex: int\n        Constraint2sat* = object\n   \
    \         problem: Problem2sat\n            clauses: array[2, tuple[a, b: int]]\n\
    \            count: int\n\n    proc initTwoSat*(n: int): Problem2sat =\n     \
    \   ## n\u500B\u306E\u5909\u6570\u3092\u6301\u3064\u554F\u984C\u3092\u751F\u6210\
    \u3059\u308B\u3002O(n)\u3002\n        if n < 0:\n            raise newException(ValueError,\
    \ \"\u5909\u6570\u306E\u500B\u6570\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\")\n        Problem2sat(assignment: newSeq[bool](n))\n\
    \n    proc `[]`*(p: Problem2sat, k: int): Literal2sat =\n        ## 0\u59CB\u307E\
    \u308A\u306E\u756A\u53F7k\u306E\u5909\u6570\u3092\u53D6\u5F97\u3059\u308B\u3002\
    O(1)\u3002\n        if p.isNil:\n            raise newException(ValueError, \"\
    \u554F\u984C\u304C\u521D\u671F\u5316\u3055\u308C\u3066\u3044\u307E\u305B\u3093\
    \")\n        if k < 0 or k >= p.assignment.len:\n            raise newException(IndexDefect,\
    \ \"\u5909\u6570\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\")\n        Literal2sat(problem:\
    \ p, vertex: 2 * k + 1)\n\n    proc toLiteral*(a: Literal2sat): Literal2sat =\n\
    \        ## \u30EA\u30C6\u30E9\u30EB\u3092\u305D\u306E\u307E\u307E\u8FD4\u3059\
    \u3002O(1)\u3002\n        a\n\n    proc `not`*(a: Literal2sat): Literal2sat =\n\
    \        ## \u30EA\u30C6\u30E9\u30EB\u3092\u5426\u5B9A\u3059\u308B\u3002O(1)\u3002\
    \n        result = a\n        result.vertex = result.vertex xor 1\n\n    proc\
    \ `or`*(a, b: Literal2sat): Constraint2sat =\n        ## \u5C11\u306A\u304F\u3068\
    \u3082\u4E00\u65B9\u304C\u771F\u3068\u306A\u308B\u5236\u7D04\u3092\u751F\u6210\
    \u3059\u308B\u3002O(1)\u3002\n        let x = a\n        let y = b\n        if\
    \ x.problem.isNil or x.problem != y.problem:\n            raise newException(ValueError,\
    \ \"\u540C\u3058\u554F\u984C\u306B\u6240\u5C5E\u3059\u308B\u5909\u6570\u304C\u5FC5\
    \u8981\u3067\u3059\")\n        result.problem = x.problem\n        result.clauses[0]\
    \ = (x.vertex, y.vertex)\n        result.count = 1\n\n    proc nand*(a, b: Literal2sat):\
    \ Constraint2sat =\n        ## \u4E21\u65B9\u304C\u540C\u6642\u306B\u771F\u306B\
    \u306A\u308B\u3053\u3068\u3092\u7981\u6B62\u3059\u308B\u5236\u7D04\u3092\u751F\
    \u6210\u3059\u308B\u3002O(1)\u3002\n        (not a) or (not b)\n\n    proc implies*(a,\
    \ b: Literal2sat): Constraint2sat =\n        ## a\u304C\u771F\u306A\u3089b\u3082\
    \u771F\u3068\u306A\u308B\u5236\u7D04\u3092\u751F\u6210\u3059\u308B\u3002O(1)\u3002\
    \n        (not a) or b\n\n    proc `xor`*(a, b: Literal2sat): Constraint2sat =\n\
    \        ## \u3061\u3087\u3046\u3069\u4E00\u65B9\u304C\u771F\u3068\u306A\u308B\
    \u5236\u7D04\u3092\u751F\u6210\u3059\u308B\u3002O(1)\u3002\n        result = a\
    \ or b\n        result.clauses[1] = (result.clauses[0].a xor 1, result.clauses[0].b\
    \ xor 1)\n        result.count = 2\n\n    proc `^`*(a, b: Literal2sat): Constraint2sat\
    \ =\n        ## \u3061\u3087\u3046\u3069\u4E00\u65B9\u304C\u771F\u3068\u306A\u308B\
    \u5236\u7D04\u3092\u751F\u6210\u3059\u308B\u3002O(1)\u3002\n        a xor b\n\n\
    \    proc `==`*(a: Literal2sat, b: Literal2sat): Constraint2sat =\n        ##\
    \ \u4E21\u65B9\u304C\u540C\u3058\u771F\u507D\u5024\u3068\u306A\u308B\u5236\u7D04\
    \u3092\u751F\u6210\u3059\u308B\u3002O(1)\u3002\n        a xor (not b)\n\n    proc\
    \ `!=`*(a: Literal2sat, b: Literal2sat): Constraint2sat =\n        ## \u4E21\u65B9\
    \u304C\u7570\u306A\u308B\u771F\u507D\u5024\u3068\u306A\u308B\u5236\u7D04\u3092\
    \u751F\u6210\u3059\u308B\u3002O(1)\u3002\n        a xor b\n\n    proc `==`*(a:\
    \ Literal2sat, b: bool): Constraint2sat =\n        ## \u30EA\u30C6\u30E9\u30EB\
    \u306E\u771F\u507D\u5024\u3092\u56FA\u5B9A\u3059\u308B\u5236\u7D04\u3092\u751F\
    \u6210\u3059\u308B\u3002O(1)\u3002\n        if b: a or a\n        else: (not a)\
    \ or (not a)\n\n    proc `==`*(a: bool, b: Literal2sat): Constraint2sat =\n  \
    \      ## \u30EA\u30C6\u30E9\u30EB\u306E\u771F\u507D\u5024\u3092\u56FA\u5B9A\u3059\
    \u308B\u5236\u7D04\u3092\u751F\u6210\u3059\u308B\u3002O(1)\u3002\n        b ==\
    \ a\n\n    proc `!=`*(a: Literal2sat, b: bool): Constraint2sat =\n        ## \u30EA\
    \u30C6\u30E9\u30EB\u3092\u6307\u5B9A\u5024\u3068\u7570\u306A\u308B\u771F\u507D\
    \u5024\u306B\u56FA\u5B9A\u3059\u308B\u3002O(1)\u3002\n        a == (not b)\n\n\
    \    proc `!=`*(a: bool, b: Literal2sat): Constraint2sat =\n        ## \u30EA\u30C6\
    \u30E9\u30EB\u3092\u6307\u5B9A\u5024\u3068\u7570\u306A\u308B\u771F\u507D\u5024\
    \u306B\u56FA\u5B9A\u3059\u308B\u3002O(1)\u3002\n        b == (not a)\n\n    proc\
    \ `+=`*(p: Problem2sat, constraint: Constraint2sat) =\n        ## \u5236\u7D04\
    \u3092\u8FFD\u52A0\u3057\u3001\u4EE5\u524D\u306E\u89E3\u3092\u7121\u52B9\u5316\
    \u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        if p.isNil or constraint.problem\
    \ != p or constraint.count == 0:\n            raise newException(ValueError, \"\
    \u3053\u306E\u554F\u984C\u306B\u6240\u5C5E\u3059\u308B\u5236\u7D04\u304C\u5FC5\
    \u8981\u3067\u3059\")\n        for i in 0..<constraint.count:\n            p.clauses.add(constraint.clauses[i])\n\
    \        p.solved = false\n        p.evaluated = false\n\n    proc add_clause*(p:\
    \ Problem2sat, i: int, f: bool, j: int, g: bool) =\n        ## (\u5909\u6570i\
    \ == f) or (\u5909\u6570j == g) \u3092\u8FFD\u52A0\u3057\u3001\u4EE5\u524D\u306E\
    \u89E3\u3092\u7121\u52B9\u5316\u3059\u308B\u3002\u511F\u5374O(1)\u3002\n     \
    \   let a = if f: p[i] else: not p[i]\n        let b = if g: p[j] else: not p[j]\n\
    \        p += a or b\n\n    proc solve*(p: Problem2sat): bool =\n        ## \u5168\
    \u5236\u7D04\u3092\u89E3\u304D\u3001\u89E3\u304C\u5B58\u5728\u3059\u308B\u304B\
    \u8FD4\u3059\u3002O(n+m)\u3001\u5236\u7D04\u8FFD\u52A0\u306A\u3057\u306E\u518D\
    \u5B9F\u884C\u306FO(1)\u3002\n        if p.isNil:\n            raise newException(ValueError,\
    \ \"\u554F\u984C\u304C\u521D\u671F\u5316\u3055\u308C\u3066\u3044\u307E\u305B\u3093\
    \")\n        if p.evaluated:\n            return p.solved\n        p.solved =\
    \ false\n        let n = p.assignment.len * 2\n        var offsets = newSeq[int](n\
    \ + 1)\n        for (a, b) in p.clauses:\n            inc offsets[(a xor 1) +\
    \ 1]\n            inc offsets[(b xor 1) + 1]\n        for v in 0..<n:\n      \
    \      offsets[v + 1] += offsets[v]\n        var cursor = newSeq[int](n)\n   \
    \     for v in 0..<n:\n            cursor[v] = offsets[v]\n        var edges =\
    \ newSeq[int](2 * p.clauses.len)\n        for (a, b) in p.clauses:\n         \
    \   edges[cursor[a xor 1]] = b\n            inc cursor[a xor 1]\n            edges[cursor[b\
    \ xor 1]] = a\n            inc cursor[b xor 1]\n        for v in 0..<n:\n    \
    \        cursor[v] = offsets[v]\n\n        var used = newSeq[bool](n)\n      \
    \  var order = newSeqOfCap[int](n)\n        var stack = newSeqOfCap[int](n)\n\
    \        for root in 0..<n:\n            if used[root]: continue\n           \
    \ used[root] = true\n            stack.add(root)\n            while stack.len\
    \ > 0:\n                let v = stack[^1]\n                if cursor[v] == offsets[v\
    \ + 1]:\n                    order.add(v)\n                    stack.setLen(stack.len\
    \ - 1)\n                else:\n                    let dst = edges[cursor[v]]\n\
    \                    inc cursor[v]\n                    if not used[dst]:\n  \
    \                      used[dst] = true\n                        stack.add(dst)\n\
    \n        var component = newSeq[int](n)\n        for v in 0..<n:\n          \
    \  component[v] = -1\n        var id = 0\n        for i in countdown(order.len\
    \ - 1, 0):\n            let root = order[i]\n            if component[root] !=\
    \ -1: continue\n            component[root] = id\n            stack.add(root)\n\
    \            while stack.len > 0:\n                let v = stack.pop()\n     \
    \           # \u542B\u610F\u306E\u5BFE\u5076\u3092\u4F7F\u3044\u3001\u9006\u8FBA\
    \u3092\u4FDD\u5B58\u305B\u305A\u306B\u9006\u30B0\u30E9\u30D5\u3092\u8D70\u67FB\
    \u3059\u308B\u3002\n                let opposite = v xor 1\n                for\
    \ e in offsets[opposite]..<offsets[opposite + 1]:\n                    let dst\
    \ = edges[e] xor 1\n                    if component[dst] == -1:\n           \
    \             component[dst] = id\n                        stack.add(dst)\n  \
    \          inc id\n        p.evaluated = true\n        for i in 0..<p.assignment.len:\n\
    \            if component[2 * i] == component[2 * i + 1]:\n                return\
    \ false\n            p.assignment[i] = component[2 * i] < component[2 * i + 1]\n\
    \        p.solved = true\n        return true\n\n    proc satisfiable*(p: Problem2sat):\
    \ bool =\n        ## solve\u3068\u540C\u69D8\u306B\u5168\u5236\u7D04\u3092\u89E3\
    \u304F\u3002O(n+m)\u3001\u5236\u7D04\u8FFD\u52A0\u306A\u3057\u306E\u518D\u5B9F\
    \u884C\u306FO(1)\u3002\n        p.solve()\n\n    proc answer*(p: Problem2sat):\
    \ seq[bool] =\n        ## \u6700\u5F8C\u306B\u6210\u529F\u3057\u305F\u6C42\u89E3\
    \u3067\u306E\u5168\u5909\u6570\u306E\u5024\u3092\u30B3\u30D4\u30FC\u3057\u3066\
    \u8FD4\u3059\u3002O(n)\u3002\n        if p.isNil or not p.solved:\n          \
    \  raise newException(ValueError, \"solve\u307E\u305F\u306Fsatisfiable\u304C\u6210\
    \u529F\u3057\u305F\u5F8C\u306B\u89E3\u3092\u53D6\u5F97\u3057\u3066\u304F\u3060\
    \u3055\u3044\")\n        result = newSeq[bool](p.assignment.len)\n        for\
    \ i in 0..<p.assignment.len:\n            result[i] = p.assignment[i]\n\n    proc\
    \ get*(a: Literal2sat): bool =\n        ## \u6700\u5F8C\u306B\u6210\u529F\u3057\
    \u305Fsolve\u3067\u306E\u30EA\u30C6\u30E9\u30EB\u306E\u5024\u3092\u8FD4\u3059\u3002\
    O(1)\u3002\n        if a.problem.isNil or not a.problem.solved:\n            raise\
    \ newException(ValueError, \"solve\u304C\u6210\u529F\u3057\u305F\u5F8C\u306B\u5024\
    \u3092\u53D6\u5F97\u3057\u3066\u304F\u3060\u3055\u3044\")\n        let value =\
    \ a.problem.assignment[a.vertex div 2]\n        if (a.vertex and 1) == 1: value\n\
    \        else: not value\n\n    proc `$`*(a: Literal2sat): string =\n        ##\
    \ \u6709\u52B9\u306A\u89E3\u304C\u3042\u308C\u3070\u771F\u30921\u3001\u507D\u3092\
    0\u3001\u306A\u3051\u308C\u3070-\u3068\u3057\u3066\u8FD4\u3059\u3002O(1)\u3002\
    \n        if a.problem.isNil or not a.problem.solved:\n            return \"-\"\
    \n        if a.get(): \"1\"\n        else: \"0\"\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/two_sat.nim
  requiredBy: []
  timestamp: '2026-09-14 01:57:18+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/two_sat_test.nim
  - verify/AI/two_sat_test.nim
documentation_of: cplib/graph/two_sat.nim
layout: document
redirect_from:
- /library/cplib/graph/two_sat.nim
- /library/cplib/graph/two_sat.nim.html
title: cplib/graph/two_sat.nim
---
