# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_bplus_waveletmatrix
import cplib/collections/dynamic_bplus_bitvector
import cplib/collections/dynamic_bplus_kernels
import algorithm, random, options

doAssert sizeof(int)==8
const unsignedMax=int((1'u64 shl 60)-1'u64)
const signedMin= -(1 shl 59)
const signedMax=(1 shl 59)-1

template rejects(error:typedesc,body:untyped) =
    block:
        var caught=false
        try:body
        except error:caught=true
        doAssert caught

proc selected[W](w:W,k,x:int):int =
    w.select(k,x)

proc check[W](w:W,a:seq[int],low,high:int) =
    doAssert w.len==a.len
    var sorted=a
    sorted.sort()
    for i,x in a:
        doAssert w[i]==x
    doAssert w.range_freq(0,a.len,low,high+1)==a.len
    # 高々7個なら60bit値のすべての中間和がint64に収まる。
    let take=min(7,a.len)
    var total=0
    for i in 0..<take:total+=a[i]
    doAssert w.range_sum(0,take,low,high+1)==total
    doAssert w.sum_smallest_with_count(0,take,take)==(total,take)
    doAssert w.sum_upperbound_with_count(0,take,high)==(total,take)
    doAssert w.sum_lowerbound_with_count(0,take,high+1)==(total,take)
    for x in [low-1,low,low+1,0,high-1,high,high+1]:
        var count,less,atMost:int
        var previous,next:Option[int]
        for i,y in a:
            if y==x:
                doAssert selected(w,count,x)==i
                inc count
            if y<x:
                inc less
                if previous.isNone or y>previous.get:previous=some(y)
            if y<=x:inc atMost
            if y>=x and (next.isNone or y<next.get):next=some(y)
        doAssert w.rank(a.len,x)==count
        doAssert selected(w,count,x)== -1
        doAssert w.range_lowerbound(0,a.len,x)==less
        doAssert w.range_upperbound(0,a.len,x)==atMost
        doAssert w.prev_value(0,a.len,x)==previous
        doAssert w.next_value(0,a.len,x)==next
        doAssert w.range_freq(0,a.len,x,x+1)==count
    if a.len>0:
        for k in [0,a.len div 2,a.len-1]:
            doAssert w.kth_smallest(0,a.len,k)==sorted[k]
            doAssert w.kth_largest(0,a.len,k)==sorted[a.len-1-k]
    let l=a.len div 3
    let r=a.len*2 div 3
    var middle=a[l..<r]
    middle.sort()
    doAssert w.range_freq(l,r,low,high+1)==r-l
    if middle.len>0:doAssert w.kth_smallest(l,r,middle.len div 2)==middle[middle.len div 2]

proc exercise[W](w:W,initial:seq[int],low,high:int) =
    var a=initial
    var rng=initRand(3201122)
    check(w,a,low,high)
    for step in 0..<(if defined(dynamicWmFullTest):2000 else:250):
        let value=case step mod 7
            of 0:low
            of 1:high
            of 2:low+1
            of 3:high-1
            of 4:0
            else:low+rng.rand(high-low)
        let kind=if a.len==0:0 else:step mod 3
        let p=rng.rand(a.len-int(kind!=0))
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
        if step mod 127==0:check(w,a,low,high)
    check(w,a,low,high)
    rejects(AssertionDefect,w.insert(0,high+1))
    rejects(AssertionDefect):w[0]=low-1
    check(w,a,low,high)
    while a.len>0:
        doAssert w.erase(a.len-1)==a[^1]
        a.setLen(a.len-1)
    check(w,a,low,high)
    w.insert(0,high)
    w.insert(0,low)
    check(w,@[low,high],low,high)

proc verifySums[W](w:W,low,high:int,fits:bool,expected:int) =
    let n=w.len
    if fits:
        doAssert w.sum_smallest(0,n,n)==expected
        doAssert w.sum_smallest_with_count(0,n,n)==(expected,n)
        doAssert w.sum_upperbound(0,n,high)==expected
        doAssert w.sum_upperbound_with_count(0,n,high)==(expected,n)
        doAssert w.sum_lowerbound(0,n,high+1)==expected
        doAssert w.sum_lowerbound_with_count(0,n,high+1)==(expected,n)
        doAssert w.range_sum(0,n,low,high+1)==expected
        doAssert w.range_sum_with_count(0,n,low,high+1)==(expected,n)
    else:
        rejects(OverflowDefect):discard w.sum_smallest(0,n,n)
        rejects(OverflowDefect):discard w.sum_smallest_with_count(0,n,n)
        rejects(OverflowDefect):discard w.sum_upperbound(0,n,high)
        rejects(OverflowDefect):discard w.sum_upperbound_with_count(0,n,high)
        rejects(OverflowDefect):discard w.sum_lowerbound(0,n,high+1)
        rejects(OverflowDefect):discard w.sum_lowerbound_with_count(0,n,high+1)
        rejects(OverflowDefect):discard w.range_sum(0,n,low,high+1)
        rejects(OverflowDefect):discard w.range_sum_with_count(0,n,low,high+1)
    # overflowを起こした問い合わせが構造を変えていないことも確かめる。
    doAssert w.len==n and w.range_freq(0,n,low,high+1)==n

block:
    for cap in [2048,4096]:
        var a:seq[int]
        for i in 0..<513:a.add([0,1,unsignedMax,unsignedMax-1][i mod 4])
        if cap==2048:
            exercise(initDynamicBPlusWaveletMatrix(a,BPlusBitVector[16,32],H=60,with_sum=true,kernel=bpkAvx2),a,0,unsignedMax)
        else:
            exercise(initDynamicBPlusWaveletMatrix(a,BPlusBitVector[32,64],H=60,with_sum=true,kernel=bpkAvx2),a,0,unsignedMax)
        when defined(dynamicWmFullTest): echo "unsigned H60 B+16/32 passed cap=",cap
        for uniqueValues in [false,true]:
            for count in [8,9]:
                var values:seq[int]
                var expected=0
                for i in 0..<count:
                    let v=unsignedMax-(if uniqueValues:i else:0)
                    values.add(v)
                    if count==8:expected+=v
                if cap==2048:
                    verifySums(initDynamicBPlusWaveletMatrix(values,BPlusBitVector[16,32],H=60,with_sum=true,kernel=bpkAvx2),0,unsignedMax,count==8,expected)
                else:
                    verifySums(initDynamicBPlusWaveletMatrix(values,BPlusBitVector[32,64],H=60,with_sum=true,kernel=bpkAvx2),0,unsignedMax,count==8,expected)
        when defined(dynamicWmFullTest): echo "unsigned H60 sum limits passed B+ cap=",cap
echo "Hello World"
