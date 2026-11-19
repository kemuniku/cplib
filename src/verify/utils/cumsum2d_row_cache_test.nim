# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/cumsum2d

proc oracle(a:openArray[seq[int]], il,ir,jl,jr:int):int =
    for i in il..<ir:
        for j in jl..<jr:
            result+=a[i][j]

proc check(a:openArray[seq[int]]) =
    let height=a.len
    let width=if height==0:0 else:a[0].len
    let cs=toCumSum2D(a)
    for il in 0..height:
        for ir in il..height:
            for jl in 0..width:
                for jr in jl..width:
                    doAssert cs.query(il,ir,jl,jr)==oracle(a,il,ir,jl,jr)

check(newSeq[seq[int]]())
check([newSeq[int](),newSeq[int]()])
check([@[0]])
check([@[1,2],@[3,4]])
check([@[1],@[2,99]])
for code in 0..<729:
    var a = @[newSeq[int](3),newSeq[int](3)]
    var x=code
    for i in 0..<a.len:
        for j in 0..<a[i].len:
            a[i][j]=x mod 3-1
            x=x div 3
    check(a)
var rng=initRand(20261005)
for trial in 0..<400:
    var a=newSeq[seq[int]](rng.rand(0..10))
    let width=rng.rand(0..10)
    for i in 0..<a.len:
        a[i]=newSeq[int](width)
        for j in 0..<width:
            a[i][j]=rng.rand(-1000000..1000000)
    check(a)
let highCell=toCumSum2D([@[high(int)]])
doAssert highCell.query(0,1,0,1)==high(int)
let lowCell=toCumSum2D([@[low(int)]])
doAssert lowCell.query(0,1,0,1)==low(int)
let cancellation=toCumSum2D([@[-high(int),0],@[high(int),1]])
doAssert cancellation.query(0,2,0,2)==1
doAssert cancellation.query(0,2,0,1)==0
let rows=[@[1,2],@[3,4],@[5,6]]
check(rows.toOpenArray(1,2))
echo "Hello World"
