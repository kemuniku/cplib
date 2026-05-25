when not declared CPLIB_UTILS_KNAPSACK:
    const CPLIB_UTILS_KNAPSACK* = 1
    import sequtils,math,bitops,algorithm
    import cplib/utils/constants
    proc solve_01knapsack_NW*(items:seq[tuple[v:int,w:int]],W:int):int=
        # sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        # O(NW)
        var DP = newseqwith(W+1,-INF64)
        DP[0] = 0
        for i in 0..<len(items):
            var (v,w) = items[i]
            for j in countdown(W-w,0,1):
                DP[j+w] = max(DP[j+w],DP[j]+v)
        return DP.max()

    proc solve_01knapsack_NV*(items:seq[tuple[v:int,w:int]],W:int):int=
        # sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        # O(N sum(v_i))
        var V = items.mapit(it.v).sum()
        var DP = newseqwith(V+1,INF64)
        DP[0] = 0
        for i in 0..<len(items):
            var (v,w) = items[i]
            for j in countdown(V-v,0,1):
                DP[j+v] = min(DP[j+v],DP[j]+w)
        for i in countdown(V,0,1):
            if DP[i] <= W:
                return i

    proc solve_01knapsack_meet_in_middle*(items:seq[tuple[v:int,w:int]],W:int):int=
        # sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        # O(N 2^{N/2})
        
        proc naive_knapsack(items:seq[tuple[v:int,w:int]]):seq[tuple[v:int,w:int]]=
            var X = len(items)
            result = newseqwith(1 shl X,(0,0))
            for bit in 1..<(1 shl X):
                var i = fastLog2(bit)
                var (v,w) = result[bit xor (1 shl i)]
                result[bit] = (v+items[i].v,w+items[i].w)
        
        var A = naive_knapsack(items[0..<(len(items) div 2)])
        var B = naive_knapsack(items[(len(items) div 2)..<(len(items))]).mapit((it[1],it[0])).sorted()
        for i in 1..<len(B):
            B[i][1] = max(B[i][1],B[i-1][1])
        var ans = -INF64
        for (v,w) in A:
            if w > W:
                continue
            var (a,b) = B[B.lowerBound((W-w,INF64))-1]
            ans = max(ans,b+v)
        return ans