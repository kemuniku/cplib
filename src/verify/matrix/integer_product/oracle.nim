import sequtils

proc oracle*[T](a, b: seq[seq[T]], h, k, w: int): seq[seq[T]] =
    result = newSeqWith(h, newSeq[T](w))
    for i in 0..<h:
        for j in 0..<w:
            for t in 0..<k:
                result[i][j] += a[i][t] * b[t][j]

