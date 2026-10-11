import random, algorithm, times, strutils, os
import std/monotimes
import cplib/graph/hungarian

template ensure(condition: untyped) =
    if not condition: raise newException(ValueError,"AVX-512 benchmark validation failed")
const seed = 20261011
let plan = if paramCount() == 0: "interleaved0" else: paramStr(1)
let modes = if plan == "avx2": @[0] elif plan == "avx512": @[1] else: @[0,1]
let rotation = if plan == "interleaved1": 1 else: 0
var checksum = 0'i64
proc solve(c: seq[seq[int32]], a: seq[seq[bool]], mode: int): MinCostAssignmentResult =
    ## 同じアルゴリズムのAVX2とAVX-512を明示選択する。
    min_cost_assignment_int32_fast(c,a,vector=(if mode == 0: assignmentVectorAvx2 else: assignmentVectorAvx512))
proc run(n,m: int, kind: string) =
    ## 生成・検証を計測外とし、前処理を含む一呼出し全体を測定する。
    var rng = initRand(seed+n*1009+m)
    var c = newSeq[seq[int32]](n)
    var a: seq[seq[bool]]
    if kind in ["masked","infeasible"]: a = newSeq[seq[bool]](n)
    for i in 0..<n:
        c[i] = newSeq[int32](m)
        if a.len > 0: a[i] = newSeq[bool](m)
        for j in 0..<m:
            c[i][j] = case kind
                of "equal","near_pm","near_plus": 0'i32
                of "ties": int32(rng.rand(-3..3))
                of "extremes": (if rng.rand(1) == 0: low(int32) else: high(int32))
                of "ramp": int32(j)
                of "binary": (if j < n div 2 or (i < n div 2 and j == n div 2+i): 0'i32 else: 1'i32)
                else: int32(rng.rand(-1000000..1000000))
            if kind == "masked": a[i][j] = i == j or rng.rand(3) != 0
            if kind == "infeasible": a[i][j] = j < n-1
    if kind in ["near_pm","near_plus"]:
        var indices = newSeq[int](n*m)
        for j in 0..<indices.len: indices[j] = j
        rng.shuffle(indices)
        for j in 0..<(n*m div 100):
            let index = indices[j]
            c[index div m][index mod m] = if kind == "near_plus" or rng.rand(1) == 0: 1'i32 else: -1'i32
    let expected = min_cost_assignment_wide(c,a)
    var batches: array[2,int]
    var first: MinCostAssignmentResult
    for k,mode in modes:
        let r = solve(c,a,mode)
        ensure r.feasible == expected.feasible and r.cost == expected.cost
        ensure r.columnOfRow.len == expected.columnOfRow.len
        var seen = newSeq[bool](m)
        var total = 0'i64
        for i,j in r.columnOfRow:
            ensure j in 0..<m and not seen[j]
            ensure a.len == 0 or a[i][j]
            seen[j] = true
            total += int64(c[i][j])
        ensure total == r.cost
        if k == 0: first = r
        else: ensure r == first
        let start = getMonoTime()
        for warm in 0..<2: checksum = checksum xor solve(c,a,mode).cost
        let seconds = float((getMonoTime()-start).inNanoseconds)/2e9
        batches[mode] = max(1,min(10000,int(0.05/max(seconds,1e-9))))
    for sample in 0..<8:
        for offset in 0..<modes.len:
            let mode = modes[(sample+offset+rotation) mod modes.len]
            sleep(100)
            # 同じ方式を一回ウォームアップし、直前の方式による影響を抑える。
            checksum = checksum xor solve(c,a,mode).cost
            let start = getMonoTime()
            for rep in 0..<batches[mode]:
                let r = solve(c,a,mode)
                checksum = checksum xor r.cost xor int64(r.columnOfRow.len)
            let ms = float((getMonoTime()-start).inNanoseconds)/1e6/float(batches[mode])
            echo n,",",m,",",kind,",",["avx2","avx512"][mode],",",sample,",",batches[mode],",",formatFloat(ms,ffDecimal,6)
ensure assignment_int32_avx512_available()
stderr.writeLine("plan=",plan," seed=",seed," avx512=",assignment_int32_avx512_available())
echo "n,m,distribution,backend,sample,batch,ms"
for n in [32,128,512]: run(n,n,"uniform")
run(129,257,"uniform")
run(256,1024,"uniform")
for kind in ["equal","ties","near_pm","near_plus","extremes","masked","ramp","binary"]:
    run(512,512,kind)
run(256,1024,"masked")
run(128,128,"infeasible")
stderr.writeLine("checksum=",checksum)
