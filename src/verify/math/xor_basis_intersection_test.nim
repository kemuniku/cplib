# verification-helper: PROBLEM https://judge.yosupo.jp/problem/intersection_of_f2_vector_spaces
import cplib/math/xor_basis
import options, sequtils, strutils

proc intersectWithRestore(u, v: openArray[int]): seq[int] =
    var combined = initXorBasisWithRestore(u)
    let intersection = initXorBasis()
    for value in v:
        let witness = combined.restore(value)
        if witness.isSome:
            var common = 0
            for id in witness.get:
                if id < u.len:
                    common = common xor u[id]
            intersection.incl(common)
        combined.incl(value)
    intersection.basis

when not declared(XOR_BASIS_INTERSECTION_REGRESSION):
    proc readVectors(): seq[int] =
        let line = stdin.readLine.split.map(parseInt)
        result = newSeq[int](line[0])
        for i in 0..<result.len:
            result[i] = line[i + 1]

    let t = stdin.readLine.parseInt
    for _ in 0..<t:
        let u = readVectors()
        let v = readVectors()
        let answer = intersectWithRestore(u, v)
        if answer.len == 0:
            echo 0
        else:
            echo answer.len, " ", answer.join(" ")
