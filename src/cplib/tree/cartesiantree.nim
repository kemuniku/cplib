when not declared CPLIB_TREE_CARTESIAN_TREE:
    const CPLIB_TREE_CARTESIAN_TREE* = 1
    import cplib/graph/graph
    import sequtils

    proc cartesian_tree_tuple*(A:seq[int]):seq[tuple[p:int,l:int,r:int]]=
        ## Cartesian Treeを構築する。 O(N)
        ## (各頂点の親、左の子、右の子)　を返す。存在しない場合-1が入る。
        result = newseqwith(len(A),(-1,-1,-1))
        var stack : seq[int] = @[A[0]]

        for i in 1..<(len(A)):
            while len(stack) > 0 and A[stack[^1]] > A[i]:
                var s = stack.pop()
                result[i].l = s
                result[s].p = i
            if len(stack) > 0:
                result[i].p = stack[^1]
                result[stack[^1]].r = i
            stack.add(i)





