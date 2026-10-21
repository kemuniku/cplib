# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_bplus_sum
import random

proc audit(t: DynamicBPlusSum, a: seq[int], rng: var Rand) =
    t.validate()
    doAssert t.len == a.len
    var prefix = newSeq[int](a.len+1)
    for i, x in a: prefix[i+1] = prefix[i]+x
    for (l, r) in [(0, a.len), (0, 0), (a.len, a.len)]:
        doAssert t.range_sum(l, r) == prefix[r]-prefix[l]
    for trial in 0..<100:
        let l = rng.rand(a.len)
        let r = l+rng.rand(a.len-l)
        doAssert t.range_sum(l, r) == prefix[r]-prefix[l]

var rng = initRand(46718)
for n in [0, 1, 63, 64, 127, 128, 129, 2048, 2049, 20000]:
    var a = newSeq[int](n)
    for x in a.mitems: x = rng.rand(2000)-1000
    let t = initDynamicBPlusSum(a)
    audit(t, a, rng)
    for step in 0..<1500:
        let kind = if a.len == 0: 0 else: rng.rand(3)
        let p = rng.rand(a.len-int(kind != 0))
        let x = rng.rand(2000)-1000
        case kind
        of 0:
            t.insert(p, x)
            a.insert(x, p)
        of 1:
            doAssert t.erase(p) == a[p]
            a.delete(p)
        of 2:
            t[p] = x
            a[p] = x
        else:
            let destination = rng.rand(a.len-1)
            t.moveReplace(p, destination, x)
            a.delete(p)
            a.insert(x, destination)
        if step mod 53 == 0: audit(t, a, rng)
    audit(t, a, rng)
    while a.len > 0:
        let p = if a.len mod 2 == 0: 0 else: a.len-1
        doAssert t.erase(p) == a[p]
        a.delete(p)
        if a.len mod 257 == 0: audit(t, a, rng)
    audit(t, a, rng)
    for i in 0..<2500:
        let p = rng.rand(a.len)
        let x = rng.rand(2000)-1000
        t.insert(p, x)
        a.insert(x, p)
    audit(t, a, rng)

for x in [int.low, int.high]:
    let t = initDynamicBPlusSum(@[x])
    doAssert t.range_sum(0, 1) == x
    t[0] = not x
    doAssert t.range_sum(0, 1) == not x
    doAssert t.erase(0) == not x
    t.insert(0, x)
    doAssert t.range_sum(0, 1) == x
echo "Hello World"
