# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph_with_op
import cplib/graph/functional_graph_with_lazy_op
import cplib/graph/graph
import atcoder/lazysegtree
import std/random

type
    Sum = tuple[sum,len:int]
    Affine = tuple[a,b:int]

proc sumOp(x,y:Sum):Sum=
    return (x.sum+y.sum,x.len+y.len)

proc sumE():Sum=
    return (0,0)

proc affineMapping(f:Affine,x:Sum):Sum=
    return (f.a*x.sum+f.b*x.len,x.len)

proc affineComposition(f,g:Affine):Affine=
    # f(g(x))
    return (f.a*g.a,f.a*g.b+f.b)

proc affineId():Affine=
    return (1,0)

let nxt = @[1,2,3,1,2,5,7,6,7]
var naive = @[1,2,3,4,5,6,7,8,9]
var initial = newSeq[Sum](len(naive))
for i,x in naive:
    initial[i] = (x,1)

var fg = initFunctionalGraph_with_lazy_op(
    nxt,initial,sumOp,sumE,affineMapping,affineComposition,affineId
)

proc applyNaive(start,k:int,f:Affine,includeStart:bool)=
    var now = start
    if includeStart:
        for step in 0..k:
            naive[now] = f.a*naive[now]+f.b
            if step < k:
                now = nxt[now]
    else:
        for step in 0..<k:
            now = nxt[now]
            naive[now] = f.a*naive[now]+f.b

proc prodNaive(start,k:int,includeStart:bool):Sum=
    var now = start
    if includeStart:
        for step in 0..k:
            result.sum += naive[now]
            result.len += 1
            if step < k:
                now = nxt[now]
    else:
        for step in 0..<k:
            now = nxt[now]
            result.sum += naive[now]
            result.len += 1

randomize(123456)
for iteration in 0..<400:
    let start = rand(nxt.high)
    let k = rand(30)
    let includeStart = rand(1) == 1
    let action:Affine = (rand(1),rand(5))
    fg.apply(start,k,action,includeStart)
    applyNaive(start,k,action,includeStart)

    if iteration mod 7 == 0:
        let v = rand(nxt.high)
        let x = rand(20)
        fg[v] = (x,1)
        naive[v] = x

    for v in 0..<len(nxt):
        doAssert fg[v] == (naive[v],1)

    let queryStart = rand(nxt.high)
    let queryK = rand(40)
    let queryIncludeStart = rand(1) == 1
    doAssert fg.prod(queryStart,queryK,queryIncludeStart) ==
        prodNaive(queryStart,queryK,queryIncludeStart)

    if iteration mod 11 == 0:
        let l = rand(10)
        let r = l+rand(8)
        let products = fg.prod_range(queryStart,l,r,queryIncludeStart)
        for i,value in products:
            doAssert value == prodNaive(queryStart,l+i,queryIncludeStart)

        let folded = fg.prod_range_fold(
            queryStart,l,r,
            proc(total:int,value:Sum):int = total+value.sum,
            0,queryIncludeStart
        )
        var expected = 0
        for step in l..<r:
            expected += prodNaive(queryStart,step,queryIncludeStart).sum
        doAssert folded == expected

    if iteration mod 13 == 0:
        let limit = rand(25)
        let threshold = rand(150)
        var now = queryStart
        var prefix = 0
        var expected = limit
        for step in 0..limit:
            prefix += naive[now]
            if prefix > threshold:
                expected = step
                break
            if step < limit:
                now = nxt[now]
        doAssert fg.move_while(proc(x:Sum):bool = x.sum <= threshold,queryStart,limit) == expected

# 自己ループではk回移動すると始点にk+1回作用する。
let before = fg[5].sum
fg.apply(5,12,(1,2))
doAssert fg[5].sum == before+26
let hugeK = 1_000_000_000
let beforeHuge = fg[5].sum
fg.apply(5,hugeK,(1,1))
doAssert fg[5].sum == beforeHuge+hugeK+1
doAssert fg.prod(5,hugeK) == ((beforeHuge+hugeK+1)*(hugeK+1),hugeK+1)

# 異なる作用をpushせず重ねた場合もcomposition(new, old)の順になる。
var compositionFg = initFunctionalGraph_with_lazy_op(
    @[0],@[(sum:1,len:1)],sumOp,sumE,
    affineMapping,affineComposition,affineId
)
compositionFg.apply(0,3,(0,3)) # 何度作用しても3への代入
compositionFg.apply(0,2,(1,5)) # その後、3回の+5
doAssert compositionFg.prod(0,4) == (18*5,5)
doAssert compositionFg[0] == (18,1)

proc minOp(x,y:int):int=
    return min(x,y)

proc minE():int=
    return int.high div 4

proc addMapping(f,x:int):int=
    if x == minE():
        return x
    return x+f

proc addComposition(f,g:int):int=
    return f+g

proc addId():int=
    return 0

var minValues = @[9,4,8,2,7,6,3,5,1]
# 追加引数付きの従来名もlazy版コンストラクタとして使える。
var minFg = initFunctionalGraph_with_op(
    nxt,minValues,minOp,minE,addMapping,addComposition,addId
)
minFg.apply(4,17,3)
var now = 4
for step in 0..17:
    minValues[now] += 3
    if step < 17:
        now = nxt[now]

let allReachable = minFg.prod_reachable_idempotent_all()
for start in 0..<len(nxt):
    var seen = newSeq[bool](len(nxt))
    var v = start
    var expected = minE()
    while not seen[v]:
        seen[v] = true
        expected = min(expected,minValues[v])
        v = nxt[v]
    doAssert allReachable[start] == expected

# 全lazyをpushする一括取得後もapply/set/prodを継続利用できる。
minFg.apply(0,11,2)
now = 0
for step in 0..11:
    minValues[now] += 2
    if step < 11:
        now = nxt[now]
minFg[4] = -3
minValues[4] = -3
var expectedMin = minE()
now = 4
for step in 0..20:
    expectedMin = min(expectedMin,minValues[now])
    if step < 20:
        now = nxt[now]
doAssert minFg.prod(4,20) == expectedMin

# UnWeightedDirectedGraphからの構築も確認する。
var g = initUnWeightedDirectedGraph(len(nxt))
for v,to in nxt:
    g.add_edge(v,to)
let graphFg = initFunctionalGraph_with_lazy_op(
    g,initial,sumOp,sumE,affineMapping,affineComposition,affineId
)
doAssert graphFg.movekth(0,4) == 1

# typedesc版なら複数インスタンスを同じ明示型で保持できる。
type SumLazySeg = LazySegTree.getType(
    Sum,Affine,sumOp,sumE,affineMapping,affineComposition,affineId
)
var sameTypeFgs:seq[FunctionalGraph_with_lazy_op[SumLazySeg]]
sameTypeFgs.add(initFunctionalGraph_with_lazy_op(nxt,initial,SumLazySeg))
sameTypeFgs.add(initFunctionalGraph_with_lazy_op(g,initial,SumLazySeg))
doAssert sameTypeFgs[0].prod(0,3) == sameTypeFgs[1].prod(0,3)

# 形の異なる小さなfunctional graphでも愚直法と比較する。
for testCase in 0..<30:
    let n = 1+rand(11)
    var randomNext = newSeq[int](n)
    var randomNaive = newSeq[int](n)
    var randomInitial = newSeq[Sum](n)
    for v in 0..<n:
        randomNext[v] = rand(n-1)
        randomNaive[v] = rand(15)
        randomInitial[v] = (randomNaive[v],1)
    var randomFg = initFunctionalGraph_with_lazy_op(
        randomNext,randomInitial,sumOp,sumE,affineMapping,affineComposition,affineId
    )

    for operation in 0..<80:
        let start = rand(n-1)
        let k = rand(25)
        let includeStart = rand(1) == 1
        let action:Affine = (rand(1),rand(4))
        randomFg.apply(start,k,action,includeStart)

        var now = start
        if includeStart:
            for step in 0..k:
                randomNaive[now] = action.a*randomNaive[now]+action.b
                if step < k:
                    now = randomNext[now]
        else:
            for step in 0..<k:
                now = randomNext[now]
                randomNaive[now] = action.a*randomNaive[now]+action.b

        if operation mod 9 == 0:
            let v = rand(n-1)
            let value = rand(15)
            randomFg[v] = (value,1)
            randomNaive[v] = value

        let queryStart = rand(n-1)
        let queryK = rand(30)
        let queryIncludeStart = rand(1) == 1
        var expected:Sum
        now = queryStart
        if queryIncludeStart:
            for step in 0..queryK:
                expected = sumOp(expected,(randomNaive[now],1))
                if step < queryK:
                    now = randomNext[now]
        else:
            for step in 0..<queryK:
                now = randomNext[now]
                expected = sumOp(expected,(randomNaive[now],1))
        doAssert randomFg.prod(queryStart,queryK,queryIncludeStart) == expected

        if operation mod 8 == 0:
            let l = rand(8)
            let r = l+rand(7)
            let products = randomFg.prod_range(queryStart,l,r,queryIncludeStart)
            for i,product in products:
                var expected:Sum
                now = queryStart
                if queryIncludeStart:
                    for step in 0..(l+i):
                        expected = sumOp(expected,(randomNaive[now],1))
                        if step < l+i:
                            now = randomNext[now]
                else:
                    for step in 0..<(l+i):
                        now = randomNext[now]
                        expected = sumOp(expected,(randomNaive[now],1))
                doAssert product == expected

        if operation mod 10 == 0:
            let limit = rand(25)
            let threshold = rand(150)
            var expectedDistance = limit
            var prefix = 0
            now = queryStart
            for step in 0..limit:
                prefix += randomNaive[now]
                if prefix > threshold:
                    expectedDistance = step
                    break
                if step < limit:
                    now = randomNext[now]
            doAssert randomFg.move_while(
                proc(x:Sum):bool = x.sum <= threshold,queryStart,limit
            ) == expectedDistance

        # query群はpoint getでlazyを押す前に検証する。
        for v in 0..<n:
            doAssert randomFg[v] == (randomNaive[v],1)

proc intAdd(x,y:int):int=
    return x+y

# 4引数の既存コンストラクタは従来どおり非遅延版を返す。
let oldFg = initFunctionalGraph_with_op(nxt,@[1,2,3,4,5,6,7,8,9],intAdd,0)
doAssert oldFg.prod(0,5) == 1+2+3+4+2+3

# 非可換なopでもfunctional graph上の移動順を保つ。
proc concatOp(x,y:seq[int]):seq[int]=
    return x & y

proc concatE():seq[int]=
    return @[]

proc seqAddMapping(f:int,x:seq[int]):seq[int]=
    result = newSeq[int](len(x))
    for i,value in x:
        result[i] = value+f

proc seqAddComposition(f,g:int):int=
    return f+g

proc seqAddId():int=
    return 0

let orderNext = @[1,2,3,1,2,4]
var orderNaive = @[0,1,2,3,4,5]
var orderInitial = newSeq[seq[int]](len(orderNaive))
for i,value in orderNaive:
    orderInitial[i] = @[value]
var orderFg = initFunctionalGraph_with_lazy_op(
    orderNext,orderInitial,concatOp,concatE,
    seqAddMapping,seqAddComposition,seqAddId
)
for iteration in 0..<120:
    let start = rand(orderNext.high)
    let k = rand(25)
    let add = rand(5)
    orderFg.apply(start,k,add)
    var now = start
    for step in 0..k:
        orderNaive[now] += add
        if step < k:
            now = orderNext[now]

    let queryStart = rand(orderNext.high)
    let queryK = rand(30)
    var expected = newSeqOfCap[int](queryK+1)
    now = queryStart
    for step in 0..queryK:
        expected.add(orderNaive[now])
        if step < queryK:
            now = orderNext[now]
    doAssert orderFg.prod(queryStart,queryK) == expected

    if iteration mod 7 == 0:
        let l = rand(8)
        let r = l+rand(6)
        let products = orderFg.prod_range(queryStart,l,r)
        for i,product in products:
            var expected:seq[int]
            now = queryStart
            for step in 0..(l+i):
                expected.add(orderNaive[now])
                if step < l+i:
                    now = orderNext[now]
            doAssert product == expected

echo "Hello World"
