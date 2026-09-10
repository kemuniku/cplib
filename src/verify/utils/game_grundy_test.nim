# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/game

proc subtract(state: int): seq[int] =
    for take in 1..2:
        if take <= state:
            result.add(state - take)

let solve = init_grundy(subtract)
for state in 0..40:
    doAssert solve(state) == state mod 3
    doAssert grundy(state, subtract) == state mod 3
    doAssert (solve(state) != 0) == can_win(state, subtract)

proc nim_heap(state: int): seq[int] =
    for next_state in 0..<state:
        result.add(next_state)

let heap_solver = init_grundy(nim_heap)
for state in 0..30:
    doAssert heap_solver(state) == state

proc two_heaps(state: tuple[a, b: int]): seq[tuple[a, b: int]] =
    for a in 0..<state.a:
        result.add((a, state.b))
    for b in 0..<state.b:
        result.add((state.a, b))

let pair_solver = init_grundy(two_heaps)
for a in 0..10:
    for b in 0..10:
        doAssert pair_solver((a, b)) == (a xor b)

proc sparse(state: int): seq[int] =
    case state
    of 10: @[5]
    of 11: @[0, 0, 5]
    of 12: @[0, 1, 5]
    else: nim_heap(state)

doAssert grundy(10, sparse) == 0
doAssert grundy(11, sparse) == 1
doAssert grundy(12, sparse) == 2

proc erase_suffix(state: string): seq[string] =
    if state.len > 0:
        result.add(state[0..^2])

let string_solver = init_grundy(erase_suffix)
doAssert string_solver("") == 0
doAssert string_solver("abc") == 1
doAssert grundy("abcd", erase_suffix) == 0

block:
    var calls: array[41, int]
    proc counted(state: int): seq[int] =
        inc calls[state]
        subtract(state)
    let cached = init_grundy(counted)
    doAssert cached(40) == 1
    for state in 0..40:
        doAssert cached(state) == state mod 3
        doAssert calls[state] == 1
    let independent = init_grundy(counted)
    doAssert independent(40) == 1
    for count in calls:
        doAssert count == 2

block:
    let lambda_solver = init_grundy[int](proc(state: int): seq[int] =
        if state > 0: @[state - 1] else: @[])
    doAssert lambda_solver(4) == 0
    doAssert lambda_solver(5) == 1

proc make_solver(nxt: NextStates[int]): proc(state: int): int {.closure.} =
    init_grundy(nxt)

doAssert make_solver(subtract)(2) == 2
let stored: NextStates[int] = subtract
let stored_solver = init_grundy(stored)
doAssert stored_solver(3) == 0

proc cyclic(state: int): seq[int] = @[state]
proc two_cycle(state: int): seq[int] = @[1 - state]

for nxt in [cyclic, two_cycle]:
    let cached = init_grundy(nxt)
    for attempt in 0..1:
        var caught = false
        try:
            discard cached(0)
        except ValueError:
            caught = true
        doAssert caught
    var caught = false
    try:
        discard grundy(0, nxt)
    except ValueError:
        caught = true
    doAssert caught

block:
    var calls = 0
    proc failing(state: int): seq[int] =
        inc calls
        raise newException(ValueError, "test")
    let cached = init_grundy(failing)
    for attempt in 0..1:
        var caught = false
        try:
            discard cached(0)
        except ValueError as e:
            caught = true
            doAssert e.msg == "test"
        doAssert caught
    doAssert calls == 2

echo "Hello World"
