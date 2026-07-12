when not declared CPLIB_MATH_STERN_BROCOT_TREE:
    import cplib/math/fractions
    import cplib/graph/graph
    import sequtils,algorithm,options
    const CPLIB_MATH_STERN_BROCOT_TREE* = 1
    type SBTNode*[T] = tuple[p:T,q:T,r:T,s:T,depth:T]

    proc den*[T](x:SBTNode[T]):T=
        return x.q+x.s
    proc num*[T](x:SBTNode[T]):T=
        return x.p + x.r
    
    converter toFraction(x:SBTNode[int]):Fraction[int]=
        return initFraction(x.num,x.den,false)

    proc continued_fraction_expansion*[T](a,b:T):seq[T]=
        assert a >= 1
        assert b >= 1
        var a = a
        var b = b
        while true:
            result.add(a div b)
            if a mod b == 0:
                break
            a -= result[^1] * b
            swap(a,b)

    proc encode_path*[T](a,b:T):seq[(char,T)]=
        var CFE = continued_fraction_expansion(a,b)
        CFE[^1] -= 1
        var start = 0
        if CFE[0] == 0:
            start = 1
        
        for i in start..<len(CFE):
            if (i and 1) == 0:
                result.add(('R',CFE[i]))
            else:
                result.add(('L',CFE[i]))
    
    proc encode_path*[T](now:SBTNode[T]):seq[(char,T)]=
        return encode_path(now.num(),now.den())
    
    proc move_left*[T](now:SBTNode[T],d:T):SBTNode[T]=
        return (now.p,now.q,d*now.p+now.r,d*now.q+now.s,now.depth+d)

    proc move_right*[T](now:SBTNode[T],d:T):SBTNode[T]=
        return (now.p+d*now.r,now.q+d*now.s,now.r,now.s,now.depth+d)
    
    proc sbt_root*[T](typ:typedesc[T]):SBTNode[T]=
        return (T(0),T(1),T(1),T(0),T(0))

    proc sbt_root*():SBTNode[int]=
        return sbt_root(int)

    proc sbt_inf*[T](typ:typedesc[T]):SBTNode[T]=
        return (T(1),T(0),T(0),T(0),T(-1))

    proc sbt_inf*():SBTNode[int]=
        return sbt_inf(int)

    proc sbt_zero*[T](typ:typedesc[T]):SBTNode[T]=
        return (T(0),T(1),T(0),T(0),T(-1))

    proc sbt_zero*():SBTNode[int]=
        return sbt_zero(int)
    

    
    proc to_fraction_tuple*[T](x:SBTNode[T]):(T,T)=
        return (x.p + x.r,x.q+x.s)

    proc to_SBTNode*[T](a,b:T):SBTNode[T]=
        var CFE = continued_fraction_expansion(a,b)
        CFE[^1] -= 1
        var start = 0
        if CFE[0] == 0:
            start = 1
        var now = sbt_root(T)
        
        for i in start..<len(CFE):
            if (i and 1) == 0:
                now = move_right(now,CFE[i])
            else:
                now = move_left(now,CFE[i])
        return now

    proc to_endpoint_node[T](a,b:T):SBTNode[T]=
        if b == 0:
            return sbt_inf(T)
        if a == 0:
            return sbt_zero(T)
        return to_SBTNode(a,b)

    proc max_move_count[T](base,step,n:T):T=
        if base > n:
            return T(-1)
        if step == 0:
            return n
        return (n-base) div step

    proc is_inner_node_bounded[T](now:SBTNode[T],n:T):bool=
        return now.num() <= n and now.den() <= n

    proc max_inner_move_left_with_bound[T](now:SBTNode[T],n:T):T=
        ## move_left(d)でできるnode自身の分子・分母がn以下になる最大のd。
        return min(max_move_count(now.num(),now.p,n),max_move_count(now.den(),now.q,n))

    proc max_inner_move_right_with_bound[T](now:SBTNode[T],n:T):T=
        ## move_right(d)でできるnode自身の分子・分母がn以下になる最大のd。
        return min(max_move_count(now.num(),now.r,n),max_move_count(now.den(),now.s,n))

    proc max_endpoint_move_left_with_bound[T](now:SBTNode[T],n:T):T=
        ## move_left(d)で新しくできる右端の分子・分母がn以下になる最大のd。
        return min(max_move_count(now.r,now.p,n),max_move_count(now.s,now.q,n))

    proc max_endpoint_move_right_with_bound[T](now:SBTNode[T],n:T):T=
        ## move_right(d)で新しくできる左端の分子・分母がn以下になる最大のd。
        return min(max_move_count(now.p,now.r,n),max_move_count(now.q,now.s,n))

    proc min_greater_with_den_at_most*[T](x:SBTNode[T],m:T):SBTNode[T]=
        ## xより大きく、分子・分母がm以下である有理数のうち最小のものを返す。
        assert m >= 1

        if x.is_inner_node_bounded(m):
            var now = x.move_right(1)
            if not now.is_inner_node_bounded(m):
                return to_endpoint_node(x.r,x.s)
            return now.move_left(now.max_inner_move_left_with_bound(m))

        var now = sbt_root(T)

        for (c,d) in encode_path(x):
            if c == 'L':
                let lim = min(d,now.max_inner_move_left_with_bound(m))
                now = now.move_left(lim)
                if lim < d:
                    return now
            else:
                let lim = min(d,now.max_inner_move_right_with_bound(m))
                now = now.move_right(lim)
                if lim < d:
                    return to_endpoint_node(now.r,now.s)

        var nxt = now.move_right(1)
        if not nxt.is_inner_node_bounded(m):
            return to_endpoint_node(now.r,now.s)
        return nxt.move_left(nxt.max_inner_move_left_with_bound(m))

    proc max_less_with_den_at_most*[T](x:SBTNode[T],m:T):SBTNode[T]=
        ## xより小さく、分子・分母がm以下である有理数のうち最大のものを返す。
        assert m >= 1

        if x.is_inner_node_bounded(m):
            var now = x.move_left(1)
            if not now.is_inner_node_bounded(m):
                return to_endpoint_node(x.p,x.q)
            return now.move_right(now.max_inner_move_right_with_bound(m))

        var now = sbt_root(T)

        for (c,d) in encode_path(x):
            if c == 'L':
                let lim = min(d,now.max_inner_move_left_with_bound(m))
                now = now.move_left(lim)
                if lim < d:
                    return to_endpoint_node(now.p,now.q)
            else:
                let lim = min(d,now.max_inner_move_right_with_bound(m))
                now = now.move_right(lim)
                if lim < d:
                    return now

        var nxt = now.move_left(1)
        if not nxt.is_inner_node_bounded(m):
            return to_endpoint_node(now.p,now.q)
        return nxt.move_right(nxt.max_inner_move_right_with_bound(m))

    proc decode_path*[T](path:seq[(char,T)]):SBTNode[T]=
        
        var now = sbt_root(T)

        for (c,d) in path:
            if c == 'L':
                now = move_left(now,d)
            else:
                now = move_right(now,d)
        return now
    
    proc LCA*[T](a,b,c,d:T):SBTNode[T]=
        var CFE1 = continued_fraction_expansion(a,b)
        var CFE2 = continued_fraction_expansion(c,d)
        CFE1[^1] -= 1
        CFE2[^1] -= 1
        var now = sbt_root(T)

        for i in 0..<min(len(CFE1),len(CFE2)):
            if (i and 1) == 0:
                now = move_right(now,min(CFE1[i],CFE2[i]))
            else:
                now = move_left(now,min(CFE1[i],CFE2[i]))
            if CFE1[i] != CFE2[i]:
                return now
        return now
    
    proc LCA*[T](a,b:SBTNode[T]):SBTNode[T]=
        LCA(a.num(),a.den(),b.num(),b.den())
    
    proc ancestor*[T](a,b,k:T):Option[SBTNode[T]]=
        var CFE = continued_fraction_expansion(a,b)
        CFE[^1] -= 1
        var now = sbt_root(T)
        var cnt:T = 0
        for i in 0..<len(CFE):
            if (i and 1) == 0:
                now = move_right(now,min(k-cnt,CFE[i]))
            else:
                now = move_left(now,min(k-cnt,CFE[i]))
            cnt += CFE[i]
            if cnt >= k:
                return some(now)
        return none(SBTNode[T])
    
    proc ancestor*[T](now:SBTNode[T],k:T):Option[SBTNode[T]]=
        var CFE = continued_fraction_expansion(now.num(),now.den())
        CFE[^1] -= 1
        var now = sbt_root(T)
        var cnt:T = 0
        for i in 0..<len(CFE):
            if (i and 1) == 0:
                now = move_right(now,min(k-cnt,CFE[i]))
            else:
                now = move_left(now,min(k-cnt,CFE[i]))
            cnt += CFE[i]
            if cnt >= k:
                return some(now)
        return none(SBTNode[T])

    proc get_range*[T](node:SBTNode[T]):(T,T,T,T)=
        return (node.p,node.q,node.r,node.s)

    proc get_range_fraction*[T](node:SBTNode[T]):(Fraction[T],Fraction[T])=
        return (initFraction(node.p,node.q,false),initFraction(node.r,node.s,false))
    
    proc get_range*[T](a,b:T):(T,T,T,T)=
        return get_range(to_SBTNode(a,b))


    proc get_bounds*[T](is_ok:proc(x:SBTNode[T]):bool,n:T):SBTNode[T]=
        # 単調性のある関数is_okを考える。
        # x <= a : true
        # x > a : false
        # となるような境界aを分子・分母がn以下の有理数になるように近似した結果を返す。(その区間が得られるnodeが返る)

        # is_okにはINFと0が与えられる点に注意。
        assert n >= 1

        var now = sbt_root(T)

        var result0 = is_ok(sbt_zero(T))
        var resultinf = is_ok(sbt_inf(T))

        assert result0 != resultinf

        var is_left = false

        var result_now = is_ok(now)

        if result0 != result_now:
            is_left = true
        
        while now.is_inner_node_bounded(n):
            if is_left:
                # 新しくできる右端の分子・分母がn以下になる範囲で移動可能
                # どこまで潜ったら初めてresult_nowと結果が変わるのかを二分探索
                let lim = now.max_endpoint_move_left_with_bound(n)
                if lim <= 0:
                    break
                var l:T = 0
                var r = lim
                if is_ok(now.move_left(r)) == result_now:
                    now = now.move_left(r)
                    break
                while r-l > 1:
                    var mid = (r+l) div 2
                    if is_ok(now.move_left(mid)) == result_now:
                        l = mid
                    else:
                        r = mid
                now = now.move_left(r)
            else:
                # 新しくできる左端の分子・分母がn以下になる範囲で移動可能
                # 二分探索
                let lim = now.max_endpoint_move_right_with_bound(n)
                if lim <= 0:
                    break
                var l:T = 0
                var r = lim
                if is_ok(now.move_right(r)) == result_now:
                    now = now.move_right(r)
                    break
                while r-l > 1:
                    var mid = (r+l) div 2
                    if is_ok(now.move_right(mid)) == result_now:
                        l = mid
                    else:
                        r = mid
                now = now.move_right(r)
            result_now = not result_now
            is_left = not is_left
            #echo "now!",now.toFraction()
        return now

    
    proc cmp_with_ein(a,b:SBTNode[int]):int=
        # -1 : <
        # +1 : >
        # 0 : =
        if a == b:
            return 0
        
        var (la,ra) = a.get_range_fraction()
        var (lb,rb) = b.get_range_fraction()

        var x = a.toFraction()
        var y = b.toFraction()
        
        if lb < x and x < rb:
            return 1
        
        if la < y and y < ra:
            return -1
        
        return cmp(x,y)



    proc initAuxiliaryWeightedTree*(v:openArray[SBTNode[int]]):WeightedUnDirectedTableGraph[SBTNode[int],int]=
        ## 根が欲しかったらG.v[0]を使ってください　けむにく
        assert len(v) > 0
        var v = v.sorted(cmp_with_ein)
        for i in 0..<(len(v)-1):
            v.add(LCA(v[i],v[i+1]))
        v = v.sorted(cmp_with_ein).deduplicate(true)
        var stack :seq[SBTNode[int]]
        result = initWeightedUnDirectedTableGraph(v,int)
        stack.add(v[0])
        for i in 1..<len(v):
            while len(stack) > 0 and LCA(stack[^1],v[i]) != stack[^1]:
                discard stack.pop()
            if len(stack) != 0:
                result.add_edge(stack[^1],v[i],(v[i].depth)-(stack[^1].depth))
            stack.add(v[i])