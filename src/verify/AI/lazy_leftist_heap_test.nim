# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/lazy_leftist_heap
import random

type Item = tuple[key: int64, value: int]
var pool = initLazyLeftistHeapPool[int64, int](1000)
var roots: array[16, int]
var oracle: array[16, seq[Item]]
for root in roots.mitems: root = -1
var next = 0
var rng = initRand(940)

proc best(items: seq[Item]): int =
    result = 0
    for i in 1..<items.len:
        if items[i].key < items[result].key or
                (items[i].key == items[result].key and items[i].value < items[result].value):
            result = i

proc check() =
    for i in 0..<roots.len:
        doAssert (roots[i] == -1) == (oracle[i].len == 0)
        if roots[i] != -1:
            doAssert pool.top(roots[i]) == oracle[i][best(oracle[i])]

proc insert(i: int, key: int64) =
    let h = pool.singleton(key, next)
    oracle[i].add((key, next))
    roots[i] = pool.meld(roots[i], h)
    inc next

proc add(i: int, delta: int64) =
    pool.addAll(roots[i], delta)
    for item in oracle[i].mitems: item.key += delta

proc merge(a, b: int) =
    doAssert a != b
    roots[a] = pool.meld(roots[a], roots[b])
    roots[b] = -1
    oracle[a].add(oracle[b])
    oracle[b] = @[]

proc remove(i: int) =
    let at = best(oracle[i])
    doAssert pool.top(roots[i]) == oracle[i][at]
    roots[i] = pool.pop(roots[i])
    oracle[i].delete(at)

# 遅延加算後の新規要素と別ヒープへ、以前の加算が漏れないことを確認する。
insert(0, 4)
insert(0, 4)
add(0, -10)
insert(1, -6)
merge(1, 0)
insert(1, -6)
check()
while roots[1] != -1:
    remove(1)
    check()
add(0, -99)
merge(0, 1)

for step in 0..<50000:
    let a = rng.rand(roots.len - 1)
    case rng.rand(0..3)
    of 0: insert(a, rng.rand(-30..30).int64)
    of 1: add(a, rng.rand(-30..30).int64)
    of 2:
        let b = (a + rng.rand(1..<roots.len)) mod roots.len
        merge(a, b)
    else:
        if roots[a] != -1: remove(a)
    check()
for i in 0..<roots.len:
    while roots[i] != -1: remove(i)
check()

block:
    # payload の比較は不要。同じキーは併合順によらず挿入順。
    type Payload = object
        label: string
    var strings = initLazyLeftistHeapPool[int, Payload]()
    let a = strings.singleton(1, Payload(label: "first"))
    let b = strings.singleton(1, Payload(label: "second"))
    var root = strings.meld(b, a)
    doAssert strings.top(root).value.label == "first"
    root = strings.pop(root)
    doAssert strings.top(root).value.label == "second"
    doAssert strings.pop(root) == -1

block:
    var large = initLazyLeftistHeapPool[int64, int](200000)
    var root = -1
    for i in countdown(199999, 0):
        root = large.meld(root, large.singleton(i.int64, i))
    large.addAll(root, -200000)
    for i in 0..<200000:
        doAssert large.top(root) == (i.int64 - 200000, i)
        root = large.pop(root)
    doAssert root == -1

stderr.writeLine("lazy leftist heap regression: 50000 oracle operations and 200000 elements passed")
echo "Hello World"
