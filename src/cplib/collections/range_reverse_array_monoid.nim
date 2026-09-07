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
        ## 区間反転、一点取得、一点更新、区間総積はすべて期待O(log N)です。
        RangeReverseArrayMonoid[T](root: build(v, op, e), length: v.len, op: op, e: e)

    proc toRangeReverseArrayMonoid*[T](v: openArray[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoid[T] =
        initRangeReverseArrayMonoid(v, op, e)

    template newRangeReverseArrayMonoidWith*(V, op, e: untyped): untyped =
        initRangeReverseArrayMonoid[typeof(e)](V, proc (l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)

    proc len*[T](self: RangeReverseArrayMonoid[T]): int =
        self.length

    proc insertNode[T](self: RangeReverseArrayMonoid[T], root, node: RangeReverseArrayMonoidNode[T], k: int): RangeReverseArrayMonoidNode[T] =
        if root.isNil: return node
        if node.priority > root.priority:
            (node.left, node.right) = split(root, k, self.op, self.e)
            node.update(self.op, self.e)
            return node
        root.push
        let leftSize = root.left.nodeLen
        if k <= leftSize:
            root.left = self.insertNode(root.left, node, k)
        else:
            root.right = self.insertNode(root.right, node, k - leftSize - 1)
        root.update(self.op, self.e)
        return root

    proc insert*[T](self: RangeReverseArrayMonoid[T], index: int, value: T) =
        ## index の直前に挿入する。index = len なら末尾。
        assert 0 <= index and index <= self.len
        let node = newNode(value, rand(uint64))
        self.root = self.insertNode(self.root, node, index)
        inc self.length

    proc eraseNode[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], k: int): RangeReverseArrayMonoidNode[T] =
        node.push
        let leftSize = node.left.nodeLen
        if k == leftSize: return merge(node.left, node.right, self.op, self.e)
        if k < leftSize:
            node.left = self.eraseNode(node.left, k)
        else:
            node.right = self.eraseNode(node.right, k - leftSize - 1)
        node.update(self.op, self.e)
        return node

    proc erase*[T](self: RangeReverseArrayMonoid[T], index: int) =
        assert 0 <= index and index < self.len
        self.root = self.eraseNode(self.root, index)
        dec self.length

    proc erase*[T](self: RangeReverseArrayMonoid[T], l, r: int) =
        assert 0 <= l and l <= r and r <= self.len
        if l == r: return
        let (left, rest) = split(self.root, l, self.op, self.e)
        let (_, right) = split(rest, r - l, self.op, self.e)
        self.root = merge(left, right, self.op, self.e)
        self.length -= r - l

    proc erase*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]) =
        self.erase(segment.a, segment.b + 1)

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

    proc getNode[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], l, r: int): T =
        if l == 0 and r == node.size: return node.prod
        node.push
        let mid = node.left.nodeLen
        if r <= mid: return self.getNode(node.left, l, r)
        if l > mid: return self.getNode(node.right, l - mid - 1, r - mid - 1)
        result = node.value
        if l < mid: result = self.op(self.getNode(node.left, l, mid), result)
        if r > mid + 1: result = self.op(result, self.getNode(node.right, 0, r - mid - 1))

    proc get*[T](self: RangeReverseArrayMonoid[T], l, r: int): T =
        ## 半開区間 [l, r) の総積を返す。
        assert 0 <= l and l <= r and r <= self.len
        if l == r: return self.e
        self.getNode(self.root, l, r)

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

    proc updateNode[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], k: int, value: T) =
        node.push
        let leftSize = node.left.nodeLen
        if k == leftSize:
            node.value = value
        elif k < leftSize:
            self.updateNode(node.left, k, value)
        else:
            self.updateNode(node.right, k - leftSize - 1, value)
        node.update(self.op, self.e)

    proc update*[T](self: RangeReverseArrayMonoid[T], index: Natural, value: T) =
        ## index 番目の値を value に変更する。
        assert index < self.len
        self.updateNode(self.root, index, value)

    proc searchRight[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], start, l: int, acc: var T, f: proc(x: T): bool): int =
        let finish = start + node.nodeLen
        if node.isNil or finish <= l: return finish
        if l <= start:
            let next = self.op(acc, node.prod)
            if f(next):
                acc = next
                return finish
        node.push
        let mid = start + node.left.nodeLen
        result = self.searchRight(node.left, start, l, acc, f)
        if result < mid: return
        if l <= mid:
            let next = self.op(acc, node.value)
            if not f(next): return mid
            acc = next
        result = self.searchRight(node.right, mid + 1, l, acc, f)

    proc max_right*[T](self: RangeReverseArrayMonoid[T], l: int, f: proc(x: T): bool): int =
        ## f(get(l, r)) が真となる最大の r を返す。
        ## f(e) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= l and l <= self.len
        assert f(self.e)
        var acc = self.e
        self.searchRight(self.root, 0, l, acc, f)

    proc searchLeft[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], start, r: int, acc: var T, f: proc(x: T): bool): int =
        if node.isNil or r <= start: return start
        if start + node.size <= r:
            let next = self.op(node.prod, acc)
            if f(next):
                acc = next
                return start
        node.push
        let mid = start + node.left.nodeLen
        result = self.searchLeft(node.right, mid + 1, r, acc, f)
        if result > mid + 1: return
        if mid < r:
            let next = self.op(node.value, acc)
            if not f(next): return mid + 1
            acc = next
        result = self.searchLeft(node.left, start, r, acc, f)

    proc min_left*[T](self: RangeReverseArrayMonoid[T], r: int, f: proc(x: T): bool): int =
        ## f(get(l, r)) が真となる最小の l を返す。
        ## f(e) = true で、区間を伸ばしたとき真から偽への変化が単調であること。
        assert 0 <= r and r <= self.len
        assert f(self.e)
        var acc = self.e
        self.searchLeft(self.root, 0, r, acc, f)

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
