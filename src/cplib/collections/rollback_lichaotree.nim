when not declared CPLIB_COLLECTIONS_ROLLBACK_LICHAOTREE:
    const CPLIB_COLLECTIONS_ROLLBACK_LICHAOTREE* = 1
    import algorithm, sequtils
    import cplib/utils/constants

    ## 座標圧縮した最小値用のLi Chao Tree。初期化時の座標だけ問い合わせ可能。
    ## intの乗算・加算がオーバーフローしない入力を与えること（64bit環境向け）。
    ## refの代入は同じ木を共有する。snapshotは不変のtokenで、木のコピーではない。
    ## 取り消した分岐へは戻れず、任意削除や自由な永続分岐は提供しない。
    ## 領域はO(N + H + Q)。H/Qは変更/操作履歴の最大保持数。
    type
        RollbackLiChaoOwner = ref object
        RollbackLiChaoLine = object
            a, b: int
            present: bool
        RollbackLiChaoChange = object
            node: int
            oldLine: RollbackLiChaoLine
        RollbackLiChaoOperation = object
            start: int
            id: uint64
        RollbackLiChaoSnapshot* = object
            owner: RollbackLiChaoOwner
            depth: int
            id: uint64
        RollbackLiChaoTree* = ref object
            xs: seq[int]
            lines: seq[RollbackLiChaoLine]
            history: seq[RollbackLiChaoChange]
            operations: seq[RollbackLiChaoOperation]
            operationCount: int
            nextId: uint64
            owner: RollbackLiChaoOwner

    proc initRollbackLiChaoTree*(xs: openArray[int]): RollbackLiChaoTree =
        ## 入力をコピーしてソート・重複除去する。O(N log N)、領域O(N)。空列も可能。
        let coords = xs.sorted().deduplicate(true)
        result = RollbackLiChaoTree(xs: coords, owner: RollbackLiChaoOwner())
        result.lines = newSeq[RollbackLiChaoLine](4 * coords.len)

    proc beginOperation(self: RollbackLiChaoTree) =
        ## 無変化の追加も一操作として記録する。償却O(1)。
        if self.nextId == high(uint64):
            raise newException(ValueError, "操作の世代番号を使い切りました")
        inc self.nextId
        let operation = RollbackLiChaoOperation(start: self.history.len, id: self.nextId)
        if self.operationCount < self.operations.len:
            self.operations[self.operationCount] = operation
        else:
            self.operations.add(operation)
        inc self.operationCount

    proc replaceLine(self: RollbackLiChaoTree, node: int, line: RollbackLiChaoLine) =
        ## 書き換え前の直線と空状態を保存する。償却O(1)。
        self.history.add(RollbackLiChaoChange(node: node, oldLine: self.lines[node]))
        self.lines[node] = line

    proc insertLine(self: RollbackLiChaoTree, line: RollbackLiChaoLine, node, l, r: int) =
        ## 一つの被覆区間へ直線を追加する。O(log N)。
        var line = line
        var node = node
        var l = l
        var r = r
        while true:
            let oldLine = self.lines[node]
            if not oldLine.present:
                self.replaceLine(node, line)
                return
            let m = l + (r - l) div 2
            let left = line.a * self.xs[l] + line.b < oldLine.a * self.xs[l] + oldLine.b
            let right = line.a * self.xs[r - 1] + line.b < oldLine.a * self.xs[r - 1] + oldLine.b
            if left and right:
                self.replaceLine(node, line)
                return
            if not left and not right: return
            let mid = line.a * self.xs[m] + line.b < oldLine.a * self.xs[m] + oldLine.b
            if mid:
                self.replaceLine(node, line)
                line = oldLine
            if left != mid:
                node *= 2
                r = m
            else:
                node = node * 2 + 1
                l = m

    proc add_line*(self: RollbackLiChaoTree, a, b: int) =
        ## 全登録座標にax+bを追加する。償却O(log N)、変更数O(log N)。
        self.beginOperation()
        if self.xs.len > 0:
            self.insertLine(RollbackLiChaoLine(a: a, b: b, present: true), 1, 0, self.xs.len)

    proc insertSegment(self: RollbackLiChaoTree, line: RollbackLiChaoLine,
            ql, qr, node, l, r: int) =
        ## 半開区間をO(log N)個の被覆区間に分解する。O(log^2 N)。
        if qr <= l or r <= ql: return
        if ql <= l and r <= qr:
            self.insertLine(line, node, l, r)
            return
        let m = l + (r - l) div 2
        self.insertSegment(line, ql, qr, node * 2, l, m)
        self.insertSegment(line, ql, qr, node * 2 + 1, m, r)

    proc add_segment*(self: RollbackLiChaoTree, a, b, l, r: int) =
        ## l<=x<rにax+bを追加する。償却O(log^2 N)、変更数O(log^2 N)。
        ## l>=rや登録座標を含まない区間も一操作として記録する。
        self.beginOperation()
        if l >= r or self.xs.len == 0: return
        let ql = self.xs.lowerBound(l)
        let qr = self.xs.lowerBound(r)
        if ql < qr:
            self.insertSegment(RollbackLiChaoLine(a: a, b: b, present: true), ql, qr, 1, 0, self.xs.len)

    proc get_min*(self: RollbackLiChaoTree, x: int): int =
        ## 登録座標xでの最小値。直線がなければINF64。O(log N)。
        ## 未登録座標はreleaseでもValueErrorにする。値がINF64以上の直線も扱える。
        let index = self.xs.lowerBound(x)
        if index == self.xs.len or self.xs[index] != x:
            raise newException(ValueError, "クエリ座標は初期化時に登録されている必要があります")
        var node = 1
        var l = 0
        var r = self.xs.len
        var found = false
        result = INF64
        while true:
            let line = self.lines[node]
            if line.present:
                let value = line.a * x + line.b
                if not found or value < result: result = value
                found = true
            if r - l == 1: return
            let m = l + (r - l) div 2
            if index < m:
                node *= 2
                r = m
            else:
                node = node * 2 + 1
                l = m

    proc snapshot*(self: RollbackLiChaoTree): RollbackLiChaoSnapshot =
        ## 現在の操作境界を表す不変tokenを返す。O(1)、追加領域O(1)。
        result = RollbackLiChaoSnapshot(owner: self.owner, depth: self.operationCount)
        if self.operationCount > 0: result.id = self.operations[self.operationCount - 1].id

    proc restore(self: RollbackLiChaoTree, position: int) =
        ## 旧直線を逆順に復元する。O(復元する変更数)。
        while self.history.len > position:
            let change = self.history.pop()
            self.lines[change.node] = change.oldLine

    proc undo*(self: RollbackLiChaoTree) =
        ## 直前の追加一操作を取り消す。O(その操作の変更数 + 1)。初期状態はValueError。
        if self.operationCount == 0:
            raise newException(ValueError, "取り消せる追加操作がありません")
        dec self.operationCount
        self.restore(self.operations[self.operationCount].start)

    proc rollback*(self: RollbackLiChaoTree, token: RollbackLiChaoSnapshot) =
        ## tokenへ復元する。O(復元する変更数 + 1)。token自体は変更しない。
        ## 既定値・別木・取り消した分岐のtokenはreleaseでもValueError（木は変更しない）。
        if token.owner != self.owner or token.depth < 0 or token.depth > self.operationCount:
            raise newException(ValueError, "この木の現在の履歴に属するsnapshotが必要です")
        if token.depth > 0 and self.operations[token.depth - 1].id != token.id:
            raise newException(ValueError, "取り消した分岐のsnapshotには戻れません")
        if token.depth < self.operationCount:
            self.restore(self.operations[token.depth].start)
            # 操作配列は再利用し、無変化の操作数に比例する切り詰めを避ける。
            self.operationCount = token.depth
