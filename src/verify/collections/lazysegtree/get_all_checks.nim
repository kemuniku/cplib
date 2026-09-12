import random, sequtils

block:
    type S = tuple[sum, size: int]
    type F = tuple[a, b: int]
    proc merge(x, y: S): S = (x.sum + y.sum, x.size + y.size)
    proc mapping(f: F, x: S): S = (f.a * x.sum + f.b * x.size, x.size)
    proc composition(f, g: F): F = (f.a * g.a, f.a * g.b + f.b)
    var rng = initRand(20260912)
    for n in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33]:
        var values = newSeqWith(n, 1)
        var seg = initLazySegmentTree[S, F](
            values.mapIt((it, 1)), merge, (0, 0), mapping, composition, (1, 0))
        assert seg.get_all() == (n, n)
        for step in 0..<100:
            let f: F = (rng.rand(-1..1), rng.rand(-5..5))
            if step mod 3 != 2:
                seg.apply(0, n, f)
                for value in values.mitems:
                    value = f.a * value + f.b
            else:
                let l = rng.rand(n)
                let r = rng.rand(l..n)
                seg.apply(l, r, f)
                for i in l..<r:
                    values[i] = f.a * values[i] + f.b
            if n > 0 and step mod 5 == 0:
                let p = rng.rand(n - 1)
                values[p] = rng.rand(-10..10)
                seg[p] = (values[p], 1)
            var total = 0
            for value in values:
                total += value
            assert seg.get_all() == (total, n)
            if step mod 4 == 0:
                for i, value in values:
                    assert seg[i] == (value, 1)
                assert seg.get(0, n) == seg.get_all()

block:
    for n in [0, 1, 3, 4, 5]:
        var seg = newLazySegWith(newSeqWith(n, 1), min(l, r), int.high,
            x + f, f + g, 0)
        seg.apply(0, n, 10)
        seg.apply(0, n, 20)
        assert seg.get_all() == (if n == 0: int.high else: 31)
        if n > 0:
            seg[n - 1] = 100
            assert seg.get_all() == (if n == 1: 100 else: 31)
            assert seg.get(0, n) == seg.get_all()
