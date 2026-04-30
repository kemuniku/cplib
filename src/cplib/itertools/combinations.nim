when not declared CPLIB_ITERTOOLS_COMBINATIONS:
    const CPLIB_ITERTOOLS_COMBINATIONS* = 1

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
