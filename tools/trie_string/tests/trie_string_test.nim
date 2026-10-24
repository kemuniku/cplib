import random
include ../../../src/cplib/str/trie_string

proc sign(x: int): int =
    return (if x < 0: -1 elif x > 0: 1 else: 0)

proc bruteLcp(a, b: string): int =
    while result < min(a.len, b.len) and a[result] == b[result]:
        inc result

template invalid(body: untyped) =
    block:
        var caught = false
        try:
            body
        except ValueError:
            caught = true
        doAssert caught

var empty: TrieString
doAssert empty.nodeCount == 0
invalid: discard empty.root
invalid: discard empty.add(0, 'a')
invalid: discard empty.pop(0)
invalid: discard empty.length(0)
invalid: discard empty.compare(0, 0)
invalid: discard empty.lcp(0, 0)

var t = initTrieString()
doAssert t.root == 0 and t.nodeCount == 1
doAssert t.pop(0) == 0 and t.length(0) == 0
doAssert t.compare(0, 0) == 0
doAssert t.lcp(0, 0) == 0
for bad in [-1, 1, high(int)]:
    invalid: discard t.add(bad, 'a')
    invalid: discard t.pop(bad)
    invalid: discard t.length(bad)
    invalid: discard t.compare(0, bad)
    invalid: discard t.compare(bad, 0)
    invalid: discard t.lcp(0, bad)
    invalid: discard t.lcp(bad, 0)
    invalid: discard t.lcp(bad, bad)
doAssert t.nodeCount == 1

var byteNodes: seq[int]
for c in 0..255:
    byteNodes.add(t.add(0, char(c)))
    doAssert t.add(0, char(c)) == byteNodes[^1]
for a in 0..255:
    for b in 0..255:
        doAssert t.compare(byteNodes[a], byteNodes[b]) == sign(a - b)

var full = initTrieString()
var words = @[""]
for i in 0..<511:
    for c in ['a', 'b']:
        let v = full.add(i, c)
        doAssert v == words.len
        words.add(words[i] & c)
for a in 0..<words.len:
    for b in 0..<words.len:
        doAssert full.compare(a, b) == sign(cmp(words[a], words[b]))
        doAssert full.lcp(a, b) == bruteLcp(words[a], words[b])

for seed in [1, 17, 20261024]:
    var rng = initRand(seed)
    var trie = initTrieString()
    var strings = @[""]
    var cursor = 0
    for i in 0..<20000:
        let p = (if i mod 3 == 0: cursor else: rng.rand(strings.high))
        let c = char(rng.rand(255))
        let v = trie.add(p, c)
        if v == strings.len:
            strings.add(strings[p] & c)
        doAssert strings[v] == strings[p] & c
        doAssert trie.add(p, c) == v
        doAssert trie.pop(v) == p
        doAssert trie.length(v) == strings[v].len
        cursor = (if i mod 11 == 0: trie.pop(p) else: v)
        for q in 0..<10:
            let a = rng.rand(strings.high)
            let b = rng.rand(strings.high)
            doAssert trie.compare(a, b) == sign(cmp(strings[a], strings[b]))
            doAssert trie.lcp(a, b) == bruteLcp(strings[a], strings[b])
        doAssert trie.nodeCount == strings.len

const depth = 262145
var deep = initTrieString()
var left = @[0]
var right = @[0]
for i in 1..depth:
    left.add(deep.add(left[^1], 'a'))
    right.add(deep.add(right[^1], (if i == 1: 'b' else: 'a')))
for i in 1..depth:
    doAssert deep.pop(left[i]) == left[i - 1]
    doAssert deep.compare(left[i], right[i]) == -1
    doAssert deep.compare(left[depth], left[i - 1]) == 1
    doAssert deep.compare(left[i], right[depth]) == -1
    doAssert deep.add(left[i - 1], 'a') == left[i]
    doAssert deep.lcp(left[i], left[i]) == i
    doAssert deep.lcp(left[depth], left[i - 1]) == i - 1
    doAssert deep.lcp(left[i - 1], left[depth]) == i - 1
    doAssert deep.lcp(left[i], right[depth]) == 0
    doAssert deep.lcp(0, left[i]) == 0
    doAssert deep.lcp(left[i], 0) == 0
for i in countup(0, depth - 1, 127):
    let branch = deep.add(left[i], 'b')
    let extension = deep.add(branch, 'a')
    doAssert deep.compare(left[depth], branch) == -1
    doAssert deep.compare(left[depth], extension) == -1
    doAssert deep.compare(left[i], branch) == -1
    doAssert deep.compare(branch, extension) == -1

# 全深さでジャンプのskew binary不変条件を検査する。
for i in 1..depth:
    var v = left[i]
    var previous = 0
    var blocks = 0
    while v != 0:
        let j = deep.nodes[v].jump
        let weight = deep.nodes[v].depth - deep.nodes[j].depth
        doAssert (weight and (weight + 1)) == 0
        doAssert weight > previous or (blocks == 1 and weight == previous)
        previous = weight
        inc blocks
        v = j
    doAssert blocks <= 20

# 実装と同じ探索の歩数を測り、全小入力と大入力の境界深さで確認する。
proc steps(t: TrieString, node, target: int): int =
    var v = node
    while t.nodes[v].depth > target:
        let j = t.nodes[v].jump
        v = (if t.nodes[j].depth >= target: j else: t.nodes[v].parent)
        inc result
    doAssert t.nodes[v].depth == target

var maxSteps = 0
for d in 0..2048:
    for target in 0..d:
        maxSteps = max(maxSteps, deep.steps(left[d], target))
for target in 0..depth:
    maxSteps = max(maxSteps, deep.steps(left[depth], target))
    doAssert deep.ancestorAtDepth(left[depth], target) == left[target]
doAssert maxSteps <= 4 * 20
echo "PASS: byte alphabet, 1,046,529 exhaustive pairs, 600,000 random pairs, deep/branch/invalid/invariant tests; max traversal steps=", maxSteps

block:
    var arrayTrie = initTrieStringArray(char(0)..char(255))
    var tableTrie = initTrieStringTable(char)
    var strings = @[""]
    var rng = initRand(991)
    for i in 0..<20000:
        let p = rng.rand(strings.high)
        let c = char(rng.rand(255))
        let a = arrayTrie.add(p, c)
        let b = tableTrie.add(p, c)
        doAssert a == b
        if a == strings.len:
            strings.add(strings[p] & c)
        doAssert arrayTrie.add(p, c) == a
        doAssert arrayTrie.pop(a) == p
        doAssert arrayTrie.length(a) == strings[a].len
        for j in 0..<10:
            let x = rng.rand(strings.high)
            let y = rng.rand(strings.high)
            let expected = sign(cmp(strings[x], strings[y]))
            doAssert arrayTrie.compare(x, y) == expected
            doAssert tableTrie.compare(x, y) == expected
            let common = bruteLcp(strings[x], strings[y])
            doAssert arrayTrie.lcp(x, y) == common
            doAssert tableTrie.lcp(x, y) == common
    doAssert arrayTrie.nodeCount == tableTrie.nodeCount

block:
    var a = initTrieStringArray('a'..'b')
    var uninitialized: TrieStringArray['a'..'b']
    invalid: discard uninitialized.root
    invalid: discard uninitialized.add(0, 'a')
    invalid: discard uninitialized.pop(0)
    invalid: discard uninitialized.length(0)
    invalid: discard uninitialized.compare(0, 0)
    invalid: discard uninitialized.lcp(0, 0)
    for bad in [-1, 1, high(int)]:
        invalid: discard a.add(bad, 'a')
        invalid: discard a.pop(bad)
        invalid: discard a.length(bad)
        invalid: discard a.compare(0, bad)
        invalid: discard a.compare(bad, 0)
        invalid: discard a.lcp(0, bad)
        invalid: discard a.lcp(bad, 0)
        invalid: discard a.lcp(bad, bad)
    for c in [char(0), '`', 'c', char(255)]:
        invalid: discard a.add(0, c)
    doAssert a.nodeCount == 1 and a.pop(a.root) == a.root
    doAssert a.lcp(0, 0) == 0
    var x = 0
    var y = 0
    for d in 1..depth:
        x = a.add(x, 'a')
        y = a.add(y, (if d == 1: 'b' else: 'a'))
        doAssert a.compare(x, y) == -1
        doAssert a.compare(x, a.pop(x)) == 1
        doAssert a.lcp(x, x) == d
        doAssert a.lcp(x, a.pop(x)) == d - 1
        doAssert a.lcp(a.pop(x), x) == d - 1
        doAssert a.lcp(x, y) == 0
        doAssert a.lcp(0, x) == 0
        doAssert a.lcp(x, 0) == 0
        if d mod 127 == 0:
            let branch = a.add(x, 'b')
            let child = a.add(branch, 'a')
            doAssert a.compare(x, child) == -1
            let next = a.add(x, 'a')
            doAssert a.compare(next, child) == -1

block:
    var single = initTrieStringArray('z'..'z')
    let z = single.add(0, 'z')
    doAssert single.add(0, 'z') == z
    doAssert single.compare(0, z) == -1
    var ints = initTrieStringTable(int)
    let lo = ints.add(0, low(int))
    let hi = ints.add(0, high(int))
    doAssert ints.add(0, low(int)) == lo
    doAssert ints.compare(lo, hi) == -1
    let extended = ints.add(lo, high(int))
    doAssert ints.compare(extended, hi) == -1

import hashes
type Colliding = distinct int
proc hash(x: Colliding): Hash = 0
proc `==`(a, b: Colliding): bool = int(a) == int(b)
proc `<`(a, b: Colliding): bool = int(a) < int(b)
block:
    var collisions = initTrieStringTable(Colliding)
    var ids: seq[int]
    for i in 0..<256:
        ids.add(collisions.add(0, Colliding(i)))
    for i in 0..<256:
        doAssert collisions.add(0, Colliding(i)) == ids[i]
        for j in 0..<256:
            doAssert collisions.compare(ids[i], ids[j]) == sign(i - j)
echo "PASS: array/table parity (200,000 pairs), array deep branches, generic integers, forced hash collisions"

template longForks(makeTrie: untyped) =
    block:
        var trie = makeTrie
        var chain = @[0]
        for i in 1..50000:
            chain.add(trie.add(chain[^1], 'a'))
        for forkDepth in [1, 2, 3, 30, 31, 32, 1023, 1024, 16383, 32767]:
            var branch = trie.add(chain[forkDepth], 'b')
            for distance in 1..4097:
                if distance > 1:
                    branch = trie.add(branch, 'a')
                doAssert trie.compare(chain[forkDepth + distance], branch) == -1
                doAssert trie.compare(chain[^1], branch) == -1
                doAssert trie.compare(branch, chain[forkDepth]) == 1
                doAssert trie.lcp(chain[forkDepth + distance], branch) == forkDepth
                doAssert trie.lcp(branch, chain[^1]) == forkDepth
                doAssert trie.lcp(branch, chain[forkDepth]) == forkDepth
longForks(initTrieStringTable(char))
longForks(initTrieStringArray('a'..'b'))
echo "PASS: long suffixes below shared prefixes around skew-rank boundaries, both variants"

echo "PASS: exact LCP exhaustive/random oracle, array/table parity, roots/identical/prefix/long forks/invalid handles"

template navigation(makeTrie: untyped) =
    block:
        var trie = makeTrie
        var uninitialized: typeof(trie)
        invalid: discard uninitialized.toString(0)
        invalid: discard uninitialized.toSeq(0)
        invalid: discard uninitialized[0, 0]
        invalid: discard uninitialized.prefix(0, 0)
        invalid: discard uninitialized.lcpNode(0, 0)
        doAssert trie.toString(0) == ""
        doAssert trie.toSeq(0).len == 0
        doAssert trie.prefix(0, 0) == 0
        doAssert trie.lcpNode(0, 0) == 0
        invalid: discard trie[0, 0]
        invalid: discard trie.prefix(0, 1)
        var bytes = ""
        var v = 0
        for i in 0..255:
            bytes.add(char(i))
            v = trie.add(v, char(i))
        doAssert trie.toString(v) == bytes
        let symbols = trie.toSeq(v)
        for i in 0..255:
            doAssert symbols[i] == char(i)
            doAssert trie[v, i] == char(i)
            doAssert trie.toString(trie.prefix(v, i)) == bytes[0..<i]
        for bad in [-1, trie.nodeCount, high(int)]:
            invalid: discard trie.toString(bad)
            invalid: discard trie.toSeq(bad)
            invalid: discard trie[bad, 0]
            invalid: discard trie.prefix(bad, 0)
            invalid: discard trie.lcpNode(0, bad)
            invalid: discard trie.lcpNode(bad, 0)
            invalid: discard trie.lcpNode(bad, bad)
        for bad in [-1, 256, high(int)]:
            invalid: discard trie[v, bad]
        for bad in [-1, 257, high(int)]:
            invalid: discard trie.prefix(v, bad)
        var ids = @[0]
        var strings = @[""]
        var rng = initRand(20261101)
        for i in 1..3000:
            let parent = rng.rand(ids.high)
            let c = char(rng.rand(255))
            let node = trie.add(ids[parent], c)
            ids.add(node)
            strings.add(strings[parent] & c)
            let word = strings[^1]
            doAssert trie.toString(node) == word
            let values = trie.toSeq(node)
            doAssert values.len == word.len
            for j in 0..<word.len:
                doAssert values[j] == word[j] and trie[node, j] == word[j]
            var ancestor = node
            for j in countdown(word.len, 0):
                doAssert trie.prefix(node, j) == ancestor
                doAssert trie.toString(ancestor) == word[0..<j]
                ancestor = trie.pop(ancestor)
            doAssert trie.prefix(node, word.len) == node
            doAssert trie.lcpNode(node, node) == node
            doAssert trie.lcpNode(node, ids[parent]) == ids[parent]
            doAssert trie.lcpNode(ids[parent], node) == ids[parent]
            doAssert trie.lcpNode(node, 0) == 0 and trie.lcpNode(0, node) == 0
            for q in 0..<5:
                let other = rng.rand(ids.high)
                let common = bruteLcp(word, strings[other])
                let before = trie.nodeCount
                doAssert trie.lcpNode(node, ids[other]) == trie.prefix(node, common)
                doAssert trie.toString(trie.lcpNode(node, ids[other])) == word[0..<common]
                doAssert trie.nodeCount == before
        var chain = @[0]
        const navDepth = 8193
        for i in 1..navDepth:
            chain.add(trie.add(chain[^1], 'x'))
        let restored = trie.toString(chain[^1])
        let values = trie.toSeq(chain[^1])
        doAssert restored.len == navDepth and values.len == navDepth
        for i in 0..<navDepth:
            doAssert restored[i] == 'x' and values[i] == 'x'
        for i in countup(0, navDepth - 1, 127):
            doAssert trie[chain[^1], i] == 'x'
            doAssert trie.prefix(chain[^1], i) == chain[i]
            let branch = trie.add(chain[i], 'y')
            doAssert trie.lcpNode(chain[^1], branch) == chain[i]
            doAssert trie.lcpNode(branch, chain[^1]) == chain[i]

navigation(initTrieStringTable(char))
navigation(initTrieStringArray(char(0)..char(255)))

block:
    var ints = initTrieStringTable(int)
    doAssert ints.toSeq(0).len == 0
    invalid: discard ints[0, 0]
    var ids = @[0]
    var words: seq[seq[int]] = @[@[]]
    var rng = initRand(701)
    for i in 1..3000:
        let p = rng.rand(ids.high)
        let c = (if i == 1: low(int) elif i == 2: high(int) else: rng.rand(200) - 100)
        let node = ints.add(ids[p], c)
        ids.add(node)
        words.add(words[p] & @[c])
        doAssert ints.toSeq(node) == words[^1]
        for j in 0..<words[^1].len:
            doAssert ints[node, j] == words[^1][j]
        for j in 0..words[^1].len:
            doAssert ints.toSeq(ints.prefix(node, j)) == words[^1][0..<j]
        let other = rng.rand(ids.high)
        var common = 0
        while common < min(words[^1].len, words[other].len) and words[^1][common] == words[other][common]:
            inc common
        doAssert ints.lcpNode(node, ids[other]) == ints.prefix(node, common)
    for bad in [-1, ints.nodeCount, high(int)]:
        invalid: discard ints.toSeq(bad)
        invalid: discard ints[bad, 0]
        invalid: discard ints.prefix(bad, 0)
        invalid: discard ints.lcpNode(bad, bad)
    invalid: discard ints[ids[^1], -1]
    invalid: discard ints[ids[^1], words[^1].len]
    invalid: discard ints.prefix(ids[^1], -1)
    invalid: discard ints.prefix(ids[^1], words[^1].len + 1)
echo "PASS: conversions, symbol access, canonical LCP/prefix handles, byte/int oracles, deep chains, invalid bounds"
