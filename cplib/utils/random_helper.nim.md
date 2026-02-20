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
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links:
    - https://kanpurin.hatenablog.com/entry/2023/02/20/184752
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_RANDOMHELPER:\n    const CPLIB_UTILS_RANDOMHELPER*\
    \ = 1\n    import random,sequtils,sets,algorithm,math,strutils\n    import cplib/graph/graph\n\
    \    import cplib/tree/prufer\n    import cplib/math/isprime\n    # https://kanpurin.hatenablog.com/entry/2023/02/20/184752\n\
    \    randomize()\n\n    proc randomseq*(n:int,slice:HSlice[int,int],unique:bool=false):seq[int]=\n\
    \        ## \u9577\u3055n,\u5404\u8981\u7D20\u304Cslice\u306B\u542B\u307E\u308C\
    \u308B\u6570\u5217\u3092\u4E00\u69D8\u30E9\u30F3\u30C0\u30E0\u306B\u8FD4\u3059\
    \n        ## option: unique = True\u306E\u3068\u304D\u3001\u91CD\u8907\u3092\u8A31\
    \u3055\u306A\u3044\u3002\n        assert n >= 0\n        assert slice.len >= 1\n\
    \        if unique:\n            assert n <= slice.len\n            if n >= slice.len\
    \ div 2:\n                var tmp = slice.toseq()\n                shuffle(tmp)\n\
    \                result = tmp[0..<n]\n            else:\n                var st\
    \ = initHashSet[int]()\n                while result.len != n:\n             \
    \       var x = rand(slice)\n                    if x notin st:\n            \
    \            st.incl(x)\n                        result.add(x)\n        else:\n\
    \            for i in 0..<n:\n                result.add(rand(slice))\n      \
    \  assert len(result) == n\n        assert result.allit(it in slice)\n\n    proc\
    \ randomseq_from_sum*(n:int,sum:int):seq[int]=\n        ## \u9577\u3055n,\u7DCF\
    \u548C\u304Csum\u3067\u3042\u308B\u5404\u8981\u7D20\u304C\u975E\u8CA0\u6574\u6570\
    \u3067\u3042\u308B\u6570\u5217\u3092\u4E00\u69D8\u30E9\u30F3\u30C0\u30E0\u306B\
    \u8FD4\u3059\n        assert sum >= 0\n        assert n >= 0\n        if n ==\
    \ 0:\n            return @[]\n        var tmp = randomseq(n-1,1..(n+sum-1),true).sorted()\n\
    \        var now = 0\n        for x in tmp:\n            result.add(x-now-1)\n\
    \            now = x\n        result.add((n+sum-1) - now)\n        assert len(result)\
    \ == n and sum(result) == sum\n\n    proc random_parenthesis_sequence*(n:int):seq[int]=\n\
    \        ## \u9577\u3055n\u306E\u62EC\u5F27\u5217\u3092\u8FD4\u3059\u3002\n  \
    \      ##\u30001: \"(\" , -1 : \")\"\n        assert n mod 2 == 0\n\n        var\
    \ N = n div 2\n        var M = n div 2\n        var check = 0\n        for i in\
    \ 0..<(n):\n            var tmp = rand(1..((N-M+1)*(N+M)))\n            if tmp\
    \ <= (N-M)*(N+1):\n                result.add(-1)\n                check -= 1\n\
    \                N -= 1\n            else:\n                result.add(1)\n  \
    \              check += 1\n                M -= 1\n            assert check >=\
    \ 0\n        assert check == 0\n\n    proc random_parenthesis_string*(n:int):string=\n\
    \        return random_parenthesis_sequence(n).mapit(\").(\"[1+it]).join(\"\"\
    )\n\n    proc make_binary_tree_from_sequence*(PS:seq[int]):UnWeightedUnDirectedGraph=\n\
    \        ## \u62EC\u5F27\u5217\u304B\u3089\u4E8C\u5206\u6728\u3092\u5FA9\u5143\
    \n        var n = len(PS) div 2\n        var stack : seq[int]\n        var memo\
    \ = newseqwith(2*n,-1)\n        for i in 0..<2*n:\n            if PS[i] == 1:\n\
    \                stack.add(i)\n            else:\n                var x = stack.pop()\n\
    \                memo[x] = i\n        \n        var g = initUnWeightedUnDirectedGraph(n)\n\
    \        var now = 0\n        var edge_count = 0\n        proc dfs(l,r,no:int)=\n\
    \            var to = memo[l]\n            if to != l+1:\n                now\
    \ += 1\n                g.add_edge(no,now)\n                edge_count += 1\n\
    \                dfs(l+1,to,now)\n            if to+1 != r:\n                now\
    \ += 1\n                g.add_edge(no,now)\n                edge_count += 1\n\
    \                dfs(to+1,r,now)\n        dfs(0,2*n,0)\n        assert edge_count\
    \ == n-1\n        return g\n\n    proc random_binary_tree*(n:int):UnWeightedUnDirectedGraph=\n\
    \        ## n\u9802\u70B9\u306E\u4E8C\u5206\u6728\u3092\u4E00\u69D8\u30E9\u30F3\
    \u30C0\u30E0\u306B\u8FD4\u3059\n        assert n >= 1\n        var PS = random_parenthesis_sequence(2*n)\n\
    \        return make_binary_tree_from_sequence(PS)\n\n    proc random_tree*(n:int):UnWeightedUnDirectedGraph=\n\
    \        ## n\u9802\u70B9\u306E\u6728\u3092\u4E00\u69D8\u30E9\u30F3\u30C0\u30E0\
    \u306B\u8FD4\u3059\n        assert n >= 1\n        if n == 1:\n            return\
    \ initUnWeightedUnDirectedGraph(1)\n        elif n == 2:\n            result =\
    \ initUnWeightedUnDirectedGraph(2)\n            result.add_edge(0,1)\n       \
    \ else:\n            return prufer_decode(randomseq(n-2,0..<n))\n\n    proc random_prime*(slice:HSlice[int,int]):int=\n\
    \        ## slice\u306B\u542B\u307E\u308C\u308B\u7D20\u6570\u3092\u4E00\u69D8\u30E9\
    \u30F3\u30C0\u30E0\u306B\u8FD4\u3059\n        if len(slice) <= 1500:\n       \
    \     var f = false\n            for x in slice:\n                if isprime(x):\n\
    \                    f = true\n                    break\n            assert f\
    \ #slice\u306B\u7D20\u6570\u304C\u542B\u307E\u308C\u308B\u304B\u3069\u3046\u304B\
    \u5224\u5B9A\n        \n        while true:\n            var x = rand(slice)\n\
    \            if isprime(x):\n                return x\n\n    proc random_prime_sequence*(n:int,slice:HSlice[int,int],unique:bool=false):seq[int]=\n\
    \        if unique:\n            if len(slice) <= 1_000_000_000:\n           \
    \     var primes : seq[int]\n                for x in slice:\n               \
    \     if x.isprime():\n                        primes.add(x)\n               \
    \ result = randomseq(n,0..<len(primes),true).mapit(primes[it])\n            else:\n\
    \                var st = initHashSet[int]()\n                while result.len\
    \ != n:\n                    var x = random_prime(slice)\n                   \
    \ if x notin st:\n                        st.incl(x)\n                       \
    \ result.add(x)\n        else:\n            for i in 0..<n:\n                result.add(random_prime(slice))\n\
    \n    proc random_simple_graph*(n,m:int):UnWeightedUnDirectedGraph=\n        ##\
    \ \u30E9\u30F3\u30C0\u30E0\u306A\u5358\u7D14\u30B0\u30E9\u30D5\u3092\u4F5C\u6210\
    \u3002\n        assert m <= n*(n-1)\n        result = initUnWeightedUnDirectedGraph(n)\n\
    \        if n*(n-1) <= 10_000_000:\n            var tmp : seq[(int,int)]\n   \
    \         for i in 0..<(n-1):\n                for j in (i+1)..<n:\n         \
    \           tmp.add((i,j))\n            shuffle(tmp)\n            \n         \
    \   for i in 0..<m:\n                var (u,v) = tmp[i]\n                result.add_edge(u,v)\n\
    \        else:\n            var st = initHashSet[(int,int)]()\n            for\
    \ i in 0..<m:\n                while true:\n                    var u = rand(0..<(n-1))\n\
    \                    var v = rand((u+1)..<n)\n                    if (u,v) notin\
    \ st:\n                        st.incl((u,v))\n                        result.add_edge(u,v)\n\
    \                        break\n\n\n    proc random_connected_graph*(n,m:int):UnWeightedUnDirectedGraph=\n\
    \        ## \u30E9\u30F3\u30C0\u30E0\u306A\u5358\u7D14\u9023\u7D50\u30B0\u30E9\
    \u30D5\u3092\u751F\u6210\u3002\u305F\u3060\u3057\u3001\u4E00\u69D8\u30E9\u30F3\
    \u30C0\u30E0\u3067\u306A\u3044\u3002\n        assert m >= n-1\n        var g =\
    \ random_tree(n)\n        if n*(n-1) <= 10_000_000:\n            var st = initHashSet[(int,int)]()\n\
    \            for i in 0..<n-1:\n                for j in (i+1)..<n:\n        \
    \            st.incl((i,j))\n            \n            for i in 0..<n:\n     \
    \           for j in g[i]:\n                    st.excl((i,j))\n\n           \
    \ assert m-n+1 <= len(st)\n            var x = st.toseq()\n            shuffle(x)\n\
    \            for i in 0..<(m-n+1):\n                var (u,v) = x[i]\n       \
    \         g.add_edge(u,v)\n            return g\n        else:\n            var\
    \ st = initHashSet[(int,int)]()\n            for i in 0..<n:\n               \
    \ for j in g[i]:\n                    st.incl((i,j))\n            assert n*(n-1)\
    \ - (n-1) >= m\n            for i in 0..<(m-n+1):\n                while true:\n\
    \                    var u = rand(0..<(n-1))\n                    var v = rand((u+1)..<n)\n\
    \                    if (u,v) notin st:\n                        st.incl((u,v))\n\
    \                        g.add_edge(u,v)\n                        break\n    \
    \        return g\n\n    proc random_01sequence*(n:int,one:int):seq[int]=\n  \
    \      ## 1\u306E\u6570\u304Cone\u3067\u3042\u308B\u3088\u3046\u306A\u9577\u3055\
    n\u306E01\u5217\u3092\u4E00\u69D8\u30E9\u30F3\u30C0\u30E0\u306B\u8FD4\u3059\n\
    \        assert one in 0..n\n        var tmp = randomseq(one,0..<n,true)\n   \
    \     result = newseqwith(n,0)\n        for x in tmp:\n            result[x] =\
    \ 1"
  dependsOn:
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/graph/graph.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/utils/random_helper.nim
  requiredBy: []
  timestamp: '2024-11-28 17:57:29+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/utils/random_helper.nim
layout: document
redirect_from:
- /library/cplib/utils/random_helper.nim
- /library/cplib/utils/random_helper.nim.html
title: cplib/utils/random_helper.nim
---
