when not declared CPLIB_UTILS_GAME:
    const CPLIB_UTILS_GAME* = 1

    import sets,tables,macros

    type
        NextStates*[T] = proc(state: T): seq[T] {.closure.}
        NextStatesByTurn*[T] = proc(state: T, is_first: bool): seq[T] {.closure.}

    macro check_game_next(nxt: typed): untyped =
        ## 直接参照される外部の var に対して、メモ再利用時の注意を警告します。
        result = nxt
        # Nim 1.6 で型検査済みの無名関数が再定義扱いになるのを防ぎます。
        if nxt.kind == nnkLambda:
            result = nxt.copyNimTree
            result[0] = newEmptyNode()
        var implementation = nxt
        if implementation.kind == nnkSym:
            if implementation.symKind notin {nskProc, nskFunc}:
                return
            implementation = implementation.getImpl
        if implementation.kind notin {nnkProcDef, nnkFuncDef, nnkLambda}:
            return

        const routineKinds = {nnkProcDef, nnkFuncDef, nnkMethodDef,
            nnkIteratorDef, nnkConverterDef, nnkMacroDef, nnkTemplateDef,
            nnkLambda, nnkDo}
        var locals: seq[NimNode]
        var warned: seq[NimNode]

        proc collect_locals(node: NimNode) =
            ## 関数本体で宣言されたローカル変数のシンボルを集めます。
            if node.kind in routineKinds:
                return
            if node.kind == nnkVarSection:
                for definition in node:
                    if definition.kind in {nnkIdentDefs, nnkVarTuple}:
                        for i in 0..<definition.len - 2:
                            if definition[i].kind == nnkSym:
                                locals.add(definition[i])
            for child in node:
                collect_locals(child)

        proc inspect(node: NimNode) =
            ## 他の関数の本体には入らず、外部変数ごとに一度だけ警告します。
            if node.kind in routineKinds:
                return
            if node.kind == nnkSym and node.symKind == nskVar and
                    node notin locals and node notin warned:
                warned.add(node)
                warning("init_can_win: nxt が外部の var '" & node.strVal &
                    "' を直接参照しています。値を変更するとメモが不正になる可能性があります", node)
            for child in node:
                inspect(child)

        collect_locals(implementation.body)
        inspect(implementation.body)

    proc init_can_win_impl[T](nxt: NextStates[T],
            win_when_no_moves: bool = false): proc(state: T): bool {.closure.} =
        ## メモを保持する判定関数の実装を作ります。
        var memo = initTable[T, bool]()
        var visiting = initHashSet[T]()

        proc solve(state: T): bool =
            ## 状態の勝敗をメモ化して求めます。
            if memo.hasKey(state):
                return memo[state]
            if state in visiting:
                raise newException(ValueError,
                    "can_win はゲームグラフの閉路に対応していません")

            visiting.incl(state)
            defer: visiting.excl(state)
            let next_states = nxt(state)
            if next_states.len == 0:
                result = win_when_no_moves
            else:
                result = false
                for next_state in next_states:
                    if not solve(next_state):
                        result = true
                        break
            memo[state] = result

        result = solve

    proc init_can_win_impl[T](nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): proc(state: T): bool {.closure.} =
        ## メモを保持する判定関数の実装を作ります。
        type TurnState = tuple[state: T, is_first: bool]
        var memo = initTable[TurnState, bool]()
        var visiting = initHashSet[TurnState]()

        proc solve(state: T, is_first: bool): bool =
            ## 状態と手番ごとの勝敗をメモ化して求めます。
            let key = (state: state, is_first: is_first)
            if memo.hasKey(key):
                return memo[key]
            if key in visiting:
                raise newException(ValueError,
                    "can_win はゲームグラフの閉路に対応していません")

            visiting.incl(key)
            defer: visiting.excl(key)
            let next_states = nxt(state, is_first)
            if next_states.len == 0:
                result = win_when_no_moves
            else:
                result = false
                for next_state in next_states:
                    if not solve(next_state, not is_first):
                        result = true
                        break
            memo[key] = result

        result = proc(state: T): bool =
            ## 指定状態から先手が必勝かどうかを返します。
            solve(state, true)

    template init_can_win*[T](nxt: NextStates[T],
            win_when_no_moves: bool = false): untyped =
        ## 手番側が必勝かどうかを判定し、呼び出し間でメモを再利用する関数を返します。
        ##
        ## `nxt(state)` は一手で遷移できるすべての状態を返します。
        ## 合法手がない状態では、`win_when_no_moves` が true の場合に限り手番側の勝ちとなります。
        ## 到達可能なゲームグラフは有限で、閉路を持たない必要があります。
        ## 返された関数を使う間、`nxt` の結果は同じ引数に対して変化しない必要があります。
        ## ルールを変更する場合は、この関数で新しく判定関数を作り直してください。
        ## 関数名または無名関数を直接渡すと、直接参照する外部の var に警告します。
        ## 別の関数の内部や、変数・引数に格納された関数は検査しません。
        runnableExamples:
            proc subtract(state: int): seq[int] =
                for take in 1..2:
                    if take <= state:
                        result.add(state - take)

            let solve = init_can_win(subtract)
            assert solve(3) == false
            assert solve(4) == true
            let misere = init_can_win(subtract, win_when_no_moves = true)
            assert misere(1) == false

        init_can_win_impl(check_game_next(nxt), win_when_no_moves)

    template init_can_win*[T](nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): untyped =
        ## 先手が必勝かどうかを判定し、呼び出し間でメモを再利用する関数を返します。
        ##
        ## `nxt(state, is_first)` は手番側のプレイヤーが一手で遷移できるすべての状態を返します。
        ## `is_first` は最初の手番では true で、一手ごとに反転します。
        ## 合法手がない状態では、`win_when_no_moves` が true の場合に限り手番側の勝ちとなります。
        ## 到達可能なゲームグラフは有限で、閉路を持たない必要があります。
        ## 返された関数を使う間、`nxt` の結果は同じ引数に対して変化しない必要があります。
        ## ルールを変更する場合は、この関数で新しく判定関数を作り直してください。
        ## 関数名または無名関数を直接渡すと、直接参照する外部の var に警告します。
        ## 別の関数の内部や、変数・引数に格納された関数は検査しません。
        runnableExamples:
            proc subtract_by_turn(state: int, is_first: bool): seq[int] =
                let max_take = (if is_first: 1 else: 2)
                for take in 1..max_take:
                    if take <= state:
                        result.add(state - take)

            let solve = init_can_win(subtract_by_turn)
            assert solve(1) == true
            assert solve(2) == false

        init_can_win_impl(check_game_next(nxt), win_when_no_moves)

    proc can_win*[T](initial_state: T, nxt: NextStates[T],
            win_when_no_moves: bool = false): bool =
        ## 指定状態で手番側が必勝かどうかを、呼び出しごとに新しいメモで判定します。
        ## ゲームグラフは有限かつ閉路なしである必要があります。
        result = init_can_win_impl(nxt, win_when_no_moves)(initial_state)

    proc can_win*[T](initial_state: T, nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): bool =
        ## 指定状態から先手が必勝かどうかを、呼び出しごとに新しいメモで判定します。
        ## ゲームグラフは有限かつ閉路なしである必要があります。
        result = init_can_win_impl(nxt, win_when_no_moves)(initial_state)
