import random, sequtils, strutils

block:
    type S = tuple[sum, size: int]
    type F = tuple[a, b: int]
    proc merge(x, y: S): S = (x.sum + y.sum, x.size + y.size)
    proc mapping(f: F, x: S): S = (f.a * x.sum + f.b * x.size, x.size)
    proc composition(f, g: F): F = (f.a * g.a, f.a * g.b + f.b)
    var rng = initRand(314159)
    for n in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33]:
        var values = newSeqWith(n, 1)
        var seg = initLazySegmentTree[S, F](
            values.mapIt((it, 1)), merge, (0, 0), mapping, composition, (1, 0))
        for step in 0..<100:
            if n > 0:
                let l = rng.rand(n)
                let r = rng.rand(l..n)
                let f: F = (rng.rand(1), rng.rand(5))
                seg.apply(l, r, f)
                for i in l..<r:
                    values[i] = f.a * values[i] + f.b
                if step mod 7 == 0:
                    let i = rng.rand(n - 1)
                    values[i] = rng.rand(10)
                    seg[i] = (values[i], 1)
            for limit in [0, 1, 10, 50, 10000]:
                proc pred(x: S): bool = x.sum <= limit
                for l in 0..n:
                    var r = l
                    var total = 0
                    while r < n and total + values[r] <= limit:
                        total += values[r]
                        inc r
                    doAssert seg.max_right(l, pred) == r
                for r in 0..n:
                    var l = r
                    var total = 0
                    while l > 0 and values[l - 1] + total <= limit:
                        dec l
                        total += values[l]
                    doAssert seg.min_left(r, pred) == l
            doAssert seg.get(0, n).sum == values.foldl(a + b, 0)

block:
    proc merge(x, y: string): string = x & y
    proc mapping(f: char, x: string): string =
        if f == '\0': x else: repeat(f, x.len)
    proc composition(f, g: char): char =
        if f == '\0': g else: f
    var values = @["a", "b", "c", "a", "b", "c", "a", "b", "c"]
    var seg = initLazySegmentTree[string, char](
        values, merge, "", mapping, composition, '\0')
    for step in 0..<3:
        if step > 0:
            let ch = if step == 1: 'b' else: 'c'
            seg.apply(0, 8, ch)
            for i in 0..<8:
                values[i] = $ch
        for l in 0..values.len:
            for r in l..values.len:
                let target = values[l..<r].join("")
                doAssert seg.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
                doAssert seg.min_left(r, proc(x: string): bool = target.endsWith(x)) == l
        doAssert seg.get(0, values.len) == values.join("")
