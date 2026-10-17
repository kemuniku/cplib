import cplib/collections/offline_dynamic_waveletmatrix
import algorithm, random, times, os, strutils, json
when defined(compareOfflineWMFast):
    import cplib/collections/dynamic_quaternary_waveletmatrix

let mode = paramStr(1)
let scenario = paramStr(2)
let seed = parseInt(paramStr(3))
let n = if paramCount() >= 4: parseInt(paramStr(4)) else: 200000
let q = if paramCount() >= 5: parseInt(paramStr(5)) else: 200000
var rng = initRand(seed)
let width = if scenario == "mixed60": 60 elif scenario == "set32": 32 else: 30
let mask = (1 shl width)-1
proc value(): int =
    if scenario == "boundary": [int.low, int.high, 0, -1, 1][rng.rand(4)]
    elif scenario == "equal": 7
    elif scenario == "sum": rng.rand(2000)-1000
    else: rng.rand(mask)
var initial = newSeq[int](n)
for x in initial.mitems: x = value()
var ops: seq[OfflineWMOperation]
var length = n
for i in 0..<q:
    let choice = rng.rand(99)
    let x = value()
    let pos = if scenario == "endpoints": (if i mod 2 == 0: 0 else: max(0, length-1)) else: rng.rand(max(0, length-1))
    if length == 0 or (scenario == "front" and choice < 40) or (scenario notin ["set30", "set32", "endpoints"] and choice < 15):
        let at = if scenario == "front": 0 else: rng.rand(length)
        ops.add wmInsert(at, x)
        inc length
    elif scenario notin ["set30", "set32", "endpoints"] and choice < 25:
        ops.add wmErase(pos)
        dec length
    elif choice < (if scenario in ["set30", "set32", "endpoints"]: 80 else: 60):
        ops.add wmSet(pos, x)
    else:
        let l = rng.rand(length)
        let r = rng.rand(l..length)
        case i mod (if scenario == "sum": 8 else: 6)
        of 0: ops.add wmRangeLowerbound(l, r, x)
        of 1: ops.add wmCount(l, r, if n > 0: initial[rng.rand(n-1)] else: x)
        of 2:
            if r > l: ops.add wmKthSmallest(l, r, rng.rand(r-l-1))
            else: ops.add wmLen()
        of 3: ops.add wmAccess(pos)
        of 4: ops.add wmSelect(0, if n > 0: initial[rng.rand(n-1)] else: x)
        of 5: ops.add wmRangeFreq(l, r, min(x, value()), max(x, value()))
        of 6: ops.add wmSumSmallestWithCount(l, r, rng.rand(r-l))
        else: ops.add wmSumUpperbound(l, r, x)
var checksum = 0'u64
proc digest(x: int) =
    checksum = (checksum xor cast[uint64](x))*1099511628211'u64
let started = epochTime()
var prepared, finished: float
var storage, bits: int
if mode == "offline":
    let plan = prepareOfflineDynamicWaveletMatrix(initial, ops)
    storage = plan.storageBytes()
    bits = plan.bitWidth()
    prepared = epochTime()
    let answers = plan.run()
    for a in answers:
        case a.kind
        of owaInteger: digest(a.value)
        of owaOptional: discard
        of owaSumCount:
            digest(a.sumCount.sum)
            digest(a.sumCount.count)
    finished = epochTime()
else:
    when defined(compareOfflineWMFast):
        var dictionary: seq[int]
        let compressed = mode == "compressed"
        if compressed:
            doAssert scenario != "sum"
            dictionary = initial
            for op in ops:
                if op.kind in {owmInsert, owmSet}: dictionary.add op.x
            dictionary.sort()
            var uniqueValues: seq[int]
            for x in dictionary:
                if uniqueValues.len == 0 or uniqueValues[^1] != x: uniqueValues.add x
            dictionary = move(uniqueValues)
            for x in initial.mitems: x = dictionary.lowerBound(x)
            for op in ops.mitems:
                case op.kind
                of owmInsert, owmSet, owmCount, owmSelect:
                    let key = dictionary.lowerBound(op.x)
                    if op.kind in {owmCount, owmSelect} and (key == dictionary.len or dictionary[key] != op.x):
                        op.x = dictionary.len
                    else: op.x = key
                of owmRangeLowerbound: op.x = dictionary.lowerBound(op.x)
                of owmRangeFreq:
                    op.x = dictionary.lowerBound(op.x)
                    op.y = dictionary.lowerBound(op.y)
                else: discard
        bits = width
        if compressed:
            bits = 0
            while (1 shl bits) < dictionary.len: inc bits
        if scenario == "sum": bits = 11
        if scenario == "boundary" and not compressed: bits = 64
        let wm = initDynamicQuadWaveletMatrixFast(initial, H=bits, signedValues=scenario in ["sum", "boundary"] and not compressed, with_sum=scenario == "sum")
        prepared = epochTime()
        template decoded(x: int): int =
            (if compressed: dictionary[x] else: x)
        for op in ops:
            case op.kind
            of owmInsert: wm.insert(op.l, op.x)
            of owmErase: digest(decoded(wm.erase(op.l)))
            of owmSet: wm.set(op.l, op.x)
            of owmAccess: digest(decoded(wm.access(op.l)))
            of owmLen: digest(wm.len)
            of owmCount: digest(wm.count(op.l, op.r, op.x))
            of owmSelect: digest(wm.select(op.k, op.x))
            of owmKthSmallest: digest(decoded(wm.kth_smallest(op.l, op.r, op.k)))
            of owmRangeLowerbound: digest(wm.range_lowerbound(op.l, op.r, op.x))
            of owmRangeFreq: digest(wm.range_freq(op.l, op.r, op.x, op.y))
            of owmSumSmallestWithCount:
                let a = wm.sum_smallest_with_count(op.l, op.r, op.k)
                digest(a.sum)
                digest(a.count)
            of owmSumUpperbound: digest(wm.sum_upperbound(op.l, op.r, op.x))
            else: doAssert false
        finished = epochTime()
        storage = wm.storageBytes()
    else: quit("Fast comparison requires its separate reference checkout", 1)
echo $(%* {"mode":mode,"scenario":scenario,"seed":seed,"n":n,"q":q,"prepare":prepared-started,"operations":finished-prepared,"total":finished-started,"bytes":storage,"bits":bits,"checksum": $checksum})
