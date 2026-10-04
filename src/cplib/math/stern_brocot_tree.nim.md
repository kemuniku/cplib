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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_bounds_test.nim
    title: verify/math/stern_brocot_tree_bounds_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_bounds_test.nim
    title: verify/math/stern_brocot_tree_bounds_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_random_test.nim
    title: verify/math/stern_brocot_tree_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_random_test.nim
    title: verify/math/stern_brocot_tree_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_rational_approximation_test.nim
    title: verify/math/stern_brocot_tree_rational_approximation_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/stern_brocot_tree_rational_approximation_test.nim
    title: verify/math/stern_brocot_tree_rational_approximation_test.nim
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
  code: "when not declared CPLIB_MATH_STERN_BROCOT_TREE:\n    import cplib/math/fractions\n\
    \    import cplib/graph/graph\n    import sequtils,algorithm,options\n    const\
    \ CPLIB_MATH_STERN_BROCOT_TREE* = 1\n    type SBTNode*[T] = tuple[p:T,q:T,r:T,s:T,depth:T]\n\
    \n    proc den*[T](x:SBTNode[T]):T {.inline.}=\n        ## \u30CE\u30FC\u30C9\u306E\
    \u5206\u6BCD\u3092\u8FD4\u3059\u3002O(1)\u3002\n        return x.q+x.s\n    proc\
    \ num*[T](x:SBTNode[T]):T {.inline.}=\n        ## \u30CE\u30FC\u30C9\u306E\u5206\
    \u5B50\u3092\u8FD4\u3059\u3002O(1)\u3002\n        return x.p + x.r\n    \n   \
    \ converter toFraction(x:SBTNode[int]):Fraction[int]=\n        return initFraction(x.num,x.den,false)\n\
    \n    proc continued_fraction_expansion*[T](a,b:T):seq[T]=\n        assert a >=\
    \ 1, \"a\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        assert b >= 1, \"b\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        var a = a\n        var b = b\n\
    \        while true:\n            result.add(a div b)\n            if a mod b\
    \ == 0:\n                break\n            a -= result[^1] * b\n            swap(a,b)\n\
    \n    iterator path_runs[T](a,b:T):(char,T)=\n        ## \u6839\u304B\u3089\u306E\
    \u7D4C\u8DEF\u3092\u540C\u3058\u65B9\u5411\u3054\u3068\u306B\u5217\u6319\u3059\
    \u308B\u3002O(log(min(a,b)))\u6642\u9593\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\
    \n        assert a >= 1, \"a\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        assert b >= 1, \"b\u306F1\u4EE5\u4E0A\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var a = a\n\
    \        var b = b\n        while a != b:\n            if a > b:\n           \
    \     let d = (a-T(1)) div b\n                yield ('R',d)\n                a\
    \ -= d*b\n            else:\n                let d = (b-T(1)) div a\n        \
    \        yield ('L',d)\n                b -= d*a\n\n    proc encode_path*[T](a,b:T):seq[(char,T)]=\n\
    \        ## \u6839\u304B\u3089a/b\u307E\u3067\u306E\u7D4C\u8DEF\u3092\u30E9\u30F3\
    \u30EC\u30F3\u30B0\u30B9\u5727\u7E2E\u3059\u308B\u3002O(log(min(a,b)))\u3002\n\
    \        for run in path_runs(a,b):\n            result.add(run)\n\n    proc encode_path*[T](now:SBTNode[T]):seq[(char,T)]=\n\
    \        return encode_path(now.num(),now.den())\n    \n    proc move_left*[T](now:SBTNode[T],d:T):SBTNode[T]\
    \ {.inline.}=\n        ## \u5DE6\u306E\u5B50\u3078d\u6BB5\u79FB\u52D5\u3059\u308B\
    \u3002O(1)\u3002\n        return (now.p,now.q,d*now.p+now.r,d*now.q+now.s,now.depth+d)\n\
    \n    proc move_right*[T](now:SBTNode[T],d:T):SBTNode[T] {.inline.}=\n       \
    \ ## \u53F3\u306E\u5B50\u3078d\u6BB5\u79FB\u52D5\u3059\u308B\u3002O(1)\u3002\n\
    \        return (now.p+d*now.r,now.q+d*now.s,now.r,now.s,now.depth+d)\n    \n\
    \    proc sbt_root*[T](typ:typedesc[T]):SBTNode[T]=\n        return (T(0),T(1),T(1),T(0),T(0))\n\
    \n    proc sbt_root*():SBTNode[int]=\n        return sbt_root(int)\n\n    proc\
    \ sbt_inf*[T](typ:typedesc[T]):SBTNode[T]=\n        return (T(1),T(0),T(0),T(0),T(-1))\n\
    \n    proc sbt_inf*():SBTNode[int]=\n        return sbt_inf(int)\n\n    proc sbt_zero*[T](typ:typedesc[T]):SBTNode[T]=\n\
    \        return (T(0),T(1),T(0),T(0),T(-1))\n\n    proc sbt_zero*():SBTNode[int]=\n\
    \        return sbt_zero(int)\n    \n\n    \n    proc to_fraction_tuple*[T](x:SBTNode[T]):(T,T)=\n\
    \        return (x.p + x.r,x.q+x.s)\n\n    proc to_SBTNode*[T](a,b:T):SBTNode[T]=\n\
    \        ## a/b\u306E\u30CE\u30FC\u30C9\u3092\u4F5C\u308B\u3002O(log(min(a,b)))\u6642\
    \u9593\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\n        result = sbt_root(T)\n\
    \        for (c,d) in path_runs(a,b):\n            if c == 'R':\n            \
    \    result = result.move_right(d)\n            else:\n                result\
    \ = result.move_left(d)\n\n    proc to_endpoint_node[T](a,b:T):SBTNode[T]=\n \
    \       if b == 0:\n            return sbt_inf(T)\n        if a == 0:\n      \
    \      return sbt_zero(T)\n        return to_SBTNode(a,b)\n\n    proc max_move_count[T](base,step,n:T):T=\n\
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
    \u306E\u3082\u306E\u3092\u8FD4\u3059\u3002\n        assert m >= 1, \"m\u306F1\u4EE5\
    \u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\n     \
    \   if x.is_inner_node_bounded(m):\n            var now = x.move_right(1)\n  \
    \          if not now.is_inner_node_bounded(m):\n                return to_endpoint_node(x.r,x.s)\n\
    \            return now.move_left(now.max_inner_move_left_with_bound(m))\n\n \
    \       var now = sbt_root(T)\n\n        for (c,d) in path_runs(x.num(),x.den()):\n\
    \            if c == 'L':\n                let lim = min(d,now.max_inner_move_left_with_bound(m))\n\
    \                now = now.move_left(lim)\n                if lim < d:\n     \
    \               return now\n            else:\n                let lim = min(d,now.max_inner_move_right_with_bound(m))\n\
    \                now = now.move_right(lim)\n                if lim < d:\n    \
    \                return to_endpoint_node(now.r,now.s)\n\n        var nxt = now.move_right(1)\n\
    \        if not nxt.is_inner_node_bounded(m):\n            return to_endpoint_node(now.r,now.s)\n\
    \        return nxt.move_left(nxt.max_inner_move_left_with_bound(m))\n\n    proc\
    \ max_less_with_den_at_most*[T](x:SBTNode[T],m:T):SBTNode[T]=\n        ## x\u3088\
    \u308A\u5C0F\u3055\u304F\u3001\u5206\u5B50\u30FB\u5206\u6BCD\u304Cm\u4EE5\u4E0B\
    \u3067\u3042\u308B\u6709\u7406\u6570\u306E\u3046\u3061\u6700\u5927\u306E\u3082\
    \u306E\u3092\u8FD4\u3059\u3002\n        assert m >= 1, \"m\u306F1\u4EE5\u4E0A\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\n        if x.is_inner_node_bounded(m):\n\
    \            var now = x.move_left(1)\n            if not now.is_inner_node_bounded(m):\n\
    \                return to_endpoint_node(x.p,x.q)\n            return now.move_right(now.max_inner_move_right_with_bound(m))\n\
    \n        var now = sbt_root(T)\n\n        for (c,d) in path_runs(x.num(),x.den()):\n\
    \            if c == 'L':\n                let lim = min(d,now.max_inner_move_left_with_bound(m))\n\
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
    \        ## a/b\u3068c/d\u306E\u6700\u5C0F\u5171\u901A\u7956\u5148\u3092\u8FD4\
    \u3059\u3002O(log(min(a,b,c,d)))\u6642\u9593\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\
    \n        assert a >= 1 and c >= 1, \"\u5206\u5B50\u306F1\u4EE5\u4E0A\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert b >= 1 and\
    \ d >= 1, \"\u5206\u6BCD\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        var a = a\n        var b = b\n        var\
    \ c = c\n        var d = d\n        result = sbt_root(T)\n        while a != b\
    \ and c != d:\n            if a > b and c > d:\n                let x = (a-T(1))\
    \ div b\n                let y = (c-T(1)) div d\n                result = result.move_right(min(x,y))\n\
    \                if x != y:\n                    return\n                a -=\
    \ x*b\n                c -= y*d\n            elif a < b and c < d:\n         \
    \       let x = (b-T(1)) div a\n                let y = (d-T(1)) div c\n     \
    \           result = result.move_left(min(x,y))\n                if x != y:\n\
    \                    return\n                b -= x*a\n                d -= y*c\n\
    \            else:\n                return\n\n    proc LCA*[T](a,b:SBTNode[T]):SBTNode[T]=\n\
    \        ## 2\u30CE\u30FC\u30C9\u306E\u6700\u5C0F\u5171\u901A\u7956\u5148\u3092\
    \u8FD4\u3059\u3002O(log(min(a.num(),a.den(),b.num(),b.den())))\u3002\n       \
    \ LCA(a.num(),a.den(),b.num(),b.den())\n\n    proc ancestor*[T](a,b,k:T):Option[SBTNode[T]]=\n\
    \        ## a/b\u306E\u6DF1\u3055k\u306E\u7956\u5148\u3092\u8FD4\u3059\u3002\u5B58\
    \u5728\u3057\u306A\u3051\u308C\u3070none\u3002O(log(min(a,b)))\u3001\u8FFD\u52A0\
    \u9818\u57DFO(1)\u3002\n        assert a >= 1, \"a\u306F1\u4EE5\u4E0A\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        assert b >= 1, \"\
    b\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        if k < 0:\n            return none(SBTNode[T])\n        var now =\
    \ sbt_root(T)\n        if k == 0:\n            return some(now)\n        for (c,d)\
    \ in path_runs(a,b):\n            let steps = min(k-now.depth,d)\n           \
    \ if c == 'R':\n                now = now.move_right(steps)\n            else:\n\
    \                now = now.move_left(steps)\n            if now.depth == k:\n\
    \                return some(now)\n        return none(SBTNode[T])\n\n    proc\
    \ ancestor*[T](now:SBTNode[T],k:T):Option[SBTNode[T]]=\n        ## \u30CE\u30FC\
    \u30C9\u306E\u6DF1\u3055k\u306E\u7956\u5148\u3092\u8FD4\u3059\u3002\u5B58\u5728\
    \u3057\u306A\u3051\u308C\u3070none\u3002O(log(min(now.num(),now.den())))\u3002\
    \n        if k < 0 or k > now.depth:\n            return none(SBTNode[T])\n  \
    \      if k == now.depth:\n            return some(now)\n        return ancestor(now.num(),now.den(),k)\n\
    \n    proc get_range*[T](node:SBTNode[T]):(T,T,T,T)=\n        return (node.p,node.q,node.r,node.s)\n\
    \n    proc get_range_fraction*[T](node:SBTNode[T]):(Fraction[T],Fraction[T])=\n\
    \        return (initFraction(node.p,node.q,false),initFraction(node.r,node.s,false))\n\
    \    \n    proc get_range*[T](a,b:T):(T,T,T,T)=\n        return get_range(to_SBTNode(a,b))\n\
    \n\n    proc get_bounds*[T](a,b,n:T):SBTNode[T]=\n        ## a/b\u4EE5\u4E0B\u3068\
    a/b\u3088\u308A\u5927\u304D\u3044\u6709\u7406\u6570\u3067\u5883\u754C\u3092\u631F\
    \u3080\u3002\u5206\u5B50\u30FB\u5206\u6BCD\u306Fn\u4EE5\u4E0B\u3002O(log(n+1))\u6642\
    \u9593\u3001\u8FFD\u52A0\u9818\u57DFO(1)\u3002\n        assert a >= 0, \"a\u306F\
    0\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\
    \        assert b >= 1, \"b\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        assert n >= 1, \"n\u306F1\u4EE5\u4E0A\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        # \u6839\u304B\
    \u3089\u306E\u6700\u521D\u306E\u79FB\u52D5\u4EE5\u964D\u306F\u3001\u5206\u5B50\
    \u30FB\u5206\u6BCD\u306E\u3046\u3061\u5927\u304D\u3044\u5074\u3060\u3051\u3067\
    \u4E0A\u9650\u3092\u5224\u5B9A\u3067\u304D\u308B\u3002\n        let boundNumerator\
    \ = a >= b\n        var a = a\n        var b = b\n        result = sbt_root(T)\n\
    \        while result.p <= n-result.r and result.q <= n-result.s:\n          \
    \  if a >= b:\n                let lim = if boundNumerator: (n-result.p) div result.r\n\
    \                          else: (n-result.q) div result.s\n                let\
    \ steps = min(a div b,lim)\n                result = result.move_right(steps)\n\
    \                a -= steps*b\n            else:\n                let lim = if\
    \ boundNumerator: (n-result.r) div result.p\n                          else: (n-result.s)\
    \ div result.q\n                if a == 0:\n                    return result.move_left(lim)\n\
    \                let steps = min((b-T(1)) div a,lim)\n                result =\
    \ result.move_left(steps)\n                b -= steps*a\n\n    proc get_bounds*[T](is_ok:proc(x:SBTNode[T]):bool,n:T):SBTNode[T]\
    \ {.inline.}=\n        ## \u5206\u5B50\u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306E\
    \u6709\u7406\u6570\u3067\u5224\u5B9A\u306E\u5883\u754C\u3092\u631F\u3080\u3002\
    \u5224\u5B9A\u56DE\u6570\u306FO(log n)\u3002\n        # \u5358\u8ABF\u6027\u306E\
    \u3042\u308B\u95A2\u6570is_ok\u3092\u8003\u3048\u308B\u3002\n        # x <= a\
    \ : true\n        # x > a : false\n        # \u3068\u306A\u308B\u3088\u3046\u306A\
    \u5883\u754Ca\u3092\u5206\u5B50\u30FB\u5206\u6BCD\u304Cn\u4EE5\u4E0B\u306E\u6709\
    \u7406\u6570\u306B\u306A\u308B\u3088\u3046\u306B\u8FD1\u4F3C\u3057\u305F\u7D50\
    \u679C\u3092\u8FD4\u3059\u3002(\u305D\u306E\u533A\u9593\u304C\u5F97\u3089\u308C\
    \u308Bnode\u304C\u8FD4\u308B)\n\n        # is_ok\u306B\u306FINF\u30680\u304C\u4E0E\
    \u3048\u3089\u308C\u308B\u70B9\u306B\u6CE8\u610F\u3002\n        assert n >= 1,\
    \ \"n\u306F1\u4EE5\u4E0A\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n\n        var now = sbt_root(T)\n\n        var result0 = is_ok(sbt_zero(T))\n\
    \        var resultinf = is_ok(sbt_inf(T))\n\n        assert result0 != resultinf,\
    \ \"\u533A\u9593\u306E\u4E21\u7AEF\u306B\u5BFE\u3059\u308B\u5224\u5B9A\u7D50\u679C\
    \u306F\u7570\u306A\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\n     \
    \   var is_left = false\n\n        var result_now = is_ok(now)\n\n        if result0\
    \ != result_now:\n            is_left = true\n        \n        while now.is_inner_node_bounded(n):\n\
    \            if is_left:\n                # 1\u6BB5\u3067\u5224\u5B9A\u304C\u5909\
    \u308F\u308B\u5834\u5408\u306F\u3001\u4E0A\u9650\u8A08\u7B97\u306E\u9664\u7B97\
    \u3092\u7701\u304F\u3002\n                let next = now.move_left(T(1))\n   \
    \             if is_ok(next) != result_now:\n                    now = next\n\
    \                else:\n                    let lim = now.max_endpoint_move_left_with_bound(n)\n\
    \                    if lim == 1:\n                        return next\n     \
    \               var l = T(1)\n                    var r = T(2)\n             \
    \       while is_ok(now.move_left(r)) == result_now:\n                       \
    \ if r == lim:\n                            return now.move_left(r)\n        \
    \                l = r\n                        r += min(r,lim-r)\n          \
    \          while r-l > 1:\n                        let mid = l + (r-l) div 2\n\
    \                        if is_ok(now.move_left(mid)) == result_now:\n       \
    \                     l = mid\n                        else:\n               \
    \             r = mid\n                    now = now.move_left(r)\n          \
    \  else:\n                let next = now.move_right(T(1))\n                if\
    \ is_ok(next) != result_now:\n                    now = next\n               \
    \ else:\n                    let lim = now.max_endpoint_move_right_with_bound(n)\n\
    \                    if lim == 1:\n                        return next\n     \
    \               var l = T(1)\n                    var r = T(2)\n             \
    \       while is_ok(now.move_right(r)) == result_now:\n                      \
    \  if r == lim:\n                            return now.move_right(r)\n      \
    \                  l = r\n                        r += min(r,lim-r)\n        \
    \            while r-l > 1:\n                        let mid = l + (r-l) div 2\n\
    \                        if is_ok(now.move_right(mid)) == result_now:\n      \
    \                      l = mid\n                        else:\n              \
    \              r = mid\n                    now = now.move_right(r)\n        \
    \    result_now = not result_now\n            is_left = not is_left\n        return\
    \ now\n\n    \n    proc cmp_with_ein(a,b:SBTNode[int]):int=\n        # -1 : <\n\
    \        # +1 : >\n        # 0 : =\n        if a == b:\n            return 0\n\
    \        \n        var (la,ra) = a.get_range_fraction()\n        var (lb,rb) =\
    \ b.get_range_fraction()\n\n        var x = a.toFraction()\n        var y = b.toFraction()\n\
    \        \n        if lb < x and x < rb:\n            return 1\n        \n   \
    \     if la < y and y < ra:\n            return -1\n        \n        return cmp(x,y)\n\
    \n\n\n    proc initAuxiliaryWeightedTree*(v:openArray[SBTNode[int]]):WeightedUnDirectedTableGraph[SBTNode[int],int]=\n\
    \        ## \u6839\u304C\u6B32\u3057\u304B\u3063\u305F\u3089G.v[0]\u3092\u4F7F\
    \u3063\u3066\u304F\u3060\u3055\u3044\u3000\u3051\u3080\u306B\u304F\n        assert\
    \ len(v) > 0, \"\u5217v\u306F\u7A7A\u3067\u306A\u3044\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        var v = v.sorted(cmp_with_ein)\n        for i in 0..<(len(v)-1):\n\
    \            v.add(LCA(v[i],v[i+1]))\n        v = v.sorted(cmp_with_ein).deduplicate(true)\n\
    \        var stack :seq[SBTNode[int]]\n        result = initWeightedUnDirectedTableGraph(v,int)\n\
    \        stack.add(v[0])\n        for i in 1..<len(v):\n            while len(stack)\
    \ > 0 and LCA(stack[^1],v[i]) != stack[^1]:\n                discard stack.pop()\n\
    \            if len(stack) != 0:\n                result.add_edge(stack[^1],v[i],(v[i].depth)-(stack[^1].depth))\n\
    \            stack.add(v[i])"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/math/stern_brocot_tree.nim
  requiredBy: []
  timestamp: '2026-10-01 06:31:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/stern_brocot_tree_rational_approximation_test.nim
  - verify/math/stern_brocot_tree_rational_approximation_test.nim
  - verify/math/stern_brocot_tree_random_test.nim
  - verify/math/stern_brocot_tree_random_test.nim
  - verify/math/stern_brocot_tree_bounds_test.nim
  - verify/math/stern_brocot_tree_bounds_test.nim
documentation_of: cplib/math/stern_brocot_tree.nim
layout: document
redirect_from:
- /library/cplib/math/stern_brocot_tree.nim
- /library/cplib/math/stern_brocot_tree.nim.html
title: cplib/math/stern_brocot_tree.nim
---
