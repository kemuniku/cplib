## 最大重みマッチングの主双対探索。
## 花を固定順の子と巡回辺で表し、基点の変更は頂点列の並べ替えを伴わない。
## 疎グラフでは頂点列をAVL木で連結・分割し、双対値と最小余裕を遅延更新する。
## 密グラフでは所属配列と成分間の最小辺を使う。
when not declared CPLIB_GRAPH_INTERNAL_WEIGHTED_MATCHING_ENGINE:
    const CPLIB_GRAPH_INTERNAL_WEIGHTED_MATCHING_ENGINE* = 1
    import heapqueue
    import cplib/graph/graph

    const MatchingInfinity = high(int64)
    type
        MatchingDirection = tuple[src, dst: int]
        MatchingEdge = tuple[src, dst: int, weight: int64]
        MatchingColor = enum
            mcHidden, mcIdle, mcEven, mcOdd
        MatchingComponent = object
            live: bool
            parent, count, first, base, pivot, root, version: int
            color: MatchingColor
            dual, changed: int64
            previous: MatchingDirection
            children: seq[int]
            cycle: seq[MatchingDirection]
            ends, members, direct: seq[int]
            bestVertex, crossEdge: int
            best, cross: int64
        MatchingLeaf = object
            left, right, parent, height, count, owner: int
            potential, lazy, offer, minimum: int64
            edge, arg: int
        MatchingEvent = tuple[time: int64, kind, component, version, edge: int]
        MatchingMachine[fast: static bool] = object
            n, serial, queueHead: int
            time: int64
            arcs: seq[MatchingEdge]
            adjacency: seq[seq[int]]
            components: seq[MatchingComponent]
            leaves: seq[MatchingLeaf]
            free, mate, queue, marked: seq[int]
            currentVisit: int
            heap: HeapQueue[MatchingEvent]
            pending: seq[MatchingEvent]
            heapReady: bool
            owner: seq[int]
            between: seq[seq[int]]

    proc slope(color: MatchingColor): int64 {.inline.} =
        ## 外側・内側・未到達の頂点の双対値の変化率を返す。
        case color
        of mcEven: -1'i64
        of mcOdd: 1'i64
        else: 0'i64

    proc reverse(edge: MatchingDirection): MatchingDirection {.inline.} =
        ## 辺の向きを反転する。
        (edge.dst, edge.src)

    proc apply[fast: static bool](s: var MatchingMachine[fast], root: int, delta: int64) =
        ## AVL部分木の双対値と最小余裕を一括更新する。O(1)。
        if root == 0 or delta == 0: return
        s.leaves[root].potential += delta
        s.leaves[root].lazy += delta
        if s.leaves[root].minimum != MatchingInfinity:
            s.leaves[root].minimum += delta

    proc push[fast: static bool](s: var MatchingMachine[fast], root: int) =
        ## 保留している双対値の更新を子へ伝える。O(1)。
        let delta = s.leaves[root].lazy
        if delta == 0: return
        s.apply(s.leaves[root].left, delta)
        s.apply(s.leaves[root].right, delta)
        s.leaves[root].lazy = 0

    proc pull[fast: static bool](s: var MatchingMachine[fast], root: int) =
        ## AVL節点の高さ・要素数・最小余裕を再計算する。O(1)。
        let l = s.leaves[root].left
        let r = s.leaves[root].right
        s.leaves[root].height = 1 + max(s.leaves[l].height, s.leaves[r].height)
        s.leaves[root].count = 1 + s.leaves[l].count + s.leaves[r].count
        var best = MatchingInfinity
        var arg = 0
        if s.leaves[root].edge >= 0:
            best = s.leaves[root].potential + s.leaves[root].offer
            arg = root
        for child in [l, r]:
            if child != 0 and s.leaves[child].minimum < best:
                best = s.leaves[child].minimum
                arg = s.leaves[child].arg
        s.leaves[root].minimum = best
        s.leaves[root].arg = arg

    proc attach[fast: static bool](s: var MatchingMachine[fast], root, child: int, right: bool) =
        ## 子へのリンクと逆向きの親リンクを同時に更新する。
        if right: s.leaves[root].right = child
        else: s.leaves[root].left = child
        if child != 0: s.leaves[child].parent = root

    proc rotate[fast: static bool](s: var MatchingMachine[fast], root: int, left: bool): int =
        ## 一回の回転で、頂点列の順序を保ちながらAVL木を組み替える。
        s.push(root)
        result = if left: s.leaves[root].right else: s.leaves[root].left
        s.push(result)
        if left:
            s.attach(root, s.leaves[result].left, true)
            s.attach(result, root, false)
        else:
            s.attach(root, s.leaves[result].right, false)
            s.attach(result, root, true)
        s.leaves[result].parent = 0
        s.pull(root)
        s.pull(result)

    proc balance[fast: static bool](s: var MatchingMachine[fast], root: int): int =
        ## 左右の高さの差を解消する。O(1)。
        s.pull(root)
        s.leaves[root].parent = 0
        let l = s.leaves[root].left
        let r = s.leaves[root].right
        if s.leaves[l].height > s.leaves[r].height + 1:
            if s.leaves[s.leaves[l].right].height > s.leaves[s.leaves[l].left].height:
                let child = s.rotate(l, true)
                s.attach(root, child, false)
            return s.rotate(root, false)
        if s.leaves[r].height > s.leaves[l].height + 1:
            if s.leaves[s.leaves[r].left].height > s.leaves[s.leaves[r].right].height:
                let child = s.rotate(r, false)
                s.attach(root, child, true)
            return s.rotate(root, true)
        root

    proc join[fast: static bool](s: var MatchingMachine[fast], l, middle, r: int): int =
        ## 一節点を間に挟んで二つのAVL木を連結する。O(高さの差+1)。
        if s.leaves[l].height > s.leaves[r].height + 1:
            s.push(l)
            let child = s.join(s.leaves[l].right, middle, r)
            s.attach(l, child, true)
            return s.balance(l)
        if s.leaves[r].height > s.leaves[l].height + 1:
            s.push(r)
            let child = s.join(l, middle, s.leaves[r].left)
            s.attach(r, child, false)
            return s.balance(r)
        s.attach(middle, l, false)
        s.attach(middle, r, true)
        s.leaves[middle].parent = 0
        s.pull(middle)
        middle

    proc split[fast: static bool](s: var MatchingMachine[fast], root, count: int): tuple[left, right: int] =
        ## 頂点列を先頭count個と残りに分割する。O(log V)。
        if root == 0: return
        s.push(root)
        let l = s.leaves[root].left
        let r = s.leaves[root].right
        let size = s.leaves[l].count
        s.leaves[root].left = 0
        s.leaves[root].right = 0
        s.leaves[root].parent = 0
        if count <= size:
            let parts = s.split(l, count)
            result.left = parts.left
            result.right = s.join(parts.right, root, r)
        else:
            let parts = s.split(r, count - size - 1)
            result.left = s.join(l, root, parts.left)
            result.right = parts.right
        if result.left != 0: s.leaves[result.left].parent = 0
        if result.right != 0: s.leaves[result.right].parent = 0

    proc concatenate[fast: static bool](s: var MatchingMachine[fast], l, r: int): int =
        ## 二つの頂点列を連結する。O(log V)。
        if l == 0:
            if r != 0: s.leaves[r].parent = 0
            return r
        if r == 0:
            s.leaves[l].parent = 0
            return l
        let parts = s.split(l, s.leaves[l].count - 1)
        s.join(parts.left, parts.right, r)

    proc top[fast: static bool](s: MatchingMachine[fast], vertex: int): int =
        ## 頂点を含む最上位の花を返す。密版O(1)、疎版O(log V)。
        when fast:
            var root = vertex
            while s.leaves[root].parent != 0: root = s.leaves[root].parent
            s.leaves[root].owner
        else: s.owner[vertex]

    proc potential[fast: static bool](s: MatchingMachine[fast], vertex: int): int64 =
        ## 時刻の項を除いた頂点の双対値を返す。密版O(1)、疎版O(log V)。
        result = s.leaves[vertex].potential
        when fast:
            var v = s.leaves[vertex].parent
            while v != 0:
                result += s.leaves[v].lazy
                v = s.leaves[v].parent

    proc rank[fast: static bool](s: MatchingMachine[fast], vertex: int): int =
        ## 頂点の、所属するAVL木の中での位置を返す。O(log V)。
        result = s.leaves[s.leaves[vertex].left].count
        var v = vertex
        while s.leaves[v].parent != 0:
            let p = s.leaves[v].parent
            if s.leaves[p].right == v:
                result += s.leaves[s.leaves[p].left].count + 1
            v = p

    proc childIndex[fast: static bool](s: MatchingMachine[fast], b, vertex: int): int =
        ## 指定頂点を含む直接の子の添字を返す。密版O(1)、疎版O(log V)。
        when fast:
            let index = s.rank(vertex) - s.rank(s.components[b].first)
            var l = 0
            var r = s.components[b].ends.len
            while l < r:
                let m = (l + r) div 2
                if index < s.components[b].ends[m]: r = m
                else: l = m + 1
            l
        else: s.components[b].direct[vertex]

    iterator vertices[fast: static bool](s: MatchingMachine[fast], b: int): int =
        ## 最上位の花の頂点を列挙する。O(頂点数)。
        when fast:
            var stack: seq[int]
            var current = s.components[b].root
            while current != 0 or stack.len > 0:
                if current != 0:
                    stack.add(current)
                    current = s.leaves[current].left
                else:
                    current = stack.pop()
                    yield current
                    current = s.leaves[current].right
        else:
            for v in s.components[b].members: yield v

    proc shift[fast: static bool](s: var MatchingMachine[fast], b: int, delta: int64) =
        ## 一つの花の頂点双対値を一括更新する。密版O(頂点数)、疎版O(1)。
        when fast: s.apply(s.components[b].root, delta)
        else:
            for v in s.components[b].members: s.leaves[v].potential += delta
            if s.components[b].best != MatchingInfinity: s.components[b].best += delta

    proc touch[fast: static bool](s: var MatchingMachine[fast], b: int) =
        ## 花の双対値を現在の時刻にそろえる。
        if b > s.n:
            s.components[b].dual -= 2 * slope(s.components[b].color) * (s.time - s.components[b].changed)
        s.components[b].changed = s.time

    proc invalidate[fast: static bool](s: var MatchingMachine[fast], b: int) =
        ## 古いイベントを無効化するため、花の世代番号を更新する。
        inc s.serial
        s.components[b].version = s.serial

    proc bestOffer[fast: static bool](s: MatchingMachine[fast], b: int): tuple[value: int64, vertex: int] =
        ## 花へ入る辺のうち最小の余裕を与える候補を返す。O(1)。
        when fast:
            let root = s.components[b].root
            (s.leaves[root].minimum, s.leaves[root].arg)
        else: (s.components[b].best, s.components[b].bestVertex)

    proc schedule[fast: static bool](s: var MatchingMachine[fast], event: MatchingEvent) =
        ## 初回走査のイベントはまとめて蓄え、以後はヒープに追加する。
        if s.heapReady: s.heap.push(event)
        else: s.pending.add(event)

    proc scheduleOffer[fast: static bool](s: var MatchingMachine[fast], b: int) =
        ## 未到達の花に入る候補をイベントとして登録する。疎版O(log V)。
        when fast:
            if s.components[b].color != mcIdle: return
            let candidate = s.bestOffer(b)
            s.invalidate(b)
            if candidate.vertex != 0:
                s.schedule((candidate.value, 0, b, s.components[b].version, s.leaves[candidate.vertex].edge))

    proc offer[fast: static bool](s: var MatchingMachine[fast], vertex, edge: int, value: int64) =
        ## 外側頂点からの候補を更新する。密版O(1)、疎版O(log V)。
        if s.leaves[vertex].edge >= 0 and value >= s.leaves[vertex].offer: return
        let b = s.top(vertex)
        when fast:
            var path = @[vertex]
            while s.leaves[path[^1]].parent != 0: path.add(s.leaves[path[^1]].parent)
            for i in countdown(path.high, 0): s.push(path[i])
            s.leaves[vertex].offer = value
            s.leaves[vertex].edge = edge
            for v in path: s.pull(v)
        else:
            s.leaves[vertex].offer = value
            s.leaves[vertex].edge = edge
            let key = s.leaves[vertex].potential + value
            if key < s.components[b].best:
                s.components[b].best = key
                s.components[b].bestVertex = vertex
        s.scheduleOffer(b)

    proc edgeTime[fast: static bool](s: MatchingMachine[fast], edge: int): int64 =
        ## 二つの外側頂点を結ぶ辺がタイトになる時刻を返す。
        let e = s.arcs[edge]
        (s.potential(e.src) + s.potential(e.dst) - 2 * e.weight) div 2

    proc activateCross[fast: static bool](s: var MatchingMachine[fast], b: int) =
        ## 密版で、外側の花同士の最小辺を更新する。O(V)。
        when not fast:
            s.components[b].cross = MatchingInfinity
            s.components[b].crossEdge = -1
            for c in 1..<s.components.len:
                if c == b or s.components[c].color != mcEven: continue
                let edge = s.between[b][c]
                if edge < 0: continue
                let time = s.edgeTime(edge)
                if time < s.components[b].cross:
                    s.components[b].cross = time
                    s.components[b].crossEdge = edge
                if time < s.components[c].cross:
                    s.components[c].cross = time
                    s.components[c].crossEdge = edge

    proc label[fast: static bool](s: var MatchingMachine[fast], b: int, color: MatchingColor) =
        ## 花のラベルと双対値の変化率を変更し、必要な探索を登録する。
        let old = s.components[b].color
        s.touch(b)
        s.shift(b, (slope(old) - slope(color)) * s.time)
        s.components[b].color = color
        s.invalidate(b)
        if color == mcEven and old != mcEven:
            for v in s.vertices(b): s.queue.add(v)
            s.activateCross(b)
        elif color == mcIdle:
            s.scheduleOffer(b)
        elif color == mcOdd and b > s.n:
            when fast:
                s.schedule((s.time + s.components[b].dual div 2, 2, b, s.components[b].version, -1))

    proc ancestor[fast: static bool](s: var MatchingMachine[fast], left, right: int): int =
        ## 二本の交互路を交互にたどり、共通祖先を返す。異なる木なら0。
        inc s.currentVisit
        var a = left
        var b = right
        while a != 0 or b != 0:
            if a != 0:
                if s.marked[a] == s.currentVisit: return a
                s.marked[a] = s.currentVisit
                let entry = s.components[a].previous
                if entry.src == 0: a = 0
                else:
                    let inner = s.top(entry.src)
                    a = s.top(s.components[inner].previous.src)
            swap(a, b)

    proc branch[fast: static bool](s: MatchingMachine[fast], start, finish: int): tuple[nodes: seq[int], edges: seq[MatchingDirection]] =
        ## 外側の花から祖先までの交互路を、上向きに列挙する。
        var current = start
        while current != finish:
            result.nodes.add(current)
            let matched = s.components[current].previous
            result.edges.add(matched.reverse())
            current = s.top(matched.src)
            result.nodes.add(current)
            let unmatched = s.components[current].previous
            result.edges.add(unmatched.reverse())
            current = s.top(unmatched.src)

    proc contract[fast: static bool](s: var MatchingMachine[fast], x, y, common: int) =
        ## 交互路二本と一辺を奇閉路にし、花として縮約する。
        let a = s.branch(s.top(x), common)
        let b = s.branch(s.top(y), common)
        let id = s.free.pop()
        var flower = MatchingComponent(live: true, base: s.components[common].base,
            first: s.components[common].first, previous: s.components[common].previous,
            changed: s.time, best: MatchingInfinity, cross: MatchingInfinity, crossEdge: -1)
        flower.children.add(common)
        for i in countdown(a.nodes.high, 0):
            flower.cycle.add(a.edges[i].reverse())
            flower.children.add(a.nodes[i])
        flower.cycle.add((x, y))
        for i, child in b.nodes:
            flower.children.add(child)
            flower.cycle.add(b.edges[i])
        when not fast: flower.direct = newSeq[int](s.n + 1)
        for i, child in flower.children:
            s.label(child, mcEven)
            s.touch(child)
            s.components[child].color = mcHidden
            s.components[child].parent = id
            s.invalidate(child)
            flower.count += s.components[child].count
            flower.ends.add(flower.count)
            when fast:
                flower.root = s.concatenate(flower.root, s.components[child].root)
            else:
                for v in s.components[child].members:
                    flower.members.add(v)
                    flower.direct[v] = i
                    s.owner[v] = id
        when fast:
            s.leaves[flower.root].owner = id
        else:
            for other in 1..<s.components.len:
                var chosen = -1
                var value = MatchingInfinity
                for child in flower.children:
                    let edge = s.between[child][other]
                    if edge < 0: continue
                    let e = s.arcs[edge]
                    let key = s.potential(e.src) + s.potential(e.dst) - 2 * e.weight
                    if key < value:
                        value = key
                        chosen = edge
                s.between[id][other] = chosen
                s.between[other][id] = chosen
        flower.color = mcEven
        s.components[id] = move(flower)
        s.invalidate(id)
        s.activateCross(id)

    proc cycleEdge[fast: static bool](s: MatchingMachine[fast], b, index, direction: int): MatchingDirection =
        ## 巡回辺を指定された向きで返す。
        if direction == 1: s.components[b].cycle[index]
        else:
            let previous = (index + s.components[b].children.len - 1) mod s.components[b].children.len
            s.components[b].cycle[previous].reverse()

    proc expose[fast: static bool](s: var MatchingMachine[fast], component, vertex: int) =
        ## 指定頂点を花の基点にし、内部の交互路を反転する。再帰は使わない。
        var tasks = @[(kind: 0, a: component, b: vertex)]
        while tasks.len > 0:
            let task = tasks.pop()
            if task.kind == 1:
                s.mate[task.a] = task.b
                s.mate[task.b] = task.a
                continue
            let b = task.a
            let v = task.b
            if b <= s.n:
                s.mate[v] = 0
                continue
            let target = s.childIndex(b, v)
            let count = s.components[b].children.len
            var at = s.components[b].pivot
            let distance = (target - at + count) mod count
            let direction = if distance mod 2 == 0: 1 else: -1
            while at != target:
                let next = (at + direction + count) mod count
                let edge = s.cycleEdge(b, at, direction)
                tasks.add((1, edge.src, edge.dst))
                tasks.add((0, s.components[b].children[next], edge.dst))
                tasks.add((0, s.components[b].children[at], edge.src))
                at = (next + direction + count) mod count
            tasks.add((0, s.components[b].children[target], v))
            s.components[b].pivot = target
            s.components[b].base = v

    proc augment[fast: static bool](s: var MatchingMachine[fast], x, y: int) =
        ## 異なる根を結ぶ二本の交互路を記録し、そのマッチ辺を反転する。
        var bases: seq[tuple[component, vertex: int]]
        var selected = @[(x, y)]
        for endpoint in [x, y]:
            var v = endpoint
            while true:
                let b = s.top(v)
                bases.add((b, v))
                let incoming = s.components[b].previous
                if incoming.src == 0: break
                let inner = s.top(incoming.src)
                let edge = s.components[inner].previous
                bases.add((inner, edge.dst))
                selected.add((edge.src, edge.dst))
                v = edge.src
        for item in bases: s.expose(item.component, item.vertex)
        for edge in selected:
            s.mate[edge[0]] = edge[1]
            s.mate[edge[1]] = edge[0]

    proc grow[fast: static bool](s: var MatchingMachine[fast], x, y: int) =
        ## 未到達の花と、そのマッチ先を交互木に追加する。
        let b = s.top(y)
        let z = s.mate[s.components[b].base]
        assert z != 0, "未マッチの花は探索開始時に根として登録されます"
        s.components[b].previous = (x, y)
        s.label(b, mcOdd)
        let next = s.top(z)
        s.components[next].previous = (s.components[b].base, z)
        s.label(next, mcEven)

    proc expand[fast: static bool](s: var MatchingMachine[fast], b: int) =
        ## 内側の花を分割し、入口から基点までの偶数長の交互路を復元する。
        let entry = s.components[b].previous
        let first = s.childIndex(b, entry.dst)
        let finish = s.components[b].pivot
        let count = s.components[b].children.len
        let distance = (finish - first + count) mod count
        let direction = if distance mod 2 == 0: 1 else: -1
        var colors = newSeq[MatchingColor](count)
        var incoming = newSeq[MatchingDirection](count)
        for color in colors.mitems: color = mcIdle
        var at = first
        colors[at] = mcOdd
        incoming[at] = entry
        while at != finish:
            let next = (at + direction + count) mod count
            colors[next] = if colors[at] == mcOdd: mcEven else: mcOdd
            incoming[next] = s.cycleEdge(b, at, direction)
            at = next
        when fast:
            var remaining = s.components[b].root
            for child in s.components[b].children:
                let parts = s.split(remaining, s.components[child].count)
                s.components[child].root = parts.left
                s.leaves[parts.left].owner = child
                remaining = parts.right
        else:
            for child in s.components[b].children:
                s.components[child].best = MatchingInfinity
                s.components[child].bestVertex = 0
                for v in s.components[child].members:
                    s.owner[v] = child
                    if s.leaves[v].edge >= 0:
                        let key = s.leaves[v].potential + s.leaves[v].offer
                        if key < s.components[child].best:
                            s.components[child].best = key
                            s.components[child].bestVertex = v
        s.components[b].color = mcHidden
        s.invalidate(b)
        for i, child in s.components[b].children:
            s.components[child].parent = 0
            s.components[child].color = mcOdd
            s.components[child].changed = s.time
            s.components[child].previous = incoming[i]
            s.label(child, colors[i])
        s.components[b] = MatchingComponent(color: mcHidden)
        s.free.add(b)

    proc nextEvent[fast: static bool](s: var MatchingMachine[fast]): MatchingEvent =
        ## 次の有効なイベントを返す。密版O(V)、疎版は一取り出しO(log V)。
        result = (MatchingInfinity, -1, 0, 0, -1)
        when fast:
            if not s.heapReady:
                s.heap = toHeapQueue(s.pending)
                s.pending.setLen(0)
                s.heapReady = true
            while s.heap.len > 0:
                let event = s.heap.pop()
                if event.kind == 1:
                    let edge = s.arcs[event.edge]
                    if s.top(edge.src) != s.top(edge.dst): return event
                else:
                    let b = event.component
                    if not s.components[b].live or s.components[b].parent != 0: continue
                    if s.components[b].version != event.version: continue
                    let color = if event.kind == 0: mcIdle else: mcOdd
                    if s.components[b].color == color: return event
        else:
            for b in 1..<s.components.len:
                case s.components[b].color
                of mcIdle:
                    let candidate = s.bestOffer(b)
                    if candidate.value < result.time:
                        result = (candidate.value, 0, b, 0, s.leaves[candidate.vertex].edge)
                of mcEven:
                    if s.components[b].cross < result.time:
                        result = (s.components[b].cross, 1, b, 0, s.components[b].crossEdge)
                of mcOdd:
                    if b > s.n:
                        let time = s.components[b].changed + s.components[b].dual div 2
                        if time < result.time: result = (time, 2, b, 0, -1)
                of mcHidden: discard

    proc scan[fast: static bool](s: var MatchingMachine[fast]): bool =
        ## 新しく外側になった頂点を走査し、時刻を進めずに使える辺を直ちに処理する。
        while s.queueHead < s.queue.len:
            let u = s.queue[s.queueHead]
            inc s.queueHead
            var source = s.top(u)
            let p = s.potential(u)
            for id in s.adjacency[u]:
                let edge = s.arcs[id]
                let dest = s.top(edge.dst)
                if source == dest: continue
                if s.components[dest].color == mcEven:
                    let time = s.edgeTime(id)
                    if time == s.time:
                        let common = s.ancestor(source, dest)
                        if common == 0:
                            s.augment(u, edge.dst)
                            return true
                        s.contract(u, edge.dst, common)
                        source = s.top(u)
                    else:
                        when fast: s.schedule((time, 1, 0, 0, id))
                else:
                    s.offer(edge.dst, id, p - 2 * edge.weight)
                    if s.components[dest].color == mcIdle:
                        if p + s.potential(edge.dst) - 2 * edge.weight == s.time:
                            s.grow(u, edge.dst)

    proc finishStage[fast: static bool](s: var MatchingMachine[fast]) =
        ## 双対値を現在時刻で確定し、次の探索の時刻原点へ移す。
        for b in 1..<s.components.len:
            if not s.components[b].live or s.components[b].parent != 0: continue
            s.touch(b)
            s.shift(b, slope(s.components[b].color) * s.time)
            s.components[b].color = mcIdle
            s.components[b].changed = 0
        s.time = 0

    proc stage[fast: static bool](s: var MatchingMachine[fast]): bool =
        ## 増加路を一つ求める。密版O(V^2)、疎版O(E log V)。
        s.queue.setLen(0)
        s.queueHead = 0
        s.heap.clear()
        s.pending.setLen(0)
        s.heapReady = false
        for v in 1..s.n:
            s.leaves[v].edge = -1
            s.leaves[v].minimum = MatchingInfinity
            s.leaves[v].arg = 0
        for b in 1..<s.components.len:
            s.components[b].best = MatchingInfinity
            s.components[b].bestVertex = 0
            s.components[b].cross = MatchingInfinity
            s.components[b].crossEdge = -1
            s.components[b].previous = (0, 0)
        var deadline = MatchingInfinity
        for b in 1..<s.components.len:
            if s.components[b].color != mcIdle: continue
            let v = s.components[b].base
            if s.mate[v] == 0:
                deadline = min(deadline, s.potential(v))
                s.label(b, mcEven)
        if deadline == MatchingInfinity: return false
        while true:
            if s.scan():
                s.finishStage()
                return true
            let event = s.nextEvent()
            if event.time >= deadline:
                s.time = deadline
                s.finishStage()
                return false
            assert event.time >= s.time, "イベント時刻は後戻りできません"
            s.time = event.time
            case event.kind
            of 0:
                let edge = s.arcs[event.edge]
                s.grow(edge.src, edge.dst)
            of 1:
                let edge = s.arcs[event.edge]
                let common = s.ancestor(s.top(edge.src), s.top(edge.dst))
                if common == 0:
                    s.augment(edge.src, edge.dst)
                    s.finishStage()
                    return true
                s.contract(edge.src, edge.dst, common)
            of 2: s.expand(event.component)
            else: assert false, "未知のイベントです"

    proc independentWeightedMatching*[T: SomeSignedInt](g: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T], fast: static bool): tuple[weight: int64, matching: seq[tuple[u, v: int]]] =
        ## 整数重みの最大重みマッチングを求める。公開モジュール二種類から利用する共通実装。
        when g is StaticGraphTypes: g.static_graph_initialized_check()
        var indices = newSeq[int](g.len)
        var vertices = @[-1]
        var largest = 0'i64
        for edge in g.edge_info:
            if edge.src == edge.dst or edge.cost <= 0: continue
            largest = max(largest, int64(edge.cost))
            for v in [edge.src, edge.dst]:
                if indices[v] == 0:
                    indices[v] = vertices.len
                    vertices.add(v)
        let n = vertices.len - 1
        if n == 0: return
        assert largest <= high(int64) div 4 div int64(n), "辺重みがint64で安全に計算できる範囲を超えています"
        let capacity = 2 * n + 1
        var s = MatchingMachine[fast](n: n, components: newSeq[MatchingComponent](capacity),
            leaves: newSeq[MatchingLeaf](n + 1), mate: newSeq[int](n + 1),
            adjacency: newSeq[seq[int]](n + 1), marked: newSeq[int](capacity))
        when not fast:
            s.owner = newSeq[int](n + 1)
            s.between = newSeq[seq[int]](capacity)
            for row in s.between.mitems:
                row = newSeq[int](capacity)
                for x in row.mitems: x = -1
        for b in countdown(capacity - 1, n + 1): s.free.add(b)
        for v in 1..n:
            s.components[v] = MatchingComponent(live: true, count: 1, first: v, base: v,
                root: v, color: mcIdle, best: MatchingInfinity, cross: MatchingInfinity, crossEdge: -1)
            s.leaves[v] = MatchingLeaf(height: 1, count: 1, owner: v, potential: largest,
                minimum: MatchingInfinity, edge: -1)
            when not fast:
                s.components[v].members = @[v]
                s.owner[v] = v
        when fast:
            var raw = newSeq[seq[tuple[vertex: int, weight: int64]]](n + 1)
            for edge in g.edge_info:
                if edge.src == edge.dst or edge.cost <= 0: continue
                let u = indices[edge.src]
                let v = indices[edge.dst]
                raw[u].add((v, int64(edge.cost)))
                raw[v].add((u, int64(edge.cost)))
            var seen = newSeq[int](n + 1)
            var position = newSeq[int](n + 1)
            for u in 1..n:
                for edge in raw[u]:
                    let v = edge.vertex
                    if seen[v] != u:
                        seen[v] = u
                        position[v] = s.arcs.len
                        s.adjacency[u].add(s.arcs.len)
                        s.arcs.add((u, v, edge.weight))
                    else:
                        let id = position[v]
                        s.arcs[id].weight = max(s.arcs[id].weight, edge.weight)
            raw = @[]
        else:
            for edge in g.edge_info:
                if edge.src == edge.dst or edge.cost <= 0: continue
                let a = indices[edge.src]
                let b = indices[edge.dst]
                for endpoints in [(a, b), (b, a)]:
                    let (u, v) = endpoints
                    let id = s.between[u][v]
                    if id < 0:
                        s.between[u][v] = s.arcs.len
                        s.adjacency[u].add(s.arcs.len)
                        s.arcs.add((u, v, int64(edge.cost)))
                    else:
                        s.arcs[id].weight = max(s.arcs[id].weight, int64(edge.cost))
        # 最大重みの辺だけで作る初期マッチングは、その辺数に対して既に最適。
        for edge in s.arcs:
            if edge.weight == largest and s.mate[edge.src] == 0 and s.mate[edge.dst] == 0:
                s.mate[edge.src] = edge.dst
                s.mate[edge.dst] = edge.src
        while s.stage(): discard
        for u in 1..n:
            let v = s.mate[u]
            if u >= v: continue
            for id in s.adjacency[u]:
                if s.arcs[id].dst == v:
                    result.weight += s.arcs[id].weight
                    break
            result.matching.add((min(vertices[u], vertices[v]), max(vertices[u], vertices[v])))
