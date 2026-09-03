when not declared CPLIB_UTILS_GAME:
    const CPLIB_UTILS_GAME* = 1

    import sets,tables

    type
        NextStates*[T] = proc(state: T): seq[T] {.closure.}
        NextStatesByTurn*[T] = proc(state: T, is_first: bool): seq[T] {.closure.}

    proc can_win*[T](initial_state: T, nxt: NextStates[T],
            win_when_no_moves: bool = false): bool =
        ## Returns whether the player at `initial_state` can force a win.
        ##
        ## `nxt(state)` returns all states reachable in one move.  A state with
        ## no legal moves is winning exactly when `win_when_no_moves` is true.
        ## The reachable game graph must be finite and acyclic.
        runnableExamples:
            proc subtract(state: int): seq[int] =
                for take in 1..2:
                    if take <= state:
                        result.add(state - take)

            assert can_win(3, subtract) == false
            assert can_win(4, subtract) == true
            assert can_win(1, subtract, win_when_no_moves = true) == false

        var memo = initTable[T, bool]()
        var visiting = initHashSet[T]()

        proc solve(state: T): bool =
            if memo.hasKey(state):
                return memo[state]
            if state in visiting:
                raise newException(ValueError,
                    "can_win does not support cycles in the game graph")

            visiting.incl(state)
            let next_states = nxt(state)
            if next_states.len == 0:
                result = win_when_no_moves
            else:
                result = false
                for next_state in next_states:
                    if not solve(next_state):
                        result = true
                        break
            visiting.excl(state)
            memo[state] = result

        result = solve(initial_state)

    proc can_win*[T](initial_state: T, nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): bool =
        ## Returns whether the first player can force a win.
        ##
        ## `nxt(state, is_first)` returns all states reachable by the player
        ## whose turn it is.  `is_first` is true on the initial turn and is
        ## flipped after every move.  A state with no legal moves is winning
        ## for the player whose turn it is exactly when `win_when_no_moves` is
        ## true.  The reachable game graph must be finite and acyclic.
        runnableExamples:
            proc subtract_by_turn(state: int, is_first: bool): seq[int] =
                let max_take = (if is_first: 1 else: 2)
                for take in 1..max_take:
                    if take <= state:
                        result.add(state - take)

            assert can_win(1, subtract_by_turn) == true
            assert can_win(2, subtract_by_turn) == false

        type TurnState = tuple[state: T, is_first: bool]
        var memo = initTable[TurnState, bool]()
        var visiting = initHashSet[TurnState]()

        proc solve(state: T, is_first: bool): bool =
            let key = (state: state, is_first: is_first)
            if memo.hasKey(key):
                return memo[key]
            if key in visiting:
                raise newException(ValueError,
                    "can_win does not support cycles in the game graph")

            visiting.incl(key)
            let next_states = nxt(state, is_first)
            if next_states.len == 0:
                result = win_when_no_moves
            else:
                result = false
                for next_state in next_states:
                    if not solve(next_state, not is_first):
                        result = true
                        break
            visiting.excl(key)
            memo[key] = result

        result = solve(initial_state, true)
