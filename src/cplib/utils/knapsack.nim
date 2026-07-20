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

    proc maxPlusConcave(w:int, items:seq[tuple[v:int,w:int,m:int]], dp:var seq[int]) =
        ## `items` はすべて重さ w。個数ごとの最大価値（凹列）との
        ## max-plus convolution を monotone minima で計算する。
        let z = dp.high
        var a = @[0]
        let lim = z div w
        var xs = items
        xs.sort(proc(x,y:tuple[v:int,w:int,m:int]):int = cmp(y.v,x.v))
        for x in xs:
            var k = 0
            while k < x.m and a.len <= lim:
                a.add(a[^1] + x.v)
                inc k
        for s in 0..<w:
            let n = (z-s) div w + 1
            var d0 = newSeq[int](n)
            var d1 = newSeqWith(n, -INF64)
            for i in 0..<n: d0[i] = dp[i*w+s]
            proc rec(l,r,optL,optR:int) =
                if l >= r: return
                let mid = (l+r) div 2
                let lo = max(optL,mid-a.high)
                let hi = min(mid,optR)
                var best = lo
                for t in lo..hi:
                    if d0[t] > -INF64 and d1[mid] < d0[t]+a[mid-t]:
                        d1[mid] = d0[t]+a[mid-t]
                        best = t
                rec(l,mid,optL,best)
                rec(mid+1,r,best,optR)
            rec(0,n,0,n-1)
            for i in 0..<n: dp[i*w+s] = d1[i]

    proc solve_PowerKnapsack*(items:openArray[tuple[v:int,t:int]], Z0,K:int):int =
        ## (6): 各品物の重さが K^t の 0-1 ナップサック。O(N log N + log Z)
        assert K >= 2
        var z = Z0
        var levels = 0
        var q = z
        while q > 0: inc levels; q = q div K
        var vals = newSeq[seq[int]](levels+1)
        for x in items:
            if x.t < levels: vals[x.t].add(x.v)
        result = 0
        for t in 0..<levels:
            vals[t].sort()
            while z mod K > 0 and vals[t].len > 0:
                result += vals[t].pop()
                dec z
            while vals[t].len > 0:
                var v = 0
                for _ in 0..<K:
                    if vals[t].len > 0: v += vals[t].pop()
                vals[t+1].add(v)
            z = z div K

    proc solve_SmallCoefficientPowerKnapsack*(items:openArray[tuple[v:int,s:int,t:int,m:int]], Z0:int):int =
        ## (7): 重さ s*2^t の個数制限付きナップサック。
        var maxT = 0
        for x in items: maxT = max(maxT,x.t)
        var ranked = newSeq[seq[tuple[v:int,w:int,m:int]]](maxT+66)
        for x in items: ranked[x.t].add((x.v,x.s,x.m))
        var dp = @[0]
        var z = Z0
        var t = 0
        while z > 0:
            for x in ranked[t]:
                var rem = x.m
                if rem >= 1: rem = 1 + (rem-1) mod 2
                for _ in 0..<rem:
                    let oldHigh = dp.high
                    for _ in 0..<x.w: dp.add(dp[^1])
                    for i in countdown(oldHigh,0):
                        dp[i+x.w] = max(dp[i+x.w],dp[i]+x.v)
                ranked[t+1].add((x.v*2,x.w,(x.m-rem) div 2))
            var nx:seq[int]
            var i = z mod 2
            while i < dp.len: nx.add(dp[i]); i += 2
            nx.add(dp[^1])
            dp = nx
            z = z div 2
            inc t
        result = dp[min(z,dp.high)]

    proc solve_LargeUnboundedKnapsack*(items:openArray[tuple[v:int,w:int]], Z:int):int =
        ## (8): Z > (max w)^2 を想定した完全ナップサック。O(N max(w))
        if items.len == 0: return 0
        var best = items[0]
        for x in items:
            if best.v*x.w < x.v*best.w: best = x
        var gain = newSeq[int](best.w)
        for x in items:
            if x != best:
                gain[x.w mod best.w] = max(gain[x.w mod best.w],x.v-best.v*(x.w div best.w))
        var dp = newSeq[int](best.w)
        for w in 0..<best.w:
            if gain[w] <= 0: continue
            let g = gcd(w,best.w)
            for s in 0..<g:
                var p = s
                for _ in 0..<(best.w div g*2):
                    var nx = p+w
                    var v = gain[w]
                    if nx >= best.w: nx -= best.w; v -= best.v
                    dp[nx] = max(dp[nx],dp[p]+v)
                    p = nx
        result = -INF64
        for r in 0..<best.w:
            var cur = dp[r]
            if r > Z mod best.w: cur -= best.v
            result = max(result,cur)
        result += (Z div best.w)*best.v

    proc solve_FewWeightsKnapsack*(items:openArray[tuple[v:int,w:int,m:int]], Z:int):int =
        ## (9): 異なる重さが少ない個数制限付きナップサック。
        ## O(Z * #weights * log Z + N log N)
        var ranked = newSeq[seq[tuple[v:int,w:int,m:int]]](Z+1)
        for x in items:
            if x.w <= Z: ranked[x.w].add(x)
        var dp = newSeq[int](Z+1)
        for w in 1..Z:
            if ranked[w].len > 0: maxPlusConcave(w,ranked[w],dp)
        result = dp[Z]

    proc solve_SmallWeightKnapsack*(items0:openArray[tuple[v:int,w:int,m:int]], Z0:int):int =
        ## (10): max(w) が小さい個数制限付きナップサック。
        ## O(max(w)^3 log(max(w)) + N log N)
        if items0.len == 0: return 0
        var items = @items0
        items.sort(proc(x,y:tuple[v:int,w:int,m:int]):int =
            cmp(x.v*y.w,x.w*y.v))
        var maxW = 0
        for x in items: maxW = max(maxW,x.w)
        var a,b = newSeq[seq[tuple[v:int,w:int,m:int]]](maxW+1)
        var z = Z0
        var off = 0
        while items.len > 0:
            var x = items[^1]
            let n = min(z div x.w,x.m)
            off += n*x.v; z -= n*x.w; x.m -= n
            if n > 0: a[x.w].add((x.v,x.w,n))
            items[^1] = x
            if x.m > 0: break
            discard items.pop()
        for x in items:
            if x.m > 0: b[x.w].add(x)
        let z2 = maxW*(maxW+1)
        var left = newSeqWith(z2+1,-INF64)
        var right = newSeq[int](z2+1)
        left[0] = 0
        for w in 1..maxW:
            if a[w].len > 0:
                for i in 0..<a[w].len: a[w][i].v = -a[w][i].v
                maxPlusConcave(w,a[w],left)
            if b[w].len > 0: maxPlusConcave(w,b[w],right)
        for i in countdown(z2-1,0): left[i] = max(left[i],left[i+1])
        result = off
        for removed in 0..maxW*(maxW-1):
            let added = removed+z
            if added <= z2 and left[removed] > -INF64:
                result = max(result,off+left[removed]+right[added])

    proc solve_SmallValueKnapsack*(items0:openArray[tuple[v:int,w:int,m:int]], Z0:int):int =
        ## (11): max(v) が小さい個数制限付きナップサック。
        ## O(max(v)^3 log(max(v)) + N log N)
        if items0.len == 0: return 0
        var items = @items0
        items.sort(proc(x,y:tuple[v:int,w:int,m:int]):int =
            cmp(x.v*y.w,x.w*y.v))
        var maxV = 0
        for x in items: maxV = max(maxV,x.v)
        var a,b = newSeq[seq[tuple[v:int,w:int,m:int]]](maxV+1)
        var z = Z0
        var off = 0
        while items.len > 0:
            var x = items[^1]
            let n = min(z div x.w,x.m)
            off += n*x.v; z -= n*x.w; x.m -= n
            if n > 0: a[x.v].add((x.w,x.v,n))
            items[^1] = x
            if x.m > 0: break
            discard items.pop()
        for x in items:
            if x.m > 0: b[x.v].add((-x.w,x.v,x.m))
        let z2 = maxV*(maxV+1)
        var removedWeight = newSeq[int](z2+1)
        var negAddedWeight = newSeqWith(z2+1,-INF64)
        negAddedWeight[0] = 0
        for v in 1..maxV:
            if a[v].len > 0: maxPlusConcave(v,a[v],removedWeight)
            if b[v].len > 0: maxPlusConcave(v,b[v],negAddedWeight)
        for i in countdown(z2-1,0):
            negAddedWeight[i] = max(negAddedWeight[i],negAddedWeight[i+1])
        result = off
        var q = z2
        for removedValue in countdown(maxV*(maxV-1),0):
            while q > 0 and removedWeight[removedValue]+z < -negAddedWeight[q]: dec q
            result = max(result,off-removedValue+q)
