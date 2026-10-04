when not declared CPLIB_TREE_CARTESIAN_TREE:
    const CPLIB_TREE_CARTESIAN_TREE* = 1
    import sequtils

    proc cartesian_tree_tuple*(A: seq[int]): seq[tuple[p: int, l: int, r: int]] =
        ## 最小値Cartesian treeの親と左右の子をO(N)で返す。同値は左側を優先する。
        result = newSeqWith(A.len, (-1, -1, -1))
        var root = -1
        for i in 0..<A.len:
            var p = i - 1
            # 親リンクが単調スタックの次要素を表す。各リンクは高々一度だけ外れる。
            while p != -1 and A[p] > A[i]:
                p = result[p].p
            let left = if p == -1: root else: result[p].r
            result[i].p = p
            result[i].l = left
            if left != -1: result[left].p = i
            if p == -1: root = i
            else: result[p].r = i

    proc cartesian_tree_subtree_ranges*(A: seq[int]): seq[tuple[l: int, r: int]] =
        ## 各頂点iの部分木が占める元配列の半開区間[l,r)を時間・空間O(N)で返す。
        ## 同値は左側優先、空入力は空列。入力を変更せず、再帰を使わない。
        let tree = A.cartesian_tree_tuple()
        result = newSeq[tuple[l: int, r: int]](A.len)
        # 左の子は小さい添字、右の子は大きい添字なので各端点を順に確定できる。
        for i in 0..<A.len:
            result[i].l = if tree[i].l == -1: i else: result[tree[i].l].l
        for i in countdown(A.len - 1, 0):
            result[i].r = if tree[i].r == -1: i + 1 else: result[tree[i].r].r
