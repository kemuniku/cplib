---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import random, sequtils, strutils\n\nblock:\n    type S = tuple[sum, size:\
    \ int]\n    type F = tuple[a, b: int]\n    proc merge(x, y: S): S = (x.sum + y.sum,\
    \ x.size + y.size)\n    proc mapping(f: F, x: S): S = (f.a * x.sum + f.b * x.size,\
    \ x.size)\n    proc composition(f, g: F): F = (f.a * g.a, f.a * g.b + f.b)\n \
    \   var rng = initRand(314159)\n    for n in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33]:\n\
    \        var values = newSeqWith(n, 1)\n        var seg = initLazySegmentTree[S,\
    \ F](\n            values.mapIt((it, 1)), merge, (0, 0), mapping, composition,\
    \ (1, 0))\n        for step in 0..<100:\n            if n > 0:\n             \
    \   let l = rng.rand(n)\n                let r = rng.rand(l..n)\n            \
    \    let f: F = (rng.rand(1), rng.rand(5))\n                seg.apply(l, r, f)\n\
    \                for i in l..<r:\n                    values[i] = f.a * values[i]\
    \ + f.b\n                if step mod 7 == 0:\n                    let i = rng.rand(n\
    \ - 1)\n                    values[i] = rng.rand(10)\n                    seg[i]\
    \ = (values[i], 1)\n            for limit in [0, 1, 10, 50, 10000]:\n        \
    \        proc pred(x: S): bool = x.sum <= limit\n                for l in 0..n:\n\
    \                    var r = l\n                    var total = 0\n          \
    \          while r < n and total + values[r] <= limit:\n                     \
    \   total += values[r]\n                        inc r\n                    doAssert\
    \ seg.max_right(l, pred) == r\n                for r in 0..n:\n              \
    \      var l = r\n                    var total = 0\n                    while\
    \ l > 0 and values[l - 1] + total <= limit:\n                        dec l\n \
    \                       total += values[l]\n                    doAssert seg.min_left(r,\
    \ pred) == l\n            doAssert seg.get(0, n).sum == values.foldl(a + b, 0)\n\
    \nblock:\n    proc merge(x, y: string): string = x & y\n    proc mapping(f: char,\
    \ x: string): string =\n        if f == '\\0': x else: repeat(f, x.len)\n    proc\
    \ composition(f, g: char): char =\n        if f == '\\0': g else: f\n    var values\
    \ = @[\"a\", \"b\", \"c\", \"a\", \"b\", \"c\", \"a\", \"b\", \"c\"]\n    var\
    \ seg = initLazySegmentTree[string, char](\n        values, merge, \"\", mapping,\
    \ composition, '\\0')\n    for step in 0..<3:\n        if step > 0:\n        \
    \    let ch = if step == 1: 'b' else: 'c'\n            seg.apply(0, 8, ch)\n \
    \           for i in 0..<8:\n                values[i] = $ch\n        for l in\
    \ 0..values.len:\n            for r in l..values.len:\n                let target\
    \ = values[l..<r].join(\"\")\n                doAssert seg.max_right(l, proc(x:\
    \ string): bool = target.startsWith(x)) == r\n                doAssert seg.min_left(r,\
    \ proc(x: string): bool = target.endsWith(x)) == l\n        doAssert seg.get(0,\
    \ values.len) == values.join(\"\")\n"
  dependsOn: []
  isVerificationFile: false
  path: verify/collections/lazysegtree/binary_search_checks.nim
  requiredBy: []
  timestamp: '2026-09-11 02:59:49+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/lazysegtree/binary_search_checks.nim
layout: document
redirect_from:
- /library/verify/collections/lazysegtree/binary_search_checks.nim
- /library/verify/collections/lazysegtree/binary_search_checks.nim.html
title: verify/collections/lazysegtree/binary_search_checks.nim
---
