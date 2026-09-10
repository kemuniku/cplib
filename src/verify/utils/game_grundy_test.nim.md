---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/game.nim
    title: cplib/utils/game.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/game.nim
    title: cplib/utils/game.nim
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
    import cplib/utils/game\n\nproc subtract(state: int): seq[int] =\n    for take\
    \ in 1..2:\n        if take <= state:\n            result.add(state - take)\n\n\
    let solve = init_grundy(subtract)\nfor state in 0..40:\n    doAssert solve(state)\
    \ == state mod 3\n    doAssert grundy(state, subtract) == state mod 3\n    doAssert\
    \ (solve(state) != 0) == can_win(state, subtract)\n\nproc nim_heap(state: int):\
    \ seq[int] =\n    for next_state in 0..<state:\n        result.add(next_state)\n\
    \nlet heap_solver = init_grundy(nim_heap)\nfor state in 0..30:\n    doAssert heap_solver(state)\
    \ == state\n\nproc two_heaps(state: tuple[a, b: int]): seq[tuple[a, b: int]] =\n\
    \    for a in 0..<state.a:\n        result.add((a, state.b))\n    for b in 0..<state.b:\n\
    \        result.add((state.a, b))\n\nlet pair_solver = init_grundy(two_heaps)\n\
    for a in 0..10:\n    for b in 0..10:\n        doAssert pair_solver((a, b)) ==\
    \ (a xor b)\n\nproc sparse(state: int): seq[int] =\n    case state\n    of 10:\
    \ @[5]\n    of 11: @[0, 0, 5]\n    of 12: @[0, 1, 5]\n    else: nim_heap(state)\n\
    \ndoAssert grundy(10, sparse) == 0\ndoAssert grundy(11, sparse) == 1\ndoAssert\
    \ grundy(12, sparse) == 2\n\nproc erase_suffix(state: string): seq[string] =\n\
    \    if state.len > 0:\n        result.add(state[0..^2])\n\nlet string_solver\
    \ = init_grundy(erase_suffix)\ndoAssert string_solver(\"\") == 0\ndoAssert string_solver(\"\
    abc\") == 1\ndoAssert grundy(\"abcd\", erase_suffix) == 0\n\nblock:\n    var calls:\
    \ array[41, int]\n    proc counted(state: int): seq[int] =\n        inc calls[state]\n\
    \        subtract(state)\n    let cached = init_grundy(counted)\n    doAssert\
    \ cached(40) == 1\n    for state in 0..40:\n        doAssert cached(state) ==\
    \ state mod 3\n        doAssert calls[state] == 1\n    let independent = init_grundy(counted)\n\
    \    doAssert independent(40) == 1\n    for count in calls:\n        doAssert\
    \ count == 2\n\nblock:\n    let lambda_solver = init_grundy[int](proc(state: int):\
    \ seq[int] =\n        if state > 0: @[state - 1] else: @[])\n    doAssert lambda_solver(4)\
    \ == 0\n    doAssert lambda_solver(5) == 1\n\nproc make_solver(nxt: NextStates[int]):\
    \ proc(state: int): int {.closure.} =\n    init_grundy(nxt)\n\ndoAssert make_solver(subtract)(2)\
    \ == 2\nlet stored: NextStates[int] = subtract\nlet stored_solver = init_grundy(stored)\n\
    doAssert stored_solver(3) == 0\n\nproc cyclic(state: int): seq[int] = @[state]\n\
    proc two_cycle(state: int): seq[int] = @[1 - state]\n\nfor nxt in [cyclic, two_cycle]:\n\
    \    let cached = init_grundy(nxt)\n    for attempt in 0..1:\n        var caught\
    \ = false\n        try:\n            discard cached(0)\n        except ValueError:\n\
    \            caught = true\n        doAssert caught\n    var caught = false\n\
    \    try:\n        discard grundy(0, nxt)\n    except ValueError:\n        caught\
    \ = true\n    doAssert caught\n\nblock:\n    var calls = 0\n    proc failing(state:\
    \ int): seq[int] =\n        inc calls\n        raise newException(ValueError,\
    \ \"test\")\n    let cached = init_grundy(failing)\n    for attempt in 0..1:\n\
    \        var caught = false\n        try:\n            discard cached(0)\n   \
    \     except ValueError as e:\n            caught = true\n            doAssert\
    \ e.msg == \"test\"\n        doAssert caught\n    doAssert calls == 2\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/utils/game.nim
  - cplib/utils/game.nim
  isVerificationFile: true
  path: verify/utils/game_grundy_test.nim
  requiredBy: []
  timestamp: '2026-09-11 03:00:31+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/game_grundy_test.nim
layout: document
redirect_from:
- /verify/verify/utils/game_grundy_test.nim
- /verify/verify/utils/game_grundy_test.nim.html
title: verify/utils/game_grundy_test.nim
---
