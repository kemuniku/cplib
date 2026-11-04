when not declared CPLIB_UTILS_LARSCH:
    const CPLIB_UTILS_LARSCH* = 1

    # Larmore–Schieber (1991) の行削減・列削減を独立に実装した。
    # 原著者の説明・証明: https://web.cs.unlv.edu/larmore/Research/ltol.02.pdf
    type
        LarschComparison = proc(row, oldCol, newCol: int): bool {.closure.}
        LarschLevel = ref object
            count, row, left, pending: int
            headers: seq[int]
            child: LarschLevel
            better: LarschComparison
        Larsch* = object
            level: LarschLevel

    proc newLarschLevel(count: int, better: LarschComparison): LarschLevel =
        ## 行を半減する再帰を構築する。時間・空間 O(count)。
        let level = LarschLevel(count: count, better: better)
        if count >= 2:
            proc reduced(row, oldCol, newCol: int): bool =
                ## 列削減した行列の比較を元の行列に写す。
                level.better(row * 2 + 1, level.headers[oldCol], level.headers[newCol])
            level.child = newLarschLevel(count div 2, reduced)
        return level

    proc advance(level: LarschLevel): int =
        ## 次の行の左端最小列を返す。全行で O(count) 回の比較。
        let row = level.row
        if row mod 2 == 1:
            result = level.pending
            if level.better(row, result, row): result = row
        else:
            var right = row
            if row + 1 < level.count:
                # 偶数番目の行だけを残し、その対角列を除いた行列を列削減する。
                # headers[p] は行 2*p+1 以降に残す列。列 2*p まで処理すると確定する。
                let first = if row == 0: 0 else: row - 1
                for col in first..row:
                    while level.headers.len > 0:
                        let p = level.headers.len - 1
                        # 無効列を比較しないので、確定した header は pop されない。
                        if col > p * 2: break
                        if not level.better(p * 2 + 1, level.headers[p], col): break
                        level.headers.setLen(p)
                    if level.headers.len < level.child.count:
                        level.headers.add(col)
                right = level.headers[advance(level.child)]
                level.pending = right
            # 左端最小列の単調性で、直前の行の答えと次の縮約行の答えの間を探索する。
            result = level.left
            for col in level.left + 1..right:
                if level.better(row, result, col): result = col
        level.left = result
        inc level.row

    proc initLarsch*[F](n: int, better: F): Larsch =
        ## 三角全単調行列 A[row,col] (0<=col<=row<n) のオンライン行最小値探索を構築する。
        ## better(row,oldCol,newCol) は新列が真に小さい場合だけ true。同値は左端を返す。
        ## col>row は無効で比較しない。各行の有限候補を比較した行列が全単調であること:
        ## r<s, a<b<=r で A[r,b]<A[r,a] なら A[s,b]<A[s,a]。
        ## 単に各行の最小列が単調なだけでは不十分。前提を自動検査しない。
        ## Larsch のコピーは同じ探索状態を共有する。独立した探索には再構築すること。
        ## next() の呼出し番号 t (0始まり) では、列 0..t の値が全行で利用可能であること。
        ## 将来の行も比較するが、列 t+1 以降は参照しない。返却後に列 t+1 を確定してよい。
        ## 全 n 回で時間・比較回数・空間 O(n) (比較 O(1) の場合)。1回の最悪時間は O(n)。
        assert n >= 0, "行数は非負である必要があります"
        proc compare(row, oldCol, newCol: int): bool =
            ## 呼出し元の比較を保持する。
            better(row, oldCol, newCol)
        result.level = newLarschLevel(n, compare)

    proc next*(search: var Larsch): int =
        ## 次の行の左端最小列を返す。ちょうど n 回だけ順番に呼び出せる。
        assert search.level != nil and search.level.row < search.level.count,
            "LARSCH の行を使い切っています"
        advance(search.level)

    proc onlineTotallyMonotoneDP*[T, F](n: int, initial: T, transition: F):
            tuple[costs: seq[T], prev: seq[int]] =
        ## dp[0]=initial, dp[j]=min(transition(j,i,dp[i]) | 0<=i<j) を O(n) で求める。
        ## transition(to,from,finalizedValue) の実現行列 A[j-1,i] が上記の三角全単調であること。
        ## transition は引数と事前に利用可能なデータだけに依存し、列の確定後は不変であること。
        ## 全辺の候補を有限値で定義し、比較は厳密な全順序であること (NaN は不可)。
        ## 未来の to も評価するが、dp[from] は必ず確定済み。同値は最小の from、prev[0]=-1。
        ## 空入力では空列。transition の時間 O(1) なら時間・空間 O(n)。
        assert n >= 0, "頂点数は非負である必要があります"
        var costs = newSeq[T](n)
        var prev = newSeq[int](n)
        if n == 0: return (costs, prev)
        costs[0] = initial
        prev[0] = -1
        proc better(row, oldCol, newCol: int): bool =
            ## 確定済み dp の値だけから候補を比較する。
            transition(row + 1, newCol, costs[newCol]) <
                transition(row + 1, oldCol, costs[oldCol])
        var search = initLarsch(n - 1, better)
        for j in 1..<n:
            let i = search.next()
            prev[j] = i
            costs[j] = transition(j, i, costs[i])
        return (costs, prev)
