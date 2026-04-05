when not declared CPLIB_MATH_SQRT_FLOOR:
    const CPLIB_MATH_SQRT_FLOOR* = 1
    import math
    proc sqrt_heuristic_for_floor_sum*(A,B,N,M:int):seq[tuple[x:int,y:int,dx:int,dy:int,n:int]]=
        ## Ak + B mod M (0 <= k < N) をO(√N)個の等差数列に分解する
        var A = A mod M
        var B = B mod M
        var D = int(sqrt(float(N)))

        var bidx = -1
        var bval = M
        for i in 1..D:
            # min(A*i mod M , -A * i mod M)が最小となるようなiを探す。
            # そのような値はM/D以下になる。
            var val = A*i mod M
            val = min(val,M-val)
            if bval > val:
                bval = val
                bidx = i
        
        if (bidx * A mod M) > M - (bidx * A mod M):
            # -A,M-1-Bに帰着
            for (x,y,dx,dy,n) in sqrt_heuristic_for_floor_sum((M-A) mod M,M-1-B,N,M):
                result.add((x,M-1-y,dx,-dy,n))
            return result
        
        # 元の数列を k mod bidxで分けてbidx個のグループに分ける
        # 各グループを見ると、deltaがA*iになっている(つまり、deltaがM/D以下となる。)

        for g in 0..<bidx:
            var a = A * bidx mod M
            var b = (A * g + B) mod M
            var n = (N - g + bidx - 1) div bidx
            var x = ((a * (n-1) + b) div M) + 1
            var l = 0
            for k in 0..<x:
                var r : int
                if k+1 == x:
                    r = n
                else:
                    r = (M * (k+1) - b + a - 1) div a
                result.add((bidx * l + g, (a * l + b) mod M,bidx,(bidx * A mod M),r-l))
                l = r
