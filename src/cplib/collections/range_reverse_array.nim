when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY:
    const CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY* = 1
    import random, strutils

    randomize()

    type RangeReverseArrayNode[T] {.acyclic.} = ref object
        left, right: RangeReverseArrayNode[T]
        priority: uint64
        size: int
        rev: bool
        value: T

    type RangeReverseArray*[T] = ref object
        root: RangeReverseArrayNode[T]
        length: int

    proc nodeLen[T](node: RangeReverseArrayNode[T]): int {.inline.} =
        if node.isNil: 0 else: node.size

    proc update[T](node: RangeReverseArrayNode[T]) =
        node.size = 1 + node.left.nodeLen + node.right.nodeLen

    proc toggle[T](node: RangeReverseArrayNode[T]) =
        if not node.isNil:
            node.rev = not node.rev

    proc push[T](node: RangeReverseArrayNode[T]) =
        if node.isNil or not node.rev: return
        let tmp = node.left
        node.left = node.right
        node.right = tmp
        node.left.toggle
        node.right.toggle
        node.rev = false

    proc newNode[T](value: T, priority: uint64): RangeReverseArrayNode[T] =
        RangeReverseArrayNode[T](priority: priority, size: 1, value: value)

    proc updateAll[T](node: RangeReverseArrayNode[T]) =
        if node.isNil: return
        node.left.updateAll
        node.right.updateAll
        node.update

    proc build[T](v: openArray[T]): RangeReverseArrayNode[T] =
        var stack: seq[RangeReverseArrayNode[T]]
        for i in 0..<v.len:
            let node = newNode(v[i], rand(uint64))
            var last: RangeReverseArrayNode[T] = nil
            while stack.len > 0 and stack[^1].priority < node.priority:
                last = stack.pop()
            node.left = last
            if stack.len > 0:
                stack[^1].right = node
            stack.add(node)
        if stack.len == 0:
            return nil
        result = stack[0]
        result.updateAll

    proc merge[T](left, right: RangeReverseArrayNode[T]): RangeReverseArrayNode[T] =
        if left.isNil: return right
        if right.isNil: return left
        if left.priority > right.priority:
            left.push
            left.right = merge(left.right, right)
            left.update
            return left
        else:
            right.push
            right.left = merge(left, right.left)
            right.update
            return right

    proc split[T](node: RangeReverseArrayNode[T], k: int): (RangeReverseArrayNode[T], RangeReverseArrayNode[T]) =
        if node.isNil:
            return (nil, nil)
        node.push
        let leftSize = node.left.nodeLen
        if k <= leftSize:
            var (left, right) = split(node.left, k)
            node.left = right
            node.update
            return (left, node)
        else:
            var (left, right) = split(node.right, k - leftSize - 1)
            node.right = left
            node.update
            return (node, right)

    proc initRangeReverseArray*[T](v: openArray[T]): RangeReverseArray[T] =
        ## vで初期化します。
        ## 区間反転、一点取得、一点更新はすべてO(log N)です。
        RangeReverseArray[T](root: build(v), length: v.len)

    proc toRangeReverseArray*[T](v: openArray[T]): RangeReverseArray[T] =
        initRangeReverseArray(v)

    proc len*[T](self: RangeReverseArray[T]): int =
        self.length

    proc split*[T](self: RangeReverseArray[T], k: int): (RangeReverseArray[T], RangeReverseArray[T]) =
        ## 先頭 k 要素で分割し、元の列を空にします。期待 O(log N)。
        assert 0 <= k and k <= self.length, "0 <= k <= len が必要です"
        let n = self.length
        var root = move(self.root)
        let (leftRoot, rightRoot) = split(root, k)
        self.length = 0
        result = (RangeReverseArray[T](root: leftRoot, length: k), RangeReverseArray[T](root: rightRoot, length: n - k))

    proc merge*[T](left, right: RangeReverseArray[T]): RangeReverseArray[T] =
        ## 左右の列を連結し、両方の元の列を空にします。期待 O(log N)。
        assert left != right, "同じ列を連結できません"
        let n = left.length + right.length
        var leftRoot = move(left.root)
        var rightRoot = move(right.root)
        result = RangeReverseArray[T](root: merge(leftRoot, rightRoot), length: n)
        left.length = 0
        right.length = 0

    proc insert*[T](self: RangeReverseArray[T], index: int, value: T) =
        ## index の直前に挿入します。末尾には len を指定します。期待 O(log N)。
        assert 0 <= index and index <= self.length, "0 <= index <= len が必要です"
        let (left, right) = split(self.root, index)
        self.root = merge(left, merge(newNode(value, rand(uint64)), right))
        inc self.length

    proc insort*[T](self: RangeReverseArray[T], value: T, less: proc(x, y: T): bool): int {.discardable.} =
        ## ソート済みの列へ同値の末尾となる位置に挿入し、その位置を返します。期待 O(log N)。
        var node = self.root
        while not node.isNil:
            node.push
            if less(value, node.value):
                node = node.left
            else:
                result += node.left.nodeLen + 1
                node = node.right
        self.insert(result, value)

    proc insort*[T](self: RangeReverseArray[T], value: T): int {.discardable.} =
        ## < でソート済みの列へ同値の末尾となる位置に挿入します。期待 O(log N)。
        self.insort(value, proc(x, y: T): bool = x < y)

    proc reverse*[T](self: RangeReverseArray[T], l, r: int) =
        ## 半開区間[l, r)を反転します。
        assert 0 <= l and l <= r and r <= self.length, "指定した区間が有効な範囲内である必要があります: 0 <= l and l <= r and r <= self.length"
        var (left, middleRight) = split(self.root, l)
        var (middle, right) = split(middleRight, r - l)
        middle.toggle
        self.root = merge(left, merge(middle, right))

    proc reverse*[T](self: RangeReverseArray[T], segment: HSlice[int, int]) =
        ## 閉区間segmentを反転します。
        self.reverse(segment.a, segment.b + 1)

    proc get*[T](self: RangeReverseArray[T], index: int): T =
        ## index番目の値を返します。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
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

    proc update*[T](self: RangeReverseArray[T], index: int, value: T) =
        ## index番目の値をvalueに変更します。
        assert 0 <= index and index < self.length, "指定した値が有効な範囲内である必要があります: 0 <= index and index < self.length"
        var node = self.root
        var k = index
        while true:
            node.push
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                node.value = value
                return
            else:
                k -= leftSize + 1
                node = node.right

    proc `[]`*[T](self: RangeReverseArray[T], index: int): T =
        self.get(index)

    proc `[]`*[T](self: RangeReverseArray[T], index: BackwardsIndex): T =
        self.get(self.length - int(index))

    proc `[]=`*[T](self: RangeReverseArray[T], index: int, value: T) =
        self.update(index, value)

    proc `[]=`*[T](self: RangeReverseArray[T], index: BackwardsIndex, value: T) =
        self.update(self.length - int(index), value)

    iterator items*[T](self: RangeReverseArray[T]): T =
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

    proc toSeq*[T](self: RangeReverseArray[T]): seq[T] =
        for x in self:
            result.add(x)

    proc `$`*[T](self: RangeReverseArray[T]): string =
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
