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
        var tmp = v.sorted()
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
    
    iterator combinations_withf*[T](v: seq[T], r: int, f: proc(l, r: T): T): T =
        ## `combinations(v, r)` の各組合せを `f` で左畳み込みした値を yield する。
        ## 例: `f = proc(a,b:int):int = a*b` なら 各組合せの総積。
        ## 接頭辞畳み込みを保持し、変化のあった添字以降のみ再計算する差分更新版。
        let n = len(v)
        if r == 0:
            discard # 0 要素の組合せは畳み込み単位元が不明なので何も yield しない
        else:
            if r <= n:
                var idx = newSeq[int](r)
                var pref = newSeq[T](r)
                for i in 0..<r:
                    idx[i] = i
                pref[0] = v[0]
                for i in 1..<r:
                    pref[i] = f(pref[i - 1], v[i])
                yield pref[r - 1]
                while true:
                    var i = r - 1
                    while i >= 0 and idx[i] == i + n - r:
                        dec i
                    if i < 0:
                        break
                    inc idx[i]
                    if i == 0:
                        pref[0] = v[idx[0]]
                    else:
                        pref[i] = f(pref[i - 1], v[idx[i]])
                    for j in (i + 1)..<r:
                        idx[j] = idx[j - 1] + 1
                        pref[j] = f(pref[j - 1], v[idx[j]])
                    yield pref[r - 1]

    iterator combinations*[T](v: seq[T], r: static[int]): array[r, T] =
        let n = len(v)
        when r == 0:
            var x: array[r, T]
            yield x
        else:
            if r <= n:
                var idx: array[r, int]
                var x: array[r, T]
                for i in 0..<r:
                    idx[i] = i
                    x[i] = v[i]
                yield x
                while true:
                    var i = r - 1
                    while i >= 0 and idx[i] == i + n - r:
                        dec i
                    if i < 0:
                        break
                    inc idx[i]
                    x[i] = v[idx[i]]
                    for j in (i + 1)..<r:
                        idx[j] = idx[j - 1] + 1
                        x[j] = v[idx[j]]
                    yield x

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
    iterator partitions*(n: int): seq[int] =
        ## 分割数列挙
        if n == 0:
            yield @[]
        else:
            var a = newSeq[int](n + 1)
            var k = 1
            a[1] = n
            while k != 0:
                var x = a[k - 1] + 1
                var y = a[k] - 1
                dec k
                while x <= y:
                    a[k] = x
                    y -= x
                    inc k
                a[k] = x + y
                yield a[0 .. k]


