when not declared CPLIB_COLLECTIONS_PERSISTENT_SEQUENCE:
    const CPLIB_COLLECTIONS_PERSISTENT_SEQUENCE* = 1

    type
        PersistentSequenceNoAction* = object
        PersistentSequenceNode[T, F] = ref object
            left, right: PersistentSequenceNode[T, F]
            height, size: int
            value, forward, backward: T
            lazy: F
            pending, reversed: bool
        PersistentSequenceContext[T, F] = ref object
            op: proc(a, b: T): T
            e: T
            mapping: proc(f: F, x: T): T
            aggregateMapping: proc(f: F, x: T, length: int): T
            composition: proc(f, g: F): F
            id: F
            monoid: bool
        PersistentSequence*[T, F] = object
            root: PersistentSequenceNode[T, F]
            context: PersistentSequenceContext[T, F]

    proc nodeSize[T, F](n: PersistentSequenceNode[T, F]): int =
        ## 部分木の要素数をO(1)で返します。
        if n == nil: 0 else: n.size

    proc nodeHeight[T, F](n: PersistentSequenceNode[T, F]): int =
        ## 部分木の高さをO(1)で返します。
        if n == nil: 0 else: n.height

    proc checked[T, F](s: PersistentSequence[T, F]) =
        ## 初期化済みであることをO(1)で検査します。
        if s.context == nil: raise newException(ValueError, "未初期化の永続列です")

    proc len*[T, F](s: PersistentSequence[T, F]): int =
        ## 要素数をO(1)で返します。
        s.checked
        s.root.nodeSize

    proc checkRange[T, F](s: PersistentSequence[T, F], l, r: int) =
        ## 半開区間の境界をO(1)で検査します。
        if l < 0 or r < l or r > s.len:
            raise newException(ValueError, "永続列の区間が範囲外です")

    proc makeNode[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                       value: T, right: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 新しい節点を集約値とともに構築します。時間・追加領域O(1)。
        let ls = left.nodeSize
        let rs = right.nodeSize
        if ls == high(int) or rs > high(int) - ls - 1:
            raise newException(ValueError, "永続列の長さがintに収まりません")
        result = PersistentSequenceNode[T, F](left: left, right: right, value: value,
            height: max(left.nodeHeight, right.nodeHeight) + 1, size: ls + 1 + rs, lazy: c.id)
        if c.monoid:
            result.forward = c.op(c.op((if left == nil: c.e else: left.forward), value),
                (if right == nil: c.e else: right.forward))
            result.backward = c.op(c.op((if right == nil: c.e else: right.backward), value),
                (if left == nil: c.e else: left.backward))

    proc cloneNode[T, F](n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 節点のみをO(1)で複製し、子は共有します。
        PersistentSequenceNode[T, F](left: n.left, right: n.right, height: n.height, size: n.size,
            value: n.value, forward: n.forward, backward: n.backward, lazy: n.lazy,
            pending: n.pending, reversed: n.reversed)

    proc refresh[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]) =
        ## 未公開の複製節点の要素数・高さ・集約値をO(1)で再計算します。
        let ls = n.left.nodeSize
        let rs = n.right.nodeSize
        if ls == high(int) or rs > high(int) - ls - 1:
            raise newException(ValueError, "永続列の長さがintに収まりません")
        n.size = ls + 1 + rs
        n.height = max(n.left.nodeHeight, n.right.nodeHeight) + 1
        if c.monoid:
            n.forward = c.op(c.op((if n.left == nil: c.e else: n.left.forward), n.value),
                (if n.right == nil: c.e else: n.right.forward))
            n.backward = c.op(c.op((if n.right == nil: c.e else: n.right.backward), n.value),
                (if n.left == nil: c.e else: n.left.backward))

    proc tagged[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                      f: F, pending, flip: bool): PersistentSequenceNode[T, F] =
        ## 作用と反転を同じ複製節点に反映します。共有節点は不変です。時間・追加領域O(1)。
        if n == nil: return nil
        when F is PersistentSequenceNoAction:
            if not flip: return n
        else:
            if not pending and not flip: return n
        result = cloneNode(n)
        when F isnot PersistentSequenceNoAction:
            if pending:
                result.value = c.mapping(f, n.value)
                if c.monoid:
                    result.forward = c.aggregateMapping(f, n.forward, n.size)
                    result.backward = c.aggregateMapping(f, n.backward, n.size)
                result.lazy = if n.pending: c.composition(f, n.lazy) else: f
                result.pending = true
        if flip:
            swap(result.left, result.right)
            swap(result.forward, result.backward)
            result.reversed = not result.reversed

    proc acted[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], f: F): PersistentSequenceNode[T, F] =
        ## 作用した版を返します。時間・追加領域O(1)。NoActionは恒等作用です。
        c.tagged(n, f, true, false)

    proc flipped[T, F](n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 節点を複製して左右と順逆集約を反転します。時間・追加領域O(1)。
        if n == nil: return nil
        result = cloneNode(n)
        swap(result.left, result.right)
        swap(result.forward, result.backward)
        result.reversed = not result.reversed

    proc copyPushed[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 節点を必ず複製し、子の作用・反転を一回の複製で伝播します。時間・追加領域O(1)。
        result = cloneNode(n)
        if n.pending or n.reversed:
            result.left = c.tagged(n.left, n.lazy, n.pending, n.reversed)
            result.right = c.tagged(n.right, n.lazy, n.pending, n.reversed)
            result.pending = false
            result.reversed = false
            result.lazy = c.id

    proc balanceOwned[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], leftOwned = false, rightOwned = false): PersistentSequenceNode[T, F] =
        ## 未公開の複製根だけを回転します。時間・追加領域O(1)。
        ## Owned=trueは今回の再帰で生成し、遅延を伝播済みの未公開根に限ります。
        ## 共有する子・孫は回転で変更する前に必ず複製します。
        if n.left.nodeHeight > n.right.nodeHeight + 1:
            let a = if leftOwned: n.left else: c.copyPushed(n.left)
            if a.left.nodeHeight >= a.right.nodeHeight:
                n.left = a.right
                a.right = n
                c.refresh(n)
                c.refresh(a)
                return a
            let b = c.copyPushed(a.right)
            a.right = b.left
            n.left = b.right
            b.left = a
            b.right = n
            c.refresh(a)
            c.refresh(n)
            c.refresh(b)
            return b
        if n.right.nodeHeight > n.left.nodeHeight + 1:
            let a = if rightOwned: n.right else: c.copyPushed(n.right)
            if a.right.nodeHeight >= a.left.nodeHeight:
                n.right = a.left
                a.left = n
                c.refresh(n)
                c.refresh(a)
                return a
            let b = c.copyPushed(a.left)
            n.right = b.left
            a.left = b.right
            b.left = n
            b.right = a
            c.refresh(n)
            c.refresh(a)
            c.refresh(b)
            return b
        c.refresh(n)
        n

    proc joinView[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                        leftCarry: F, leftPending, leftFlip: bool, bridge: PersistentSequenceNode[T, F],
                        right: PersistentSequenceNode[T, F], rightCarry: F,
                        rightPending, rightFlip: bool): PersistentSequenceNode[T, F] =
        ## 高い側の境界を仮想的に伝播して連結します。時間・追加領域O(|高さ差|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            let l = if leftFlip: left.right else: left.left
            let r = if leftFlip: left.left else: left.right
            let next = if left.pending: (if leftPending: c.composition(leftCarry, left.lazy) else: left.lazy) else: leftCarry
            let pending = leftPending or left.pending
            let flip = leftFlip xor left.reversed
            let value = if leftPending: c.mapping(leftCarry, left.value) else: left.value
            let combined = c.joinView(r, next, pending, flip, bridge, right, rightCarry, rightPending, rightFlip)
            let a = PersistentSequenceNode[T, F](left: c.tagged(l, next, pending, flip), right: combined, value: value, lazy: c.id)
            return c.balanceOwned(a, rightOwned = true)
        if right.nodeHeight > left.nodeHeight + 1:
            let l = if rightFlip: right.right else: right.left
            let r = if rightFlip: right.left else: right.right
            let next = if right.pending: (if rightPending: c.composition(rightCarry, right.lazy) else: right.lazy) else: rightCarry
            let pending = rightPending or right.pending
            let flip = rightFlip xor right.reversed
            let value = if rightPending: c.mapping(rightCarry, right.value) else: right.value
            let combined = c.joinView(left, leftCarry, leftPending, leftFlip, bridge, l, next, pending, flip)
            let a = PersistentSequenceNode[T, F](left: combined, right: c.tagged(r, next, pending, flip), value: value, lazy: c.id)
            return c.balanceOwned(a, leftOwned = true)
        bridge.left = c.tagged(left, leftCarry, leftPending, leftFlip)
        bridge.right = c.tagged(right, rightCarry, rightPending, rightFlip)
        c.refresh(bridge)
        bridge

    proc joinOwned[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                         bridge: PersistentSequenceNode[T, F], right: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 未公開の複製節点を橋にして連結します。時間・追加領域O(|高さ差|+1)。
        c.joinView(left, c.id, false, false, bridge, right, c.id, false, false)

    proc splitView[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                        k: int, carry: F, pending, flip: bool): tuple[left, right: PersistentSequenceNode[T, F]] =
        ## 祖先の作用・反転を引数で渡し、採用する結果の節点だけを生成します。全体O(log(N+1))。
        if k == 0: return (nil, c.tagged(n, carry, pending, flip))
        if k == n.nodeSize: return (c.tagged(n, carry, pending, flip), nil)
        let left = if flip: n.right else: n.left
        let right = if flip: n.left else: n.right
        let ls = left.nodeSize
        let next = if n.pending: (if pending: c.composition(carry, n.lazy) else: n.lazy) else: carry
        let nextPending = pending or n.pending
        let nextFlip = flip xor n.reversed
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = PersistentSequenceNode[T, F](value: value, lazy: c.id)
        if k <= ls:
            let parts = c.splitView(left, k, next, nextPending, nextFlip)
            return (parts.left, c.joinView(parts.right, c.id, false, false, bridge, right, next, nextPending, nextFlip))
        let parts = c.splitView(right, k - ls - 1, next, nextPending, nextFlip)
        (c.joinView(left, next, nextPending, nextFlip, bridge, parts.left, c.id, false, false), parts.right)

    proc splitNode[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                        k: int): tuple[left, right: PersistentSequenceNode[T, F]] =
        ## 先頭k個で分割します。時間・追加領域O(log(N+1))。
        c.splitView(n, k, c.id, false, false)

    proc takeView[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                       k: int, carry: F, pending, flip: bool): tuple[left, bridge, right: PersistentSequenceNode[T, F]] =
        ## k番目を未公開の橋節点として分離します。時間・追加領域O(log(N+1))。
        let left = if flip: n.right else: n.left
        let right = if flip: n.left else: n.right
        let ls = left.nodeSize
        let next = if n.pending: (if pending: c.composition(carry, n.lazy) else: n.lazy) else: carry
        let nextPending = pending or n.pending
        let nextFlip = flip xor n.reversed
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = PersistentSequenceNode[T, F](value: value, lazy: c.id)
        if k == ls:
            return (c.tagged(left, next, nextPending, nextFlip), bridge, c.tagged(right, next, nextPending, nextFlip))
        if k < ls:
            let p = c.takeView(left, k, next, nextPending, nextFlip)
            return (p.left, p.bridge, c.joinView(p.right, c.id, false, false, bridge, right, next, nextPending, nextFlip))
        let p = c.takeView(right, k - ls - 1, next, nextPending, nextFlip)
        (c.joinView(left, next, nextPending, nextFlip, bridge, p.left, c.id, false, false), p.bridge, p.right)

    proc cutEnds[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                       a, b: int, carry: F, pending, flip: bool): tuple[left, first, middle, last, right: PersistentSequenceNode[T, F]] =
        ## 長さ2以上の区間の両端を橋として分離し、共通境界経路を一度たどります。全体O(log(N+1))。
        let left = if flip: n.right else: n.left
        let right = if flip: n.left else: n.right
        let ls = left.nodeSize
        let next = if n.pending: (if pending: c.composition(carry, n.lazy) else: n.lazy) else: carry
        let nextPending = pending or n.pending
        let nextFlip = flip xor n.reversed
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = PersistentSequenceNode[T, F](value: value, lazy: c.id)
        if b <= ls:
            let p = c.cutEnds(left, a, b, next, nextPending, nextFlip)
            return (p.left, p.first, p.middle, p.last, c.joinView(p.right, c.id, false, false, bridge, right, next, nextPending, nextFlip))
        if a > ls:
            let p = c.cutEnds(right, a - ls - 1, b - ls - 1, next, nextPending, nextFlip)
            return (c.joinView(left, next, nextPending, nextFlip, bridge, p.left, c.id, false, false), p.first, p.middle, p.last, p.right)
        if a == ls:
            let p = c.takeView(right, b - ls - 2, next, nextPending, nextFlip)
            return (c.tagged(left, next, nextPending, nextFlip), bridge, p.left, p.bridge, p.right)
        if b == ls + 1:
            let p = c.takeView(left, a, next, nextPending, nextFlip)
            return (p.left, p.bridge, p.right, bridge, c.tagged(right, next, nextPending, nextFlip))
        let l = c.takeView(left, a, next, nextPending, nextFlip)
        let r = c.takeView(right, b - ls - 2, next, nextPending, nextFlip)
        (l.left, l.bridge, c.joinOwned(l.right, bridge, r.left), r.bridge, r.right)

    proc removeFirst[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]): tuple[bridge, rest: PersistentSequenceNode[T, F]] =
        ## 最初の節点の複製と残りを返します。時間・追加領域O(log(N+1))。
        let a = c.copyPushed(n)
        if a.left == nil:
            let rest = a.right
            a.right = nil
            return (a, rest)
        let p = c.removeFirst(a.left)
        a.left = p.rest
        (p.bridge, c.balanceOwned(a))

    proc removeLast[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]): tuple[bridge, rest: PersistentSequenceNode[T, F]] =
        ## 最後の節点の複製と残りを返します。時間・追加領域O(log(N+1))。
        let a = c.copyPushed(n)
        if a.right == nil:
            let rest = a.left
            a.left = nil
            return (a, rest)
        let p = c.removeLast(a.right)
        a.right = p.rest
        (p.bridge, c.balanceOwned(a))

    proc concatNode[T, F](c: PersistentSequenceContext[T, F], a, b: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 低い側の端節点を橋にして連結します。時間・追加領域O(log(N+1))。
        if a == nil: return b
        if b == nil: return a
        if a.nodeHeight < b.nodeHeight:
            let p = c.removeLast(a)
            return c.joinOwned(p.rest, p.bridge, b)
        let p = c.removeFirst(b)
        c.joinOwned(a, p.bridge, p.rest)

    proc buildNodes[T, F](c: PersistentSequenceContext[T, F], values: openArray[T], l, r: int): PersistentSequenceNode[T, F] =
        ## 入力を保持・再コピーせず中央分割で木を構築します。全体O(N)。
        if l == r: return nil
        let m = l + (r - l) div 2
        c.makeNode(c.buildNodes(values, l, m), values[m], c.buildNodes(values, m + 1, r))

    proc from_seq*[T, F](s: PersistentSequence[T, F], values: openArray[T]): PersistentSequence[T, F] =
        ## 同じ演算設定を共有する別の列をO(N)で構築します。入力の格納配列は保持しません。
        s.checked
        result.context = s.context
        result.root = s.context.buildNodes(values, 0, values.len)

    proc initPersistentLazySequence*[T, F](values: openArray[T], op: proc(a, b: T): T, e: T,
            mapping: proc(f: F, x: T): T, aggregateMapping: proc(f: F, x: T, length: int): T,
            composition: proc(f, g: F): F, id: F): PersistentSequence[T, F] =
        ## モノイドと点ごとの作用を持つ永続列をO(N)で構築します。composition(f,g)はgの後にfです。
        ## 演算は純粋かつO(1)、作用は積・反転と両立することが前提です。
        if op == nil or mapping == nil or aggregateMapping == nil or composition == nil:
            raise newException(ValueError, "演算が未指定です")
        result.context = PersistentSequenceContext[T, F](op: op, e: e, mapping: mapping,
            aggregateMapping: aggregateMapping, composition: composition, id: id, monoid: true)
        result = result.from_seq(values)

    proc initPersistentSequence*[T](values: openArray[T], op: proc(a, b: T): T, e: T): PersistentSequence[T, PersistentSequenceNoAction] =
        ## モノイド永続列をO(N)で構築します。opは結合的、eは単位元とします。
        initPersistentLazySequence(values, op, e,
            proc(f: PersistentSequenceNoAction, x: T): T = x,
            proc(f: PersistentSequenceNoAction, x: T, length: int): T = x,
            proc(f, g: PersistentSequenceNoAction): PersistentSequenceNoAction = f, PersistentSequenceNoAction())

    proc initPersistentSequence*[T](values: openArray[T]): PersistentSequence[T, PersistentSequenceNoAction] =
        ## 集約を持たない永続列をO(N)で構築します。prod/get_allは利用できません。
        result.context = PersistentSequenceContext[T, PersistentSequenceNoAction](
            mapping: proc(f: PersistentSequenceNoAction, x: T): T = x,
            composition: proc(f, g: PersistentSequenceNoAction): PersistentSequenceNoAction = f)
        result = result.from_seq(values)

    proc withRoot[T, F](s: PersistentSequence[T, F], root: PersistentSequenceNode[T, F]): PersistentSequence[T, F] =
        ## 演算設定を共有する版をO(1)で返します。
        PersistentSequence[T, F](root: root, context: s.context)

    proc split*[T, F](s: PersistentSequence[T, F], k: int): tuple[left, right: PersistentSequence[T, F]] =
        ## 先頭k個と残りを返します。元の版は不変です。時間・追加領域O(log(N+1))。
        s.checkRange(k, k)
        let p = s.context.splitNode(s.root, k)
        (s.withRoot(p.left), s.withRoot(p.right))

    proc concat*[T, F](a, b: PersistentSequence[T, F]): PersistentSequence[T, F] =
        ## 同じ設定から派生した列を連結します。同一・重複部分木も可。時間・追加領域O(log(N+1))。
        a.checked
        b.checked
        if a.context != b.context: raise newException(ValueError, "concatには同じ演算設定が必要です。from_seqを使用してください")
        if b.len > high(int) - a.len: raise newException(ValueError, "永続列の長さがintに収まりません")
        a.withRoot(a.context.concatNode(a.root, b.root))

    proc insert*[T, F](s: PersistentSequence[T, F], k: int, value: T): PersistentSequence[T, F] =
        ## kの直前に値を挿入した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(k, k)
        if s.len == high(int): raise newException(ValueError, "永続列の長さがintに収まりません")
        proc visit(n: PersistentSequenceNode[T, F], p: int): PersistentSequenceNode[T, F] =
            ## 挿入経路だけを複製して平衡化します。全体O(log(N+1))。
            if n == nil: return s.context.makeNode(nil, value, nil)
            let a = s.context.copyPushed(n)
            let ls = a.left.nodeSize
            if p <= ls:
                a.left = visit(a.left, p)
                return s.context.balanceOwned(a, leftOwned = true)
            a.right = visit(a.right, p - ls - 1)
            s.context.balanceOwned(a, rightOwned = true)
        s.withRoot(visit(s.root, k))

    proc erase*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間[l,r)を削除した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if l == r: return s
        let p = s.context.splitNode(s.root, l)
        let q = s.context.splitNode(p.right, r - l)
        s.withRoot(s.context.concatNode(p.left, q.right))

    proc erase*[T, F](s: PersistentSequence[T, F], k: int): PersistentSequence[T, F] =
        ## k番目の値を削除した版を返します。時間・追加領域O(log(N+1))。
        if k < 0 or k >= s.len: raise newException(ValueError, "添字が範囲外です")
        proc visit(n: PersistentSequenceNode[T, F], p: int): PersistentSequenceNode[T, F] =
            ## 削除経路のみ複製し、削除節点の左右を連結します。全体O(log(N+1))。
            let ls = n.left.nodeSize
            if p == ls:
                let left = s.context.tagged(n.left, n.lazy, n.pending, n.reversed)
                let right = s.context.tagged(n.right, n.lazy, n.pending, n.reversed)
                return s.context.concatNode(left, right)
            let a = s.context.copyPushed(n)
            if p < ls: a.left = visit(a.left, p)
            else: a.right = visit(a.right, p - ls - 1)
            s.context.balanceOwned(a)
        s.withRoot(visit(s.root, k))

    proc slice*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間[l,r)だけを共有した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        let p = s.context.splitNode(s.root, l)
        s.withRoot(s.context.splitNode(p.right, r - l).left)

    proc apply*[T, F](s: PersistentSequence[T, F], l, r: int, f: F): PersistentSequence[T, F] =
        ## 半開区間に点ごとの作用を適用した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if l == r: return s
        proc visit(n: PersistentSequenceNode[T, F], a, b: int, carry: F,
                   pending, flip: bool): PersistentSequenceNode[T, F] =
            ## 境界へは作用を引数で渡し、採用する結果の節点だけを複製します。
            if a == 0 and b == n.size:
                let combined = if pending: s.context.composition(f, carry) else: f
                return s.context.tagged(n, combined, true, flip)
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let ls = left.nodeSize
            let next = if n.pending: (if pending: s.context.composition(carry, n.lazy) else: n.lazy) else: carry
            let nextPending = pending or n.pending
            let nextFlip = flip xor n.reversed
            var value = if pending: s.context.mapping(carry, n.value) else: n.value
            if a <= ls and ls < b: value = s.context.mapping(f, value)
            let l = if a < ls: visit(left, a, min(b, ls), next, nextPending, nextFlip)
                    else: s.context.tagged(left, next, nextPending, nextFlip)
            let r = if b > ls + 1: visit(right, max(0, a - ls - 1), b - ls - 1, next, nextPending, nextFlip)
                    else: s.context.tagged(right, next, nextPending, nextFlip)
            s.context.makeNode(l, value, r)
        s.withRoot(visit(s.root, l, r, s.context.id, false, false))

    proc reverse*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間を反転した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if r - l < 2: return s
        if l == 0 and r == s.len: return s.withRoot(flipped(s.root))
        let p = s.context.cutEnds(s.root, l, r, s.context.id, false, false)
        let a = s.context.joinOwned(p.left, p.last, flipped(p.middle))
        s.withRoot(s.context.joinOwned(a, p.first, p.right))

    proc mapped[T, F](c: PersistentSequenceContext[T, F], f: F, value: T): T {.inline.} =
        ## NoActionでは恒等作用の呼び出しを省きます。O(1)。
        when F is PersistentSequenceNoAction: value
        else: c.mapping(f, value)

    proc mappedAggregate[T, F](c: PersistentSequenceContext[T, F], f: F, value: T, length: int): T {.inline.} =
        ## NoActionでは集約への恒等作用を省きます。O(1)。
        when F is PersistentSequenceNoAction: value
        else: c.aggregateMapping(f, value, length)

    proc childCarry[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], carry: F): F {.inline.} =
        ## 読み取り時の祖先作用をO(1)で合成します。
        when F is PersistentSequenceNoAction: c.id
        else:
            if n.pending: c.composition(carry, n.lazy) else: carry

    proc get*[T, F](s: PersistentSequence[T, F], k: int): T =
        ## k番目の値を節点の変更・複製なしにO(log(N+1))で取得します。
        if k < 0 or k >= s.len: raise newException(ValueError, "添字が範囲外です")
        var n = s.root
        var p = k
        var carry = s.context.id
        var flip = false
        while true:
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let ls = left.nodeSize
            if p == ls: return s.context.mapped(carry, n.value)
            carry = s.context.childCarry(n, carry)
            flip = flip xor n.reversed
            if p < ls: n = left
            else:
                p -= ls + 1
                n = right

    proc `[]`*[T, F](s: PersistentSequence[T, F], k: int): T =
        ## k番目の値をO(log(N+1))で返します。
        s.get(k)

    proc update*[T, F](s: PersistentSequence[T, F], k: int, value: T): PersistentSequence[T, F] =
        ## k番目を置き換えた版を返します。時間・追加領域O(log(N+1))。
        if k < 0 or k >= s.len: raise newException(ValueError, "添字が範囲外です")
        proc visit(n: PersistentSequenceNode[T, F], p: int): PersistentSequenceNode[T, F] =
            ## 更新経路だけを複製します。全体O(log(N+1))。
            let a = s.context.copyPushed(n)
            let ls = a.left.nodeSize
            if p < ls: a.left = visit(a.left, p)
            elif p == ls: a.value = value
            else: a.right = visit(a.right, p - ls - 1)
            s.context.refresh(a)
            a
        s.withRoot(visit(s.root, k))

    proc `[]=`*[T, F](s: var PersistentSequence[T, F], k: int, value: T) =
        ## 変数だけを更新後の版に差し替えます。保存済みの版は不変です。O(log(N+1))。
        s = s.update(k, value)

    proc prod*[T, F](s: PersistentSequence[T, F], l, r: int): T =
        ## 半開区間の順序付き積を節点の変更・複製なしにO(log(N+1))で返します。
        s.checkRange(l, r)
        if not s.context.monoid: raise newException(ValueError, "モノイドが未指定です")
        proc visit(n: PersistentSequenceNode[T, F], a, b: int, carry: F, flip: bool): T =
            ## 順逆の集約と祖先作用を使って境界経路のみ読み取ります。
            if a == b: return s.context.e
            if a == 0 and b == n.size:
                return s.context.mappedAggregate(carry, (if flip: n.backward else: n.forward), n.size)
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let ls = left.nodeSize
            let next = s.context.childCarry(n, carry)
            let reversed = flip xor n.reversed
            result = s.context.e
            if a < ls: result = visit(left, a, min(b, ls), next, reversed)
            if a <= ls and ls < b: result = s.context.op(result, s.context.mapped(carry, n.value))
            if b > ls + 1: result = s.context.op(result, visit(right, max(0, a - ls - 1), b - ls - 1, next, reversed))
        if l == r: return s.context.e
        visit(s.root, l, r, s.context.id, false)

    proc get_all*[T, F](s: PersistentSequence[T, F]): T =
        ## 全体の積をO(1)で返します。空列では単位元です。
        s.checked
        if not s.context.monoid: raise newException(ValueError, "モノイドが未指定です")
        if s.root == nil: s.context.e else: s.root.forward

    proc to_seq*[T, F](s: PersistentSequence[T, F]): seq[T] =
        ## 値を順に列挙します。時間・返り値の領域O(N)、再帰領域O(log(N+1))。
        s.checked
        result = newSeqOfCap[T](s.len)
        proc visit(n: PersistentSequenceNode[T, F], carry: F, flip: bool, output: var seq[T]) =
            ## 祖先の作用と反転だけを渡し、共有節点を読み取ります。
            if n == nil: return
            let next = s.context.childCarry(n, carry)
            let reversed = flip xor n.reversed
            visit((if flip: n.right else: n.left), next, reversed, output)
            output.add(s.context.mapped(carry, n.value))
            visit((if flip: n.left else: n.right), next, reversed, output)
        visit(s.root, s.context.id, false, result)

    proc partition_point*[T, F](s: PersistentSequence[T, F], predicate: proc(x: T): bool): int =
        ## trueからfalseに変わる最初の位置をO(log(N+1))で返します。判定は単調かつ純粋とします。
        s.checked
        if predicate == nil: raise newException(ValueError, "判定関数が未指定です")
        var n = s.root
        var carry = s.context.id
        var flip = false
        while n != nil:
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let take = predicate(s.context.mapped(carry, n.value))
            carry = s.context.childCarry(n, carry)
            flip = flip xor n.reversed
            if take:
                result += left.nodeSize + 1
                n = right
            else: n = left
