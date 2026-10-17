# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, deques
import cplib/collections/persistent_queue

proc check[T](queue: PersistentQueue[T], values: seq[T]) =
    doAssert queue.len == values.len
    var remaining = queue
    for value in values:
        doAssert remaining.front() == value
        remaining = remaining.pop()
    doAssert remaining.len == 0
    doAssert queue.len == values.len

block:
    var empty: PersistentQueue[int]
    let initialized = initPersistentQueue[int]()
    check(empty, newSeq[int]())
    check(initialized, newSeq[int]())
    let first = empty.push(int.low)
    let sibling = empty.push(int.high)
    check(first, @[int.low])
    check(sibling, @[int.high])
    let second = first.push(0)
    let third = second.push(int.high)
    check(second, @[int.low, 0])
    check(third.pop().push(-1), @[0, int.high, -1])
    check(third.pop().pop().push(7), @[int.high, 7])
    check(first.pop().push(42), @[42])
    check(third, @[int.low, 0, int.high])
    when compileOption("assertions"):
        var rejected = false
        try:
            discard empty.front()
        except AssertionDefect:
            rejected = true
        doAssert rejected
        rejected = false
        try:
            discard empty.pop()
        except AssertionDefect:
            rejected = true
        doAssert rejected

block:
    let original = initPersistentQueue[string]().push("日本語").push("").push("abc")
    check(original.pop().push("分岐"), @["", "abc", "分岐"])
    check(original, @["日本語", "", "abc"])
    let sequences = initPersistentQueue[seq[int]]().push(@[1, 2]).push(@[3])
    var value = sequences.front()
    value.add(9)
    check(sequences, @[@[1, 2], @[3]])
    type Item = object
        key: int
        text: string
    let items = initPersistentQueue[Item]().push(Item(key: 2, text: "x"))
    check(items.push(Item(key: 1, text: "y")), @[Item(key: 2, text: "x"), Item(key: 1, text: "y")])
    let references = initPersistentQueue[ref int]().push(new(int))
    doAssert references.front()[] == 0
    doAssert references.pop().len == 0

block:
    var versions = @[initPersistentQueue[int]()]
    for i in 0..<131073:
        versions.add(versions[^1].push(i))
    for length in [1, 2, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65,
            127, 128, 129, 255, 256, 257, 1023, 1024, 1025, 65535, 65536, 65537,
            131071, 131072, 131073]:
        var branch = versions[length]
        for removed in 0..<length:
            doAssert branch.len == length - removed
            doAssert branch.front() == removed
            let sibling = branch.push(-removed - 1)
            doAssert sibling.len == branch.len + 1
            doAssert sibling.front() == removed
            branch = branch.pop()
        check(branch.push(-1).push(-2), @[-1, -2])
        doAssert versions[length].len == length
        doAssert versions[length].front() == 0
    let base = versions[^1]
    for i in 0..<10000:
        let branch = base.pop().push(-i)
        doAssert branch.front() == 1
        doAssert branch.len == base.len
    doAssert base.front() == 0

block:
    var queue = initPersistentQueue[int]()
    for i in 0..<100000:
        queue = queue.push(i)
        doAssert queue.front() == i
        queue = queue.pop()
        doAssert queue.len == 0

block:
    var rng = initRand(6801729)
    for trial in 0..<40:
        var versions = @[initPersistentQueue[int]()]
        var oracle = @[initDeque[int]()]
        for step in 0..<1000:
            let parent = if step mod 3 == 0: versions.high else: rng.rand(versions.high)
            var expected = oracle[parent]
            let adding = expected.len == 0 or rng.rand(3) != 0
            let next = if adding:
                let value = rng.rand(-1000000..1000000)
                expected.addLast(value)
                versions[parent].push(value)
            else:
                doAssert versions[parent].front() == expected.peekFirst()
                discard expected.popFirst()
                versions[parent].pop()
            versions.add(next)
            oracle.add(expected)
            doAssert next.len == expected.len
            if expected.len > 0:
                doAssert next.front() == expected.peekFirst()
            let inspected = rng.rand(versions.high)
            var values: seq[int]
            for value in oracle[inspected].items:
                values.add(value)
            check(versions[inspected], values)
        for i in 0..<versions.len:
            var values: seq[int]
            for value in oracle[i].items:
                values.add(value)
            check(versions[i], values)

echo "Hello World"
