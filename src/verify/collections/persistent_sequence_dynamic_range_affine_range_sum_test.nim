# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_sequence_range_affine_range_sum
import cplib/collections/persistent_sequence
import cplib/modint/modint

type
    Mint = modint998244353_barrett
    Affine = tuple[a, b: Mint]

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
proc op(a, b: Mint): Mint = a + b
proc mapping(f: Affine, x: Mint): Mint = f.a * x + f.b
proc aggregateMapping(f: Affine, x: Mint, length: int): Mint = f.a * x + f.b * length
proc composition(f, g: Affine): Affine = (f.a * g.a, f.a * g.b + f.b)

let n = ii()
let q = ii()
var values = newSeq[Mint](n)
for x in values.mitems: x = Mint(ii())
var sequence = initPersistentLazySequence(values, op, Mint(0), mapping,
    aggregateMapping, composition, (Mint(1), Mint(0)))
for unused in 0..<q:
    let t = ii()
    if t == 0:
        let k = ii()
        let x = Mint(ii())
        sequence = sequence.insert(k, x)
    elif t == 1:
        let k = ii()
        sequence = sequence.erase(k)
    else:
        let l = ii()
        let r = ii()
        if t == 2:
            sequence = sequence.reverse(l, r)
        elif t == 3:
            let b = Mint(ii())
            let c = Mint(ii())
            sequence = sequence.apply(l, r, (b, c))
        else:
            echo sequence.prod(l, r)
