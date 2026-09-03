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
    for state in 0..20:\n    doAssert can_win(state, subtract) == (state mod 3 !=\
    \ 0)\n    doAssert can_win(state, subtract, win_when_no_moves = true) ==\n   \
    \     (state mod 3 != 1)\n\nproc erase_suffix(state: string): seq[string] =\n\
    \    if state.len > 0:\n        result.add(state[0..^2])\n\ndoAssert can_win(\"\
    abc\", erase_suffix)\ndoAssert not can_win(\"abcd\", erase_suffix)\n\nproc subtract_by_turn(state:\
    \ int, is_first: bool): seq[int] =\n    let max_take = (if is_first: 1 else: 2)\n\
    \    for take in 1..max_take:\n        if take <= state:\n            result.add(state\
    \ - take)\n\ndoAssert can_win(1, subtract_by_turn)\ndoAssert not can_win(2, subtract_by_turn)\n\
    doAssert not can_win(3, subtract_by_turn)\ndoAssert can_win(0, subtract_by_turn,\
    \ win_when_no_moves = true)\n\nproc cyclic(state: int): seq[int] = @[state]\n\n\
    block:\n    var caught = false\n    try:\n        discard can_win(0, cyclic)\n\
    \    except ValueError:\n        caught = true\n    doAssert caught\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/utils/game.nim
  - cplib/utils/game.nim
  isVerificationFile: true
  path: verify/utils/game_test.nim
  requiredBy: []
  timestamp: '2026-07-27 08:09:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/game_test.nim
layout: document
redirect_from:
- /verify/verify/utils/game_test.nim
- /verify/verify/utils/game_test.nim.html
title: verify/utils/game_test.nim
---
