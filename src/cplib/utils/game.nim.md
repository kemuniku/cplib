---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_grundy_test.nim
    title: verify/utils/game_grundy_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_grundy_test.nim
    title: verify/utils/game_grundy_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_optimal_play_test.nim
    title: verify/utils/game_optimal_play_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_optimal_play_test.nim
    title: verify/utils/game_optimal_play_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_test.nim
    title: verify/utils/game_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_warning_test.nim
    title: verify/utils/game_warning_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/game_warning_test.nim
    title: verify/utils/game_warning_test.nim
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
    \    import sets,tables,macros\n\n    type\n        NextStates*[T] = proc(state:\
    \ T): seq[T] {.closure.}\n        NextStatesByTurn*[T] = proc(state: T, is_first:\
    \ bool): seq[T] {.closure.}\n\n    macro check_game_next(nxt: typed, caller: static[string]\
    \ = \"init_can_win\",\n            argument: static[string] = \"nxt\"): untyped\
    \ =\n        ## \u76F4\u63A5\u53C2\u7167\u3055\u308C\u308B\u5916\u90E8\u306E var\
    \ \u306B\u5BFE\u3057\u3066\u3001\u30E1\u30E2\u518D\u5229\u7528\u6642\u306E\u6CE8\
    \u610F\u3092\u8B66\u544A\u3057\u307E\u3059\u3002\n        let caller_name = caller\n\
    \        let argument_name = argument\n        result = nxt\n        # Nim 1.6\
    \ \u3067\u578B\u691C\u67FB\u6E08\u307F\u306E\u7121\u540D\u95A2\u6570\u304C\u518D\
    \u5B9A\u7FA9\u6271\u3044\u306B\u306A\u308B\u306E\u3092\u9632\u304E\u307E\u3059\
    \u3002\n        if nxt.kind == nnkLambda:\n            result = nxt.copyNimTree\n\
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
    \               warned.add(node)\n                warning(caller_name & \": \"\
    \ & argument_name & \" \u304C\u5916\u90E8\u306E var '\" & node.strVal &\n    \
    \                \"' \u3092\u76F4\u63A5\u53C2\u7167\u3057\u3066\u3044\u307E\u3059\
    \u3002\u5024\u3092\u5909\u66F4\u3059\u308B\u3068\u30E1\u30E2\u304C\u4E0D\u6B63\
    \u306B\u306A\u308B\u53EF\u80FD\u6027\u304C\u3042\u308A\u307E\u3059\", node)\n\
    \            for child in node:\n                inspect(child)\n\n        collect_locals(implementation.body)\n\
    \        inspect(implementation.body)\n\n    proc init_grundy_impl[T](nxt: NextStates[T]):\
    \ proc(state: T): int {.closure.} =\n        ## Grundy \u6570\u306E\u30E1\u30E2\
    \u3092\u4FDD\u6301\u3059\u308B\u8A08\u7B97\u95A2\u6570\u3092\u4F5C\u308A\u307E\
    \u3059\u3002\n        var memo = initTable[T, int]()\n        var visiting = initHashSet[T]()\n\
    \n        proc solve(state: T): int =\n            ## \u9077\u79FB\u5148\u306E\
    \ Grundy \u6570\u306E mex \u3092\u30E1\u30E2\u5316\u3057\u3066\u6C42\u3081\u307E\
    \u3059\u3002\n            if memo.hasKey(state):\n                return memo[state]\n\
    \            if state in visiting:\n                raise newException(ValueError,\n\
    \                    \"grundy \u306F\u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306E\
    \u9589\u8DEF\u306B\u5BFE\u5FDC\u3057\u3066\u3044\u307E\u305B\u3093\")\n      \
    \      visiting.incl(state)\n            defer: visiting.excl(state)\n       \
    \     let next_states = nxt(state)\n            var seen = newSeq[bool](next_states.len\
    \ + 1)\n            for next_state in next_states:\n                let value\
    \ = solve(next_state)\n                if value < seen.len:\n                \
    \    seen[value] = true\n            while seen[result]:\n                inc\
    \ result\n            memo[state] = result\n\n        result = solve\n\n    template\
    \ init_grundy*[T](nxt: NextStates[T]): untyped =\n        ## Grundy \u6570\u3092\
    \u8A08\u7B97\u3057\u3001\u547C\u3073\u51FA\u3057\u9593\u3067\u30E1\u30E2\u3092\
    \u518D\u5229\u7528\u3059\u308B\u95A2\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        ## \u4E21\u8005\u306E\u5408\u6CD5\u624B\u304C\u540C\u3058\u3067\u3001\
    \u5408\u6CD5\u624B\u304C\u306A\u3044\u5074\u304C\u8CA0\u3051\u308B\u6709\u9650\
    \u304B\u3064\u9589\u8DEF\u306A\u3057\u306E\u30B2\u30FC\u30E0\u3092\u5BFE\u8C61\
    \u3068\u3057\u307E\u3059\u3002\n        ## \u9077\u79FB\u5148\u306E Grundy \u6570\
    \u306B\u542B\u307E\u308C\u306A\u3044\u6700\u5C0F\u306E\u975E\u8CA0\u6574\u6570\
    \u3092\u8FD4\u3057\u3001\u7D42\u7AEF\u72B6\u614B\u3067\u306F 0 \u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        ## \u5024\u304C 0 \u306A\u3089\u624B\u756A\u5074\u306E\
    \u8CA0\u3051\u3001\u305D\u308C\u4EE5\u5916\u306A\u3089\u52DD\u3061\u3067\u3059\
    \u3002\u72EC\u7ACB\u306A\u30B2\u30FC\u30E0\u306E\u548C\u306F\u5024\u306E xor \u3067\
    \u6C42\u3081\u3089\u308C\u307E\u3059\u3002\n        ## \u8FD4\u3055\u308C\u305F\
    \u95A2\u6570\u3092\u4F7F\u3046\u9593\u3001nxt \u306E\u7D50\u679C\u306F\u540C\u3058\
    \u5F15\u6570\u306B\u5BFE\u3057\u3066\u5909\u5316\u3057\u306A\u3044\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\u3002\n        ## \u30EB\u30FC\u30EB\u3092\u5909\
    \u66F4\u3059\u308B\u5834\u5408\u306F\u3001\u3053\u306E\u95A2\u6570\u3067\u65B0\
    \u3057\u304F\u8A08\u7B97\u95A2\u6570\u3092\u4F5C\u308A\u76F4\u3057\u3066\u304F\
    \u3060\u3055\u3044\u3002\n        ## \u5916\u90E8\u306E var \u3078\u306E\u8B66\
    \u544A\u306F init_can_win \u3068\u540C\u3058\u7BC4\u56F2\u3067\u3059\u3002\n \
    \       ## \u65B0\u305F\u306B\u63A2\u7D22\u3059\u308B\u72B6\u614B\u6570 V\u3001\
    \u9077\u79FB\u6570 E \u306B\u5BFE\u3057\u3066\u6642\u9593 O(V + E)\u3001\u63A2\
    \u7D22\u4E2D\u306E\u88DC\u52A9\u7A7A\u9593 O(V + E) \u3067\u3059\u3002\n     \
    \   ## \u30E1\u30E2\u306F\u7D2F\u8A08\u72B6\u614B\u6570\u306B\u6BD4\u4F8B\u3059\
    \u308B\u7A7A\u9593\u3092\u4F7F\u3044\u3001\u8A55\u4FA1\u6E08\u307F\u306E\u72B6\
    \u614B\u3078\u306E\u554F\u3044\u5408\u308F\u305B\u306F O(1) \u3067\u3059\u3002\
    \n        ## \uFF08\u72B6\u614B\u306E\u30CF\u30C3\u30B7\u30E5\u30FB\u6BD4\u8F03\
    \u30FB\u30B3\u30D4\u30FC\u3092 O(1)\u3001nxt \u3092\u5217\u6319\u6570\u306B\u6BD4\
    \u4F8B\u3059\u308B\u6642\u9593\u3068\u3057\u305F\u5834\u5408\uFF09\u3002\n   \
    \     runnableExamples:\n            proc subtract(state: int): seq[int] =\n \
    \               for take in 1..2:\n                    if take <= state:\n   \
    \                     result.add(state - take)\n\n            let solve = init_grundy(subtract)\n\
    \            assert solve(0) == 0\n            assert solve(2) == 2\n        \
    \    assert solve(4) == 1\n\n        init_grundy_impl(check_game_next(nxt, \"\
    init_grundy\"))\n\n    proc grundy*[T](initial_state: T, nxt: NextStates[T]):\
    \ int =\n        ## \u6307\u5B9A\u72B6\u614B\u306E Grundy \u6570\u3092\u3001\u547C\
    \u3073\u51FA\u3057\u3054\u3068\u306B\u65B0\u3057\u3044\u30E1\u30E2\u3067\u8A08\
    \u7B97\u3057\u307E\u3059\u3002\n        ## \u5BFE\u8C61\u30B2\u30FC\u30E0\u30FB\
    \u8A08\u7B97\u91CF\u306F init_grundy \u3068\u540C\u3058\u3067\u3001nxt \u306E\u7D50\
    \u679C\u306F\u547C\u3073\u51FA\u3057\u4E2D\u4E00\u5B9A\u3068\u3057\u307E\u3059\
    \u3002\n        result = init_grundy_impl(nxt)(initial_state)\n\n    proc init_can_win_impl[T](nxt:\
    \ NextStates[T],\n            win_when_no_moves: bool = false): proc(state: T):\
    \ bool {.closure.} =\n        ## \u30E1\u30E2\u3092\u4FDD\u6301\u3059\u308B\u5224\
    \u5B9A\u95A2\u6570\u306E\u5B9F\u88C5\u3092\u4F5C\u308A\u307E\u3059\u3002\n   \
    \     var memo = initTable[T, bool]()\n        var visiting = initHashSet[T]()\n\
    \n        proc solve(state: T): bool =\n            ## \u72B6\u614B\u306E\u52DD\
    \u6557\u3092\u30E1\u30E2\u5316\u3057\u3066\u6C42\u3081\u307E\u3059\u3002\n   \
    \         if memo.hasKey(state):\n                return memo[state]\n       \
    \     if state in visiting:\n                raise newException(ValueError,\n\
    \                    \"can_win \u306F\u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306E\
    \u9589\u8DEF\u306B\u5BFE\u5FDC\u3057\u3066\u3044\u307E\u305B\u3093\")\n\n    \
    \        visiting.incl(state)\n            defer: visiting.excl(state)\n     \
    \       let next_states = nxt(state)\n            if next_states.len == 0:\n \
    \               result = win_when_no_moves\n            else:\n              \
    \  result = false\n                for next_state in next_states:\n          \
    \          if not solve(next_state):\n                        result = true\n\
    \                        break\n            memo[state] = result\n\n        result\
    \ = solve\n\n    proc init_can_win_impl[T](nxt: NextStatesByTurn[T],\n       \
    \     win_when_no_moves: bool = false): proc(state: T): bool {.closure.} =\n \
    \       ## \u30E1\u30E2\u3092\u4FDD\u6301\u3059\u308B\u5224\u5B9A\u95A2\u6570\u306E\
    \u5B9F\u88C5\u3092\u4F5C\u308A\u307E\u3059\u3002\n        type TurnState = tuple[state:\
    \ T, is_first: bool]\n        var memo = initTable[TurnState, bool]()\n      \
    \  var visiting = initHashSet[TurnState]()\n\n        proc solve(state: T, is_first:\
    \ bool): bool =\n            ## \u72B6\u614B\u3068\u624B\u756A\u3054\u3068\u306E\
    \u52DD\u6557\u3092\u30E1\u30E2\u5316\u3057\u3066\u6C42\u3081\u307E\u3059\u3002\
    \n            let key = (state: state, is_first: is_first)\n            if memo.hasKey(key):\n\
    \                return memo[key]\n            if key in visiting:\n         \
    \       raise newException(ValueError,\n                    \"can_win \u306F\u30B2\
    \u30FC\u30E0\u30B0\u30E9\u30D5\u306E\u9589\u8DEF\u306B\u5BFE\u5FDC\u3057\u3066\
    \u3044\u307E\u305B\u3093\")\n\n            visiting.incl(key)\n            defer:\
    \ visiting.excl(key)\n            let next_states = nxt(state, is_first)\n   \
    \         if next_states.len == 0:\n                result = win_when_no_moves\n\
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
    \ win_when_no_moves)(initial_state)\n\n    proc init_optimal_play_impl[T](nxt:\
    \ NextStates[T],\n            win_when_no_moves: bool = false,\n            prefer:\
    \ proc(a, b: T): bool {.closure.} = nil):\n            proc(state: T): tuple[is_win:\
    \ bool, states: seq[T]] {.closure.} =\n        ## \u52DD\u6557\u30FB\u7D42\u5C40\
    \u624B\u6570\u30FB\u9077\u79FB\u5148\u306E\u30E1\u30E2\u3092\u4FDD\u6301\u3059\
    \u308B\u5FA9\u5143\u95A2\u6570\u3092\u4F5C\u308A\u307E\u3059\u3002\n        type\
    \ Evaluation = tuple[winning: bool, turns: int, next_state: T]\n        var memo\
    \ = initTable[T, Evaluation]()\n        var visiting = initHashSet[T]()\n\n  \
    \      proc solve(state: T): Evaluation =\n            ## \u52DD\u6557\u30FB\u6700\
    \u9069\u306A\u7D42\u5C40\u624B\u6570\u30FB\u9077\u79FB\u5148\u3092\u30E1\u30E2\
    \u5316\u3057\u3066\u6C42\u3081\u307E\u3059\u3002\n            if memo.hasKey(state):\n\
    \                return memo[state]\n            if state in visiting:\n     \
    \           raise newException(ValueError,\n                    \"optimal_play\
    \ \u306F\u30B2\u30FC\u30E0\u30B0\u30E9\u30D5\u306E\u9589\u8DEF\u306B\u5BFE\u5FDC\
    \u3057\u3066\u3044\u307E\u305B\u3093\")\n            visiting.incl(state)\n  \
    \          defer: visiting.excl(state)\n            let next_states = nxt(state)\n\
    \            result = (winning: win_when_no_moves, turns: 0, next_state: state)\n\
    \            for i, next_state in next_states:\n                let child = solve(next_state)\n\
    \                let winning = not child.winning\n                let turns =\
    \ child.turns + 1\n                if i == 0 or (winning and not result.winning)\
    \ or\n                        (winning == result.winning and\n               \
    \             ((winning and turns < result.turns) or\n                       \
    \      (not winning and turns > result.turns) or\n                           \
    \  (turns == result.turns and prefer != nil and\n                            \
    \  prefer(next_state, result.next_state)))):\n                    result = (winning:\
    \ winning, turns: turns, next_state: next_state)\n            memo[state] = result\n\
    \n        result = proc(initial_state: T): tuple[is_win: bool, states: seq[T]]\
    \ =\n            ## \u521D\u671F\u72B6\u614B\u306E\u52DD\u6557\u3068\u3001\u30E1\
    \u30E2\u3092\u7528\u3044\u3066\u5FA9\u5143\u3057\u305F\u72B6\u614B\u5217\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u5FA9\u5143\u306F O(\u5217\u306E\u9577\u3055) \u3067\
    \u3059\u3002\n            result.is_win = solve(initial_state).winning\n     \
    \       var state = initial_state\n            result.states.add(state)\n    \
    \        while memo[state].turns > 0:\n                state = memo[state].next_state\n\
    \                result.states.add(state)\n\n    proc init_optimal_play_impl[T](nxt:\
    \ NextStatesByTurn[T],\n            win_when_no_moves: bool = false,\n       \
    \     prefer: proc(a, b: T): bool {.closure.} = nil):\n            proc(state:\
    \ T): tuple[is_win: bool, states: seq[T]] {.closure.} =\n        ## \u72B6\u614B\
    \u3068\u624B\u756A\u3054\u3068\u306E\u30E1\u30E2\u3092\u4FDD\u6301\u3059\u308B\
    \u5FA9\u5143\u95A2\u6570\u3092\u4F5C\u308A\u307E\u3059\u3002\n        type TurnState\
    \ = tuple[state: T, is_first: bool]\n        proc next_by_turn(current: TurnState):\
    \ seq[TurnState] =\n            ## \u72B6\u614B\u306B\u624B\u756A\u3092\u4ED8\u3051\
    \u3066\u9077\u79FB\u3092\u5217\u6319\u3057\u307E\u3059\u3002\n            for\
    \ next_state in nxt(current.state, current.is_first):\n                result.add((state:\
    \ next_state, is_first: not current.is_first))\n\n        var prefer_by_turn:\
    \ proc(a, b: TurnState): bool {.closure.}\n        if prefer != nil:\n       \
    \     prefer_by_turn = proc(a, b: TurnState): bool =\n                ## \u624B\
    \u756A\u3092\u9664\u3044\u305F\u9077\u79FB\u5148\u306E\u72B6\u614B\u3092\u6BD4\
    \u8F03\u3057\u307E\u3059\u3002\n                prefer(a.state, b.state)\n   \
    \     let solve = init_optimal_play_impl(next_by_turn, win_when_no_moves, prefer_by_turn)\n\
    \        result = proc(initial_state: T): tuple[is_win: bool, states: seq[T]]\
    \ =\n            ## \u6307\u5B9A\u72B6\u614B\u304B\u3089\u5148\u624B\u304C\u5FC5\
    \u52DD\u304B\u3069\u3046\u304B\u3068\u72B6\u614B\u5217\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n            let play = solve((state: initial_state, is_first: true))\n\
    \            result.is_win = play.is_win\n            for current in play.states:\n\
    \                result.states.add(current.state)\n\n    template init_optimal_play*[T](nxt:\
    \ NextStates[T],\n            win_when_no_moves: bool = false): untyped =\n  \
    \      ## \u52DD\u6557\u3068\u6700\u9069\u306A\u72B6\u614B\u5217\u3092\u8FD4\u3057\
    \u3001\u547C\u3073\u51FA\u3057\u9593\u3067\u30E1\u30E2\u3092\u518D\u5229\u7528\
    \u3059\u308B\u95A2\u6570\u3092\u4F5C\u308A\u307E\u3059\u3002\n        ## \u8FD4\
    \u308A\u5024\u306F tuple[is_win: bool, states: seq[T]] \u3067\u3001is_win \u306F\
    \u521D\u671F\u72B6\u614B\u306E\u624B\u756A\u5074\u304C\u5FC5\u52DD\u304B\u3092\
    \u8868\u3057\u307E\u3059\u3002\n        ## states \u306F\u521D\u671F\u72B6\u614B\
    \u3068\u7D42\u7AEF\u72B6\u614B\u3092\u542B\u307F\u3001\u521D\u671F\u72B6\u614B\
    \u304C\u7D42\u7AEF\u306A\u3089\u8981\u7D20\u6570\u306F 1 \u3067\u3059\u3002\n\
    \        ## \u52DD\u3066\u308B\u5C40\u9762\u3067\u306F\u52DD\u3064\u307E\u3067\
    \u306E\u624B\u6570\u3092\u6700\u5C0F\u5316\u3057\u3001\u8CA0\u3051\u308B\u5C40\
    \u9762\u3067\u306F\u8CA0\u3051\u308B\u307E\u3067\u306E\u624B\u6570\u3092\u6700\
    \u5927\u5316\u3057\u307E\u3059\u3002\n        ## \u52DD\u6557\u3068\u624B\u6570\
    \u304C\u540C\u3058\u306A\u3089 nxt \u306E\u9806\u3067\u9078\u3073\u307E\u3059\u3002\
    \n        ## \u5408\u6CD5\u624B\u304C\u306A\u3044\u72B6\u614B\u3067\u306F\u3001\
    win_when_no_moves \u304C true \u306E\u5834\u5408\u306B\u9650\u308A\u624B\u756A\
    \u5074\u306E\u52DD\u3061\u3068\u306A\u308A\u307E\u3059\u3002\n        ## \u30B2\
    \u30FC\u30E0\u30B0\u30E9\u30D5\u306F\u6709\u9650\u304B\u3064\u9589\u8DEF\u306A\
    \u3057\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n   \
    \     ## \u8FD4\u3055\u308C\u305F\u95A2\u6570\u3092\u4F7F\u3046\u9593\u3001nxt\
    \ \u306E\u7D50\u679C\u306F\u540C\u3058\u5F15\u6570\u306B\u5BFE\u3057\u3066\u5909\
    \u5316\u3057\u306A\u3044\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n   \
    \     ## \u30EB\u30FC\u30EB\u3092\u5909\u66F4\u3059\u308B\u5834\u5408\u306F\u3001\
    \u3053\u306E\u95A2\u6570\u3067\u65B0\u3057\u304F\u5FA9\u5143\u95A2\u6570\u3092\
    \u4F5C\u308A\u76F4\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        ## init_can_win\
    \ \u3068\u540C\u69D8\u3001\u76F4\u63A5\u6E21\u3057\u305F\u95A2\u6570\u30FB\u7121\
    \u540D\u95A2\u6570\u304C\u76F4\u63A5\u53C2\u7167\u3059\u308B\u5916\u90E8\u306E\
    \ var \u306B\u8B66\u544A\u3057\u307E\u3059\u3002\n        ## \u5225\u306E\u95A2\
    \u6570\u306E\u5185\u90E8\u3084\u3001\u5909\u6570\u30FB\u5F15\u6570\u306B\u683C\
    \u7D0D\u3055\u308C\u305F\u95A2\u6570\u306F\u691C\u67FB\u3057\u307E\u305B\u3093\
    \u3002\n        ## \u65B0\u305F\u306B\u63A2\u7D22\u3059\u308B\u72B6\u614B\u6570\
    \ V\u3001\u9077\u79FB\u6570 E\u3001\u8FD4\u3059\u5217\u306E\u9577\u3055 L \u306B\
    \u5BFE\u3057\u3066\u6642\u9593 O(V + E + L) \u3067\u3059\u3002\n        ## \u30E1\
    \u30E2\u306F\u7D2F\u8A08\u72B6\u614B\u6570\u306B\u6BD4\u4F8B\u3059\u308B\u7A7A\
    \u9593\u3092\u4F7F\u3044\u3001\u63A2\u7D22\u4E2D\u306F\u3055\u3089\u306B O(V +\
    \ E) \u306E\u88DC\u52A9\u7A7A\u9593\u3092\u4F7F\u3044\u307E\u3059\u3002\n    \
    \    ## \uFF08\u72B6\u614B\u306E\u30CF\u30C3\u30B7\u30E5\u30FB\u6BD4\u8F03\u30FB\
    \u30B3\u30D4\u30FC\u3092 O(1)\u3001nxt \u3092\u5217\u6319\u6570\u306B\u6BD4\u4F8B\
    \u3059\u308B\u6642\u9593\u3068\u3057\u305F\u5834\u5408\uFF09\u3002\n        runnableExamples:\n\
    \            proc subtract(state: int): seq[int] =\n                for take in\
    \ 1..2:\n                    if take <= state:\n                        result.add(state\
    \ - take)\n\n            let solve = init_optimal_play(subtract)\n           \
    \ assert solve(4) == (is_win: true, states: @[4, 3, 2, 0])\n            assert\
    \ solve(3) == (is_win: false, states: @[3, 2, 0])\n\n        init_optimal_play_impl(check_game_next(nxt,\
    \ \"init_optimal_play\"), win_when_no_moves)\n\n    template init_optimal_play*[T](nxt:\
    \ NextStatesByTurn[T],\n            win_when_no_moves: bool = false): untyped\
    \ =\n        ## \u624B\u756A\u5225\u306E\u30EB\u30FC\u30EB\u3067\u52DD\u6557\u3068\
    \u6700\u9069\u306A\u72B6\u614B\u5217\u3092\u8FD4\u3057\u3001\u547C\u3073\u51FA\
    \u3057\u9593\u3067\u30E1\u30E2\u3092\u518D\u5229\u7528\u3059\u308B\u95A2\u6570\
    \u3092\u4F5C\u308A\u307E\u3059\u3002\n        ## \u8FD4\u308A\u5024\u306F tuple[is_win:\
    \ bool, states: seq[T]] \u3067\u3001is_win \u306F\u5148\u624B\u304C\u5FC5\u52DD\
    \u304B\u3092\u8868\u3057\u307E\u3059\u3002\n        ## \u5404\u547C\u3073\u51FA\
    \u3057\u306F\u5148\u624B\u304B\u3089\u59CB\u307E\u308A\u3001states \u306E\u5076\
    \u6570\u756A\u76EE\u3067\u306F is_first = true\u3001\u5947\u6570\u756A\u76EE\u3067\
    \u306F false \u3067\u3059\u3002\n        ## \u72B6\u614B\u3068\u624B\u756A\u306E\
    \u7D44\u3054\u3068\u306B\u30E1\u30E2\u5316\u3057\u307E\u3059\u3002\n        ##\
    \ \u9078\u629E\u898F\u5247\u30FB\u524D\u63D0\u30FB\u5916\u90E8\u5909\u6570\u3078\
    \u306E\u8B66\u544A\u30FB\u8A08\u7B97\u91CF\u306F\u624B\u756A\u306B\u3088\u3089\
    \u306A\u3044 init_optimal_play \u3068\u540C\u3058\u3067\u3059\u3002\n        init_optimal_play_impl(check_game_next(nxt,\
    \ \"init_optimal_play\"), win_when_no_moves)\n\n    proc optimal_play*[T](initial_state:\
    \ T, nxt: NextStates[T],\n            win_when_no_moves: bool = false): tuple[is_win:\
    \ bool, states: seq[T]] =\n        ## \u547C\u3073\u51FA\u3057\u3054\u3068\u306B\
    \u65B0\u3057\u3044\u30E1\u30E2\u3067\u3001\u624B\u756A\u5074\u304C\u5FC5\u52DD\
    \u304B\u3069\u3046\u304B\u3068\u521D\u671F\u72B6\u614B\u304B\u3089\u7D42\u7AEF\
    \u72B6\u614B\u307E\u3067\u306E\u72B6\u614B\u5217\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        ## \u9078\u629E\u898F\u5247\u30FB\u524D\u63D0\u30FB\u8A08\u7B97\
    \u91CF\u306F init_optimal_play \u3068\u540C\u3058\u3067\u3001nxt \u306E\u7D50\u679C\
    \u306F\u547C\u3073\u51FA\u3057\u4E2D\u4E00\u5B9A\u3068\u3057\u307E\u3059\u3002\
    \n        result = init_optimal_play_impl(nxt, win_when_no_moves)(initial_state)\n\
    \n    proc optimal_play*[T](initial_state: T, nxt: NextStatesByTurn[T],\n    \
    \        win_when_no_moves: bool = false): tuple[is_win: bool, states: seq[T]]\
    \ =\n        ## \u624B\u756A\u5225\u306E\u30EB\u30FC\u30EB\u3067\u3001\u5148\u624B\
    \u304C\u5FC5\u52DD\u304B\u3069\u3046\u304B\u3068\u521D\u671F\u72B6\u614B\u304B\
    \u3089\u7D42\u7AEF\u72B6\u614B\u307E\u3067\u306E\u72B6\u614B\u5217\u3092\u65B0\
    \u3057\u3044\u30E1\u30E2\u3067\u8FD4\u3057\u307E\u3059\u3002\n        ## \u624B\
    \u756A\u30FB\u9078\u629E\u898F\u5247\u30FB\u524D\u63D0\u30FB\u8A08\u7B97\u91CF\
    \u306F init_optimal_play \u3068\u540C\u3058\u3067\u3001nxt \u306E\u7D50\u679C\u306F\
    \u547C\u3073\u51FA\u3057\u4E2D\u4E00\u5B9A\u3068\u3057\u307E\u3059\u3002\n   \
    \     result = init_optimal_play_impl(nxt, win_when_no_moves)(initial_state)\n\
    \n    proc init_optimal_play_evaluated_impl[T, S](nxt: NextStates[T],\n      \
    \      evaluate: proc(state: T): S {.closure.}, win_when_no_moves: bool):\n  \
    \          proc(state: T): tuple[is_win: bool, states: seq[T]] {.closure.} =\n\
    \        ## \u9077\u79FB\u5148\u306E\u8A55\u4FA1\u5024\u3067\u540C\u9806\u4F4D\
    \u306E\u5019\u88DC\u3092\u6BD4\u8F03\u3059\u308B\u5FA9\u5143\u95A2\u6570\u3092\
    \u4F5C\u308A\u307E\u3059\u3002\n        proc prefer(a, b: T): bool =\n       \
    \     ## \u8A55\u4FA1\u5024\u304C\u53B3\u5BC6\u306B\u5927\u304D\u3044\u5019\u88DC\
    \u3092\u512A\u5148\u3057\u307E\u3059\u3002\n            evaluate(b) < evaluate(a)\n\
    \        init_optimal_play_impl(nxt, win_when_no_moves, prefer)\n\n    proc init_optimal_play_evaluated_impl[T,\
    \ S](nxt: NextStatesByTurn[T],\n            evaluate: proc(state: T): S {.closure.},\
    \ win_when_no_moves: bool):\n            proc(state: T): tuple[is_win: bool, states:\
    \ seq[T]] {.closure.} =\n        ## \u624B\u756A\u5225\u306E\u30EB\u30FC\u30EB\
    \u3067\u3001\u9077\u79FB\u5148\u306E\u8A55\u4FA1\u5024\u306B\u3088\u308B\u512A\
    \u5148\u9806\u4F4D\u3092\u8A2D\u5B9A\u3057\u307E\u3059\u3002\n        proc prefer(a,\
    \ b: T): bool =\n            ## \u8A55\u4FA1\u5024\u304C\u53B3\u5BC6\u306B\u5927\
    \u304D\u3044\u5019\u88DC\u3092\u512A\u5148\u3057\u307E\u3059\u3002\n         \
    \   evaluate(b) < evaluate(a)\n        init_optimal_play_impl(nxt, win_when_no_moves,\
    \ prefer)\n\n    template init_optimal_play*[T, S](nxt: NextStates[T],\n     \
    \       evaluate: proc(state: T): S {.closure.},\n            win_when_no_moves:\
    \ bool = false): untyped =\n        ## \u52DD\u6557\u3068\u7D42\u5C40\u624B\u6570\
    \u304C\u540C\u3058\u5019\u88DC\u306F\u3001\u9077\u79FB\u5148\u306E evaluate(state)\
    \ \u304C\u5927\u304D\u3044\u624B\u3092\u512A\u5148\u3057\u3066\u30E1\u30E2\u5316\
    \u3057\u307E\u3059\u3002\n        ## \u4E21\u30D7\u30EC\u30A4\u30E4\u30FC\u3068\
    \u3082\u8A55\u4FA1\u5024\u3092\u6700\u5927\u5316\u3057\u3001\u8A55\u4FA1\u5024\
    \u3082\u540C\u3058\u306A\u3089 nxt \u306E\u9806\u3067\u9078\u3073\u307E\u3059\u3002\
    \n        ## S \u306F < \u3067\u6BD4\u8F03\u53EF\u80FD\u306A\u578B\u3068\u3057\
    \u307E\u3059\u3002\u8A55\u4FA1\u5024\u306F\u72B6\u614B\u5217\u5168\u4F53\u306E\
    \u5408\u8A08\u3067\u306F\u3042\u308A\u307E\u305B\u3093\u3002\n        ## \u5FA9\
    \u5143\u95A2\u6570\u3092\u4F7F\u3046\u9593\u3001evaluate \u306E\u7D50\u679C\u3082\
    \u540C\u3058\u5F15\u6570\u306B\u5BFE\u3057\u3066\u5909\u5316\u3057\u306A\u3044\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\n        ## nxt \u3068 evaluate\
    \ \u304C\u76F4\u63A5\u53C2\u7167\u3059\u308B\u5916\u90E8\u306E var \u3078\u306E\
    \u8B66\u544A\u306F init_can_win \u3068\u540C\u3058\u7BC4\u56F2\u3067\u3059\u3002\
    \n        ## \u305D\u306E\u4ED6\u306E\u4ED5\u69D8\u306F\u8A55\u4FA1\u95A2\u6570\
    \u306A\u3057\u306E init_optimal_play \u3068\u540C\u3058\u3067\u3059\u3002\n  \
    \      ## evaluate \u3068\u8A55\u4FA1\u5024\u306E\u6BD4\u8F03\u304C O(1) \u306A\
    \u3089\u8A08\u7B97\u91CF\u3082\u540C\u3058\u3067\u3059\u3002\n        init_optimal_play_evaluated_impl(\n\
    \            check_game_next(nxt, \"init_optimal_play\"),\n            check_game_next(evaluate,\
    \ \"init_optimal_play\", \"evaluate\"), win_when_no_moves)\n\n    template init_optimal_play*[T,\
    \ S](nxt: NextStatesByTurn[T],\n            evaluate: proc(state: T): S {.closure.},\n\
    \            win_when_no_moves: bool = false): untyped =\n        ## \u624B\u756A\
    \u5225\u306E\u30EB\u30FC\u30EB\u3067\u3001\u52DD\u6557\u3068\u7D42\u5C40\u624B\
    \u6570\u304C\u540C\u3058\u5019\u88DC\u306F\u9077\u79FB\u5148\u306E\u8A55\u4FA1\
    \u5024\u304C\u5927\u304D\u3044\u624B\u3092\u512A\u5148\u3057\u307E\u3059\u3002\
    \n        ## \u8A55\u4FA1\u95A2\u6570\u306E\u4ED5\u69D8\u3068\u524D\u63D0\u306F\
    \u624B\u756A\u306B\u3088\u3089\u306A\u3044\u8A55\u4FA1\u95A2\u6570\u4ED8\u304D\
    \ init_optimal_play \u3068\u540C\u3058\u3067\u3059\u3002\n        init_optimal_play_evaluated_impl(\n\
    \            check_game_next(nxt, \"init_optimal_play\"),\n            check_game_next(evaluate,\
    \ \"init_optimal_play\", \"evaluate\"), win_when_no_moves)\n\n    proc optimal_play*[T,\
    \ S](initial_state: T, nxt: NextStates[T],\n            evaluate: proc(state:\
    \ T): S {.closure.},\n            win_when_no_moves: bool = false): tuple[is_win:\
    \ bool, states: seq[T]] =\n        ## \u8A55\u4FA1\u95A2\u6570\u4ED8\u304D init_optimal_play\
    \ \u3068\u540C\u3058\u898F\u5247\u3067\u3001\u547C\u3073\u51FA\u3057\u3054\u3068\
    \u306B\u65B0\u3057\u3044\u30E1\u30E2\u3092\u4F7F\u3063\u3066\u5FA9\u5143\u3057\
    \u307E\u3059\u3002\n        ## nxt \u3068 evaluate \u306E\u7D50\u679C\u306F\u547C\
    \u3073\u51FA\u3057\u4E2D\u4E00\u5B9A\u3068\u3057\u307E\u3059\u3002\n        result\
    \ = init_optimal_play_evaluated_impl(nxt, evaluate, win_when_no_moves)(initial_state)\n\
    \n    proc optimal_play*[T, S](initial_state: T, nxt: NextStatesByTurn[T],\n \
    \           evaluate: proc(state: T): S {.closure.},\n            win_when_no_moves:\
    \ bool = false): tuple[is_win: bool, states: seq[T]] =\n        ## \u624B\u756A\
    \u5225\u306E\u30EB\u30FC\u30EB\u3068\u8A55\u4FA1\u95A2\u6570\u306B\u3088\u308B\
    \u512A\u5148\u9806\u4F4D\u3067\u3001\u547C\u3073\u51FA\u3057\u3054\u3068\u306B\
    \u65B0\u3057\u3044\u30E1\u30E2\u3092\u4F7F\u3063\u3066\u5FA9\u5143\u3057\u307E\
    \u3059\u3002\n        ## nxt \u3068 evaluate \u306E\u7D50\u679C\u306F\u547C\u3073\
    \u51FA\u3057\u4E2D\u4E00\u5B9A\u3068\u3057\u307E\u3059\u3002\n        result =\
    \ init_optimal_play_evaluated_impl(nxt, evaluate, win_when_no_moves)(initial_state)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/game.nim
  requiredBy: []
  timestamp: '2026-09-11 03:00:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/game_optimal_play_test.nim
  - verify/utils/game_optimal_play_test.nim
  - verify/utils/game_warning_test.nim
  - verify/utils/game_warning_test.nim
  - verify/utils/game_grundy_test.nim
  - verify/utils/game_grundy_test.nim
  - verify/utils/game_test.nim
  - verify/utils/game_test.nim
documentation_of: cplib/utils/game.nim
layout: document
redirect_from:
- /library/cplib/utils/game.nim
- /library/cplib/utils/game.nim.html
title: cplib/utils/game.nim
---
