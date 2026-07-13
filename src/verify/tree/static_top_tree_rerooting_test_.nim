# Randomized boundary/orientation and update test for the all-directions version.
import std/random
import cplib/graph/graph
import cplib/tree/static_top_tree_rerooting

type Data = object
    reversed: bool
    s, t: int
    mask: uint64

proc compress(l, r: Data): Data =
    doAssert not l.reversed and not r.reversed and l.t == r.s
    Data(reversed: false, s: l.s, t: r.t, mask: l.mask or r.mask)

proc rake(l, r: Data): Data =
    doAssert not l.reversed and not r.reversed and l.s == r.s
    Data(reversed: false, s: l.s, t: l.t, mask: l.mask or r.mask)

proc rake2(l, r: Data): Data =
    doAssert l.reversed and not r.reversed and l.s == r.s
    Data(reversed: true, s: l.s, t: l.t, mask: l.mask or r.mask)

proc compress2(l, r: Data): Data =
    doAssert l.reversed and r.reversed and l.t == r.s
    Data(reversed: true, s: l.s, t: r.t, mask: l.mask or r.mask)

proc compress3(l, r: Data): Data =
    doAssert l.reversed and not r.reversed and l.t == r.s
    Data(reversed: true, s: l.s, t: l.t, mask: l.mask or r.mask)

randomize(20260713)
for n in 1..60:
    var g = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n: g.add_edge(v, rand(v - 1))
    let stt = initStaticTopTree(g)
    proc single(v: int): (Data, Data) =
        let p = stt.treeParent[v]
        (Data(s: p, t: v, mask: 1'u64 shl v),
         Data(reversed: true, s: v, t: p, mask: 1'u64 shl v))
    var dp = initRerootingStaticTopTreeDP(stt, single,
        compress, rake, rake2, compress2, compress3)
    let all = if n == 64: high(uint64) else: (1'u64 shl n) - 1
    for v in 0..<n:
        doAssert dp.prodAll(v).mask == all
    for step in 0..<30:
        let v = rand(n - 1)
        let p = stt.treeParent[v]
        dp.set(v, (Data(s: p, t: v, mask: 1'u64 shl v),
                   Data(reversed: true, s: v, t: p, mask: 1'u64 shl v)))
        doAssert dp.prodAll(rand(n - 1)).mask == all
