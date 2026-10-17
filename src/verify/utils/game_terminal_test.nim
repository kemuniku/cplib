# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/game

type
    Board = array[4, int]
    State = tuple[board: Board, is_first: bool]

proc score(board: Board): int =
    for i, mark in board:
        result += mark * (1 shl i)

proc place(board: Board, is_first: bool): seq[Board] =
    for i in 0..<board.len:
        if board[i] == 0:
            var next_board = board
            next_board[i] = (if is_first: 1 else: -1)
            result.add(next_board)

proc judge(board: Board, is_first: bool): bool =
    doAssert 0 notin board
    (score(board) > 0) == is_first

proc place_state(state: State): seq[State] =
    for board in place(state.board, state.is_first):
        result.add((board, not state.is_first))

proc judge_state(state: State): bool =
    judge(state.board, state.is_first)

proc score_state(state: State): int = score(state.board)

proc minimax(board: Board, is_first: bool): int =
    if 0 notin board:
        return score(board)
    result = (if is_first: low(int) else: high(int))
    for i in 0..<board.len:
        if board[i] == 0:
            var next_board = board
            next_board[i] = (if is_first: 1 else: -1)
            let value = minimax(next_board, not is_first)
            result = (if is_first: max(result, value) else: min(result, value))

proc check_play(initial: State, play: tuple[is_win: bool, states: seq[State]]) =
    doAssert play.is_win == ((minimax(initial.board, initial.is_first) > 0) == initial.is_first)
    doAssert play.states[0] == initial
    var empty = 0
    for mark in initial.board:
        if mark == 0: inc empty
    doAssert play.states.len == empty + 1
    for i in 0..<play.states.len - 1:
        let current = play.states[i]
        let child = play.states[i + 1]
        doAssert child in place_state(current)
        doAssert (minimax(current.board, current.is_first) > 0) ==
            (minimax(child.board, child.is_first) > 0)
    doAssert 0 notin play.states[^1].board
    doAssert play.is_win == ((score(play.states[^1].board) > 0) == initial.is_first)

let win = init_can_win(place, terminal_win = judge)
let win_state = init_can_win(place_state, terminal_win = judge_state)
let play = init_optimal_play(place, terminal_win = judge)
let play_state = init_optimal_play(place_state, terminal_win = judge_state)
let evaluated = init_optimal_play(place, evaluate = score, terminal_win = judge)
let evaluated_state = init_optimal_play(place_state, evaluate = score_state, terminal_win = judge_state)

for code in 0..<81:
    var board: Board
    var rest = code
    for i in 0..<board.len:
        board[i] = rest mod 3 - 1
        rest = rest div 3
    let expected = minimax(board, true) > 0
    doAssert win(board) == expected
    doAssert can_win(board, place, terminal_win = judge) == expected
    for is_first in [false, true]:
        let state: State = (board, is_first)
        let expected_state = (minimax(board, is_first) > 0) == is_first
        doAssert win_state(state) == expected_state
        doAssert can_win(state, place_state, terminal_win = judge_state) == expected_state
        let plain = play_state(state)
        let ranked = evaluated_state(state)
        check_play(state, plain)
        check_play(state, ranked)
        doAssert optimal_play(state, place_state, terminal_win = judge_state) == plain
        doAssert optimal_play(state, place_state, evaluate = score_state, terminal_win = judge_state) == ranked
        if is_first:
            for pair in [(play(board), plain), (evaluated(board), ranked)]:
                doAssert pair[0].is_win == pair[1].is_win
                doAssert pair[0].states.len == pair[1].states.len
                for i, step in pair[0].states:
                    doAssert step == pair[1].states[i].board
            doAssert optimal_play(board, place, terminal_win = judge) == play(board)
            doAssert optimal_play(board, place, evaluate = score, terminal_win = judge) == evaluated(board)

proc branching(state: int): seq[int] =
    case state
    of 2: @[0]
    of 3: @[1, 2]
    of 4: @[3, 1]
    of 5: @[2, 0]
    else: @[]

proc terminal(state: int): bool =
    doAssert state in [0, 1]
    state == 1

proc branching_by_turn(state: int, is_first: bool): seq[int] = branching(state)
proc terminal_by_turn(state: int, is_first: bool): bool = terminal(state)
proc prefer_large(state: int): int = state

for fallback in [false, true]:
    doAssert not can_win(3, branching, fallback, terminal)
    doAssert not can_win(3, branching_by_turn, fallback, terminal_by_turn)
    doAssert optimal_play(3, branching, fallback, terminal) == (is_win: false, states: @[3, 2, 0])
    doAssert optimal_play(4, branching, fallback, terminal) == (is_win: true, states: @[4, 3, 2, 0])
    doAssert optimal_play(5, branching, fallback, terminal) == (is_win: true, states: @[5, 0])
    let solve = init_can_win(branching, fallback, terminal)
    let solve_by_turn = init_can_win(branching_by_turn, fallback, terminal_by_turn)
    let restore = init_optimal_play(branching, fallback, terminal)
    let restore_by_turn = init_optimal_play(branching_by_turn, fallback, terminal_by_turn)
    let rank = init_optimal_play(branching, prefer_large, fallback, terminal)
    let rank_by_turn = init_optimal_play(branching_by_turn, prefer_large, fallback, terminal_by_turn)
    for initial in 0..5:
        let expected = restore(initial)
        doAssert solve(initial) == expected.is_win
        doAssert solve_by_turn(initial) == expected.is_win
        doAssert restore_by_turn(initial) == expected
        doAssert rank(initial) == expected
        doAssert rank_by_turn(initial) == expected
        doAssert optimal_play(initial, branching_by_turn, fallback, terminal_by_turn) == expected
        doAssert optimal_play(initial, branching, prefer_large, fallback, terminal) == expected
        doAssert optimal_play(initial, branching_by_turn, prefer_large, fallback, terminal_by_turn) == expected

block:
    proc shared_terminal(state: int, is_first: bool): seq[int] =
        case state
        of 2: @[0, 1]
        of 1: @[0]
        else: @[]
    proc first_wins(state: int, is_first: bool): bool =
        doAssert state == 0
        is_first
    let solve = init_can_win(shared_terminal, terminal_win = first_wins)
    let restore = init_optimal_play(shared_terminal, terminal_win = first_wins)
    for initial in 0..2:
        doAssert solve(initial)
        doAssert restore(initial).is_win
    doAssert restore(2).states == @[2, 0]

block:
    var calls = 0
    proc counted(state: int): bool =
        inc calls
        terminal(state)
    proc counted_by_turn(state: int, is_first: bool): bool = counted(state)
    let solvers = [init_can_win(branching, terminal_win = counted),
        init_can_win(branching_by_turn, terminal_win = counted_by_turn)]
    let restorers = [init_optimal_play(branching, terminal_win = counted),
        init_optimal_play(branching_by_turn, terminal_win = counted_by_turn)]
    for solve in solvers:
        for state in 0..5: discard solve(state)
        let previous = calls
        for state in 0..5: discard solve(state)
        doAssert calls == previous
    for restore in restorers:
        for state in 0..5: discard restore(state)
        let previous = calls
        for state in 0..5: discard restore(state)
        doAssert calls == previous
    doAssert calls > 0

block:
    proc failing(state: int): bool = raise newException(ValueError, "terminal failure")
    proc failing_by_turn(state: int, is_first: bool): bool = failing(state)
    let solve = init_can_win(branching, terminal_win = failing)
    let solve_by_turn = init_can_win(branching_by_turn, terminal_win = failing_by_turn)
    let restore = init_optimal_play(branching, terminal_win = failing)
    let restore_by_turn = init_optimal_play(branching_by_turn, terminal_win = failing_by_turn)
    for attempt in 0..1:
        for f in [solve, solve_by_turn]:
            var caught = false
            try: discard f(2)
            except ValueError as e:
                caught = true
                doAssert e.msg == "terminal failure"
            doAssert caught
        for f in [restore, restore_by_turn]:
            var caught = false
            try: discard f(2)
            except ValueError as e:
                caught = true
                doAssert e.msg == "terminal failure"
            doAssert caught

block:
    let solve = init_can_win[int](branching, terminal_win = proc(state: int): bool = state == 1)
    let solve_by_turn = init_can_win[int](branching_by_turn,
        terminal_win = proc(state: int, is_first: bool): bool = state == 1)
    let restore = init_optimal_play[int](branching,
        terminal_win = proc(state: int): bool = state == 1)
    let restore_by_turn = init_optimal_play[int](branching_by_turn,
        terminal_win = proc(state: int, is_first: bool): bool = state == 1)
    doAssert not solve(3)
    doAssert not solve_by_turn(3)
    doAssert restore(3) == restore_by_turn(3)
    doAssert restore(3).states == @[3, 2, 0]

block:
    proc make_solver(winning_leaf: int): proc(state: int): bool {.closure.} =
        init_can_win(branching, terminal_win = proc(state: int): bool = state == winning_leaf)
    proc make_restore(nxt: NextStates[int], terminal_win: TerminalWin[int]):
            proc(state: int): tuple[is_win: bool, states: seq[int]] {.closure.} =
        init_optimal_play(nxt, terminal_win = terminal_win)
    let first = make_solver(0)
    let second = make_solver(1)
    doAssert not first(2)
    doAssert second(2)
    let stored: TerminalWin[int] = terminal
    doAssert make_restore(branching, stored)(3).states == @[3, 2, 0]
    let ranked = init_optimal_play(branching, evaluate = prefer_large,
        terminal_win = proc(state: int): bool = state == 1)
    let ranked_by_turn = init_optimal_play(branching_by_turn, evaluate = prefer_large,
        terminal_win = proc(state: int, is_first: bool): bool = state == 1)
    doAssert ranked(3) == ranked_by_turn(3)
    doAssert ranked(3).states == @[3, 2, 0]

echo "Hello World"
