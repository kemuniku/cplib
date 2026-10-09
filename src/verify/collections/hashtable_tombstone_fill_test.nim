# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, hashes, sequtils
import cplib/collections/hashtable

type
    Key = object
        id: int
    Box = ref object
        value: int
proc hash(key: Key): Hash = 0
proc hash(box: Box): Hash = hash(cast[uint](box))
proc `$`(key: Key): string = $key.id
proc `$`(box: Box): string = (if box == nil: "nil" else: $box.value)

block:
    var table = initHashTable[Key, string](64)
    for i in 0..<32: table[Key(id: i)] = $i
    let capacity = table.values.len
    for step in 0..<5000:
        let key = Key(id: step mod 32)
        table.del(key)
        doAssert not table.contains(key) and table.len == 31
        if step mod 2 == 0: table[key] = $step
        else: table.incl((key, $step))
        table.incl((key, $step))
        doAssert table[key] == $step and table.len == 32
        doAssert table.values.len == capacity
        for i in 0..<32: doAssert table.hasKey(Key(id: i))
    let oldTable = table
    table[Key(id: 0)] = "new"
    doAssert oldTable[Key(id: 0)] != table[Key(id: 0)]

block:
    var table = initHashTable[Key, int]()
    var present: array[128, bool]
    var expected: array[128, int]
    var rng = initRand(97610)
    for step in 0..<4000:
        let i = rng.rand(127)
        let key = Key(id: i)
        case rng.rand(5)
        of 0, 1:
            if step mod 2 == 0: table.del(key)
            else: table.excl(key)
            present[i] = false
        of 2, 3:
            table.incl((key, step))
            present[i] = true
            expected[i] = step
        of 4:
            table[key] = step
            present[i] = true
            expected[i] = step
        else:
            if present[i]:
                table[key] += 1
                inc expected[i]
        var count = 0
        for j in 0..<128:
            doAssert table.contains(Key(id: j)) == present[j]
            if present[j]:
                inc count
                doAssert table[Key(id: j)] == expected[j]
        doAssert table.len == count
        var pairs = 0
        for key, value in table.pairs:
            doAssert present[key.id] and value == expected[key.id]
            inc pairs
        doAssert pairs == count
    table.clear()
    doAssert table.len == 0 and table.values.len == 4
    table[Key(id: 0)] = 1
    doAssert table[Key(id: 0)] == 1

block:
    var table = initHashTable[string, Box]()
    for i in 0..<200:
        let box = Box(value: i)
        table.incl(("same", box))
        doAssert table["same"] == box and table["same"].value == i
        table.del("same")
        doAssert table.len == 0
    table["same"] = nil
    doAssert table["same"] == nil
    var refs = initHashTable[Box, int]()
    let box = Box(value: 7)
    for i in 0..<100:
        refs[box] = i
        doAssert refs[box] == i
        refs.del(box)
        doAssert not refs.contains(box)
block:
    var table = initHashTable[int, Box](64)
    let objects = (0..<32).toSeq.mapIt(Box(value: it))
    for i in 0..<32: table[i] = objects[i]
    let preserved = table.values
    let snapshot = repr(preserved)
    for i in 1..<32: table.del(i)
    table.del(0)
    table[0] = objects[0]
    doAssert table.len == 1 and table.values.len == 4
    doAssert table[0] == objects[0]
    doAssert repr(preserved) == snapshot
block:
    var table = initHashTable[int, int]()
    table[0] = 1
    let lookup = hasKey[int, int]
    proc access(self: HashTable[int, int], key: int): int = self[key]
    let getValue = access
    doAssert lookup(table, 0)
    doAssert getValue(table, 0) == 1
    table[0] += 4
    doAssert table[0] == 5
echo "Hello World"
