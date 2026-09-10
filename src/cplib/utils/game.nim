when not declared CPLIB_UTILS_GAME:
    const CPLIB_UTILS_GAME* = 1

    import sets,tables,macros

    type
        NextStates*[T] = proc(state: T): seq[T] {.closure.}
        NextStatesByTurn*[T] = proc(state: T, is_first: bool): seq[T] {.closure.}

    macro check_game_next(nxt: typed, caller: static[string] = "init_can_win",
            argument: static[string] = "nxt"): untyped =
        ## 直接参照される外部の var に対して、メモ再利用時の注意を警告します。
        let caller_name = caller
        let argument_name = argument
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
                warning(caller_name & ": " & argument_name & " が外部の var '" & node.strVal &
                    "' を直接参照しています。値を変更するとメモが不正になる可能性があります", node)
            for child in node:
                inspect(child)

        collect_locals(implementation.body)
        inspect(implementation.body)

    proc init_grundy_impl[T](nxt: NextStates[T]): proc(state: T): int {.closure.} =
        ## Grundy 数のメモを保持する計算関数を作ります。
        var memo = initTable[T, int]()
        var visiting = initHashSet[T]()

        proc solve(state: T): int =
            ## 遷移先の Grundy 数の mex をメモ化して求めます。
            if memo.hasKey(state):
                return memo[state]
            if state in visiting:
                raise newException(ValueError,
                    "grundy はゲームグラフの閉路に対応していません")
            visiting.incl(state)
            defer: visiting.excl(state)
            let next_states = nxt(state)
            var seen = newSeq[bool](next_states.len + 1)
            for next_state in next_states:
                let value = solve(next_state)
                if value < seen.len:
                    seen[value] = true
            while seen[result]:
                inc result
            memo[state] = result

        result = solve

    template init_grundy*[T](nxt: NextStates[T]): untyped =
        ## Grundy 数を計算し、呼び出し間でメモを再利用する関数を返します。
        ## 両者の合法手が同じで、合法手がない側が負ける有限かつ閉路なしのゲームを対象とします。
        ## 遷移先の Grundy 数に含まれない最小の非負整数を返し、終端状態では 0 を返します。
        ## 値が 0 なら手番側の負け、それ以外なら勝ちです。独立なゲームの和は値の xor で求められます。
        ## 返された関数を使う間、nxt の結果は同じ引数に対して変化しない必要があります。
        ## ルールを変更する場合は、この関数で新しく計算関数を作り直してください。
        ## 外部の var への警告は init_can_win と同じ範囲です。
        ## 新たに探索する状態数 V、遷移数 E に対して時間 O(V + E)、探索中の補助空間 O(V + E) です。
        ## メモは累計状態数に比例する空間を使い、評価済みの状態への問い合わせは O(1) です。
        ## （状態のハッシュ・比較・コピーを O(1)、nxt を列挙数に比例する時間とした場合）。
        runnableExamples:
            proc subtract(state: int): seq[int] =
                for take in 1..2:
                    if take <= state:
                        result.add(state - take)

            let solve = init_grundy(subtract)
            assert solve(0) == 0
            assert solve(2) == 2
            assert solve(4) == 1

        init_grundy_impl(check_game_next(nxt, "init_grundy"))

    proc grundy*[T](initial_state: T, nxt: NextStates[T]): int =
        ## 指定状態の Grundy 数を、呼び出しごとに新しいメモで計算します。
        ## 対象ゲーム・計算量は init_grundy と同じで、nxt の結果は呼び出し中一定とします。
        result = init_grundy_impl(nxt)(initial_state)

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

    proc init_optimal_play_impl[T](nxt: NextStates[T],
            win_when_no_moves: bool = false,
            prefer: proc(a, b: T): bool {.closure.} = nil):
            proc(state: T): tuple[is_win: bool, states: seq[T]] {.closure.} =
        ## 勝敗・終局手数・遷移先のメモを保持する復元関数を作ります。
        type Evaluation = tuple[winning: bool, turns: int, next_state: T]
        var memo = initTable[T, Evaluation]()
        var visiting = initHashSet[T]()

        proc solve(state: T): Evaluation =
            ## 勝敗・最適な終局手数・遷移先をメモ化して求めます。
            if memo.hasKey(state):
                return memo[state]
            if state in visiting:
                raise newException(ValueError,
                    "optimal_play はゲームグラフの閉路に対応していません")
            visiting.incl(state)
            defer: visiting.excl(state)
            let next_states = nxt(state)
            result = (winning: win_when_no_moves, turns: 0, next_state: state)
            for i, next_state in next_states:
                let child = solve(next_state)
                let winning = not child.winning
                let turns = child.turns + 1
                if i == 0 or (winning and not result.winning) or
                        (winning == result.winning and
                            ((winning and turns < result.turns) or
                             (not winning and turns > result.turns) or
                             (turns == result.turns and prefer != nil and
                              prefer(next_state, result.next_state)))):
                    result = (winning: winning, turns: turns, next_state: next_state)
            memo[state] = result

        result = proc(initial_state: T): tuple[is_win: bool, states: seq[T]] =
            ## 初期状態の勝敗と、メモを用いて復元した状態列を返します。復元は O(列の長さ) です。
            result.is_win = solve(initial_state).winning
            var state = initial_state
            result.states.add(state)
            while memo[state].turns > 0:
                state = memo[state].next_state
                result.states.add(state)

    proc init_optimal_play_impl[T](nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false,
            prefer: proc(a, b: T): bool {.closure.} = nil):
            proc(state: T): tuple[is_win: bool, states: seq[T]] {.closure.} =
        ## 状態と手番ごとのメモを保持する復元関数を作ります。
        type TurnState = tuple[state: T, is_first: bool]
        proc next_by_turn(current: TurnState): seq[TurnState] =
            ## 状態に手番を付けて遷移を列挙します。
            for next_state in nxt(current.state, current.is_first):
                result.add((state: next_state, is_first: not current.is_first))

        var prefer_by_turn: proc(a, b: TurnState): bool {.closure.}
        if prefer != nil:
            prefer_by_turn = proc(a, b: TurnState): bool =
                ## 手番を除いた遷移先の状態を比較します。
                prefer(a.state, b.state)
        let solve = init_optimal_play_impl(next_by_turn, win_when_no_moves, prefer_by_turn)
        result = proc(initial_state: T): tuple[is_win: bool, states: seq[T]] =
            ## 指定状態から先手が必勝かどうかと状態列を返します。
            let play = solve((state: initial_state, is_first: true))
            result.is_win = play.is_win
            for current in play.states:
                result.states.add(current.state)

    template init_optimal_play*[T](nxt: NextStates[T],
            win_when_no_moves: bool = false): untyped =
        ## 勝敗と最適な状態列を返し、呼び出し間でメモを再利用する関数を作ります。
        ## 返り値は tuple[is_win: bool, states: seq[T]] で、is_win は初期状態の手番側が必勝かを表します。
        ## states は初期状態と終端状態を含み、初期状態が終端なら要素数は 1 です。
        ## 勝てる局面では勝つまでの手数を最小化し、負ける局面では負けるまでの手数を最大化します。
        ## 勝敗と手数が同じなら nxt の順で選びます。
        ## 合法手がない状態では、win_when_no_moves が true の場合に限り手番側の勝ちとなります。
        ## ゲームグラフは有限かつ閉路なしである必要があります。
        ## 返された関数を使う間、nxt の結果は同じ引数に対して変化しない必要があります。
        ## ルールを変更する場合は、この関数で新しく復元関数を作り直してください。
        ## init_can_win と同様、直接渡した関数・無名関数が直接参照する外部の var に警告します。
        ## 別の関数の内部や、変数・引数に格納された関数は検査しません。
        ## 新たに探索する状態数 V、遷移数 E、返す列の長さ L に対して時間 O(V + E + L) です。
        ## メモは累計状態数に比例する空間を使い、探索中はさらに O(V + E) の補助空間を使います。
        ## （状態のハッシュ・比較・コピーを O(1)、nxt を列挙数に比例する時間とした場合）。
        runnableExamples:
            proc subtract(state: int): seq[int] =
                for take in 1..2:
                    if take <= state:
                        result.add(state - take)

            let solve = init_optimal_play(subtract)
            assert solve(4) == (is_win: true, states: @[4, 3, 2, 0])
            assert solve(3) == (is_win: false, states: @[3, 2, 0])

        init_optimal_play_impl(check_game_next(nxt, "init_optimal_play"), win_when_no_moves)

    template init_optimal_play*[T](nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): untyped =
        ## 手番別のルールで勝敗と最適な状態列を返し、呼び出し間でメモを再利用する関数を作ります。
        ## 返り値は tuple[is_win: bool, states: seq[T]] で、is_win は先手が必勝かを表します。
        ## 各呼び出しは先手から始まり、states の偶数番目では is_first = true、奇数番目では false です。
        ## 状態と手番の組ごとにメモ化します。
        ## 選択規則・前提・外部変数への警告・計算量は手番によらない init_optimal_play と同じです。
        init_optimal_play_impl(check_game_next(nxt, "init_optimal_play"), win_when_no_moves)

    proc optimal_play*[T](initial_state: T, nxt: NextStates[T],
            win_when_no_moves: bool = false): tuple[is_win: bool, states: seq[T]] =
        ## 呼び出しごとに新しいメモで、手番側が必勝かどうかと初期状態から終端状態までの状態列を返します。
        ## 選択規則・前提・計算量は init_optimal_play と同じで、nxt の結果は呼び出し中一定とします。
        result = init_optimal_play_impl(nxt, win_when_no_moves)(initial_state)

    proc optimal_play*[T](initial_state: T, nxt: NextStatesByTurn[T],
            win_when_no_moves: bool = false): tuple[is_win: bool, states: seq[T]] =
        ## 手番別のルールで、先手が必勝かどうかと初期状態から終端状態までの状態列を新しいメモで返します。
        ## 手番・選択規則・前提・計算量は init_optimal_play と同じで、nxt の結果は呼び出し中一定とします。
        result = init_optimal_play_impl(nxt, win_when_no_moves)(initial_state)

    proc init_optimal_play_evaluated_impl[T, S](nxt: NextStates[T],
            evaluate: proc(state: T): S {.closure.}, win_when_no_moves: bool):
            proc(state: T): tuple[is_win: bool, states: seq[T]] {.closure.} =
        ## 遷移先の評価値で同順位の候補を比較する復元関数を作ります。
        proc prefer(a, b: T): bool =
            ## 評価値が厳密に大きい候補を優先します。
            evaluate(b) < evaluate(a)
        init_optimal_play_impl(nxt, win_when_no_moves, prefer)

    proc init_optimal_play_evaluated_impl[T, S](nxt: NextStatesByTurn[T],
            evaluate: proc(state: T): S {.closure.}, win_when_no_moves: bool):
            proc(state: T): tuple[is_win: bool, states: seq[T]] {.closure.} =
        ## 手番別のルールで、遷移先の評価値による優先順位を設定します。
        proc prefer(a, b: T): bool =
            ## 評価値が厳密に大きい候補を優先します。
            evaluate(b) < evaluate(a)
        init_optimal_play_impl(nxt, win_when_no_moves, prefer)

    template init_optimal_play*[T, S](nxt: NextStates[T],
            evaluate: proc(state: T): S {.closure.},
            win_when_no_moves: bool = false): untyped =
        ## 勝敗と終局手数が同じ候補は、遷移先の evaluate(state) が大きい手を優先してメモ化します。
        ## 両プレイヤーとも評価値を最大化し、評価値も同じなら nxt の順で選びます。
        ## S は < で比較可能な型とします。評価値は状態列全体の合計ではありません。
        ## 復元関数を使う間、evaluate の結果も同じ引数に対して変化しない必要があります。
        ## nxt と evaluate が直接参照する外部の var への警告は init_can_win と同じ範囲です。
        ## その他の仕様は評価関数なしの init_optimal_play と同じです。
        ## evaluate と評価値の比較が O(1) なら計算量も同じです。
        init_optimal_play_evaluated_impl(
            check_game_next(nxt, "init_optimal_play"),
            check_game_next(evaluate, "init_optimal_play", "evaluate"), win_when_no_moves)

    template init_optimal_play*[T, S](nxt: NextStatesByTurn[T],
            evaluate: proc(state: T): S {.closure.},
            win_when_no_moves: bool = false): untyped =
        ## 手番別のルールで、勝敗と終局手数が同じ候補は遷移先の評価値が大きい手を優先します。
        ## 評価関数の仕様と前提は手番によらない評価関数付き init_optimal_play と同じです。
        init_optimal_play_evaluated_impl(
            check_game_next(nxt, "init_optimal_play"),
            check_game_next(evaluate, "init_optimal_play", "evaluate"), win_when_no_moves)

    proc optimal_play*[T, S](initial_state: T, nxt: NextStates[T],
            evaluate: proc(state: T): S {.closure.},
            win_when_no_moves: bool = false): tuple[is_win: bool, states: seq[T]] =
        ## 評価関数付き init_optimal_play と同じ規則で、呼び出しごとに新しいメモを使って復元します。
        ## nxt と evaluate の結果は呼び出し中一定とします。
        result = init_optimal_play_evaluated_impl(nxt, evaluate, win_when_no_moves)(initial_state)

    proc optimal_play*[T, S](initial_state: T, nxt: NextStatesByTurn[T],
            evaluate: proc(state: T): S {.closure.},
            win_when_no_moves: bool = false): tuple[is_win: bool, states: seq[T]] =
        ## 手番別のルールと評価関数による優先順位で、呼び出しごとに新しいメモを使って復元します。
        ## nxt と evaluate の結果は呼び出し中一定とします。
        result = init_optimal_play_evaluated_impl(nxt, evaluate, win_when_no_moves)(initial_state)
