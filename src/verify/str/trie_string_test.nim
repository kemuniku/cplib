# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, hashes
include ../../cplib/str/trie_string

proc sign(x: int): int =
    if x < 0: -1 elif x > 0: 1 else: 0

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

template checkBad(bad, good, symbol: untyped) =
    invalid: discard id(bad)
    invalid: discard bad.add(symbol)
    invalid: discard bad.pop()
    invalid: discard bad.length
    invalid: discard len(bad)
    invalid: discard bad.len
    invalid: discard bad.prefix(0)
    invalid: discard bad[0]
    invalid: discard bad.toSeq()
    invalid: discard bad.cmp(good)
    invalid: discard good.cmp(bad)
    invalid: discard bad < good
    invalid: discard good < bad
    invalid: discard bad <= good
    invalid: discard good <= bad
    invalid: discard bad > good
    invalid: discard good > bad
    invalid: discard bad >= good
    invalid: discard good >= bad
    invalid: discard bad.lcp(good)
    invalid: discard good.lcp(bad)
    invalid: discard bad.lcpNode(good)
    invalid: discard good.lcpNode(bad)
    invalid: discard bad == good
    invalid: discard bad == bad

template basics(makeTrie: untyped) =
    block:
        var trie = makeTrie
        let root = trie.root
        var emptyArena: typeof(trie)
        var defaultNode: typeof(root)
        doAssert emptyArena.nodeCount == 0
        invalid: discard emptyArena.root
        checkBad(defaultNode, root, 'a')
        invalid: discard ($defaultNode)
        for id in [-1, trie.nodeCount, high(int)]:
            var bad = root
            bad.id = id
            checkBad(bad, root, 'a')
            invalid: discard ($bad)
        let otherArena = makeTrie
        let other = otherArena.root
        invalid: discard root.cmp(other)
        invalid: discard other.cmp(root)
        invalid: discard root < other
        invalid: discard root <= other
        invalid: discard root > other
        invalid: discard root >= other
        invalid: discard root.lcp(other)
        invalid: discard other.lcp(root)
        invalid: discard root.lcpNode(other)
        invalid: discard other.lcpNode(root)
        invalid: discard root == other
        doAssert root.pop() == root and root.prefix(0) == root
        doAssert root.length == 0 and root.cmp(root) == 0
        doAssert root.lcp(root) == 0 and root.lcpNode(root) == root
        doAssert ($root) == "" and root.toSeq().len == 0
        invalid: discard root[0]
        invalid: discard root[-1]
        invalid: discard root.prefix(1)
        invalid: discard root.prefix(-1)
        let a = root.add('a')
        let ab = a.add('b')
        let aCopy = a
        var moving = a
        moving = moving.add('b')
        doAssert moving == ab and aCopy == a and ($a) == "a"
        moving = moving.pop()
        doAssert moving == a and ($ab) == "ab"
        doAssert root.add('a').add('b') == ab
        let alias = trie
        doAssert alias.root == root
        trie = makeTrie
        doAssert alias.root.add('a') == a
        invalid: discard trie.root.cmp(a)
        doAssert ($ab) == "ab"
        for bad in [-1, 2, high(int)]:
            invalid: discard ab[bad]
        for bad in [-1, 3, high(int)]:
            invalid: discard ab.prefix(bad)

basics(initTrieStringTable(char))
basics(initTrieStringArray('a'..'b'))
block:
    let a = initTrieStringArray('a'..'b')
    for c in [char(0), '`', 'c', char(255)]:
        invalid: discard a.root.add(c)
    doAssert a.nodeCount == 1
    let one = initTrieStringArray('z'..'z').root
    doAssert one.add('z') == one.add('z')

template byteAlphabet(makeTrie: untyped) =
    block:
        let arena = makeTrie
        let root = arena.root
        var nodes: seq[typeof(root)]
        var chain = root
        var word = ""
        for i in 0..255:
            nodes.add(root.add(char(i)))
            doAssert root.add(char(i)) == nodes[^1]
            chain = chain.add(char(i))
            word.add(char(i))
        doAssert ($chain) == word
        let values = chain.toSeq()
        for a in 0..255:
            doAssert chain[a] == char(a) and values[a] == char(a)
            doAssert ($chain.prefix(a)) == word[0..<a]
            for b in 0..255:
                doAssert nodes[a].cmp(nodes[b]) == sign(a - b)
                doAssert nodes[a].lcp(nodes[b]) == ord(a == b)
byteAlphabet(initTrieStringTable(char))
byteAlphabet(initTrieStringArray(char(0)..char(255)))

block:
    let arena = initTrieString()
    var nodes = @[arena.root]
    var words = @[""]
    for i in 0..<511:
        for c in ['a', 'b']:
            nodes.add(nodes[i].add(c))
            words.add(words[i] & c)
    for a in 0..<nodes.len:
        for b in 0..<nodes.len:
            doAssert nodes[a].cmp(nodes[b]) == sign(cmp(words[a], words[b]))
            let common = bruteLcp(words[a], words[b])
            doAssert nodes[a].lcp(nodes[b]) == common
            doAssert nodes[a].lcpNode(nodes[b]) == nodes[a].prefix(common)

for seed in [1, 17, 20261024]:
    let arena = initTrieString()
    var nodes = @[arena.root]
    var words = @[""]
    var rng = initRand(seed)
    var cursor = 0
    for i in 0..<20000:
        let p = (if i mod 3 == 0: cursor else: rng.rand(nodes.high))
        let c = char(rng.rand(255))
        let v = nodes[p].add(c)
        if v.id == nodes.len:
            nodes.add(v)
            words.add(words[p] & c)
        doAssert ($v) == words[p] & c
        doAssert nodes[p].add(c) == v and v.pop() == nodes[p]
        doAssert v.length == words[v.id].len and len(v) == words[v.id].len
        cursor = (if i mod 11 == 0: nodes[p].pop().id else: v.id)
        for q in 0..<10:
            let a = rng.rand(nodes.high)
            let b = rng.rand(nodes.high)
            doAssert nodes[a].cmp(nodes[b]) == sign(cmp(words[a], words[b]))
            doAssert nodes[a].lcp(nodes[b]) == bruteLcp(words[a], words[b])
        doAssert arena.nodeCount == nodes.len

block:
    let arrayArena = initTrieStringArray(char(0)..char(255))
    let tableArena = initTrieString()
    var aa = @[arrayArena.root]
    var tt = @[tableArena.root]
    var words = @[""]
    var rng = initRand(991)
    for i in 0..<20000:
        let p = rng.rand(words.high)
        let c = char(rng.rand(255))
        let a = aa[p].add(c)
        let b = tt[p].add(c)
        doAssert a.id == b.id
        if a.id == words.len:
            aa.add(a)
            tt.add(b)
            words.add(words[p] & c)
        doAssert aa[p].add(c) == a and a.pop() == aa[p]
        doAssert ($a) == words[a.id] and ($b) == words[b.id]
        for j in 0..<10:
            let x = rng.rand(words.high)
            let y = rng.rand(words.high)
            let expected = sign(cmp(words[x], words[y]))
            let common = bruteLcp(words[x], words[y])
            doAssert aa[x].cmp(aa[y]) == expected and tt[x].cmp(tt[y]) == expected
            doAssert aa[x].lcp(aa[y]) == common and tt[x].lcp(tt[y]) == common
    doAssert arrayArena.nodeCount == tableArena.nodeCount

const depth = 262145
template deepChains(makeTrie: untyped) =
    block:
        var arena = makeTrie
        let root = arena.root
        var left = @[root]
        var right = @[root]
        for i in 1..depth:
            left.add(left[^1].add('a'))
            right.add(right[^1].add(if i == 1: 'b' else: 'a'))
        arena = nil
        for i in 1..depth:
            doAssert left[i].pop() == left[i - 1]
            doAssert left[i].cmp(right[i]) == -1
            doAssert left[depth].cmp(left[i - 1]) == 1
            doAssert left[i].cmp(right[depth]) == -1
            doAssert left[i - 1].add('a') == left[i]
            doAssert left[i].lcp(left[i]) == i
            doAssert left[depth].lcp(left[i - 1]) == i - 1
            doAssert left[i - 1].lcp(left[depth]) == i - 1
            doAssert left[i].lcp(right[depth]) == 0
            doAssert root.lcp(left[i]) == 0 and left[i].lcp(root) == 0
        for i in countup(0, depth - 1, 127):
            let branch = left[i].add('b')
            let extension = branch.add('a')
            doAssert left[depth].cmp(branch) == -1
            doAssert left[depth].cmp(extension) == -1
            doAssert left[i].cmp(branch) == -1 and branch.cmp(extension) == -1
            doAssert left[^1].lcpNode(extension) == left[i]
            doAssert left[^1].prefix(i) == left[i]
            doAssert left[^1][i] == 'a'
        let restored = ($left[^1])
        let values = left[^1].toSeq()
        doAssert restored.len == depth and values.len == depth
        for i in 0..<depth:
            doAssert restored[i] == 'a' and values[i] == 'a'
        for i in 1..depth:
            var v = left[i].id
            var previous = 0
            var blocks = 0
            while v != 0:
                let j = root.owner.nodes[v].jump
                let weight = root.owner.nodes[v].depth - root.owner.nodes[j].depth
                doAssert (weight and (weight + 1)) == 0
                doAssert weight > previous or (blocks == 1 and weight == previous)
                previous = weight
                inc blocks
                v = j
            doAssert blocks <= 20
        for i in 0..depth:
            doAssert left[^1].prefix(i) == left[i]
deepChains(initTrieString())
deepChains(initTrieStringArray('a'..'b'))

block:
    let root = initTrieString().root
    var chain = @[root]
    for i in 1..2048:
        chain.add(chain[^1].add('a'))
    for d in 0..2048:
        for target in 0..d:
            doAssert chain[d].prefix(target) == chain[target]

template longForks(makeTrie: untyped) =
    block:
        let root = makeTrie.root
        var chain = @[root]
        for i in 1..50000:
            chain.add(chain[^1].add('a'))
        for forkDepth in [1, 2, 3, 30, 31, 32, 1023, 1024, 16383, 32767]:
            var branch = chain[forkDepth].add('b')
            for distance in 1..4097:
                if distance > 1:
                    branch = branch.add('a')
                doAssert chain[forkDepth + distance].cmp(branch) == -1
                doAssert chain[^1].cmp(branch) == -1
                doAssert branch.cmp(chain[forkDepth]) == 1
                doAssert chain[forkDepth + distance].lcp(branch) == forkDepth
                doAssert branch.lcp(chain[^1]) == forkDepth
                doAssert branch.lcpNode(chain[^1]) == chain[forkDepth]
longForks(initTrieString())
longForks(initTrieStringArray('a'..'b'))

template navigation(makeTrie: untyped) =
    block:
        let arena = makeTrie
        var nodes = @[arena.root]
        var words = @[""]
        var rng = initRand(20261101)
        for i in 1..3000:
            let p = rng.rand(nodes.high)
            let c = char(rng.rand(255))
            let node = nodes[p].add(c)
            nodes.add(node)
            words.add(words[p] & c)
            let word = words[^1]
            doAssert ($node) == word
            let values = node.toSeq()
            doAssert values.len == word.len
            for j in 0..<word.len:
                doAssert values[j] == word[j] and node[j] == word[j]
            var ancestor = node
            for j in countdown(word.len, 0):
                doAssert node.prefix(j) == ancestor
                doAssert ($ancestor) == word[0..<j]
                ancestor = ancestor.pop()
            doAssert node.prefix(word.len) == node and node.lcpNode(node) == node
            doAssert node.lcpNode(nodes[p]) == nodes[p] and nodes[p].lcpNode(node) == nodes[p]
            for q in 0..<5:
                let other = rng.rand(nodes.high)
                let common = bruteLcp(word, words[other])
                let before = arena.nodeCount
                doAssert node.lcpNode(nodes[other]) == node.prefix(common)
                doAssert ($node.lcpNode(nodes[other])) == word[0..<common]
                doAssert arena.nodeCount == before
navigation(initTrieString())
navigation(initTrieStringArray(char(0)..char(255)))

block:
    let arena = initTrieStringTable(int)
    let root = arena.root
    var bad: typeof(root)
    checkBad(bad, root, 1)
    let other = initTrieStringTable(int).root
    invalid: discard root.cmp(other)
    invalid: discard root.lcp(other)
    invalid: discard root.lcpNode(other)
    invalid: discard root == other
    var nodes = @[root]
    var words: seq[seq[int]] = @[@[]]
    var rng = initRand(701)
    for i in 1..3000:
        let p = rng.rand(nodes.high)
        let c = (if i == 1: low(int) elif i == 2: high(int) else: rng.rand(200) - 100)
        let node = nodes[p].add(c)
        nodes.add(node)
        words.add(words[p] & @[c])
        doAssert node.toSeq() == words[^1]
        for j in 0..<words[^1].len:
            doAssert node[j] == words[^1][j]
        for j in 0..words[^1].len:
            doAssert node.prefix(j).toSeq() == words[^1][0..<j]
        let other = rng.rand(nodes.high)
        var common = 0
        while common < min(words[^1].len, words[other].len) and words[^1][common] == words[other][common]:
            inc common
        doAssert node.lcpNode(nodes[other]) == node.prefix(common)
    invalid: discard nodes[^1][-1]
    invalid: discard nodes[^1][words[^1].len]
    invalid: discard nodes[^1].prefix(-1)
    invalid: discard nodes[^1].prefix(words[^1].len + 1)

type Colliding = distinct int
proc hash(x: Colliding): Hash = 0
proc `==`(a, b: Colliding): bool = int(a) == int(b)
proc `<`(a, b: Colliding): bool = int(a) < int(b)
block:
    let root = initTrieStringTable(Colliding).root
    var nodes: seq[typeof(root)]
    for i in 0..<256:
        nodes.add(root.add(Colliding(i)))
    for i in 0..<256:
        doAssert root.add(Colliding(i)) == nodes[i]
        for j in 0..<256:
            doAssert nodes[i].cmp(nodes[j]) == sign(i - j)
stderr.writeLine "PASS: typed handles, owners/lifetimes/copies, exact comparison/navigation, bytes/integers/collisions, deep growth"
echo "Hello World"
