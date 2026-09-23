# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, heapqueue, random
import cplib/collections/radix_heap

proc checkBounds[K: SomeInteger]() =
    var heap = initRadixHeap[K, string]()
    var keys = @[low(K), low(K) + K(1), K(0), K(1), high(K) - K(1), high(K)]
    when K is SomeSignedInt:
        keys.add(K(-1))
    for key in keys:
        heap.push(key, $key)
    keys.sort()
    for key in keys:
        doAssert heap.top().key == key
        doAssert heap[0] == heap.top()
        doAssert heap.pop() == (key, $key)
    doAssert heap.isEmpty()
    heap.push(high(K), "last")
    doAssert heap.pop().key == high(K)
    heap.clear()
    heap.push(low(K), "first")
    doAssert heap.pop().key == low(K)

checkBounds[int]()
checkBounds[int8]()
checkBounds[int16]()
checkBounds[int32]()
checkBounds[int64]()
checkBounds[uint]()
checkBounds[uint8]()
checkBounds[uint16]()
checkBounds[uint32]()
checkBounds[uint64]()

var rng = initRand(712367)
var heap = initRadixHeap[int, int]()
var reference = initHeapQueue[int]()
var last = -100000
for step in 0..<30000:
    if reference.len == 0 or rng.rand(99) < 60:
        let key = last + rng.rand(10000)
        heap.push((key, step))
        reference.push(key)
    else:
        doAssert heap.top().key == reference[0]
        last = heap.pop().key
        doAssert last == reference.pop()
    doAssert heap.len == reference.len
while reference.len != 0:
    doAssert heap.pop().key == reference.pop()

type Payload = object
    data: seq[string]
var payloadHeap = initRadixHeap[int, Payload](-3)
payloadHeap.push(-2, Payload(data: @["a", "b"]))
payloadHeap.push(-2, Payload(data: @["c"]))
doAssert payloadHeap.pop().value.data.len > 0
payloadHeap.clear(-10)
payloadHeap.push(-10, Payload(data: @["reset"]))
doAssert payloadHeap.pop().value.data == @["reset"]

when compileOption("assertions"):
    var rejected = false
    try:
        payloadHeap.push(-11, Payload())
    except AssertionDefect:
        rejected = true
    doAssert rejected
    rejected = false
    try:
        discard payloadHeap.pop()
    except AssertionDefect:
        rejected = true
    doAssert rejected

echo "Hello World"
