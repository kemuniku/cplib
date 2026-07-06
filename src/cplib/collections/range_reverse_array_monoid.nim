when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY_MONOID:
    const CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY_MONOID* = 1
    import random, strutils

    randomize()

    type RangeReverseArrayMonoidNode[T] {.acyclic.} = ref object
        left, right: RangeReverseArrayMonoidNode[T]
        priority: uint64
        size: int
        rev: bool
        value, prod, rprod: T

    type RangeReverseArrayMonoid*[T] = ref object
        root: RangeReverseArrayMonoidNode[T]
        length: int
        op: proc(x, y: T): T
        e: T

    proc nodeLen[T](node: RangeReverseArrayMonoidNode[T]): int {.inline.} =
        if node.isNil: 0 else: node.size

    proc nodeProd[T](node: RangeReverseArrayMonoidNode[T], e: T): T {.inline.} =
        if node.isNil: e else: node.prod

    proc nodeRProd[T](node: RangeReverseArrayMonoidNode[T], e: T): T {.inline.} =
        if node.isNil: e else: node.rprod

    proc update[T](node: RangeReverseArrayMonoidNode[T], op: proc(x, y: T): T, e: T) =
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.prod = op(op(node.left.nodeProd(e), node.value), node.right.nodeProd(e))
        node.rprod = op(op(node.right.nodeRProd(e), node.value), node.left.nodeRProd(e))

    proc toggle[T](node: RangeReverseArrayMonoidNode[T]) =
        if not node.isNil:
            node.rev = not node.rev
            let tmp = node.prod
            node.prod = node.rprod
            node.rprod = tmp

    proc push[T](node: RangeReverseArrayMonoidNode[T]) =
        if node.isNil or not node.rev: return
        let tmp = node.left
        node.left = node.right
        node.right = tmp
        node.left.toggle
        node.right.toggle
        node.rev = false

    proc newNode[T](value: T, priority: uint64): RangeReverseArrayMonoidNode[T] =
        RangeReverseArrayMonoidNode[T](priority: priority, size: 1, value: value, prod: value, rprod: value)

    proc updateAll[T](node: RangeReverseArrayMonoidNode[T], op: proc(x, y: T): T, e: T) =
        if node.isNil: return
        node.left.updateAll(op, e)
        node.right.updateAll(op, e)
        node.update(op, e)

    proc build[T](v: openArray[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoidNode[T] =
        var stack: seq[RangeReverseArrayMonoidNode[T]]
        for i in 0..<v.len:
            let node = newNode(v[i], rand(uint64))
            var last: RangeReverseArrayMonoidNode[T] = nil
            while stack.len > 0 and stack[^1].priority < node.priority:
                last = stack.pop()
            node.left = last
            if stack.len > 0:
                stack[^1].right = node
            stack.add(node)
        if stack.len == 0:
            return nil
        result = stack[0]
        result.updateAll(op, e)

    proc merge[T](left, right: RangeReverseArrayMonoidNode[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoidNode[T] =
        if left.isNil: return right
        if right.isNil: return left
        if left.priority > right.priority:
            left.push
            left.right = merge(left.right, right, op, e)
            left.update(op, e)
            return left
        else:
            right.push
            right.left = merge(left, right.left, op, e)
            right.update(op, e)
            return right

    proc split[T](node: RangeReverseArrayMonoidNode[T], k: int, op: proc(x, y: T): T, e: T): (RangeReverseArrayMonoidNode[T], RangeReverseArrayMonoidNode[T]) =
        if node.isNil:
            return (nil, nil)
        node.push
        let leftSize = node.left.nodeLen
        if k <= leftSize:
            var (left, right) = split(node.left, k, op, e)
            node.left = right
            node.update(op, e)
            return (left, node)
        else:
            var (left, right) = split(node.right, k - leftSize - 1, op, e)
            node.right = left
            node.update(op, e)
            return (node, right)

    proc initRangeReverseArrayMonoid*[T](v: openArray[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoid[T] =
        ## vで初期化します。
        ## 区間反転、一点取得、一点更新、区間総積はすべてO(log N)です。
        RangeReverseArrayMonoid[T](root: build(v, op, e), length: v.len, op: op, e: e)

    proc toRangeReverseArrayMonoid*[T](v: openArray[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoid[T] =
        initRangeReverseArrayMonoid(v, op, e)

    template newRangeReverseArrayMonoidWith*(V, op, e: untyped): untyped =
        initRangeReverseArrayMonoid[typeof(e)](V, proc (l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)

    proc len*[T](self: RangeReverseArrayMonoid[T]): int =
        self.length

    proc reverse*[T](self: RangeReverseArrayMonoid[T], l, r: int) =
        ## 半開区間[l, r)を反転します。
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = split(self.root, l, self.op, self.e)
        var (middle, right) = split(middleRight, r - l, self.op, self.e)
        middle.toggle
        self.root = merge(left, merge(middle, right, self.op, self.e), self.op, self.e)

    proc reverse*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]) =
        ## 閉区間segmentを反転します。
        self.reverse(segment.a, segment.b + 1)

    proc get*[T](self: RangeReverseArrayMonoid[T], index: int): T =
        ## index番目の値を返します。
        assert 0 <= index and index < self.length
        var node = self.root
        var k = index
        while true:
            node.push
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                return node.value
            else:
                k -= leftSize + 1
                node = node.right

    proc get*[T](self: RangeReverseArrayMonoid[T], l, r: int): T =
        ## 半開区間[l, r)の総積を返します。
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = split(self.root, l, self.op, self.e)
        var (middle, right) = split(middleRight, r - l, self.op, self.e)
        result = middle.nodeProd(self.e)
        self.root = merge(left, merge(middle, right, self.op, self.e), self.op, self.e)

    proc get*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]): T =
        ## 閉区間segmentの総積を返します。
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b + 1 <= self.length
        self.get(segment.a, segment.b + 1)

    proc fold*[T](self: RangeReverseArrayMonoid[T], l, r: int): T =
        self.get(l, r)

    proc fold*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]): T =
        self.get(segment)

    proc fold*[T](self: RangeReverseArrayMonoid[T]): T =
        self.root.nodeProd(self.e)

    proc get_all*[T](self: RangeReverseArrayMonoid[T]): T =
        ## [0,len(self))区間の総積をO(1)で返します。
        self.root.nodeProd(self.e)

    proc update*[T](self: RangeReverseArrayMonoid[T], index: Natural, value: T) =
        ## index番目の値をvalueに変更します。
        assert index < self.length
        var (left, middleRight) = split(self.root, int(index), self.op, self.e)
        var (middle, right) = split(middleRight, 1, self.op, self.e)
        middle.value = value
        middle.prod = value
        middle.rprod = value
        middle.update(self.op, self.e)
        self.root = merge(left, merge(middle, right, self.op, self.e), self.op, self.e)

    proc `[]`*[T](self: RangeReverseArrayMonoid[T], index: int): T =
        self.get(index)

    proc `[]`*[T](self: RangeReverseArrayMonoid[T], index: BackwardsIndex): T =
        self.get(self.length - int(index))

    proc `[]`*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]): T =
        self.get(segment)

    proc `[]=`*[T](self: RangeReverseArrayMonoid[T], index: Natural, value: T) =
        self.update(index, value)

    iterator items*[T](self: RangeReverseArrayMonoid[T]): T =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                var (t, node) = stack.pop()
                node.push
                if t == 0:
                    if not node.right.isNil: stack.add((0, node.right))
                    stack.add((1, node))
                    if not node.left.isNil: stack.add((0, node.left))
                else:
                    yield node.value

    proc toSeq*[T](self: RangeReverseArrayMonoid[T]): seq[T] =
        for x in self:
            result.add(x)

    proc `$`*[T](self: RangeReverseArrayMonoid[T]): string =
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
