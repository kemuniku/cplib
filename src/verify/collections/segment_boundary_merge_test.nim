# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils, strutils
import cplib/collections/segtree
import cplib/collections/lazysegtree

block:
    type S = tuple[sum, size: int]
    type F = tuple[a, b: int]
    proc merge(x, y: S): S = (x.sum+y.sum, x.size+y.size)
    proc mapping(f: F, x: S): S = (f.a*x.sum+f.b*x.size, x.size)
    proc composition(f, g: F): F = (f.a*g.a, f.a*g.b+f.b)
    var rng = initRand(815773)
    for n in [0, 1, 2, 3, 7, 8, 9, 31, 32, 33, 63, 64, 65, 127, 128, 129]:
        var values = newSeqWith(n, 1)
        var seg = initSegmentTree[S](values.mapIt((it, 1)), merge, (0, 0))
        var lazy = initLazySegmentTree[S, F](values.mapIt((it, 1)), merge, (0, 0), mapping, composition, (1, 0))
        for step in 0..<30:
            if n > 0:
                let l = rng.rand(n)
                let r = rng.rand(l..n)
                let action = (rng.rand(1), rng.rand(3))
                lazy.apply(l, r, action)
                for i in l..<r:
                    values[i] = action[0]*values[i]+action[1]
                    seg[i] = (values[i], 1)
                if step mod 5 == 0:
                    let i = rng.rand(n-1)
                    values[i] = rng.rand(10)
                    seg[i] = (values[i], 1)
                    lazy[i] = (values[i], 1)
            for limit in [0, 1, 10, 100, int.high]:
                proc pred(x: S): bool = x.sum <= limit
                for l in 0..n:
                    var r = l
                    var sum = 0
                    while r < n and sum+values[r] <= limit:
                        sum += values[r]
                        inc r
                    doAssert seg.max_right(l, pred) == r
                    doAssert lazy.max_right(l, pred) == r
                for r in 0..n:
                    var l = r
                    var sum = 0
                    while l > 0 and sum+values[l-1] <= limit:
                        dec l
                        sum += values[l]
                    doAssert seg.min_left(r, pred) == l
                    doAssert lazy.min_left(r, pred) == l
            doAssert seg.get_all.sum == values.foldl(a+b, 0)
            doAssert lazy.get_all.sum == values.foldl(a+b, 0)
        when compileOption("assertions"):
            proc rejects(action: proc()) =
                var rejected = false
                try: action()
                except AssertionDefect: rejected = true
                doAssert rejected
            rejects(proc() = discard seg.max_right(-1, proc(x: S): bool = true))
            rejects(proc() = discard lazy.min_left(n+1, proc(x: S): bool = true))
            rejects(proc() = discard seg.max_right(0, proc(x: S): bool = false))
            rejects(proc() = discard lazy.min_left(n, proc(x: S): bool = false))

block:
    type Box = ref object
        value: string
    proc merge(x, y: Box): Box = Box(value: x.value & y.value)
    proc mapping(f: char, x: Box): Box =
        if f == '\0': x else: Box(value: repeat(f, x.value.len))
    proc composition(f, g: char): char = (if f == '\0': g else: f)
    var values = @["a", "bc", "", "d", "ab", "c", ""]
    var seg = initSegmentTree(values.mapIt(Box(value: it)), merge, Box(value: ""))
    var lazy = initLazySegmentTree(values.mapIt(Box(value: it)), merge, Box(value: ""), mapping, composition, '\0')
    for step in 0..<3:
        if step > 0:
            let ch = if step == 1: 'b' else: 'c'
            lazy.apply(1, 6, ch)
            for i in 1..<6:
                values[i] = repeat(ch, values[i].len)
                seg[i] = Box(value: values[i])
        for l in 0..values.len:
            for r in l..values.len:
                let target = values[l..<r].join("")
                proc prefix(x: Box): bool = target.startsWith(x.value)
                proc suffix(x: Box): bool = target.endsWith(x.value)
                var right = l
                var text = ""
                while right < values.len and target.startsWith(text & values[right]):
                    text.add values[right]
                    inc right
                var left = r
                text = ""
                while left > 0 and target.endsWith(values[left-1] & text):
                    dec left
                    text = values[left] & text
                doAssert seg.max_right(l, prefix) == right
                doAssert lazy.max_right(l, prefix) == right
                doAssert seg.min_left(r, suffix) == left
                doAssert lazy.min_left(r, suffix) == left
        doAssert seg.get_all.value == values.join("")
        doAssert lazy.get_all.value == values.join("")
block:
    type RefValue = ref object
        value: int
    proc merge(x, y: RefValue): RefValue = (if x.value >= y.value: x else: y)
    proc mapping(f: int, x: RefValue): RefValue =
        if f == 0: x else: RefValue(value: x.value+f)
    proc composition(f, g: int): int = f+g
    let identity = RefValue(value: -1)
    let original = @[1, 4, 2, 3, 0]
    let objects = original.mapIt(RefValue(value: it))
    var seg = initSegmentTree(objects, merge, identity)
    var lazy = initLazySegmentTree(objects, merge, identity, mapping, composition, 0)
    for limit in [-1, 0, 2, 5]:
        proc pred(x: RefValue): bool = x.value <= limit
        for l in 0..original.len:
            var r = l
            while r < original.len and original[r] <= limit: inc r
            doAssert seg.max_right(l, pred) == r
            doAssert lazy.max_right(l, pred) == r
        for r in 0..original.len:
            var l = r
            while l > 0 and original[l-1] <= limit: dec l
            doAssert seg.min_left(r, pred) == l
            doAssert lazy.min_left(r, pred) == l
        doAssert identity.value == -1
        for i in 0..<original.len: doAssert objects[i].value == original[i]
echo "Hello World"
