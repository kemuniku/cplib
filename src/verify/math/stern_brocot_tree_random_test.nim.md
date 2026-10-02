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
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
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
    import cplib/math/stern_brocot_tree\nimport options, random\n\nproc naivePath[T](a,\
    \ b: T): seq[(char, T)] =\n    var a = a\n    var b = b\n    while a != b:\n \
    \       let direction = if a > b: 'R' else: 'L'\n        if result.len > 0 and\
    \ result[^1][0] == direction:\n            inc result[^1][1]\n        else:\n\
    \            result.add((direction, T(1)))\n        if a > b:\n            a -=\
    \ b\n        else:\n            b -= a\n\nproc referencePath[T](a, b: T): seq[(char,\
    \ T)] =\n    var cf = continued_fraction_expansion(a, b)\n    dec cf[^1]\n   \
    \ for i, count in cf:\n        if count > 0:\n            result.add(((if i mod\
    \ 2 == 0: 'R' else: 'L'), count))\n\nproc referenceAncestor[T](path: seq[(char,\
    \ T)], k: T): Option[SBTNode[T]] =\n    if k < 0:\n        return none(SBTNode[T])\n\
    \    var prefix: seq[(char, T)]\n    var remaining = k\n    for (direction, count)\
    \ in path:\n        let take = min(remaining, count)\n        prefix.add((direction,\
    \ take))\n        remaining -= take\n        if remaining == 0:\n            break\n\
    \    if remaining == 0:\n        return some(decode_path(prefix))\n    return\
    \ none(SBTNode[T])\n\nproc referenceLCA[T](a, b: seq[(char, T)]): SBTNode[T] =\n\
    \    var prefix: seq[(char, T)]\n    for i in 0..<min(a.len, b.len):\n       \
    \ if a[i][0] != b[i][0]:\n            break\n        prefix.add((a[i][0], min(a[i][1],\
    \ b[i][1])))\n        if a[i][1] != b[i][1]:\n            break\n    return decode_path(prefix)\n\
    \nproc checkNode[T](a, b: T, path: seq[(char, T)]) =\n    let node = to_SBTNode(a,\
    \ b)\n    doAssert node == decode_path(path)\n    doAssert encode_path(a, b) ==\
    \ path\n    doAssert encode_path(node) == path\n    doAssert get_range(a, b) ==\
    \ get_range(node)\n    for k in [T(-1), T(0), T(1), node.depth div 2, node.depth,\
    \ node.depth+1]:\n        let expected = referenceAncestor(path, k)\n        doAssert\
    \ ancestor(a, b, k) == expected\n        doAssert ancestor(node, k) == expected\n\
    \nproc testSmall[T]() =\n    for a in 1..20:\n        for b in 1..20:\n      \
    \      let path = naivePath(T(a), T(b))\n            checkNode(T(a), T(b), path)\n\
    \            for k in 0..a+b:\n                doAssert ancestor(T(a), T(b), T(k))\
    \ == referenceAncestor(path, T(k))\n            for c in 1..12:\n            \
    \    for d in 1..12:\n                    let expected = referenceLCA(path, naivePath(T(c),\
    \ T(d)))\n                    doAssert LCA(T(a), T(b), T(c), T(d)) == expected\n\
    \                    doAssert LCA(to_SBTNode(T(a), T(b)), to_SBTNode(T(c), T(d)))\
    \ == expected\n            for bound in 1..8:\n                var lo = (T(0),\
    \ T(1))\n                var hi = (T(1), T(0))\n                for x in 1..bound:\n\
    \                    for y in 1..bound:\n                        if x*b < a*y\
    \ and T(x)*lo[1] > lo[0]*T(y):\n                            lo = (T(x), T(y))\n\
    \                        if x*b > a*y and T(x)*hi[1] < hi[0]*T(y):\n         \
    \                   hi = (T(x), T(y))\n                let node = to_SBTNode(T(a),\
    \ T(b))\n                let lower = max_less_with_den_at_most(node, T(bound))\n\
    \                let upper = min_greater_with_den_at_most(node, T(bound))\n  \
    \              let lowerNode = if lo[0] == 0: sbt_zero(T) else: to_SBTNode(lo[0],\
    \ lo[1])\n                let upperNode = if hi[1] == 0: sbt_inf(T) else: to_SBTNode(hi[0],\
    \ hi[1])\n                doAssert lower == lowerNode\n                doAssert\
    \ upper == upperNode\n\nproc testLarge[T]() =\n    var rng = initRand(20260930)\n\
    \    for trial in 0..<10000:\n        let a = T(rng.rand(999999999)+1)\n     \
    \   let b = T(rng.rand(999999999)+1)\n        let c = T(rng.rand(999999999)+1)\n\
    \        let d = T(rng.rand(999999999)+1)\n        let path = referencePath(a,\
    \ b)\n        checkNode(a, b, path)\n        doAssert LCA(a, b, c, d) == referenceLCA(path,\
    \ referencePath(c, d))\n        let node = to_SBTNode(a, b)\n        doAssert\
    \ LCA(node, node) == node\n        let parent = ancestor(node, node.depth div\
    \ 2).get()\n        doAssert LCA(node, parent) == parent\n    for (a, b) in [(T.high,\
    \ T(1)), (T(1), T.high), (T.high, T.high),\n                   (T.high, T.high-1),\
    \ (T.high-1, T.high),\n                   (T(701408733), T(433494437)), (T(433494437),\
    \ T(701408733))]:\n        let path = referencePath(a, b)\n        checkNode(a,\
    \ b, path)\n        doAssert LCA(a, b, a, b) == decode_path(path)\n        doAssert\
    \ LCA(a, b, b, a) == sbt_root(T)\n\nfor path in [@[], @[('L', 0)], @[('R', 0)],\
    \ @[('L', 3), ('L', 4), ('R', 2)]]:\n    let node = decode_path(path)\n    doAssert\
    \ to_SBTNode(node.num(), node.den()) == node\n\ntestSmall[int]()\ntestSmall[int32]()\n\
    testSmall[int64]()\ntestLarge[int]()\ntestLarge[int32]()\ntestLarge[int64]()\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/stern_brocot_tree_random_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:31:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/stern_brocot_tree_random_test.nim
layout: document
redirect_from:
- /verify/verify/math/stern_brocot_tree_random_test.nim
- /verify/verify/math/stern_brocot_tree_random_test.nim.html
title: verify/math/stern_brocot_tree_random_test.nim
---
