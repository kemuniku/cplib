---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_segtree.nim
    title: cplib/collections/persistent_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_segtree.nim
    title: cplib/collections/persistent_segtree.nim
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
    import random, strutils\nimport cplib/collections/persistent_segtree\n\nlet st\
    \ = initSegmentTree(@[1, 2, 3, 4], proc(l, r: int): int = l + r, 0)\ndoAssert\
    \ st.query(0, 4) == 10\ndoAssert st.query(1, 3) == 5\nlet st2 = st.update(2, 10)\n\
    doAssert st.query(0, 4) == 10\ndoAssert st2.query(0, 4) == 17\ndoAssert st2.query(2,\
    \ 3) == 10\n\nblock:\n    var current = newSegWith([1, 2, 3, 4, 5], l + r, 0)\n\
    \    let saved = current\n    current[2] = 10\n    current[^1] = 7\n    doAssert\
    \ current.len == 5\n    doAssert current[^1] == 7\n    doAssert current[^5] ==\
    \ 1\n    doAssert current[1..3] == 16\n    doAssert current.get(1..3) == 16\n\
    \    doAssert current.get_all() == 24\n    doAssert $current == \"1 2 10 4 7\"\
    \n    doAssert $saved == \"1 2 3 4 5\"\n    doAssert current.max_right(0, proc(x:\
    \ int): bool = x <= 13) == 3\n    doAssert current.min_left(5, proc(x: int): bool\
    \ = x <= 11) == 3\n    let sized: PersistentSegmentTree[int] = initPersistentSegmentTree(5,\
    \ (proc(l, r: int): int = min(l, r)), int.high)\n    doAssert sized.get_all()\
    \ == int.high\n    doAssert sized[0] == int.high\n    doAssert initSegmentTree[int](3,\
    \ proc(l, r: int): int = l + r, 0).get_all() == 0\n    doAssert newPersistentSegWith(3,\
    \ l + r, 0).len == 3\n\nblock:\n    type Value = object\n        sum, size: int\n\
    \    let v = [Value(sum: 2, size: 1), Value(sum: 5, size: 1)]\n    let a = newPersistentSegWith(v,\n\
    \        Value(sum: l.sum + r.sum, size: l.size + r.size), Value())\n    let b\
    \ = a.update(0, Value(sum: 9, size: 1))\n    doAssert a.get_all() == Value(sum:\
    \ 7, size: 2)\n    doAssert b.get_all() == Value(sum: 14, size: 2)\n\nblock:\n\
    \    type Box = ref object\n        value: int\n    let a = newPersistentSegWith([Box(value:\
    \ 3), Box(value: 4)],\n        Box(value: l.value + r.value), Box(value: 0))\n\
    \    let b = a.update(0, Box(value: 8))\n    doAssert a.get_all().value == 7\n\
    \    doAssert b.get_all().value == 12\n\nblock:\n    let a = newPersistentSegWith([\"\
    a\", \"b\", \"c\", \"d\", \"e\", \"f\", \"g\"], l & r, \"\")\n    let b = a.update(3,\
    \ \"X\")\n    doAssert a.get_all() == \"abcdefg\"\n    doAssert b.get_all() ==\
    \ \"abcXefg\"\n    let expected = \"abcXefg\"\n    for l in 0..expected.len:\n\
    \        for r in l..expected.len:\n            let target = expected[l..<r]\n\
    \            doAssert b.get(l, r) == target\n            doAssert b.max_right(l,\
    \ proc(x: string): bool = target.startsWith(x)) == r\n            doAssert b.min_left(r,\
    \ proc(x: string): bool = target.endsWith(x)) == l\n\nproc check(st: PSegmentTree[int],\
    \ expected: seq[int], rng: var Rand) =\n    doAssert st.len == expected.len\n\
    \    var total = 0\n    for i, x in expected:\n        doAssert st[i] == x\n \
    \       total += x\n    doAssert st.get_all() == total\n    doAssert $st == expected.join(\"\
    \ \")\n    for rep in 0..<5:\n        var l = rng.rand(expected.len)\n       \
    \ var r = rng.rand(expected.len)\n        if l > r: swap(l, r)\n        var sum\
    \ = 0\n        for i in l..<r: sum += expected[i]\n        doAssert st.query(l,\
    \ r) == sum\n        doAssert st[l..<r] == sum\n        let limit = rng.rand(total\
    \ + 1)\n        let predicate = proc(x: int): bool = x <= limit\n        var right\
    \ = l\n        sum = 0\n        while right < expected.len and sum + expected[right]\
    \ <= limit:\n            sum += expected[right]\n            inc right\n     \
    \   doAssert st.max_right(l, predicate) == right\n        var left = r\n     \
    \   sum = 0\n        while left > 0 and expected[left - 1] + sum <= limit:\n \
    \           dec left\n            sum += expected[left]\n        doAssert st.min_left(r,\
    \ predicate) == left\n\nvar rng = initRand(20260926)\nfor n in [0, 1, 2, 3, 7,\
    \ 16, 31, 64]:\n    var initial = newSeq[int](n)\n    for x in initial.mitems:\
    \ x = rng.rand(9)\n    var versions = @[newPersistentSegWith(initial, l + r, 0)]\n\
    \    var states = @[initial]\n    check(versions[0], states[0], rng)\n    if n\
    \ == 0:\n        doAssert initPersistentSegmentTree[int](0, proc(l, r: int): int\
    \ = l + r, 0).len == 0\n        continue\n    for step in 0..<300:\n        let\
    \ parent = if step mod 3 == 0: versions.high else: rng.rand(versions.high)\n \
    \       let p = rng.rand(n - 1)\n        let value = rng.rand(20)\n        var\
    \ expected = newSeq[int](n)\n        for i in 0..<n: expected[i] = states[parent][i]\n\
    \        var next = versions[parent]\n        if step mod 3 == 0:\n          \
    \  let source = rng.rand(versions.high)\n            let l = rng.rand(n)\n   \
    \         let r = rng.rand(l..n)\n            for i in l..<r: expected[i] = states[source][i]\n\
    \            if step mod 2 == 0: next = next.copy_range(versions[source], l, r)\n\
    \            else: next = next.copy_range(versions[source], l..<r)\n         \
    \   check(versions[source], states[source], rng)\n        else:\n            expected[p]\
    \ = value\n            if step mod 2 == 0: next = next.update(p, value)\n    \
    \        else: next[p] = value\n        versions.add(next)\n        states.add(expected)\n\
    \        check(next, expected, rng)\n        check(versions[parent], states[parent],\
    \ rng)\n        let old = rng.rand(versions.high)\n        check(versions[old],\
    \ states[old], rng)\n    for i in 0..<versions.len: check(versions[i], states[i],\
    \ rng)\n\nblock:\n    var calls = 0\n    let merge = proc(l, r: int): int =\n\
    \        inc calls\n        l + r\n    let tree = initPersistentSegmentTree(4097,\
    \ merge, 0)\n    calls = 0\n    let changed = tree.update(2000, 1)\n    doAssert\
    \ calls < 100\n    calls = 0\n    doAssert changed.get(17, 4096) == 1\n    doAssert\
    \ calls < 100\n    calls = 0\n    doAssert changed.max_right(17, proc(x: int):\
    \ bool = x == 0) == 2000\n    doAssert calls < 100\n    calls = 0\n    doAssert\
    \ changed.min_left(4096, proc(x: int): bool = x == 0) == 2001\n    doAssert calls\
    \ < 100\n\nblock:\n    let empty = newPersistentSegWith(0, l + r, 0)\n    doAssert\
    \ empty.copy_range(empty, 0, 0).get_all() == 0\n    doAssert empty.copy_range(empty,\
    \ 0..<0).len == 0\n    let a = newPersistentSegWith([1, 2, 3, 4, 5], l + r, 0)\n\
    \    let b = newPersistentSegWith([6, 7, 8, 9, 10], l + r, 0)\n    for l in 0..5:\n\
    \        for r in l..5:\n            let copied = a.copy_range(b, l, r)\n    \
    \        var expected = @[1, 2, 3, 4, 5]\n            for i in l..<r: expected[i]\
    \ = i + 6\n            check(copied, expected, rng)\n    check(a.copy_range(a,\
    \ 1, 4), @[1, 2, 3, 4, 5], rng)\n    check(a, @[1, 2, 3, 4, 5], rng)\n    check(b,\
    \ @[6, 7, 8, 9, 10], rng)\n    doAssert newPersistentSegWith([1], l + r, 0).copy_range(\n\
    \        newPersistentSegWith([2], l + r, 0), 0, 1)[0] == 2\n\nblock:\n    # \u5225\
    \u3005\u306B\u69CB\u7BC9\u3057\u305F\u6728\u306E\u30B3\u30D4\u30FC\u3068\u3001\
    \u5143\u306E\u6728\u306E\u7834\u68C4\u5F8C\u306E\u5BFF\u547D\u3092\u691C\u8A3C\
    \u3059\u308B\u3002\n    proc makeCopied(full: bool): PSegmentTree[string] =\n\
    \        let dest = newPersistentSegWith([\"a\", \"b\", \"c\", \"d\", \"e\"],\
    \ l & r, \"\")\n        let source = newPersistentSegWith([\"v\", \"w\", \"x\"\
    , \"y\", \"z\"], l & r, \"\")\n        if full: dest.copy_range(source, 0, 5)\n\
    \        else: dest.copy_range(source, 1..<4)\n    let saved = makeCopied(false)\n\
    \    let full = makeCopied(true)\n    GC_fullCollect()\n    doAssert saved.get_all()\
    \ == \"awxye\"\n    doAssert full.get_all() == \"vwxyz\"\n    var tree = saved\n\
    \    for i in 0..<3000:\n        tree = tree.update(i mod 5, $char(ord('A') +\
    \ i mod 26))\n    GC_fullCollect()\n    doAssert saved.get_all() == \"awxye\"\n\
    \    for l in 0..5:\n        for r in l..5:\n            let target = \"awxye\"\
    [l..<r]\n            doAssert saved.get(l, r) == target\n            doAssert\
    \ saved.max_right(l, proc(x: string): bool = target.startsWith(x)) == r\n    \
    \        doAssert saved.min_left(r, proc(x: string): bool = target.endsWith(x))\
    \ == l\n\nblock:\n    # \u8907\u6570\u306E\u72EC\u7ACB\u3057\u305F\u6728\u3092\
    \u53CC\u65B9\u5411\u306B\u30B3\u30D4\u30FC\u3057\u3001\u6240\u6709\u9818\u57DF\
    \u306E\u7D71\u5408\u3092\u691C\u8A3C\u3059\u308B\u3002\n    var trees: seq[PSegmentTree[int]]\n\
    \    var states: seq[seq[int]]\n    for i in 0..<16:\n        states.add(@[i,\
    \ i + 1, i + 2, i + 3, i + 4])\n        trees.add(newPersistentSegWith(states[^1],\
    \ l + r, 0))\n    for i in 0..<256:\n        let d = rng.rand(15)\n        let\
    \ s = rng.rand(15)\n        let l = rng.rand(4)\n        let r = rng.rand(l..5)\n\
    \        trees[d] = trees[d].copy_range(trees[s], l, r)\n        for j in l..<r:\
    \ states[d][j] = states[s][j]\n        if i mod 16 == 0: GC_fullCollect()\n  \
    \      check(trees[d], states[d], rng)\n    GC_fullCollect()\n    for i in 0..<16:\
    \ check(trees[i], states[i], rng)\n\nblock:\n    # \u72EC\u7ACB\u3057\u305F\u6728\
    \u304B\u3089\u53CD\u5FA9\u30B3\u30D4\u30FC\u3057\u3066\u3082\u3001\u89E3\u653E\
    \u6642\u306E\u53C2\u7167\u30C1\u30A7\u30FC\u30F3\u304C\u6DF1\u304F\u306A\u3089\
    \u306A\u3044\u3053\u3068\u3002\n    proc repeatedCopy() =\n        var a = newPersistentSegWith([1,\
    \ 2], l + r, 0)\n        let b = newPersistentSegWith([3, 4], l + r, 0)\n    \
    \    for i in 0..<200000: a = a.copy_range(b, 0, 1)\n        doAssert a.get_all()\
    \ == 5\n    repeatedCopy()\n    GC_fullCollect()\n\nblock:\n    var calls = 0\n\
    \    let merge = proc(l, r: int): int =\n        inc calls\n        l + r\n  \
    \  let dest = initPersistentSegmentTree(4097, merge, 0)\n    var values = newSeq[int](4097)\n\
    \    for x in values.mitems: x = 1\n    let source = initPersistentSegmentTree(values,\
    \ merge, 0)\n    calls = 0\n    let copied = dest.copy_range(source, 17, 4096)\n\
    \    doAssert copied.get_all() == 4096 - 17\n    doAssert calls < 100\n    calls\
    \ = 0\n    doAssert dest.copy_range(source, 0, 4097).get_all() == 4097\n    doAssert\
    \ calls == 0\n    doAssert dest.get_all() == 0\n    doAssert source.get_all()\
    \ == 4097\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/collections/persistent_segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/persistent_segtree.nim
  isVerificationFile: true
  path: verify/AI/persistent_segtree_test.nim
  requiredBy: []
  timestamp: '2026-09-28 04:00:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_segtree_test.nim
- /verify/verify/AI/persistent_segtree_test.nim.html
title: verify/AI/persistent_segtree_test.nim
---
