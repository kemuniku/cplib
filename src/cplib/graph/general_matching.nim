## 一般無向グラフの最大マッチング（Gabow法）。
##
## 最短増加路の長さを双対変数と時刻バケットで求め、その長さの
## 頂点素な増加路を極大になるまでまとめて反転する。
## 各段階はO(V+E)、段階数はO(sqrt V)。孤立点は探索前に除く。
## 参考: https://arxiv.org/abs/1703.03998
##
## 花の縮約には、葉を追加できる木上の集合併合を使う。
## b=Theta(log V)頂点以下の小木を保持し、祖先と未併合頂点を
## それぞれ機械語のビットマスクで表す。小木内の問い合わせはO(1)。
## 満杯になった小木は両側がb/4以上になるようO(b)で分割するため、
## 葉の追加は償却O(1)、小木境界の総数はO(V/b)。
## 境界だけの集合は小さい側の所属先を直接更新する。
## 問い合わせはO(1)、全更新はO((V/b) log V)=O(V)で、
## 通常のUnion-Findによる逆Ackermann関数の追加因子を避けている。
when not declared CPLIB_GRAPH_GENERAL_MATCHING:
    const CPLIB_GRAPH_GENERAL_MATCHING* = 1
    import bitops
    import cplib/graph/graph

    type
        MatchingMicroTree = object
            vertices: seq[int]
            outside: int
            live: uint64
        MatchingTreeUnion = object
            limit: int
            parent, depth, blockId, position: seq[int]
            ancestors: seq[uint64]
            inserted, deleted: seq[bool]
            blocks: seq[MatchingMicroTree]
            representative, size, first, last, next, top: seq[int]

    proc initMatchingTreeUnion(n: int): MatchingTreeUnion =
        ## 葉の追加と親への併合を扱う。全操作でO(n+操作数)、領域O(n)。
        result.limit = max(8, fastLog2(uint64(max(n, 2))) + 1)
        result.parent = newSeq[int](n)
        result.depth = newSeq[int](n)
        result.blockId = newSeq[int](n)
        result.position = newSeq[int](n)
        result.ancestors = newSeq[uint64](n)
        result.inserted = newSeq[bool](n)
        result.deleted = newSeq[bool](n)
        result.representative = newSeq[int](n)
        result.size = newSeq[int](n)
        result.first = newSeq[int](n)
        result.last = newSeq[int](n)
        result.next = newSeq[int](n)
        result.top = newSeq[int](n)
        result.blocks = @[MatchingMicroTree(vertices: @[0], outside: 0, live: 1)]
        result.inserted[0] = true
        result.ancestors[0] = 1

    proc microRoot(t: MatchingTreeUnion, v: int): int =
        ## 同じ小木内の未併合な最寄り祖先を求める。O(1)。
        let b = t.blockId[v]
        let mask = t.ancestors[v] and t.blocks[b].live
        if mask == 0: t.blocks[b].outside
        else: t.blocks[b].vertices[fastLog2(mask)]

    proc makeMacro(t: var MatchingTreeUnion, v: int) =
        ## 小木境界を大域的な併合の対象に登録する。O(1)。
        if t.size[v] != 0: return
        t.representative[v] = v
        t.size[v] = 1
        t.first[v] = v
        t.last[v] = v
        t.next[v] = -1
        t.top[v] = v

    proc mergeMacro(t: var MatchingTreeUnion, u, v: int) =
        ## 小さい集合の所属先を更新する。全併合でO((n/b) log n)。
        var a = t.representative[u]
        var b = t.representative[v]
        if a == b: return
        if t.size[a] < t.size[b]: swap(a, b)
        var x = t.first[b]
        while x != -1:
            t.representative[x] = a
            x = t.next[x]
        t.next[t.last[a]] = t.first[b]
        t.last[a] = t.last[b]
        t.size[a] += t.size[b]
        if t.depth[t.top[b]] < t.depth[t.top[a]]:
            t.top[a] = t.top[b]

    proc root(t: var MatchingTreeUnion, v: int): int =
        ## 未併合な最寄り祖先を求める。全問い合わせと併合でO(n+操作数)。
        if not t.inserted[v]: return v
        var x = v
        result = t.microRoot(x)
        if t.blockId[x] == t.blockId[result]: return
        x = t.top[t.representative[result]]
        while true:
            result = t.microRoot(x)
            if t.blockId[x] == t.blockId[result]: return
            t.mergeMacro(result, x)
            x = t.top[t.representative[result]]

    proc rebuildBlock(t: var MatchingTreeUnion, b: int, vertices: seq[int], outside: int) =
        ## 分割後の小木の祖先マスクを再構築する。O(b)。
        t.blocks[b] = MatchingMicroTree(vertices: vertices, outside: outside)
        for i, v in vertices:
            t.blockId[v] = b
            t.position[v] = i
        for i, v in vertices:
            let bit = 1'u64 shl i
            t.ancestors[v] = bit
            if v != 0 and t.blockId[t.parent[v]] == b:
                t.ancestors[v] = t.ancestors[v] or t.ancestors[t.parent[v]]
            if not t.deleted[v]: t.blocks[b].live = t.blocks[b].live or bit

    proc splitBlock(t: var MatchingTreeUnion, b: int) =
        ## 満杯の小木を大きさb/4以上の二つに分割する。O(b)。
        let vertices = t.blocks[b].vertices
        let count = vertices.len
        let outside = t.blocks[b].outside
        var sizes = newSeq[int](count)
        for i in countdown(count - 1, 0):
            inc sizes[i]
            let v = vertices[i]
            if v != 0 and t.blockId[t.parent[v]] == b:
                sizes[t.position[t.parent[v]]] += sizes[i]
        var pivot = outside
        for i, v in vertices:
            if sizes[i] * 2 >= count: pivot = v
        var selected = 0'u64
        var total = 0
        for i, v in vertices:
            if v != 0 and t.parent[v] == pivot and total * 4 < count:
                selected = selected or (1'u64 shl i)
                total += sizes[i]
        var left, right: seq[int]
        for i, v in vertices:
            if (t.ancestors[v] and selected) != 0: right.add(v)
            else: left.add(v)
        assert left.len > 0 and right.len > 0, "併合する両方の列は空でない必要があります"
        let nb = t.blocks.len
        t.blocks.add(MatchingMicroTree())
        # 所属先を先に更新し、境界をまたぐ祖先マスクを混ぜない。
        for v in right: t.blockId[v] = nb
        t.rebuildBlock(b, left, outside)
        t.rebuildBlock(nb, right, pivot)
        t.makeMacro(pivot)

    proc grow(t: var MatchingTreeUnion, parent, v: int) =
        ## 木に葉を追加する。分割を含めて償却O(1)。
        assert not t.inserted[v] and t.inserted[parent], "追加する頂点は未登録で、親頂点は登録済みである必要があります"
        t.inserted[v] = true
        t.parent[v] = parent
        t.depth[v] = t.depth[parent] + 1
        let b = t.blockId[parent]
        let i = t.blocks[b].vertices.len
        t.blockId[v] = b
        t.position[v] = i
        t.ancestors[v] = t.ancestors[parent] or (1'u64 shl i)
        t.blocks[b].vertices.add(v)
        t.blocks[b].live = t.blocks[b].live or (1'u64 shl i)
        if i + 1 == t.limit: t.splitBlock(b)

    proc joinParent(t: var MatchingTreeUnion, v: int) =
        ## 頂点の集合を親の集合へ併合する。O(1)。
        assert v != 0 and t.inserted[v], "対象の頂点は0以外の登録済み頂点である必要があります"
        t.deleted[v] = true
        let b = t.blockId[v]
        t.blocks[b].live = t.blocks[b].live and not (1'u64 shl t.position[v])

    type
        MatchingSearch = object
            n, time, deadline, stamp, order, saved: int
            graph: seq[seq[int]]
            mate, potential, label, initial: seq[int]
            link: seq[tuple[u, v: int]]
            queue: seq[int]
            head: int
            events: seq[seq[tuple[u, v: int]]]
            contractions: seq[tuple[v, base: int]]
            members: seq[seq[int]]
            tree: MatchingTreeUnion

    proc base(s: var MatchingSearch, v: int): int =
        ## 正の双対値を持つ花と探索中の花を縮約した基点を返す。
        s.tree.root(s.initial[v])

    proc extend(s: var MatchingSearch, x, y: int) =
        ## 交互木を非マッチ辺とマッチ辺の一組だけ伸ばす。
        let z = s.mate[y]
        s.tree.grow(x, y)
        s.tree.grow(y, z)
        s.label[y] = -1
        s.potential[y] = s.time
        s.link[z] = (x, y)
        s.label[z] = s.label[x]
        s.potential[z] = s.time + 1
        s.queue.add(z)

    proc contract(s: var MatchingSearch, x, y: int) =
        ## 交互木内の奇閉路を縮約する。走査する頂点数に比例する時間。
        var a = s.base(x)
        var b = s.base(y)
        dec s.stamp
        s.label[s.mate[a]] = s.stamp
        s.label[s.mate[b]] = s.stamp
        while true:
            if s.mate[b] != 0: swap(a, b)
            a = s.base(s.link[a].u)
            if s.label[s.mate[a]] == s.stamp: break
            s.label[s.mate[a]] = s.stamp
        let ancestor = a
        for endpoint in [x, y]:
            var v = s.base(endpoint)
            while v != ancestor:
                let w = s.mate[v]
                let parent = s.base(s.link[v].u)
                s.link[w] = (x, y)
                s.label[w] = s.label[x]
                s.potential[w] = 1 + 2 * s.time - s.potential[w]
                s.queue.add(w)
                s.tree.joinParent(v)
                s.tree.joinParent(w)
                s.contractions.add((v, ancestor))
                s.contractions.add((w, ancestor))
                v = parent

    proc shortest(s: var MatchingSearch): bool =
        ## 双対変数の更新を時刻バケットで処理し、最短増加路を探す。O(V+E)。
        s.time = 0
        s.deadline = s.n + 1
        s.stamp = -1
        s.saved = 0
        s.queue.setLen(0)
        s.head = 0
        s.contractions.setLen(0)
        s.tree = initMatchingTreeUnion(s.n + 1)
        for u in 0..s.n:
            s.initial[u] = u
            s.label[u] = 0
            s.potential[u] = 1
        for bucket in s.events.mitems: bucket.setLen(0)
        for u in 1..s.n:
            if s.mate[u] == 0:
                s.tree.grow(0, u)
                s.label[u] = u
                s.queue.add(u)
        block search:
            while true:
                while s.head < s.queue.len:
                    let x = s.queue[s.head]
                    inc s.head
                    for y in s.graph[x]:
                        if s.label[y] > 0:
                            let at = (s.potential[x] + s.potential[y]) div 2
                            if s.label[x] != s.label[y]:
                                if at == s.time: break search
                                s.deadline = min(s.deadline, at)
                            elif s.base(x) != s.base(y):
                                if at == s.time: s.contract(x, y)
                                elif at <= s.n div 2: s.events[at].add((x, y))
                        elif s.label[y] == 0:
                            let at = s.potential[x] + 1
                            if at == s.time: s.extend(x, y)
                            elif at <= s.n div 2: s.events[at].add((x, y))
                while true:
                    inc s.time
                    s.saved = s.contractions.len
                    if s.time > s.n div 2: return false
                    if s.time == s.deadline: break search
                    var changed = false
                    for e in s.events[s.time]:
                        let (x, y) = e
                        if s.label[y] > 0:
                            if s.potential[x] + s.potential[y] != 2 * s.time: continue
                            if s.base(x) == s.base(y): continue
                            if s.label[x] != s.label[y]: break search
                            s.contract(x, y)
                            changed = true
                        elif s.label[y] == 0:
                            s.extend(x, y)
                            changed = true
                    if changed: break
        for u in 1..s.n:
            if s.label[u] > 0: s.potential[u] -= s.time
            elif s.label[u] < 0: s.potential[u] = 1 + s.time - s.potential[u]
        true

    proc rematch(s: var MatchingSearch, v, w: int) =
        ## 花を展開しながら増加路上のマッチ辺を反転する。経路長に比例する時間。
        var stack = @[(v, w)]
        while stack.len > 0:
            let (x, y) = stack.pop()
            let old = s.mate[x]
            s.mate[x] = y
            if s.mate[old] != x: continue
            let e = s.link[x]
            if e.v == s.base(e.v):
                s.mate[old] = e.u
                stack.add((e.u, old))
            else:
                stack.add((e.v, e.u))
                stack.add((e.u, e.v))

    proc augment(s: var MatchingSearch, start, startBase: int): bool =
        ## タイトな辺だけで深さ優先探索し、増加路を一つ反転する。
        type Frame = object
            x, bx, edge: int
            pending: seq[int]
            group, member: int
        var stack = @[Frame(x: start, bx: startBase)]
        while stack.len > 0:
            let i = stack.high
            if stack[i].group < stack[i].pending.len:
                let b = stack[i].pending[stack[i].group]
                if stack[i].member < s.members[b].len:
                    let v = s.members[b][stack[i].member]
                    inc stack[i].member
                    let bx = s.base(b)
                    stack.add(Frame(x: v, bx: bx))
                else:
                    inc stack[i].group
                    stack[i].member = 0
                continue
            let x = stack[i].x
            let bx = stack[i].bx
            if stack[i].edge == s.graph[x].len:
                stack.setLen(i)
                continue
            let y = s.graph[x][stack[i].edge]
            inc stack[i].edge
            if s.potential[x] + s.potential[y] != 0: continue
            let by = s.base(y)
            if s.label[by] > 0:
                if s.label[bx] >= s.label[by]: continue
                var pending: seq[int]
                var v = by
                while v != bx:
                    let w = s.base(s.mate[v])
                    let parent = s.base(s.link[v].u)
                    s.link[w] = (x, y)
                    pending.add(w)
                    s.tree.joinParent(v)
                    s.tree.joinParent(w)
                    v = parent
                # 縮約した経路を根側から探索する。
                stack[i].pending.setLen(0)
                for j in countdown(pending.high, 0): stack[i].pending.add(pending[j])
                stack[i].group = 0
                stack[i].member = 0
            elif s.label[by] == 0:
                s.label[by] = -1
                let z = s.mate[by]
                if z == 0:
                    s.rematch(x, y)
                    s.rematch(y, x)
                    return true
                let bz = s.base(z)
                s.tree.grow(s.initial[x], by)
                s.tree.grow(by, bz)
                s.link[bz] = (x, y)
                s.label[bz] = s.order
                inc s.order
                stack[i].pending = @[bz]
                stack[i].group = 0
                stack[i].member = 0
        false

    proc maximal(s: var MatchingSearch): int =
        ## 正の双対値を持つ花を残し、頂点素な最短増加路の極大集合を求める。O(V+E)。
        for u in 0..s.n: s.initial[u] = u
        for i in 0..<s.saved:
            let e = s.contractions[i]
            s.initial[e.v] = e.base
        # 縮約履歴の森を一度ずつたどり、全頂点の基点を線形時間で確定する。
        var path: seq[int]
        for u in 1..s.n:
            var v = u
            while s.initial[v] != v:
                path.add(v)
                v = s.initial[v]
            for x in path: s.initial[x] = v
            path.setLen(0)
        s.tree = initMatchingTreeUnion(s.n + 1)
        s.order = 1
        for u in 0..s.n:
            s.label[u] = 0
            s.members[u].setLen(0)
        for u in 1..s.n: s.members[s.initial[u]].add(u)
        for u in 1..s.n:
            if s.mate[u] != 0: continue
            let b = s.initial[u]
            if s.label[b] != 0: continue
            s.tree.grow(0, b)
            s.label[b] = s.order
            inc s.order
            for v in s.members[b]:
                if s.augment(v, b):
                    inc result
                    break
        assert result > 0, "resultは正である必要があります"

    proc maximum_matching*(g: UnDirectedGraph): seq[tuple[u, v: int]] =
        ## 無向グラフの最大マッチングの頂点ペア列を返す。O(V+E sqrt V)時間、O(V+E)領域。
        ## 重みは無視する。多重辺を許容し、自己ループは無視する。入力は変更しない。
        ## 静的グラフはbuild()後に呼ぶ。孤立点を除いた探索部分はO(E sqrt V)。
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        var id = newSeq[int](g.len)
        var original = @[-1]
        for u in 0..<g.len:
            for (v, _) in g.to_and_cost(u):
                if u >= v: continue
                for x in [u, v]:
                    if id[x] == 0:
                        id[x] = original.len
                        original.add(x)
        if original.len == 1: return
        let n = original.len - 1
        var s = MatchingSearch(n: n,
            graph: newSeq[seq[int]](n + 1), mate: newSeq[int](n + 1),
            potential: newSeq[int](n + 1), label: newSeq[int](n + 1),
            initial: newSeq[int](n + 1), link: newSeq[tuple[u, v: int]](n + 1),
            events: newSeq[seq[tuple[u, v: int]]](n div 2 + 1),
            members: newSeq[seq[int]](n + 1))
        for u in 0..<g.len:
            for (v, _) in g.to_and_cost(u):
                if u >= v: continue
                s.graph[id[u]].add(id[v])
                s.graph[id[v]].add(id[u])
        var count = 0
        while count * 2 + 1 < n and s.shortest():
            count += s.maximal()
        for u in 1..n:
            if s.mate[u] > u:
                result.add((original[u], original[s.mate[u]]))
