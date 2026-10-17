# verification-helper: IGNORE
# 引数: N Q H updatePercent pattern seed ISA repetition
# pattern: random / low_cardinality / constant。ISA: 0=auto, 1=scalar, 2=AVX2, 3=AVX-512。
# -d:dynamicWmBenchmarkOracle は小規模な素朴解照合用で、時間比較には使用しない。
import cplib/collections/dynamic_quaternary_waveletmatrix
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import random, times, os, strutils, options

{.checks: off.}

type SecondCountOp = object
    update: bool
    p, r, x: int

proc mix(checksum: var uint64, value: int) {.inline.} =
    checksum = (checksum xor cast[uint64](value)) * 1099511628211'u64

proc main() =
    doAssert paramCount() == 8
    let n = parseInt(paramStr(1))
    let q = parseInt(paramStr(2))
    let width = parseInt(paramStr(3))
    let rate = parseInt(paramStr(4))
    let pattern = paramStr(5)
    let seed = parseInt(paramStr(6))
    let isa = parseInt(paramStr(7))
    let repetition = parseInt(paramStr(8))
    doAssert n > 0 and q >= 0 and width in 0..30 and rate in 0..100
    doAssert pattern in ["random", "low_cardinality", "constant"]
    doAssert seed in 0..1000 and isa in 0..3 and repetition >= 0
    let kernel = case isa
        of 0: bpkAuto
        of 1: bpkScalar
        of 2: bpkAvx2
        else: bpkAvx512
    if not kernelAvailable(kernel): quit(77)
    when defined(dynamicWmBenchmarkOracle):
        doAssert n <= 4096 and q <= 10000
    let maximum = (1 shl width) - 1
    var valueRng = initRand(991827 + 1000003 * seed)
    var actionRng = initRand(198731 + 1000033 * seed)
    proc nextValue(): int =
        case pattern
        of "constant": maximum div 2
        of "low_cardinality": (maximum div 7) * valueRng.rand(7)
        else: valueRng.rand(maximum)
    var initial = newSeq[int](n)
    var traceChecksum = 14695981039346656037'u64
    for x in initial.mitems:
        x = nextValue()
        traceChecksum.mix(x)
    let updates = q * rate div 100
    var updateFlags = newSeq[bool](q)
    for i in 0..<updates: updateFlags[i] = true
    for i in countdown(q - 1, 1):
        swap(updateFlags[i], updateFlags[actionRng.rand(i)])
    var actions = newSeq[SecondCountOp](q)
    for i in 0..<q:
        if updateFlags[i]:
            actions[i] = SecondCountOp(update: true, p: actionRng.rand(n - 1), x: nextValue())
        else:
            let a = actionRng.rand(n - 1)
            let b = actionRng.rand(n - 1)
            actions[i] = SecondCountOp(p: min(a, b), r: max(a, b) + 1)
        let op = actions[i]
        traceChecksum.mix(int(op.update))
        traceChecksum.mix(op.p)
        traceChecksum.mix(op.r)
        traceChecksum.mix(op.x)
    when defined(dynamicWmBenchmarkOracle):
        var reference = initial
    let buildStart = cpuTime()
    var wm = initDynamicQuadWaveletMatrix(initial, QuadVector[16, 64], H = width, kernel = kernel)
    let buildSeconds = cpuTime() - buildStart
    let operationStart = cpuTime()
    var checksum = 14695981039346656037'u64
    for op in actions:
        if op.update:
            wm[op.p] = op.x
            when defined(dynamicWmBenchmarkOracle): reference[op.p] = op.x
        else:
            let mx = wm.kth_largest(op.p, op.r, 0)
            let x = wm.prev_value(op.p, op.r, mx)
            let answer = if x.isNone(): 0 else: wm.count(op.p, op.r, x.get())
            checksum.mix(answer)
            when defined(dynamicWmBenchmarkOracle):
                var first = -1
                var second = -1
                for i in op.p..<op.r:
                    let value = reference[i]
                    if value > first:
                        second = first
                        first = value
                    elif value < first and value > second:
                        second = value
                var expected = 0
                for i in op.p..<op.r:
                    if reference[i] == second: inc expected
                doAssert answer == expected
    let operationSeconds = cpuTime() - operationStart
    doAssert wm.len == n
    echo n, ",", q, ",", width, ",", rate, ",", pattern, ",", seed, ",", isa, ",", repetition,
        ",", updates, ",", q - updates, ",", wm.activeKernel, ",", buildSeconds, ",", operationSeconds,
        ",", wm.storageBytes, ",", traceChecksum, ",", checksum

main()
