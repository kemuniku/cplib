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
    import cplib/utils/game\n\ntype\n    Board = array[4, int]\n    State = tuple[board:\
    \ Board, is_first: bool]\n\nproc score(board: Board): int =\n    for i, mark in\
    \ board:\n        result += mark * (1 shl i)\n\nproc place(board: Board, is_first:\
    \ bool): seq[Board] =\n    for i in 0..<board.len:\n        if board[i] == 0:\n\
    \            var next_board = board\n            next_board[i] = (if is_first:\
    \ 1 else: -1)\n            result.add(next_board)\n\nproc judge(board: Board,\
    \ is_first: bool): bool =\n    doAssert 0 notin board\n    (score(board) > 0)\
    \ == is_first\n\nproc place_state(state: State): seq[State] =\n    for board in\
    \ place(state.board, state.is_first):\n        result.add((board, not state.is_first))\n\
    \nproc judge_state(state: State): bool =\n    judge(state.board, state.is_first)\n\
    \nproc score_state(state: State): int = score(state.board)\n\nproc minimax(board:\
    \ Board, is_first: bool): int =\n    if 0 notin board:\n        return score(board)\n\
    \    result = (if is_first: low(int) else: high(int))\n    for i in 0..<board.len:\n\
    \        if board[i] == 0:\n            var next_board = board\n            next_board[i]\
    \ = (if is_first: 1 else: -1)\n            let value = minimax(next_board, not\
    \ is_first)\n            result = (if is_first: max(result, value) else: min(result,\
    \ value))\n\nproc check_play(initial: State, play: tuple[is_win: bool, states:\
    \ seq[State]]) =\n    doAssert play.is_win == ((minimax(initial.board, initial.is_first)\
    \ > 0) == initial.is_first)\n    doAssert play.states[0] == initial\n    var empty\
    \ = 0\n    for mark in initial.board:\n        if mark == 0: inc empty\n    doAssert\
    \ play.states.len == empty + 1\n    for i in 0..<play.states.len - 1:\n      \
    \  let current = play.states[i]\n        let child = play.states[i + 1]\n    \
    \    doAssert child in place_state(current)\n        doAssert (minimax(current.board,\
    \ current.is_first) > 0) ==\n            (minimax(child.board, child.is_first)\
    \ > 0)\n    doAssert 0 notin play.states[^1].board\n    doAssert play.is_win ==\
    \ ((score(play.states[^1].board) > 0) == initial.is_first)\n\nlet win = init_can_win(place,\
    \ terminal_win = judge)\nlet win_state = init_can_win(place_state, terminal_win\
    \ = judge_state)\nlet play = init_optimal_play(place, terminal_win = judge)\n\
    let play_state = init_optimal_play(place_state, terminal_win = judge_state)\n\
    let evaluated = init_optimal_play(place, evaluate = score, terminal_win = judge)\n\
    let evaluated_state = init_optimal_play(place_state, evaluate = score_state, terminal_win\
    \ = judge_state)\n\nfor code in 0..<81:\n    var board: Board\n    var rest =\
    \ code\n    for i in 0..<board.len:\n        board[i] = rest mod 3 - 1\n     \
    \   rest = rest div 3\n    let expected = minimax(board, true) > 0\n    doAssert\
    \ win(board) == expected\n    doAssert can_win(board, place, terminal_win = judge)\
    \ == expected\n    for is_first in [false, true]:\n        let state: State =\
    \ (board, is_first)\n        let expected_state = (minimax(board, is_first) >\
    \ 0) == is_first\n        doAssert win_state(state) == expected_state\n      \
    \  doAssert can_win(state, place_state, terminal_win = judge_state) == expected_state\n\
    \        let plain = play_state(state)\n        let ranked = evaluated_state(state)\n\
    \        check_play(state, plain)\n        check_play(state, ranked)\n       \
    \ doAssert optimal_play(state, place_state, terminal_win = judge_state) == plain\n\
    \        doAssert optimal_play(state, place_state, evaluate = score_state, terminal_win\
    \ = judge_state) == ranked\n        if is_first:\n            for pair in [(play(board),\
    \ plain), (evaluated(board), ranked)]:\n                doAssert pair[0].is_win\
    \ == pair[1].is_win\n                doAssert pair[0].states.len == pair[1].states.len\n\
    \                for i, step in pair[0].states:\n                    doAssert\
    \ step == pair[1].states[i].board\n            doAssert optimal_play(board, place,\
    \ terminal_win = judge) == play(board)\n            doAssert optimal_play(board,\
    \ place, evaluate = score, terminal_win = judge) == evaluated(board)\n\nproc branching(state:\
    \ int): seq[int] =\n    case state\n    of 2: @[0]\n    of 3: @[1, 2]\n    of\
    \ 4: @[3, 1]\n    of 5: @[2, 0]\n    else: @[]\n\nproc terminal(state: int): bool\
    \ =\n    doAssert state in [0, 1]\n    state == 1\n\nproc branching_by_turn(state:\
    \ int, is_first: bool): seq[int] = branching(state)\nproc terminal_by_turn(state:\
    \ int, is_first: bool): bool = terminal(state)\nproc prefer_large(state: int):\
    \ int = state\n\nfor fallback in [false, true]:\n    doAssert not can_win(3, branching,\
    \ fallback, terminal)\n    doAssert not can_win(3, branching_by_turn, fallback,\
    \ terminal_by_turn)\n    doAssert optimal_play(3, branching, fallback, terminal)\
    \ == (is_win: false, states: @[3, 2, 0])\n    doAssert optimal_play(4, branching,\
    \ fallback, terminal) == (is_win: true, states: @[4, 3, 2, 0])\n    doAssert optimal_play(5,\
    \ branching, fallback, terminal) == (is_win: true, states: @[5, 0])\n    let solve\
    \ = init_can_win(branching, fallback, terminal)\n    let solve_by_turn = init_can_win(branching_by_turn,\
    \ fallback, terminal_by_turn)\n    let restore = init_optimal_play(branching,\
    \ fallback, terminal)\n    let restore_by_turn = init_optimal_play(branching_by_turn,\
    \ fallback, terminal_by_turn)\n    let rank = init_optimal_play(branching, prefer_large,\
    \ fallback, terminal)\n    let rank_by_turn = init_optimal_play(branching_by_turn,\
    \ prefer_large, fallback, terminal_by_turn)\n    for initial in 0..5:\n      \
    \  let expected = restore(initial)\n        doAssert solve(initial) == expected.is_win\n\
    \        doAssert solve_by_turn(initial) == expected.is_win\n        doAssert\
    \ restore_by_turn(initial) == expected\n        doAssert rank(initial) == expected\n\
    \        doAssert rank_by_turn(initial) == expected\n        doAssert optimal_play(initial,\
    \ branching_by_turn, fallback, terminal_by_turn) == expected\n        doAssert\
    \ optimal_play(initial, branching, prefer_large, fallback, terminal) == expected\n\
    \        doAssert optimal_play(initial, branching_by_turn, prefer_large, fallback,\
    \ terminal_by_turn) == expected\n\nblock:\n    proc shared_terminal(state: int,\
    \ is_first: bool): seq[int] =\n        case state\n        of 2: @[0, 1]\n   \
    \     of 1: @[0]\n        else: @[]\n    proc first_wins(state: int, is_first:\
    \ bool): bool =\n        doAssert state == 0\n        is_first\n    let solve\
    \ = init_can_win(shared_terminal, terminal_win = first_wins)\n    let restore\
    \ = init_optimal_play(shared_terminal, terminal_win = first_wins)\n    for initial\
    \ in 0..2:\n        doAssert solve(initial)\n        doAssert restore(initial).is_win\n\
    \    doAssert restore(2).states == @[2, 0]\n\nblock:\n    var calls = 0\n    proc\
    \ counted(state: int): bool =\n        inc calls\n        terminal(state)\n  \
    \  proc counted_by_turn(state: int, is_first: bool): bool = counted(state)\n \
    \   let solvers = [init_can_win(branching, terminal_win = counted),\n        init_can_win(branching_by_turn,\
    \ terminal_win = counted_by_turn)]\n    let restorers = [init_optimal_play(branching,\
    \ terminal_win = counted),\n        init_optimal_play(branching_by_turn, terminal_win\
    \ = counted_by_turn)]\n    for solve in solvers:\n        for state in 0..5: discard\
    \ solve(state)\n        let previous = calls\n        for state in 0..5: discard\
    \ solve(state)\n        doAssert calls == previous\n    for restore in restorers:\n\
    \        for state in 0..5: discard restore(state)\n        let previous = calls\n\
    \        for state in 0..5: discard restore(state)\n        doAssert calls ==\
    \ previous\n    doAssert calls > 0\n\nblock:\n    proc failing(state: int): bool\
    \ = raise newException(ValueError, \"terminal failure\")\n    proc failing_by_turn(state:\
    \ int, is_first: bool): bool = failing(state)\n    let solve = init_can_win(branching,\
    \ terminal_win = failing)\n    let solve_by_turn = init_can_win(branching_by_turn,\
    \ terminal_win = failing_by_turn)\n    let restore = init_optimal_play(branching,\
    \ terminal_win = failing)\n    let restore_by_turn = init_optimal_play(branching_by_turn,\
    \ terminal_win = failing_by_turn)\n    for attempt in 0..1:\n        for f in\
    \ [solve, solve_by_turn]:\n            var caught = false\n            try: discard\
    \ f(2)\n            except ValueError as e:\n                caught = true\n \
    \               doAssert e.msg == \"terminal failure\"\n            doAssert caught\n\
    \        for f in [restore, restore_by_turn]:\n            var caught = false\n\
    \            try: discard f(2)\n            except ValueError as e:\n        \
    \        caught = true\n                doAssert e.msg == \"terminal failure\"\
    \n            doAssert caught\n\nblock:\n    let solve = init_can_win[int](branching,\
    \ terminal_win = proc(state: int): bool = state == 1)\n    let solve_by_turn =\
    \ init_can_win[int](branching_by_turn,\n        terminal_win = proc(state: int,\
    \ is_first: bool): bool = state == 1)\n    let restore = init_optimal_play[int](branching,\n\
    \        terminal_win = proc(state: int): bool = state == 1)\n    let restore_by_turn\
    \ = init_optimal_play[int](branching_by_turn,\n        terminal_win = proc(state:\
    \ int, is_first: bool): bool = state == 1)\n    doAssert not solve(3)\n    doAssert\
    \ not solve_by_turn(3)\n    doAssert restore(3) == restore_by_turn(3)\n    doAssert\
    \ restore(3).states == @[3, 2, 0]\n\nblock:\n    proc make_solver(winning_leaf:\
    \ int): proc(state: int): bool {.closure.} =\n        init_can_win(branching,\
    \ terminal_win = proc(state: int): bool = state == winning_leaf)\n    proc make_restore(nxt:\
    \ NextStates[int], terminal_win: TerminalWin[int]):\n            proc(state: int):\
    \ tuple[is_win: bool, states: seq[int]] {.closure.} =\n        init_optimal_play(nxt,\
    \ terminal_win = terminal_win)\n    let first = make_solver(0)\n    let second\
    \ = make_solver(1)\n    doAssert not first(2)\n    doAssert second(2)\n    let\
    \ stored: TerminalWin[int] = terminal\n    doAssert make_restore(branching, stored)(3).states\
    \ == @[3, 2, 0]\n    let ranked = init_optimal_play(branching, evaluate = prefer_large,\n\
    \        terminal_win = proc(state: int): bool = state == 1)\n    let ranked_by_turn\
    \ = init_optimal_play(branching_by_turn, evaluate = prefer_large,\n        terminal_win\
    \ = proc(state: int, is_first: bool): bool = state == 1)\n    doAssert ranked(3)\
    \ == ranked_by_turn(3)\n    doAssert ranked(3).states == @[3, 2, 0]\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/utils/game.nim
  - cplib/utils/game.nim
  isVerificationFile: true
  path: verify/utils/game_terminal_test.nim
  requiredBy: []
  timestamp: '2026-10-17 20:24:48+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/game_terminal_test.nim
layout: document
redirect_from:
- /verify/verify/utils/game_terminal_test.nim
- /verify/verify/utils/game_terminal_test.nim.html
title: verify/utils/game_terminal_test.nim
---
