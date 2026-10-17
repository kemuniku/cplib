# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/utils/kth_element

proc check[T](a: openArray[T]) =
    let before = @a
    let expected = a.sorted
    for k in 0..<a.len:
        randomize(20261005 + k)
        doAssert kth_element(a,k) == expected[k]
        doAssert @a == before

check([low(int), high(int), 0, low(int), high(int)])
check([0u, high(uint), 1u, high(uint)])
check([1.0, -1.0, system.Inf, NegInf, 0.0, 1.0])
check(["", "a", "\0", "\xff", "aaa", "a"])
check(['a', '\0', '\xff', 'a'])
check([(2,"z"), (1,"a"), (1,"z"), (2,"a")])
for n in 1..6:
    var count = 1
    for _ in 0..<n:
        count *= 3
    for code in 0..<count:
        var a = newSeq[int](n)
        var x = code
        for i in 0..<n:
            a[i] = x mod 3 - 1
            x = x div 3
        check(a)
var rng = initRand(20261005)
for trial in 0..<200:
    var a = newSeq[int](rng.rand(1..100))
    for x in a.mitems:
        x = rng.rand(-1000..1000)
    check(a)

type Key = object
    value: int
    payload: array[8,int]
proc `<`(a,b:Key):bool = a.value < b.value
proc `==`(a,b:Key):bool = a.value == b.value
proc cmp(a,b:Key):int =
    if a.value < b.value: low(int)
    elif a.value > b.value: high(int)
    else: 0
let keys = [Key(value:3),Key(value:1),Key(value:2),Key(value:1)]
for k, expected in [1,1,2,3]:
    randomize(20261005)
    doAssert kth_element(keys,k).value == expected

echo "Hello World"
