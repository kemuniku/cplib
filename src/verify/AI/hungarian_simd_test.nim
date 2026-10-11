# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/hungarian

var checked = 0
proc check(c: seq[seq[int32]], a: seq[seq[bool]] = @[], brute = true) =
    let reference = min_cost_assignment_wide(c, a)
    for backend in [assignmentScalar, assignmentSimd]:
        for vector in [assignmentVectorSse,assignmentVectorAvx2,assignmentVectorAvx512,assignmentVectorAuto]:
            if backend == assignmentSimd:
                if vector == assignmentVectorAvx512 and not assignment_int32_avx512_available(): continue
                if vector in [assignmentVectorAvx2,assignmentVectorAuto] and not assignment_int32_avx2_available(): continue
            let unfused = min_cost_assignment_int32_fast(c,a,backend,assignmentPreferFree,false,false,vector)
            let stable = min_cost_assignment_int32_fast(c,a,backend,assignmentStable,vector=vector)
            doAssert stable == reference
            let fast = min_cost_assignment_int32_fast(c,a,backend,vector=vector)
            doAssert fast == min_cost_assignment_int32_fast(c,a,assignmentScalar)
            if assignment_int32_avx2_available(): doAssert fast == min_cost_assignment(c,a)
            let fused = min_cost_assignment_int32_fast(c,a,backend,assignmentPreferFree,true,false,vector)
            doAssert fused == unfused
            doAssert fused.feasible == fast.feasible and fused.cost == fast.cost
            doAssert fast.feasible == reference.feasible and fast.cost == reference.cost
            doAssert fast.columnOfRow.len == reference.columnOfRow.len
            for answer in [stable,unfused,fused,fast]:
                doAssert answer.feasible == reference.feasible and answer.cost == reference.cost
                doAssert answer.columnOfRow.len == reference.columnOfRow.len
                var total = 0'i64
                var cols: seq[int]
                for i,j in answer.columnOfRow:
                    doAssert j >= 0 and j < c[i].len and j notin cols
                    doAssert a.len == 0 or a[i][j]
                    cols.add(j)
                    total += int64(c[i][j])
                doAssert total == answer.cost
    if brute:
        var found = false
        var best = high(int64)
        let m = if c.len == 0: 0 else: c[0].len
        var used = newSeq[bool](m)
        proc visit(i: int, total: int64) =
            if i == c.len:
                found = true
                best = min(best, total)
                return
            for j in 0..<m:
                if not used[j] and (a.len == 0 or a[i][j]):
                    used[j] = true
                    visit(i+1, total + int64(c[i][j]))
                    used[j] = false
        visit(0, 0)
        doAssert found == reference.feasible
        if found: doAssert best == reference.cost
    inc checked

check(@[])
check(@[newSeq[int32]()])
check(@[@[0'i32], @[0'i32]])
check(@[@[low(int32), high(int32)]])
check(@[@[high(int32), low(int32)]])
let extremes = @[low(int32), low(int32)+1, -1'i32, 0'i32, 1'i32, high(int32)-1, high(int32)]
for a in extremes:
    for b in extremes:
        for c in extremes:
            for d in extremes:
                check(@[@[a,b], @[c,d]])
for code in 0..<4096:
    var c = @[@[0'i32,0,0], @[0'i32,0,0]]
    var a = @[@[false,false,false], @[false,false,false]]
    var rest = code
    for i in 0..<2:
        for j in 0..<3:
            let digit = rest mod 4
            rest = rest div 4
            c[i][j] = int32(digit-2)
            a[i][j] = digit != 0
    check(c,a)
var rng = initRand(538)
for trial in 0..<5000:
    let n = rng.rand(0..5)
    let m = rng.rand(0..8)
    var c = newSeq[seq[int32]](n)
    var a = newSeq[seq[bool]](n)
    for i in 0..<n:
        c[i] = newSeq[int32](m)
        a[i] = newSeq[bool](m)
        for j in 0..<m:
            c[i][j] = if trial mod 3 == 0: extremes[rng.rand(extremes.high)] else: int32(rng.rand(-3..3))
            a[i][j] = rng.rand(3) != 0
    check(c, if trial mod 2 == 0: a else: @[])
for m in @[1,2,3,4,7,8,9,31,32,33,127,128,129,260] & toSeq(1..65):
    let n = min(m, 100)
    for kind in 0..<4:
        var c = newSeq[seq[int32]](n)
        var a = newSeq[seq[bool]](n)
        for i in 0..<n:
            c[i] = newSeq[int32](m)
            a[i] = newSeq[bool](m)
            for j in 0..<m:
                c[i][j] = case kind
                    of 0: 0'i32
                    of 1: int32(j*j-i)
                    of 2: extremes[rng.rand(extremes.high)]
                    else: int32(rng.rand(-1000000..1000000))
                a[i][j] = rng.rand(3) != 0
        check(c, brute=false)
        check(c,a,brute=false)
        for i in 0..<n:
            for j in 0..<m: a[i][j] = j < n-1
        check(c,a,brute=false)
block:
    let n = 128
    var c = newSeq[seq[int32]](n)
    var a = newSeq[seq[bool]](n)
    for i in 0..<n:
        c[i] = newSeq[int32](n)
        a[i] = newSeq[bool](n)
        if i < n-1:
            c[i][i] = low(int32)
            a[i][i] = true
        let j = (i+1) mod n
        c[i][j] = if i mod 2 == 0: high(int32) else: low(int32)
        a[i][j] = true
    check(c,a,brute=false)
template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected
rejects: discard min_cost_assignment_int32_fast(@[@[1'i32], @[2'i32,3]])
rejects: discard min_cost_assignment_int32_fast(@[@[1'i32]], @[@[true,false]])
rejects: discard min_cost_assignment_int32_fast(@[@[1'i32]], @[@[true],@[false]])
rejects: discard min_cost_assignment_int32_fast(newSeq[seq[int32]](), @[@[true]])
rejects: discard min_cost_assignment_int32_fast(newSeq[seq[int32]](32768))
block:
    let c = @[@[3'i32,1,2], @[4'i32,5,-6]]
    let a = @[@[true,true,true], @[true,true,true]]
    discard min_cost_assignment_int32_fast(c,a,assignmentScalar)
    doAssert c == @[@[3'i32,1,2], @[4'i32,5,-6]] and a == @[@[true,true,true], @[true,true,true]]
for trial in 0..<200:
    let n = rng.rand(6..60)
    let m = rng.rand(n..n+30)
    var c = newSeq[seq[int32]](n)
    var a = newSeq[seq[bool]](n)
    for i in 0..<n:
        c[i] = newSeq[int32](m)
        a[i] = newSeq[bool](m)
        for j in 0..<m:
            c[i][j] = if trial mod 3 == 0: extremes[rng.rand(extremes.high)] else: int32(rng.rand(int64(low(int32))..int64(high(int32))))
            a[i][j] = rng.rand(100) < trial mod 101
    check(c, if trial mod 2 == 0: a else: @[], brute=false)
for kind in 0..1:
    for masked in [false,true]:
        let n = 64
        var c = newSeq[seq[int32]](n)
        var a = newSeq[seq[bool]](if masked: n else: 0)
        for i in 0..<n:
            c[i] = newSeq[int32](n)
            if masked: a[i] = newSeqWith(n,true)
            for j in 0..<n:
                c[i][j] = if kind == 0: int32(j) else: (if j < n div 2 or (i < n div 2 and j == n div 2+i): 0'i32 else: 1'i32)
        check(c,a,brute=false)
block:
    let c = @[@[low(int32),high(int32)]]
    let expected = min_cost_assignment_int32_fast(c,backend=assignmentScalar)
    if assignment_int32_avx2_available():
        doAssert min_cost_assignment_int32_avx2(c) == expected
        doAssert min_cost_assignment_int32_fast(c) == expected
        doAssert assignment_int32_vector_backend(assignmentVectorAvx2) == assignmentVectorAvx2
        doAssert assignment_int32_vector_backend(assignmentVectorAuto) == (if assignment_int32_avx512_available(): assignmentVectorAvx512 else: assignmentVectorAvx2)
    else:
        rejects: discard min_cost_assignment_int32_avx2(c)
        rejects: discard min_cost_assignment_int32_fast(c)
        rejects: discard min_cost_assignment_int32_fast(newSeq[seq[int32]]())
        rejects: discard assignment_int32_vector_backend(assignmentVectorAuto)
    if assignment_int32_avx512_available():
        doAssert min_cost_assignment_int32_avx512(c) == expected
        doAssert assignment_int32_vector_backend(assignmentVectorAvx512) == assignmentVectorAvx512
    else:
        rejects: discard min_cost_assignment_int32_avx512(c)
        rejects: discard assignment_int32_vector_backend(assignmentVectorAvx512)
when defined(hungarianDisableAvx512) or defined(hungarianForceScalar) or defined(hungarianDisableAvx2):
    doAssert not assignment_int32_avx512_available()
when defined(hungarianDisableAvx2) or defined(hungarianForceScalar):
    doAssert not assignment_int32_avx2_available()
echo "Hello World"
stderr.writeLine("cases=",checked," sse=",assignment_int32_simd_available()," avx2=",assignment_int32_avx2_available()," avx512=",assignment_int32_avx512_available())
