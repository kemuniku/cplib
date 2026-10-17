# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random
import cplib/collections/persistent_sequence
import cplib/collections/persistent_multiset

type
    Payload = ref object
        text: string
    Action = ref object
        table: array[3, char]

proc product(a, b: Payload): Payload = Payload(text: a.text & b.text)
proc mapped(f: Action, x: Payload): Payload =
    result = Payload()
    for ch in x.text: result.text.add(f.table[ord(ch) - ord('a')])
proc aggregate(f: Action, x: Payload, length: int): Payload = mapped(f, x)
proc composed(f, g: Action): Action =
    result = Action()
    for i in 0..2: result.table[i] = f.table[ord(g.table[i]) - ord('a')]

let identity = Action(table: ['a', 'b', 'c'])
let actions = @[identity, Action(table: ['b', 'a', 'c']), Action(table: ['a', 'c', 'b'])]
var input = @[Payload(text: "ab"), Payload(text: "c"), Payload(text: ""), Payload(text: "ba")]
let original = initPersistentLazySequence(input, product, Payload(), mapped, aggregate, composed, identity)
input[0] = Payload(text: "cc")
var versions = @[original]
var expected = @[@["ab", "c", "", "ba"]]
var rng = initRand(1030677)
for step in 0..<700:
    let source = rng.rand(versions.high)
    let old = versions[source]
    let before = @(expected[source])
    var values = @(before)
    var current = old
    let l = rng.rand(values.len)
    let r = rng.rand(l..values.len)
    case step mod 7
    of 0:
        let f = actions[rng.rand(actions.high)]
        current = old.apply(l, r, f)
        for i in l..<r: values[i] = mapped(f, Payload(text: values[i])).text
    of 1:
        current = old.reverse(l, r)
        if l < r: values.reverse(l, r - 1)
    of 2:
        current = old.insert(l, Payload(text: "abc"))
        values.insert("abc", l)
    of 3:
        if values.len > 0:
            let k = rng.rand(values.high)
            current = old.erase(k)
            values.delete(k)
    of 4:
        let parts = old.split(l)
        current = parts.right.concat(parts.left)
        values = values[l..<values.len] & values[0..<l]
    of 5:
        current = old.slice(l, r).concat(old.slice(l, r))
        values = values[l..<r] & values[l..<r]
    else:
        if values.len > 0:
            let k = rng.rand(values.high)
            current = old.update(k, Payload(text: "cb"))
            values[k] = "cb"
    if values.len > 40:
        current = current.slice(0, 40)
        values.setLen(40)
    versions.add(current)
    expected.add(values)
    for k in [source, versions.high]:
        doAssert versions[k].len == expected[k].len
        let actual = versions[k].to_seq
        for i in 0..<actual.len:
            doAssert actual[i].text == expected[k][i]
            doAssert versions[k][i].text == expected[k][i]
        for a in 0..actual.len:
            var text = ""
            for b in a..actual.len:
                doAssert versions[k].prod(a, b).text == text
                if b < actual.len: text.add(expected[k][b])
    if step mod 100 == 0:
        when declared(GC_fullCollect): GC_fullCollect()
for k in 0..<versions.len:
    let actual = versions[k].to_seq
    var text = ""
    for i, x in actual:
        doAssert x.text == expected[k][i]
        doAssert versions[k][i].text == expected[k][i]
        text.add(expected[k][i])
    doAssert versions[k].prod(0, actual.len).text == text

proc retained(): PersistentSequence[Payload, Action] =
    let local = initPersistentLazySequence(@[Payload(text: "ab"), Payload(text: "c")],
        product, Payload(), mapped, aggregate, composed, identity)
    let part = local.apply(0, 2, actions[1]).reverse(0, 2).slice(0, 2)
    part.concat(part)
block:
    let survivor = retained()
    when declared(GC_fullCollect): GC_fullCollect()
    doAssert survivor.prod(0, 4).text == "cbacba"

block:
    type Item = tuple[key, payload: int]
    let values = @[(1, 10), (1, 11), (2, 20), (2, 21)]
    let byKey = initPersistentMultiset(values, proc(a, b: Item): int = cmp(a.key, b.key))
    doAssert byKey.to_seq == values
    let changed = byKey.insert((1, 12)).erase((2, 99))
    doAssert changed.to_seq == @[(1, 10), (1, 11), (1, 12), (2, 21)]
    doAssert byKey.to_seq == values
    let descending = initPersistentMultiset(@[(2, 20), (2, 21), (1, 10), (1, 11)], proc(a, b: Item): int = cmp(b.key, a.key))
    doAssert descending.to_seq == @[(2, 20), (2, 21), (1, 10), (1, 11)]

echo "Hello World"
