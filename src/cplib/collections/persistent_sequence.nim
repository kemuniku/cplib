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
        new(result)
        result[] = n[]

    proc acted[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], f: F): PersistentSequenceNode[T, F] =
        ## 複製した節点にのみ作用します。時間・追加領域O(1)。
        if n == nil: return nil
        result = cloneNode(n)
        result.value = c.mapping(f, n.value)
        if c.monoid:
            result.forward = c.aggregateMapping(f, n.forward, n.size)
            result.backward = c.aggregateMapping(f, n.backward, n.size)
        result.lazy = if n.pending: c.composition(f, n.lazy) else: f
        result.pending = true

    proc flipped[T, F](n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 節点を複製して左右と順逆集約を反転します。時間・追加領域O(1)。
        if n == nil: return nil
        result = cloneNode(n)
        swap(result.left, result.right)
        swap(result.forward, result.backward)
        result.reversed = not result.reversed

    proc pushed[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 子を複製して遅延情報を伝播します。共有節点は変更しません。O(1)。
        if not n.pending and not n.reversed: return n
        result = cloneNode(n)
        if n.pending:
            result.left = c.acted(result.left, n.lazy)
            result.right = c.acted(result.right, n.lazy)
        if n.reversed:
            result.left = flipped(result.left)
            result.right = flipped(result.right)
        result.pending = false
        result.reversed = false
        result.lazy = c.id

    proc balanced[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                       value: T, right: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 高さの差が高々2の部分木を回転で平衡化します。時間・追加領域O(1)。
        if left.nodeHeight > right.nodeHeight + 1:
            let a = c.pushed(left)
            if a.left.nodeHeight >= a.right.nodeHeight:
                return c.makeNode(a.left, a.value, c.makeNode(a.right, value, right))
            let b = c.pushed(a.right)
            return c.makeNode(c.makeNode(a.left, a.value, b.left), b.value, c.makeNode(b.right, value, right))
        if right.nodeHeight > left.nodeHeight + 1:
            let a = c.pushed(right)
            if a.right.nodeHeight >= a.left.nodeHeight:
                return c.makeNode(c.makeNode(left, value, a.left), a.value, a.right)
            let b = c.pushed(a.left)
            return c.makeNode(c.makeNode(left, value, b.left), b.value, c.makeNode(b.right, a.value, a.right))
        c.makeNode(left, value, right)

    proc joined[T, F](c: PersistentSequenceContext[T, F], left: PersistentSequenceNode[T, F],
                     value: T, right: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 高い側の経路を複製して連結します。時間・追加領域O(|高さ差|+1)。
        if left.nodeHeight > right.nodeHeight + 1:
            let a = c.pushed(left)
            return c.balanced(a.left, a.value, c.joined(a.right, value, right))
        if right.nodeHeight > left.nodeHeight + 1:
            let a = c.pushed(right)
            return c.balanced(c.joined(left, value, a.left), a.value, a.right)
        c.makeNode(left, value, right)

    proc splitNode[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F],
                        k: int): tuple[left, right: PersistentSequenceNode[T, F]] =
        ## 先頭k個で分割します。時間・追加領域O(log(N+1))。
        if k == 0: return (nil, n)
        if k == n.nodeSize: return (n, nil)
        let a = c.pushed(n)
        let ls = a.left.nodeSize
        if k <= ls:
            let parts = c.splitNode(a.left, k)
            return (parts.left, c.joined(parts.right, a.value, a.right))
        let parts = c.splitNode(a.right, k - ls - 1)
        (c.joined(a.left, a.value, parts.left), parts.right)

    proc removeFirst[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F]): tuple[value: T, rest: PersistentSequenceNode[T, F]] =
        ## 最初の値と残りを返します。時間・追加領域O(log(N+1))。
        let a = c.pushed(n)
        if a.left == nil: return (a.value, a.right)
        let p = c.removeFirst(a.left)
        (p.value, c.balanced(p.rest, a.value, a.right))

    proc concatNode[T, F](c: PersistentSequenceContext[T, F], a, b: PersistentSequenceNode[T, F]): PersistentSequenceNode[T, F] =
        ## 二つの部分木を連結します。時間・追加領域O(log(N+1))。
        if a == nil: return b
        if b == nil: return a
        let p = c.removeFirst(b)
        c.joined(a, p.value, p.rest)

    proc from_seq*[T, F](s: PersistentSequence[T, F], values: openArray[T]): PersistentSequence[T, F] =
        ## 同じ演算設定を共有する別の列をO(N)で構築します。入力の格納配列は保持しません。
        s.checked
        let copied = @values
        proc build(l, r: int): PersistentSequenceNode[T, F] =
            ## 中央分割でAVL木を構築します。全体O(N)。
            if l == r: return nil
            let m = l + (r - l) div 2
            s.context.makeNode(build(l, m), copied[m], build(m + 1, r))
        result.context = s.context
        result.root = build(0, values.len)

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
        let p = s.context.splitNode(s.root, k)
        s.withRoot(s.context.joined(p.left, value, p.right))

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
        s.erase(k, k + 1)

    proc slice*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間[l,r)だけを共有した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        let p = s.context.splitNode(s.root, l)
        s.withRoot(s.context.splitNode(p.right, r - l).left)

    proc apply*[T, F](s: PersistentSequence[T, F], l, r: int, f: F): PersistentSequence[T, F] =
        ## 半開区間に点ごとの作用を適用した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if l == r: return s
        let p = s.context.splitNode(s.root, l)
        let q = s.context.splitNode(p.right, r - l)
        s.withRoot(s.context.concatNode(s.context.concatNode(p.left, s.context.acted(q.left, f)), q.right))

    proc reverse*[T, F](s: PersistentSequence[T, F], l, r: int): PersistentSequence[T, F] =
        ## 半開区間を反転した版を返します。時間・追加領域O(log(N+1))。
        s.checkRange(l, r)
        if l == r: return s
        let p = s.context.splitNode(s.root, l)
        let q = s.context.splitNode(p.right, r - l)
        s.withRoot(s.context.concatNode(s.context.concatNode(p.left, flipped(q.left)), q.right))

    proc childCarry[T, F](c: PersistentSequenceContext[T, F], n: PersistentSequenceNode[T, F], carry: F): F =
        ## 読み取り時の祖先作用をO(1)で合成します。
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
            if p == ls: return s.context.mapping(carry, n.value)
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
            let a = s.context.pushed(n)
            let ls = a.left.nodeSize
            if p < ls: return s.context.makeNode(visit(a.left, p), a.value, a.right)
            if p == ls: return s.context.makeNode(a.left, value, a.right)
            s.context.makeNode(a.left, a.value, visit(a.right, p - ls - 1))
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
                return s.context.aggregateMapping(carry, (if flip: n.backward else: n.forward), n.size)
            let left = if flip: n.right else: n.left
            let right = if flip: n.left else: n.right
            let ls = left.nodeSize
            let next = s.context.childCarry(n, carry)
            let reversed = flip xor n.reversed
            result = s.context.e
            if a < ls: result = visit(left, a, min(b, ls), next, reversed)
            if a <= ls and ls < b: result = s.context.op(result, s.context.mapping(carry, n.value))
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
            output.add(s.context.mapping(carry, n.value))
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
            let take = predicate(s.context.mapping(carry, n.value))
            carry = s.context.childCarry(n, carry)
            flip = flip xor n.reversed
            if take:
                result += left.nodeSize + 1
                n = right
            else: n = left
