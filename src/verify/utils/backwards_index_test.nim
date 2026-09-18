# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/backwards_index

type Buffer[T] = object
    data: seq[T]

proc len[T](self: Buffer[T]): int = self.data.len
proc `[]`[T](self: Buffer[T], idx: int): T {.backwardsIndex.} =
    self.data[idx]
proc `[]`[T](self: var Buffer[T], idx: int): var T {.backwardsIndex.} =
    self.data[idx]
proc `[]=`[T](self: var Buffer[T], idx: Natural, value: T) {.backwardsIndex.} =
    self.data[idx] = value

let immutable = Buffer[int](data: @[10, 20, 30])
doAssert immutable[^1] == 30
doAssert immutable[^immutable.len] == 10
var mutable = immutable
mutable[^1] = 40
mutable[^2] += 5
doAssert mutable.data == @[10, 25, 40]

var receiverCalls, indexCalls, valueCalls: int
proc receiver(): var Buffer[int] =
    inc receiverCalls
    mutable
proc index(): BackwardsIndex =
    inc indexCalls
    ^1
proc value(): int =
    inc valueCalls
    99
receiver()[index()] = value()
doAssert (receiverCalls, indexCalls, valueCalls) == (1, 1, 1)
receiver()[index()] += 1
doAssert (receiverCalls, indexCalls) == (2, 2)
doAssert mutable[^1] == 100

type FixedBuffer[N: static int, T] = object
    data: array[N, T]
func len[N: static int, T](self: FixedBuffer[N, T]): int = N
func `[]`[N: static int, T](self: FixedBuffer[N, T], idx: Natural): T {.inline, backwardsIndex.} =
    self.data[idx]
let fixed = FixedBuffer[3, int](data: [1, 2, 3])
doAssert fixed[^1] == 3
doAssert fixed[^3] == 1

for idx in [^0, ^4]:
    var raised = false
    try:
        discard immutable[idx]
    except IndexDefect:
        raised = true
    doAssert raised

let empty = Buffer[int]()
var raised = false
try:
    discard empty[^1]
except IndexDefect:
    raised = true
doAssert raised

echo "Hello World"
