import random

type WidthTraceOp* = tuple[kind,p,r,k,x,y:int]
proc buildWidthTrace*(n,width,ops,rate:int,pattern:string):tuple[initial:seq[int],actions:seq[WidthTraceOp],finalLen:int] =
    doAssert sizeof(int)==8
    doAssert width in [18,32]
    doAssert pattern in ["random","front_insert","threshold_cycle"]
    var rng=initRand(819721)
    let limit=(1 shl 18)-1
    proc value(rng:var Rand,i:int):int =
        case pattern
        of "toggle", "threshold", "front_insert", "threshold_cycle": 0
        of "constant": limit div 2
        of "biased": (if rng.rand(99)<95: 0 else:rng.rand(limit))
        of "ascending": min(limit,i)
        of "descending": max(0,limit-i)
        else: rng.rand(limit)
    var a=newSeq[int](n)
    for i in 0..<n: a[i]=rng.value(i)
    var actions=newSeq[WidthTraceOp](ops)
    var length=n
    for i in 0..<ops:
        if pattern=="front_insert":
            actions[i]=(0,0,0,0,0,0)
            inc length
            continue
        if pattern=="threshold_cycle":
            let stage=if i<1024: -1 else: (i-1024) mod 2052
            let kind=if stage>=1 and stage<=1026:1 else:0
            actions[i]=(kind,0,0,0,0,0)
            length += (if kind==0:1 else: -1)
            continue
        if pattern=="toggle":
            let kind=i mod 2
            actions[i]=(kind,0,0,0,0,0)
            length += (if kind==0:1 else: -1)
            continue
        if rng.rand(99)<rate or pattern=="split_churn":
            let kind=if pattern=="split_churn": (if i mod 4096<2048:0 else:1) else: i mod 3
            let p=case pattern
                of "endpoints": (if i mod 2==0:0 else:length-int(kind!=0))
                of "hotspot": length div 2
                of "split_churn": 0
                else: rng.rand(length-int(kind!=0))
            actions[i]=(kind,p,0,0,rng.value(n+i),0)
            if kind==0: inc length
            elif kind==1: dec length
        else:
            let l=rng.rand(length-1)
            let r=l+1+rng.rand(length-l-1)
            let x=rng.value(i)
            let y=rng.rand(limit)
            actions[i]=(3+rng.rand(4),l,r,rng.rand(r-l-1),min(x,y),max(x,y))
    # 位置・操作種別・区間・kはH18の既存traceを維持し、値だけ独立乱数へ置き換える。
    if width==32 and pattern=="random":
        var valueRng=initRand(320819721)
        let maximum=int(0xffff_ffff'u64)
        for i in 0..<a.len:a[i]=valueRng.rand(maximum)
        for op in actions.mitems:
            if op.kind<=2:
                op.x=valueRng.rand(maximum)
            else:
                let x=valueRng.rand(maximum)
                let y=valueRng.rand(maximum)
                op.x=min(x,y)
                op.y=max(x,y)
    (a,actions,length)
