---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import random\nimport cplib/utils/offline_dynamic_queries\nimport cplib/collections/unionfind\n\
    \nproc testValues() =\n    var solver = initOfflineDynamicQueries()\n    var data\
    \ = @[0, 0, 0]\n    var counter = 0\n    proc helper[T](x: var T, amount: T) =\n\
    \        ## \u547C\u3073\u51FA\u3057\u5148\u306E\u8AAC\u660E\u30B3\u30E1\u30F3\
    \u30C8\u3082\u5909\u63DB\u3067\u304D\u308B\u3053\u3068\u3092\u78BA\u8A8D\u3059\
    \u308B\u3002\n        x += amount\n    proc update(a, b: var int) =\n        inc\
    \ a\n        inc b\n    proc apply(idx: int) =\n        ## \u9069\u7528\u95A2\u6570\
    \u306E\u8AAC\u660E\u30B3\u30E1\u30F3\u30C8\u3082\u5909\u63DB\u3067\u304D\u308B\
    \u3053\u3068\u3092\u78BA\u8A8D\u3059\u308B\u3002\n        var local = idx\n  \
    \      inc local\n        helper(data[idx], local)\n        for i in 0..<data.len:\n\
    \            data[i] += 2\n        update(data[0], counter)\n    proc answer(idx:\
    \ int) =\n        doAssert data == @[@[4, 2, 2], @[7, 6, 4], @[3, 4, 2]][idx]\n\
    \    solver.add(0)\n    solver.output(0)\n    solver.add(1)\n    solver.output(1)\n\
    \    solver.remove(0)\n    solver.output(2)\n    for repeat in 0..<2:\n      \
    \  solver.runAutoRollback(apply, answer)\n        doAssert data == @[0, 0, 0]\
    \ and counter == 0\n\ntestValues()\n\nblock:\n    type ValueUnionFind = object\n\
    \        parent: seq[int]\n    var uf = ValueUnionFind(parent: @[-1, -1, -1, -1])\n\
    \    proc root(self: ValueUnionFind, x: int): int =\n        if self.parent[x]\
    \ < 0: return x\n        self.root(self.parent[x])\n    proc size(self: ValueUnionFind,\
    \ x: int): int = -self.parent[self.root(x)]\n    proc unite(self: var ValueUnionFind,\
    \ u, v: int) =\n        var x = self.root(u)\n        var y = self.root(v)\n \
    \       if x == y: return\n        if self.parent[x] > self.parent[y]: swap(x,\
    \ y)\n        self.parent[x] += self.parent[y]\n        self.parent[y] = x\n \
    \   var solver = initOfflineDynamicQueries((int, int))\n    var disconnected =\
    \ 6\n    proc apply(idx: int, edge: (int, int)) =\n        if uf.root(edge[0])\
    \ != uf.root(edge[1]):\n            disconnected -= uf.size(edge[0]) * uf.size(edge[1])\n\
    \        uf.unite(edge[0], edge[1])\n    var answers: seq[int]\n    proc answer(idx:\
    \ int) = answers.add(disconnected)\n    solver.add(0, (0, 1))\n    solver.add(1,\
    \ (1, 2))\n    solver.output(0)\n    solver.remove(0)\n    solver.output(1)\n\
    \    solver.remove(1)\n    solver.output(2)\n    solver.runAutoRollback(apply,\
    \ answer)\n    doAssert answers == @[3, 5, 6]\n    doAssert disconnected == 6\
    \ and uf.parent == @[-1, -1, -1, -1]\n\nblock:\n    type\n        Box = ref object\n\
    \            value: int\n        Data = object\n            values: seq[int]\n\
    \            box: Box\n    var data = Data(values: @[2, 3], box: Box(value: 7))\n\
    \    var wrapped = (items: [@[11]],)\n    proc read[T](values: seq[T], idx: int):\
    \ T = values[idx]\n    proc read(box: Box): int = box.value\n    proc read(data:\
    \ Data, idx: int): int = read(data.values, idx) + read(data.box)\n    proc read(items:\
    \ array[1, seq[int]]): int = read(items[0], 0)\n    proc read(wrapped: tuple[items:\
    \ array[1, seq[int]]]): int = read(wrapped.items)\n    var total = 0\n    var\
    \ solver = initOfflineDynamicQueries()\n    proc apply(idx: int) =\n        total\
    \ += read(data, idx) + read(wrapped)\n        total += read(data.box)\n    proc\
    \ answer(idx: int) = doAssert total == [27, 55, 28][idx]\n    solver.add(0)\n\
    \    solver.output(0)\n    solver.add(1)\n    solver.output(1)\n    solver.remove(0)\n\
    \    solver.output(2)\n    solver.runAutoRollback(apply, answer)\n    doAssert\
    \ total == 0 and data.values == @[2, 3] and data.box.value == 7\n\nblock:\n  \
    \  type State = object\n        values: array[3, int]\n        count: int\n  \
    \  var state: State\n    var solver = initOfflineDynamicQueries(int)\n    proc\
    \ recurse(x: var int, depth: int) =\n        if depth == 0: return\n        x\
    \ = x + depth\n        recurse(x, depth - 1)\n    proc apply(idx, value: int)\
    \ =\n        recurse(state.values[idx], value)\n        state.count += 1\n   \
    \     var a = 1\n        var b = 2\n        swap(a, b)\n        while a > 0: dec\
    \ a\n    proc answer(idx: int) =\n        doAssert state.values[0] == [6, 0, 10][idx]\n\
    \        doAssert state.count == [1, 0, 1][idx]\n    solver.add(0, 3)\n    solver.output(0)\n\
    \    solver.remove(0)\n    solver.output(1)\n    solver.add(0, 4)\n    solver.output(2)\n\
    \    solver.runAutoRollback(apply, answer)\n    doAssert state.values == [0, 0,\
    \ 0] and state.count == 0\n\nblock:\n    var solver = initOfflineDynamicQueries()\n\
    \    var state = 7\n    proc apply(idx: int) = state += 1\n    proc answer(idx:\
    \ int) = raise newException(ValueError, \"test\")\n    solver.add(0)\n    solver.output(0)\n\
    \    try:\n        solver.runAutoRollback(apply, answer)\n        doAssert false\n\
    \    except ValueError:\n        doAssert state == 7\n\nblock:\n    var solver\
    \ = initOfflineDynamicQueries()\n    var state = 0\n    proc apply(idx: int) =\
    \ discard\n    proc answer(idx: int) = inc state\n    solver.output(0)\n    solver.add(0)\n\
    \    solver.output(1)\n    solver.remove(0)\n    solver.output(2)\n    solver.runAutoRollback(apply,\
    \ answer)\n    doAssert state == 3\n\nblock:\n    var solver = initOfflineDynamicQueries()\n\
    \    var state = 7\n    proc apply(idx: int) =\n        state = 10\n        state\
    \ = 20 div idx\n    proc answer(idx: int) = discard\n    solver.add(0)\n    solver.output(0)\n\
    \    try:\n        solver.runAutoRollback(apply, answer)\n        doAssert false\n\
    \    except DivByZeroDefect:\n        doAssert state == 7\n\nvar rng = initRand(347932)\n\
    for trial in 0..<80:\n    const n = 12\n    var solver = initOfflineDynamicQueries((int,\
    \ int))\n    var uf = initUnionFind(n)\n    uf.unite(0, 1)\n    var active = newSeq[bool](30)\n\
    \    var edges = newSeq[(int, int)](30)\n    var expected: seq[int]\n    for step\
    \ in 0..<200:\n        if rng.rand(2) == 0:\n            var labels: array[n,\
    \ int]\n            for i in 0..<n: labels[i] = i\n            labels[1] = 0\n\
    \            var count = n - 1\n            for idx, edge in edges:\n        \
    \        if active[idx]:\n                    let a = labels[edge[0]]\n      \
    \              let b = labels[edge[1]]\n                    if a != b:\n     \
    \                   dec count\n                        for i in 0..<n:\n     \
    \                       if labels[i] == b: labels[i] = a\n            solver.output(expected.len)\n\
    \            expected.add(count)\n        else:\n            let idx = rng.rand(edges.high)\n\
    \            if active[idx]:\n                solver.remove(idx)\n           \
    \ else:\n                edges[idx] = (rng.rand(n - 1), rng.rand(n - 1))\n   \
    \             solver.add(idx, edges[idx])\n            active[idx] = not active[idx]\n\
    \    proc apply(idx: int, edge: (int, int)) = uf.unite(edge[0], edge[1])\n   \
    \ var answered = 0\n    proc answer(idx: int) =\n        doAssert idx == answered\n\
    \        doAssert uf.count == expected[idx]\n        inc answered\n    solver.runAutoRollback(apply,\
    \ answer)\n    doAssert answered == expected.len\n    doAssert uf.count == n -\
    \ 1\n    doAssert uf.issame(0, 1)\n    doAssert uf.siz(0) == 2\n    for i in 2..<n:\
    \ doAssert uf.siz(i) == 1\n\nstatic:\n    doAssert not compiles(block:\n     \
    \   type\n            Box = ref object\n                value: int\n         \
    \   Data = object\n                box: Box\n                values: seq[int]\n\
    \        var data = Data(box: Box(), values: @[0])\n        var solver = initOfflineDynamicQueries()\n\
    \        proc mutate(box: Box) = inc box.value\n        proc indirect(data: Data)\
    \ = mutate(data.box)\n        proc apply(idx: int) =\n            mutate(data.box)\n\
    \            indirect(data)\n        proc answer(idx: int) = discard\n       \
    \ solver.runAutoRollback(apply, answer)\n    )\n    doAssert not compiles(block:\n\
    \        type Data = object\n            values: seq[int]\n        var data =\
    \ Data(values: @[0])\n        var solver = initOfflineDynamicQueries()\n     \
    \   proc resize(data: var Data) = data.values.setLen(3)\n        proc apply(idx:\
    \ int) = resize(data)\n        proc answer(idx: int) = discard\n        solver.runAutoRollback(apply,\
    \ answer)\n    )\n    doAssert not compiles(block:\n        var solver = initOfflineDynamicQueries()\n\
    \        var data = @[0]\n        proc apply(idx: int) = data.add(idx)\n     \
    \   proc answer(idx: int) = discard\n        solver.runAutoRollback(apply, answer)\n\
    \    )\n    doAssert not compiles(block:\n        var solver = initOfflineDynamicQueries()\n\
    \        var data = @[0]\n        proc resize() = data.setLen(3)\n        proc\
    \ apply(idx: int) = resize()\n        proc answer(idx: int) = discard\n      \
    \  solver.runAutoRollback(apply, answer)\n    )\n    doAssert not compiles(block:\n\
    \        var solver = initOfflineDynamicQueries()\n        var data = @[0]\n \
    \       proc apply(idx: int) = data = @[idx]\n        proc answer(idx: int) =\
    \ discard\n        solver.runAutoRollback(apply, answer)\n    )\n    doAssert\
    \ not compiles(block:\n        var solver = initOfflineDynamicQueries()\n    \
    \    proc change() = discard\n        var callback = change\n        proc apply(idx:\
    \ int) = callback()\n        proc answer(idx: int) = discard\n        solver.runAutoRollback(apply,\
    \ answer)\n    )\n    doAssert compiles(block:\n        var solver = initOfflineDynamicQueries()\n\
    \        proc helper(x: var int) = inc x\n        proc apply(idx: int) =\n   \
    \         var local = 0\n            helper(local)\n        proc answer(idx: int)\
    \ = discard\n        solver.runAutoRollback(apply, answer)\n    )\n    doAssert\
    \ not compiles(block:\n        var solver = initOfflineDynamicQueries()\n    \
    \    proc apply(idx: int) =\n            var local = @[0]\n            local[0]\
    \ = idx\n        proc answer(idx: int) = discard\n        solver.runAutoRollback(apply,\
    \ answer)\n    )\n    doAssert not compiles(block:\n        var solver = initOfflineDynamicQueries()\n\
    \        proc foreign() {.importc: \"foreign\".}\n        proc apply(idx: int)\
    \ = foreign()\n        proc answer(idx: int) = discard\n        solver.runAutoRollback(apply,\
    \ answer)\n    )\n    doAssert not compiles(block:\n        var solver = initOfflineDynamicQueries()\n\
    \        var value = 0\n        proc apply(idx: int) =\n            let address\
    \ = addr value\n            address[] = idx\n        proc answer(idx: int) = discard\n\
    \        solver.runAutoRollback(apply, answer)\n    )\n    doAssert not compiles(block:\n\
    \        var solver = initOfflineDynamicQueries()\n        var value = \"abc\"\
    \n        proc apply(idx: int) = value[0] = 'x'\n        proc answer(idx: int)\
    \ = discard\n        solver.runAutoRollback(apply, answer)\n    )\n    doAssert\
    \ not compiles(block:\n        type Variant = object\n            case flag: bool\n\
    \            of true: value: int\n            of false: values: seq[int]\n   \
    \     var state = Variant(flag: false)\n        var solver = initOfflineDynamicQueries()\n\
    \        proc apply(idx: int) = state.flag = true\n        proc answer(idx: int)\
    \ = discard\n        solver.runAutoRollback(apply, answer)\n    )\n\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: true
  path: verify/AI/auto_rollback_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/auto_rollback_test.nim
layout: document
redirect_from:
- /verify/verify/AI/auto_rollback_test.nim
- /verify/verify/AI/auto_rollback_test.nim.html
title: verify/AI/auto_rollback_test.nim
---
