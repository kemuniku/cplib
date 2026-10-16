# verification-helper: IGNORE
# 手動の全量検証スクリプトで実行する多段木テスト。
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import random, algorithm
proc run[QV](T:typedesc[QV],kernel:BPlusKernel) =
    const maximum=(1 shl 60)-1
    var rng=initRand(788213)
    var a=newSeq[int](140000)
    for i in 0..<a.len:a[i]=if i mod 17==0:0 else:rng.rand(maximum)
    let w=initDynamicQuadWaveletMatrix(a,T,H=60,kernel=kernel)
    for step in 0..<1000:
        let value=if step mod 7==0:maximum elif step mod 7==1:0 else:rng.rand(maximum)
        let kind=step mod 3
        let p=case step mod 5
            of 0:0
            of 1:a.len-int(kind!=0)
            else:rng.rand(a.len-int(kind!=0))
        case kind
        of 0:
            w.insert(p,value)
            a.insert(value,p)
        of 1:
            doAssert w.erase(p)==a[p]
            a.delete(p)
        else:
            w[p]=value
            a[p]=value
        if step mod 25==0:
            doAssert w.len==a.len
            let pos=rng.rand(a.len-1)
            let x=a[pos]
            var before,total=0
            for i,y in a:
                if y==x:
                    inc total
                    if i<pos:inc before
            doAssert w[pos]==x and w.rank(pos,x)==before
            doAssert w.select(before,x)==pos and w.rank(a.len,x)==total
            doAssert w.select(total,x)== -1
            let l=rng.rand(a.len-1)
            let r=min(a.len,l+2000)
            var b=a[l..<r]
            b.sort()
            let k=rng.rand(b.len-1)
            doAssert w.kth_smallest(l,r,k)==b[k]
            var less=0
            for y in b:less+=int(y<x)
            doAssert w.range_lowerbound(l,r,x)==less
        if step mod 250==0:w.validate()
    w.validate()
    when defined(dynamicWmFullTest): echo "large multi-level seq oracle passed ", $T, " ",kernel
for kernel in [bpkAvx2,bpkAvx512]:
    if not kernelAvailable(kernel):continue
    run(QuadVector[24,64],kernel)
    run(QuadVector[32,128],kernel)
echo "Hello World"
