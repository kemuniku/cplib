# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/[algorithm, random]
import cplib/collections/interval_heap

var heap = initIntervalHeap[int]()
doAssert heap.len == 0

for x in [5, 1, 4, 1, 9, -2]:
    heap.push(x)
doAssert heap.min == -2
doAssert heap.max == 9
doAssert heap.popMin() == -2
doAssert heap.popMax() == 9

var expected = @[1, 1, 4, 5]
for x in expected:
    doAssert heap.popMin() == x
doAssert heap.len == 0

var rng = initRand(20260713)
for trial in 0 ..< 100:
    var actual = initIntervalHeap[int]()
    var values: seq[int]
    for step in 0 ..< 1000:
        if values.len == 0 or rng.rand(2) == 0:
            let x = rng.rand(2000) - 1000
            actual.push(x)
            values.add(x)
        else:
            values.sort()
            if rng.rand(1) == 0:
                doAssert actual.min == values[0]
                doAssert actual.popMin() == values[0]
                values.delete(0)
            else:
                doAssert actual.max == values[^1]
                doAssert actual.popMax() == values[^1]
                values.setLen(values.len - 1)
        doAssert actual.len == values.len

let fromArray = toIntervalHeap([3, 8, -1, 3, 7])
doAssert fromArray.min == -1
doAssert fromArray.max == 8

var cleared = fromArray
cleared.clear()
doAssert cleared.len == 0

type Item = object
    key: int

proc `<`(a, b: Item): bool = a.key < b.key

var items = toIntervalHeap([Item(key: 4), Item(key: -3), Item(key: 10)])
doAssert items.popMin().key == -3
doAssert items.popMax().key == 10
