import atcoder/lazysegtree
import sequtils
import cplib/utils/constants

proc initRangeAddRangeMin*(v:seq[int]):auto=
    ## 区間加算区間min
    type S = int
    type F = int
    proc op(a,b:S):S=min(a,b)
    proc e():S=INF64
    proc mapping(f:F,x:S):S=f+x
    proc composition(f,g:F):F=f+g
    proc id():F=0
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v)

proc initRangeAddRangeMax*(v:seq[int]):auto=
    ## 区間加算区間max
    type S = int
    type F = int
    proc op(a,b:S):S=max(a,b)
    proc e():S = -(INF64)
    proc mapping(f:F,x:S):S=f+x
    proc composition(f,g:F):F=f+g
    proc id():F=0
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v)

proc initRangeAddRangeMinMax*(v:seq[int]):auto=
    ## 区間加算区間(min,max)
    type S = (int,int)
    type F = int
    proc op(a,b:S):S=(min(a[0],b[0]),max(a[1],b[1]))
    proc e():S = (INF64,-INF64)
    proc mapping(f:F,x:S):S=(x[0]+f,x[1]+f)
    proc composition(f,g:F):F=f+g
    proc id():F=0
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v.mapit((it,it)))

proc initRangeAddRangeMinCount*(v:seq[int]):auto=
    ## 区間加算区間(min,最小値の個数)
    type S = (int,int)
    type F = int
    proc op(a,b:S):S=
        if a[0] == b[0]:
            return (a[0],a[1]+b[1])
        elif a[0] < b[0]:
            return a
        else:
            return b
    proc e():S=(INF64,1)
    proc mapping(f:F,x:S):S=(x[0]+f,x[1])
    proc composition(f,g:F):F=f+g
    proc id():F=0
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v.mapit((it,1)))

proc initRangeAddRangeMaxCount*(v:seq[int]):auto=
    ## 区間加算区間(max,最小値の個数)
    type S = (int,int)
    type F = int
    proc op(a,b:S):S=
        if a[0] == b[0]:
            return (a[0],a[1]+b[1])
        elif a[0] > b[0]:
            return a
        else:
            return b
    proc e():S=(-INF64,1)
    proc mapping(f:F,x:S):S=(x[0]+f,x[1])
    proc composition(f,g:F):F=f+g
    proc id():F=0
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v.mapit((it,1)))

# proc initRangeAddRangeMin*(v:seq[int]):auto=
#     ## 区間加算区間min
#     type S = int
#     type F = int
#     proc op(a,b:S):S=min(a,b)
#     proc e():S=INF64
#     proc mapping(f:F,x:S):S=f+x
#     proc composition(f,g:F):F=f+g
#     proc id():F=0
#     return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v)


proc initRangeAffineRangeSum*(v:seq[int]):auto=
    ## 区間一次関数作用区間和
    type S = (int,int)
    type F = (int,int)
    proc op(a,b:S):S=(a[0]+b[0],a[1]+b[1])
    proc e():S=(int(0),0)
    proc mapping(f:F,x:S):S= (f[0] * x[0] + f[1] * x[1],x[1])
    proc composition(f,g:F):F=(f[0]*g[0],f[0]*g[1]+f[1])
    proc id():F=(int(1),int(0))
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v.mapit((it,1)))

proc initRangeClampRangeMinMax*(v:seq[int]):auto=
    ## 区間Clamp関数作用(chmin,chmax,add,change) 区間 (min,max)
    ## ただし、作用は`F=(a,b,c)`として、`min(c,max(b,x+a))`
    ## 加算したいとき:`(x,-INF,INF)`を作用
    ## chmaxしたいとき:`(0,x,INF)`を作用
    ## chminしたいとき:`(0,-INF,x)`を作用
    ## 区間変更したいとき:`(0,x,x)`を作用
    ## clampしたいとき:`(0,l,r)`を作用
    type S = (int,int)
    type F = (int,int,int)
    proc op(a,b:S):S= (min(a[0],b[0]),max(a[1],b[1]))
    proc e():S=(INF64,-INF64)
    proc mapping(f:F,x:S):S= (max(f[1],min(x[0]+f[0],f[2])),max(f[1],min(x[0]+f[1],f[2])))
    proc composition(f,g:F):F= (g[0]+f[0],max(f[1],min(g[1]+f[0],f[2])),min(g[2]+f[0],f[2]))
    proc id():F=(0,-INF64,INF64)
    return LazySegTree.getType(S, F, op, e, mapping, composition, id).init(v.mapit((it,it)))