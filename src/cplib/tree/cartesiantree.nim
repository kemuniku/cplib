when not declared CPLIB_TREE_CARTESIAN_TREE:
    const CPLIB_TREE_CARTESIAN_TREE* = 1
    import sequtils

    proc cartesian_tree_tuple*(A:seq[int]):seq[tuple[p:int,l:int,r:int]]=
        result = newseqwith(len(A),(-1,-1,-1))
        var stack : seq[int]

        for i in 0..<(len(A)):
            var s = -1
            while len(stack) > 0 and A[stack[^1]] > A[i]:
                s = stack.pop()
            if s != -1:
                if result[i].l != -1:
                    swap(result[i].l , result[s].l)
                else:
                    result[i].l = s
                result[s].p = i
            if len(stack) > 0:
                result[i].p = stack[^1]
                result[stack[^1]].r = i
            stack.add(i)

            #echo stack.mapit(A[it])