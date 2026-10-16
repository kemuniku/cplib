---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avl_seq.nim
    title: cplib/collections/avl_seq.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avl_seq.nim
    title: cplib/collections/avl_seq.nim
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
    include cplib/collections/avl_seq\nimport random\n\nproc check(node: AvlSeqNode[int]):\
    \ (int, int) =\n    if node.isNil: return (0, 0)\n    let (leftHeight, leftSize)\
    \ = check(node.left)\n    let (rightHeight, rightSize) = check(node.right)\n \
    \   doAssert abs(leftHeight - rightHeight) <= 1\n    doAssert node.height == max(leftHeight,\
    \ rightHeight) + 1\n    doAssert node.size == leftSize + rightSize + 1\n    (node.height,\
    \ node.size)\n\nblock:\n    let empty = initAvlSeq(newSeq[int]())\n    let (left,\
    \ right) = empty.split(0)\n    doAssert empty.len == 0\n    doAssert merge(left,\
    \ right).len == 0\n    empty.insert(0, 42)\n    doAssert empty[^1] == 42\n   \
    \ empty.erase(0)\n    doAssert empty.toSeq.len == 0\n\nblock:\n    var tree =\
    \ @[1, 2, 3].toAvlSeq\n    doAssert tree.len == 3\n    doAssert tree[^1] == 3\n\
    \    tree[^2] = 5\n    doAssert tree.toSeq == @[1, 5, 3]\n    tree.insert(1, 4)\n\
    \    doAssert tree.toSeq == @[1, 4, 5, 3]\n    tree.erase(1..2)\n    doAssert\
    \ tree.toSeq == @[1, 3]\n    doAssert $tree == \"1 3\"\n\nblock:\n    var rng\
    \ = initRand(20261017)\n    var tree = initAvlSeq(newSeq[int]())\n    var values:\
    \ seq[int]\n    for step in 0..<5000:\n        let n = values.len\n        let\
    \ index = rng.rand(n)\n        case rng.rand(0..5)\n        of 0, 1:\n       \
    \     let value = rng.rand(0..1000)\n            tree.insert(index, value)\n \
    \           values.insert(value, index)\n        of 2:\n            if n > 0:\n\
    \                tree.erase(index mod n)\n                values.delete(index\
    \ mod n)\n        of 3:\n            let right = rng.rand(index..n)\n        \
    \    tree.erase(index, right)\n            values = values[0..<index] & values[right..<n]\n\
    \        of 4:\n            if n > 0:\n                let value = rng.rand(0..1000)\n\
    \                tree[index mod n] = value\n                values[index mod n]\
    \ = value\n        else:\n            let (left, right) = tree.split(index)\n\
    \            doAssert tree.len == 0\n            doAssert left.toSeq == values[0..<index]\n\
    \            doAssert right.toSeq == values[index..<n]\n            tree = merge(left,\
    \ right)\n            doAssert left.len == 0 and right.len == 0\n        doAssert\
    \ tree.len == values.len\n        doAssert tree.toSeq == values\n        if step\
    \ mod 43 == 0:\n            doAssert check(tree.root)[1] == values.len\n\nblock:\n\
    \    var tree = initAvlSeq(newSeq[int]())\n    var values: seq[int]\n    var rng\
    \ = initRand(20261018)\n    for step in 0..<2000:\n        let value = rng.rand(0..100)\n\
    \        var expected = 0\n        while expected < values.len and values[expected]\
    \ <= value: inc expected\n        doAssert tree.insort(value) == expected\n  \
    \      values.insert(value, expected)\n        if step mod 37 == 0:\n        \
    \    let k = rng.rand(values.len)\n            let (left, right) = tree.split(k)\n\
    \            doAssert left.toSeq == values[0..<k]\n            doAssert right.toSeq\
    \ == values[k..<values.len]\n            tree = merge(left, right)\n         \
    \   doAssert check(tree.root)[1] == values.len\n        doAssert tree.toSeq ==\
    \ values\n    let descending = initAvlSeq(@[5, 3, 3, 1])\n    doAssert descending.insort(3,\
    \ proc(a, b: int): bool = a > b) == 3\n    doAssert descending.toSeq == @[5, 3,\
    \ 3, 3, 1]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/collections/avl_seq.nim
  - cplib/collections/avl_seq.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/collections/avl_seq_test.nim
  requiredBy: []
  timestamp: '2026-10-15 20:57:06+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avl_seq_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avl_seq_test.nim
- /verify/verify/collections/avl_seq_test.nim.html
title: verify/collections/avl_seq_test.nim
---
