# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/utils/offline_dynamic_queries
import cplib/collections/unionfind

proc testValues() =
    var solver = initOfflineDynamicQueries()
    var data = @[0, 0, 0]
    var counter = 0
    proc helper[T](x: var T, amount: T) =
        ## 呼び出し先の説明コメントも変換できることを確認する。
        x += amount
    proc update(a, b: var int) =
        inc a
        inc b
    proc apply(idx: int) =
        ## 適用関数の説明コメントも変換できることを確認する。
        var local = idx
        inc local
        helper(data[idx], local)
        for i in 0..<data.len:
            data[i] += 2
        update(data[0], counter)
    proc answer(idx: int) =
        doAssert data == @[@[4, 2, 2], @[7, 6, 4], @[3, 4, 2]][idx]
    solver.add(0)
    solver.output(0)
    solver.add(1)
    solver.output(1)
    solver.remove(0)
    solver.output(2)
    for repeat in 0..<2:
        solver.runAutoRollback(apply, answer)
        doAssert data == @[0, 0, 0] and counter == 0

testValues()

block:
    type ValueUnionFind = object
        parent: seq[int]
    var uf = ValueUnionFind(parent: @[-1, -1, -1, -1])
    proc root(self: ValueUnionFind, x: int): int =
        if self.parent[x] < 0: return x
        self.root(self.parent[x])
    proc size(self: ValueUnionFind, x: int): int = -self.parent[self.root(x)]
    proc unite(self: var ValueUnionFind, u, v: int) =
        var x = self.root(u)
        var y = self.root(v)
        if x == y: return
        if self.parent[x] > self.parent[y]: swap(x, y)
        self.parent[x] += self.parent[y]
        self.parent[y] = x
    var solver = initOfflineDynamicQueries((int, int))
    var disconnected = 6
    proc apply(idx: int, edge: (int, int)) =
        if uf.root(edge[0]) != uf.root(edge[1]):
            disconnected -= uf.size(edge[0]) * uf.size(edge[1])
        uf.unite(edge[0], edge[1])
    var answers: seq[int]
    proc answer(idx: int) = answers.add(disconnected)
    solver.add(0, (0, 1))
    solver.add(1, (1, 2))
    solver.output(0)
    solver.remove(0)
    solver.output(1)
    solver.remove(1)
    solver.output(2)
    solver.runAutoRollback(apply, answer)
    doAssert answers == @[3, 5, 6]
    doAssert disconnected == 6 and uf.parent == @[-1, -1, -1, -1]

block:
    type
        Box = ref object
            value: int
        Data = object
            values: seq[int]
            box: Box
    var data = Data(values: @[2, 3], box: Box(value: 7))
    var wrapped = (items: [@[11]],)
    proc read[T](values: seq[T], idx: int): T = values[idx]
    proc read(box: Box): int = box.value
    proc read(data: Data, idx: int): int = read(data.values, idx) + read(data.box)
    proc read(items: array[1, seq[int]]): int = read(items[0], 0)
    proc read(wrapped: tuple[items: array[1, seq[int]]]): int = read(wrapped.items)
    var total = 0
    var solver = initOfflineDynamicQueries()
    proc apply(idx: int) =
        total += read(data, idx) + read(wrapped)
        total += read(data.box)
    proc answer(idx: int) = doAssert total == [27, 55, 28][idx]
    solver.add(0)
    solver.output(0)
    solver.add(1)
    solver.output(1)
    solver.remove(0)
    solver.output(2)
    solver.runAutoRollback(apply, answer)
    doAssert total == 0 and data.values == @[2, 3] and data.box.value == 7

block:
    type State = object
        values: array[3, int]
        count: int
    var state: State
    var solver = initOfflineDynamicQueries(int)
    proc recurse(x: var int, depth: int) =
        if depth == 0: return
        x = x + depth
        recurse(x, depth - 1)
    proc apply(idx, value: int) =
        recurse(state.values[idx], value)
        state.count += 1
        var a = 1
        var b = 2
        swap(a, b)
        while a > 0: dec a
    proc answer(idx: int) =
        doAssert state.values[0] == [6, 0, 10][idx]
        doAssert state.count == [1, 0, 1][idx]
    solver.add(0, 3)
    solver.output(0)
    solver.remove(0)
    solver.output(1)
    solver.add(0, 4)
    solver.output(2)
    solver.runAutoRollback(apply, answer)
    doAssert state.values == [0, 0, 0] and state.count == 0

block:
    var solver = initOfflineDynamicQueries()
    var state = 7
    proc apply(idx: int) = state += 1
    proc answer(idx: int) = raise newException(ValueError, "test")
    solver.add(0)
    solver.output(0)
    try:
        solver.runAutoRollback(apply, answer)
        doAssert false
    except ValueError:
        doAssert state == 7

block:
    var solver = initOfflineDynamicQueries()
    var state = 0
    proc apply(idx: int) = discard
    proc answer(idx: int) = inc state
    solver.output(0)
    solver.add(0)
    solver.output(1)
    solver.remove(0)
    solver.output(2)
    solver.runAutoRollback(apply, answer)
    doAssert state == 3

block:
    var solver = initOfflineDynamicQueries()
    var state = 7
    proc apply(idx: int) =
        state = 10
        state = 20 div idx
    proc answer(idx: int) = discard
    solver.add(0)
    solver.output(0)
    try:
        solver.runAutoRollback(apply, answer)
        doAssert false
    except DivByZeroDefect:
        doAssert state == 7

var rng = initRand(347932)
for trial in 0..<80:
    const n = 12
    var solver = initOfflineDynamicQueries((int, int))
    var uf = initUnionFind(n)
    uf.unite(0, 1)
    var active = newSeq[bool](30)
    var edges = newSeq[(int, int)](30)
    var expected: seq[int]
    for step in 0..<200:
        if rng.rand(2) == 0:
            var labels: array[n, int]
            for i in 0..<n: labels[i] = i
            labels[1] = 0
            var count = n - 1
            for idx, edge in edges:
                if active[idx]:
                    let a = labels[edge[0]]
                    let b = labels[edge[1]]
                    if a != b:
                        dec count
                        for i in 0..<n:
                            if labels[i] == b: labels[i] = a
            solver.output(expected.len)
            expected.add(count)
        else:
            let idx = rng.rand(edges.high)
            if active[idx]:
                solver.remove(idx)
            else:
                edges[idx] = (rng.rand(n - 1), rng.rand(n - 1))
                solver.add(idx, edges[idx])
            active[idx] = not active[idx]
    proc apply(idx: int, edge: (int, int)) = uf.unite(edge[0], edge[1])
    var answered = 0
    proc answer(idx: int) =
        doAssert idx == answered
        doAssert uf.count == expected[idx]
        inc answered
    solver.runAutoRollback(apply, answer)
    doAssert answered == expected.len
    doAssert uf.count == n - 1
    doAssert uf.issame(0, 1)
    doAssert uf.siz(0) == 2
    for i in 2..<n: doAssert uf.siz(i) == 1

static:
    doAssert not compiles(block:
        type
            Box = ref object
                value: int
            Data = object
                box: Box
                values: seq[int]
        var data = Data(box: Box(), values: @[0])
        var solver = initOfflineDynamicQueries()
        proc mutate(box: Box) = inc box.value
        proc indirect(data: Data) = mutate(data.box)
        proc apply(idx: int) =
            mutate(data.box)
            indirect(data)
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        type Data = object
            values: seq[int]
        var data = Data(values: @[0])
        var solver = initOfflineDynamicQueries()
        proc resize(data: var Data) = data.values.setLen(3)
        proc apply(idx: int) = resize(data)
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        var data = @[0]
        proc apply(idx: int) = data.add(idx)
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        var data = @[0]
        proc resize() = data.setLen(3)
        proc apply(idx: int) = resize()
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        var data = @[0]
        proc apply(idx: int) = data = @[idx]
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        proc change() = discard
        var callback = change
        proc apply(idx: int) = callback()
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert compiles(block:
        var solver = initOfflineDynamicQueries()
        proc helper(x: var int) = inc x
        proc apply(idx: int) =
            var local = 0
            helper(local)
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        proc apply(idx: int) =
            var local = @[0]
            local[0] = idx
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        proc foreign() {.importc: "foreign".}
        proc apply(idx: int) = foreign()
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        var value = 0
        proc apply(idx: int) =
            let address = addr value
            address[] = idx
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        var solver = initOfflineDynamicQueries()
        var value = "abc"
        proc apply(idx: int) = value[0] = 'x'
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )
    doAssert not compiles(block:
        type Variant = object
            case flag: bool
            of true: value: int
            of false: values: seq[int]
        var state = Variant(flag: false)
        var solver = initOfflineDynamicQueries()
        proc apply(idx: int) = state.flag = true
        proc answer(idx: int) = discard
        solver.runAutoRollback(apply, answer)
    )

echo "Hello World"
