when not declared CPLIB_UTILS_ITERTOOLS:
    const CPLIB_UTILS_ITERTOOLS* = 1
    import algorithm, sequtils, options
    import cplib/graph/graph
    import cplib/tree/prufer

    iterator permutations*[T](v : seq[T]):seq[T]=
        ## pythonのitertoolsのpermutationsと同じ動作をします。
        var idxs = (0..<len(v)).toseq()
        while true:
            yield idxs.mapit(v[it])
            if not nextPermutation(idxs):
                break

    iterator distinct_permutations*[T](v : seq[T]):seq[T]=
        ## next_permutaionをするのと同じ動作をします。
        var tmp = v.sorted()
        while true:
            yield tmp
            if not nextPermutation(tmp):
                break

    template accumulated*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq)+1)
        result[0] = first
        for i in 0..<len(inner_seq):
            let
                a {.inject.} = result[i]
                b {.inject.} = inner_seq[i]
            result[i+1] = operation
        result

    template accumulated*[T](sequence:seq[T],operation:untyped):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq))
        if len(inner_seq) >= 1:
            result[0] = inner_seq[0]
        for i in 1..<len(inner_seq):
            let
                a {.inject.} = result[i-1]
                b {.inject.} = inner_seq[i]
            result[i] = operation
        result

    template accumulate*[T](sequence:var seq[T],operation:untyped)=
        for i in 1..<len(sequence):
            let
                a {.inject.} = sequence[i-1]
                b {.inject.} = sequence[i]
            sequence[i] = operation

    template accumulatedr*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq)+1)
        result[^1] = first
        for i in countdown(len(inner_seq),1,1):
            let
                a {.inject.} = inner_seq[i-1]
                b {.inject.} = result[i]
            result[i-1] = operation
        result

    template accumulatedr*[T](sequence:seq[T],operation:untyped):seq[T]=
        let inner_seq = sequence
        var result = newseq[T](len(inner_seq))
        if len(inner_seq) >= 1:
            result[^1] = inner_seq[^1]
        for i in countdown(len(inner_seq)-2,0,1):
            let
                a {.inject.} = inner_seq[i]
                b {.inject.} = result[i+1]
            result[i] = operation
        result

    template accumulater*[T](sequence:var seq[T],operation:untyped)=
        for i in countdown(len(sequence)-2,0,1):
            let
                a {.inject.} = sequence[i]
                b {.inject.} = sequence[i+1]
            sequence[i] = operation

    iterator combinations*[T](v: seq[T], r: int): seq[T] =
        let n = len(v)
        if r == 0:
            yield @[]
        elif 0 <= r and r <= n:
            var idx = newSeq[int](r)
            for i in 0..<r:
                idx[i] = i

            var x = newSeq[T](r)
            while true:
                for i in 0..<r:
                    x[i] = v[idx[i]]
                yield x

                var i = r - 1
                while i >= 0 and idx[i] == i + n - r:
                    dec i
                if i < 0:
                    break

                inc idx[i]
                for j in (i + 1)..<r:
                    idx[j] = idx[j - 1] + 1
    
    iterator combinations_withf*[T](v: openArray[T], r: int, f: proc(l, r: T): T): T =
        ## `combinations(v, r)` の各組合せを `f` で左畳み込みした値を yield する。
        ## 例: `f = proc(a,b:int):int = a*b` なら 各組合せの総積。
        ## 接頭辞畳み込みを保持し、変化のあった添字以降のみ再計算する差分更新版。
        let n = len(v)
        if r == 0:
            discard # 0 要素の組合せは畳み込み単位元が不明なので何も yield しない
        else:
            if r <= n:
                var idx = newSeq[int](r)
                var pref = newSeq[T](r)
                for i in 0..<r:
                    idx[i] = i
                pref[0] = v[0]
                for i in 1..<r:
                    pref[i] = f(pref[i - 1], v[i])
                yield pref[r - 1]
                while true:
                    var i = r - 1
                    while i >= 0 and idx[i] == i + n - r:
                        dec i
                    if i < 0:
                        break
                    inc idx[i]
                    if i == 0:
                        pref[0] = v[idx[0]]
                    else:
                        pref[i] = f(pref[i - 1], v[idx[i]])
                    for j in (i + 1)..<r:
                        idx[j] = idx[j - 1] + 1
                        pref[j] = f(pref[j - 1], v[idx[j]])
                    yield pref[r - 1]

    iterator combinations*[T](v: openArray[T], r: static[int]): array[r, T] =
        let n = len(v)
        when r == 0:
            var x: array[r, T]
            yield x
        else:
            if r <= n:
                var idx: array[r, int]
                var x: array[r, T]
                for i in 0..<r:
                    idx[i] = i
                    x[i] = v[i]
                yield x
                while true:
                    var i = r - 1
                    while i >= 0 and idx[i] == i + n - r:
                        dec i
                    if i < 0:
                        break
                    inc idx[i]
                    x[i] = v[idx[i]]
                    for j in (i + 1)..<r:
                        idx[j] = idx[j - 1] + 1
                        x[j] = v[idx[j]]
                    yield x

    iterator product*[T](v: seq[T],repeat:int):seq[T]=
        if repeat == 0:
            yield @[]
        elif v.len > 0:
            var idxs = newseq[int](repeat)
            var f = true
            while f:
                yield idxs.mapit(v[it])
                for i in 0..<repeat:
                    idxs[i] += 1
                    if idxs[i] == len(v):
                        idxs[i] = 0
                        if i == repeat-1:
                            f = false
                        continue
                    else:
                        break
    iterator partitions*(n: int): seq[int] =
        ## 分割数列挙
        if n == 0:
            yield @[]
        else:
            var a = newSeq[int](n + 1)
            var k = 1
            a[1] = n
            while k != 0:
                var x = a[k - 1] + 1
                var y = a[k] - 1
                dec k
                while x <= y:
                    a[k] = x
                    y -= x
                    inc k
                a[k] = x + y
                yield a[0 .. k]

    iterator bounded_sum_sequences*(s: int, bounds: openArray[tuple[l, r: int]]): seq[int] =
        ## 総和 s、bounds[i].l <= a[i] < bounds[i].r の数列を辞書順に列挙。
        ## 空の bounds は s == 0 のときだけ空列を返す。空の範囲は解なし。
        ## 各範囲の端点・累積和・差の計算は int に収まること。
        let n = bounds.len
        var lo = newSeq[int](n + 1)
        var hi = newSeq[int](n + 1)
        var valid = true
        for i in countdown(n - 1, 0):
            if bounds[i].l >= bounds[i].r:
                valid = false
                break
            lo[i] = lo[i + 1] + bounds[i].l
            hi[i] = hi[i + 1] + bounds[i].r - 1
        if valid and lo[0] <= s and s <= hi[0]:
            if n == 0:
                yield @[]
            else:
                var a = newSeq[int](n)
                var remaining = newSeq[int](n + 1)
                var upper = newSeq[int](n)
                remaining[0] = s
                var depth = 0
                a[0] = max(bounds[0].l, s - hi[1])
                upper[0] = min(bounds[0].r - 1, s - lo[1])
                while depth >= 0:
                    if a[depth] > upper[depth]:
                        dec depth
                        if depth >= 0: inc a[depth]
                    elif depth == n - 1:
                        yield a
                        inc a[depth]
                    else:
                        remaining[depth + 1] = remaining[depth] - a[depth]
                        inc depth
                        a[depth] = max(bounds[depth].l, remaining[depth] - hi[depth + 1])
                        upper[depth] = min(bounds[depth].r - 1, remaining[depth] - lo[depth + 1])

    iterator bounded_sum_sequences*(n, s, l, r: int): seq[int] =
        ## 長さ n、総和 s、各要素が [l, r) の数列を辞書順に列挙。
        assert n >= 0
        for a in bounded_sum_sequences(s, newSeqWith(n, (l: l, r: r))):
            yield a

    iterator monotone_sequences_impl(n, l, r, step: int, target: Option[int]): seq[int] =
        assert n >= 0
        if n == 0:
            if target.isNone or target.get == 0: yield @[]
        elif l < r and (step == 0 or n <= r - l):
            var a = newSeq[int](n)
            var prefix = newSeq[int](n + 1)
            var depth = 0
            a[0] = l
            while depth >= 0:
                let count = n - depth
                let upper = r - 1 - step * (count - 1)
                var exhausted = a[depth] > upper
                if not exhausted and target.isSome:
                    let minimum = prefix[depth] + count * a[depth] + step * (count * (count - 1) div 2)
                    let maximum = prefix[depth] + a[depth] + (count - 1) * (r - 1) - step * ((count - 1) * (count - 2) div 2)
                    if minimum > target.get:
                        exhausted = true
                    elif maximum < target.get:
                        # この接頭辞では総和が足りないので、候補を直接進める。
                        a[depth] += target.get - maximum
                        continue
                if exhausted:
                    dec depth
                    if depth >= 0: inc a[depth]
                elif depth == n - 1:
                    yield a
                    inc a[depth]
                else:
                    prefix[depth + 1] = prefix[depth] + a[depth]
                    a[depth + 1] = a[depth] + step
                    inc depth

    iterator nondecreasing_sequences*(n, l, r: int): seq[int] =
        ## 長さ n、各要素が [l, r) の広義単調増加列を辞書順に列挙。
        for a in monotone_sequences_impl(n, l, r, 0, none(int)): yield a

    iterator nondecreasing_sequences*(n, s, l, r: int): seq[int] =
        ## 総和 s を指定する版。端点・総和の中間計算は int に収まること。
        for a in monotone_sequences_impl(n, l, r, 0, some(s)): yield a

    iterator strictly_increasing_sequences*(n, l, r: int): seq[int] =
        ## 長さ n、各要素が [l, r) の狭義単調増加列を辞書順に列挙。
        for a in monotone_sequences_impl(n, l, r, 1, none(int)): yield a

    iterator strictly_increasing_sequences*(n, s, l, r: int): seq[int] =
        ## 総和 s を指定する版。端点・総和の中間計算は int に収まること。
        for a in monotone_sequences_impl(n, l, r, 1, some(s)): yield a

    iterator cartesian_product*[T](choices: openArray[seq[T]]): seq[T] =
        ## 各位置の候補から1つずつ選ぶ。右端から候補の添字を進める。
        ## 位置が0個なら空列を1件、空の候補があれば0件。候補内の重複は保持。
        let n = choices.len
        var valid = true
        for choice in choices:
            if choice.len == 0: valid = false
        if valid:
            var indices = newSeq[int](n)
            var a = newSeq[T](n)
            while true:
                for i in 0..<n: a[i] = choices[i][indices[i]]
                yield a
                var i = n - 1
                while i >= 0 and indices[i] == choices[i].len - 1:
                    indices[i] = 0
                    dec i
                if i < 0: break
                inc indices[i]

    iterator set_partitions*(n: int, k: int = -1): seq[int] =
        ## 0..<n の集合分割を所属グループ番号の列で返す。k == -1 は個数指定なし。
        ## グループ番号は初出順に 0, 1, ... とし、番号の付け替えによる重複を除く。
        assert n >= 0 and k >= -1
        if n == 0:
            if k == -1 or k == 0: yield @[]
        elif k != 0 and k <= n:
            var a = newSeq[int](n)
            var groups = newSeq[int](n + 1)
            var depth = 0
            while depth >= 0:
                var upper = groups[depth]
                if k >= 0: upper = min(upper, k - 1)
                if a[depth] > upper:
                    dec depth
                    if depth >= 0: inc a[depth]
                else:
                    groups[depth + 1] = max(groups[depth], a[depth] + 1)
                    if k >= 0 and groups[depth + 1] + n - depth - 1 < k:
                        inc a[depth]
                    elif depth == n - 1:
                        yield a
                        inc a[depth]
                    else:
                        inc depth
                        a[depth] = 0

    iterator pairings*(n: int): seq[tuple[u, v: int]] =
        ## 0..<n をペアに分ける全通り。ペア内・ペア間の順序による重複なし。
        ## n == 0 は空列を1件、奇数なら0件。
        assert n >= 0
        if n == 0:
            yield @[]
        elif n mod 2 == 0:
            var used = newSeq[bool](n)
            var pairs = newSeq[tuple[u, v: int]](n div 2)
            var depth = 0
            pairs[0] = (0, 0)
            used[0] = true
            while depth >= 0:
                inc pairs[depth].v
                while pairs[depth].v < n and used[pairs[depth].v]:
                    inc pairs[depth].v
                if pairs[depth].v == n:
                    used[pairs[depth].u] = false
                    dec depth
                    if depth >= 0: used[pairs[depth].v] = false
                elif depth == pairs.len - 1:
                    yield pairs
                else:
                    used[pairs[depth].v] = true
                    var u = 0
                    while used[u]: inc u
                    inc depth
                    pairs[depth] = (u, u)
                    used[u] = true

    iterator contiguous_partitions*(n: int, k: int = -1): seq[int] =
        ## 長さ n の列を k 個の非空連続区間に分ける境界 [0, ..., n] を返す。
        ## 区間 i は [b[i], b[i+1])。k == -1 は区間数指定なし。空列の境界は @[0]。
        assert n >= 0 and k >= -1
        if n == 0:
            if k == -1 or k == 0: yield @[0]
        elif k != 0 and k <= n:
            let first = if k == -1: 1 else: k
            let last = if k == -1: n else: k
            for count in first..last:
                for cuts in strictly_increasing_sequences(count - 1, 1, n):
                    yield @[0] & cuts & @[n]

    iterator parenthesis_sequences*(n: int): string =
        ## n 組（長さ 2*n）の正しい括弧列を辞書順に列挙。n == 0 は空文字列。
        assert n >= 0
        if n == 0:
            yield ""
        else:
            var a = newString(2 * n)
            var balance = newSeq[int](2 * n + 1)
            var choice = newSeq[int](2 * n)
            var depth = 0
            while depth >= 0:
                if choice[depth] >= 2:
                    dec depth
                else:
                    let opening = choice[depth] == 0
                    inc choice[depth]
                    if opening and (depth + balance[depth]) div 2 == n: continue
                    if not opening and balance[depth] == 0: continue
                    a[depth] = if opening: '(' else: ')'
                    balance[depth + 1] = balance[depth] + (if opening: 1 else: -1)
                    if depth == a.len - 1:
                        yield a
                    else:
                        inc depth
                        choice[depth] = 0

    iterator labeled_trees*(n: int): UnWeightedUnDirectedGraph =
        ## 頂点番号 0..<n の木を重複なく列挙。n >= 1。
        ## Prüfer 列を使用し、n >= 2 では n^(n-2) 件。
        assert n >= 1
        if n == 1:
            yield initUnWeightedUnDirectedGraph(1)
        else:
            for code in product(toSeq(0..<n), n - 2):
                yield prufer_decode(code)

    iterator simple_graphs*(n: int, m: int = -1): UnWeightedUnDirectedGraph =
        ## 頂点番号 0..<n、辺数 m の単純無向グラフ。m == -1 は辺数指定なし。
        ## 同型でも頂点番号が異なるグラフは区別する。
        assert n >= 0 and m >= -1
        var edges: seq[tuple[u, v: int]]
        for u in 0..<n:
            for v in u + 1..<n: edges.add((u, v))
        let first = if m == -1: 0 else: m
        let last = if m == -1: edges.len else: min(m, edges.len)
        for count in first..last:
            for selected in combinations(edges, count):
                var g = initUnWeightedUnDirectedGraph(n)
                for (u, v) in selected: g.add_edge(u, v)
                yield g

    iterator topological_orders*(adj: seq[seq[int]]): seq[int] =
        ## 隣接リストのトポロジカル順序を辞書順に列挙。有向閉路がある場合は0件。
        let n = adj.len
        var indegree = newSeq[int](n)
        for edges in adj:
            for v in edges:
                assert v >= 0 and v < n
                inc indegree[v]
        if n == 0:
            yield @[]
        else:
            var used = newSeq[bool](n)
            var order = newSeq[int](n)
            var next = newSeq[int](n)
            var depth = 0
            while depth >= 0:
                var u = next[depth]
                while u < n and (used[u] or indegree[u] != 0): inc u
                if u == n:
                    dec depth
                    if depth >= 0:
                        let previous = order[depth]
                        used[previous] = false
                        for v in adj[previous]: inc indegree[v]
                else:
                    next[depth] = u + 1
                    order[depth] = u
                    if depth == n - 1:
                        yield order
                    else:
                        used[u] = true
                        for v in adj[u]: dec indegree[v]
                        inc depth
                        next[depth] = 0

    iterator topological_orders*(g: DirectedGraph): seq[int] =
        ## cplib の有向グラフ版。重みは無視。静的グラフは build 済みであること。
        var adj = newSeq[seq[int]](g.len)
        for u in 0..<g.len:
            for (v, _) in g.to_and_cost(u): adj[u].add(v)
        for order in topological_orders(adj): yield order

    iterator integer_vectors_l1*(n, s: int): seq[int] =
        ## 長さ n、sum(abs(a[i])) <= s の整数列を辞書順に列挙。
        ## s < 0 は0件。s < high(int) であること。
        assert n >= 0 and s < high(int)
        if s >= 0:
            if n == 0:
                yield @[]
            else:
                var a = newSeq[int](n)
                var remaining = newSeq[int](n + 1)
                remaining[0] = s
                a[0] = -s
                var depth = 0
                while depth >= 0:
                    if a[depth] > remaining[depth]:
                        dec depth
                        if depth >= 0: inc a[depth]
                    elif depth == n - 1:
                        yield a
                        inc a[depth]
                    else:
                        remaining[depth + 1] = remaining[depth] - abs(a[depth])
                        inc depth
                        a[depth] = -remaining[depth]

    proc find_counterexample*[T, U](cases: openArray[T], solve, naive: proc(input: T): U): Option[tuple[input: T, actual, expected: U]] =
        ## 最初に solve と naive の戻り値が != となる入力と両出力を返す。
        ## 全件一致なら none。コールバックは入力を変更しないこと。
        for input in cases:
            let actual = solve(input)
            let expected = naive(input)
            if actual != expected:
                return some((input: input, actual: actual, expected: expected))

    proc find_counterexample*[T, U](cases: iterator(): T {.closure.}, solve, naive: proc(input: T): U): Option[tuple[input: T, actual, expected: U]] =
        ## closure iterator 版。入力を1件ずつ生成し、最初の不一致で中断する。
        for input in cases():
            let actual = solve(input)
            let expected = naive(input)
            if actual != expected:
                return some((input: input, actual: actual, expected: expected))

    proc shrink_counterexample*(input: seq[int], fails: proc(input: seq[int]): bool): seq[int] =
        ## fails が真の整数列を、要素削除・0への置換・0方向への移動で縮小。
        ## 移動幅は絶対値の半分から1まで半減させて試す。
        ## 変化するたびに先頭から再試行する貪欲法で、最小の反例とは限らない。
        ## fails は決定的で入力を変更しないこと。初期入力でも真であること。
        assert fails(input)
        result = input
        while true:
            var changed = false
            for i in 0..<result.len:
                let candidate = result[0..<i] & result[i + 1..<result.len]
                if fails(candidate):
                    result = candidate
                    changed = true
                    break
            if changed: continue
            for i in 0..<result.len:
                let value = result[i]
                if value == 0: continue
                var delta = value
                while delta != 0:
                    var candidate = result
                    candidate[i] = value - delta
                    if fails(candidate):
                        result = candidate
                        changed = true
                        break
                    delta = delta div 2
                if changed: break
            if not changed: break
