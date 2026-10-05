# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/knapsack

proc oracle(items: openArray[tuple[v:int,w:int]], capacity: int): int =
    for mask in 0..<(1 shl items.len):
        var value, weight = 0
        for i, item in items:
            if (mask and (1 shl i)) != 0:
                value += item.v
                weight += item.w
        if weight <= capacity:
            result = max(result,value)

proc check(items: openArray[tuple[v:int,w:int]], capacity: int, nonnegative = true) =
    let expected = oracle(items,capacity)
    doAssert solve_01knapsack_NW(items,capacity) == expected
    doAssert solve_01knapsack_meet_in_middle(items,capacity) == expected
    if nonnegative:
        doAssert solve_01knapsack_NV(items,capacity) == expected

check(newSeq[tuple[v:int,w:int]](),0)
check(newSeq[tuple[v:int,w:int]](),10)
check([(v:0,w:0),(v:2,w:0),(v:3,w:1)],0)
check([(v:1,w:100),(v:2,w:100),(v:3,w:1)],2)
check([(v:3,w:1),(v:5,w:1),(v:3,w:1)],3)
check([(v: -5,w:0),(v:4,w:2),(v: -1,w:1)],3,false)
for n in 0..4:
    var count = 1
    for _ in 0..<n:
        count *= 9
    for code in 0..<count:
        var items = newSeq[tuple[v:int,w:int]](n)
        var x = code
        for i in 0..<n:
            items[i] = (v:x mod 3,w:(x div 3) mod 3)
            x = x div 9
        for capacity in 0..6:
            check(items,capacity)
var rng = initRand(20261005)
for trial in 0..<600:
    var items = newSeq[tuple[v:int,w:int]](rng.rand(0..14))
    for item in items.mitems:
        item = (v:rng.rand(0..50),w:rng.rand(0..30))
    check(items,rng.rand(0..100))
for trial in 0..<200:
    var items = newSeq[tuple[v:int,w:int]](rng.rand(0..14))
    for item in items.mitems:
        item = (v:rng.rand(-20..50),w:rng.rand(0..30))
    check(items,rng.rand(0..100),false)
let fixed = [(v:7,w:2),(v:2,w:0),(v:11,w:3)]
check(fixed,3)
check(fixed.toOpenArray(1,2),3)
echo "Hello World"
