---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
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
    import random\nimport cplib/collections/SWAG\nimport cplib/collections/segtree\n\
    \ntype Affine = tuple[a, b: int]\nconst modulus = 998244353\n\nfunc compose(l,\
    \ r: Affine): Affine =\n    ((l.a * r.a) mod modulus, (l.b * r.a + r.b) mod modulus)\n\
    \nproc check[T](swag: SWAG[T], values: seq[T],\n              merge: proc(l, r:\
    \ T): T, unit: T) =\n    var expected = unit\n    for value in values:\n     \
    \   expected = merge(expected, value)\n    doAssert swag.len == values.len\n \
    \   doAssert swag.fold() == expected\n    doAssert $swag == \"swag\" & $values\n\
    \    for i, value in values:\n        doAssert swag[i] == value\n        doAssert\
    \ swag[^(values.len - i)] == value\n\nproc exercise[T](swag: SWAG[T], merge: proc(l,\
    \ r: T): T,\n                 unit: T, samples: seq[T]) =\n    var values: seq[T]\
    \ = @[]\n    swag.check(values, merge, unit)\n    for fromFront in [false, true]:\n\
    \        for value in samples:\n            if fromFront:\n                swag.addFirst(value)\n\
    \                values.insert(value, 0)\n            else:\n                swag.addLast(value)\n\
    \                values.add(value)\n            swag.check(values, merge, unit)\n\
    \        while values.len > 0:\n            if fromFront:\n                doAssert\
    \ swag.popLast() == values.pop()\n            else:\n                doAssert\
    \ swag.popFirst() == values[0]\n                values.delete(0)\n           \
    \ swag.check(values, merge, unit)\n    var rng = initRand(20261005)\n    for _\
    \ in 0..<2000:\n        let action = rng.rand(3)\n        let value = samples[rng.rand(samples.high)]\n\
    \        if values.len == 0 or action == 0:\n            swag.addFirst(value)\n\
    \            values.insert(value, 0)\n        elif action == 1:\n            swag.addLast(value)\n\
    \            values.add(value)\n        elif action == 2:\n            doAssert\
    \ swag.popFirst() == values[0]\n            values.delete(0)\n        else:\n\
    \            doAssert swag.popLast() == values.pop()\n        swag.check(values,\
    \ merge, unit)\n    while values.len > 0:\n        doAssert swag.popLast() ==\
    \ values.pop()\n        swag.check(values, merge, unit)\n    for fromFront in\
    \ [false, true]:\n        var raised = false\n        try:\n            if fromFront:\
    \ discard swag.popFirst()\n            else: discard swag.popLast()\n        except\
    \ IndexDefect:\n            raised = true\n        doAssert raised\n        swag.check(values,\
    \ merge, unit)\n    swag.addLast(samples[0])\n    doAssert swag.popFirst() ==\
    \ samples[0]\n    swag.check(@[], merge, unit)\n\nlet sum = proc(l, r: int): int\
    \ = l + r\nlet minimum = proc(l, r: int): int = min(l, r)\nlet affine = proc(l,\
    \ r: Affine): Affine = compose(l, r)\nlet numbers = @[3, 1, 4, 1, 5, 9, 2, 6]\n\
    let functions: seq[Affine] = @[(2, 3), (5, 7), (0, 9), (11, 13), (17, 19)]\nlet\
    \ identity: Affine = (1, 0)\n\nlet sumSwag: SWAG[int] = newSwagWith(l + r, 0)\n\
    let minSwag = newswagwith(min(l, r), int.high)\nlet affineSwag = newSwagWith(compose(l,\
    \ r), identity)\nsumSwag.exercise(sum, 0, numbers)\nminSwag.exercise(minimum,\
    \ int.high, numbers)\naffineSwag.exercise(affine, identity, functions)\ninitSWAG(sum,\
    \ 0).exercise(sum, 0, numbers)\ninitSWAG(minimum, int.high).exercise(minimum,\
    \ int.high, numbers)\ninitSWAG(affine, identity).exercise(affine, identity, functions)\n\
    \nblock:\n    let l = 100\n    let r = 200\n    let merge = 300\n    let default\
    \ = 400\n    let first = newSwagWith(l + r, 0'i64)\n    let second = newSwagWith(min(l,\
    \ r), high(int64))\n    let tree = newsegwith(@[2'i64, 3'i64], l + r, 0'i64)\n\
    \    first.addLast(2'i64)\n    first.addLast(3'i64)\n    second.addLast(7'i64)\n\
    \    second.addLast(4'i64)\n    doAssert first.fold() == tree.get_all()\n    doAssert\
    \ second.fold() == 4'i64\n    doAssert (l, r, merge, default) == (100, 200, 300,\
    \ 400)\n\nblock:\n    var unitCalls = 0\n    proc unit(): int =\n        inc unitCalls\n\
    \        0\n    let swag = newSwagWith(l + r, unit())\n    doAssert unitCalls\
    \ == 1\n    doAssert swag.fold() == 0\n    swag.addLast(10)\n    doAssert swag.fold()\
    \ == 10\n    doAssert unitCalls == 1\n\nproc genericSum[T](unit: T): SWAG[T] =\n\
    \    newSwagWith(l + r, unit)\n\nblock:\n    let integers = genericSum(0'i32)\n\
    \    let reals = genericSum(0.0)\n    let strings = newSwagWith(l & r, \"\")\n\
    \    integers.addLast(12'i32)\n    integers.addFirst(30'i32)\n    doAssert integers.fold()\
    \ == 42'i32\n    reals.addLast(1.5)\n    reals.addFirst(2.5)\n    doAssert reals.fold()\
    \ == 4.0\n    strings.addLast(\"b\")\n    strings.addFirst(\"a\")\n    doAssert\
    \ strings.fold() == \"ab\"\n    let concat = proc(l, r: string): string = l &\
    \ r\n    newSwagWith(l & r, \"\").exercise(concat, \"\", @[\"a\", \"bc\", \"d\"\
    , \"ef\"])\n\nproc capturedSwag[T](ceiling: T): SWAG[T] =\n    newSwagWith(min(min(l,\
    \ r), ceiling), ceiling)\n\nproc capturedOldSwag[T](ceiling: T): SWAG[T] =\n \
    \   initSWAG(proc(l, r: T): T = min(min(l, r), ceiling), ceiling)\n\nblock:\n\
    \    let first = capturedSwag(10)\n    let second = capturedSwag(20)\n    let\
    \ old = capturedOldSwag(10)\n    first.addLast(5)\n    second.addLast(15)\n  \
    \  old.addLast(5)\n    doAssert first.fold() == old.fold()\n    doAssert second.fold()\
    \ == 15\n    doAssert first.popFirst() == 5\n    let captured = proc(l, r: int):\
    \ int = min(min(l, r), 10)\n    first.exercise(captured, 10, @[3, 1, 4, 5, 9])\n\
    \nstatic:\n    let swag = newSwagWith(l + r, 0)\n    doAssert swag.fold() == 0\n\
    \    swag.addLast(2)\n    swag.addFirst(3)\n    doAssert swag.fold() == 5\n  \
    \  doAssert swag.popLast() == 2\n    doAssert swag.popFirst() == 3\n    doAssert\
    \ swag.fold() == 0\n    let noncommutative = newSwagWith(compose(l, r), (1, 0))\n\
    \    noncommutative.addLast((2, 3))\n    noncommutative.addLast((5, 7))\n    doAssert\
    \ noncommutative.fold() == (10, 22)\n    doAssert noncommutative.popFirst() ==\
    \ (2, 3)\n    doAssert noncommutative.fold() == (5, 7)\n\ndoAssert get_maxrights(@[1,\
    \ 2, 3], sum, 0,\n    proc(x: int): bool = x <= 3) == @[2, 2, 3]\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/SWAG.nim
  - cplib/collections/SWAG.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/AI/SWAG_newswagwith_test.nim
  requiredBy: []
  timestamp: '2026-10-06 00:15:45+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/SWAG_newswagwith_test.nim
layout: document
redirect_from:
- /verify/verify/AI/SWAG_newswagwith_test.nim
- /verify/verify/AI/SWAG_newswagwith_test.nim.html
title: verify/AI/SWAG_newswagwith_test.nim
---
