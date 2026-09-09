# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/game

var global_moves = 1
let fixed_moves = 1

proc direct(state: int): seq[int] =
    if state >= global_moves:
        result.add(state - global_moves)

proc indirect(state: int): seq[int] =
    direct(state)

proc local_only(state: int): seq[int] =
    var step = fixed_moves
    var (a, b) = (step, 0)
    proc unused(state: int): seq[int] =
        direct(state)
    step = a + b
    if state >= step:
        result.add(state - step)

let direct_solver = init_can_win(direct)
doAssert direct_solver(1)
let indirect_solver = init_can_win(indirect)
doAssert indirect_solver(1)
let local_solver = init_can_win[int](local_only)
doAssert local_solver(1)

block:
    var captured_moves = 1
    proc by_turn(state: int, is_first: bool): seq[int] =
        if state >= captured_moves:
            result.add(state - captured_moves)
    let solve = init_can_win(by_turn)
    doAssert solve(1)

block:
    var lambda_moves = 1
    let solve = init_can_win(proc(state: int): seq[int] =
        var step = lambda_moves
        if state >= step:
            result.add(state - step)
    )
    doAssert solve(1)

block:
    var turn_lambda_moves = 1
    let solve = init_can_win(proc(state: int, is_first: bool): seq[int] =
        if state >= turn_lambda_moves:
            result.add(state - turn_lambda_moves)
    )
    doAssert solve(1)

proc make_solver(nxt: NextStates[int]): proc(state: int): bool {.closure.} =
    init_can_win(nxt)

doAssert make_solver(direct)(1)
let stored: NextStates[int] = direct
let stored_solver = init_can_win(stored)
doAssert stored_solver(1)
doAssert can_win(1, direct)

proc make_captured_solver(step: int): proc(state: int): bool {.closure.} =
    var captured_step = step
    init_can_win(proc(state: int): seq[int] =
        if state >= captured_step:
            result.add(state - captured_step)
    )

let captured_one = make_captured_solver(1)
let captured_two = make_captured_solver(2)
doAssert captured_one(1)
doAssert not captured_two(1)
doAssert not captured_one(2)
doAssert captured_two(2)

echo "Hello World"
