# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, hashes, algorithm, sequtils
import cplib/collections/hashset

type
    Key = object
        id: int
    Box = ref object
        value: int
proc hash(key: Key): Hash = 0
proc hash(box: Box): Hash = hash(cast[uint](box))
proc `$`(key: Key): string = $key.id

block:
    var set = initHashSet[Key]()
    for i in 0..<32: set.incl(Key(id: i))
    let capacity = set.values.len
    for step in 0..<5000:
        let key = Key(id: step mod 32)
        set.excl(key)
        doAssert not set.contains(key)
        set.incl(key)
        set.incl(key)
        doAssert set.values.len == capacity
        for i in 0..<32: doAssert set.contains(Key(id: i))
    var oldSet = set
    set.excl(Key(id: 0))
    doAssert oldSet.contains(Key(id: 0)) and not set.contains(Key(id: 0))

block:
    var set = initHashSet[Key]()
    for i in 0..<64: set.incl(Key(id: i))
    for i in 1..<64: set.excl(Key(id: i))
    let capacity = set.values.len
    for step in 0..<1000:
        set.excl(Key(id: 0))
        set.incl(Key(id: 0))
        doAssert set.contains(Key(id: 0))
        doAssert set.values.len == 4

block:
    var set = initHashSet[Key]()
    var present: array[128, bool]
    var rng = initRand(97610)
    for step in 0..<4000:
        let i = rng.rand(127)
        let key = Key(id: i)
        if rng.rand(2) == 0:
            set.excl(key)
            present[i] = false
        else:
            set.incl(key)
            present[i] = true
        for j in 0..<128: doAssert set.contains(Key(id: j)) == present[j]
        var actual: seq[int]
        for key in set.items: actual.add(key.id)
        actual.sort()
        var wanted: seq[int]
        for j in 0..<128:
            if present[j]: wanted.add(j)
        doAssert actual == wanted

block:
    var set = initHashSet[string]()
    for i in 0..<200:
        set.incl("same")
        doAssert set.contains("same")
        set.excl("same")
        doAssert not set.contains("same")
    var refs = initHashSet[Box]()
    let box = Box(value: 7)
    for i in 0..<100:
        refs.incl(box)
        doAssert refs.contains(box)
        refs.excl(box)
        doAssert not refs.contains(box)
block:
    var set = initHashSet[Box]()
    let objects = (0..<32).toSeq.mapIt(Box(value: it))
    for box in objects: set.incl(box)
    let preserved = set.values
    let snapshot = repr(preserved)
    for i in 1..<32: set.excl(objects[i])
    set.excl(objects[0])
    set.incl(objects[0])
    doAssert set.values.len == 4 and set.contains(objects[0])
    doAssert repr(preserved) == snapshot
block:
    var set = initHashSet[int]()
    set.incl(7)
    proc access(self: var HashSet[int], val: int): bool = self.contains(val)
    let lookup = access
    doAssert lookup(set, 7)
    doAssert not lookup(set, 8)
echo "Hello World"
