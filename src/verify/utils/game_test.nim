# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/game

proc subtract(state: int): seq[int] =
    for take in 1..2:
        if take <= state:
            result.add(state - take)

for state in 0..20:
    doAssert can_win(state, subtract) == (state mod 3 != 0)
    doAssert can_win(state, subtract, win_when_no_moves = true) ==
        (state mod 3 != 1)

proc erase_suffix(state: string): seq[string] =
    if state.len > 0:
        result.add(state[0..^2])

doAssert can_win("abc", erase_suffix)
doAssert not can_win("abcd", erase_suffix)

proc subtract_by_turn(state: int, is_first: bool): seq[int] =
    let max_take = (if is_first: 1 else: 2)
    for take in 1..max_take:
        if take <= state:
            result.add(state - take)

doAssert can_win(1, subtract_by_turn)
doAssert not can_win(2, subtract_by_turn)
doAssert not can_win(3, subtract_by_turn)
doAssert can_win(0, subtract_by_turn, win_when_no_moves = true)

proc cyclic(state: int): seq[int] = @[state]

block:
    var caught = false
    try:
        discard can_win(0, cyclic)
    except ValueError:
        caught = true
    doAssert caught

block:
    var calls = 0
    proc counted(state: int): seq[int] =
        inc calls
        subtract(state)

    let solve = init_can_win(counted)
    for state in 0..20:
        doAssert solve(state) == (state mod 3 != 0)
    doAssert calls == 21
    for state in 0..20:
        discard solve(state)
    doAssert calls == 21

    let misere = init_can_win(counted, win_when_no_moves = true)
    for state in 0..20:
        doAssert misere(state) == (state mod 3 != 1)
    doAssert calls == 42

block:
    var calls = 0
    proc counted(state: int, is_first: bool): seq[int] =
        inc calls
        subtract_by_turn(state, is_first)

    let solve = init_can_win(counted)
    for state in 0..20:
        doAssert solve(state) == can_win(state, subtract_by_turn)
    let previous_calls = calls
    for state in 0..20:
        discard solve(state)
    doAssert calls == previous_calls
    let misere = init_can_win(counted, win_when_no_moves = true)
    for state in 0..20:
        doAssert misere(state) == can_win(state, subtract_by_turn, true)

block:
    let solve = init_can_win(erase_suffix)
    doAssert solve("abc")
    doAssert not solve("abcd")

block:
    var calls = 0
    proc failing(state: int): seq[int] =
        inc calls
        raise newException(ValueError, "test")
    proc failing_by_turn(state: int, is_first: bool): seq[int] =
        failing(state)

    let solve = init_can_win(failing)
    let solve_by_turn = init_can_win(failing_by_turn)
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

block:
    let solve = init_can_win(cyclic)
    for attempt in 0..1:
        var caught = false
        try:
            discard solve(0)
        except ValueError:
            caught = true
        doAssert caught

echo "Hello World"
