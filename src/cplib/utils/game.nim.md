---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  - icon: ':x:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  - icon: ':x:'
    path: verify/utils/game_warning_test.nim
    title: verify/utils/game_warning_test.nim
  - icon: ':x:'
    path: verify/utils/game_warning_test.nim
    title: verify/utils/game_warning_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_GAME:\n    const CPLIB_UTILS_GAME* = 1\n\n\
    \    import sets,tables,macros\n\n    type\n        NextStates*[T] = proc(state:\
    \ T): seq[T] {.closure.}\n        NextStatesByTurn*[T] = proc(state: T, is_first:\
    \ bool): seq[T] {.closure.}\n\n    macro check_game_next(nxt: typed): untyped\
    \ =\n        ## \u76F4\u63A5\u53C2\u7167\u3055\u308C\u308B\u5916\u90E8\u306E var\
    \ \u306B\u5BFE\u3057\u3066\u3001\u30E1\u30E2\u518D\u5229\u7528\u6642\u306E\u6CE8\
    \u610F\u3092\u8B66\u544A\u3057\u307E\u3059\u3002\n        result = nxt\n     \
    \   # Nim 1.6 \u3067\u578B\u691C\u67FB\u6E08\u307F\u306E\u7121\u540D\u95A2\u6570\
    \u304C\u518D\u5B9A\u7FA9\u6271\u3044\u306B\u306A\u308B\u306E\u3092\u9632\u304E\
    \u307E\u3059\u3002\n        if nxt.kind == nnkLambda:\n            result = nxt.copyNimTree\n\
    \            result[0] = newEmptyNode()\n        var implementation = nxt\n  \
    \      if implementation.kind == nnkSym:\n            if implementation.symKind\
    \ notin {nskProc, nskFunc}:\n                return\n            implementation\
    \ = implementation.getImpl\n        if implementation.kind notin {nnkProcDef,\
    \ nnkFuncDef, nnkLambda}:\n            return\n\n        const routineKinds =\
    \ {nnkProcDef, nnkFuncDef, nnkMethodDef,\n            nnkIteratorDef, nnkConverterDef,\
    \ nnkMacroDef, nnkTemplateDef,\n            nnkLambda, nnkDo}\n        var locals:\
    \ seq[NimNode]\n        var warned: seq[NimNode]\n\n        proc collect_locals(node:\
    \ NimNode) =\n            ## \u95A2\u6570\u672C\u4F53\u3067\u5BA3\u8A00\u3055\u308C\
    \u305F\u30ED\u30FC\u30AB\u30EB\u5909\u6570\u306E\u30B7\u30F3\u30DC\u30EB\u3092\
    \u96C6\u3081\u307E\u3059\u3002\n            if node.kind in routineKinds:\n  \
    \              return\n            if node.kind == nnkVarSection:\n          \
    \      for definition in node:\n                    if definition.kind in {nnkIdentDefs,\
    \ nnkVarTuple}:\n                        for i in 0..<definition.len - 2:\n  \
    \                          if definition[i].kind == nnkSym:\n                \
    \                locals.add(definition[i])\n            for child in node:\n \
    \               collect_locals(child)\n\n        proc inspect(node: NimNode) =\n\
    \            ## \u4ED6\u306E\u95A2\u6570\u306E\u672C\u4F53\u306B\u306F\u5165\u3089\
    \u305A\u3001\u5916\u90E8\u5909\u6570\u3054\u3068\u306B\u4E00\u5EA6\u3060\u3051\
    \u8B66\u544A\u3057\u307E\u3059\u3002\n            if node.kind in routineKinds:\n\
    \                return\n            if node.kind == nnkSym and node.symKind ==\
    \ nskVar and\n                    node notin locals and node notin warned:\n \
    \               warned.add(node)\n                warning(\"init_can_win: nxt\
    \ \u304C\u5916\u90E8\u306E var '\" & node.strVal &\n                    \"' \u3092\
    \u76F4\u63A5\u53C2\u7167\u3057\u3066\u3044\u307E\u3059\u3002\u5024\u3092\u5909\
    \u66F4\u3059\u308B\u3068\u30E1\u30E2\u304C\u4E0D\u6B63\u306B\u306A\u308B\u53EF\
    \u80FD\u6027\u304C\u3042\u308A\u307E\u3059\", node)\n            for child in\
    \ node:\n                inspect(child)\n\n        collect_locals(implementation.body)\n\
    \        inspect(implementation.body)\n\n    proc init_can_win_impl[T](nxt: NextStates[T],\n\
    \            win_when_no_moves: bool = false): proc(state: T): bool {.closure.}\
    \ =\n        ## \u30E1\u30E2\u3092\u4FDD\u6301\u3059\u308B\u5224\u5B9A\u95A2\u6570\
    \u306E\u5B9F\u88C5\u3092\u4F5C\u308A\u307E\u3059\u3002\n        var memo = initTable[T,\
    \ bool]()\n        var visiting = initHashSet[T]()\n\n        proc solve(state:\
    \ T): bool =\n            ## \u72B6\u614B\u306E\u52DD\u6557\u3092\u30E1\u30E2\u5316\
    \u3057\u3066\u6C42\u3081\u307E\u3059\u3002\n            if memo.hasKey(state):\n\
    \                return memo[state]\n            if state in visiting:\n     \
    \           raise newException(ValueError,\n                    \"can_win \u306F\
    \u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306E\u9589\u8DEF\u306B\u5BFE\u5FDC\u3057\
    \u3066\u3044\u307E\u305B\u3093\")\n\n            visiting.incl(state)\n      \
    \      defer: visiting.excl(state)\n            let next_states = nxt(state)\n\
    \            if next_states.len == 0:\n                result = win_when_no_moves\n\
    \            else:\n                result = false\n                for next_state\
    \ in next_states:\n                    if not solve(next_state):\n           \
    \             result = true\n                        break\n            memo[state]\
    \ = result\n\n        result = solve\n\n    proc init_can_win_impl[T](nxt: NextStatesByTurn[T],\n\
    \            win_when_no_moves: bool = false): proc(state: T): bool {.closure.}\
    \ =\n        ## \u30E1\u30E2\u3092\u4FDD\u6301\u3059\u308B\u5224\u5B9A\u95A2\u6570\
    \u306E\u5B9F\u88C5\u3092\u4F5C\u308A\u307E\u3059\u3002\n        type TurnState\
    \ = tuple[state: T, is_first: bool]\n        var memo = initTable[TurnState, bool]()\n\
    \        var visiting = initHashSet[TurnState]()\n\n        proc solve(state:\
    \ T, is_first: bool): bool =\n            ## \u72B6\u614B\u3068\u624B\u756A\u3054\
    \u3068\u306E\u52DD\u6557\u3092\u30E1\u30E2\u5316\u3057\u3066\u6C42\u3081\u307E\
    \u3059\u3002\n            let key = (state: state, is_first: is_first)\n     \
    \       if memo.hasKey(key):\n                return memo[key]\n            if\
    \ key in visiting:\n                raise newException(ValueError,\n         \
    \           \"can_win \u306F\u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306E\u9589\u8DEF\
    \u306B\u5BFE\u5FDC\u3057\u3066\u3044\u307E\u305B\u3093\")\n\n            visiting.incl(key)\n\
    \            defer: visiting.excl(key)\n            let next_states = nxt(state,\
    \ is_first)\n            if next_states.len == 0:\n                result = win_when_no_moves\n\
    \            else:\n                result = false\n                for next_state\
    \ in next_states:\n                    if not solve(next_state, not is_first):\n\
    \                        result = true\n                        break\n      \
    \      memo[key] = result\n\n        result = proc(state: T): bool =\n       \
    \     ## \u6307\u5B9A\u72B6\u614B\u304B\u3089\u5148\u624B\u304C\u5FC5\u52DD\u304B\
    \u3069\u3046\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\n            solve(state,\
    \ true)\n\n    template init_can_win*[T](nxt: NextStates[T],\n            win_when_no_moves:\
    \ bool = false): untyped =\n        ## \u624B\u756A\u5074\u304C\u5FC5\u52DD\u304B\
    \u3069\u3046\u304B\u3092\u5224\u5B9A\u3057\u3001\u547C\u3073\u51FA\u3057\u9593\
    \u3067\u30E1\u30E2\u3092\u518D\u5229\u7528\u3059\u308B\u95A2\u6570\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\n        ##\n        ## `nxt(state)` \u306F\u4E00\u624B\
    \u3067\u9077\u79FB\u3067\u304D\u308B\u3059\u3079\u3066\u306E\u72B6\u614B\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\n        ## \u5408\u6CD5\u624B\u304C\u306A\u3044\
    \u72B6\u614B\u3067\u306F\u3001`win_when_no_moves` \u304C true \u306E\u5834\u5408\
    \u306B\u9650\u308A\u624B\u756A\u5074\u306E\u52DD\u3061\u3068\u306A\u308A\u307E\
    \u3059\u3002\n        ## \u5230\u9054\u53EF\u80FD\u306A\u30B2\u30FC\u30E0\u30B0\
    \u30E9\u30D5\u306F\u6709\u9650\u3067\u3001\u9589\u8DEF\u3092\u6301\u305F\u306A\
    \u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ## \u8FD4\u3055\
    \u308C\u305F\u95A2\u6570\u3092\u4F7F\u3046\u9593\u3001`nxt` \u306E\u7D50\u679C\
    \u306F\u540C\u3058\u5F15\u6570\u306B\u5BFE\u3057\u3066\u5909\u5316\u3057\u306A\
    \u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ## \u30EB\u30FC\
    \u30EB\u3092\u5909\u66F4\u3059\u308B\u5834\u5408\u306F\u3001\u3053\u306E\u95A2\
    \u6570\u3067\u65B0\u3057\u304F\u5224\u5B9A\u95A2\u6570\u3092\u4F5C\u308A\u76F4\
    \u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        ## \u95A2\u6570\u540D\u307E\
    \u305F\u306F\u7121\u540D\u95A2\u6570\u3092\u76F4\u63A5\u6E21\u3059\u3068\u3001\
    \u76F4\u63A5\u53C2\u7167\u3059\u308B\u5916\u90E8\u306E var \u306B\u8B66\u544A\u3057\
    \u307E\u3059\u3002\n        ## \u5225\u306E\u95A2\u6570\u306E\u5185\u90E8\u3084\
    \u3001\u5909\u6570\u30FB\u5F15\u6570\u306B\u683C\u7D0D\u3055\u308C\u305F\u95A2\
    \u6570\u306F\u691C\u67FB\u3057\u307E\u305B\u3093\u3002\n        runnableExamples:\n\
    \            proc subtract(state: int): seq[int] =\n                for take in\
    \ 1..2:\n                    if take <= state:\n                        result.add(state\
    \ - take)\n\n            let solve = init_can_win(subtract)\n            assert\
    \ solve(3) == false\n            assert solve(4) == true\n            let misere\
    \ = init_can_win(subtract, win_when_no_moves = true)\n            assert misere(1)\
    \ == false\n\n        init_can_win_impl(check_game_next(nxt), win_when_no_moves)\n\
    \n    template init_can_win*[T](nxt: NextStatesByTurn[T],\n            win_when_no_moves:\
    \ bool = false): untyped =\n        ## \u5148\u624B\u304C\u5FC5\u52DD\u304B\u3069\
    \u3046\u304B\u3092\u5224\u5B9A\u3057\u3001\u547C\u3073\u51FA\u3057\u9593\u3067\
    \u30E1\u30E2\u3092\u518D\u5229\u7528\u3059\u308B\u95A2\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        ##\n        ## `nxt(state, is_first)` \u306F\u624B\
    \u756A\u5074\u306E\u30D7\u30EC\u30A4\u30E4\u30FC\u304C\u4E00\u624B\u3067\u9077\
    \u79FB\u3067\u304D\u308B\u3059\u3079\u3066\u306E\u72B6\u614B\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        ## `is_first` \u306F\u6700\u521D\u306E\u624B\u756A\
    \u3067\u306F true \u3067\u3001\u4E00\u624B\u3054\u3068\u306B\u53CD\u8EE2\u3057\
    \u307E\u3059\u3002\n        ## \u5408\u6CD5\u624B\u304C\u306A\u3044\u72B6\u614B\
    \u3067\u306F\u3001`win_when_no_moves` \u304C true \u306E\u5834\u5408\u306B\u9650\
    \u308A\u624B\u756A\u5074\u306E\u52DD\u3061\u3068\u306A\u308A\u307E\u3059\u3002\
    \n        ## \u5230\u9054\u53EF\u80FD\u306A\u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\
    \u306F\u6709\u9650\u3067\u3001\u9589\u8DEF\u3092\u6301\u305F\u306A\u3044\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ## \u8FD4\u3055\u308C\u305F\
    \u95A2\u6570\u3092\u4F7F\u3046\u9593\u3001`nxt` \u306E\u7D50\u679C\u306F\u540C\
    \u3058\u5F15\u6570\u306B\u5BFE\u3057\u3066\u5909\u5316\u3057\u306A\u3044\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ## \u30EB\u30FC\u30EB\u3092\
    \u5909\u66F4\u3059\u308B\u5834\u5408\u306F\u3001\u3053\u306E\u95A2\u6570\u3067\
    \u65B0\u3057\u304F\u5224\u5B9A\u95A2\u6570\u3092\u4F5C\u308A\u76F4\u3057\u3066\
    \u304F\u3060\u3055\u3044\u3002\n        ## \u95A2\u6570\u540D\u307E\u305F\u306F\
    \u7121\u540D\u95A2\u6570\u3092\u76F4\u63A5\u6E21\u3059\u3068\u3001\u76F4\u63A5\
    \u53C2\u7167\u3059\u308B\u5916\u90E8\u306E var \u306B\u8B66\u544A\u3057\u307E\u3059\
    \u3002\n        ## \u5225\u306E\u95A2\u6570\u306E\u5185\u90E8\u3084\u3001\u5909\
    \u6570\u30FB\u5F15\u6570\u306B\u683C\u7D0D\u3055\u308C\u305F\u95A2\u6570\u306F\
    \u691C\u67FB\u3057\u307E\u305B\u3093\u3002\n        runnableExamples:\n      \
    \      proc subtract_by_turn(state: int, is_first: bool): seq[int] =\n       \
    \         let max_take = (if is_first: 1 else: 2)\n                for take in\
    \ 1..max_take:\n                    if take <= state:\n                      \
    \  result.add(state - take)\n\n            let solve = init_can_win(subtract_by_turn)\n\
    \            assert solve(1) == true\n            assert solve(2) == false\n\n\
    \        init_can_win_impl(check_game_next(nxt), win_when_no_moves)\n\n    proc\
    \ can_win*[T](initial_state: T, nxt: NextStates[T],\n            win_when_no_moves:\
    \ bool = false): bool =\n        ## \u6307\u5B9A\u72B6\u614B\u3067\u624B\u756A\
    \u5074\u304C\u5FC5\u52DD\u304B\u3069\u3046\u304B\u3092\u3001\u547C\u3073\u51FA\
    \u3057\u3054\u3068\u306B\u65B0\u3057\u3044\u30E1\u30E2\u3067\u5224\u5B9A\u3057\
    \u307E\u3059\u3002\n        ## \u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306F\u6709\
    \u9650\u304B\u3064\u9589\u8DEF\u306A\u3057\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\u3002\n        result = init_can_win_impl(nxt, win_when_no_moves)(initial_state)\n\
    \n    proc can_win*[T](initial_state: T, nxt: NextStatesByTurn[T],\n         \
    \   win_when_no_moves: bool = false): bool =\n        ## \u6307\u5B9A\u72B6\u614B\
    \u304B\u3089\u5148\u624B\u304C\u5FC5\u52DD\u304B\u3069\u3046\u304B\u3092\u3001\
    \u547C\u3073\u51FA\u3057\u3054\u3068\u306B\u65B0\u3057\u3044\u30E1\u30E2\u3067\
    \u5224\u5B9A\u3057\u307E\u3059\u3002\n        ## \u30B2\u30FC\u30E0\u30B0\u30E9\
    \u30D5\u306F\u6709\u9650\u304B\u3064\u9589\u8DEF\u306A\u3057\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        result = init_can_win_impl(nxt,\
    \ win_when_no_moves)(initial_state)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/game.nim
  requiredBy: []
  timestamp: '2026-09-09 16:56:35+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/utils/game_warning_test.nim
  - verify/utils/game_warning_test.nim
  - verify/utils/game_test.nim
  - verify/utils/game_test.nim
documentation_of: cplib/utils/game.nim
layout: document
redirect_from:
- /library/cplib/utils/game.nim
- /library/cplib/utils/game.nim.html
title: cplib/utils/game.nim
---
