---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_GAME:\n    const CPLIB_UTILS_GAME* = 1\n\n\
    \    import sets,tables\n\n    type\n        NextStates*[T] = proc(state: T):\
    \ seq[T] {.closure.}\n        NextStatesByTurn*[T] = proc(state: T, is_first:\
    \ bool): seq[T] {.closure.}\n\n    proc can_win*[T](initial_state: T, nxt: NextStates[T],\n\
    \            win_when_no_moves: bool = false): bool =\n        ## Returns whether\
    \ the player at `initial_state` can force a win.\n        ##\n        ## `nxt(state)`\
    \ returns all states reachable in one move.  A state with\n        ## no legal\
    \ moves is winning exactly when `win_when_no_moves` is true.\n        ## The reachable\
    \ game graph must be finite and acyclic.\n        runnableExamples:\n        \
    \    proc subtract(state: int): seq[int] =\n                for take in 1..2:\n\
    \                    if take <= state:\n                        result.add(state\
    \ - take)\n\n            assert can_win(3, subtract) == false\n            assert\
    \ can_win(4, subtract) == true\n            assert can_win(1, subtract, win_when_no_moves\
    \ = true) == false\n\n        var memo = initTable[T, bool]()\n        var visiting\
    \ = initHashSet[T]()\n\n        proc solve(state: T): bool =\n            if memo.hasKey(state):\n\
    \                return memo[state]\n            if state in visiting:\n     \
    \           raise newException(ValueError,\n                    \"can_win does\
    \ not support cycles in the game graph\")\n\n            visiting.incl(state)\n\
    \            let next_states = nxt(state)\n            if next_states.len == 0:\n\
    \                result = win_when_no_moves\n            else:\n             \
    \   result = false\n                for next_state in next_states:\n         \
    \           if not solve(next_state):\n                        result = true\n\
    \                        break\n            visiting.excl(state)\n           \
    \ memo[state] = result\n\n        result = solve(initial_state)\n\n    proc can_win*[T](initial_state:\
    \ T, nxt: NextStatesByTurn[T],\n            win_when_no_moves: bool = false):\
    \ bool =\n        ## Returns whether the first player can force a win.\n     \
    \   ##\n        ## `nxt(state, is_first)` returns all states reachable by the\
    \ player\n        ## whose turn it is.  `is_first` is true on the initial turn\
    \ and is\n        ## flipped after every move.  A state with no legal moves is\
    \ winning\n        ## for the player whose turn it is exactly when `win_when_no_moves`\
    \ is\n        ## true.  The reachable game graph must be finite and acyclic.\n\
    \        runnableExamples:\n            proc subtract_by_turn(state: int, is_first:\
    \ bool): seq[int] =\n                let max_take = (if is_first: 1 else: 2)\n\
    \                for take in 1..max_take:\n                    if take <= state:\n\
    \                        result.add(state - take)\n\n            assert can_win(1,\
    \ subtract_by_turn) == true\n            assert can_win(2, subtract_by_turn) ==\
    \ false\n\n        type TurnState = tuple[state: T, is_first: bool]\n        var\
    \ memo = initTable[TurnState, bool]()\n        var visiting = initHashSet[TurnState]()\n\
    \n        proc solve(state: T, is_first: bool): bool =\n            let key =\
    \ (state: state, is_first: is_first)\n            if memo.hasKey(key):\n     \
    \           return memo[key]\n            if key in visiting:\n              \
    \  raise newException(ValueError,\n                    \"can_win does not support\
    \ cycles in the game graph\")\n\n            visiting.incl(key)\n            let\
    \ next_states = nxt(state, is_first)\n            if next_states.len == 0:\n \
    \               result = win_when_no_moves\n            else:\n              \
    \  result = false\n                for next_state in next_states:\n          \
    \          if not solve(next_state, not is_first):\n                        result\
    \ = true\n                        break\n            visiting.excl(key)\n    \
    \        memo[key] = result\n\n        result = solve(initial_state, true)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/game.nim
  requiredBy: []
  timestamp: '2026-07-27 08:09:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/game_test.nim
  - verify/utils/game_test.nim
documentation_of: cplib/utils/game.nim
layout: document
redirect_from:
- /library/cplib/utils/game.nim
- /library/cplib/utils/game.nim.html
title: cplib/utils/game.nim
---
