when not declared CPLIB_UTILS_ROLLBACK_MO:
    const CPLIB_UTILS_ROLLBACK_MO* = 1
    import algorithm, math
    import cplib/utils/private/auto_rollback

    type RollbackMo* = object
        n, width: int
        queries: seq[tuple[left, right, idx: int]]

    proc initRollbackMo*(N: int, Q: int = 0, width: int = 0): RollbackMo =
        ## 長さNの列に対するRollback Moを初期化する。O(1)。
        ## 幅0ならQ>0でN/sqrt(Q)、Q=0でsqrt(N)を目安に幅を決める。Qは想定クエリ数。
        assert N >= 0 and Q >= 0 and width >= 0
        result.n = N
        let estimated = if Q > 0: float(N) / sqrt(float(Q)) else: sqrt(float(N))
        result.width = if width > 0: width else: max(1, int(estimated))
        result.width = min(result.width, max(1, N))

    proc insert*(self: var RollbackMo, l, r: int): int {.discardable.} =
        ## 半開区間[l, r)を登録し、0始まりの登録番号を返す。空区間も許可する。償却O(1)。
        assert 0 <= l and l <= r and r <= self.n
        result = self.queries.len
        self.queries.add((l, r, result))

    proc run*(self: RollbackMo, add: proc(idx: int),
            rollback: proc(), answer: proc(query_idx: int)) =
        ## 区間を並べ替えて処理し、登録番号をanswerへ渡す。終了時は実行前の状態に戻す。
        ## addは指定位置の要素を追加し、rollbackは直前のaddを1回取り消す。変化がないaddも対応が必要。
        ## 回答は追加順によらないこと。answerは状態を変更せず、結果を登録番号で保存すること。
        ## 実行中に登録内容を変更しないこと。登録内容は保持し、繰り返し実行できる。
        ## 幅B、クエリ数Qに対し、ソートO(Q log Q)、追加・取り消し各O(N²/B + QB)、追加領域O(Q)。
        assert self.width > 0, "initRollbackMoで初期化してください"
        var queries = newSeq[tuple[left, right, idx: int]](self.queries.len)
        for i, query in self.queries: queries[i] = query
        let width = self.width
        queries.sort(proc(a, b: tuple[left, right, idx: int]): int =
            result = cmp(a.left div width, b.left div width)
            if result == 0: result = cmp(a.right, b.right)
            if result == 0: result = cmp(a.idx, b.idx)
        )
        var currentBlock = -1
        var boundary = 0
        var right = 0
        for query in queries:
            let nextBlock = query.left div width
            if nextBlock != currentBlock:
                while right > boundary:
                    rollback()
                    dec right
                currentBlock = nextBlock
                boundary = query.left - query.left mod width
                boundary += min(width, self.n - boundary)
                right = boundary
            if query.right <= boundary:
                for i in query.left..<query.right: add(i)
                answer(query.idx)
                for i in query.left..<query.right: rollback()
            else:
                while right < query.right:
                    add(right)
                    inc right
                var left = boundary
                while left > query.left:
                    dec left
                    add(left)
                answer(query.idx)
                for i in query.left..<boundary: rollback()
        while right > boundary:
            rollback()
            dec right

    template runAutoRollback*(self: RollbackMo, add: proc(idx: int),
            answer: proc(query_idx: int)) =
        ## addと静的な呼び出し先を変換し、rollbackを自動生成して区間を処理する。
        ## 通常の型への数値などの書き込みに対応。seqの伸縮・参照の変更・動的呼び出しなどは未対応。
        ## 値渡しの複合型は読み取り専用。ローカル変数と戻り値は数値・それらのタプル・固定長配列に限定する。
        ## answerは状態を変更しないこと（経路圧縮も不可）。結果は登録番号で保存すること。
        ## 未対応の処理はコンパイルエラー。例外時も実行前の状態へ戻す。
        ## runの計算量に、記録・復元する値の合計サイズに比例する時間・領域が加わる。
        runAutoRollbackImpl(self, add, answer, run)
