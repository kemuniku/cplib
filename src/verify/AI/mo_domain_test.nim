# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/mo

type Query = tuple[l, r: int]

proc value(i, origin: int): int =
    let x = i - origin + 1
    x * x + 3 * x - 7

proc oracle(l, r, origin: int): int =
    if l <= r:
        for i in l..<r: result += value(i, origin)
    else:
        for i in r..<l: result -= value(i, origin)

proc check(domain: HSlice[int, int], queries: seq[Query], width: int,
        initial: Query, useDefault = false) =
    var mo = initMo(domain, queries.len, width)
    for q in queries: mo.insert(q.l, q.r)
    var left = initial.l
    var right = initial.r
    var state = oracle(left, right, domain.a)
    var seen = newSeq[int](queries.len)
    var movements = 0
    proc addLeft(i: int) =
        doAssert i == left - 1 and i >= domain.a
        left = i
        state += value(i, domain.a)
        inc movements
    proc addRight(i: int) =
        doAssert i == right and i < domain.b
        right = i + 1
        state += value(i, domain.a)
        inc movements
    proc deleteLeft(i: int) =
        doAssert i == left and i < domain.b
        left = i + 1
        state -= value(i, domain.a)
        inc movements
    proc deleteRight(i: int) =
        doAssert i == right - 1 and i >= domain.a
        right = i
        state -= value(i, domain.a)
        inc movements
    proc remember(idx: int) =
        doAssert (left, right) == queries[idx]
        doAssert state == oracle(queries[idx].l, queries[idx].r, domain.a)
        seen[idx] += 1
    for repeat in 0..<2:
        left = initial.l
        right = initial.r
        state = oracle(left, right, domain.a)
        movements = 0
        if useDefault:
            mo.run(addLeft, addRight, deleteLeft, deleteRight, remember = remember)
        else:
            mo.run(addLeft, addRight, deleteLeft, deleteRight, remember,
                nl = initial.l, nr = initial.r)
        for count in seen: doAssert count == repeat + 1
        let d = domain.b - domain.a
        doAssert movements <= 2 * d * (d div mo.width + 2) + queries.len * mo.width
        if queries.len == 0:
            doAssert movements == 0 and (left, right) == initial
        else:
            doAssert (left, right) in queries

var rng = initRand(6432026)
for origin in [-17, -3, 0, 11]:
    for d in 0..9:
        let domain = origin..origin + d
        var queries: seq[Query]
        for l in domain:
            for r in domain: queries.add((l, r))
        queries.add((origin, origin + d))
        rng.shuffle(queries)
        for width in [0, 1, 2, 4, d + 17]:
            for initial in [(origin, origin), (origin, origin + d),
                    (origin + d, origin), (origin + d, origin + d)]:
                check(domain, queries, width, initial)
        if origin <= 0 and 0 <= origin + d:
            check(domain, queries, 0, (0, 0), useDefault = true)
        check(domain, @[], 0, (origin + d, origin))

for trial in 0..<100:
    let origin = rng.rand(60) - 40
    let d = rng.rand(30)
    var queries: seq[Query]
    for i in 0..<100:
        queries.add((origin + rng.rand(d), origin + rng.rand(d)))
    check(origin..origin + d, queries, rng.rand(d + 10),
        (origin + rng.rand(d), origin + rng.rand(d)))

for origin in [low(int), high(int) - 8]:
    check(origin..origin + 8, @[(origin, origin + 8), (origin + 8, origin),
        (origin + 3, origin + 7), (origin + 8, origin + 8)], 2,
        (origin + 4, origin + 1))

proc checkFactories() =
    var mo = initMo(-9.. -2, 1)
    mo.insert(-7, -3)
    var factories, endpoints, records: int
    var state = oracle(-5, -8, -9)
    proc endpoint(x: int): int =
        inc endpoints
        x
    proc makeCallback(sign: int): proc(i: int) {.closure.} =
        inc factories
        result = proc(i: int) = state += sign * value(i, -9)
    proc makeRemember(): proc(idx: int) {.closure.} =
        inc factories
        result = proc(idx: int) =
            doAssert idx == 0 and state == oracle(-7, -3, -9)
            inc records
    mo.run(makeCallback(1), makeCallback(1), makeCallback(-1),
        makeCallback(-1), makeRemember(), nl = endpoint(-5), nr = endpoint(-8))
    doAssert factories == 5 and endpoints == 2 and records == 1

checkFactories()

block:
    var mo = initMo(-4..4, 1)
    mo.insert(-2, 2)
    var state = oracle(1, 0, -4)
    proc addValue(i: int) = state += value(i, -4)
    proc deleteValue(i: int) = state -= value(i, -4)
    proc remember(idx: int) = doAssert state == oracle(-2, 2, -4)
    mo.run(addValue, addValue, deleteValue, deleteValue, remember, nl = 1)
    state = oracle(0, 3, -4)
    mo.run(addValue, addValue, deleteValue, deleteValue, remember, nr = 3)
    var legacy = initMo(4, 1)
    legacy.insert(1, 3)
    state = oracle(3, 1, -4)
    proc legacyRemember(idx: int) = doAssert state == oracle(1, 3, -4)
    legacy.run(addValue, addValue, deleteValue, deleteValue,
        remember = legacyRemember, nl = 3, nr = 1)

const maxLeft = (1 shl 20) - 1
proc checkPacking(mo: var Mo, initial: Query, queries: seq[Query]) =
    for q in queries: mo.insert(q.l, q.r)
    var left = initial.l
    var right = initial.r
    var seen = newSeq[int](queries.len)
    mo.run(
        proc(i: int) =
            doAssert i == left - 1
            left = i,
        proc(i: int) =
            doAssert i == right
            right = i + 1,
        proc(i: int) =
            doAssert i == left
            left = i + 1,
        proc(i: int) =
            doAssert i == right - 1
            right = i,
        proc(idx: int) =
            doAssert (left, right) == queries[idx]
            seen[idx] += 1,
        nl = initial.l, nr = initial.r)
    for count in seen: doAssert count == 1

for origin in [low(int), high(int) - maxLeft, -maxLeft]:
    var mo = initMo(origin..origin + maxLeft, 3, high(int))
    let endPoint = origin + maxLeft
    checkPacking(mo, (endPoint, endPoint), @[(endPoint, endPoint),
        (endPoint - 1, endPoint), (endPoint, endPoint - 1)])

for right in [-(1 shl 23), (1 shl 23) - 2]:
    var mo = initMo((1 shl 23) - 1, 2, high(int))
    checkPacking(mo, (maxLeft, right), @[(maxLeft, right), (maxLeft - 1, right + 1)])

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except AssertionDefect: rejected = true
        doAssert rejected, astToStr(body)

rejects: discard initMo(3..2, 0)
rejects: discard initMo(low(int)..high(int), 0)
rejects: discard initMo(0..(1 shl 20), 0)
rejects: discard initMo(-1..1, -1)
rejects: discard initMo(-1..1, 0, -1)
rejects: discard initMo(-1, 0)
rejects: discard initMo(1, 0, 0)
rejects: discard initMo(1, -1)
block:
    var mo = initMo(-3..3, 0)
    rejects: mo.insert(-4, 0)
    rejects: mo.insert(0, -4)
    rejects: mo.insert(4, 0)
    rejects: mo.insert(0, 4)
    proc noop(i: int) = discard
    rejects: mo.run(noop, noop, noop, noop, noop, nl = -4)
    rejects: mo.run(noop, noop, noop, noop, noop, nr = 4)
block:
    var mo = initMo(1 shl 23, 0, high(int))
    rejects: mo.insert(1 shl 20, 0)
    rejects: mo.insert(0, -(1 shl 23) - 1)
    rejects: mo.insert(0, 1 shl 23)

block:
    const count = 1 shl 20
    var mo = initMo(-7.. -7, 0)
    for i in 0..<count: mo.insert(-7, -7)
    rejects: mo.insert(-7, -7)
    var records = 0
    proc noop(i: int) = doAssert false
    mo.run(noop, noop, noop, noop, proc(idx: int) =
        doAssert idx == records
        records += 1, nl = -7, nr = -7)
    doAssert records == count

echo "Hello World"
