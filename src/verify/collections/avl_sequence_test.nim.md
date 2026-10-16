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
    import random, sequtils, strutils\nimport cplib/collections/[avl_monoid, avl_lazysegtree,\
    \ avl_dualsegtree]\n\nproc concat(a, b: string): string = a & b\n\nblock:\n  \
    \  var rng = initRand(20261015)\n    var tree = newAvlMonoidWith(newSeq[string](),\
    \ l & r, \"\")\n    var values: seq[string]\n    doAssert tree.fold == \"\"\n\
    \    for step in 0..<2500:\n        let n = values.len\n        let l = rng.rand(n)\n\
    \        let r = rng.rand(l..n)\n        case rng.rand(0..5)\n        of 0, 1:\n\
    \            let x = $(rng.rand(0..9))\n            tree.insert(l, x)\n      \
    \      values.insert(x, l)\n        of 2:\n            tree.erase(l, r)\n    \
    \        values = values[0..<l] & values[r..<n]\n        of 3:\n            if\
    \ l < n:\n                let x = $(rng.rand(0..9))\n                tree[l] =\
    \ x\n                values[l] = x\n        of 4:\n            if l < n:\n   \
    \             tree.erase(l)\n                values.delete(l)\n        else:\n\
    \            discard\n        doAssert tree.len == values.len\n        doAssert\
    \ tree.toSeq == values\n        doAssert tree.fold == values.join(\"\")\n    \
    \    let a = rng.rand(values.len)\n        let b = rng.rand(a..values.len)\n \
    \       doAssert tree.fold(a, b) == values[a..<b].join(\"\")\n        let limit\
    \ = rng.rand(0..values.len + 2)\n        doAssert tree.max_right(a, proc(x: string):\
    \ bool = x.len <= limit) == min(values.len, a + limit)\n        doAssert tree.min_left(b,\
    \ proc(x: string): bool = x.len <= limit) == max(0, b - limit)\n    tree.erase(0,\
    \ tree.len)\n    doAssert tree.toSeq.len == 0\n\nblock:\n    var tree = initAvlMonoid(@[\"\
    ab\", \"c\", \"de\"], concat, \"\")\n    doAssert tree.max_right(0, proc(x: string):\
    \ bool = \"abc\".startsWith(x)) == 2\n    doAssert tree.min_left(3, proc(x: string):\
    \ bool = \"cde\".endsWith(x)) == 1\n    tree.insert(1, \"X\")\n    doAssert tree.get_all\
    \ == \"abXcde\"\n    tree.erase(2)\n    doAssert tree.get_all == \"abXde\"\n\n\
    const Mod = 998244353\ntype S = tuple[sum, len: int]\ntype F = tuple[a, b: int]\n\
    const Identity: F = (1, 0)\nproc op(x, y: S): S = ((x.sum + y.sum) mod Mod, x.len\
    \ + y.len)\nproc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.len) mod Mod,\
    \ x.len)\nproc composition(f, g: F): F = (f.a * g.a mod Mod, (f.a * g.b + f.b)\
    \ mod Mod)\n\ntemplate checkOperations(tree: untyped) =\n    block:\n        var\
    \ seg = tree\n        var values: seq[S]\n        var rng = initRand(20261016)\n\
    \        seg.apply(0, 0, Identity)\n        seg.erase(0, 0)\n        for step\
    \ in 0..<3000:\n            let n = values.len\n            let l = rng.rand(n)\n\
    \            let r = rng.rand(l..n)\n            case rng.rand(0..7)\n       \
    \     of 0, 1:\n                let x: S = (rng.rand(100), 1)\n              \
    \  seg.insert(l, x)\n                values.insert(x, l)\n            of 2:\n\
    \                seg.erase(l, r)\n                values = values[0..<l] & values[r..<n]\n\
    \            of 3:\n                let f: F = (rng.rand(0..3), rng.rand(100))\n\
    \                seg.apply(l, r, f)\n                for i in l..<r: values[i]\
    \ = mapping(f, values[i])\n            of 4:\n                if l < n:\n    \
    \                let x: S = (rng.rand(100), 1)\n                    seg[l] = x\n\
    \                    values[l] = x\n            of 5:\n                if l <\
    \ n:\n                    let f: F = (0, rng.rand(100))\n                    seg.apply(l,\
    \ f)\n                    values[l] = mapping(f, values[l])\n            of 6:\n\
    \                if l < n:\n                    seg.erase(l)\n               \
    \     values.delete(l)\n            else:\n                if l < n: doAssert\
    \ seg[l] == values[l]\n            doAssert seg.len == values.len\n          \
    \  when compiles(seg.get_all):\n                var expected: S = (0, 0)\n   \
    \             for x in values: expected = op(expected, x)\n                doAssert\
    \ seg.get_all == expected\n                let a = rng.rand(values.len)\n    \
    \            let b = rng.rand(a..values.len)\n                expected = (0, 0)\n\
    \                for i in a..<b: expected = op(expected, values[i])\n        \
    \        doAssert seg.get(a, b) == expected\n                let limit = rng.rand(0..values.len\
    \ + 2)\n                doAssert seg.max_right(a, proc(x: S): bool = x.len <=\
    \ limit) == min(values.len, a + limit)\n                doAssert seg.min_left(b,\
    \ proc(x: S): bool = x.len <= limit) == max(0, b - limit)\n            if step\
    \ mod 73 == 0: doAssert seg.toSeq == values\n        doAssert seg.toSeq == values\n\
    \        seg.erase(0, seg.len)\n        seg.insert(0, (42, 1))\n        doAssert\
    \ seg[^1] == (42, 1)\n\ncheckOperations(initAvlLazySegmentTree(newSeq[S](), op,\
    \ (0, 0), mapping, composition, Identity))\ncheckOperations(initAvlDualSegmentTree(newSeq[S](),\
    \ mapping, composition, Identity))\n\nblock:\n    var seg = newAvlLazySegWith(@[\"\
    a\", \"b\", \"c\", \"d\"], l & r, \"\",\n        (if f: x.toUpperAscii else: x),\
    \ f or g, false)\n    seg.apply(0, 4, true)\n    seg.insert(2, \"x\")\n    seg.erase(1)\n\
    \    doAssert seg.fold == \"AxCD\"\n    doAssert seg.get(1, 3) == \"xC\"\n   \
    \ doAssert seg.max_right(0, proc(x: string): bool = \"Ax\".startsWith(x)) == 2\n\
    \    doAssert seg.min_left(4, proc(x: string): bool = \"CD\".endsWith(x)) == 2\n\
    \nblock:\n    var seg = newAvlDualSegWith(4, 100, min(f, x), min(f, g), high(int))\n\
    \    seg.apply(0, 4, 10)\n    seg.insert(2, 50)\n    seg.erase(0..1)\n    doAssert\
    \ seg.toSeq == @[50, 10, 10]\n\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/collections/avl_sequence_test.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/avl_sequence_test.nim
layout: document
redirect_from:
- /verify/verify/collections/avl_sequence_test.nim
- /verify/verify/collections/avl_sequence_test.nim.html
title: verify/collections/avl_sequence_test.nim
---
