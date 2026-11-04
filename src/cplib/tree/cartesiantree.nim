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
