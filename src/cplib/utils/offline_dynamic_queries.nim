when not declared CPLIB_UTILS_OFFLINE_DYNAMIC_QUERIES:
    const CPLIB_UTILS_OFFLINE_DYNAMIC_QUERIES* = 1
    import tables

    type OfflineDynamicQueries*[T = void] = object
        active: Table[int, int]
        intervals: seq[tuple[left, right, idx: int]]
        outputs: seq[int]
        when T isnot void:
            values: seq[T]
            indices: seq[int]

    proc initOfflineDynamicQueries*(T: typedesc): OfflineDynamicQueries[T] =
        ## 操作の追加・取り消し・出力をオフラインで処理する型を初期化する。O(1)。
        result.active = initTable[int, int]()

    proc initOfflineDynamicQueries*(): OfflineDynamicQueries[void] =
        ## 追加情報を持たない型を初期化する。O(1)。
        initOfflineDynamicQueries(void)

    proc add*(self: var OfflineDynamicQueries[void], idx: int) =
        ## 操作idxを有効にする。有効な番号の重複追加は禁止、取り消し後の再追加は可能。期待O(1)。
        assert not self.active.hasKey(idx), "既に有効な操作です"
        self.active[idx] = self.outputs.len

    proc add*[T](self: var OfflineDynamicQueries[T], idx: int, value: T) =
        ## 操作idxと情報valueを登録する。取り消し後は別の値で再追加可能。期待・償却O(1)。
        assert not self.active.hasKey(idx), "既に有効な操作です"
        self.active[idx] = self.values.len
        self.values.add(value)
        self.indices.add(idx)
        self.intervals.add((self.outputs.len, -1, self.values.len - 1))

    proc remove*[T](self: var OfflineDynamicQueries[T], idx: int) =
        ## 有効な操作idxを取り消す。期待・償却O(1)。
        assert self.active.hasKey(idx), "有効でない操作は取り消せません"
        when T is void:
            let left = self.active[idx]
            if left < self.outputs.len:
                self.intervals.add((left, self.outputs.len, idx))
        else:
            self.intervals[self.active[idx]].right = self.outputs.len
        self.active.del(idx)

    proc output*[T](self: var OfflineDynamicQueries[T], query_idx: int) =
        ## 現在の状態の出力を登録し、実行時にquery_idxをanswerへ渡す。償却O(1)。
        self.outputs.add(query_idx)

    proc runImpl[T, F](self: OfflineDynamicQueries[T], apply: F,
            rollback: proc(), answer: proc(query_idx: int)) =
        ## 有効な操作を適用して登録順にanswerを呼び、終了時に実行前の状態へ戻す。
        ## 適用順は登録順とは限らないため、出力が操作の適用順によらないことが必要。
        ## apply 1回につきrollback 1回で戻すこと。状態が変化しないapplyにも対応が必要。
        ## answerは状態を変更しないこと。コールバックから登録内容を変更しないこと。
        ## 追加回数A、出力回数Qに対し、コールバックを除き時間・領域O(A log(Q+1) + Q)。
        ## apply・rollbackは各O(A log(Q+1))回、answerはQ回。登録内容は保持する。
        let q = self.outputs.len
        if q == 0: return
        var size = 1
        while size < q: size *= 2
        var nodes = newSeq[seq[int]](size * 2)

        proc insert(left, right, idx: int) =
            ## 半開区間[left, right)に操作idxを登録する。O(log Q)。
            var l = left + size
            var r = right + size
            while l < r:
                if (l and 1) != 0:
                    nodes[l].add(idx)
                    inc l
                if (r and 1) != 0:
                    dec r
                    nodes[r].add(idx)
                l = l shr 1
                r = r shr 1

        for interval in self.intervals:
            let right = if interval.right < 0: q else: interval.right
            insert(interval.left, right, interval.idx)
        when T is void:
            for idx, left in self.active.pairs:
                insert(left, q, idx)

        proc visit(node, left, right: int) =
            ## 区間木を深さ優先で走査し、適用した操作を逆順に取り消す。
            if left >= q: return
            for idx in nodes[node]:
                when T is void: apply(idx)
                else: apply(self.indices[idx], self.values[idx])
            if right - left == 1:
                answer(self.outputs[left])
            else:
                let mid = (left + right) div 2
                visit(node * 2, left, mid)
                visit(node * 2 + 1, mid, right)
            for i in 0..<nodes[node].len: rollback()

        visit(1, 0, size)

    proc run*[T](self: OfflineDynamicQueries[T], apply: proc(idx: int, value: T),
            rollback: proc(), answer: proc(query_idx: int)) =
        ## 各追加時の番号と情報をapplyへ渡して実行する。適用順によらず回答が決まることが必要。
        ## applyごとにrollbackを1回呼び、終了時に元の状態へ戻す。answerは登録順で状態を参照する。
        ## コールバックによる登録変更は禁止。追加A回、出力Q回で時間・領域O(A log(Q+1) + Q)。
        ## 計算量は情報の保持・受け渡しとコールバックのコストを除く。登録内容は保持する。
        self.runImpl(apply, rollback, answer)

    proc run*(self: OfflineDynamicQueries[void], apply: proc(idx: int),
            rollback: proc(), answer: proc(query_idx: int)) =
        ## 追加情報なしで実行する。型付きrunと同じ条件・計算量で、applyには番号のみ渡す。
        self.runImpl(apply, rollback, answer)

    # runAutoRollback(apply, answer)は通常の型・関数から復元処理を自動生成する試験的なAPI。
    # applyの静的な呼び出し先も変換する。数値などの値の代入・inc・dec・swapに対応する。
    # seqの伸縮、参照の差し替え、動的呼び出しなど、未対応の処理はコンパイルエラーになる。
    # answerは状態を変更しないこと。UnionFindの経路圧縮を伴う参照操作にも注意すること。
    import cplib/utils/private/auto_rollback

    proc runAutoRollbackTyped[T](solver: OfflineDynamicQueries[T],
            apply: proc(idx: int, value: T), rollback: proc(), answer: proc(query_idx: int)) =
        ## 自動生成したコールバックの型を確定してから通常の実行処理へ渡す。
        solver.run(apply, rollback, answer)

    proc runAutoRollbackWithoutValue(solver: OfflineDynamicQueries[void],
            apply: proc(idx: int), rollback: proc(), answer: proc(query_idx: int)) =
        ## 追加情報なしのコールバックの型を確定してから通常の実行処理へ渡す。
        solver.run(apply, rollback, answer)

    template runAutoRollback*[T](solver: OfflineDynamicQueries[T],
            apply: proc(idx: int, value: T), answer: proc(query_idx: int)) =
        ## 通常の型と関数を使って自動でrollbackする試験的なAPI。applyと静的な呼び出し先を変換する。
        ## 対象は数値などの値の書き込み。seqの伸縮・参照変更・動的呼び出しなどはコンパイルエラー。
        ## seqなどを含むobject・tuple・arrayの値渡しは、参照先まで読み取り専用として許可する。
        ## ローカル変数と戻り値は数値・それらのタプル・固定長配列に限定する。これらのvar引数渡しにも対応。
        ## answerは状態を変更しないこと（経路圧縮も不可）。適用順によらず回答が決まること。
        ## 記録・復元の時間と領域は保存する値の合計サイズに比例する。例外時も実行前の状態へ戻す。
        runAutoRollbackImpl(solver, apply, answer, runAutoRollbackTyped)

    template runAutoRollback*(solver: OfflineDynamicQueries[void],
            apply: proc(idx: int), answer: proc(query_idx: int)) =
        ## 追加情報なしで自動rollbackする。型付きrunAutoRollbackと同じ条件・計算量。
        runAutoRollbackImpl(solver, apply, answer, runAutoRollbackWithoutValue)
