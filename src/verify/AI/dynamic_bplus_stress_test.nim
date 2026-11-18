# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_bplus_waveletmatrix
import cplib/collections/dynamic_bplus_bitvector
import cplib/collections/dynamic_bplus_kernels
import dynamic_bplus_stress_trace
import random, algorithm, options

template rejects(body:untyped) =
    block:
        var caught=false
        try:body
        except AssertionDefect:caught=true
        doAssert caught

proc audit[W](w:W,a:seq[int],rng:var Rand) =
    w.validate()
    doAssert w.len==a.len
    for i,x in a:doAssert w.access(i)==x
    for trial in 0..<12:
        let l=rng.rand(a.len)
        let r=l+rng.rand(a.len-l)
        let x=if a.len>0:a[rng.rand(a.len-1)] else:0
        var less,count,atMost=0
        var previous,next:Option[int]
        var sorted=a[l..<r]
        sorted.sort()
        for y in sorted:
            if y<x:
                inc less
                previous=some(y)
            if y==x:inc count
            if y<=x:inc atMost
            if y>=x and next.isNone:next=some(y)
        doAssert w.count(l,r,x)==count
        doAssert w.range_lowerbound(l,r,x)==less
        doAssert w.range_upperbound(l,r,x)==atMost
        doAssert w.prev_value(l,r,x)==previous
        doAssert w.next_value(l,r,x)==next
        if x<int.high:doAssert w.range_freq(l,r,x,x+1)==count
        if r>l:
            let k=rng.rand(r-l-1)
            doAssert w.kth_smallest(l,r,k)==sorted[k]
            doAssert w.kth_largest(l,r,k)==sorted[sorted.len-1-k]
        var total=0
        for i,y in a:
            if y==x:
                doAssert w.select(total,x)==i
                inc total
        doAssert w.rank(a.len,x)==total
        doAssert w.select(total,x)== -1
        doAssert w.select(-1,x)== -1

for kernel in [bpkScalar,bpkAvx2,bpkAvx512]:
    if not kernelAvailable(kernel):continue
    for width in [18,32,60]:
        for seed in 0..(if defined(dynamicWmFullTest):2 else:0):
            for pattern in ["random","biased","constant","endpoints","hotspot"]:
                let trace=buildStressTrace(257,width,(if defined(dynamicWmFullTest):1800 else:240),70,pattern,seed)
                var a=trace.initial
                let w=initDynamicBPlusWaveletMatrix(a,H=width,kernel=kernel)
                var rng=initRand(418211+seed)
                for step,op in trace.actions:
                    case op.kind
                    of 0:
                        w.insert(op.p,op.x)
                        a.insert(op.x,op.p)
                    of 1:
                        doAssert w.erase(op.p)==a[op.p]
                        a.delete(op.p)
                    of 2:
                        w.update(op.p,op.x)
                        a[op.p]=op.x
                    of 3:doAssert w[op.p]==a[op.p]
                    of 4:
                        var part=a[op.p..<op.r]
                        part.sort()
                        doAssert w.kth_smallest(op.p,op.r,op.k)==part[op.k]
                    of 5:
                        var count=0
                        for i in op.p..<op.r:count+=int(op.x<=a[i] and a[i]<op.y)
                        doAssert w.range_freq(op.p,op.r,op.x,op.y)==count
                    of 6:
                        var count=0
                        for i in 0..<op.p:count+=int(a[i]==op.x)
                        doAssert w.rank(op.p,op.x)==count
                    else:
                        var seen=0
                        var expected= -1
                        for i,y in a:
                            if y==op.x:
                                if seen==op.k:expected=i
                                inc seen
                        doAssert w.select(op.k,op.x)==expected
                    if step mod 251==0:audit(w,a,rng)
                audit(w,a,rng)
                doAssert w.len==trace.finalLen
    when defined(dynamicWmFullTest): echo "stress oracle passed ",kernel

for width in [0,1,63]:
    let maximum=if width==63:int.high else:(1 shl width)-1
    let w=initDynamicBPlusWaveletMatrix(newSeq[int](),H=width,with_sum=true)
    doAssert w.len==0 and w.rank(0,0)==0 and w.select(0,0)== -1
    doAssert w.range_freq(0,0,-1,int.high)==0
    doAssert w.prev_value(0,0,1).isNone and w.next_value(0,0,0).isNone
    doAssert w.sum_smallest(0,0,0)==0
    rejects:discard w[0]
    rejects:discard w.erase(0)
    rejects:discard w.kth_smallest(0,0,0)
    rejects:discard w.rank(1,0)
    rejects:discard w.count(0,-1,0)
    rejects:w.insert(-1,0)
    rejects:w.insert(1,0)
    rejects:w.insert(0,-1)
    if width<63:
        rejects:w.insert(0,maximum+1)
    w.insert(0,maximum)
    w.insert(0,0)
    doAssert w.select(0,maximum)==int(maximum!=0)
    doAssert w.sum_upperbound(0,2,int.high)==maximum
    doAssert w.range_upperbound(0,2,int.high)==2
    doAssert w.range_lowerbound(0,2,-1)==0
    doAssert w.erase(1)==maximum
    doAssert w.erase(0)==0
    w.validate()
rejects:discard initDynamicBPlusWaveletMatrix(@[0],H=64)
rejects:discard initDynamicBPlusWaveletMatrix(@[-1],H=1)
let auto=initDynamicBPlusWaveletMatrix(@[0,1])
doAssert auto.bitWidth==1
rejects:auto.insert(0,2)
let disabled=initDynamicBPlusWaveletMatrix(@[1],H=2)
rejects:discard disabled.sum_smallest(0,1,1)
for kernel in BPlusKernel:
    let w=initDynamicBPlusWaveletMatrix(@[2,1,2],H=2,kernel=kernel)
    if not kernelAvailable(kernel):doAssert w.activeKernel==bpkScalar
    doAssert w.select(1,2)==2
echo "Hello World"
