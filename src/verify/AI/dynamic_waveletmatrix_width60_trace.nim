import random
import dynamic_waveletmatrix_width32_trace

proc buildWidth60Trace*(n,width,ops,rate:int,pattern:string):tuple[initial:seq[int],actions:seq[WidthTraceOp],finalLen:int] =
    doAssert sizeof(int)==8
    doAssert width in [18,32,60]
    if width!=60:return buildWidthTrace(n,width,ops,rate,pattern)
    result=buildWidthTrace(n,18,ops,rate,pattern)
    if pattern=="random":
        var valueRng=initRand(600819721)
        let maximum=int((1'u64 shl 60)-1'u64)
        for x in result.initial.mitems:x=valueRng.rand(maximum)
        for op in result.actions.mitems:
            if op.kind<=2:
                op.x=valueRng.rand(maximum)
            else:
                let x=valueRng.rand(maximum)
                let y=valueRng.rand(maximum)
                op.x=min(x,y)
                op.y=max(x,y)
