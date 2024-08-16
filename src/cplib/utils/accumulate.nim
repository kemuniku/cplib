when not declared CPLIB_UTILS_ACCUMULATE:
    const CPLIB_UTILS_ACCUMULATE* = 1
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

