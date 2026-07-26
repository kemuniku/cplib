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

echo "Hello World"
