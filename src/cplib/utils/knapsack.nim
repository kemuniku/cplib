when not declared CPLIB_UTILS_KNAPSACK:
    const CPLIB_UTILS_KNAPSACK* = 1
    import sequtils,math,bitops,algorithm
    import cplib/utils/constants
    proc solve_01knapsack_NW*(items:openArray[tuple[v:int,w:int]],W:int):int=
        ## sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        ## O(NW)
        var DP = newseqwith(W+1,-INF64)
        DP[0] = 0
        for i in 0..<len(items):
            var (v,w) = items[i]
            for j in countdown(W-w,0,1):
                DP[j+w] = max(DP[j+w],DP[j]+v)
        return DP.max()

    proc solve_01knapsack_NV*(items:openArray[tuple[v:int,w:int]],W:int):int=
        ## sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        ## O(N sum(v_i))
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

    proc solve_01knapsack_meet_in_middle*(items:openArray[tuple[v:int,w:int]],W:int):int=
        ## sum(w_i) <= Wとなるようなitemの取り方で、vが最大のものを選ぶ
        ## O(N 2^{N/2})
        
        let items = @items
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
    
    proc solve_UBknapsack_NW*(items:openArray[tuple[v:int,w:int]],W:int):int=
        ## 各アイテムを何回でも選んでいいナップサック問題
        ## O(NW)
        var DP = newseqwith(W+1,-INF64)
        DP[0] = 0
        for i in 0..<len(items):
            var (v,w) = items[i]
            for j in 0..(W-w):
                DP[j+w] = max(DP[j+w],DP[j]+v)
        return DP.max()
    
    proc solve_BoundedKnapsack*(items:openArray[tuple[v:int,w:int,m:int]], W:int):int =
        var dp = newSeq[int](W + 1)
        for (v, w, m0) in items:
            if w > W:
                continue
            if w == 0:
                for i in 0..W:
                    dp[i] += v*m0
                continue
            let m = min(m0, W div w)
            var buf = dp
            var s = 0
            while s * w <= W:
                let l = s * w
                let r = min(W + 1, (s + m) * w)
                for i in l ..< r - w:
                    dp[i + w] = max(dp[i + w], dp[i] + v)
                for i in countdown(r - w - 1, l):
                    buf[i] = max(buf[i], buf[i + w] - v)
                s += m
            for i in w * m .. W:
                dp[i] = max(dp[i], buf[i - w * m] + v * m)
        return dp[W]
