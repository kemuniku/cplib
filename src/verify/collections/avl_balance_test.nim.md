---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avl_monoid.nim
    title: cplib/collections/avl_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avl_monoid.nim
    title: cplib/collections/avl_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    include cplib/collections/avl_monoid\nimport random, sequtils\n\nproc add(a, b:\
    \ int): int = a + b\n\nproc check(node: AvlMonoidNode[int]): (int, int, int) =\n\
    \    if node.isNil: return (0, 0, 0)\n    let (leftHeight, leftSize, leftProd)\
    \ = check(node.left)\n    let (rightHeight, rightSize, rightProd) = check(node.right)\n\
    \    doAssert abs(leftHeight - rightHeight) <= 1\n    doAssert node.height ==\
    \ max(leftHeight, rightHeight) + 1\n    doAssert node.size == leftSize + rightSize\
    \ + 1\n    doAssert node.prod == leftProd + node.value + rightProd\n    (node.height,\
    \ node.size, node.prod)\n\nvar rng = initRand(20261015)\nvar tree = initAvlMonoid(newSeqWith(20000,\
    \ 1), add, 0)\nvar length = tree.len\nfor step in 0..<20000:\n    let index =\
    \ rng.rand(0..<length)\n    case step mod 5\n    of 0, 1:\n        tree.insert(index,\
    \ rng.rand(1..100))\n        inc length\n    of 2:\n        tree.erase(index)\n\
    \        dec length\n    of 3:\n        tree.erase(index, min(length, index +\
    \ 2))\n        length -= min(2, length - index)\n    else:\n        tree[index]\
    \ = rng.rand(1..100)\n    if step mod 100 == 0:\n        let k = rng.rand(length)\n\
    \        let (left, right) = tree.split(k)\n        doAssert check(left.root)[1]\
    \ == k\n        doAssert check(right.root)[1] == length - k\n        tree = merge(left,\
    \ right)\n        let (_, size, product) = check(tree.root)\n        doAssert\
    \ size == length\n        doAssert tree.get_all == product\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/collections/avl_monoid.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/avl_monoid.nim
  isVerificationFile: true
  path: verify/collections/avl_balance_test.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avl_balance_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avl_balance_test.nim
- /verify/verify/collections/avl_balance_test.nim.html
title: verify/collections/avl_balance_test.nim
---
