when not declared CPLIB_UTILS_ITERTOOLS:
    const CPLIB_UTILS_ITERTOOLS* = 1
    import algorithm,sequtils

    iterator permutations*[T](v : seq[T]):seq[T]=
        ## pythonのitertoolsのpermutationsと同じ動作をします。
        var idxs = (0..<len(v)).toseq()
        while true:
            yield idxs.mapit(v[it])
            if not nextPermutation(idxs):
                break

    iterator distinct_permutations*[T](v : seq[T]):seq[T]=
        ## next_permutaionをするのと同じ動作をします。
        var tmp = v
        while true:
            yield tmp
            if not nextPermutation(tmp):
                break

    template accumulated*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq)+1)
        result[0] = first
        for i in 0..<len(inner_seq):
            let
                a {.inject.} = result[i]
                b {.inject.} = inner_seq[i]
            result[i+1] = operation
        result

    template accumulated*[T](sequence:seq[T],operation:untyped):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq))
        if len(inner_seq) >= 1:
            result[0] = inner_seq[0]
        for i in 1..<len(inner_seq):
            let
                a {.inject.} = result[i-1]
                b {.inject.} = inner_seq[i]
            result[i] = operation
        result

    template accumulate*[T](sequence:var seq[T],operation:untyped)=
        for i in 1..<len(sequence):
            let
                a {.inject.} = sequence[i-1]
                b {.inject.} = sequence[i]
            sequence[i] = operation

    template accumulatedr*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq)+1)
        result[^1] = first
        for i in countdown(len(inner_seq),1,1):
            let
                a {.inject.} = inner_seq[i-1]
                b {.inject.} = result[i]
            result[i-1] = operation
        result

    template accumulatedr*[T](sequence:seq[T],operation:untyped):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq))
        if len(inner_seq) >= 1:
            result[^1] = inner_seq[^1]
        for i in countdown(len(inner_seq)-2,0,1):
            let
                a {.inject.} = inner_seq[i]
                b {.inject.} = result[i+1]
            result[i] = operation
        result

    template accumulater*[T](sequence:var seq[T],operation:untyped)=
        for i in countdown(len(sequence)-2,0,1):
            let
                a {.inject.} = sequence[i]
                b {.inject.} = sequence[i+1]
            sequence[i] = operation

    iterator combinations*[T](v: seq[T], r: int): seq[T] =
        let n = len(v)
        if r == 0:
            yield @[]
        elif 0 <= r and r <= n:
            var idx = newSeq[int](r)
            for i in 0..<r:
                idx[i] = i

            var x = newSeq[T](r)
            while true:
                for i in 0..<r:
                    x[i] = v[idx[i]]
                yield x

                var i = r - 1
                while i >= 0 and idx[i] == i + n - r:
                    dec i
                if i < 0:
                    break

                inc idx[i]
                for j in (i + 1)..<r:
                    idx[j] = idx[j - 1] + 1
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


