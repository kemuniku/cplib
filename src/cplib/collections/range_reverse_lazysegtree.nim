when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_LAZYSEGTREE:
    const CPLIB_COLLECTIONS_RANGE_REVERSE_LAZYSEGTREE* = 1
    import random, sequtils, strutils

    randomize()

    type RangeReverseLazySegmentTreeNode[S, F] {.acyclic.} = ref object
        left, right: RangeReverseLazySegmentTreeNode[S, F]
        priority: uint64
        size: int
        rev: bool
        value, prod, rprod: S
        lazy: F

    type RangeReverseLazySegmentTree*[S, F] = ref object
        root: RangeReverseLazySegmentTreeNode[S, F]
        length: int
        merge: proc(x, y: S): S
        default: S
        mapping: proc(f: F, x: S): S
        composition: proc(f, g: F): F
        id: F

    proc nodeLen[S, F](node: RangeReverseLazySegmentTreeNode[S, F]): int {.inline.} =
        if node.isNil: 0 else: node.size

    proc nodeProd[S, F](node: RangeReverseLazySegmentTreeNode[S, F], default: S): S {.inline.} =
        if node.isNil: default else: node.prod

    proc nodeRProd[S, F](node: RangeReverseLazySegmentTreeNode[S, F], default: S): S {.inline.} =
        if node.isNil: default else: node.rprod

    proc update[S, F](node: RangeReverseLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S) =
        if node.isNil: return
        node.size = 1 + node.left.nodeLen + node.right.nodeLen
        node.prod = merge(merge(node.left.nodeProd(default), node.value), node.right.nodeProd(default))
        node.rprod = merge(merge(node.right.nodeRProd(default), node.value), node.left.nodeRProd(default))

    proc allApply[S, F](
        node: RangeReverseLazySegmentTreeNode[S, F],
        f: F,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F
    ) =
        if node.isNil: return
        node.value = mapping(f, node.value)
        node.prod = mapping(f, node.prod)
        node.rprod = mapping(f, node.rprod)
        node.lazy = composition(f, node.lazy)

    proc toggle[S, F](node: RangeReverseLazySegmentTreeNode[S, F]) =
        if not node.isNil:
            node.rev = not node.rev
            let tmp = node.prod
            node.prod = node.rprod
            node.rprod = tmp

    proc push[S, F](
        node: RangeReverseLazySegmentTreeNode[S, F],
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

    proc newNode[S, F](value: S, priority: uint64, id: F): RangeReverseLazySegmentTreeNode[S, F] =
        RangeReverseLazySegmentTreeNode[S, F](priority: priority, size: 1, value: value, prod: value, rprod: value, lazy: id)

    proc updateAll[S, F](
        node: RangeReverseLazySegmentTreeNode[S, F],
        merge: proc(x, y: S): S,
        default: S
    ) =
        if node.isNil: return
        node.left.updateAll(merge, default)
        node.right.updateAll(merge, default)
        node.update(merge, default)

    proc build[S, F](v: openArray[S], merge: proc(x, y: S): S, default: S, id: F): RangeReverseLazySegmentTreeNode[S, F] =
        var stack: seq[RangeReverseLazySegmentTreeNode[S, F]]
        for i in 0..<v.len:
            let node = newNode(v[i], rand(uint64), id)
            var last: RangeReverseLazySegmentTreeNode[S, F] = nil
            while stack.len > 0 and stack[^1].priority < node.priority:
                last = stack.pop()
            node.left = last
            if stack.len > 0:
                stack[^1].right = node
            stack.add(node)
        if stack.len == 0:
            return nil
        result = stack[0]
        result.updateAll(merge, default)

    proc mergeNode[S, F](
        left, right: RangeReverseLazySegmentTreeNode[S, F],
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseLazySegmentTreeNode[S, F] =
        if left.isNil: return right
        if right.isNil: return left
        if left.priority > right.priority:
            left.push(mapping, composition, id)
            left.right = mergeNode(left.right, right, merge, default, mapping, composition, id)
            left.update(merge, default)
            return left
        else:
            right.push(mapping, composition, id)
            right.left = mergeNode(left, right.left, merge, default, mapping, composition, id)
            right.update(merge, default)
            return right

    proc split[S, F](
        node: RangeReverseLazySegmentTreeNode[S, F],
        k: int,
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): (RangeReverseLazySegmentTreeNode[S, F], RangeReverseLazySegmentTreeNode[S, F]) =
        if node.isNil:
            return (nil, nil)
        node.push(mapping, composition, id)
        let leftSize = node.left.nodeLen
        if k <= leftSize:
            var (left, right) = split(node.left, k, merge, default, mapping, composition, id)
            node.left = right
            node.update(merge, default)
            return (left, node)
        else:
            var (left, right) = split(node.right, k - leftSize - 1, merge, default, mapping, composition, id)
            node.right = left
            node.update(merge, default)
            return (node, right)

    proc initRangeReverseLazySegmentTree*[S, F](
        v: openArray[S],
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseLazySegmentTree[S, F] =
        RangeReverseLazySegmentTree[S, F](
            root: build(v, merge, default, id),
            length: v.len,
            merge: merge,
            default: default,
            mapping: mapping,
            composition: composition,
            id: id
        )

    proc initRangeReverseLazySegmentTree*[S, F](
        n: int,
        merge: proc(x, y: S): S,
        default: S,
        mapping: proc(f: F, x: S): S,
        composition: proc(f, g: F): F,
        id: F
    ): RangeReverseLazySegmentTree[S, F] =
        initRangeReverseLazySegmentTree(newSeqWith(n, default), merge, default, mapping, composition, id)

    template newRangeReverseLazySegWith*(vOrN, merge, default, mapping, composition, id: untyped): untyped =
        type S = typeof(default)
        type F = typeof(id)
        initRangeReverseLazySegmentTree[S, F](
            vOrN,
            proc (l{.inject.}, r{.inject.}: S): S = merge,
            default, proc (f{.inject.}: F, x{.inject.}: S): S = mapping,
            proc (f{.inject.}, g{.inject.}: F): F = composition,
            id
        )

    proc len*[S, F](self: RangeReverseLazySegmentTree[S, F]): int =
        self.length

    proc mergeRoot[S, F](
        self: RangeReverseLazySegmentTree[S, F],
        left, right: RangeReverseLazySegmentTreeNode[S, F]
    ): RangeReverseLazySegmentTreeNode[S, F] =
        mergeNode(left, right, self.merge, self.default, self.mapping, self.composition, self.id)

    proc splitRoot[S, F](
        self: RangeReverseLazySegmentTree[S, F],
        node: RangeReverseLazySegmentTreeNode[S, F],
        k: int
    ): (RangeReverseLazySegmentTreeNode[S, F], RangeReverseLazySegmentTreeNode[S, F]) =
        split(node, k, self.merge, self.default, self.mapping, self.composition, self.id)

    proc reverse*[S, F](self: RangeReverseLazySegmentTree[S, F], l, r: int) =
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.toggle
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc reverse*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int, int]) =
        self.reverse(segment.a, segment.b + 1)

    proc apply*[S, F](self: RangeReverseLazySegmentTree[S, F], l, r: int, f: F) =
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        middle.allApply(f, self.mapping, self.composition)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc apply*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int, int], f: F) =
        self.apply(segment.a, segment.b + 1, f)

    proc get*[S, F](self: RangeReverseLazySegmentTree[S, F], l, r: int): S =
        assert 0 <= l and l <= r and r <= self.length
        var (left, middleRight) = self.splitRoot(self.root, l)
        var (middle, right) = self.splitRoot(middleRight, r - l)
        result = middle.nodeProd(self.default)
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc get*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        self.get(segment.a, segment.b + 1)

    proc fold*[S, F](self: RangeReverseLazySegmentTree[S, F], l, r: int): S =
        self.get(l, r)

    proc fold*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        self.get(segment)

    proc fold*[S, F](self: RangeReverseLazySegmentTree[S, F]): S =
        self.root.nodeProd(self.default)

    proc get_all*[S, F](self: RangeReverseLazySegmentTree[S, F]): S =
        self.root.nodeProd(self.default)

    proc get*[S, F](self: RangeReverseLazySegmentTree[S, F], index: int): S =
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

    proc update*[S, F](self: RangeReverseLazySegmentTree[S, F], index: Natural, value: S) =
        assert index < self.length
        var (left, middleRight) = self.splitRoot(self.root, int(index))
        var (middle, right) = self.splitRoot(middleRight, 1)
        middle.value = value
        middle.prod = value
        middle.rprod = value
        middle.lazy = self.id
        middle.rev = false
        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))

    proc `[]`*[S, F](self: RangeReverseLazySegmentTree[S, F], index: int): S =
        self.get(index)

    proc `[]`*[S, F](self: RangeReverseLazySegmentTree[S, F], index: BackwardsIndex): S =
        self.get(self.length - int(index))

    proc `[]`*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int, int]): S =
        self.get(segment)

    proc `[]=`*[S, F](self: RangeReverseLazySegmentTree[S, F], index: Natural, value: S) =
        self.update(index, value)

    iterator items*[S, F](self: RangeReverseLazySegmentTree[S, F]): S =
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

    proc toSeq*[S, F](self: RangeReverseLazySegmentTree[S, F]): seq[S] =
        for x in self:
            result.add(x)

    proc `$`*[S, F](self: RangeReverseLazySegmentTree[S, F]): string =
        var s: seq[string]
        for x in self:
            s.add($x)
        return s.join(" ")
