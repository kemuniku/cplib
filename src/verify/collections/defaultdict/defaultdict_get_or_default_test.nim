# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import hashes, tables
import cplib/collections/defaultdict

type CollisionKey = object
    id: int
proc hash(key: CollisionKey): Hash = 0

var d = initDefaultDict[CollisionKey, int](17)
var model: seq[(int, int)]
let sampleKeys = @[low(int), high(int), -1, 0, 1, 2, 7, 9, 15]

proc find(key: int): int =
    for i, pair in model:
        if pair[0] == key: return i
    -1

proc check() =
    let beforeLen = d.len
    let beforeHash = d.hash
    let beforeText = $d
    for id in sampleKeys:
        let i = find(id)
        let key = CollisionKey(id: id)
        let expected = if i < 0: 17 else: model[i][1]
        doAssert d.getOrDefault(key) == expected
        doAssert d.hasKey(key) == (i >= 0)
    doAssert d.len == beforeLen
    doAssert d.hash == beforeHash
    doAssert $d == beforeText
    var count = 0
    for key, value in d.pairs:
        let i = find(key.id)
        doAssert i >= 0 and model[i][1] == value
        inc count
    doAssert count == model.len and d.len == model.len

check()
for step in 0..<500:
    let id = sampleKeys[(step * 7 + step div 9) mod sampleKeys.len]
    let key = CollisionKey(id: id)
    let i = find(id)
    case step mod 11
    of 0:
        d.clear()
        model.setLen(0)
    of 1, 2:
        d.del(key)
        if i >= 0: model.delete(i)
    of 3, 4, 5:
        let delta = step mod 17 - 8
        d[key] += delta
        if i >= 0: model[i][1] += delta
        else: model.add((id, 17 + delta))
    of 6, 7:
        let value = step - 250
        d[key] = value
        if i >= 0: model[i][1] = value
        else: model.add((id, value))
    else:
        discard d.getOrDefault(key)
    check()

let immutable = [("present", 0)].toDefaultDict(-3)
doAssert immutable.getOrDefault("present") == 0
doAssert immutable.getOrDefault("missing") == -3
doAssert immutable.len == 1 and not immutable.hasKey("missing")
let converted = {"present": 5}.toTable.toDefaultDict(-9)
doAssert converted.getOrDefault("present") == 5
doAssert converted.getOrDefault("missing") == -9
doAssert converted.len == 1

var sequenceDict = initDefaultDict[int, seq[int]](@[10])
doAssert sequenceDict.getOrDefault(1) == @[10]
doAssert sequenceDict.len == 0
var copied = sequenceDict.getOrDefault(1)
copied.add(99)
doAssert sequenceDict.getOrDefault(2) == @[10] and sequenceDict.len == 0
sequenceDict[1].add(20)
doAssert sequenceDict.getOrDefault(1) == @[10, 20]
doAssert sequenceDict.getOrDefault(2) == @[10]
doAssert sequenceDict.len == 1 and not sequenceDict.hasKey(2)

type Payload = object
    number: int
    text: string
proc update(value: var Payload) =
    inc value.number
    value.text.add("!")
var objects = initDefaultDict[int, Payload](Payload(number: 7, text: "default"))
doAssert objects.getOrDefault(1).number == 7
doAssert objects.len == 0
objects[1].update()
doAssert objects.getOrDefault(1) == Payload(number: 8, text: "default!")
doAssert objects.getOrDefault(2) == Payload(number: 7, text: "default")
doAssert objects.len == 1

type Reference = ref object
    number: int
let fallback = Reference(number: 7)
var references = initDefaultDict[int, Reference](fallback)
doAssert references.getOrDefault(1) == fallback
doAssert references.len == 0
references.getOrDefault(1).number = 9
doAssert fallback.number == 9 and not references.hasKey(1)
var nilDefaults = initDefaultDict[int, Reference](nil)
doAssert nilDefaults.getOrDefault(0).isNil and nilDefaults.len == 0

echo "Hello World"
