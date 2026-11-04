# verification-helper: PROBLEM https://judge.yosupo.jp/problem/persistent_range_affine_range_sum
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
var versions = newSeq[PersistentSequence[Mint, Affine]](q + 1)
versions[0] = initPersistentLazySequence(values, op, Mint(0), mapping,
    aggregateMapping, composition, (Mint(1), Mint(0)))
for i in 0..<q:
    let t = ii()
    let k = ii()
    if t == 0:
        let l = ii()
        let r = ii()
        let b = Mint(ii())
        let c = Mint(ii())
        versions[i + 1] = versions[k + 1].apply(l, r, (b, c))
    elif t == 1:
        let source = ii()
        let l = ii()
        let r = ii()
        let destination = versions[k + 1].split(l)
        let tail = destination.right.split(r - l).right
        let copied = versions[source + 1].slice(l, r)
        versions[i + 1] = destination.left.concat(copied).concat(tail)
    else:
        let l = ii()
        let r = ii()
        echo versions[k + 1].prod(l, r)
