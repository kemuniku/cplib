---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_lazysegtree.nim
    title: cplib/collections/persistent_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_lazysegtree.nim
    title: cplib/collections/persistent_lazysegtree.nim
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
    import random, strutils\nimport cplib/collections/persistent_lazysegtree\n\ntype\n\
    \    Value = object\n        sum, size: int\n    Affine = tuple[a, b: int]\n\n\
    proc merge(l, r: Value): Value = Value(sum: l.sum + r.sum, size: l.size + r.size)\n\
    proc mapping(f: Affine, x: Value): Value = Value(sum: f.a * x.sum + f.b * x.size,\
    \ size: x.size)\nproc composition(f, g: Affine): Affine = (f.a * g.a, f.a * g.b\
    \ + f.b)\nproc makeTree(values: openArray[int]): PersistentLazySegmentTree[Value,\
    \ Affine] =\n    var initial: seq[Value]\n    for x in values: initial.add(Value(sum:\
    \ x, size: 1))\n    initPersistentLazySegmentTree(initial, merge, Value(), mapping,\
    \ composition, (1, 0))\n\nblock:\n    let base = makeTree([1, 2, 3, 4, 5])\n \
    \   let added = base.apply(0, 5, (1, 3))\n    let multiplied = added.apply(0..<5,\
    \ (2, 0))\n    let branch = added.apply(1, 4, (0, 7))\n    var assigned = multiplied.update(2,\
    \ Value(sum: 100, size: 1))\n    let saved = assigned\n    assigned[^1] = Value(sum:\
    \ 9, size: 1)\n    assigned[0] = Value(sum: 20, size: 1)\n    doAssert base.get_all()\
    \ == Value(sum: 15, size: 5)\n    doAssert added.get_all() == Value(sum: 30, size:\
    \ 5)\n    doAssert multiplied.get_all() == Value(sum: 60, size: 5)\n    doAssert\
    \ branch.get_all() == Value(sum: 33, size: 5)\n    doAssert saved[^1] == Value(sum:\
    \ 16, size: 1)\n    doAssert saved[0] == Value(sum: 8, size: 1)\n    doAssert\
    \ assigned.get_all() == Value(sum: 153, size: 5)\n    doAssert assigned[1..3]\
    \ == Value(sum: 124, size: 3)\n    doAssert assigned.get(1..3) == Value(sum: 124,\
    \ size: 3)\n    doAssert assigned.query(1, 4) == Value(sum: 124, size: 3)\n  \
    \  doAssert assigned.apply(2..<2, (0, 999)).get_all() == assigned.get_all()\n\
    \    doAssert multiplied[2] == Value(sum: 12, size: 1)\n\nblock:\n    let tree\
    \ = newLazySegWith([1, 2, 3, 4, 5], min(l, r), int.high, f + x, f + g, 0)\n  \
    \  let next = tree.apply(0, 5, 7)\n    doAssert $tree == \"1 2 3 4 5\"\n    doAssert\
    \ $next == \"8 9 10 11 12\"\n    doAssert next[^5] == 8\n    let sized: PLazySegmentTree[int,\
    \ int] = initLazySegmentTree(3, (proc(l, r: int): int = min(l, r)), int.high,\n\
    \        proc(f, x: int): int = min(f, x), proc(f, g: int): int = min(f, g), int.high)\n\
    \    doAssert sized.apply(0, 3, 10).get_all() == 10\n    doAssert sized.get_all()\
    \ == int.high\n    let viaSeq = initLazySegmentTree(@[3, 2, 1], (proc(l, r: int):\
    \ int = min(l, r)), int.high,\n        proc(f, x: int): int = min(f, x), proc(f,\
    \ g: int): int = min(f, g), int.high)\n    doAssert viaSeq.len == 3\n    doAssert\
    \ viaSeq[1] == 2\n    let templated = newPersistentLazySegWith(3, min(l, r), int.high,\n\
    \        min(f, x), min(f, g), int.high)\n    doAssert templated[0] == int.high\n\
    \    let empty = newPersistentLazySegWith(0, l + r, 0, x, 0, 0)\n    doAssert\
    \ empty.len == 0\n    doAssert empty.get_all() == 0\n    doAssert empty[0..<0]\
    \ == 0\n    doAssert $empty == \"\"\n    doAssert empty.max_right(0, proc(x: int):\
    \ bool = x == 0) == 0\n    doAssert empty.min_left(0, proc(x: int): bool = x ==\
    \ 0) == 0\n    doAssert empty.apply(0, 0, 1).get_all() == 0\n\nproc check(tree:\
    \ PersistentLazySegmentTree[Value, Affine], expected: seq[int], rng: var Rand)\
    \ =\n    doAssert tree.len == expected.len\n    var total = 0\n    var rendered:\
    \ seq[string]\n    for i, x in expected:\n        let value = Value(sum: x, size:\
    \ 1)\n        doAssert tree[i] == value\n        rendered.add($value)\n      \
    \  total += x\n    doAssert tree.get_all() == Value(sum: total, size: expected.len)\n\
    \    doAssert $tree == rendered.join(\" \")\n    for rep in 0..<5:\n        var\
    \ l = rng.rand(expected.len)\n        var r = rng.rand(expected.len)\n       \
    \ if l > r: swap(l, r)\n        var sum = 0\n        for i in l..<r: sum += expected[i]\n\
    \        doAssert tree.get(l, r) == Value(sum: sum, size: r - l)\n        doAssert\
    \ tree[l..<r] == Value(sum: sum, size: r - l)\n        let limit = rng.rand(total\
    \ + 1)\n        let predicate = proc(x: Value): bool = x.sum <= limit\n      \
    \  var right = l\n        sum = 0\n        while right < expected.len and sum\
    \ + expected[right] <= limit:\n            sum += expected[right]\n          \
    \  inc right\n        doAssert tree.max_right(l, predicate) == right\n       \
    \ var left = r\n        sum = 0\n        while left > 0 and expected[left - 1]\
    \ + sum <= limit:\n            dec left\n            sum += expected[left]\n \
    \       doAssert tree.min_left(r, predicate) == left\n\nvar rng = initRand(20260927)\n\
    for n in [0, 1, 2, 3, 7, 16, 31, 64]:\n    var initial = newSeq[int](n)\n    for\
    \ x in initial.mitems: x = rng.rand(9)\n    var versions = @[makeTree(initial)]\n\
    \    var states = @[initial]\n    for step in 0..<400:\n        let parent = if\
    \ step mod 3 == 0: rng.rand(versions.high) else: versions.high\n        var expected\
    \ = newSeq[int](n)\n        for i in 0..<n: expected[i] = states[parent][i]\n\
    \        var next = versions[parent]\n        if step mod 3 == 0:\n          \
    \  let source = rng.rand(versions.high)\n            var l = rng.rand(n)\n   \
    \         var r = rng.rand(n)\n            if l > r: swap(l, r)\n            if\
    \ step mod 5 == 0:\n                l = 0\n                r = n\n           \
    \ for i in l..<r: expected[i] = states[source][i]\n            if step mod 2 ==\
    \ 0: next = next.copy_range(versions[source], l, r)\n            else: next =\
    \ next.copy_range(versions[source], l..<r)\n            check(versions[source],\
    \ states[source], rng)\n        elif n > 0 and step mod 4 == 0:\n            let\
    \ p = rng.rand(n - 1)\n            let value = rng.rand(20)\n            expected[p]\
    \ = value\n            if step mod 8 == 0: next[p] = Value(sum: value, size: 1)\n\
    \            else: next = next.update(p, Value(sum: value, size: 1))\n       \
    \ else:\n            var l = rng.rand(n)\n            var r = rng.rand(n)\n  \
    \          if l > r: swap(l, r)\n            if step mod 5 == 0:\n           \
    \     l = 0\n                r = n\n            let f: Affine = (rng.rand(1),\
    \ rng.rand(5))\n            for i in l..<r: expected[i] = f.a * expected[i] +\
    \ f.b\n            if step mod 2 == 0: next = next.apply(l, r, f)\n          \
    \  else: next = next.apply(l..<r, f)\n        versions.add(next)\n        states.add(expected)\n\
    \        check(next, expected, rng)\n        check(versions[parent], states[parent],\
    \ rng)\n        let old = rng.rand(versions.high)\n        check(versions[old],\
    \ states[old], rng)\n    for i in 0..<versions.len: check(versions[i], states[i],\
    \ rng)\n\nblock:\n    let base = newPersistentLazySegWith([\"a\", \"b\", \"c\"\
    , \"d\", \"e\", \"f\", \"g\"], l & r, \"\",\n        (if f == '\\0': x else: repeat(f,\
    \ x.len)), (if f == '\\0': g else: f), '\\0')\n    let versions = @[base, base.apply(0,\
    \ 7, 'x'), base.apply(1, 6, 'y'),\n        base.apply(0, 7, 'x').apply(2, 5, 'z').update(3,\
    \ \"A\")]\n    let states = @[\"abcdefg\", \"xxxxxxx\", \"ayyyyyg\", \"xxzAzxx\"\
    ]\n    for i, tree in versions:\n        doAssert tree.get_all() == states[i]\n\
    \        for l in 0..7:\n            for r in l..7:\n                let target\
    \ = states[i][l..<r]\n                doAssert tree.get(l, r) == target\n    \
    \            doAssert tree.max_right(l, proc(x: string): bool = target.startsWith(x))\
    \ == r\n                doAssert tree.min_left(r, proc(x: string): bool = target.endsWith(x))\
    \ == l\n\nblock:\n    type Action = proc(x: int): int\n    let identity: Action\
    \ = proc(x: int): int = x\n    let twice: Action = proc(x: int): int = x * 2\n\
    \    let tree = newPersistentLazySegWith([1, 2, 3], l + r, 0,\n        f(x), (proc(x:\
    \ int): int = f(g(x))), identity)\n    let next = tree.apply(0, 3, twice)\n  \
    \  doAssert next.get_all() == 12\n    doAssert next[1] == 4\n    doAssert tree[1]\
    \ == 2\n\nblock:\n    var calls = 0\n    let countedMerge = proc(l, r: Value):\
    \ Value =\n        inc calls\n        merge(l, r)\n    let countedMapping = proc(f:\
    \ Affine, x: Value): Value =\n        inc calls\n        mapping(f, x)\n    let\
    \ countedComposition = proc(f, g: Affine): Affine =\n        inc calls\n     \
    \   composition(f, g)\n    var initial = newSeq[Value](4097)\n    for x in initial.mitems:\
    \ x = Value(sum: 1, size: 1)\n    let tree = initPersistentLazySegmentTree(initial,\
    \ countedMerge, Value(),\n        countedMapping, countedComposition, (1, 0))\n\
    \    calls = 0\n    let added = tree.apply(0, 4097, (1, 3))\n    doAssert calls\
    \ < 500\n    calls = 0\n    let changed = added.update(2000, Value(sum: 0, size:\
    \ 1))\n    doAssert calls < 500\n    let source = tree.apply(0, 4097, (2, 1))\n\
    \    calls = 0\n    let copied = changed.copy_range(source, 17, 4096)\n    doAssert\
    \ calls < 500\n    doAssert copied.get_all().sum == 18 * 4 + (4096 - 17) * 3\n\
    \    calls = 0\n    doAssert changed.get(17, 4096).sum == (4096 - 17 - 1) * 4\n\
    \    doAssert calls < 500\n    calls = 0\n    doAssert changed.max_right(17, proc(x:\
    \ Value): bool = x.sum <= 400) == 117\n    doAssert calls < 500\n    calls = 0\n\
    \    doAssert changed.min_left(4096, proc(x: Value): bool = x.sum <= 400) == 3996\n\
    \    doAssert calls < 500\n\nblock:\n    # \u72EC\u7ACB\u306B\u69CB\u7BC9\u3057\
    \u305F\u6728\u306E\u30B3\u30D4\u30FC\u3068\u3001\u5143\u306E\u6728\u3092\u7834\
    \u68C4\u3057\u305F\u5F8C\u306E\u9818\u57DF\u306E\u5BFF\u547D\u3092\u691C\u8A3C\
    \u3059\u308B\u3002\n    proc copiedTree(): PersistentLazySegmentTree[Value, Affine]\
    \ =\n        let dest = makeTree([1, 2, 3, 4, 5]).apply(0, 5, (2, 1))\n      \
    \  let source = makeTree([10, 20, 30, 40, 50]).apply(0, 5, (3, 2))\n        result\
    \ = dest.copy_range(source, 1, 4)\n        result = result.copy_range(makeTree([7,\
    \ 8, 9, 10, 11]), 2, 3)\n    let saved = copiedTree()\n    GC_fullCollect()\n\
    \    check(saved, @[3, 62, 9, 122, 11], rng)\n    let next = saved.apply(0, 5,\
    \ (0, 7)).update(2, Value(sum: 100, size: 1))\n    GC_fullCollect()\n    check(next,\
    \ @[7, 7, 100, 7, 7], rng)\n    check(saved, @[3, 62, 9, 122, 11], rng)\n    let\
    \ full = makeTree([0, 0, 0, 0, 0]).copy_range(copiedTree(), 0, 5)\n    GC_fullCollect()\n\
    \    check(full, @[3, 62, 9, 122, 11], rng)\n\nblock:\n    # \u30CE\u30FC\u30C9\
    \u9818\u57DF\u306E\u8FFD\u52A0\u3092\u307E\u305F\u304E\u3001\u53C2\u7167\u3092\
    \u542B\u3080\u5024\u3068\u7570\u306A\u308B\u6240\u6709\u9818\u57DF\u3092\u691C\
    \u8A3C\u3059\u308B\u3002\n    proc stringTree(c: char): PersistentLazySegmentTree[string,\
    \ char] =\n        newPersistentLazySegWith([repeat(c, 1), repeat(c, 1), repeat(c,\
    \ 1)], l & r, \"\",\n            (if f == '\\0': x else: repeat(f, x.len)), (if\
    \ f == '\\0': g else: f), '\\0')\n    var tree = stringTree('a')\n    let old\
    \ = tree\n    for i in 0..<3000:\n        tree = tree.apply(0, 3, char(ord('a')\
    \ + i mod 26))\n        if i mod 100 == 0:\n            tree = tree.copy_range(stringTree('X'),\
    \ 1, 2)\n            GC_fullCollect()\n            doAssert tree[1] == \"X\"\n\
    \    doAssert tree.get_all() == repeat(char(ord('a') + 2999 mod 26), 3)\n    doAssert\
    \ old.get_all() == \"aaa\"\n\nblock:\n    # \u72EC\u7ACB\u3057\u305F\u6728\u304B\
    \u3089\u306E\u53CD\u5FA9\u30B3\u30D4\u30FC\u5F8C\u306B\u3001\u6240\u6709\u95A2\
    \u4FC2\u3092\u6DF1\u3044\u518D\u5E30\u306A\u3057\u3067\u89E3\u653E\u3067\u304D\
    \u308B\u3053\u3068\u3002\n    proc repeatedCopy() =\n        var dest = makeTree([1,\
    \ 2])\n        let source = makeTree([3, 4])\n        for i in 0..<200000:\n \
    \           dest = dest.copy_range(source, 0, 1)\n        doAssert dest.get_all().sum\
    \ == 5\n    repeatedCopy()\n    GC_fullCollect()\n\nblock:\n    # \u8907\u6570\
    \u306E\u72EC\u7ACB\u3057\u305F\u6728\u3092\u53CC\u65B9\u5411\u306B\u30B3\u30D4\
    \u30FC\u3057\u3066\u6240\u6709\u9818\u57DF\u3092\u7D71\u5408\u3059\u308B\u3002\
    \n    var trees: seq[PersistentLazySegmentTree[Value, Affine]]\n    var states:\
    \ seq[seq[int]]\n    for i in 0..<16:\n        states.add(@[i, i + 1, i + 2, i\
    \ + 3, i + 4])\n        trees.add(makeTree(states[^1]))\n    for i in 0..<256:\n\
    \        let d = rng.rand(15)\n        let s = rng.rand(15)\n        let l = rng.rand(4)\n\
    \        let r = rng.rand(l..5)\n        trees[d] = trees[d].copy_range(trees[s],\
    \ l, r)\n        for j in l..<r: states[d][j] = states[s][j]\n        if i mod\
    \ 16 == 0: GC_fullCollect()\n        check(trees[d], states[d], rng)\n    GC_fullCollect()\n\
    \    for i in 0..<16: check(trees[i], states[i], rng)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/persistent_lazysegtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/persistent_lazysegtree.nim
  isVerificationFile: true
  path: verify/AI/persistent_lazysegtree_test.nim
  requiredBy: []
  timestamp: '2026-09-28 03:54:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_lazysegtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_lazysegtree_test.nim
- /verify/verify/AI/persistent_lazysegtree_test.nim.html
title: verify/AI/persistent_lazysegtree_test.nim
---
