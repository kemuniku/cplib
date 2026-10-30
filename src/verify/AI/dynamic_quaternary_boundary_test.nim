# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_waveletmatrix_sum
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import cplib/collections/dynamic_bplus_waveletmatrix
import options

const quadTestBranch {.intdefine.} = 16
const quadTestWords {.intdefine.} = 64

template makeWM(values:untyped,H:untyped = -1,signedValues:untyped = false,
                kernel:untyped = bpkAuto):untyped =
    when defined(quadTestBranch) or defined(quadTestWords):
        initDynamicQuadWaveletMatrixSum(values,QuadVector[quadTestBranch,quadTestWords],
            H,signedValues,kernel)
    else:
        initDynamicQuadWaveletMatrixSum(values,H,signedValues,kernel)

template rejects(error:typedesc,body:untyped) =
    block:
        var caught=false
        try:body
        except error:caught=true
        doAssert caught
proc sums[W](w:W,low,high,expected:int,fits:bool) =
    let n=w.len
    if fits:
        doAssert w.sum_upperbound(0,n,high)==expected
        doAssert w.sum_upperbound_with_count(0,n,high)==(expected,n)
        doAssert w.sum_smallest(0,n,n)==expected
        doAssert w.sum_smallest_with_count(0,n,n)==(expected,n)
        if high<int.high:
            doAssert w.sum_lowerbound(0,n,high+1)==expected
            doAssert w.sum_lowerbound_with_count(0,n,high+1)==(expected,n)
            doAssert w.range_sum(0,n,low,high+1)==expected
            doAssert w.range_sum_with_count(0,n,low,high+1)==(expected,n)
    else:
        rejects(OverflowDefect):discard w.sum_upperbound(0,n,high)
        rejects(OverflowDefect):discard w.sum_smallest(0,n,n)
        if high<int.high:
            rejects(OverflowDefect):discard w.sum_lowerbound(0,n,high+1)
            rejects(OverflowDefect):discard w.range_sum(0,n,low,high+1)
    w.validate()
for kernel in [bpkScalar,bpkAvx2,bpkAvx512]:
    if not kernelAvailable(kernel):continue
    let maximum=(1 shl 60)-1
    for uniqueValues in [false,true]:
        for n in [8,9]:
            var a:seq[int]
            var expected=0
            for i in 0..<n:
                let x=maximum-(if uniqueValues:i else:0)
                a.add(x)
                if n==8:expected+=x
            if n == 8: sums(makeWM(a,H=60,kernel=kernel),0,maximum,expected,true)
            else:
                rejects(OverflowDefect): discard makeWM(a,H=60,kernel=kernel)
    for negative in [false,true]:
        for n in [16,17]:
            let x=if negative: -(1 shl 59) else:(1 shl 59)-1
            var a:seq[int]
            var expected=0
            for i in 0..<n:
                a.add(x)
                if n==16:expected+=x
            if n == 16: sums(makeWM(a,H=60,signedValues=true,kernel=kernel),-(1 shl 59),(1 shl 59)-1,expected,true)
            else:
                rejects(OverflowDefect): discard makeWM(a,H=60,signedValues=true,kernel=kernel)
    sums(makeWM(@[int.low,int.high],H=64,signedValues=true,kernel=kernel),int.low,int.high,-1,true)
    for signed in [false,true]:
        let a=if signed: @[-4,3,-1,0,3,-4] else: @[0,7,3,0,7,2]
        let w=makeWM(a,H=3,signedValues=signed,kernel=kernel)
        for l in 0..a.len:
            for r in l..a.len:
                for low in -5..8:
                    for high in low..9:
                        var total,count=0
                        for i in l..<r:
                            if low<=a[i] and a[i]<high:
                                total+=a[i]
                                inc count
                        doAssert w.range_sum_with_count(l,r,low,high)==(total,count)
        let child=w.get_children(1,0,a.len)
        var count=0
        for d in 0..3:count+=child.right[d]-child.left[d]
        doAssert count==a.len
    when defined(dynamicWmFullTest): echo "quad sums passed ",kernel
let empty=makeWM(newSeq[int](),H=0)
doAssert empty.sum_smallest(0,0,0)==0
rejects(AssertionDefect):discard makeWM(@[0],H=65,signedValues=true)
rejects(AssertionDefect):discard makeWM(@[0],H=0,signedValues=true)
let disabled=initDynamicQuadWaveletMatrix(@[1],H=2)
static: doAssert not compiles(disabled.sum_upperbound(0,1,1))
let binary=initDynamicBPlusWaveletMatrix(@[2,1,2],H=2)
doAssert binary.select(1,2)==2
for kernel in BPlusKernel:
    let w=makeWM(@[2,1,2],H=2,kernel=kernel)
    if not kernelAvailable(kernel):doAssert w.activeKernel==bpkScalar
    doAssert w.select(1,2)==2
when defined(dynamicWmFullTest): echo "quad boundary and binary coexistence passed"
echo "Hello World"
