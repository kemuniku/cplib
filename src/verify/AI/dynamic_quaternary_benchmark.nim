# 引数: B ISA leafBits N H Q updatePercent pattern repetition [seed]
# ISA: 0=auto, 1=scalar, 2=AVX2, 3=AVX-512。非対応ISAは終了値77でスキップ。
# -d:dynamicWmBinary は二分岐 B32/W64、それ以外は四分岐 B16/W64, B24/W64, B32/W128。
when defined(dynamicWmBinary):
    import cplib/collections/dynamic_bplus_waveletmatrix
    import cplib/collections/dynamic_bplus_bitvector
else:
    import cplib/collections/dynamic_quaternary_waveletmatrix
    import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import random, times, os, strutils
import dynamic_bplus_stress_trace

proc run[BV](T:typedesc[BV]) =
    let args=commandLineParams()
    let structure=(if defined(dynamicWmBinary):"bplus" else:"quad") & args[0]
    let kernel=case parseInt(args[1])
        of 0:bpkAuto
        of 1:bpkScalar
        of 2:bpkAvx2
        else:bpkAvx512
    let cap=parseInt(args[2])
    let n=parseInt(args[3])
    let width=parseInt(args[4])
    let ops=parseInt(args[5])
    let rate=parseInt(args[6])
    let pattern=args[7]
    let rep=parseInt(args[8])
    if not kernelAvailable(kernel): quit(77)
    let seed=if args.len>9:parseInt(args[9]) else:0
    let (a,actions,length)=buildStressTrace(n,width,ops,rate,pattern,seed)
    let start=cpuTime()
    when defined(dynamicWmBinary):
        let w=initDynamicBPlusWaveletMatrix(a,T,H=width,kernel=kernel)
    else:
        let w=initDynamicQuadWaveletMatrix(a,T,H=width,kernel=kernel)
    let build=cpuTime()-start
    let t=cpuTime()
    var checksum=0'u64
    for op in actions:
        case op.kind
        of 0: w.insert(op.p,op.x)
        of 1: checksum=checksum xor cast[uint64](w.erase(op.p))
        of 2: w[op.p]=op.x
        of 3: checksum=checksum xor cast[uint64](w[op.p])
        of 4: checksum=checksum xor cast[uint64](w.kth_smallest(op.p,op.r,op.k))
        of 5: checksum=checksum xor cast[uint64](w.range_freq(op.p,op.r,op.x,op.y))
        of 6: checksum=checksum xor cast[uint64](w.rank(op.p,op.x))
        else: checksum=checksum xor cast[uint64](w.select(op.k,op.x))
    let elapsed=cpuTime()-t
    doAssert w.len==length
    if pattern in ["front_insert","threshold_cycle"]:
        doAssert w.rank(w.len,0)==w.len
        for p in [0,w.len div 2,w.len-1]:doAssert w[p]==0
    echo $structure,",",$kernel,",",cap,",",n,",",width,",",ops,",",rate,",",pattern,",",rep,",",build,",",elapsed,",",w.storageBytes,",",checksum

doAssert paramCount() in [9,10]
when defined(dynamicWmBinary):
    doAssert paramStr(1)=="32" and paramStr(3)=="4096"
    run(BPlusBitVector[32,64])
else:
    let config=(paramStr(1),paramStr(3))
    if config==("16","4096"):run(QuadVector[16,64])
    elif config==("24","4096"):run(QuadVector[24,64])
    elif config==("32","8192"):run(QuadVector[32,128])
    else:quit(2)
