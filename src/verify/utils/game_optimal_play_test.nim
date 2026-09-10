# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/game

proc subtract(state: int): seq[int] =
    for take in 1..2:
        if take <= state:
            result.add(state - take)

doAssert optimal_play(4, subtract).states == @[4, 3, 2, 0]
doAssert optimal_play(3, subtract).states == @[3, 2, 0]
doAssert optimal_play(4, subtract, true).states == @[4, 3, 1, 0]

for misere in [false, true]:
    doAssert optimal_play(0, subtract, misere).states == @[0]
    for initial in 0..30:
        let (is_win, path) = optimal_play(initial, subtract, misere)
        doAssert is_win == (initial mod 3 != ord(misere))
        doAssert path[0] == initial
        doAssert path[^1] == 0
        for i in 0..<path.len - 1:
            doAssert path[i + 1] in subtract(path[i])
            let winning = path[i] mod 3 != ord(misere)
            if winning:
                doAssert path[i + 1] mod 3 == ord(misere)
            else:
                doAssert path[i + 1] == path[i] - 1
        doAssert (initial mod 3 != ord(misere)) ==
            ((path.len mod 2 == 0) xor misere)

proc subtract_by_turn(state: int, is_first: bool): seq[int] =
    let max_take = (if is_first: 1 else: 2)
    for take in 1..max_take:
        if take <= state:
            result.add(state - take)

for misere in [false, true]:
    var winning: array[31, array[bool, bool]]
    var turns: array[31, array[bool, int]]
    for is_first in [false, true]:
        winning[0][is_first] = misere
    for state in 1..30:
        for is_first in [false, true]:
            for next_state in subtract_by_turn(state, is_first):
                if not winning[next_state][not is_first]:
                    winning[state][is_first] = true
            var shortest = high(int)
            var longest = 0
            for next_state in subtract_by_turn(state, is_first):
                if not winning[next_state][not is_first]:
                    shortest = min(shortest, turns[next_state][not is_first] + 1)
                longest = max(longest, turns[next_state][not is_first] + 1)
            turns[state][is_first] =
                (if winning[state][is_first]: shortest else: longest)
    for initial in 0..30:
        let (is_win, path) = optimal_play(initial, subtract_by_turn, misere)
        doAssert is_win == winning[initial][true]
        doAssert path[0] == initial
        doAssert path[^1] == 0
        doAssert path.len - 1 == turns[initial][true]
        for i in 0..<path.len - 1:
            let is_first = i mod 2 == 0
            let moves = subtract_by_turn(path[i], is_first)
            var expected = moves[0]
            for next_state in moves:
                if winning[next_state][not is_first] != winning[path[i]][is_first] and
                        turns[next_state][not is_first] + 1 == turns[path[i]][is_first]:
                    expected = next_state
                    break
            doAssert path[i + 1] == expected
        doAssert winning[initial][true] ==
            ((path.len mod 2 == 0) xor misere)

proc pass_first(state: int, is_first: bool): seq[int] =
    if state > 0:
        result.add(if is_first: state else: state - 1)

doAssert optimal_play(2, pass_first).states == @[2, 2, 1, 1, 0]

proc branching(state: int): seq[int] =
    case state
    of 0: @[]
    of 1: @[0]
    of 2: @[1]
    of 3: @[2]
    of 4: @[2, 0]
    of 5: @[1, 3]
    of 6: @[0, 2]
    of 7: @[3, 1]
    of 8: @[2, 5]
    of 9: @[4, 3]
    else: @[]

doAssert optimal_play(4, branching).states == @[4, 0]
doAssert optimal_play(5, branching).states == @[5, 3, 2, 1, 0]
doAssert optimal_play(6, branching).states == @[6, 0]
doAssert optimal_play(7, branching).states == @[7, 3, 2, 1, 0]
doAssert optimal_play(8, branching).states == @[8, 2, 1, 0]
doAssert optimal_play(9, branching).states == @[9, 3, 2, 1, 0]
doAssert optimal_play(4, branching, true).states == @[4, 2, 1, 0]
doAssert optimal_play(5, branching, true).states == @[5, 1, 0]
doAssert optimal_play(6, branching, true).states == @[6, 2, 1, 0]
doAssert optimal_play(7, branching, true).states == @[7, 1, 0]

proc branching_by_turn(state: int, is_first: bool): seq[int] =
    branching(state)

for misere in [false, true]:
    for initial in 0..9:
        doAssert optimal_play(initial, branching_by_turn, misere) ==
            optimal_play(initial, branching, misere)

proc erase_suffix(state: string): seq[string] =
    if state.len > 0:
        result.add(state[0..^2])

doAssert optimal_play("abc", erase_suffix).states == @["abc", "ab", "a", ""]
doAssert optimal_play[int](1, proc(state: int): seq[int] =
    if state > 0: @[0] else: @[]).states == @[1, 0]
doAssert optimal_play[int](1, proc(state: int, is_first: bool): seq[int] =
    if state > 0: @[0] else: @[]).states == @[1, 0]

proc cyclic(state: int): seq[int] = @[state]
proc cyclic_by_turn(state: int, is_first: bool): seq[int] = @[state]

for by_turn in [false, true]:
    var caught = false
    try:
        if by_turn:
            discard optimal_play(0, cyclic_by_turn)
        else:
            discard optimal_play(0, cyclic)
    except ValueError:
        caught = true
    doAssert caught

for misere in [false, true]:
    block:
        var calls: array[31, int]
        proc counted(state: int): seq[int] =
            inc calls[state]
            subtract(state)
        let solve = init_optimal_play(counted, misere)
        doAssert solve(30) == optimal_play(30, subtract, misere)
        for initial in 0..30:
            doAssert calls[initial] == 1
            doAssert solve(initial) == optimal_play(initial, subtract, misere)
            doAssert calls[initial] == 1
        var play = solve(4)
        play.states[0] = -1
        doAssert solve(4).states[0] == 4
        let independent = init_optimal_play(counted, not misere)
        doAssert independent(30) == optimal_play(30, subtract, not misere)
        for count in calls:
            doAssert count == 2
    block:
        var calls: array[31, array[bool, int]]
        proc counted(state: int, is_first: bool): seq[int] =
            inc calls[state][is_first]
            subtract_by_turn(state, is_first)
        let solve = init_optimal_play(counted, misere)
        for initial in 0..30:
            doAssert solve(initial) == optimal_play(initial, subtract_by_turn, misere)
        let previous_calls = calls
        for initial in 0..30:
            doAssert solve(initial) == optimal_play(initial, subtract_by_turn, misere)
        doAssert calls == previous_calls
        for counts in calls:
            for count in counts:
                doAssert count <= 1

let string_solver = init_optimal_play(erase_suffix)
doAssert string_solver("abc") == (is_win: true, states: @["abc", "ab", "a", ""])
doAssert string_solver("") == (is_win: false, states: @[""])
let pass_solver = init_optimal_play(pass_first)
for initial in 0..5:
    doAssert pass_solver(initial) == optimal_play(initial, pass_first)

block:
    let solve = init_optimal_play[int](proc(state: int): seq[int] =
        if state > 0: @[0] else: @[])
    doAssert solve(1) == (is_win: true, states: @[1, 0])
    let solve_by_turn = init_optimal_play[int](proc(state: int, is_first: bool): seq[int] =
        if state > 0: @[0] else: @[])
    doAssert solve_by_turn(1) == solve(1)

proc make_solver(nxt: NextStates[int]): proc(state: int): tuple[is_win: bool, states: seq[int]] {.closure.} =
    init_optimal_play(nxt)

doAssert make_solver(subtract)(4) == optimal_play(4, subtract)
let stored: NextStatesByTurn[int] = subtract_by_turn
let stored_solver = init_optimal_play(stored)
doAssert stored_solver(4) == optimal_play(4, subtract_by_turn)

block:
    let solve = init_optimal_play(cyclic)
    let solve_by_turn = init_optimal_play(cyclic_by_turn)
    for attempt in 0..1:
        for f in [solve, solve_by_turn]:
            var caught = false
            try:
                discard f(0)
            except ValueError:
                caught = true
            doAssert caught

block:
    var calls = 0
    proc failing(state: int): seq[int] =
        inc calls
        raise newException(ValueError, "test")
    proc failing_by_turn(state: int, is_first: bool): seq[int] =
        failing(state)
    let solve = init_optimal_play(failing)
    let solve_by_turn = init_optimal_play(failing_by_turn)
    for attempt in 0..1:
        for f in [solve, solve_by_turn]:
            var caught = false
            try:
                discard f(0)
            except ValueError as e:
                caught = true
                doAssert e.msg == "test"
            doAssert caught
    doAssert calls == 4

proc tied(state: int): seq[int] =
    case state
    of 2: @[0, 1]
    of 3: @[0]
    of 4: @[2, 3]
    else: @[]

proc tied_by_turn(state: int, is_first: bool): seq[int] =
    tied(state)

proc score(state: int): int = state
proc constant_score(state: int): int = -10

for misere in [false, true]:
    doAssert optimal_play(2, tied, evaluate = score, win_when_no_moves = misere) ==
        (is_win: not misere, states: @[2, 1])
    doAssert optimal_play(4, tied, evaluate = score, win_when_no_moves = misere) ==
        (is_win: misere, states: @[4, 3, 0])
    let solve = init_optimal_play(tied, evaluate = score, win_when_no_moves = misere)
    let solve_by_turn = init_optimal_play(tied_by_turn, evaluate = score, win_when_no_moves = misere)
    for initial in 0..4:
        doAssert solve(initial) == optimal_play(initial, tied, score, misere)
        doAssert solve_by_turn(initial) == solve(initial)
        doAssert optimal_play(initial, tied_by_turn, score, misere) == solve(initial)
        doAssert optimal_play(initial, tied, constant_score, misere) ==
            optimal_play(initial, tied, misere)
    for initial in 0..9:
        let original = optimal_play(initial, branching, misere)
        let evaluated = optimal_play(initial, branching, score, misere)
        doAssert evaluated.is_win == original.is_win
        doAssert evaluated.states.len == original.states.len

doAssert optimal_play(4, branching, score).states == @[4, 0]
doAssert optimal_play(5, branching, proc(state: int): int = -state).states ==
    @[5, 3, 2, 1, 0]
doAssert optimal_play(8, branching, score).states == @[8, 2, 1, 0]

block:
    var calls = 0
    let solve = init_optimal_play(tied, evaluate = proc(state: int): float =
        inc calls
        -float(state)
    )
    doAssert solve(4) == (is_win: false, states: @[4, 2, 0])
    doAssert calls > 0
    let previous_calls = calls
    for initial in 0..4:
        discard solve(initial)
    doAssert calls == previous_calls

block:
    let solve = init_optimal_play(tied_by_turn, evaluate = proc(state: int): int64 =
        -int64(state)
    )
    doAssert solve(4).states == @[4, 2, 0]
    let solve_pair = init_optimal_play(tied, evaluate = proc(state: int): tuple[a, b: int] =
        (0, state)
    )
    doAssert solve_pair(4).states == @[4, 3, 0]

echo "Hello World"
