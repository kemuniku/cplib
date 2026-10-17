# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/offline_dynamic_waveletmatrix
import algorithm, options, random

proc naive(initial: seq[int], ops: seq[OfflineWMOperation]): seq[OfflineWMAnswer] =
    var a = initial
    for i, op in ops:
        var answer = OfflineWMAnswer(operationIndex: i, kind: owaInteger)
        case op.kind
        of owmInsert:
            a.insert(op.x, op.l)
            continue
        of owmSet:
            a[op.l] = op.x
            continue
        of owmErase:
            answer.value = a[op.l]
            a.delete(op.l)
        of owmAccess: answer.value = a[op.l]
        of owmLen: answer.value = a.len
        of owmSelect:
            answer.value = -1
            var k = op.k
            for j, x in a:
                if x == op.x:
                    if k == 0:
                        answer.value = j
                        break
                    dec k
        else:
            var b = a[op.l..<op.r]
            b.sort()
            case op.kind
            of owmKthSmallest: answer.value = b[op.k]
            of owmKthLargest: answer.value = b[b.high-op.k]
            of owmPrevValue, owmNextValue:
                var value = none(int)
                for x in b:
                    if op.kind == owmPrevValue and x < op.x: value = some(x)
                    if op.kind == owmNextValue and x >= op.x and value.isNone: value = some(x)
                answer = OfflineWMAnswer(operationIndex: i, kind: owaOptional, optionalValue: value)
            else:
                var pair: tuple[sum, count: int]
                for j, x in b:
                    var take = false
                    case op.kind
                    of owmRank, owmCount: take = x == op.x
                    of owmRangeLowerbound, owmSumLowerbound, owmSumLowerboundWithCount: take = x < op.x
                    of owmRangeUpperbound, owmSumUpperbound, owmSumUpperboundWithCount: take = x <= op.x
                    of owmRangeFreq, owmRangeSum, owmRangeSumWithCount: take = op.x <= x and x < op.y
                    of owmSumSmallest, owmSumSmallestWithCount: take = j < op.k
                    else: discard
                    if take:
                        inc pair.count
                        if op.kind >= owmSumLowerbound: pair.sum += x
                if op.kind >= owmSumLowerboundWithCount:
                    answer = OfflineWMAnswer(operationIndex: i, kind: owaSumCount, sumCount: pair)
                elif op.kind >= owmSumLowerbound: answer.value = pair.sum
                else: answer.value = pair.count
        result.add answer

when defined(compareOfflineWMFast):
    import cplib/collections/dynamic_quaternary_waveletmatrix
    proc baseline(initial: seq[int], ops: seq[OfflineWMOperation]): seq[OfflineWMAnswer] =
        let wm = initDynamicQuadWaveletMatrixFast(initial, H=64, signedValues=true, with_sum=true)
        for i, op in ops:
            var a = OfflineWMAnswer(operationIndex: i, kind: owaInteger)
            case op.kind
            of owmInsert:
                wm.insert(op.l, op.x)
                continue
            of owmSet:
                wm.set(op.l, op.x)
                continue
            of owmErase: a.value = wm.erase(op.l)
            of owmAccess: a.value = wm.access(op.l)
            of owmLen: a.value = wm.len
            of owmRank: a.value = wm.rank(op.r, op.x)
            of owmCount: a.value = wm.count(op.l, op.r, op.x)
            of owmSelect: a.value = wm.select(op.k, op.x)
            of owmKthSmallest: a.value = wm.kth_smallest(op.l, op.r, op.k)
            of owmKthLargest: a.value = wm.kth_largest(op.l, op.r, op.k)
            of owmRangeLowerbound: a.value = wm.range_lowerbound(op.l, op.r, op.x)
            of owmRangeUpperbound: a.value = wm.range_upperbound(op.l, op.r, op.x)
            of owmRangeFreq: a.value = wm.range_freq(op.l, op.r, op.x, op.y)
            of owmPrevValue: a = OfflineWMAnswer(operationIndex:i, kind:owaOptional, optionalValue:wm.prev_value(op.l, op.r, op.x))
            of owmNextValue: a = OfflineWMAnswer(operationIndex:i, kind:owaOptional, optionalValue:wm.next_value(op.l, op.r, op.x))
            of owmSumLowerbound: a.value = wm.sum_lowerbound(op.l, op.r, op.x)
            of owmSumUpperbound: a.value = wm.sum_upperbound(op.l, op.r, op.x)
            of owmRangeSum: a.value = wm.range_sum(op.l, op.r, op.x, op.y)
            of owmSumSmallest: a.value = wm.sum_smallest(op.l, op.r, op.k)
            of owmSumLowerboundWithCount: a = OfflineWMAnswer(operationIndex:i, kind:owaSumCount, sumCount:wm.sum_lowerbound_with_count(op.l, op.r, op.x))
            of owmSumUpperboundWithCount: a = OfflineWMAnswer(operationIndex:i, kind:owaSumCount, sumCount:wm.sum_upperbound_with_count(op.l, op.r, op.x))
            of owmRangeSumWithCount: a = OfflineWMAnswer(operationIndex:i, kind:owaSumCount, sumCount:wm.range_sum_with_count(op.l, op.r, op.x, op.y))
            of owmSumSmallestWithCount: a = OfflineWMAnswer(operationIndex:i, kind:owaSumCount, sumCount:wm.sum_smallest_with_count(op.l, op.r, op.k))
            result.add a

proc check(a: seq[int], ops: seq[OfflineWMOperation]) =
    let expected = naive(a, ops)
    let plan = prepareOfflineDynamicWaveletMatrix(a, ops)
    doAssert plan.storageBytes >= 0
    let actual = plan.run()
    doAssert actual == expected, $ops & "\n" & $actual & "\n" & $expected
    doAssert naive(a, ops) == expected
    when defined(compareOfflineWMFast): doAssert baseline(a, ops) == expected

check(@[], @[])
check(@[1, 2, 3], @[])
check(@[], @[wmLen(), wmRank(0, 1), wmCount(0, 0, 1), wmSelect(0, 1),
    wmPrevValue(0, 0, 1), wmNextValue(0, 0, 1), wmSumSmallest(0, 0, 0),
    wmInsert(0, 5), wmSet(0, -3), wmAccess(0), wmErase(0), wmLen()])
check(@[int.low, 0, int.high], @[wmAccess(0), wmAccess(2), wmRangeLowerbound(0, 3, int.low),
    wmRangeUpperbound(0, 3, int.high), wmPrevValue(0, 3, int.low), wmNextValue(0, 3, int.high),
    wmSelect(0, int.high), wmSet(0, int.high), wmSelect(1, int.high), wmErase(1), wmSelect(1, int.high)])
check(@[int.low], @[wmSumUpperbound(0, 1, int.low), wmErase(0), wmInsert(0, int.high),
    wmSumSmallest(0, 1, 1), wmSet(0, 0), wmRangeSumWithCount(0, 1, int.low, int.high)])
check(@[7, 7, 7], @[wmSelect(-1, 7), wmSelect(3, 7), wmInsert(0, 7), wmErase(2),
    wmSet(0, 7), wmSelect(2, 7), wmSumSmallestWithCount(0, 3, 3), wmRangeFreq(0, 3, 9, -9)])
for seed in 0..<40:
    var rng = initRand(seed)
    for trial in 0..<12:
        var a = newSeq[int](rng.rand(30))
        for x in a.mitems: x = rng.rand(20)-10
        var length = a.len
        var ops: seq[OfflineWMOperation]
        for step in 0..<250:
            var kind = OfflineWMKind(rng.rand(ord(OfflineWMKind.high)))
            if length == 0 and kind in {owmSet, owmErase, owmAccess, owmKthSmallest, owmKthLargest}:
                kind = owmInsert
            var op = OfflineWMOperation(kind: kind, x: rng.rand(30)-15, y: rng.rand(30)-15)
            case kind
            of owmInsert:
                op.l = rng.rand(length)
                inc length
            of owmErase, owmSet, owmAccess:
                op.l = rng.rand(length-1)
                if kind == owmErase: dec length
            of owmSelect: op.k = rng.rand(length+1)-1
            of owmLen: discard
            else:
                op.l = rng.rand(length)
                op.r = rng.rand(length)
                if op.l > op.r: swap(op.l, op.r)
                if kind == owmRank: op.l = 0
                if kind in {owmKthSmallest, owmKthLargest}:
                    if op.l == op.r:
                        op.l = 0
                        op.r = length
                    op.k = rng.rand(op.r-op.l-1)
                if kind in {owmSumSmallest, owmSumSmallestWithCount}: op.k = rng.rand(op.r-op.l)
            ops.add op
        check(a, ops)
for seed in 0..<20:
    var rng = initRand(seed+100)
    var a: seq[int]
    let pool = @[int.low, int.low+1, -(1 shl 60), -1, 0, 1, 1 shl 32, (1 shl 60)-1, int.high-1, int.high]
    for i in 0..<20: a.add pool[rng.rand(pool.high)]
    var length = a.len
    var ops: seq[OfflineWMOperation]
    for step in 0..<500:
        let x = pool[rng.rand(pool.high)]
        if step mod 4 == 0:
            ops.add wmInsert(rng.rand(length), x)
            inc length
        elif step mod 4 == 1: ops.add wmSet(rng.rand(length-1), x)
        elif step mod 4 == 2:
            ops.add wmErase(rng.rand(length-1))
            dec length
        else:
            ops.add wmSelect(rng.rand(4)-1, x)
            ops.add wmRank(length, x)
            ops.add wmRangeUpperbound(0, length, x)
            ops.add wmPrevValue(0, length, x)
            ops.add wmNextValue(0, length, x)
            ops.add wmKthLargest(0, length, rng.rand(length-1))
    check(a, ops)
var shifting: seq[OfflineWMOperation]
for i in 0..<1500:
    shifting.add wmInsert(0, i mod 7)
    shifting.add wmSet(i, -i)
    shifting.add wmAccess(0)
    shifting.add wmSelect(0, -i)
for i in countdown(1499, 0):
    shifting.add wmErase(i div 2)
    shifting.add wmLen()
check(@[], shifting)
echo "Hello World"
