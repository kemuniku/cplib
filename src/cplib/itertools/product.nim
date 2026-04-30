when not declared CPLIB_ITERTOOLS_PRODUCT:
    const CPLIB_ITERTOOLS_PRODUCT* = 1
    import sequtils

    iterator product*[T](v: seq[T],repeat:int):seq[T]=
        if repeat == 0:
            yield @[]
        else:
            var idxs = newseq[int](repeat)
            var f = true
            while f:
                yield idxs.mapit(v[it])
                for i in 0..<repeat:
                    idxs[i] += 1
                    if idxs[i] == len(v):
                        idxs[i] = 0
                        if i == repeat-1:
                            f = false
                        continue
                    else:
                        break


