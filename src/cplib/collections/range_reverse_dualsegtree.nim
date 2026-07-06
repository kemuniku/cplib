when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_DUALSEGTREE:
    const CPLIB_COLLECTIONS_RANGE_REVERSE_DUALSEGTREE* = 1
    import random, sequtils, strutils

    randomize()

    type RangeReverseDualSegmentTreeNode[S, F] {.acyclic.} = ref object
        left, right: RangeReverseDualSegmentTreeNode[S, F]
        priority: uint64
        size: int
        rev: bool
        value: S
        lazy: F

    type RangeReverseDualSegmentTree*[S, F] = ref object
        root: RangeReverseDualSegmentTreeNode[S, F]
        length: int
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F

    proc nodeLen[S, F](node: RangeReverseDualSegmentTreeNode[S, F]): int {.inline.} =
        if node.isNil: 0 else: node.size

    proc update[S, F](node: RangeReverseDualSegmentTreeNode[S, F]) =
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen

    proc allApply[S, F](
        node: RangeReverseDualSegmentTreeNode[S, F],
        f: F,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F
    ) =
        if node.isNil: return
        node.value = mapping(f, node.value)
        node.lazy = composition(f, node.lazy)

    proc toggle[S, F](node: RangeReverseDualSegmentTreeNode[S, F]) =
        if not node.isNil:
            node.rev = not node.rev

    proc push[S, F](
        node: RangeReverseDualSegmentTreeNode[S, F],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ) =
        if node.isNil: return
        if node.rev:
            let tmp = node.left
            node.left = node.right
            node.right = tmp
            node.left.toggle
            node.right.toggle
            node.rev = false
        node.left.allApply(node.lazy, mapping, composition)
        node.right.allApply(node.lazy, mapping, composition)
        node.lazy = id

    proc newNode[S, F](value: S, priority: uint64, id: F): RangeReverseDualSegmentTreeNode[S, F] =
        RangeReverseDualSegmentTreeNode[S, F](priority: priority, size: 1, value: value, lazy: id)

    proc updateAll[S, F](node: RangeReverseDualSegmentTreeNode[S, F]) =
        if node.isNil: return
        node.left.updateAll
        node.right.updateAll
        node.update

    proc build[S, F](v: openArray[S], id: F): RangeReverseDualSegmentTreeNode[S, F] =
        var stack: seq[RangeReverseDualSegmentTreeNode[S, F]]
        for i in 0..<v.len:
            let node = newNode(v[i], rand(uint64), id)
            var last: RangeReverseDualSegmentTreeNode[S, F] = nil
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

    proc mergeNode[S, F](
        left, right: RangeReverseDualSegmentTreeNode[S, F],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseDualSegmentTreeNode[S, F] =
        if left.isNil: return right
        if right.isNil: return left
        if left.priority > right.priority:
            left.push(mapping, composition, id)
            left.right = mergeNode(left.right, right, mapping, composition, id)
            left.update
            return left
        else:
            right.push(mapping, composition, id)
            right.left = mergeNode(left, right.left, mapping, composition, id)
            right.update
            return right

    proc split[S, F](
        node: RangeReverseDualSegmentTreeNode[S, F],
        k: int,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): (RangeReverseDualSegmentTreeNode[S, F], RangeReverseDualSegmentTreeNode[S, F]) =
        if node.isNil:
            return (nil, nil)
        node.push(mapping, composition, id)
        let leftSize = node.left.nodeLen
        if k <= leftSize:
            var (left, right) = split(node.left, k, mapping, composition, id)
            node.left = right
            node.update
            return (left, node)
        else:
            var (left, right) = split(node.right, k - leftSize - 1, mapping, composition, id)
            node.right = left
            node.update
            return (node, right)

    proc initRangeReverseDualSegmentTree*[S, F](
        v: openArray[S],
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseDualSegmentTree[S, F] =
        RangeReverseDualSegmentTree[S, F](root: build(v, id), length: v.len, mapping: mapping, composition: composition, id: id)

    proc initRangeReverseDualSegmentTree*[S, F](
        n: int,
        initValue: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseDualSegmentTree[S, F] =
        initRangeReverseDualSegmentTree(newSeqWith(n, initValue), mapping, composition, id)

    template newRangeReverseDualSegWith*(v, mapping, composition, id: untyped): untyped =
        type S = typeof(v[0])
        type F = typeof(id)
        initRangeReverseDualSegmentTree[S, F](
            v,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    template newRangeReverseDualSegWith*(n, initValue, mapping, composition, id: untyped): untyped =
        type S = typeof(initValue)
        type F = typeof(id)
        initRangeReverseDualSegmentTree[S, F](
            n,
            initValue,
            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    proc len*[S, F](self: RangeReverseDualSegmentTree[S, F]): int =
        self.length

    proc mergeRoot[S, F](
        self: RangeReverseDualSegmentTree[S, F],
        left, right: RangeReverseDualSegmentTreeNode[S, F]
    ): RangeReverseDualSegmentTreeNode[S, F] =
        mergeNode(left, right, self.mapping, self.composition, self.id)

    proc splitRoot[S, F](
        self: RangeReverseDualSegmentTree[S, F],
        node: RangeReverseDualSegmentTreeNode[S, F],
        k: int
    ): (RangeReverseDualSegmentTreeNode[S, F], RangeReverseDualSegmentTreeNode[S, F]) =
        split(node, k, self.mapping, self.composition, self.id)

    proc reverse*[S, F](self: RangeReverseDualSegmentTree[S, F], l, r: int) =
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.toggle
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc reverse*[S, F](self: RangeReverseDualSegmentTree[S, F], segment: HSlice[int, int]) =
        self.reverse(segment.a, segment.b + 1)

    proc apply*[S, F](self: RangeReverseDualSegmentTree[S, F], l, r: int, f: F) =
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.allApply(f, self.mapping, self.composition)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc apply*[S, F](self: RangeReverseDualSegmentTree[S, F], segment: HSlice[int, int], f: F) =
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: RangeReverseDualSegmentTree[S, F], index: int): S =
        assert 0 <= index and index < self.length
        var node = self.root
        var k = index
        while true:
            node.push(self.mapping, self.composition, self.id)
            let leftSize = node.left.nodeLen
            if k < leftSize:
                node = node.left
            elif k == leftSize:
                return node.value
            else:
                k -= leftSize + 1
                node = node.right

    proc update*[S, F](self: RangeReverseDualSegmentTree[S, F], index: Natural, value: S) =
        assert index < self.length
        var (left, middleRight) = self.splitRoot(self.root, int(index))
        var (middle, right) = self.splitRoot(middleRight, 1)
        middle.value = value
        middle.lazy = self.id
        middle.rev = false
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc `[]`*[S, F](self: RangeReverseDualSegmentTree[S, F], index: int): S =
        self.get(index)

    proc `[]`*[S, F](self: RangeReverseDualSegmentTree[S, F], index: BackwardsIndex): S =
        self.get(self.length - int(index))

    proc `[]=`*[S, F](self: RangeReverseDualSegmentTree[S, F], index: Natural, value: S) =
        self.update(index, value)

    iterator items*[S, F](self: RangeReverseDualSegmentTree[S, F]): S =
        if not self.root.isNil:
            var stack = @[(0, self.root)]
            while stack.len > 0:
                var (t, node) = stack.pop()
                node.push(self.mapping, self.composition, self.id)
                if t == 0:
                    if not node.right.isNil: stack.add((0, node.right))
                    stack.add((1, node))
                    if not node.left.isNil: stack.add((0, node.left))
                else:
                    yield node.value

    proc toSeq*[S, F](self: RangeReverseDualSegmentTree[S, F]): seq[S] =
        for x in self:
            result.add(x)

    proc `$`*[S, F](self: RangeReverseDualSegmentTree[S, F]): string =
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
