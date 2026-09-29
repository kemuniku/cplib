when not declared CPLIB_TREE_DSU_ON_TREE:
    ## DSU on treeで各部分木を集計する。通常はaddとanswerだけを指定する。
    ##
    ## .. code-block:: nim
    ##
    ##   import cplib/tree/dsu_on_tree
    ##   let g = @[@[1, 2], @[0], @[0]]
    ##   var total = 0
    ##   var answers = newSeq[int](g.len)
    ##   proc add(v: int) = total += v + 1
    ##   proc answer(v: int) = answers[v] = total
    ##   dsuOnTree(g, add, answer)
    ##   # answers == @[6, 2, 3]、total == 0
    ##   proc clearState(v: int) = total -= v + 1
    ##   dsuOnTree(g, add, answer, clear = clearState, root = 0)
    ##
    const CPLIB_TREE_DSU_ON_TREE* = 1
    import cplib/tree/heavylightdecomposition
    import cplib/utils/private/auto_rollback

    proc runDsuOnTree[Clear](hld: HeavyLightDecomposition, add: proc(v: int),
            answer: proc(v: int), clear: Clear) =
        ## HLD順を逆から走査し、保持中の区間を一括または頂点ごとに破棄する。O(N log N)回の追加。
        assert hld != nil and hld.numVertices > 0
        var activeLeft, activeRight: int
        template clearActive() =
            ## 正常に追加した頂点を破棄する。clearの例外時には再度呼び出さない。
            if activeLeft < activeRight:
                let first = activeLeft
                let last = activeRight
                activeLeft = activeRight
                when compiles(clear()):
                    clear()
                else:
                    for j in first..<last:
                        clear(hld.toVtx(j))
        try:
            # HLD順の逆順ではlight部分木、heavy部分木、親の順に処理できる。
            for i in countdown(hld.numVertices - 1, 0):
                let v = hld.toVtx(i)
                let heavy = hld.heavyChildOf(v)
                let first = if heavy == -1: i + 1 else: hld.subtree(heavy)[1]
                if activeLeft == activeRight:
                    activeLeft = first
                    activeRight = first
                for j in first..<hld.subtree(v)[1]:
                    add(hld.toVtx(j))
                    activeRight = j + 1
                add(v)
                activeLeft = i
                answer(v)
                if hld.heavyRootOf(v) == v:
                    clearActive()
        finally:
            clearActive()

    proc dsuOnTree*(hld: HeavyLightDecomposition, add: proc(v: int),
            answer: proc(v: int), clear: proc(v: int)) =
        ## 各頂点v自身を含む部分木を集計し、answer(v)を一度ずつ呼ぶ。add・clearは各O(N log N)回。
        ## 空の集計から開始し、破棄する部分木の各頂点vにclear(v)を一度ずつ呼ぶ。正常終了時は空に戻る。
        ## clear(v)は頂点vの寄与を取り除くこと。削除順は未規定で、削除の途中にadd・answerは呼ばない。
        ## answerは集計を変更せず答えを保存すること。答えは追加順によらず、回答順は未規定。
        ## コールバックには元の頂点番号を渡す。実行中はHLDを変更しないこと。自動記録は行わない。
        ## 例外時も追加済みの頂点を削除する。addが例外を送出する場合、その呼び出しでは状態を変更しないこと。
        ## clearは例外を送出しないこと。各コールバックがO(1)なら全体O(N log N)、追加空間O(1)。
        runDsuOnTree(hld, add, answer, clear)

    template dsuOnTree*(hld: HeavyLightDecomposition, add: proc(v: int), answer: proc(v: int)) =
        ## addの変更前の値を記録し、部分木の集計を自動で破棄する。addはO(N log N)回。
        ## 空の集計から開始すること。終了・例外時は実行前の値に戻す。answerの変更は記録しない。
        ## answer(v)ではv自身を含む部分木が集計される。集計を変更せず、追加順に依存しない答えを保存すること。
        ## addには静的に特定できるprocを渡す。数値・タプル・固定長配列の更新に対応し、seqの伸縮は未対応。
        ## 変更先は実行終了まで生存し、add以外から変更・解放しないこと。HLDも実行中は変更しないこと。
        ## 配列ごとに判定ビット列と保存領域を確保し、足りないときだけ拡張する。ハッシュは使用しない。
        ## 固定の配列・変数は実行開始時に保存先を確認し、更新ごとの領域確認を省く。
        ## 同じ領域の各添字は次の破棄まで一度だけ保存する。共通の初期値は共有し、異なる値だけ個別に保存する。
        ## 復元時は触った添字だけを戻す。領域の混在・再入などで判定できない更新は、変更のたびに値を保存する。
        ## 時間は走査・更新・保存・復元と領域拡張の合計、追加空間は配列別の最大確保量と履歴量に比例する。
        runAutoClearImpl(hld, add, answer, runDsuOnTree)

    template dsuOnTree*(g: typed, add: proc(v: int), answer: proc(v: int), clear: proc(v: int), root: int = 0) =
        ## 木gをrootで根付けて集計する。手動clear版。HLD構築の期待時間・追加空間O(N)。
        ## gはinitHldが受け取れる木・隣接リスト。静的グラフは事前にbuildし、辺の重みは参照しない。
        block:
            let tree = g
            let treeRoot = root
            assert tree.len > 0 and 0 <= treeRoot and treeRoot < tree.len
            let decomposition = initHld(tree, treeRoot)
            dsuOnTree(decomposition, add, answer, clear)

    template dsuOnTree*(g: typed, add: proc(v: int), answer: proc(v: int), root: int = 0) =
        ## 木gをrootで根付けて集計する。自動復元版。HLD構築の期待時間・追加空間O(N)。
        ## gの条件は手動clear版、add・answerの条件はHLDを渡す自動復元版と同じ。
        block:
            let tree = g
            let treeRoot = root
            assert tree.len > 0 and 0 <= treeRoot and treeRoot < tree.len
            let decomposition = initHld(tree, treeRoot)
            dsuOnTree(decomposition, add, answer)
