# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import dynamic_bplus_stress_trace
import random, algorithm, options

template makeWM(values:untyped,H:untyped,signedValues:untyped=false,kernel:untyped=bpkAuto):untyped =
    when defined(quadBranch24):
        initDynamicQuadWaveletMatrix(values,QuadVector[24,64],H,signedValues,kernel)
    elif defined(quadBranch32):
        initDynamicQuadWaveletMatrix(values,QuadVector[32,128],H,signedValues,kernel)
    else:
        initDynamicQuadWaveletMatrix(values,H,signedValues,kernel)

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
                let w=makeWM(a,H=width,kernel=kernel)
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

for signed in [false,true]:
    for width in [0,1,2,3,7,17,31,59,63,64]:
        if signed and width==0:continue
        if not signed and width==64:continue
        let low=if not signed:0 elif width==64:int.low else: -(1 shl (width-1))
        let high=if width==64 or (not signed and width==63):int.high elif signed:(1 shl (width-1))-1 else:(1 shl width)-1
        var a = @[low,high,0,low,high,0]
        let w=makeWM(a,H=width,signedValues=signed)
        var rng=initRand(917415+width)
        audit(w,a,rng)
        for step in 0..<(if defined(dynamicWmFullTest):500 else:90):
            let value=case step mod 5
                of 0:low
                of 1:high
                of 2:0
                else:
                    if width==64:
                        let v=rng.rand(int.high)
                        if step mod 2==0:v else:not v
                    else:low+rng.rand(high-low)
            let kind=if a.len==0:0 else:step mod 3
            let pos=rng.rand(a.len-int(kind!=0))
            case kind
            of 0:
                w.insert(pos,value)
                a.insert(value,pos)
            of 1:
                doAssert w.erase(pos)==a[pos]
                a.delete(pos)
            else:
                w[pos]=value
                a[pos]=value
            if step mod 41==0:audit(w,a,rng)
        audit(w,a,rng)
        while a.len>0:
            doAssert w.erase(0)==a[0]
            a.delete(0)
        audit(w,a,rng)
        rejects:discard w[0]
        rejects:discard w.erase(0)
        rejects:discard w.kth_smallest(0,0,0)
        rejects:w.insert(-1,0)
        rejects:w.insert(1,0)
        if low>int.low:
            rejects:w.insert(0,low-1)
        if high<int.high:
            rejects:w.insert(0,high+1)
        w.insert(0,high)
        doAssert w[0]==high and w.select(0,high)==0
        w.validate()
    when defined(dynamicWmFullTest): echo "odd H and signed boundary passed signed=",signed
# digit orderとselect逆写像を低い全値域で全探索する。
for width in 0..6:
    var a:seq[int]
    for x in 0..<(1 shl width):
        a.add(x)
        a.add((1 shl width)-1-x)
    let w=makeWM(a,H=width)
    var rng=initRand(11)
    audit(w,a,rng)
    for x in 0..<(1 shl width):
        var k=0
        for i,v in a:
            if v==x:
                doAssert w.select(k,x)==i
                inc k
        doAssert w.rank(a.len,x)==k
    for i in 0..<a.len:
        w[i]=(a[i]+1) mod (1 shl width)
        a[i]=(a[i]+1) mod (1 shl width)
    audit(w,a,rng)
when defined(dynamicWmFullTest): echo "digit order and inverse mapping passed"
echo "Hello World"
