# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm, sequtils, strutils
import cplib/collections/range_reverse_lazysegtree

type Action = object
    a, b: int

proc `==`(f, g: Action): bool {.error: "作用型の等値比較を要求してはいけません".}
const P = 17
const Identity = Action(a: 1, b: 0)

proc concat(x, y: string): string =
    ## 順序を区別する文字列モノイド。
    x & y

proc mapping(f: Action, x: string): string =
    ## 各文字へ法17のアフィン変換を作用させる。
    result = newString(x.len)
    for i, c in x:
        result[i] = char(ord('a') + (f.a * (ord(c) - ord('a')) + f.b) mod P)

proc composition(f, g: Action): Action =
    ## gの後にfを作用させる。作用の合成は非可換。
    Action(a: f.a * g.a mod P, b: (f.a * g.b + f.b) mod P)

proc oracleApply(values: var seq[string], l, r: int, f: Action) =
    ## 木のmapping/compositionを使わない逐次計算。
    for i in l..<r:
        for j in 0..<values[i].len:
            let old = ord(values[i][j]) - ord('a')
            values[i][j] = char(ord('a') + (old * f.a + f.b) mod 17)

proc oracleRange(values: seq[string], l, r: int): string =
    ## 左から順に文字を連結する。
    for i in l..<r: result.add(values[i])

proc verify(tree: RangeReverseLazySegmentTree[string, Action], values: seq[string], exhaustive = false) =
    ## 部分区間・添字・非可換な探索条件を独立な列と比較する。
    doAssert tree.len == values.len
    doAssert tree.get_all == oracleRange(values, 0, values.len)
    doAssert tree.fold == oracleRange(values, 0, values.len)
    if not exhaustive: return
    for boundary in 0..values.len:
        doAssert tree.get(boundary, boundary) == ""
        doAssert tree.fold(boundary..<boundary) == ""
    for i in 0..<values.len:
        doAssert tree.get(i) == values[i]
        doAssert tree[i] == values[i]
        doAssert tree[^(values.len - i)] == values[i]
    for l in 0..values.len:
        for r in l..values.len:
            let target = oracleRange(values, l, r)
            doAssert tree.get(l, r) == target
            doAssert tree.get(l..<r) == target
            doAssert tree[l..<r] == target
            doAssert tree.fold(l, r) == target
            # 各要素は非空なので、prefix/suffixが成立する最終境界は一意。
            if values.allIt(it.len > 0):
                doAssert tree.max_right(l, proc(x: string): bool = target.startsWith(x)) == r
                doAssert tree.min_left(r, proc(x: string): bool = target.endsWith(x)) == l
    doAssert tree.toSeq == values
    var iterated: seq[string]
    for x in tree.items: iterated.add(x)
    doAssert iterated == values
    doAssert $tree == values.join(" ")

randomize(918273)

# 空・単点・同一境界・端への挿入と、保留中の作用に続く代入を確認する。
block:
    var values: seq[string]
    let tree = initRangeReverseLazySegmentTree(values, concat, "", mapping, composition, Identity)
    verify(tree, values, true)
    doAssert tree.max_right(0, proc(x: string): bool = x.len <= 0) == 0
    doAssert tree.min_left(0, proc(x: string): bool = x.len <= 0) == 0
    tree.apply(0..<0, Action(a: 0, b: 8))
    tree.reverse(0..<0)
    tree.erase(0..<0)
    tree.insert(0, "b")
    values.add("b")
    tree.apply(0, 1, Action(a: 2, b: 3))
    oracleApply(values, 0, 1, Action(a: 2, b: 3))
    tree.apply(0..0, Action(a: 3, b: 1))
    oracleApply(values, 0, 1, Action(a: 3, b: 1))
    tree.reverse(0..0)
    tree[^1] = "q"
    values[0] = "q"
    tree.insert(0, "c")
    values.insert("c", 0)
    tree.insert(tree.len, "d")
    values.add("d")
    verify(tree, values, true)
    tree.erase(0..tree.len - 1)
    values.setLen(0)
    verify(tree, values, true)

# 全区間作用・反転を保留したまま各境界へ挿入・削除・代入する。
for boundary in 0..12:
    var values = (0..<12).toSeq.mapIt($char(ord('a') + it))
    let tree = initRangeReverseLazySegmentTree(values, concat, "", mapping, composition, Identity)
    tree.apply(0, 12, Action(a: 2, b: 3))
    oracleApply(values, 0, 12, Action(a: 2, b: 3))
    tree.apply(0, 12, Action(a: 3, b: 1))
    oracleApply(values, 0, 12, Action(a: 3, b: 1))
    tree.reverse(0, 12)
    values.reverse()
    tree.insert(boundary, "abc")
    values.insert("abc", boundary)
    tree.apply(0, tree.len, Action(a: 4, b: 6))
    oracleApply(values, 0, values.len, Action(a: 4, b: 6))
    tree.update(Natural(boundary), "pq")
    values[boundary] = "pq"
    tree.apply(boundary, Action(a: 0, b: 9))
    oracleApply(values, boundary, boundary + 1, Action(a: 0, b: 9))
    tree.reverse(0, tree.len)
    values.reverse()
    tree.erase(12 - boundary)
    values.delete(12 - boundary)
    verify(tree, values, true)

# 多数の混合操作。全要素を読む間隔をあけ、遅延状態を持続させる。
for seed in 0..<8:
    var rng = initRand(3456 + seed)
    var values: seq[string]
    let tree = initRangeReverseLazySegmentTree(values, concat, "", mapping, composition, Identity)
    for step in 0..<1500:
        let n = values.len
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let f = Action(a: rng.rand(0..16), b: rng.rand(0..16))
        case rng.rand(0..9)
        of 0, 1:
            if n < 40:
                let value = $char(ord('a') + rng.rand(0..16))
                tree.insert(l, value)
                values.insert(value, l)
        of 2:
            tree.erase(l..<r)
            values = values[0..<l] & values[r..<n]
        of 3, 4:
            tree.apply(l..<r, f)
            oracleApply(values, l, r, f)
        of 5:
            tree.reverse(l..<r)
            if l < r: values.reverse(l, r - 1)
        of 6:
            if l < n:
                let value = $char(ord('a') + rng.rand(0..16))
                tree[l] = value
                values[l] = value
        of 7:
            if l < n:
                tree.erase(l)
                values.delete(l)
        of 8:
            doAssert tree.get(l, r) == oracleRange(values, l, r)
        else:
            tree.apply(0, n, f)
            oracleApply(values, 0, n, f)
        verify(tree, values, step mod 137 == 0)
    verify(tree, values, true)

# 個数初期化は各要素を単位元で作り、templateは式と作用型を維持する。
block:
    let tree = initRangeReverseLazySegmentTree[string, Action](5, concat, "", mapping, composition, Identity)
    doAssert tree.toSeq == newSeq[string](5)
    tree.apply(0, 5, Action(a: 2, b: 3))
    tree.reverse(0, 5)
    for i in 0..<5: tree[i] = $char(ord('a') + i)
    verify(tree, @["a", "b", "c", "d", "e"], true)
    let zero = initRangeReverseLazySegmentTree[string, Action](0, concat, "", mapping, composition, Identity)
    verify(zero, newSeq[string](), true)
block:
    let tree = newRangeReverseLazySegWith(@["a", "b", "c"], l & r, "", mapping(f, x), composition(f, g), Identity)
    tree.apply(0, 3, Action(a: 2, b: 3))
    var values = @["a", "b", "c"]
    oracleApply(values, 0, 3, Action(a: 2, b: 3))
    verify(tree, values, true)
block:
    let tree = newRangeReverseLazySegWith(2, l & r, "", mapping(f, x), composition(f, g), Identity)
    tree[^1] = "b"
    tree[0] = "a"
    verify(tree, @["a", "b"], true)

echo "Hello World"
