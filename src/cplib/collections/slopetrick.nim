when not declared CPLIB_COLLECTIONS_SLOPETRICK:
    const CPLIB_COLLECTIONS_SLOPETRICK* = 1
    import heapqueue
    import cplib/utils/constants

    # https://ei1333.github.io/library/structure/others/slope-trick.hpp

    type SlopeTrick = ref object
        L : HeapQueue[int]
        R : HeapQueue[int]
        min_f : int
        l_add : int
        r_add : int

    proc pushL(f:SlopeTrick, x:int)=
        f.L.push(-x+f.l_add)

    proc pushR(f:SlopeTrick, x:int)=
        f.R.push(x-f.r_add)

    proc L0(f:SlopeTrick):int=
        return -f.L[0]+f.l_add

    proc R0(f:SlopeTrick):int=
        return f.R[0]+f.r_add

    proc popL(f:SlopeTrick):int=
        return -f.L.pop()+f.l_add

    proc popR(f:SlopeTrick):int=
        return f.R.pop()+f.r_add

    proc pushpopL(f:SlopeTrick, x:int):int=
        return -f.L.pushpop(-x+f.l_add)+f.l_add

    proc pushpopR(f:SlopeTrick, x:int):int=
        return f.R.pushpop(x-f.r_add)+f.r_add

    proc clearL*(f:SlopeTrick)=
        f.L.clear()
        f.pushL(-INF64)

    proc clearR*(f:SlopeTrick)=
        f.R.clear()
        f.pushR(INF64)

    proc min*(f:SlopeTrick):int=
        return f.min_f

    proc add_all*(f:SlopeTrick, a:int)=
        f.min_f += a

    proc add_x_minus_a*(f:SlopeTrick, a:int)=
        ## f(x)にmax(x-a,0)を加算
        ## ＿／
        f.min_f += max(f.L0-a,0)
        var x = f.pushpopL(a)
        f.pushR(x)


    proc add_a_minus_x*(f:SlopeTrick, a:int)=
        ## f(x)にmax(a-x,0)を加算
        ## ＼＿
        f.min_f += max(a-f.R0,0)
        var x = f.pushpopR(a)
        f.pushL(x)

    proc add_abs*(f:SlopeTrick, a:int)=
        add_x_minus_a(f,a)
        add_a_minus_x(f,a)

    proc min_index*(f:SlopeTrick):int=
        return f.L0

    proc shift*(f:SlopeTrick, a:int)=
        f.l_add += a
        f.r_add += a

    proc initSlopeTrick*(a:int):SlopeTrick=
        result = SlopeTrick(L: initHeapQueue[int](), R: initHeapQueue[int](), min_f: a, l_add: 0, r_add: 0)
        result.pushL(-INF64)
        result.pushR(INF64)


