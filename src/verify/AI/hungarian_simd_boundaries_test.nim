# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/hungarian
var cases = 0
for m in [65538,65539]:
    for nearHigh in [false,true]:
        var c = newSeq[seq[int32]](3)
        var a = newSeq[seq[bool]](3)
        let base = if nearHigh: high(int32)-3 else: low(int32)
        for i in 0..<3:
            c[i] = newSeq[int32](m)
            a[i] = newSeq[bool](m)
            for j in 0..<m: c[i][j] = base+3
            let col = m-3+i
            c[i][col] = base
            a[i][col] = true
        for masked in [false,true]:
            let mask = if masked: a else: newSeq[seq[bool]]()
            let expected = min_cost_assignment_wide(c,mask)
            doAssert expected.cost == 3*int64(base)
            for backend in [assignmentScalar,assignmentSimd]:
                for stable in [false,true]:
                    for vector in [assignmentVectorSse,assignmentVectorAvx2,assignmentVectorAvx512,assignmentVectorAuto]:
                        if backend == assignmentSimd:
                            if vector == assignmentVectorAvx512 and not assignment_int32_avx512_available(): continue
                            if vector in [assignmentVectorAvx2,assignmentVectorAuto] and not assignment_int32_avx2_available(): continue
                        let answer = min_cost_assignment_int32_fast(c,mask,backend,
                            if stable: assignmentStable else: assignmentPreferFree, vector=vector)
                        doAssert answer == expected
                        doAssert answer.columnOfRow == @[m-3,m-2,m-1]
            inc cases
block:
    let c = @[@[0'i32,0,0],@[0'i32,1,1],@[1'i32,0,0]]
    let old = min_cost_assignment_wide(c)
    let fast = min_cost_assignment_int32_fast(c,backend=assignmentScalar)
    if assignment_int32_avx2_available(): doAssert min_cost_assignment(c) == fast
    doAssert old.cost == 0 and fast.cost == 0
    doAssert old.columnOfRow == @[1,0,2]
    doAssert fast.columnOfRow == @[2,0,1]
    doAssert min_cost_assignment_int32_fast(c,backend=assignmentScalar,tieBreak=assignmentStable) == old
    stderr.writeLine("tie example: old=",old.columnOfRow," fast=",fast.columnOfRow)
echo "Hello World"
stderr.writeLine("wide-column/offset cases=",cases)
