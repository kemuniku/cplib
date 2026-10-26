# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/static_range_distinct
import random, hashes

proc naive[T](a: openArray[T], l, r: int): int =
    var seen: seq[T]
    for i in l..<r:
        if a[i] notin seen:
            seen.add(a[i])
    seen.len

var rng = initRand(20261022)

proc check[T](a: openArray[T]) =
    let d = initStaticRangeDistinct(a)
    doAssert d.len == a.len
    var intervals: seq[tuple[l, r: int]]
    for l in 0..a.len:
        for r in l..a.len:
            intervals.add((l, r))
    rng.shuffle(intervals)
    for (l, r) in intervals:
        doAssert d.count(l, r) == naive(a, l, r)

check(newSeq[int]())
check(@[1])
check(@[int.low, int.high, 0, int.low, int.high])
check(@[0'u64, uint64.high, 1'u64 shl 63, uint64.high])
check(@["", "日本語", "abc", "日本語", ""])
check(@[(1, "a"), (2, "b"), (1, "a")])

type CollisionKey = object
    value: int
proc hash(x: CollisionKey): Hash = Hash(0)
check(@[CollisionKey(value: 1), CollisionKey(value: 2), CollisionKey(value: 1)])

proc checkCompared[T](a: openArray[T], keys: openArray[int], cmp: proc(a, b: T): int) =
    let d = initStaticRangeDistinct(a, cmp)
    doAssert d.len == a.len
    for l in 0..a.len:
        for r in l..a.len:
            doAssert d.count(l, r) == naive(keys, l, r)

type CompareOnly = object
    value: int
proc hash(x: CompareOnly): Hash {.error: "hash は使用できません".}
proc `==`(a, b: CompareOnly): bool {.error: "== は使用できません".}
proc cmp(a, b: CompareOnly): int = cmp(a.value, b.value)

doAssert not compiles(hash(CompareOnly(value: 0)))
doAssert not compiles(CompareOnly(value: 0) == CompareOnly(value: 0))
for keys in [newSeq[int](), @[1], @[2, 1, 2, 3, 1], @[1, 1, 1]]:
    var a: seq[CompareOnly]
    for key in keys:
        a.add(CompareOnly(value: key))
    let d = initStaticRangeDistinct(a)
    for l in 0..a.len:
        for r in l..a.len:
            doAssert d.count(l, r) == naive(keys, l, r)
    checkCompared(a, keys, cmp)

checkCompared(@[(1, "a"), (2, "b"), (1, "c"), (2, "d")], @[1, 2, 1, 2],
    proc(a, b: (int, string)): int = cmp(a[0], b[0]))
checkCompared(@[int.low, int.high, 0, int.low], @[0, 1, 2, 0],
    proc(a, b: int): int = cmp(b, a))
let modulus = 3
checkCompared(@[1, 4, 2, 5, 3, 6], @[1, 1, 2, 2, 0, 0],
    proc(a, b: int): int = cmp(a mod modulus, b mod modulus))

for n in [2, 3, 7, 8, 15, 16, 63, 64, 65, 127, 128, 129]:
    var equal = newSeq[int](n)
    var unique = newSeq[int](n)
    var alternating = newSeq[int](n)
    for i in 0..<n:
        equal[i] = -17
        unique[i] = i - n
        alternating[i] = i mod 2
    check(equal)
    check(unique)
    check(alternating)

for trial in 0..<100:
    var a = newSeq[int](rng.rand(45))
    for x in a.mitems:
        x = rng.rand(20) - 10
    check(a)
    checkCompared(a, a, proc(a, b: int): int = cmp(a, b))

for n in [255, 256, 257, 1024, 4097]:
    var a = newSeq[int](n)
    for x in a.mitems:
        x = rng.rand(99) - 50
    let d = initStaticRangeDistinct(a)
    let compared = initStaticRangeDistinct(a, proc(a, b: int): int = cmp(a, b))
    var previousAnswer = 0
    for q in 0..<500:
        let x = (rng.rand(n) + previousAnswer) mod (n+1)
        let y = (rng.rand(n) + previousAnswer) mod (n+1)
        let l = min(x, y)
        let r = max(x, y)
        previousAnswer = d.count(l, r)
        doAssert previousAnswer == naive(a, l, r)
        doAssert compared.count(l, r) == previousAnswer

var input = @[1, 2, 1]
let snapshot = initStaticRangeDistinct(input)
let comparedSnapshot = initStaticRangeDistinct(input, proc(a, b: int): int = cmp(a, b))
input[1] = 1
doAssert snapshot.count(0, 3) == 2
doAssert comparedSnapshot.count(0, 3) == 2
let zero: StaticRangeDistinct = default(StaticRangeDistinct)
doAssert zero.len == 0
doAssert zero.count(0, 0) == 0
when compileOption("assertions"):
    for interval in [(-1, 0), (0, 4), (2, 1), (4, 4)]:
        var caught = false
        try:
            discard snapshot.count(interval[0], interval[1])
        except AssertionDefect:
            caught = true
        doAssert caught
echo "Hello World"
