# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import random
proc run[B,W](T:typedesc[QuadVector[B,W]],kernel:BPlusKernel) =
    var rng=initRand(551231)
    var a=newSeq[int](5000)
    for x in a.mitems:x=rng.rand(3)
    let t=initQuadVector(T,a,kernel)
    proc check() =
        t.validate()
        doAssert t.len==a.len
        var counts:array[4,int]
        for i,x in a:
            if i mod 29==0:
                doAssert t[i]==x
                doAssert t.rankAccess(i)==(counts[x],x)
                doAssert t.ranks(i)==counts
                for d in 0..3:doAssert t.rank(i,d)==counts[d]
            doAssert t.select(x,counts[x])==i
            inc counts[x]
        doAssert t.ranks(a.len)==counts
        for d in 0..3:
            doAssert t.total(d)==counts[d]
            doAssert t.select(d,counts[d])== -1
            doAssert t.select(d,-1)== -1
        for z in 0..<50:
            let l=rng.rand(a.len)
            let r=l+rng.rand(a.len-l)
            for d in 0..3:doAssert t.rankPair(l,r,d)==(t.rank(l,d),t.rank(r,d))
    check()
    for step in 0..<(if defined(dynamicWmFullTest):3000 else:500):
        let d=rng.rand(3)
        let insertion=step mod 3!=0 or a.len==0
        let p=if step mod 5==0:0 elif step mod 5==1:a.len-int(not insertion) else:rng.rand(a.len-int(not insertion))
        var count=0
        if insertion:
            for i in 0..<p:count+=int(a[i]==d)
            doAssert t.insert(p,d)==count
            a.insert(d,p)
        else:
            for i in 0..<p:count+=int(a[i]==a[p])
            doAssert t.erase(p)==(count,a[p])
            a.delete(p)
        if step mod 251==0:check()
    check()
    while a.len>0:
        let p=if a.len mod 2==0:0 else:a.len-1
        doAssert t.erase(p).digit==a[p]
        a.delete(p)
        if a.len in [1024,32,1,0]:check()
    when defined(dynamicWmFullTest): echo "quad vector passed ",B,"/",W," ",kernel
for kernel in [bpkScalar,bpkAvx2,bpkAvx512]:
    if not kernelAvailable(kernel):continue
    run(QuadVector[4,1],kernel)
    run(QuadVector[16,32],kernel)
    run(QuadVector[16,64],kernel)
    run(QuadVector[24,64],kernel)
    run(QuadVector[16,128],kernel)
    run(QuadVector[32,128],kernel)
echo "Hello World"
