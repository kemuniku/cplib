# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/functional_graph_with_lazy_op
import atcoder/lazysegtree

type Sum = tuple[sum,len:int]
proc op(x,y:Sum):Sum = (x.sum+y.sum,x.len+y.len)
proc e():Sum = (0,0)
proc mapping(f:int,x:Sum):Sum = (x.sum+f*x.len,x.len)
proc composition(f,g:int):int = f+g
proc id():int = 0
proc foldNamed(total:int,value:Sum):int {.nimcall.} = total+value.sum
proc belowNamed(value:Sum):bool {.nimcall.} = value.sum<=3

type ST = typeof(initLazySegTree[Sum,int](@[(1,1)],op,e,mapping,composition,id))
let fg = initFunctionalGraph_with_lazy_op(@[0],@[(1,1)],ST)
doAssert fg.prod_range_fold(0,0,3,foldNamed,0)==6
doAssert fg.prod_range_fold(0,0,3,proc(total:int,value:Sum):int = total+value.sum,0)==6
doAssert fg.prod_range_fold(0,0,3,proc(total:int,value:Sum):int {.closure.} = total+value.sum,0)==6
doAssert fg.prod_range_fold(0,1,1,foldNamed,7)==7
doAssert fg.move_while(belowNamed,0,9)==3
doAssert fg.move_while(proc(value:Sum):bool = value.sum<=3,0,9)==3
doAssert fg.move_while(proc(value:Sum):bool {.closure.} = value.sum<=3,0,9)==3

proc checkCaptures(bonus,threshold:int) =
    let fold:proc(total:int,value:Sum):int = proc(total:int,value:Sum):int = total+value.sum+bonus
    let predicate:proc(value:Sum):bool = proc(value:Sum):bool = value.sum<=threshold
    doAssert fg.prod_range_fold(0,0,3,fold,0)==6+3*bonus
    doAssert fg.move_while(predicate,0,9)==threshold
checkCaptures(2,4)
checkCaptures(5,1)

doAssert prod_range_fold[ST,int](fg,0,0,3,foldNamed,0)==6
doAssert move_while[ST](fg,belowNamed,0,9)==3
doAssert fg.prod_range_fold(0,0,3,proc(total:float,value:Sum):float = total+float(value.sum),0)==6.0
doAssert fg.prod_range_fold(0,0,3,proc(total:string,value:Sum):string = total & $value.sum,"")=="123"
static:
    doAssert not compiles(fg.prod_range_fold(0,0,1,proc(total:int,value:string):int = total,0))
    doAssert not compiles(fg.move_while(proc(value:string):bool = true,0,9))
let foldProc = prod_range_fold[ST,int]
doAssert foldProc(fg,0,0,3,foldNamed,0,true)==6
let moveProc = move_while[ST]
doAssert moveProc(fg,belowNamed,0,9)==3

var evaluations:array[7,int]
proc counted[T](index:int,value:T):T =
    inc evaluations[index]
    value
doAssert counted(0,fg).prod_range_fold(counted(1,0),counted(2,0),counted(3,3),counted(4,foldNamed),counted(5,0),counted(6,true))==6
for count in evaluations: doAssert count==1
evaluations=default(array[7,int])
doAssert counted(0,fg).move_while(counted(1,belowNamed),counted(2,0),counted(3,9))==3
for index in 0..3: doAssert evaluations[index]==1
static:
    doAssert not compiles(fg.prod_range_fold(0,0,1,proc(total:int,value:Sum):string = "",0))
    doAssert not compiles(fg.prod_range_fold(0,0,1,foldNamed,"bad"))
    doAssert not compiles(fg.move_while(proc(value:Sum):int = 1,0,9))
static:
    doAssert not compiles(prod_range_fold[ST,float](fg,0,0,3,foldNamed,0))
    doAssert not compiles(prod_range_fold[ST,string](fg,0,0,3,foldNamed,0))
    doAssert typeof(prod_range_fold[ST,float](fg,0,0,3,proc(total:float,value:Sum):float=total+float(value.sum),0)) is float
echo "Hello World"
