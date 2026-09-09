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
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_STERN_BROCOT_TREE:\n    import cplib/math/fractions\n\
    \    import cplib/graph/graph\n    import sequtils,algorithm,options\n    const\
    \ CPLIB_MATH_STERN_BROCOT_TREE* = 1\n    type SBTNode*[T] = tuple[p:T,q:T,r:T,s:T,depth:T]\n\
    \n    proc den*[T](x:SBTNode[T]):T=\n        return x.q+x.s\n    proc num*[T](x:SBTNode[T]):T=\n\
    \        return x.p + x.r\n    \n    converter toFraction(x:SBTNode[int]):Fraction[int]=\n\
    \        return initFraction(x.num,x.den,false)\n\n    proc continued_fraction_expansion*[T](a,b:T):seq[T]=\n\
    \        assert a >= 1\n        assert b >= 1\n        var a = a\n        var\
    \ b = b\n        while true:\n            result.add(a div b)\n            if\
    \ a mod b == 0:\n                break\n            a -= result[^1] * b\n    \
    \        swap(a,b)\n\n    proc encode_path*[T](a,b:T):seq[(char,T)]=\n       \
    \ var CFE = continued_fraction_expansion(a,b)\n        CFE[^1] -= 1\n        var\
    \ start = 0\n        if CFE[0] == 0:\n            start = 1\n        \n      \
    \  for i in start..<len(CFE):\n            if (i and 1) == 0:\n              \
    \  result.add(('R',CFE[i]))\n            else:\n                result.add(('L',CFE[i]))\n\
    \    \n    proc encode_path*[T](now:SBTNode[T]):seq[(char,T)]=\n        return\
    \ encode_path(now.num(),now.den())\n    \n    proc move_left*[T](now:SBTNode[T],d:T):SBTNode[T]=\n\
    \        return (now.p,now.q,d*now.p+now.r,d*now.q+now.s,now.depth+d)\n\n    proc\
    \ move_right*[T](now:SBTNode[T],d:T):SBTNode[T]=\n        return (now.p+d*now.r,now.q+d*now.s,now.r,now.s,now.depth+d)\n\
    \    \n    proc sbt_root*[T](typ:typedesc[T]):SBTNode[T]=\n        return (T(0),T(1),T(1),T(0),T(0))\n\
    \n    proc sbt_root*():SBTNode[int]=\n        return sbt_root(int)\n\n    proc\
    \ sbt_inf*[T](typ:typedesc[T]):SBTNode[T]=\n        return (T(1),T(0),T(0),T(0),T(-1))\n\
    \n    proc sbt_inf*():SBTNode[int]=\n        return sbt_inf(int)\n\n    proc sbt_zero*[T](typ:typedesc[T]):SBTNode[T]=\n\
    \        return (T(0),T(1),T(0),T(0),T(-1))\n\n    proc sbt_zero*():SBTNode[int]=\n\
    \        return sbt_zero(int)\n    \n\n    \n    proc to_fraction_tuple*[T](x:SBTNode[T]):(T,T)=\n\
    \        return (x.p + x.r,x.q+x.s)\n\n    proc to_SBTNode*[T](a,b:T):SBTNode[T]=\n\
    \        var CFE = continued_fraction_expansion(a,b)\n        CFE[^1] -= 1\n \
    \       var start = 0\n        if CFE[0] == 0:\n            start = 1\n      \
    \  var now = sbt_root(T)\n        \n        for i in start..<len(CFE):\n     \
    \       if (i and 1) == 0:\n                now = move_right(now,CFE[i])\n   \
    \         else:\n                now = move_left(now,CFE[i])\n        return now\n\
    \n    proc to_endpoint_node[T](a,b:T):SBTNode[T]=\n        if b == 0:\n      \
    \      return sbt_inf(T)\n        if a == 0:\n            return sbt_zero(T)\n\
    \        return to_SBTNode(a,b)\n\n    proc max_move_count[T](base,step,n:T):T=\n\
    \        if base > n:\n            return T(-1)\n        if step == 0:\n     \
    \       return n\n        return (n-base) div step\n\n    proc is_inner_node_bounded[T](now:SBTNode[T],n:T):bool=\n\
    \        return now.num() <= n and now.den() <= n\n\n    proc max_inner_move_left_with_bound[T](now:SBTNode[T],n:T):T=\n\
    \        ## move_left(d)\u3067\u3067\u304D\u308Bnode\u81EA\u8EAB\u306E\u5206\u5B50\
    \u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u6700\u5927\u306Ed\u3002\
    \n        return min(max_move_count(now.num(),now.p,n),max_move_count(now.den(),now.q,n))\n\
    \n    proc max_inner_move_right_with_bound[T](now:SBTNode[T],n:T):T=\n       \
    \ ## move_right(d)\u3067\u3067\u304D\u308Bnode\u81EA\u8EAB\u306E\u5206\u5B50\u30FB\
    \u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u6700\u5927\u306Ed\u3002\n \
    \       return min(max_move_count(now.num(),now.r,n),max_move_count(now.den(),now.s,n))\n\
    \n    proc max_endpoint_move_left_with_bound[T](now:SBTNode[T],n:T):T=\n     \
    \   ## move_left(d)\u3067\u65B0\u3057\u304F\u3067\u304D\u308B\u53F3\u7AEF\u306E\
    \u5206\u5B50\u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u6700\u5927\
    \u306Ed\u3002\n        return min(max_move_count(now.r,now.p,n),max_move_count(now.s,now.q,n))\n\
    \n    proc max_endpoint_move_right_with_bound[T](now:SBTNode[T],n:T):T=\n    \
    \    ## move_right(d)\u3067\u65B0\u3057\u304F\u3067\u304D\u308B\u5DE6\u7AEF\u306E\
    \u5206\u5B50\u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u6700\u5927\
    \u306Ed\u3002\n        return min(max_move_count(now.p,now.r,n),max_move_count(now.q,now.s,n))\n\
    \n    proc min_greater_with_den_at_most*[T](x:SBTNode[T],m:T):SBTNode[T]=\n  \
    \      ## x\u3088\u308A\u5927\u304D\u304F\u3001\u5206\u5B50\u30FB\u5206\u6BCD\u304C\
    m\u4EE5\u4E0B\u3067\u3042\u308B\u6709\u7406\u6570\u306E\u3046\u3061\u6700\u5C0F\
    \u306E\u3082\u306E\u3092\u8FD4\u3059\u3002\n        assert m >= 1\n\n        if\
    \ x.is_inner_node_bounded(m):\n            var now = x.move_right(1)\n       \
    \     if not now.is_inner_node_bounded(m):\n                return to_endpoint_node(x.r,x.s)\n\
    \            return now.move_left(now.max_inner_move_left_with_bound(m))\n\n \
    \       var now = sbt_root(T)\n\n        for (c,d) in encode_path(x):\n      \
    \      if c == 'L':\n                let lim = min(d,now.max_inner_move_left_with_bound(m))\n\
    \                now = now.move_left(lim)\n                if lim < d:\n     \
    \               return now\n            else:\n                let lim = min(d,now.max_inner_move_right_with_bound(m))\n\
    \                now = now.move_right(lim)\n                if lim < d:\n    \
    \                return to_endpoint_node(now.r,now.s)\n\n        var nxt = now.move_right(1)\n\
    \        if not nxt.is_inner_node_bounded(m):\n            return to_endpoint_node(now.r,now.s)\n\
    \        return nxt.move_left(nxt.max_inner_move_left_with_bound(m))\n\n    proc\
    \ max_less_with_den_at_most*[T](x:SBTNode[T],m:T):SBTNode[T]=\n        ## x\u3088\
    \u308A\u5C0F\u3055\u304F\u3001\u5206\u5B50\u30FB\u5206\u6BCD\u304Cm\u4EE5\u4E0B\
    \u3067\u3042\u308B\u6709\u7406\u6570\u306E\u3046\u3061\u6700\u5927\u306E\u3082\
    \u306E\u3092\u8FD4\u3059\u3002\n        assert m >= 1\n\n        if x.is_inner_node_bounded(m):\n\
    \            var now = x.move_left(1)\n            if not now.is_inner_node_bounded(m):\n\
    \                return to_endpoint_node(x.p,x.q)\n            return now.move_right(now.max_inner_move_right_with_bound(m))\n\
    \n        var now = sbt_root(T)\n\n        for (c,d) in encode_path(x):\n    \
    \        if c == 'L':\n                let lim = min(d,now.max_inner_move_left_with_bound(m))\n\
    \                now = now.move_left(lim)\n                if lim < d:\n     \
    \               return to_endpoint_node(now.p,now.q)\n            else:\n    \
    \            let lim = min(d,now.max_inner_move_right_with_bound(m))\n       \
    \         now = now.move_right(lim)\n                if lim < d:\n           \
    \         return now\n\n        var nxt = now.move_left(1)\n        if not nxt.is_inner_node_bounded(m):\n\
    \            return to_endpoint_node(now.p,now.q)\n        return nxt.move_right(nxt.max_inner_move_right_with_bound(m))\n\
    \n    proc decode_path*[T](path:seq[(char,T)]):SBTNode[T]=\n        \n       \
    \ var now = sbt_root(T)\n\n        for (c,d) in path:\n            if c == 'L':\n\
    \                now = move_left(now,d)\n            else:\n                now\
    \ = move_right(now,d)\n        return now\n    \n    proc LCA*[T](a,b,c,d:T):SBTNode[T]=\n\
    \        var CFE1 = continued_fraction_expansion(a,b)\n        var CFE2 = continued_fraction_expansion(c,d)\n\
    \        CFE1[^1] -= 1\n        CFE2[^1] -= 1\n        var now = sbt_root(T)\n\
    \n        for i in 0..<min(len(CFE1),len(CFE2)):\n            if (i and 1) ==\
    \ 0:\n                now = move_right(now,min(CFE1[i],CFE2[i]))\n           \
    \ else:\n                now = move_left(now,min(CFE1[i],CFE2[i]))\n         \
    \   if CFE1[i] != CFE2[i]:\n                return now\n        return now\n \
    \   \n    proc LCA*[T](a,b:SBTNode[T]):SBTNode[T]=\n        LCA(a.num(),a.den(),b.num(),b.den())\n\
    \    \n    proc ancestor*[T](a,b,k:T):Option[SBTNode[T]]=\n        var CFE = continued_fraction_expansion(a,b)\n\
    \        CFE[^1] -= 1\n        var now = sbt_root(T)\n        var cnt:T = 0\n\
    \        for i in 0..<len(CFE):\n            if (i and 1) == 0:\n            \
    \    now = move_right(now,min(k-cnt,CFE[i]))\n            else:\n            \
    \    now = move_left(now,min(k-cnt,CFE[i]))\n            cnt += CFE[i]\n     \
    \       if cnt >= k:\n                return some(now)\n        return none(SBTNode[T])\n\
    \    \n    proc ancestor*[T](now:SBTNode[T],k:T):Option[SBTNode[T]]=\n       \
    \ var CFE = continued_fraction_expansion(now.num(),now.den())\n        CFE[^1]\
    \ -= 1\n        var now = sbt_root(T)\n        var cnt:T = 0\n        for i in\
    \ 0..<len(CFE):\n            if (i and 1) == 0:\n                now = move_right(now,min(k-cnt,CFE[i]))\n\
    \            else:\n                now = move_left(now,min(k-cnt,CFE[i]))\n \
    \           cnt += CFE[i]\n            if cnt >= k:\n                return some(now)\n\
    \        return none(SBTNode[T])\n\n    proc get_range*[T](node:SBTNode[T]):(T,T,T,T)=\n\
    \        return (node.p,node.q,node.r,node.s)\n\n    proc get_range_fraction*[T](node:SBTNode[T]):(Fraction[T],Fraction[T])=\n\
    \        return (initFraction(node.p,node.q,false),initFraction(node.r,node.s,false))\n\
    \    \n    proc get_range*[T](a,b:T):(T,T,T,T)=\n        return get_range(to_SBTNode(a,b))\n\
    \n\n    proc get_bounds*[T](is_ok:proc(x:SBTNode[T]):bool,n:T):SBTNode[T]=\n \
    \       # \u5358\u8ABF\u6027\u306E\u3042\u308B\u95A2\u6570is_ok\u3092\u8003\u3048\
    \u308B\u3002\n        # x <= a : true\n        # x > a : false\n        # \u3068\
    \u306A\u308B\u3088\u3046\u306A\u5883\u754Ca\u3092\u5206\u5B50\u30FB\u5206\u6BCD\
    \u304Cn\u4EE5\u4E0B\u306E\u6709\u7406\u6570\u306B\u306A\u308B\u3088\u3046\u306B\
    \u8FD1\u4F3C\u3057\u305F\u7D50\u679C\u3092\u8FD4\u3059\u3002(\u305D\u306E\u533A\
    \u9593\u304C\u5F97\u3089\u308C\u308Bnode\u304C\u8FD4\u308B)\n\n        # is_ok\u306B\
    \u306FINF\u30680\u304C\u4E0E\u3048\u3089\u308C\u308B\u70B9\u306B\u6CE8\u610F\u3002\
    \n        assert n >= 1\n\n        var now = sbt_root(T)\n\n        var result0\
    \ = is_ok(sbt_zero(T))\n        var resultinf = is_ok(sbt_inf(T))\n\n        assert\
    \ result0 != resultinf\n\n        var is_left = false\n\n        var result_now\
    \ = is_ok(now)\n\n        if result0 != result_now:\n            is_left = true\n\
    \        \n        while now.is_inner_node_bounded(n):\n            if is_left:\n\
    \                # \u65B0\u3057\u304F\u3067\u304D\u308B\u53F3\u7AEF\u306E\u5206\
    \u5B50\u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u7BC4\u56F2\u3067\
    \u79FB\u52D5\u53EF\u80FD\n                # \u3069\u3053\u307E\u3067\u6F5C\u3063\
    \u305F\u3089\u521D\u3081\u3066result_now\u3068\u7D50\u679C\u304C\u5909\u308F\u308B\
    \u306E\u304B\u3092\u4E8C\u5206\u63A2\u7D22\n                let lim = now.max_endpoint_move_left_with_bound(n)\n\
    \                if lim <= 0:\n                    break\n                var\
    \ l:T = 0\n                var r = lim\n                if is_ok(now.move_left(r))\
    \ == result_now:\n                    now = now.move_left(r)\n               \
    \     break\n                while r-l > 1:\n                    var mid = (r+l)\
    \ div 2\n                    if is_ok(now.move_left(mid)) == result_now:\n   \
    \                     l = mid\n                    else:\n                   \
    \     r = mid\n                now = now.move_left(r)\n            else:\n   \
    \             # \u65B0\u3057\u304F\u3067\u304D\u308B\u5DE6\u7AEF\u306E\u5206\u5B50\
    \u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306B\u306A\u308B\u7BC4\u56F2\u3067\u79FB\
    \u52D5\u53EF\u80FD\n                # \u4E8C\u5206\u63A2\u7D22\n             \
    \   let lim = now.max_endpoint_move_right_with_bound(n)\n                if lim\
    \ <= 0:\n                    break\n                var l:T = 0\n            \
    \    var r = lim\n                if is_ok(now.move_right(r)) == result_now:\n\
    \                    now = now.move_right(r)\n                    break\n    \
    \            while r-l > 1:\n                    var mid = (r+l) div 2\n     \
    \               if is_ok(now.move_right(mid)) == result_now:\n               \
    \         l = mid\n                    else:\n                        r = mid\n\
    \                now = now.move_right(r)\n            result_now = not result_now\n\
    \            is_left = not is_left\n            #echo \"now!\",now.toFraction()\n\
    \        return now\n\n    \n    proc cmp_with_ein(a,b:SBTNode[int]):int=\n  \
    \      # -1 : <\n        # +1 : >\n        # 0 : =\n        if a == b:\n     \
    \       return 0\n        \n        var (la,ra) = a.get_range_fraction()\n   \
    \     var (lb,rb) = b.get_range_fraction()\n\n        var x = a.toFraction()\n\
    \        var y = b.toFraction()\n        \n        if lb < x and x < rb:\n   \
    \         return 1\n        \n        if la < y and y < ra:\n            return\
    \ -1\n        \n        return cmp(x,y)\n\n\n\n    proc initAuxiliaryWeightedTree*(v:openArray[SBTNode[int]]):WeightedUnDirectedTableGraph[SBTNode[int],int]=\n\
    \        ## \u6839\u304C\u6B32\u3057\u304B\u3063\u305F\u3089G.v[0]\u3092\u4F7F\
    \u3063\u3066\u304F\u3060\u3055\u3044\u3000\u3051\u3080\u306B\u304F\n        assert\
    \ len(v) > 0\n        var v = v.sorted(cmp_with_ein)\n        for i in 0..<(len(v)-1):\n\
    \            v.add(LCA(v[i],v[i+1]))\n        v = v.sorted(cmp_with_ein).deduplicate(true)\n\
    \        var stack :seq[SBTNode[int]]\n        result = initWeightedUnDirectedTableGraph(v,int)\n\
    \        stack.add(v[0])\n        for i in 1..<len(v):\n            while len(stack)\
    \ > 0 and LCA(stack[^1],v[i]) != stack[^1]:\n                discard stack.pop()\n\
    \            if len(stack) != 0:\n                result.add_edge(stack[^1],v[i],(v[i].depth)-(stack[^1].depth))\n\
    \            stack.add(v[i])"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/math/stern_brocot_tree.nim
  requiredBy: []
  timestamp: '2026-07-09 05:26:00+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/stern_brocot_tree.nim
layout: document
redirect_from:
- /library/cplib/math/stern_brocot_tree.nim
- /library/cplib/math/stern_brocot_tree.nim.html
title: cplib/math/stern_brocot_tree.nim
---
