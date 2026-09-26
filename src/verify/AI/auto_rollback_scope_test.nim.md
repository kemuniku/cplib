---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
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
    import random\nimport cplib/utils/auto_rollback\nimport cplib/collections/unionfind\n\
    \nblock:\n    var values = @[2, 4, 6]\n    proc update(idx: int, value: int =\
    \ 1): int {.discardable.} =\n        values[idx] += value\n        values[idx]\n\
    \    withAutoRollback(update):\n        let initial = snapshot()\n        doAssert\
    \ update(idx = 0) == 3\n        let saved = snapshot()\n        update(1, 10)\n\
    \        rollback(saved)\n        doAssert values == @[3, 4, 6]\n        rollback(saved)\n\
    \        withAutoRollback(update):\n            update(0, 5)\n            doAssert\
    \ values[0] == 8\n        doAssert values[0] == 3\n        Temporary:\n      \
    \      update(0, 7)\n            doAssert values[0] == 10\n        doAssert values[0]\
    \ == 3\n        rollback(initial)\n        doAssert values == @[2, 4, 6]\n   \
    \     update(2, 3)\n    doAssert values == @[2, 4, 6]\n    update(0, 5)\n    doAssert\
    \ values == @[7, 4, 6]\n\nblock:\n    var rng = initRand(47328)\n    var values:\
    \ array[8, int]\n    proc update(idx, amount: int) = values[idx] += amount\n \
    \   for repeat in 0..<30:\n        withAutoRollback(update):\n            var\
    \ expected: array[8, int]\n            var states: seq[(int, array[8, int])]\n\
    \            for step in 0..<100:\n                case rng.rand(3)\n        \
    \        of 0:\n                    states.add((snapshot(), expected))\n     \
    \           of 1:\n                    if states.len > 0:\n                  \
    \      let position = rng.rand(states.high)\n                        rollback(states[position][0])\n\
    \                        expected = states[position][1]\n                    \
    \    states.setLen(position + 1)\n                else:\n                    let\
    \ idx = rng.rand(values.high)\n                    let amount = rng.rand(-5..5)\n\
    \                    update(idx, amount)\n                    expected[idx] +=\
    \ amount\n                doAssert values == expected\n        for value in values:\
    \ doAssert value == 0\n\nblock:\n    var values = @[0, 0]\n    proc helper(idx:\
    \ int) = values[idx] += 2\n    Temporary:\n        values[0] = 3\n        helper(1)\n\
    \        var local = 7\n        Temporary:\n            local = 9\n          \
    \  values[0] += 5\n            helper(1)\n            doAssert local == 9 and\
    \ values[0] == 8 and values[1] == 4\n        doAssert local == 7 and values[0]\
    \ == 3 and values[1] == 2\n        for i in 0..<2:\n            Temporary:\n \
    \               helper(i)\n            doAssert values[0] == 3 and values[1] ==\
    \ 2\n    doAssert values == @[0, 0]\n\nblock:\n    var uf = initUnionFind(5)\n\
    \    withAutoRollback(unite):\n        let initial = snapshot()\n        uf.unite(0,\
    \ 1)\n        doAssert uf.count == 4\n        let saved = snapshot()\n       \
    \ uf.unite(1, 2)\n        uf.unite(0, 2)\n        doAssert uf.count == 3\n   \
    \     rollback(saved)\n        doAssert uf.count == 4\n        rollback(initial)\n\
    \        doAssert uf.count == 5\n    Temporary:\n        uf.unite(0, 1)\n    \
    \    uf.unite(2, 3)\n        uf.unite(1, 3)\n        doAssert uf.issame(0, 2)\n\
    \        doAssert uf.count == 2\n    doAssert uf.count == 5\n    for i in 0..<5:\
    \ doAssert uf.siz(i) == 1\n\nblock:\n    var state = 7\n    proc update() = inc\
    \ state\n    let failure = newException(ValueError, \"test\")\n    try:\n    \
    \    withAutoRollback(update):\n            update()\n            raise failure\n\
    \    except ValueError:\n        doAssert state == 7\n    try:\n        Temporary:\n\
    \            update()\n            raise failure\n    except ValueError:\n   \
    \     doAssert state == 7\n    try:\n        Temporary:\n            state = 100\n\
    \            doAssert state == 0\n    except AssertionDefect:\n        doAssert\
    \ state == 7\n    for position in [-1, 100]:\n        try:\n            withAutoRollback(update):\n\
    \                update()\n                rollback(position)\n            doAssert\
    \ false\n        except ValueError:\n            doAssert state == 7\n\nblock:\n\
    \    var state = 0\n    proc returning(): int =\n        Temporary:\n        \
    \    state = 5\n            return state\n    proc returningResult(): int =\n\
    \        result = 2\n        Temporary:\n            result = 9\n            state\
    \ = 10\n            return result\n    doAssert returning() == 5 and state ==\
    \ 0\n    doAssert returningResult() == 9 and state == 0\n    proc update() = state\
    \ += 5\n    proc returningScope(): int =\n        withAutoRollback(update):\n\
    \            update()\n            return state\n    doAssert returningScope()\
    \ == 5 and state == 0\n    var iterations = 0\n    for i in 0..<5:\n        inc\
    \ iterations\n        Temporary:\n            state = 7\n            if i == 0:\
    \ continue\n            break\n    doAssert iterations == 2 and state == 0\n \
    \   iterations = 0\n    for i in 0..<5:\n        inc iterations\n        withAutoRollback(update):\n\
    \            update()\n            if i == 0: continue\n            break\n  \
    \  doAssert iterations == 2 and state == 0\n\nstatic:\n    doAssert not compiles(block:\n\
    \        var values: seq[int]\n        Temporary:\n            values.add(1)\n\
    \    )\n    doAssert not compiles(block:\n        var values: seq[int]\n     \
    \   proc update() = values.add(1)\n        withAutoRollback(update):\n       \
    \     update()\n    )\n    doAssert not compiles(block:\n        var value = 0\n\
    \        proc update() = inc value\n        withAutoRollback(update):\n      \
    \      update()\n        discard snapshot()\n    )\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/auto_rollback.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/AI/auto_rollback_scope_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/auto_rollback_scope_test.nim
layout: document
redirect_from:
- /verify/verify/AI/auto_rollback_scope_test.nim
- /verify/verify/AI/auto_rollback_scope_test.nim.html
title: verify/AI/auto_rollback_scope_test.nim
---
