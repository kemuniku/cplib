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
    import random, sequtils\nimport cplib/collections/[range_reverse_array, range_reverse_array_monoid,\
    \ range_reverse_lazysegtree, range_reverse_dualsegtree]\n\nproc maximum(a, b:\
    \ int): int = max(a, b)\nproc add(f, x: int): int = f + x\nproc compose(f, g:\
    \ int): int = f + g\nproc descending(a, b: int): bool = a > b\nproc concat(a,\
    \ b: string): string = a & b\n\ntemplate checkBasic(treeExpr: untyped) =\n   \
    \ block:\n        let original = treeExpr\n        original.reverse(1, 4)\n  \
    \      let (left, right) = original.split(2)\n        doAssert original.len ==\
    \ 0\n        doAssert left.toSeq == @[1, 4]\n        doAssert right.toSeq == @[3,\
    \ 2, 5]\n        let joined = merge(left, right)\n        doAssert left.len ==\
    \ 0 and right.len == 0\n        doAssert joined.toSeq == @[1, 4, 3, 2, 5]\n  \
    \      let (empty, all) = joined.split(0)\n        doAssert empty.len == 0 and\
    \ all.toSeq == @[1, 4, 3, 2, 5]\n        let restored = merge(empty, all)\n  \
    \      let (allAgain, emptyAgain) = restored.split(restored.len)\n        doAssert\
    \ allAgain.toSeq == @[1, 4, 3, 2, 5] and emptyAgain.len == 0\n        doAssert\
    \ merge(allAgain, emptyAgain).toSeq == @[1, 4, 3, 2, 5]\n\ncheckBasic(initRangeReverseArray(@[1,\
    \ 2, 3, 4, 5]))\ncheckBasic(initRangeReverseArrayMonoid(@[1, 2, 3, 4, 5], maximum,\
    \ low(int)))\ncheckBasic(initRangeReverseLazySegmentTree(@[1, 2, 3, 4, 5], maximum,\
    \ low(int), add, compose, 0))\ncheckBasic(initRangeReverseDualSegmentTree(@[1,\
    \ 2, 3, 4, 5], add, compose, 0))\n\ntemplate checkInsort(treeExpr: untyped) =\n\
    \    block:\n        let tree = treeExpr\n        tree.reverse(0, tree.len)\n\
    \        doAssert tree.insort(2) == 3\n        doAssert tree.insort(0) == 0\n\
    \        doAssert tree.insort(5) == 6\n        doAssert tree.toSeq == @[0, 1,\
    \ 2, 2, 2, 4, 5]\n        let descendingTree = treeExpr\n        doAssert descendingTree.insort(3,\
    \ descending) == 1\n\ncheckInsort(initRangeReverseArray(@[4, 2, 2, 1]))\ncheckInsort(initRangeReverseArrayMonoid(@[4,\
    \ 2, 2, 1], maximum, low(int)))\ncheckInsort(initRangeReverseLazySegmentTree(@[4,\
    \ 2, 2, 1], maximum, low(int), add, compose, 0))\ncheckInsort(initRangeReverseDualSegmentTree(@[4,\
    \ 2, 2, 1], add, compose, 0))\n\nblock:\n    let empty = initRangeReverseArray(newSeq[int]())\n\
    \    let (left, right) = empty.split(0)\n    doAssert merge(left, right).len ==\
    \ 0\n    empty.insert(0, 10)\n    doAssert empty.toSeq == @[10]\n\nblock:\n  \
    \  let tree = initRangeReverseArrayMonoid(@[\"a\", \"b\", \"c\", \"d\"], concat,\
    \ \"\")\n    tree.reverse(0, 4)\n    let (left, right) = tree.split(2)\n    doAssert\
    \ left.fold == \"dc\" and right.fold == \"ba\"\n    let joined = merge(left, right)\n\
    \    doAssert joined.fold == \"dcba\"\n    joined.reverse(1, 4)\n    doAssert\
    \ joined.fold == \"dabc\"\n\nblock:\n    let lazy = initRangeReverseLazySegmentTree(@[1,\
    \ 2, 3, 4], maximum, low(int), add, compose, 0)\n    lazy.apply(0, 4, 10)\n  \
    \  lazy.reverse(0, 4)\n    let (left, right) = lazy.split(2)\n    doAssert left.toSeq\
    \ == @[14, 13] and right.toSeq == @[12, 11]\n    let joined = merge(left, right)\n\
    \    doAssert joined.toSeq == @[14, 13, 12, 11]\n    doAssert joined.fold == 14\n\
    \    joined.reverse(0, 4)\n    doAssert joined.insort(13) == 3\n    doAssert joined.toSeq\
    \ == @[11, 12, 13, 13, 14]\n\nblock:\n    let dual = initRangeReverseDualSegmentTree(@[1,\
    \ 2, 3, 4], add, compose, 0)\n    dual.apply(0, 4, 10)\n    dual.reverse(0, 4)\n\
    \    let (left, right) = dual.split(2)\n    doAssert left.toSeq == @[14, 13] and\
    \ right.toSeq == @[12, 11]\n    let joined = merge(left, right)\n    joined.reverse(0,\
    \ 4)\n    doAssert joined.insort(13) == 3\n    doAssert joined.toSeq == @[11,\
    \ 12, 13, 13, 14]\n\nblock:\n    let lazy = initRangeReverseLazySegmentTree(@[1,\
    \ 2, 3, 4], maximum, low(int), add, compose, 0)\n    lazy.apply(0, 4, 10)\n  \
    \  doAssert lazy.insort(13) == 3\n    doAssert lazy.toSeq == @[11, 12, 13, 13,\
    \ 14]\n    let dual = initRangeReverseDualSegmentTree(@[1, 2, 3, 4], add, compose,\
    \ 0)\n    dual.apply(0, 4, 10)\n    doAssert dual.insort(13) == 3\n    doAssert\
    \ dual.toSeq == @[11, 12, 13, 13, 14]\n\ntemplate checkRandomReverse(treeExpr:\
    \ untyped) =\n    block:\n        var tree = treeExpr\n        var values = (0..<40).toSeq\n\
    \        var rng = initRand(20261016)\n        for step in 0..<1000:\n       \
    \     let l = rng.rand(values.len)\n            let r = rng.rand(l..values.len)\n\
    \            tree.reverse(l, r)\n            var i = l\n            var j = r\
    \ - 1\n            while i < j:\n                swap(values[i], values[j])\n\
    \                inc i\n                dec j\n            let k = rng.rand(values.len)\n\
    \            let (left, right) = tree.split(k)\n            doAssert left.toSeq\
    \ == values[0..<k]\n            doAssert right.toSeq == values[k..<values.len]\n\
    \            tree = merge(left, right)\n            doAssert tree.toSeq == values\n\
    \nlet initial = (0..<40).toSeq\ncheckRandomReverse(initRangeReverseArray(initial))\n\
    checkRandomReverse(initRangeReverseArrayMonoid(initial, maximum, low(int)))\n\
    checkRandomReverse(initRangeReverseLazySegmentTree(initial, maximum, low(int),\
    \ add, compose, 0))\ncheckRandomReverse(initRangeReverseDualSegmentTree(initial,\
    \ add, compose, 0))\n\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/collections/range_reverse_split_merge_insort_test.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_split_merge_insort_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_split_merge_insort_test.nim
- /verify/verify/collections/range_reverse_split_merge_insort_test.nim.html
title: verify/collections/range_reverse_split_merge_insort_test.nim
---
