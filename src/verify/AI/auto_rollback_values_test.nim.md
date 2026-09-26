---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree_static_op.nim
    title: cplib/collections/lazysegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
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
    import random, math\nimport cplib/utils/auto_rollback\nimport cplib/collections/lazysegtree_static_op\n\
    \nblock:\n    var state = 1\n    let answer = Temporary:\n        state = 10\n\
    \        let inner = Temporary:\n            state = 30\n            state + 2\n\
    \        doAssert state == 10 and inner == 32\n        var local = 4\n       \
    \ let captured = Temporary:\n            local = 12\n            (local, [state,\
    \ inner])\n        doAssert local == 4 and captured[0] == 12\n        (state,\
    \ captured[1])\n    doAssert state == 1 and answer == (10, [10, 32])\n    let\
    \ saved = Temporary:\n        state = 8\n        state\n    doAssert saved ==\
    \ 8 and state == 1\n    let calculated = Temporary:\n        var (x, y) = (3,\
    \ 5)\n        x *= y\n        x ^ 4\n    doAssert calculated == 50625\n\nblock:\n\
    \    var state: tuple[first: array[3, int], second: int]\n    state = ([1, 2,\
    \ 3], 4)\n    proc change(value: var int) =\n        value *= 3\n        inc state.second\n\
    \    proc indirect(value: var int) = change(value)\n    proc applyValues(): (array[3,\
    \ int], int) =\n        var local = 5\n        indirect(local)\n        indirect(state.first[0])\n\
    \        result = (state.first, local)\n        result[0][1] = 100\n    let value\
    \ = Temporary:\n        let before = state\n        let changed = applyValues()\n\
    \        doAssert changed[0][0] == 3 and changed[1] == 15\n        doAssert state.second\
    \ == 6\n        state = ([7, 8, 9], 10)\n        swap(state.first, state.first)\n\
    \        before\n    doAssert value == ([1, 2, 3], 4) and state == value\n   \
    \ withAutoRollback(applyValues):\n        let saved = snapshot()\n        discard\
    \ applyValues()\n        doAssert state.first[0] == 3 and state.second == 6\n\
    \        rollback(saved)\n        doAssert state == value\n\ntype S = (array[32,\
    \ int32], int32)\ntype F = (int, int)\nproc op(a, b: S): S =\n    for i in 0..<32:\
    \ result[0][i] = a[0][i] + b[0][i]\n    result[1] = a[1] + b[1]\nproc mapping(f:\
    \ F, value: S): S =\n    result = value\n    for i in 0..<32:\n        if (f[0]\
    \ and (1 shl i)) == 0: result[0][i] = 0\n        if (f[1] and (1 shl i)) != 0:\
    \ result[0][i] = value[1]\nproc composition(f, g: F): F =\n    (f[0] and g[0],\
    \ (g[1] and f[0]) or f[1])\nproc fromInt(value: int): S =\n    result[1] = 1\n\
    \    for i in 0..<32:\n        result[0][i] = int32((value shr i) and 1)\nproc\
    \ toInt(value: S): int =\n    for i in 0..<32: result += int(value[0][i]) * (1\
    \ shl i)\n\nblock:\n    var rng = initRand(91453)\n    var initial: array[17,\
    \ int]\n    var nodes: seq[S]\n    for i in 0..<initial.len:\n        initial[i]\
    \ = rng.rand(255)\n        nodes.add(fromInt(initial[i]))\n    var st = initLazySegmentTree(nodes,\
    \ op, default(S), mapping, composition, (255, 0))\n    st.apply(0..<17, (255,\
    \ 8))\n    for i in 0..<initial.len: initial[i] = initial[i] or 8\n    let originalArr\
    \ = st.arr\n    let originalLazy = st.lazy\n    for repeat in 0..<40:\n      \
    \  var operations: array[30, (int, int, int, int, int, int)]\n        for i in\
    \ 0..<operations.len:\n            let l = rng.rand(17)\n            let r = rng.rand(l..17)\n\
    \            let ql = rng.rand(17)\n            let qr = rng.rand(ql..17)\n  \
    \          operations[i] = (l, r, rng.rand(255), rng.rand(255), ql, qr)\n    \
    \    let answer = Temporary:\n            var expected = initial\n           \
    \ var total = 0\n            for i in 0..<operations.len:\n                let\
    \ (l, r, mask, bits, ql, qr) = operations[i]\n                st.apply(l..<r,\
    \ (mask, bits))\n                for j in l..<r: expected[j] = (expected[j] and\
    \ mask) or bits\n                var sum = 0\n                for j in ql..<qr:\
    \ sum += expected[j]\n                let actual = toInt(st[ql..<qr])\n      \
    \          doAssert actual == sum\n                total += actual\n         \
    \       let inner = Temporary:\n                    st.apply(0..<17, (0, 3))\n\
    \                    toInt(st[0..<17])\n                doAssert inner == 51\n\
    \                doAssert toInt(st[ql..<qr]) == sum\n            total\n     \
    \   doAssert answer >= 0\n        doAssert st.arr == originalArr and st.lazy ==\
    \ originalLazy\n        Temporary:\n            for i in 0..<17: doAssert toInt(st[i..<i\
    \ + 1]) == initial[i]\n        doAssert st.arr == originalArr and st.lazy == originalLazy\n\
    \nstatic:\n    doAssert not compiles(block:\n        var state = @[1]\n      \
    \  let answer = Temporary:\n            state[0] = 3\n            state\n    )\n\
    \    doAssert not compiles(block:\n        var value = (1, @[2])\n        Temporary:\n\
    \            value = (2, @[3])\n    )\n    doAssert not compiles(block:\n    \
    \    type Box = ref object\n            value: int\n        proc update(box: Box)\
    \ = inc box.value\n        Temporary:\n            update(Box(value: 1))\n   \
    \ )\n    doAssert not compiles(block:\n        var state = 0\n        proc update()\
    \ = inc state\n        proc choose(): proc() = update\n        Temporary:\n  \
    \          (update, choose())[0]()\n    )\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/lazysegtree_static_op.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/lazysegtree_static_op.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/auto_rollback.nim
  isVerificationFile: true
  path: verify/AI/auto_rollback_values_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:43:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/auto_rollback_values_test.nim
layout: document
redirect_from:
- /verify/verify/AI/auto_rollback_values_test.nim
- /verify/verify/AI/auto_rollback_values_test.nim.html
title: verify/AI/auto_rollback_values_test.nim
---
