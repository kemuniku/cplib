---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone.nim
    title: cplib/collections/convex_hull_trick_monotone.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone.nim
    title: cplib/collections/convex_hull_trick_monotone.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone_slope.nim
    title: cplib/collections/convex_hull_trick_monotone_slope.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick_monotone_slope.nim
    title: cplib/collections/convex_hull_trick_monotone_slope.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    import algorithm, random\nimport cplib/collections/convex_hull_trick_monotone_slope\n\
    import cplib/collections/convex_hull_trick_monotone\nimport cplib/collections/convex_hull_trick\n\
    import cplib/math/int128\n\ntype Line = tuple[a, b: int]\n\nproc naive(lines:\
    \ seq[Line], x: int): Int128 =\n    result = to_Int128(lines[0].a) * to_Int128(x)\
    \ + to_Int128(lines[0].b)\n    for line in lines:\n        result = min(result,\
    \ to_Int128(line.a) * to_Int128(x) + to_Int128(line.b))\n\nproc checkDynamic(lines:\
    \ seq[Line], coordinates: seq[int]) =\n    var hull = initConvexHullTrick()\n\
    \    var added: seq[Line]\n    for line in lines:\n        hull.add_line(line.a,\
    \ line.b)\n        added.add(line)\n        for x in coordinates:\n          \
    \  let expected = naive(added, x)\n            if to_Int128(low(int)) <= expected\
    \ and expected <= to_Int128(high(int)):\n                doAssert hull.get_min(x)\
    \ == expected.to_int\n\nvar rng = initRand(20260912)\nfor slopeIncreasing in [false,\
    \ true]:\n    for xIncreasing in [false, true]:\n        for trial in 0..<100:\n\
    \            var hull = initConvexHullTrickMonotoneSlope(slopeIncreasing)\n  \
    \          var monotone = initConvexHullTrickMonotone(slopeIncreasing, xIncreasing)\n\
    \            var dynamic = initConvexHullTrick()\n            var lines: seq[Line]\n\
    \            var a = if slopeIncreasing: -100 else: 100\n            var x = if\
    \ xIncreasing: -100 else: 100\n            for step in 0..<150:\n            \
    \    if step == 0 or rng.rand(2) != 0:\n                    a += (if slopeIncreasing:\
    \ 1 else: -1) * rng.rand(3)\n                    let b = rng.rand(-10000..10000)\n\
    \                    lines.add((a, b))\n                    hull.add_line(a, b)\n\
    \                    monotone.add_line(a, b)\n                    dynamic.add_line(a,\
    \ b)\n                else:\n                    x += (if xIncreasing: 1 else:\
    \ -1) * rng.rand(3)\n                    doAssert monotone.get_min(x) == naive(lines,\
    \ x).to_int\n                let q = rng.rand(-200..200)\n                doAssert\
    \ hull.get_min(q) == naive(lines, q).to_int\n                doAssert dynamic.get_min(q)\
    \ == naive(lines, q).to_int\n\nfor trial in 0..<200:\n    var lines: seq[Line]\n\
    \    for i in 0..<100:\n        lines.add((rng.rand(-30..30), rng.rand(-100..100)))\n\
    \    checkDynamic(lines, @[-100, -17, -2, -1, 0, 1, 2, 13, 100])\n\nlet extremes\
    \ = @[low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]\nvar extremeLines:\
    \ seq[Line]\nfor a in extremes:\n    for b in extremes:\n        extremeLines.add((a,\
    \ b))\nfor trial in 0..<20:\n    rng.shuffle(extremeLines)\n    checkDynamic(extremeLines,\
    \ extremes)\n\nfor slopeIncreasing in [false, true]:\n    var lines = extremeLines\n\
    \    lines.sort(proc(l, r: Line): int =\n        if slopeIncreasing: cmp(l.a,\
    \ r.a) else: cmp(r.a, l.a))\n    var hull = initConvexHullTrickMonotoneSlope(slopeIncreasing)\n\
    \    for line in lines:\n        hull.add_line(line.a, line.b)\n    for xIncreasing\
    \ in [false, true]:\n        var monotone = initConvexHullTrickMonotone(slopeIncreasing,\
    \ xIncreasing)\n        for line in lines:\n            monotone.add_line(line.a,\
    \ line.b)\n        var coordinates = extremes\n        if not xIncreasing: coordinates.reverse()\n\
    \        for x in coordinates:\n            let expected = naive(lines, x)\n \
    \           if to_Int128(low(int)) <= expected and expected <= to_Int128(high(int)):\n\
    \                doAssert hull.get_min(x) == expected.to_int\n               \
    \ doAssert monotone.get_min(x) == expected.to_int\n\ncheckDynamic(@[(3, 0), (2,\
    \ 0), (1, 0), (0, 0), (-1, 0)], @[-1, 0, 1])\ncheckDynamic(@[(3, 0), (1, 1), (2,\
    \ 0), (2, -1), (2, 2)], @[-2, -1, 0, 1, 2])\ncheckDynamic(@[(0, high(int)), (0,\
    \ low(int))], extremes)\ncheckDynamic(@[(high(int), high(int)), (low(int), low(int))],\
    \ @[-1, 0])\n\nblock:\n    var hull = initConvexHullTrick()\n    var sortedHull\
    \ = initConvexHullTrickMonotoneSlope(slopeIncreasing = true)\n    var monotoneHull\
    \ = initConvexHullTrickMonotone(slopeIncreasing = true)\n    for a in 0..<10000:\n\
    \        hull.add_line(a, a * a)\n        sortedHull.add_line(a, a * a)\n    \
    \    monotoneHull.add_line(a, a * a)\n    for x in -20000..0:\n        let a =\
    \ min(9999, (-x) div 2)\n        let expected = a * x + a * a\n        doAssert\
    \ hull.get_min(x) == expected\n        doAssert sortedHull.get_min(x) == expected\n\
    \        doAssert monotoneHull.get_min(x) == expected\n    hull.add_line(0, -1000000000)\n\
    \    doAssert hull.get_min(0) == -1000000000\n\nwhen compileOption(\"assertions\"\
    ):\n    template rejects(body: untyped) =\n        block:\n            var rejected\
    \ = false\n            try:\n                body\n            except AssertionDefect:\n\
    \                rejected = true\n            doAssert rejected\n    rejects:\n\
    \        let hull = initConvexHullTrickMonotoneSlope()\n        discard hull.get_min(0)\n\
    \    rejects:\n        var hull = initConvexHullTrickMonotone()\n        discard\
    \ hull.get_min(0)\n    rejects:\n        let hull = initConvexHullTrick()\n  \
    \      discard hull.get_min(0)\n    rejects:\n        var hull = initConvexHullTrickMonotoneSlope()\n\
    \        hull.add_line(0, 0)\n        hull.add_line(1, 0)\n    rejects:\n    \
    \    var hull = initConvexHullTrickMonotone()\n        hull.add_line(0, 0)\n \
    \       discard hull.get_min(1)\n        discard hull.get_min(0)\n\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/collections/convex_hull_trick_monotone_slope.nim
  - cplib/math/int128.nim
  - cplib/collections/convex_hull_trick_monotone.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/convex_hull_trick_monotone.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/convex_hull_trick_monotone_slope.nim
  isVerificationFile: true
  path: verify/collections/convex_hull_trick_test.nim
  requiredBy: []
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/convex_hull_trick_test.nim
layout: document
redirect_from:
- /verify/verify/collections/convex_hull_trick_test.nim
- /verify/verify/collections/convex_hull_trick_test.nim.html
title: verify/collections/convex_hull_trick_test.nim
---
