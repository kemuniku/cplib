---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/graph/functional_graph\nimport cplib/graph/graph\nimport atcoder/lazysegtree\n\
    import std/random\n\ntype\n    Sum = tuple[sum,len:int]\n    Affine = tuple[a,b:int]\n\
    \nproc sumOp(x,y:Sum):Sum=\n    return (x.sum+y.sum,x.len+y.len)\n\nproc sumE():Sum=\n\
    \    return (0,0)\n\nproc affineMapping(f:Affine,x:Sum):Sum=\n    return (f.a*x.sum+f.b*x.len,x.len)\n\
    \nproc affineComposition(f,g:Affine):Affine=\n    # f(g(x))\n    return (f.a*g.a,f.a*g.b+f.b)\n\
    \nproc affineId():Affine=\n    return (1,0)\n\nlet nxt = @[1,2,3,1,2,5,7,6,7]\n\
    var naive = @[1,2,3,4,5,6,7,8,9]\nvar initial = newSeq[Sum](len(naive))\nfor i,x\
    \ in naive:\n    initial[i] = (x,1)\n\nvar fg = initFunctionalGraph_with_lazy_op(\n\
    \    nxt,initial,sumOp,sumE,affineMapping,affineComposition,affineId\n)\n\nproc\
    \ applyNaive(start,k:int,f:Affine,includeStart:bool)=\n    var now = start\n \
    \   if includeStart:\n        for step in 0..k:\n            naive[now] = f.a*naive[now]+f.b\n\
    \            if step < k:\n                now = nxt[now]\n    else:\n       \
    \ for step in 0..<k:\n            now = nxt[now]\n            naive[now] = f.a*naive[now]+f.b\n\
    \nproc prodNaive(start,k:int,includeStart:bool):Sum=\n    var now = start\n  \
    \  if includeStart:\n        for step in 0..k:\n            result.sum += naive[now]\n\
    \            result.len += 1\n            if step < k:\n                now =\
    \ nxt[now]\n    else:\n        for step in 0..<k:\n            now = nxt[now]\n\
    \            result.sum += naive[now]\n            result.len += 1\n\nrandomize(123456)\n\
    for iteration in 0..<400:\n    let start = rand(nxt.high)\n    let k = rand(30)\n\
    \    let includeStart = rand(1) == 1\n    let action:Affine = (rand(1),rand(5))\n\
    \    fg.apply(start,k,action,includeStart)\n    applyNaive(start,k,action,includeStart)\n\
    \n    if iteration mod 7 == 0:\n        let v = rand(nxt.high)\n        let x\
    \ = rand(20)\n        fg[v] = (x,1)\n        naive[v] = x\n\n    for v in 0..<len(nxt):\n\
    \        doAssert fg[v] == (naive[v],1)\n\n    let queryStart = rand(nxt.high)\n\
    \    let queryK = rand(40)\n    let queryIncludeStart = rand(1) == 1\n    doAssert\
    \ fg.prod(queryStart,queryK,queryIncludeStart) ==\n        prodNaive(queryStart,queryK,queryIncludeStart)\n\
    \n    if iteration mod 11 == 0:\n        let l = rand(10)\n        let r = l+rand(8)\n\
    \        let products = fg.prod_range(queryStart,l,r,queryIncludeStart)\n    \
    \    for i,value in products:\n            doAssert value == prodNaive(queryStart,l+i,queryIncludeStart)\n\
    \n        let folded = fg.prod_range_fold(\n            queryStart,l,r,\n    \
    \        proc(total:int,value:Sum):int = total+value.sum,\n            0,queryIncludeStart\n\
    \        )\n        var expected = 0\n        for step in l..<r:\n           \
    \ expected += prodNaive(queryStart,step,queryIncludeStart).sum\n        doAssert\
    \ folded == expected\n\n    if iteration mod 13 == 0:\n        let limit = rand(25)\n\
    \        let threshold = rand(150)\n        var now = queryStart\n        var\
    \ prefix = 0\n        var expected = limit\n        for step in 0..limit:\n  \
    \          prefix += naive[now]\n            if prefix > threshold:\n        \
    \        expected = step\n                break\n            if step < limit:\n\
    \                now = nxt[now]\n        doAssert fg.move_while(proc(x:Sum):bool\
    \ = x.sum <= threshold,queryStart,limit) == expected\n\n# \u81EA\u5DF1\u30EB\u30FC\
    \u30D7\u3067\u306Fk\u56DE\u79FB\u52D5\u3059\u308B\u3068\u59CB\u70B9\u306Bk+1\u56DE\
    \u4F5C\u7528\u3059\u308B\u3002\nlet before = fg[5].sum\nfg.apply(5,12,(1,2))\n\
    doAssert fg[5].sum == before+26\nlet hugeK = 1_000_000_000\nlet beforeHuge = fg[5].sum\n\
    fg.apply(5,hugeK,(1,1))\ndoAssert fg[5].sum == beforeHuge+hugeK+1\ndoAssert fg.prod(5,hugeK)\
    \ == ((beforeHuge+hugeK+1)*(hugeK+1),hugeK+1)\n\n# \u7570\u306A\u308B\u4F5C\u7528\
    \u3092push\u305B\u305A\u91CD\u306D\u305F\u5834\u5408\u3082composition(new, old)\u306E\
    \u9806\u306B\u306A\u308B\u3002\nvar compositionFg = initFunctionalGraph_with_lazy_op(\n\
    \    @[0],@[(sum:1,len:1)],sumOp,sumE,\n    affineMapping,affineComposition,affineId\n\
    )\ncompositionFg.apply(0,3,(0,3)) # \u4F55\u5EA6\u4F5C\u7528\u3057\u3066\u3082\
    3\u3078\u306E\u4EE3\u5165\ncompositionFg.apply(0,2,(1,5)) # \u305D\u306E\u5F8C\
    \u30013\u56DE\u306E+5\ndoAssert compositionFg.prod(0,4) == (18*5,5)\ndoAssert\
    \ compositionFg[0] == (18,1)\n\nproc minOp(x,y:int):int=\n    return min(x,y)\n\
    \nproc minE():int=\n    return int.high div 4\n\nproc addMapping(f,x:int):int=\n\
    \    if x == minE():\n        return x\n    return x+f\n\nproc addComposition(f,g:int):int=\n\
    \    return f+g\n\nproc addId():int=\n    return 0\n\nvar minValues = @[9,4,8,2,7,6,3,5,1]\n\
    # \u8FFD\u52A0\u5F15\u6570\u4ED8\u304D\u306E\u5F93\u6765\u540D\u3082lazy\u7248\
    \u30B3\u30F3\u30B9\u30C8\u30E9\u30AF\u30BF\u3068\u3057\u3066\u4F7F\u3048\u308B\
    \u3002\nvar minFg = initFunctionalGraph_with_op(\n    nxt,minValues,minOp,minE,addMapping,addComposition,addId\n\
    )\nminFg.apply(4,17,3)\nvar now = 4\nfor step in 0..17:\n    minValues[now] +=\
    \ 3\n    if step < 17:\n        now = nxt[now]\n\nlet allReachable = minFg.prod_reachable_idempotent_all()\n\
    for start in 0..<len(nxt):\n    var seen = newSeq[bool](len(nxt))\n    var v =\
    \ start\n    var expected = minE()\n    while not seen[v]:\n        seen[v] =\
    \ true\n        expected = min(expected,minValues[v])\n        v = nxt[v]\n  \
    \  doAssert allReachable[start] == expected\n\n# \u5168lazy\u3092push\u3059\u308B\
    \u4E00\u62EC\u53D6\u5F97\u5F8C\u3082apply/set/prod\u3092\u7D99\u7D9A\u5229\u7528\
    \u3067\u304D\u308B\u3002\nminFg.apply(0,11,2)\nnow = 0\nfor step in 0..11:\n \
    \   minValues[now] += 2\n    if step < 11:\n        now = nxt[now]\nminFg[4] =\
    \ -3\nminValues[4] = -3\nvar expectedMin = minE()\nnow = 4\nfor step in 0..20:\n\
    \    expectedMin = min(expectedMin,minValues[now])\n    if step < 20:\n      \
    \  now = nxt[now]\ndoAssert minFg.prod(4,20) == expectedMin\n\n# UnWeightedDirectedGraph\u304B\
    \u3089\u306E\u69CB\u7BC9\u3082\u78BA\u8A8D\u3059\u308B\u3002\nvar g = initUnWeightedDirectedGraph(len(nxt))\n\
    for v,to in nxt:\n    g.add_edge(v,to)\nlet graphFg = initFunctionalGraph_with_lazy_op(\n\
    \    g,initial,sumOp,sumE,affineMapping,affineComposition,affineId\n)\ndoAssert\
    \ graphFg.movekth(0,4) == 1\n\n# typedesc\u7248\u306A\u3089\u8907\u6570\u30A4\u30F3\
    \u30B9\u30BF\u30F3\u30B9\u3092\u540C\u3058\u660E\u793A\u578B\u3067\u4FDD\u6301\
    \u3067\u304D\u308B\u3002\ntype SumLazySeg = LazySegTree.getType(\n    Sum,Affine,sumOp,sumE,affineMapping,affineComposition,affineId\n\
    )\nvar sameTypeFgs:seq[FunctionalGraph_with_lazy_op[SumLazySeg]]\nsameTypeFgs.add(initFunctionalGraph_with_lazy_op(nxt,initial,SumLazySeg))\n\
    sameTypeFgs.add(initFunctionalGraph_with_lazy_op(g,initial,SumLazySeg))\ndoAssert\
    \ sameTypeFgs[0].prod(0,3) == sameTypeFgs[1].prod(0,3)\n\n# \u5F62\u306E\u7570\
    \u306A\u308B\u5C0F\u3055\u306Afunctional graph\u3067\u3082\u611A\u76F4\u6CD5\u3068\
    \u6BD4\u8F03\u3059\u308B\u3002\nfor testCase in 0..<30:\n    let n = 1+rand(11)\n\
    \    var randomNext = newSeq[int](n)\n    var randomNaive = newSeq[int](n)\n \
    \   var randomInitial = newSeq[Sum](n)\n    for v in 0..<n:\n        randomNext[v]\
    \ = rand(n-1)\n        randomNaive[v] = rand(15)\n        randomInitial[v] = (randomNaive[v],1)\n\
    \    var randomFg = initFunctionalGraph_with_lazy_op(\n        randomNext,randomInitial,sumOp,sumE,affineMapping,affineComposition,affineId\n\
    \    )\n\n    for operation in 0..<80:\n        let start = rand(n-1)\n      \
    \  let k = rand(25)\n        let includeStart = rand(1) == 1\n        let action:Affine\
    \ = (rand(1),rand(4))\n        randomFg.apply(start,k,action,includeStart)\n\n\
    \        var now = start\n        if includeStart:\n            for step in 0..k:\n\
    \                randomNaive[now] = action.a*randomNaive[now]+action.b\n     \
    \           if step < k:\n                    now = randomNext[now]\n        else:\n\
    \            for step in 0..<k:\n                now = randomNext[now]\n     \
    \           randomNaive[now] = action.a*randomNaive[now]+action.b\n\n        if\
    \ operation mod 9 == 0:\n            let v = rand(n-1)\n            let value\
    \ = rand(15)\n            randomFg[v] = (value,1)\n            randomNaive[v]\
    \ = value\n\n        let queryStart = rand(n-1)\n        let queryK = rand(30)\n\
    \        let queryIncludeStart = rand(1) == 1\n        var expected:Sum\n    \
    \    now = queryStart\n        if queryIncludeStart:\n            for step in\
    \ 0..queryK:\n                expected = sumOp(expected,(randomNaive[now],1))\n\
    \                if step < queryK:\n                    now = randomNext[now]\n\
    \        else:\n            for step in 0..<queryK:\n                now = randomNext[now]\n\
    \                expected = sumOp(expected,(randomNaive[now],1))\n        doAssert\
    \ randomFg.prod(queryStart,queryK,queryIncludeStart) == expected\n\n        if\
    \ operation mod 8 == 0:\n            let l = rand(8)\n            let r = l+rand(7)\n\
    \            let products = randomFg.prod_range(queryStart,l,r,queryIncludeStart)\n\
    \            for i,product in products:\n                var expected:Sum\n  \
    \              now = queryStart\n                if queryIncludeStart:\n     \
    \               for step in 0..(l+i):\n                        expected = sumOp(expected,(randomNaive[now],1))\n\
    \                        if step < l+i:\n                            now = randomNext[now]\n\
    \                else:\n                    for step in 0..<(l+i):\n         \
    \               now = randomNext[now]\n                        expected = sumOp(expected,(randomNaive[now],1))\n\
    \                doAssert product == expected\n\n        if operation mod 10 ==\
    \ 0:\n            let limit = rand(25)\n            let threshold = rand(150)\n\
    \            var expectedDistance = limit\n            var prefix = 0\n      \
    \      now = queryStart\n            for step in 0..limit:\n                prefix\
    \ += randomNaive[now]\n                if prefix > threshold:\n              \
    \      expectedDistance = step\n                    break\n                if\
    \ step < limit:\n                    now = randomNext[now]\n            doAssert\
    \ randomFg.move_while(\n                proc(x:Sum):bool = x.sum <= threshold,queryStart,limit\n\
    \            ) == expectedDistance\n\n        # query\u7FA4\u306Fpoint get\u3067\
    lazy\u3092\u62BC\u3059\u524D\u306B\u691C\u8A3C\u3059\u308B\u3002\n        for\
    \ v in 0..<n:\n            doAssert randomFg[v] == (randomNaive[v],1)\n\nproc\
    \ intAdd(x,y:int):int=\n    return x+y\n\n# 4\u5F15\u6570\u306E\u65E2\u5B58\u30B3\
    \u30F3\u30B9\u30C8\u30E9\u30AF\u30BF\u306F\u5F93\u6765\u3069\u304A\u308A\u975E\
    \u9045\u5EF6\u7248\u3092\u8FD4\u3059\u3002\nlet oldFg = initFunctionalGraph_with_op(nxt,@[1,2,3,4,5,6,7,8,9],intAdd,0)\n\
    doAssert oldFg.prod(0,5) == 1+2+3+4+2+3\n\n# \u975E\u53EF\u63DB\u306Aop\u3067\u3082\
    functional graph\u4E0A\u306E\u79FB\u52D5\u9806\u3092\u4FDD\u3064\u3002\nproc concatOp(x,y:seq[int]):seq[int]=\n\
    \    return x & y\n\nproc concatE():seq[int]=\n    return @[]\n\nproc seqAddMapping(f:int,x:seq[int]):seq[int]=\n\
    \    result = newSeq[int](len(x))\n    for i,value in x:\n        result[i] =\
    \ value+f\n\nproc seqAddComposition(f,g:int):int=\n    return f+g\n\nproc seqAddId():int=\n\
    \    return 0\n\nlet orderNext = @[1,2,3,1,2,4]\nvar orderNaive = @[0,1,2,3,4,5]\n\
    var orderInitial = newSeq[seq[int]](len(orderNaive))\nfor i,value in orderNaive:\n\
    \    orderInitial[i] = @[value]\nvar orderFg = initFunctionalGraph_with_lazy_op(\n\
    \    orderNext,orderInitial,concatOp,concatE,\n    seqAddMapping,seqAddComposition,seqAddId\n\
    )\nfor iteration in 0..<120:\n    let start = rand(orderNext.high)\n    let k\
    \ = rand(25)\n    let add = rand(5)\n    orderFg.apply(start,k,add)\n    var now\
    \ = start\n    for step in 0..k:\n        orderNaive[now] += add\n        if step\
    \ < k:\n            now = orderNext[now]\n\n    let queryStart = rand(orderNext.high)\n\
    \    let queryK = rand(30)\n    var expected = newSeqOfCap[int](queryK+1)\n  \
    \  now = queryStart\n    for step in 0..queryK:\n        expected.add(orderNaive[now])\n\
    \        if step < queryK:\n            now = orderNext[now]\n    doAssert orderFg.prod(queryStart,queryK)\
    \ == expected\n\n    if iteration mod 7 == 0:\n        let l = rand(8)\n     \
    \   let r = l+rand(6)\n        let products = orderFg.prod_range(queryStart,l,r)\n\
    \        for i,product in products:\n            var expected:seq[int]\n     \
    \       now = queryStart\n            for step in 0..(l+i):\n                expected.add(orderNaive[now])\n\
    \                if step < l+i:\n                    now = orderNext[now]\n  \
    \          doAssert product == expected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/graph.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: true
  path: verify/AI/functional_graph_lazy_op_test.nim
  requiredBy: []
  timestamp: '2026-07-16 11:31:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/functional_graph_lazy_op_test.nim
layout: document
redirect_from:
- /verify/verify/AI/functional_graph_lazy_op_test.nim
- /verify/verify/AI/functional_graph_lazy_op_test.nim.html
title: verify/AI/functional_graph_lazy_op_test.nim
---
