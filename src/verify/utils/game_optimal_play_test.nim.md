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
    doAssert optimal_play(4, subtract).states == @[4, 3, 2, 0]\ndoAssert optimal_play(3,\
    \ subtract).states == @[3, 2, 0]\ndoAssert optimal_play(4, subtract, true).states\
    \ == @[4, 3, 1, 0]\n\nfor misere in [false, true]:\n    doAssert optimal_play(0,\
    \ subtract, misere).states == @[0]\n    for initial in 0..30:\n        let (is_win,\
    \ path) = optimal_play(initial, subtract, misere)\n        doAssert is_win ==\
    \ (initial mod 3 != ord(misere))\n        doAssert path[0] == initial\n      \
    \  doAssert path[^1] == 0\n        for i in 0..<path.len - 1:\n            doAssert\
    \ path[i + 1] in subtract(path[i])\n            let winning = path[i] mod 3 !=\
    \ ord(misere)\n            if winning:\n                doAssert path[i + 1] mod\
    \ 3 == ord(misere)\n            else:\n                doAssert path[i + 1] ==\
    \ path[i] - 1\n        doAssert (initial mod 3 != ord(misere)) ==\n          \
    \  ((path.len mod 2 == 0) xor misere)\n\nproc subtract_by_turn(state: int, is_first:\
    \ bool): seq[int] =\n    let max_take = (if is_first: 1 else: 2)\n    for take\
    \ in 1..max_take:\n        if take <= state:\n            result.add(state - take)\n\
    \nfor misere in [false, true]:\n    var winning: array[31, array[bool, bool]]\n\
    \    var turns: array[31, array[bool, int]]\n    for is_first in [false, true]:\n\
    \        winning[0][is_first] = misere\n    for state in 1..30:\n        for is_first\
    \ in [false, true]:\n            for next_state in subtract_by_turn(state, is_first):\n\
    \                if not winning[next_state][not is_first]:\n                 \
    \   winning[state][is_first] = true\n            var shortest = high(int)\n  \
    \          var longest = 0\n            for next_state in subtract_by_turn(state,\
    \ is_first):\n                if not winning[next_state][not is_first]:\n    \
    \                shortest = min(shortest, turns[next_state][not is_first] + 1)\n\
    \                longest = max(longest, turns[next_state][not is_first] + 1)\n\
    \            turns[state][is_first] =\n                (if winning[state][is_first]:\
    \ shortest else: longest)\n    for initial in 0..30:\n        let (is_win, path)\
    \ = optimal_play(initial, subtract_by_turn, misere)\n        doAssert is_win ==\
    \ winning[initial][true]\n        doAssert path[0] == initial\n        doAssert\
    \ path[^1] == 0\n        doAssert path.len - 1 == turns[initial][true]\n     \
    \   for i in 0..<path.len - 1:\n            let is_first = i mod 2 == 0\n    \
    \        let moves = subtract_by_turn(path[i], is_first)\n            var expected\
    \ = moves[0]\n            for next_state in moves:\n                if winning[next_state][not\
    \ is_first] != winning[path[i]][is_first] and\n                        turns[next_state][not\
    \ is_first] + 1 == turns[path[i]][is_first]:\n                    expected = next_state\n\
    \                    break\n            doAssert path[i + 1] == expected\n   \
    \     doAssert winning[initial][true] ==\n            ((path.len mod 2 == 0) xor\
    \ misere)\n\nproc pass_first(state: int, is_first: bool): seq[int] =\n    if state\
    \ > 0:\n        result.add(if is_first: state else: state - 1)\n\ndoAssert optimal_play(2,\
    \ pass_first).states == @[2, 2, 1, 1, 0]\n\nproc branching(state: int): seq[int]\
    \ =\n    case state\n    of 0: @[]\n    of 1: @[0]\n    of 2: @[1]\n    of 3:\
    \ @[2]\n    of 4: @[2, 0]\n    of 5: @[1, 3]\n    of 6: @[0, 2]\n    of 7: @[3,\
    \ 1]\n    of 8: @[2, 5]\n    of 9: @[4, 3]\n    else: @[]\n\ndoAssert optimal_play(4,\
    \ branching).states == @[4, 0]\ndoAssert optimal_play(5, branching).states ==\
    \ @[5, 3, 2, 1, 0]\ndoAssert optimal_play(6, branching).states == @[6, 0]\ndoAssert\
    \ optimal_play(7, branching).states == @[7, 3, 2, 1, 0]\ndoAssert optimal_play(8,\
    \ branching).states == @[8, 2, 1, 0]\ndoAssert optimal_play(9, branching).states\
    \ == @[9, 3, 2, 1, 0]\ndoAssert optimal_play(4, branching, true).states == @[4,\
    \ 2, 1, 0]\ndoAssert optimal_play(5, branching, true).states == @[5, 1, 0]\ndoAssert\
    \ optimal_play(6, branching, true).states == @[6, 2, 1, 0]\ndoAssert optimal_play(7,\
    \ branching, true).states == @[7, 1, 0]\n\nproc branching_by_turn(state: int,\
    \ is_first: bool): seq[int] =\n    branching(state)\n\nfor misere in [false, true]:\n\
    \    for initial in 0..9:\n        doAssert optimal_play(initial, branching_by_turn,\
    \ misere) ==\n            optimal_play(initial, branching, misere)\n\nproc erase_suffix(state:\
    \ string): seq[string] =\n    if state.len > 0:\n        result.add(state[0..^2])\n\
    \ndoAssert optimal_play(\"abc\", erase_suffix).states == @[\"abc\", \"ab\", \"\
    a\", \"\"]\ndoAssert optimal_play[int](1, proc(state: int): seq[int] =\n    if\
    \ state > 0: @[0] else: @[]).states == @[1, 0]\ndoAssert optimal_play[int](1,\
    \ proc(state: int, is_first: bool): seq[int] =\n    if state > 0: @[0] else: @[]).states\
    \ == @[1, 0]\n\nproc cyclic(state: int): seq[int] = @[state]\nproc cyclic_by_turn(state:\
    \ int, is_first: bool): seq[int] = @[state]\n\nfor by_turn in [false, true]:\n\
    \    var caught = false\n    try:\n        if by_turn:\n            discard optimal_play(0,\
    \ cyclic_by_turn)\n        else:\n            discard optimal_play(0, cyclic)\n\
    \    except ValueError:\n        caught = true\n    doAssert caught\n\nfor misere\
    \ in [false, true]:\n    block:\n        var calls: array[31, int]\n        proc\
    \ counted(state: int): seq[int] =\n            inc calls[state]\n            subtract(state)\n\
    \        let solve = init_optimal_play(counted, misere)\n        doAssert solve(30)\
    \ == optimal_play(30, subtract, misere)\n        for initial in 0..30:\n     \
    \       doAssert calls[initial] == 1\n            doAssert solve(initial) == optimal_play(initial,\
    \ subtract, misere)\n            doAssert calls[initial] == 1\n        var play\
    \ = solve(4)\n        play.states[0] = -1\n        doAssert solve(4).states[0]\
    \ == 4\n        let independent = init_optimal_play(counted, not misere)\n   \
    \     doAssert independent(30) == optimal_play(30, subtract, not misere)\n   \
    \     for count in calls:\n            doAssert count == 2\n    block:\n     \
    \   var calls: array[31, array[bool, int]]\n        proc counted(state: int, is_first:\
    \ bool): seq[int] =\n            inc calls[state][is_first]\n            subtract_by_turn(state,\
    \ is_first)\n        let solve = init_optimal_play(counted, misere)\n        for\
    \ initial in 0..30:\n            doAssert solve(initial) == optimal_play(initial,\
    \ subtract_by_turn, misere)\n        let previous_calls = calls\n        for initial\
    \ in 0..30:\n            doAssert solve(initial) == optimal_play(initial, subtract_by_turn,\
    \ misere)\n        doAssert calls == previous_calls\n        for counts in calls:\n\
    \            for count in counts:\n                doAssert count <= 1\n\nlet\
    \ string_solver = init_optimal_play(erase_suffix)\ndoAssert string_solver(\"abc\"\
    ) == (is_win: true, states: @[\"abc\", \"ab\", \"a\", \"\"])\ndoAssert string_solver(\"\
    \") == (is_win: false, states: @[\"\"])\nlet pass_solver = init_optimal_play(pass_first)\n\
    for initial in 0..5:\n    doAssert pass_solver(initial) == optimal_play(initial,\
    \ pass_first)\n\nblock:\n    let solve = init_optimal_play[int](proc(state: int):\
    \ seq[int] =\n        if state > 0: @[0] else: @[])\n    doAssert solve(1) ==\
    \ (is_win: true, states: @[1, 0])\n    let solve_by_turn = init_optimal_play[int](proc(state:\
    \ int, is_first: bool): seq[int] =\n        if state > 0: @[0] else: @[])\n  \
    \  doAssert solve_by_turn(1) == solve(1)\n\nproc make_solver(nxt: NextStates[int]):\
    \ proc(state: int): tuple[is_win: bool, states: seq[int]] {.closure.} =\n    init_optimal_play(nxt)\n\
    \ndoAssert make_solver(subtract)(4) == optimal_play(4, subtract)\nlet stored:\
    \ NextStatesByTurn[int] = subtract_by_turn\nlet stored_solver = init_optimal_play(stored)\n\
    doAssert stored_solver(4) == optimal_play(4, subtract_by_turn)\n\nblock:\n   \
    \ let solve = init_optimal_play(cyclic)\n    let solve_by_turn = init_optimal_play(cyclic_by_turn)\n\
    \    for attempt in 0..1:\n        for f in [solve, solve_by_turn]:\n        \
    \    var caught = false\n            try:\n                discard f(0)\n    \
    \        except ValueError:\n                caught = true\n            doAssert\
    \ caught\n\nblock:\n    var calls = 0\n    proc failing(state: int): seq[int]\
    \ =\n        inc calls\n        raise newException(ValueError, \"test\")\n   \
    \ proc failing_by_turn(state: int, is_first: bool): seq[int] =\n        failing(state)\n\
    \    let solve = init_optimal_play(failing)\n    let solve_by_turn = init_optimal_play(failing_by_turn)\n\
    \    for attempt in 0..1:\n        for f in [solve, solve_by_turn]:\n        \
    \    var caught = false\n            try:\n                discard f(0)\n    \
    \        except ValueError as e:\n                caught = true\n            \
    \    doAssert e.msg == \"test\"\n            doAssert caught\n    doAssert calls\
    \ == 4\n\nproc tied(state: int): seq[int] =\n    case state\n    of 2: @[0, 1]\n\
    \    of 3: @[0]\n    of 4: @[2, 3]\n    else: @[]\n\nproc tied_by_turn(state:\
    \ int, is_first: bool): seq[int] =\n    tied(state)\n\nproc score(state: int):\
    \ int = state\nproc constant_score(state: int): int = -10\n\nfor misere in [false,\
    \ true]:\n    doAssert optimal_play(2, tied, evaluate = score, win_when_no_moves\
    \ = misere) ==\n        (is_win: not misere, states: @[2, 1])\n    doAssert optimal_play(4,\
    \ tied, evaluate = score, win_when_no_moves = misere) ==\n        (is_win: misere,\
    \ states: @[4, 3, 0])\n    let solve = init_optimal_play(tied, evaluate = score,\
    \ win_when_no_moves = misere)\n    let solve_by_turn = init_optimal_play(tied_by_turn,\
    \ evaluate = score, win_when_no_moves = misere)\n    for initial in 0..4:\n  \
    \      doAssert solve(initial) == optimal_play(initial, tied, score, misere)\n\
    \        doAssert solve_by_turn(initial) == solve(initial)\n        doAssert optimal_play(initial,\
    \ tied_by_turn, score, misere) == solve(initial)\n        doAssert optimal_play(initial,\
    \ tied, constant_score, misere) ==\n            optimal_play(initial, tied, misere)\n\
    \    for initial in 0..9:\n        let original = optimal_play(initial, branching,\
    \ misere)\n        let evaluated = optimal_play(initial, branching, score, misere)\n\
    \        doAssert evaluated.is_win == original.is_win\n        doAssert evaluated.states.len\
    \ == original.states.len\n\ndoAssert optimal_play(4, branching, score).states\
    \ == @[4, 0]\ndoAssert optimal_play(5, branching, proc(state: int): int = -state).states\
    \ ==\n    @[5, 3, 2, 1, 0]\ndoAssert optimal_play(8, branching, score).states\
    \ == @[8, 2, 1, 0]\n\nblock:\n    var calls = 0\n    let solve = init_optimal_play(tied,\
    \ evaluate = proc(state: int): float =\n        inc calls\n        -float(state)\n\
    \    )\n    doAssert solve(4) == (is_win: false, states: @[4, 2, 0])\n    doAssert\
    \ calls > 0\n    let previous_calls = calls\n    for initial in 0..4:\n      \
    \  discard solve(initial)\n    doAssert calls == previous_calls\n\nblock:\n  \
    \  let solve = init_optimal_play(tied_by_turn, evaluate = proc(state: int): int64\
    \ =\n        -int64(state)\n    )\n    doAssert solve(4).states == @[4, 2, 0]\n\
    \    let solve_pair = init_optimal_play(tied, evaluate = proc(state: int): tuple[a,\
    \ b: int] =\n        (0, state)\n    )\n    doAssert solve_pair(4).states == @[4,\
    \ 3, 0]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/game.nim
  - cplib/utils/game.nim
  isVerificationFile: true
  path: verify/utils/game_optimal_play_test.nim
  requiredBy: []
  timestamp: '2026-09-11 03:00:31+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/game_optimal_play_test.nim
layout: document
redirect_from:
- /verify/verify/utils/game_optimal_play_test.nim
- /verify/verify/utils/game_optimal_play_test.nim.html
title: verify/utils/game_optimal_play_test.nim
---
