---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_sort_segtree.nim
    title: cplib/collections/range_sort_segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
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
    import algorithm, random\nimport cplib/collections/range_sort_segtree\n\nconst\
    \ MOD = 998244353\ntype\n    Affine = tuple[a, b: int]\n    Item[T] = tuple[key:\
    \ int, value: T]\n\nproc compose(f, g: Affine): Affine =\n    (g.a * f.a mod MOD,\
    \ (g.a * f.b + g.b) mod MOD)\n\nproc concat(a, b: string): string = a & b\nproc\
    \ add(a, b: int): int = a + b\n\nproc sortRange[T](items: var seq[Item[T]], l,\
    \ r: int, order: SortOrder) =\n    var part = items[l..<r]\n    part.sort(proc(a,\
    \ b: Item[T]): int = cmp(a.key, b.key), order)\n    for i, item in part:\n   \
    \     items[l + i] = item\n\nproc checkStrings(seg: RangeSortSegmentTree[string],\
    \ items: seq[Item[string]]) =\n    doAssert seg.len == items.len\n    var all\
    \ = \"\"\n    for i, item in items:\n        doAssert seg.key(i) == item.key\n\
    \        doAssert seg[i] == item.value\n        all.add(item.value)\n    doAssert\
    \ seg.get_all() == all\n    for l in 0..items.len:\n        var expected = \"\"\
    \n        for r in l..items.len:\n            doAssert seg.get(l, r) == expected\n\
    \            doAssert seg[l..<r] == expected\n            if r < items.len: expected.add(items[r].value)\n\
    \nblock:\n    let seg = initRangeSortSegmentTree(newSeq[int](), newSeq[string](),\
    \ 0, concat, \"\")\n    doAssert seg.len == 0\n    doAssert seg.get_all() == \"\
    \"\n    doAssert seg.get(0, 0) == \"\"\n    doAssert seg[0..<0] == \"\"\n    seg.sort(0,\
    \ 0)\n    seg.sort(0..<0, Descending)\n\nblock:\n    let seg = initRangeSortSegmentTree([0],\
    \ [\"a\"], 1, concat, \"\")\n    seg.sort(0, 1, Descending)\n    doAssert seg.key(0)\
    \ == 0\n    doAssert seg[^1] == \"a\"\n    seg[^1] = \"b\"\n    doAssert seg.get_all()\
    \ == \"b\"\n    seg.update(0, 0, \"\")\n    doAssert seg[0..0] == \"\"\n    seg.update(0,\
    \ \"c\")\n    doAssert seg.get(0, 1) == \"c\"\n\nblock:\n    var items: seq[Item[string]]\
    \ = @[\n        (9, \"A\"), (0, \"B\"), (6, \"\"), (2, \"CD\"), (10, \"E\"), (4,\
    \ \"F\"), (7, \"G\")]\n    let seg = initRangeSortSegmentTree([9, 0, 6, 2, 10,\
    \ 4, 7],\n        [\"A\", \"B\", \"\", \"CD\", \"E\", \"F\", \"G\"], 11, concat,\
    \ \"\")\n    seg.checkStrings(items)\n    for order in [Descending, Ascending,\
    \ Descending]:\n        seg.sort(0, seg.len, order)\n        items.sortRange(0,\
    \ items.len, order)\n        doAssert seg.get_all() == (if order == Ascending:\
    \ \"BCDFGAE\" else: \"EAGFCDB\")\n        seg.checkStrings(items)\n        for\
    \ l in 0..seg.len:\n            for r in l..seg.len:\n                seg.sort(l..<r,\
    \ order)\n                items.sortRange(l, r, order)\n                seg.checkStrings(items)\n\
    \    seg.sort(0, seg.len, Descending)\n    items.sortRange(0, items.len, Descending)\n\
    \    seg.update(2, \"xy\")\n    items[2].value = \"xy\"\n    seg.update(3, 3,\
    \ \"Z\")\n    items[3] = (3, \"Z\")\n    seg.update(3, 6, \"W\")\n    items[3]\
    \ = (6, \"W\")\n    seg.checkStrings(items)\n\nblock:\n    let keys = [int.high\
    \ - 1, 0, int.high div 2, 1, int.high - 2]\n    var items: seq[Item[string]]\n\
    \    for i, key in keys: items.add((key, $i))\n    let seg = initRangeSortSegmentTree(keys,\
    \ [\"0\", \"1\", \"2\", \"3\", \"4\"], int.high, concat, \"\")\n    for _ in 0..<20:\n\
    \        for order in [Ascending, Descending]:\n            seg.sort(0, seg.len,\
    \ order)\n            items.sortRange(0, items.len, order)\n            seg.checkStrings(items)\n\
    \    seg.update(0, 2, \"new\")\n    items[0] = (2, \"new\")\n    seg.checkStrings(items)\n\
    \nvar rng = initRand(20260926)\nfor wideKeys in [false, true]:\n    for n in [1,\
    \ 2, 3, 7, 16, 31, 64]:\n        let limit = if wideKeys: int.high else: n * 4\
    \ + 7\n        var keys = newSeq[int](n)\n        var values = newSeq[Affine](n)\n\
    \        var items = newSeq[Item[Affine]](n)\n        for i in 0..<n:\n      \
    \      keys[i] = (2 * i + 1) * (if wideKeys: int.high div (n * 4 + 7) else: 1)\n\
    \        rng.shuffle(keys)\n        for i in 0..<n:\n            values[i] = (rng.rand(MOD\
    \ - 1), rng.rand(MOD - 1))\n            items[i] = (keys[i], values[i])\n    \
    \    let seg = initRangeSortSegmentTree(keys, values, limit, compose, (1, 0))\n\
    \        for step in 0..<1500:\n            var l = rng.rand(n)\n            var\
    \ r = rng.rand(n)\n            if l > r: swap(l, r)\n            let index = rng.rand(n\
    \ - 1)\n            let value: Affine = (rng.rand(MOD - 1), rng.rand(MOD - 1))\n\
    \            case rng.rand(5)\n            of 0, 1:\n                let order\
    \ = if step mod 2 == 0: Ascending else: Descending\n                if step mod\
    \ 3 == 0:\n                    l = 0\n                    r = n\n            \
    \    if step mod 2 == 0: seg.sort(l, r, order)\n                else: seg.sort(l..<r,\
    \ order)\n                items.sortRange(l, r, order)\n            of 2:\n  \
    \              var key = rng.rand(limit - 1)\n                while true:\n  \
    \                  var occupied = false\n                    for i, item in items:\n\
    \                        if i != index and item.key == key: occupied = true\n\
    \                    if not occupied: break\n                    key = rng.rand(limit\
    \ - 1)\n                seg.update(index, key, value)\n                items[index]\
    \ = (key, value)\n            of 3:\n                seg[index] = value\n    \
    \            items[index].value = value\n            of 4:\n                seg.update(index,\
    \ value)\n                items[index].value = value\n            else:\n    \
    \            discard\n            var all: Affine = (1, 0)\n            for i,\
    \ item in items:\n                doAssert seg.key(i) == item.key\n          \
    \      doAssert seg[i] == item.value\n                all = compose(all, item.value)\n\
    \            doAssert seg.get_all() == all\n            let x = rng.rand(MOD -\
    \ 1)\n            var expected = x\n            for i in l..<r:\n            \
    \    expected = (items[i].value.a * expected + items[i].value.b) mod MOD\n   \
    \         let f = seg.get(l, r)\n            doAssert (f.a * x + f.b) mod MOD\
    \ == expected\n            doAssert seg[l..<r] == f\n            doAssert seg.get_all()\
    \ == all\n\nblock:\n    let seg = initRangeSortSegmentTree([4, 1, 3, 0, 2], [4,\
    \ 1, 3, 0, 2], 5, add, 0)\n    for step in 0..<10000:\n        seg.sort(0, 5,\
    \ if step mod 2 == 0: Ascending else: Descending)\n        doAssert seg.get(1,\
    \ 4) == 6\n        doAssert seg.get_all() == 10\n\nwhen compileOption(\"assertions\"\
    ):\n    block:\n        var rejected = false\n        try:\n            discard\
    \ initRangeSortSegmentTree([1, 1], [2, 3], 2, add, 0)\n        except AssertionDefect:\n\
    \            rejected = true\n        doAssert rejected\n    block:\n        let\
    \ seg = initRangeSortSegmentTree([2, 0, 1], [2, 0, 1], 3, add, 0)\n        seg.sort(0,\
    \ 3, Descending)\n        var rejected = false\n        try:\n            seg.update(1,\
    \ 2, 9)\n        except AssertionDefect:\n            rejected = true\n      \
    \  doAssert rejected\n        doAssert seg.key(1) == 1\n        doAssert seg[1]\
    \ == 1\n        doAssert seg.get_all() == 3\n        seg.update(1, 1, 9)\n   \
    \     doAssert seg[1] == 9\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/range_sort_segtree.nim
  - cplib/collections/segtree.nim
  - cplib/collections/range_sort_segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/AI/range_sort_segtree_test.nim
  requiredBy: []
  timestamp: '2026-09-28 03:02:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/range_sort_segtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/range_sort_segtree_test.nim
- /verify/verify/AI/range_sort_segtree_test.nim.html
title: verify/AI/range_sort_segtree_test.nim
---
