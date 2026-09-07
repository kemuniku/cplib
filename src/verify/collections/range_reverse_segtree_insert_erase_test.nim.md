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
    import std/[random, sequtils, algorithm, strutils]\nimport cplib/collections/[range_reverse_lazysegtree,\
    \ range_reverse_dualsegtree]\n\ntype\n    S = tuple[sum, len: int]\n    F = tuple[a,\
    \ b: int]\nconst Mod = 998244353\nproc op(x, y: S): S = ((x.sum + y.sum) mod Mod,\
    \ x.len + y.len)\nproc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.len) mod\
    \ Mod, x.len)\nproc composition(f, g: F): F = (f.a * g.a mod Mod, (f.a * g.b +\
    \ f.b) mod Mod)\nconst Identity: F = (1, 0)\n\n# \u96C6\u7D04\u3092\u8981\u6C42\
    \u3057\u306A\u3044\u53CC\u5BFE\u7248\u3067\u3082\u3001\u540C\u3058\u64CD\u4F5C\
    \u5217\u3092\u691C\u8A3C\u3059\u308B\u3002\ntemplate checkOperations(tree: untyped)\
    \ =\n    block:\n        var seg = tree\n        var values: seq[S]\n        var\
    \ rng = initRand(20260906)\n        seg.apply(0, 0, (2, 3))\n        seg.reverse(0,\
    \ 0)\n        seg.erase(0, 0)\n        for step in 0..<6000:\n            let\
    \ n = values.len\n            let l = rng.rand(n)\n            let r = rng.rand(l..n)\n\
    \            case rng.rand(0..8)\n            of 0, 1:\n                let x:\
    \ S = (rng.rand(100), 1)\n                seg.insert(l, x)\n                values.insert(x,\
    \ l)\n            of 2:\n                seg.erase(l..<r)\n                values\
    \ = values[0..<l] & values[r..<n]\n            of 3:\n                let f: F\
    \ = (rng.rand(0..3), rng.rand(100))\n                seg.apply(l, r, f)\n    \
    \            for i in l..<r: values[i] = mapping(f, values[i])\n            of\
    \ 4:\n                seg.reverse(l, r)\n                if l < r: values.reverse(l,\
    \ r - 1)\n            of 5:\n                if l < n:\n                    let\
    \ x: S = (rng.rand(100), 1)\n                    seg[l] = x\n                \
    \    values[l] = x\n            of 6:\n                if l < n:\n           \
    \         let f: F = (0, rng.rand(100))\n                    seg.apply(l, f)\n\
    \                    values[l] = mapping(f, values[l])\n            of 7:\n  \
    \              if l < n:\n                    seg.erase(l)\n                 \
    \   values.delete(l)\n            else:\n                if l < n: doAssert seg[l]\
    \ == values[l]\n            doAssert seg.len == values.len\n            when compiles(seg.get_all):\n\
    \                var expected: S = (0, 0)\n                for x in values: expected\
    \ = op(expected, x)\n                doAssert seg.get_all == expected\n      \
    \          let a = rng.rand(values.len)\n                let b = rng.rand(a..values.len)\n\
    \                expected = (0, 0)\n                for i in a..<b: expected =\
    \ op(expected, values[i])\n                doAssert seg.get(a, b) == expected\n\
    \                let limit = rng.rand(0..values.len + 2)\n                doAssert\
    \ seg.max_right(a, proc(x: S): bool = x.len <= limit) == min(values.len, a + limit)\n\
    \                doAssert seg.min_left(b, proc(x: S): bool = x.len <= limit) ==\
    \ max(0, b - limit)\n            # \u6BCE\u56DE\u5168\u8981\u7D20\u3092\u8AAD\u3080\
    \u3068\u9045\u5EF6\u30BF\u30B0\u304C\u6D88\u3048\u308B\u305F\u3081\u3001\u5B9A\
    \u671F\u7684\u306B\u3060\u3051\u6BD4\u8F03\u3059\u308B\u3002\n            if step\
    \ mod 71 == 0: doAssert seg.toSeq == values\n        doAssert seg.toSeq == values\n\
    \        seg.erase(0, seg.len)\n        doAssert seg.len == 0\n        seg.insert(0,\
    \ (42, 1))\n        doAssert seg[^1] == (42, 1)\n        seg.erase(0)\n      \
    \  doAssert seg.toSeq == newSeq[S]()\n\ncheckOperations(initRangeReverseLazySegmentTree(newSeq[S](),\
    \ op, (0, 0), mapping, composition, Identity))\ncheckOperations(initRangeReverseDualSegmentTree(newSeq[S](),\
    \ mapping, composition, Identity))\n\n# \u9045\u5EF6\u30BF\u30B0\u3092\u6B8B\u3057\
    \u305F\u307E\u307E\u633F\u5165\u30FB\u524A\u9664\u3059\u308B\u3002\u65B0\u3057\
    \u3044\u8981\u7D20\u306B\u306F\u904E\u53BB\u306E\u66F4\u65B0\u3092\u9069\u7528\
    \u3057\u306A\u3044\u3002\nblock:\n    var seg = initRangeReverseLazySegmentTree(newSeqWith(100,\
    \ (sum: 1, len: 1)), op, (0, 0), mapping, composition, Identity)\n    seg.apply(0,\
    \ 100, (2, 3))\n    seg.apply(0, 100, (3, 7))\n    seg.reverse(0, 100)\n    seg.insert(50,\
    \ (100, 1))\n    seg.erase(0, 50)\n    doAssert seg[0] == (100, 1)\n    doAssert\
    \ seg.get(1, 51) == (1100, 50)\n    doAssert seg.max_right(1, proc(x: S): bool\
    \ = x.sum <= 66) == 4\n    doAssert seg.min_left(51, proc(x: S): bool = x.sum\
    \ <= 66) == 48\n\n# \u975E\u53EF\u63DB\u306A\u96C6\u7D04\u3067\u3082\u5DE6\u53F3\
    \u306E\u9806\u5E8F\u3001\u53CD\u8EE2\u5F8C\u306E\u4E8C\u5206\u63A2\u7D22\u3092\
    \u7DAD\u6301\u3059\u308B\u3002\nblock:\n    var seg = newRangeReverseLazySegWith(\n\
    \        @[\"a\", \"b\", \"c\", \"d\"], l & r, \"\",\n        (if f: x.toUpperAscii\
    \ else: x), f or g, false)\n    seg.apply(0, 4, true)\n    seg.reverse(0, 4)\n\
    \    seg.insert(2, \"x\")\n    seg.erase(1)\n    doAssert seg.fold == \"DxBA\"\
    \n    for l in 0..seg.len:\n        for r in l..seg.len:\n            let target\
    \ = seg.toSeq[l..<r].join(\"\")\n            doAssert seg.max_right(l, proc(x:\
    \ string): bool = target.startsWith(x)) == r\n            doAssert seg.min_left(r,\
    \ proc(x: string): bool = target.endsWith(x)) == l\n    doAssert seg.fold == \"\
    DxBA\"\n\n# \u53CC\u5BFE\u7248\u306F\u30E2\u30CE\u30A4\u30C9\u306B\u4F5C\u7528\
    \u3057\u306A\u3044\u66F4\u65B0\uFF08chmin \u306A\u3069\uFF09\u3082\u6271\u3048\
    \u308B\u3002\nblock:\n    var seg = newRangeReverseDualSegWith(4, 100, min(f,\
    \ x), min(f, g), high(int))\n    seg.apply(0, 4, 10)\n    seg.insert(2, 50)\n\
    \    seg.reverse(0, 5)\n    seg.erase(0..1)\n    doAssert seg.toSeq == @[50, 10,\
    \ 10]\n\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/collections/range_reverse_segtree_insert_erase_test.nim
  requiredBy: []
  timestamp: '2026-09-06 11:23:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_segtree_insert_erase_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_segtree_insert_erase_test.nim
- /verify/verify/collections/range_reverse_segtree_insert_erase_test.nim.html
title: verify/collections/range_reverse_segtree_insert_erase_test.nim
---
