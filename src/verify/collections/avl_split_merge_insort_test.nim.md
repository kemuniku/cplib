---
data:
  _extendedDependsOn: []
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
    import random\nimport cplib/collections/[avl_monoid, avl_lazysegtree, avl_dualsegtree]\n\
    \nproc concat(a, b: string): string = a & b\nproc maximum(a, b: int): int = max(a,\
    \ b)\nproc add(f, x: int): int = f + x\nproc compose(f, g: int): int = f + g\n\
    proc descending(a, b: int): bool = a > b\n\nblock:\n    let original = initAvlMonoid(@[\"\
    a\", \"b\", \"c\", \"d\"], concat, \"\")\n    let (left, right) = original.split(2)\n\
    \    doAssert original.len == 0\n    doAssert left.toSeq == @[\"a\", \"b\"]\n\
    \    doAssert right.toSeq == @[\"c\", \"d\"]\n    doAssert left.fold == \"ab\"\
    \n    let joined = merge(left, right)\n    doAssert left.len == 0 and right.len\
    \ == 0\n    doAssert joined.fold == \"abcd\"\n    let (empty, all) = joined.split(0)\n\
    \    doAssert empty.len == 0 and all.toSeq == @[\"a\", \"b\", \"c\", \"d\"]\n\
    \    let restored = merge(empty, all)\n    let (allAgain, emptyAgain) = restored.split(restored.len)\n\
    \    doAssert allAgain.fold == \"abcd\" and emptyAgain.len == 0\n    doAssert\
    \ merge(allAgain, emptyAgain).toSeq == @[\"a\", \"b\", \"c\", \"d\"]\n\nblock:\n\
    \    let emptyTree = initAvlMonoid(newSeq[int](), maximum, low(int))\n    let\
    \ (emptyLeft, emptyRight) = emptyTree.split(0)\n    doAssert merge(emptyLeft,\
    \ emptyRight).len == 0\n    let tree = initAvlMonoid(@[1, 2, 2, 4], maximum, low(int))\n\
    \    doAssert tree.insort(2) == 3\n    doAssert tree.insort(0) == 0\n    doAssert\
    \ tree.insort(5) == 6\n    doAssert tree.toSeq == @[0, 1, 2, 2, 2, 4, 5]\n   \
    \ let descendingTree = initAvlMonoid(@[5, 3, 3, 1], maximum, low(int))\n    doAssert\
    \ descendingTree.insort(3, descending) == 3\n    doAssert descendingTree.toSeq\
    \ == @[5, 3, 3, 3, 1]\n\nblock:\n    let original = initAvlLazySegmentTree(@[1,\
    \ 2, 3, 4], maximum, low(int), add, compose, 0)\n    original.apply(0, 4, 10)\n\
    \    let (left, right) = original.split(2)\n    doAssert original.len == 0\n \
    \   doAssert left.toSeq == @[11, 12] and right.toSeq == @[13, 14]\n    doAssert\
    \ left.fold == 12 and right.fold == 14\n    let joined = merge(left, right)\n\
    \    doAssert left.len == 0 and right.len == 0\n    doAssert joined.insort(13)\
    \ == 3\n    doAssert joined.toSeq == @[11, 12, 13, 13, 14]\n    joined.apply(1,\
    \ 4, 1)\n    doAssert joined.toSeq == @[11, 13, 14, 14, 14]\n    let (empty, all)\
    \ = joined.split(0)\n    doAssert empty.len == 0 and all.toSeq == @[11, 13, 14,\
    \ 14, 14]\n    let restored = merge(empty, all)\n    let (allAgain, emptyAgain)\
    \ = restored.split(restored.len)\n    doAssert merge(allAgain, emptyAgain).toSeq\
    \ == @[11, 13, 14, 14, 14]\n    let descendingTree = initAvlLazySegmentTree(@[5,\
    \ 3, 3, 1], maximum, low(int), add, compose, 0)\n    doAssert descendingTree.insort(3,\
    \ descending) == 3\n    doAssert descendingTree.toSeq == @[5, 3, 3, 3, 1]\n  \
    \  let pending = initAvlLazySegmentTree(@[1, 2, 3, 4], maximum, low(int), add,\
    \ compose, 0)\n    pending.apply(0, 4, 10)\n    doAssert pending.insort(13) ==\
    \ 3\n    doAssert pending.toSeq == @[11, 12, 13, 13, 14]\n\nblock:\n    let original\
    \ = initAvlDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)\n    original.apply(0,\
    \ 4, 10)\n    let (left, right) = original.split(2)\n    doAssert original.len\
    \ == 0\n    doAssert left.toSeq == @[11, 12] and right.toSeq == @[13, 14]\n  \
    \  let joined = merge(left, right)\n    doAssert left.len == 0 and right.len ==\
    \ 0\n    doAssert joined.insort(13) == 3\n    doAssert joined.toSeq == @[11, 12,\
    \ 13, 13, 14]\n    joined.apply(1, 4, 1)\n    doAssert joined.toSeq == @[11, 13,\
    \ 14, 14, 14]\n    let (empty, all) = joined.split(0)\n    doAssert empty.len\
    \ == 0 and all.toSeq == @[11, 13, 14, 14, 14]\n    let restored = merge(empty,\
    \ all)\n    let (allAgain, emptyAgain) = restored.split(restored.len)\n    doAssert\
    \ merge(allAgain, emptyAgain).toSeq == @[11, 13, 14, 14, 14]\n    let descendingTree\
    \ = initAvlDualSegmentTree(@[5, 3, 3, 1], add, compose, 0)\n    doAssert descendingTree.insort(3,\
    \ descending) == 3\n    doAssert descendingTree.toSeq == @[5, 3, 3, 3, 1]\n  \
    \  let pending = initAvlDualSegmentTree(@[1, 2, 3, 4], add, compose, 0)\n    pending.apply(0,\
    \ 4, 10)\n    doAssert pending.insort(13) == 3\n    doAssert pending.toSeq ==\
    \ @[11, 12, 13, 13, 14]\n\nblock:\n    var rng = initRand(20261015)\n    var tree\
    \ = initAvlMonoid(newSeq[int](), maximum, low(int))\n    var values: seq[int]\n\
    \    for step in 0..<1000:\n        let value = rng.rand(0..100)\n        var\
    \ expected = 0\n        while expected < values.len and values[expected] <= value:\
    \ inc expected\n        doAssert tree.insort(value) == expected\n        values.insert(value,\
    \ expected)\n        if step mod 31 == 0:\n            let k = rng.rand(values.len)\n\
    \            let (left, right) = tree.split(k)\n            doAssert left.toSeq\
    \ == values[0..<k]\n            doAssert right.toSeq == values[k..<values.len]\n\
    \            let combined = merge(left, right)\n            let (empty, all) =\
    \ combined.split(0)\n            let restored = merge(empty, all)\n          \
    \  let (a, b) = restored.split(restored.len)\n            let finalTree = merge(a,\
    \ b)\n            doAssert finalTree.toSeq == values\n            tree = finalTree\n\
    \        doAssert tree.toSeq == values\n\ntemplate checkUpdatedSorted(treeExpr:\
    \ untyped) =\n    block:\n        var tree = treeExpr\n        var values: seq[int]\n\
    \        var rng = initRand(20261016)\n        for step in 0..<1000:\n       \
    \     case step mod 3\n            of 0:\n                let value = rng.rand(0..200)\n\
    \                var expected = 0\n                while expected < values.len\
    \ and values[expected] <= value: inc expected\n                doAssert tree.insort(value)\
    \ == expected\n                values.insert(value, expected)\n            of\
    \ 1:\n                let delta = rng.rand(0..3)\n                tree.apply(0,\
    \ tree.len, delta)\n                for i in 0..<values.len: values[i] += delta\n\
    \            else:\n                let k = rng.rand(values.len)\n           \
    \     let (left, right) = tree.split(k)\n                doAssert left.toSeq ==\
    \ values[0..<k]\n                doAssert right.toSeq == values[k..<values.len]\n\
    \                tree = merge(left, right)\n            doAssert tree.toSeq ==\
    \ values\n\ncheckUpdatedSorted(initAvlLazySegmentTree(newSeq[int](), maximum,\
    \ low(int), add, compose, 0))\ncheckUpdatedSorted(initAvlDualSegmentTree(newSeq[int](),\
    \ add, compose, 0))\n\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/collections/avl_split_merge_insort_test.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avl_split_merge_insort_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avl_split_merge_insort_test.nim
- /verify/verify/collections/avl_split_merge_insort_test.nim.html
title: verify/collections/avl_split_merge_insort_test.nim
---
