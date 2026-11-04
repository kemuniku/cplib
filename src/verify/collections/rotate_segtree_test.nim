# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/rotate_segtree
import cplib/collections/segtree
import random, strutils

proc concatenate(x, y: string): string = x & y

proc rotateOracle(values: var seq[string], shift: int) =
    if values.len == 0: return
    let magnitude = if shift < 0: uint(-(shift + 1)) + 1'u else: uint(shift)
    let steps = int(magnitude mod uint(values.len))
    for step in 0..<steps:
        if shift < 0:
            let last = values[^1]
            for i in countdown(values.high, 1): values[i] = values[i - 1]
            values[0] = last
        else:
            let first = values[0]
            for i in 1..<values.len: values[i - 1] = values[i]
            values[^1] = first

proc productOracle(values: seq[string], start, count: int): string =
    var index = start
    for i in 0..<count:
        if index == values.len: index = 0
        result.add(values[index])
        inc index

proc checkAll(tree: RotateSegmentTree[string], values: seq[string]) =
    doAssert tree.len == values.len
    doAssert tree.get_all() == values.join("")
    doAssert $tree == values.join(" ")
    for i in 0..<values.len:
        doAssert tree[i] == values[i]
        doAssert tree[^(values.len - i)] == values[i]
    for start in 0..values.len:
        for count in 0..values.len:
            doAssert tree.get(start, count) == productOracle(values, start, count)
        for finish in start..values.len:
            doAssert tree[start..<finish] == values[start..<finish].join("")

for n in 0..12:
    var original = newSeq[string](n)
    for i in 0..<n: original[i] = $char(ord('a') + i)
    for shift in -2 * n - 2..2 * n + 2:
        var values = newSeq[string](n)
        for i in 0..<n: values[i] = original[i]
        let tree = initRotateSegmentTree(original, concatenate, "")
        tree.rotate(shift)
        rotateOracle(values, shift)
        checkAll(tree, values)
        if n > 0:
            tree.set(0, "first")
            values[0] = "first"
            tree[^1] = "last"
            values[^1] = "last"
            tree.update(n div 2, "middle")
            values[n div 2] = "middle"
            checkAll(tree, values)

var rng = initRand(463)
for n in [0, 1, 2, 3, 5, 8, 17, 33]:
    let tree = newRotateSegWith(n, l & r, "")
    var values = newSeq[string](n)
    for step in 0..<1500:
        if step mod 3 == 0:
            let shift = case step mod 5
                of 0: low(int)
                of 1: high(int)
                of 2: low(int) + 1
                of 3: high(int) - 1
                else: rng.rand(-1000..1000)
            tree.rotate(shift)
            rotateOracle(values, shift)
        elif n > 0:
            let index = rng.rand(n - 1)
            let value = $rng.rand(99)
            if step mod 3 == 1: tree[index] = value
            else: tree.update(index, value)
            values[index] = value
        let start = rng.rand(n)
        let count = rng.rand(n)
        doAssert tree.get(start, count) == productOracle(values, start, count)
        doAssert tree.get_all() == values.join("")
    checkAll(tree, values)

block:
    let tree = newRotateSegWith(["a", "b", "c", "d", "e"], l & r, "")
    tree.rotate(3)
    doAssert tree.get(0, 5) == "deabc"
    doAssert tree.get(3, 2) == "bc"
    doAssert tree.get(4, 3) == "cde"
    doAssert tree.get(2, 5) == "abcde"
    doAssert tree.get(5, 5) == "deabc"
    doAssert tree.get_all() == "deabc"

block:
    var calls = 0
    let merge = proc(x, y: int): int =
        inc calls
        x + y
    let n = 65537
    let tree = initRotateSegmentTree(n, merge, 0)
    calls = 0
    for i in 0..<100000: tree.rotate(if i mod 2 == 0: high(int) else: low(int))
    doAssert calls == 0
    tree.set(12345, 7)
    doAssert calls <= 17
    calls = 0
    doAssert tree.get(12346, n) == 7
    doAssert calls <= 73
    doAssert tree[12345] == 7

when compileOption("assertions"):
    template rejects(body: untyped) =
        block:
            var rejected = false
            try: body
            except AssertionDefect: rejected = true
            doAssert rejected
    let tree = newRotateSegWith([1, 2, 3], l + r, 0)
    rejects:
        discard tree.get(-1, 0)
    rejects:
        discard tree.get(4, 0)
    rejects:
        discard tree.get(0, -1)
    rejects:
        discard tree.get(0, 4)
    rejects:
        tree.set(-1, 1)
    rejects:
        tree.update(3, 1)
    rejects:
        discard tree[-1]
    rejects:
        discard tree[3]
    rejects:
        discard tree[0..high(int)]
    rejects:
        discard tree[low(int)..0]
    rejects:
        discard tree[2..0]
    rejects:
        discard initRotateSegmentTree(-1, proc(x, y: int): int = x + y, 0)
    let empty = newRotateSegWith(0, l + r, 0)
    rejects:
        empty.set(0, 1)
    rejects:
        discard empty[0]
    rejects:
        discard empty.get(0, 1)

echo "Hello World"
