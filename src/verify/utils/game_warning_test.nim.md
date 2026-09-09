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
    import cplib/utils/game\n\nvar global_moves = 1\nlet fixed_moves = 1\n\nproc direct(state:\
    \ int): seq[int] =\n    if state >= global_moves:\n        result.add(state -\
    \ global_moves)\n\nproc indirect(state: int): seq[int] =\n    direct(state)\n\n\
    proc local_only(state: int): seq[int] =\n    var step = fixed_moves\n    var (a,\
    \ b) = (step, 0)\n    proc unused(state: int): seq[int] =\n        direct(state)\n\
    \    step = a + b\n    if state >= step:\n        result.add(state - step)\n\n\
    let direct_solver = init_can_win(direct)\ndoAssert direct_solver(1)\nlet indirect_solver\
    \ = init_can_win(indirect)\ndoAssert indirect_solver(1)\nlet local_solver = init_can_win[int](local_only)\n\
    doAssert local_solver(1)\n\nblock:\n    var captured_moves = 1\n    proc by_turn(state:\
    \ int, is_first: bool): seq[int] =\n        if state >= captured_moves:\n    \
    \        result.add(state - captured_moves)\n    let solve = init_can_win(by_turn)\n\
    \    doAssert solve(1)\n\nblock:\n    var lambda_moves = 1\n    let solve = init_can_win(proc(state:\
    \ int): seq[int] =\n        var step = lambda_moves\n        if state >= step:\n\
    \            result.add(state - step)\n    )\n    doAssert solve(1)\n\nblock:\n\
    \    var turn_lambda_moves = 1\n    let solve = init_can_win(proc(state: int,\
    \ is_first: bool): seq[int] =\n        if state >= turn_lambda_moves:\n      \
    \      result.add(state - turn_lambda_moves)\n    )\n    doAssert solve(1)\n\n\
    proc make_solver(nxt: NextStates[int]): proc(state: int): bool {.closure.} =\n\
    \    init_can_win(nxt)\n\ndoAssert make_solver(direct)(1)\nlet stored: NextStates[int]\
    \ = direct\nlet stored_solver = init_can_win(stored)\ndoAssert stored_solver(1)\n\
    doAssert can_win(1, direct)\n\nproc make_captured_solver(step: int): proc(state:\
    \ int): bool {.closure.} =\n    var captured_step = step\n    init_can_win(proc(state:\
    \ int): seq[int] =\n        if state >= captured_step:\n            result.add(state\
    \ - captured_step)\n    )\n\nlet captured_one = make_captured_solver(1)\nlet captured_two\
    \ = make_captured_solver(2)\ndoAssert captured_one(1)\ndoAssert not captured_two(1)\n\
    doAssert not captured_one(2)\ndoAssert captured_two(2)\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/utils/game.nim
  - cplib/utils/game.nim
  isVerificationFile: true
  path: verify/utils/game_warning_test.nim
  requiredBy: []
  timestamp: '2026-09-09 16:56:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/game_warning_test.nim
layout: document
redirect_from:
- /verify/verify/utils/game_warning_test.nim
- /verify/verify/utils/game_warning_test.nim.html
title: verify/utils/game_warning_test.nim
---
