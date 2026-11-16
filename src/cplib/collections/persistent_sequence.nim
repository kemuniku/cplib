when not declared CPLIB_COLLECTIONS_PERSISTENT_SEQUENCE:
    const CPLIB_COLLECTIONS_PERSISTENT_SEQUENCE* = 1

    import typetraits

    type PersistentSequenceNoAction* = object

    when defined(gcOrc):
        type
            PersistentSequenceNode[T, F] = ref object of RootObj
                when supportsCopyMem(tuple[value: T, action: F]):
                    left, right: PersistentSequencePlainNode[T, F]
                else:
                    left, right: PersistentSequenceNode[T, F]
                when F is PersistentSequenceNoAction:
                    size: int
                    value, forward, backward: T
                    lazy: F
                    height: uint8
                else:
                    height, size: int
                    value, forward, backward: T
                    lazy: F
                pending, reversed: bool
                leftReversed, rightReversed: bool
            PersistentSequencePlainNode[T, F] {.acyclic.} = ref object of PersistentSequenceNode[T, F]
    else:
        type PersistentSequenceNode[T, F] = ref object
            left, right: PersistentSequenceNode[T, F]
            height, size: int
            value, forward, backward: T
            lazy: F
            pending, reversed: bool
            leftReversed, rightReversed: bool

    type
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

    template nodeType(T, F: typedesc): typedesc =
        ## 管理参照を含まないT/Fだけ、構築する節点DAGが非循環であることを伝えます。
        ## 子は管理参照で所有し、既存節点から新規節点への参照を作らないので循環しません。
        ## string・seq・ref等を含むT/Fは通常の循環追跡を保持します。GC設定は変更しません。
        when defined(gcOrc):
            when supportsCopyMem(tuple[value: T, action: F]): PersistentSequencePlainNode[T, F]
            else: PersistentSequenceNode[T, F]
        else: PersistentSequenceNode[T, F]

    template childNode(T, F: typedesc, n: untyped): untyped =
        ## 子参照をO(1)で同じ内部型に戻します。全節点の実体はnodeTypeが選ぶ型です。
        when defined(gcOrc):
            when supportsCopyMem(tuple[value: T, action: F]):
                cast[PersistentSequencePlainNode[T, F]](n)
            else: n
        else: n

    proc nodeSize[T, F](n: PersistentSequenceNode[T, F]): int =
        ## 部分木の要素数をO(1)で返します。
        if n == nil: 0 else: n.size

    template nodeHeightType(F: typedesc): typedesc =
        ## ORCのNoActionだけ高さを圧縮し、refcと遅延作用付きは従来の配置を保ちます。
        when defined(gcOrc) and (F is PersistentSequenceNoAction): uint8
        else: int

    proc nodeHeight[T, F](n: PersistentSequenceNode[T, F]): int =
        ## 部分木の高さをO(1)で返します。
        ## AVLの最小要素数は高さ2ごとに倍増するため、int長さの木では高さは128未満です。
        ## ORCのNoActionだけ内部の高さをuint8で保持し、演算はintへ戻して行います。
        if n == nil: 0 else: n.height.int

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

    proc aggregateView[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], flip: bool): T {.inline.} =
        ## 子の反転を節点の複製なしに集約値へ反映します。O(1)。
        if n == nil: c.e
        elif flip: n.backward
        else: n.forward

    proc makeNode[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                       value: T, right: PersistentSequenceNode[T, F], leftReversed = false, rightReversed = false): PersistentSequenceNode[T, F] =
        ## 新しい節点を集約値とともに構築します。時間・追加領域O(1)。
        let ls = left.nodeSize
        let rs = right.nodeSize
        if ls == high(int) or rs > high(int) - ls - 1:
            raise newException(ValueError, "永続列の長さがintに収まりません")
        result = nodeType(T, F)(left: childNode(T, F, left), right: childNode(T, F, right), value: value,
            height: nodeHeightType(F)(max(left.nodeHeight, right.nodeHeight) + 1), size: ls + 1 + rs, lazy: c.id,
            leftReversed: leftReversed, rightReversed: rightReversed)
        if c.monoid:
            result.forward = c.op(c.op(c.aggregateView(left, leftReversed), value), c.aggregateView(right, rightReversed))
            result.backward = c.op(c.op(c.aggregateView(right, not rightReversed), value), c.aggregateView(left, not leftReversed))

    proc cloneNode[T, F](n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 節点のみをO(1)で複製し、子は共有します。
        nodeType(T, F)(left: childNode(T, F, n.left), right: childNode(T, F, n.right), height: n.height, size: n.size,
            value: n.value, forward: n.forward, backward: n.backward, lazy: n.lazy,
            pending: n.pending, reversed: n.reversed, leftReversed: n.leftReversed, rightReversed: n.rightReversed)

    proc refresh[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]) =
        ## 伝播済みの未公開根の要素数・高さ・集約値をO(1)で再計算します。
        let ls = n.left.nodeSize
        let rs = n.right.nodeSize
        if ls == high(int) or rs > high(int) - ls - 1:
            raise newException(ValueError, "永続列の長さがintに収まりません")
        n.size = ls + 1 + rs
        n.height = nodeHeightType(F)(max(n.left.nodeHeight, n.right.nodeHeight) + 1)
        if c.monoid:
            n.forward = c.op(c.op(c.aggregateView(n.left, n.leftReversed), n.value), c.aggregateView(n.right, n.rightReversed))
            n.backward = c.op(c.op(c.aggregateView(n.right, not n.rightReversed), n.value), c.aggregateView(n.left, not n.leftReversed))

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
            swap(result.leftReversed, result.rightReversed)
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
        swap(result.leftReversed, result.rightReversed)
        swap(result.forward, result.backward)
        result.reversed = not result.reversed

    proc copyPushed[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], flip = false): PersistentSequenceNode[T, F] =
        ## 根を複製し、子の反転は辺のboolに伝播して共有子を変更しません。時間・追加領域O(1)。
        ## 辺の反転は参照先の論理順に対する反転です。集約値にもこの向きを反映します。
        result = cloneNode(n)
        if flip:
            swap(result.left, result.right)
            swap(result.leftReversed, result.rightReversed)
            swap(result.forward, result.backward)
            result.reversed = not result.reversed
        if result.pending:
            result.left = childNode(T, F, c.tagged(result.left, result.lazy, true, false))
            result.right = childNode(T, F, c.tagged(result.right, result.lazy, true, false))
            result.pending = false
            result.lazy = c.id
        if result.reversed:
            result.leftReversed = not result.leftReversed
            result.rightReversed = not result.rightReversed
            result.reversed = false

    proc balanceOwned[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], leftOwned = false, rightOwned = false): PersistentSequenceNode[T, F] =
        ## 未公開の複製根だけを回転します。時間・追加領域O(1)。
        ## Owned=trueは今回の再帰で生成し、遅延を伝播済みの未公開根に限ります。
        ## 共有する子・孫は回転で変更する前に必ず複製します。
        if n.left.nodeHeight > n.right.nodeHeight + 1:
            let a = if leftOwned: n.left else: c.copyPushed(n.left, n.leftReversed)
            if a.left.nodeHeight >= a.right.nodeHeight:
                n.left = childNode(T, F, a.right)
                n.leftReversed = a.rightReversed
                a.right = childNode(T, F, n)
                a.rightReversed = false
                c.refresh(n)
                c.refresh(a)
                return a
            let b = c.copyPushed(a.right, a.rightReversed)
            a.right = childNode(T, F, b.left)
            a.rightReversed = b.leftReversed
            n.left = childNode(T, F, b.right)
            n.leftReversed = b.rightReversed
            b.left = childNode(T, F, a)
            b.leftReversed = false
            b.right = childNode(T, F, n)
            b.rightReversed = false
            c.refresh(a)
            c.refresh(n)
            c.refresh(b)
            return b
        if n.right.nodeHeight > n.left.nodeHeight + 1:
            let a = if rightOwned: n.right else: c.copyPushed(n.right, n.rightReversed)
            if a.right.nodeHeight >= a.left.nodeHeight:
                n.right = childNode(T, F, a.left)
                n.rightReversed = a.leftReversed
                a.left = childNode(T, F, n)
                a.leftReversed = false
                c.refresh(n)
                c.refresh(a)
                return a
            let b = c.copyPushed(a.left, a.leftReversed)
            n.right = childNode(T, F, b.left)
            n.rightReversed = b.leftReversed
            a.left = childNode(T, F, b.right)
            a.leftReversed = b.rightReversed
            b.left = childNode(T, F, n)
            b.leftReversed = false
            b.right = childNode(T, F, a)
            b.rightReversed = false
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
            let lf = leftFlip xor left.reversed xor (if leftFlip: left.rightReversed else: left.leftReversed)
            let rf = leftFlip xor left.reversed xor (if leftFlip: left.leftReversed else: left.rightReversed)
            let value = if leftPending: c.mapping(leftCarry, left.value) else: left.value
            let combined = c.joinView(r, next, pending, rf, bridge, right, rightCarry, rightPending, rightFlip)
            let a = nodeType(T, F)(left: childNode(T, F, c.tagged(l, next, pending, false)), right: childNode(T, F, combined), value: value, lazy: c.id, leftReversed: lf)
            return c.balanceOwned(a, rightOwned = true)
        if right.nodeHeight > left.nodeHeight + 1:
            let l = if rightFlip: right.right else: right.left
            let r = if rightFlip: right.left else: right.right
            let next = if right.pending: (if rightPending: c.composition(rightCarry, right.lazy) else: right.lazy) else: rightCarry
            let pending = rightPending or right.pending
            let lf = rightFlip xor right.reversed xor (if rightFlip: right.rightReversed else: right.leftReversed)
            let rf = rightFlip xor right.reversed xor (if rightFlip: right.leftReversed else: right.rightReversed)
            let value = if rightPending: c.mapping(rightCarry, right.value) else: right.value
            let combined = c.joinView(left, leftCarry, leftPending, leftFlip, bridge, l, next, pending, lf)
            let a = nodeType(T, F)(left: childNode(T, F, combined), right: childNode(T, F, c.tagged(r, next, pending, false)), value: value, lazy: c.id, rightReversed: rf)
            return c.balanceOwned(a, leftOwned = true)
        bridge.left = childNode(T, F, c.tagged(left, leftCarry, leftPending, false))
        bridge.right = childNode(T, F, c.tagged(right, rightCarry, rightPending, false))
        bridge.leftReversed = leftFlip
        bridge.rightReversed = rightFlip
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
        let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
        let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = nodeType(T, F)(value: value, lazy: c.id)
        if k <= ls:
            let parts = c.splitView(left, k, next, nextPending, lf)
            return (parts.left, c.joinView(parts.right, c.id, false, false, bridge, right, next, nextPending, rf))
        let parts = c.splitView(right, k - ls - 1, next, nextPending, rf)
        (c.joinView(left, next, nextPending, lf, bridge, parts.left, c.id, false, false), parts.right)

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
        let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
        let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = nodeType(T, F)(value: value, lazy: c.id)
        if k == ls:
            return (c.tagged(left, next, nextPending, lf), bridge, c.tagged(right, next, nextPending, rf))
        if k < ls:
            let p = c.takeView(left, k, next, nextPending, lf)
            return (p.left, p.bridge, c.joinView(p.right, c.id, false, false, bridge, right, next, nextPending, rf))
        let p = c.takeView(right, k - ls - 1, next, nextPending, rf)
        (c.joinView(left, next, nextPending, lf, bridge, p.left, c.id, false, false), p.bridge, p.right)

    proc cutEnds[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                       a, b: int, carry: F, pending, flip: bool): tuple[left, first, middle, last, right: PersistentSequenceNode[T, F]] =
        ## 長さ2以上の区間の両端を橋として分離し、共通境界経路を一度たどります。全体O(log(N+1))。
        let left = if flip: n.right else: n.left
        let right = if flip: n.left else: n.right
        let ls = left.nodeSize
        let next = if n.pending: (if pending: c.composition(carry, n.lazy) else: n.lazy) else: carry
        let nextPending = pending or n.pending
        let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
        let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
        let value = if pending: c.mapping(carry, n.value) else: n.value
        let bridge = nodeType(T, F)(value: value, lazy: c.id)
        if b <= ls:
            let p = c.cutEnds(left, a, b, next, nextPending, lf)
            return (p.left, p.first, p.middle, p.last, c.joinView(p.right, c.id, false, false, bridge, right, next, nextPending, rf))
        if a > ls:
            let p = c.cutEnds(right, a - ls - 1, b - ls - 1, next, nextPending, rf)
            return (c.joinView(left, next, nextPending, lf, bridge, p.left, c.id, false, false), p.first, p.middle, p.last, p.right)
        if a == ls:
            let p = c.takeView(right, b - ls - 2, next, nextPending, rf)
            return (c.tagged(left, next, nextPending, lf), bridge, p.left, p.bridge, p.right)
        if b == ls + 1:
            let p = c.takeView(left, a, next, nextPending, lf)
            return (p.left, p.bridge, p.right, bridge, c.tagged(right, next, nextPending, rf))
        let l = c.takeView(left, a, next, nextPending, lf)
        let r = c.takeView(right, b - ls - 2, next, nextPending, rf)
        (l.left, l.bridge, c.joinOwned(l.right, bridge, r.left), r.bridge, r.right)

    proc removeFirst[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], flip = false): tuple[bridge, rest: PersistentSequenceNode[T, F]] =
        ## 最初の節点の複製と残りを返します。時間・追加領域O(log(N+1))。
        let a = c.copyPushed(n, flip)
        if a.left == nil:
            let rest = c.tagged(a.right, c.id, false, a.rightReversed)
            a.right = childNode(T, F, nil)
            return (a, rest)
        let p = c.removeFirst(a.left, a.leftReversed)
        a.left = childNode(T, F, p.rest)
        a.leftReversed = false
        (p.bridge, c.balanceOwned(a))

    proc removeLast[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], flip = false): tuple[bridge, rest: PersistentSequenceNode[T, F]] =
        ## 最後の節点の複製と残りを返します。時間・追加領域O(log(N+1))。
        let a = c.copyPushed(n, flip)
        if a.right == nil:
            let rest = c.tagged(a.left, c.id, false, a.leftReversed)
            a.left = childNode(T, F, nil)
            return (a, rest)
        let p = c.removeLast(a.right, a.rightReversed)
        a.right = childNode(T, F, p.rest)
        a.rightReversed = false
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
        proc visit(n: PersistentSequenceNode[T, F], p: int, flip = false): PersistentSequenceNode[T, F] =
            ## 挿入経路だけを複製して平衡化します。全体O(log(N+1))。
            if n == nil: return s.context.makeNode(nil, value, nil)
            let a = s.context.copyPushed(n, flip)
            let ls = a.left.nodeSize
            if p <= ls:
                a.left = childNode(T, F, visit(a.left, p, a.leftReversed))
                a.leftReversed = false
                return s.context.balanceOwned(a, leftOwned = true)
            a.right = childNode(T, F, visit(a.right, p - ls - 1, a.rightReversed))
            a.rightReversed = false
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
        proc visit(n: PersistentSequenceNode[T, F], p: int, flip = false): PersistentSequenceNode[T, F] =
            ## 削除経路のみ複製します。全体O(log(N+1))。
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let ls = left.nodeSize
            if p == ls:
                let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
                let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
                return s.context.concatNode(s.context.tagged(left, n.lazy, n.pending, lf),
                    s.context.tagged(right, n.lazy, n.pending, rf))
            let a = s.context.copyPushed(n, flip)
            if p < ls:
                a.left = childNode(T, F, visit(a.left, p, a.leftReversed))
                a.leftReversed = false
            else:
                a.right = childNode(T, F, visit(a.right, p - ls - 1, a.rightReversed))
                a.rightReversed = false
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
            let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
            let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
            var value = if pending: s.context.mapping(carry, n.value) else: n.value
            if a <= ls and ls < b: value = s.context.mapping(f, value)
            let l = if a < ls: visit(left, a, min(b, ls), next, nextPending, lf)
                    else: s.context.tagged(left, next, nextPending, false)
            let r = if b > ls + 1: visit(right, max(0, a - ls - 1), b - ls - 1, next, nextPending, rf)
                    else: s.context.tagged(right, next, nextPending, false)
            s.context.makeNode(l, value, r, (if a < ls: false else: lf), (if b > ls + 1: false else: rf))
        s.withRoot(visit(s.root, l, r, s.context.id, false, false))

    proc reverse*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間を反転した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if r - l < 2: return s
        if l == 0 and r == s.len: return s.withRoot(flipped(s.root))
        let p = s.context.cutEnds(s.root, l, r, s.context.id, false, false)
        let a = s.context.joinView(p.left, s.context.id, false, false, p.last, p.middle, s.context.id, false, true)
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
            let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
            let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
            if p < ls:
                n = left
                flip = lf
            else:
                p -= ls + 1
                n = right
                flip = rf

    proc `[]`*[T, F](s: PersistentSequence[T, F], k: int): T =
        ## k番目の値をO(log(N+1))で返します。
        s.get(k)

    proc update*[T, F](s: PersistentSequence[T, F], k: int, value: T): PersistentSequence[T, F] =
        ## k番目を置き換えた版を返します。時間・追加領域O(log(N+1))。
        if k < 0 or k >= s.len: raise newException(ValueError, "添字が範囲外です")
        proc visit(n: PersistentSequenceNode[T, F], p: int, flip = false): PersistentSequenceNode[T, F] =
            ## 更新経路だけを複製します。全体O(log(N+1))。
            let a = s.context.copyPushed(n, flip)
            let ls = a.left.nodeSize
            if p < ls:
                a.left = childNode(T, F, visit(a.left, p, a.leftReversed))
                a.leftReversed = false
            elif p == ls: a.value = value
            else:
                a.right = childNode(T, F, visit(a.right, p - ls - 1, a.rightReversed))
                a.rightReversed = false
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
            let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
            let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
            result = s.context.e
            if a < ls: result = visit(left, a, min(b, ls), next, lf)
            if a <= ls and ls < b: result = s.context.op(result, s.context.mapped(carry, n.value))
            if b > ls + 1: result = s.context.op(result, visit(right, max(0, a - ls - 1), b - ls - 1, next, rf))
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
            let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
            let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
            visit((if flip: n.right else: n.left), next, lf, output)
            output.add(s.context.mapped(carry, n.value))
            visit((if flip: n.left else: n.right), next, rf, output)
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
            let lf = flip xor n.reversed xor (if flip: n.rightReversed else: n.leftReversed)
            let rf = flip xor n.reversed xor (if flip: n.leftReversed else: n.rightReversed)
            if take:
                result += left.nodeSize + 1
                n = right
                flip = rf
            else:
                n = left
                flip = lf
