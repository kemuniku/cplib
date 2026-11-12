# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_bplus_bitvector
import cplib/collections/dynamic_bplus_kernels
import random

proc run[B,W:static int](T:typedesc[BPlusBitVector[B,W]],kernel:BPlusKernel) =
    var rng=initRand(855221)
    var a=newSeq[bool](if defined(dynamicWmFullTest):20000 else:5000)
    for x in a.mitems:x=rng.rand(1)==1
    let t=initBitVector(T,a,kernel)
    proc check() =
        t.validate()
        var prefix=newSeq[int](a.len+1)
        for i,x in a:prefix[i+1]=prefix[i]+int(x)
        for i in 0..200:
            let l=if i==0:0 elif i==1:a.len else:rng.rand(a.len)
            let r=if i<3:a.len else:l+rng.rand(a.len-l)
            doAssert t.rankPair(l,r)==(prefix[l],prefix[r])
            doAssert t.rankPair(l,l)==(prefix[l],prefix[l])
        for l in [0,1,63,64,65,127,128,129,W*64-1,W*64,W*64+1,a.len-1,a.len]:
            if l<0 or l>a.len:continue
            for r in [l,min(a.len,l+1),min(a.len,l+63),min(a.len,l+64),a.len]:
                doAssert t.rankPair(l,r)==(prefix[l],prefix[r])
    check()
    for step in 0..<(if defined(dynamicWmFullTest):5000 else:500):
        if step mod 3==0:
            let p=rng.rand(a.len)
            let bit=rng.rand(1)==1
            var rank=0
            for i in 0..<p:rank+=int(a[i])
            doAssert t.insert(p,bit)==rank
            a.insert(bit,p)
        else:
            let p=rng.rand(a.len-1)
            var rank=0
            for i in 0..<p:rank+=int(a[i])
            doAssert t.erase(p)==(rank,a[p])
            a.delete(p)
        if step mod 257==0:check()
    # 初期の大きいプールから大半を削除し、最小占有率と空根も検査する。
    while a.len>0:
        let p=if a.len mod 2==0:0 else:a.len-1
        doAssert t.erase(p).bit==a[p]
        a.delete(p)
        if a.len in [10000,1000,100,1,0]:check()
    when defined(dynamicWmFullTest): echo "pair and sparse deletion passed B=",B," W=",W," ",kernel

for kernel in [bpkScalar,bpkAvx2,bpkAvx512]:
    if not kernelAvailable(kernel):continue
    run(BPlusBitVector[4,1],kernel)
    run(BPlusBitVector[8,8],kernel)
    run(BPlusBitVector[12,16],kernel)
    run(BPlusBitVector[16,32],kernel)
    run(BPlusBitVector[24,64],kernel)
    run(BPlusBitVector[32,64],kernel)
echo "Hello World"
