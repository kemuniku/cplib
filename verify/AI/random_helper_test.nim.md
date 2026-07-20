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
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/random_helper.nim
    title: cplib/utils/random_helper.nim
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
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/graph/graph\nimport cplib/math/isprime\n\
    import cplib/utils/random_helper\n\nproc edgeCount(g: UnWeightedUnDirectedGraph):\
    \ int =\n  for i in 0..<g.len:\n    for j in g[i]:\n      if i < j:\n        result\
    \ += 1\n\nlet xs = randomseq(5, 1..3)\nassert xs.len == 5\nassert xs.allIt(it\
    \ in 1..3)\nlet uniq = randomseq(3, 1..5, true)\nassert uniq.len == 3\nassert\
    \ uniq.deduplicate.len == 3\nassert uniq.allIt(it in 1..5)\n\nlet parts = randomseq_from_sum(4,\
    \ 7)\nassert parts.len == 4\nassert parts.foldl(a + b, 0) == 7\nassert parts.allIt(it\
    \ >= 0)\n\nlet ps = random_parenthesis_sequence(6)\nassert ps.len == 6\nassert\
    \ ps.foldl(a + b, 0) == 0\nvar bal = 0\nfor x in ps:\n  bal += x\n  assert bal\
    \ >= 0\nassert random_parenthesis_string(4).len == 4\n\nlet bt = make_binary_tree_from_sequence(@[1,\
    \ 1, -1, -1])\nassert bt.len == 2\nassert bt.edgeCount == 1\nassert random_binary_tree(3).len\
    \ == 3\nassert random_tree(1).len == 1\nassert random_tree(2).edgeCount == 1\n\
    \nlet p = random_prime(10..20)\nassert p in 10..20\nassert p.isprime\nlet primes\
    \ = random_prime_sequence(3, 2..13, true)\nassert primes.len == 3\nassert primes.deduplicate.len\
    \ == 3\nassert primes.allIt(it.isprime)\n\nlet sg = random_simple_graph(4, 3)\n\
    assert sg.len == 4\nassert sg.edgeCount == 3\nlet cg = random_connected_graph(4,\
    \ 3)\nassert cg.len == 4\nassert cg.edgeCount == 3\n\nlet bits = random_01sequence(5,\
    \ 2)\nassert bits.len == 5\nassert bits.foldl(a + b, 0) == 2\nassert random_string(4,\
    \ 'a'..'c').allIt(it in 'a'..'c')\nassert random_string(4, \"xyz\").allIt(it in\
    \ {'x', 'y', 'z'})\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/math/powmod.nim
  - cplib/utils/random_helper.nim
  - cplib/math/isprime.nim
  - cplib/graph/graph.nim
  - cplib/math/powmod.nim
  - cplib/utils/random_helper.nim
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  isVerificationFile: true
  path: verify/AI/random_helper_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:56:47+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/random_helper_test.nim
layout: document
redirect_from:
- /verify/verify/AI/random_helper_test.nim
- /verify/verify/AI/random_helper_test.nim.html
title: verify/AI/random_helper_test.nim
---
