when not declared CPLIB_COLLECTIONS_THREE_SIDED_RANGE_TREE:
    const CPLIB_COLLECTIONS_THREE_SIDED_RANGE_TREE* = 1
    import options

    type
        ThreeSidedOwner = ref object
        ThreeSidedPointId*[X, Y] = ref object
            owner: ThreeSidedOwner
            serial: int
            live: bool
            x: X
            y: Y
        ThreeSidedPoint*[X, Y] = tuple[id: ThreeSidedPointId[X, Y], x: X, y: Y]
        ThreeSidedNode[K, V, X, Y] = ref object
            left, right: ThreeSidedNode[K, V, X, Y]
            height: int
            key: K
            value, minValue, maxValue: V
            point, minPoint, maxPoint: ThreeSidedPointId[X, Y]
        ThreeSidedRangeTree*[X, Y] = ref object
            owner: ThreeSidedOwner
            byX: ThreeSidedNode[X, Y, X, Y]
            byY: ThreeSidedNode[Y, X, X, Y]
            size, nextSerial: int

    proc initThreeSidedRangeTree*[X, Y](): ThreeSidedRangeTree[X, Y] =
        ## オンライン点集合を初期化する。O(1)。座標は一貫した厳密弱順序の < が必要。
        ThreeSidedRangeTree[X, Y](owner: ThreeSidedOwner())

    proc len*[X, Y](tree: ThreeSidedRangeTree[X, Y]): int =
        ## 有効な点数を返す。O(1)。nil は空として扱う。
        if tree.isNil: 0 else: tree.size

    proc contains*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            id: ThreeSidedPointId[X, Y]): bool =
        ## この集合の有効な点IDか判定する。O(1)。
        not tree.isNil and not tree.owner.isNil and not id.isNil and
            id.owner == tree.owner and id.live

    proc requireTree[X, Y](tree: ThreeSidedRangeTree[X, Y]) =
        ## 未初期化の集合を拒否する。
        if tree.isNil or tree.owner.isNil:
            raise newException(ValueError, "集合を初期化してください")

    proc requirePoint[X, Y](tree: ThreeSidedRangeTree[X, Y],
            id: ThreeSidedPointId[X, Y]) =
        ## 削除済み・別集合・nilの点IDを拒否する。
        if not tree.contains(id):
            raise newException(ValueError, "この集合の有効な点IDが必要です")

    proc get*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            id: ThreeSidedPointId[X, Y]): ThreeSidedPoint[X, Y] =
        ## 点IDに対応する現在の座標のコピーを返す。O(1)。
        tree.requirePoint(id)
        (id: id, x: id.x, y: id.y)

    proc nodeHeight[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y]): int =
        ## 空部分木の高さを0として返す。
        if node.isNil: 0 else: node.height

    proc prefer[V, X, Y](a: V, ap: ThreeSidedPointId[X, Y],
            b: V, bp: ThreeSidedPointId[X, Y], maximum: bool): bool =
        ## 極値を比較し、同値の場合は追加順が早い点を選ぶ。
        mixin `<`
        if maximum:
            if b < a: return true
            if a < b: return false
        else:
            if a < b: return true
            if b < a: return false
        ap.serial < bp.serial

    proc refresh[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y]) =
        ## 高さと部分木の最小・最大座標および対応する点を再計算する。O(1)。
        node.height = max(node.left.nodeHeight, node.right.nodeHeight) + 1
        node.minValue = node.value
        node.maxValue = node.value
        node.minPoint = node.point
        node.maxPoint = node.point
        for child in [node.left, node.right]:
            if not child.isNil:
                if prefer(child.minValue, child.minPoint,
                        node.minValue, node.minPoint, false):
                    node.minValue = child.minValue
                    node.minPoint = child.minPoint
                if prefer(child.maxValue, child.maxPoint,
                        node.maxValue, node.maxPoint, true):
                    node.maxValue = child.maxValue
                    node.maxPoint = child.maxPoint

    proc rotateLeft[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y]):
            ThreeSidedNode[K, V, X, Y] =
        ## 左回転して集約情報を更新する。O(1)。
        result = node.right
        node.right = result.left
        result.left = node
        node.refresh()
        result.refresh()

    proc rotateRight[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y]):
            ThreeSidedNode[K, V, X, Y] =
        ## 右回転して集約情報を更新する。O(1)。
        result = node.left
        node.left = result.right
        result.right = node
        node.refresh()
        result.refresh()

    proc balance[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y]):
            ThreeSidedNode[K, V, X, Y] =
        ## AVLの高さ差を回復し、集約情報を更新する。O(1)。
        node.refresh()
        let difference = node.left.nodeHeight - node.right.nodeHeight
        if difference > 1:
            if node.left.left.nodeHeight < node.left.right.nodeHeight:
                node.left = node.left.rotateLeft()
            return node.rotateRight()
        if difference < -1:
            if node.right.right.nodeHeight < node.right.left.nodeHeight:
                node.right = node.right.rotateRight()
            return node.rotateLeft()
        node

    proc keyLess[K](a: K, ai: int, b: K, bi: int): bool =
        ## 主座標と追加番号の辞書順を比較する。重複点も区別する。
        mixin `<`
        if a < b: return true
        if b < a: return false
        ai < bi

    proc insertNode[K, V, X, Y](node, added: ThreeSidedNode[K, V, X, Y]):
            ThreeSidedNode[K, V, X, Y] =
        ## 一点をAVLに追加する。最悪O(log(N+1))。
        if node.isNil: return added
        if keyLess(added.key, added.point.serial, node.key, node.point.serial):
            node.left = insertNode(node.left, added)
        else:
            node.right = insertNode(node.right, added)
        node.balance()

    proc detachMin[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y],
            smallest: var ThreeSidedNode[K, V, X, Y]): ThreeSidedNode[K, V, X, Y] =
        ## 最小節点を切り離し、残りのAVLを返す。最悪O(log(N+1))。
        if node.left.isNil:
            smallest = node
            return node.right
        node.left = detachMin(node.left, smallest)
        node.balance()

    proc eraseNode[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y],
            key: K, serial: int): ThreeSidedNode[K, V, X, Y] =
        ## 主座標と追加番号で一点を削除する。最悪O(log(N+1))。
        if keyLess(key, serial, node.key, node.point.serial):
            node.left = eraseNode(node.left, key, serial)
        elif keyLess(node.key, node.point.serial, key, serial):
            node.right = eraseNode(node.right, key, serial)
        else:
            if node.left.isNil: return node.right
            if node.right.isNil: return node.left
            var successor: ThreeSidedNode[K, V, X, Y]
            let right = detachMin(node.right, successor)
            successor.left = node.left
            successor.right = right
            return successor.balance()
        node.balance()

    proc addNodes[X, Y](tree: ThreeSidedRangeTree[X, Y], id: ThreeSidedPointId[X, Y]) =
        ## 両軸のAVLに同じ点IDを登録する。
        let nx = ThreeSidedNode[X, Y, X, Y](key: id.x, value: id.y, point: id)
        let ny = ThreeSidedNode[Y, X, X, Y](key: id.y, value: id.x, point: id)
        nx.refresh()
        ny.refresh()
        tree.byX = insertNode(tree.byX, nx)
        tree.byY = insertNode(tree.byY, ny)

    proc removeNodes[X, Y](tree: ThreeSidedRangeTree[X, Y], id: ThreeSidedPointId[X, Y]) =
        ## 両軸のAVLから同じ点IDを取り除く。
        tree.byX = eraseNode(tree.byX, id.x, id.serial)
        tree.byY = eraseNode(tree.byY, id.y, id.serial)

    proc add*[X, Y](tree: ThreeSidedRangeTree[X, Y], x: X, y: Y): ThreeSidedPointId[X, Y] =
        ## 点を追加し、再利用されない不透明な点IDを返す。最悪O(log(N+1))。
        tree.requireTree()
        if tree.nextSerial == high(int):
            raise newException(ValueError, "累積追加回数がintの上限に達しました")
        result = ThreeSidedPointId[X, Y](owner: tree.owner,
            serial: tree.nextSerial, live: true, x: x, y: y)
        tree.addNodes(result)
        inc tree.nextSerial
        inc tree.size

    proc erase*[X, Y](tree: ThreeSidedRangeTree[X, Y], id: ThreeSidedPointId[X, Y]) =
        ## 指定IDの点を一つ削除し、IDを無効にする。最悪O(log(N+1))。
        tree.requirePoint(id)
        tree.removeNodes(id)
        id.live = false
        dec tree.size

    proc update*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            id: ThreeSidedPointId[X, Y], x: X, y: Y) =
        ## 指定点の両座標を更新する。IDと追加順を維持する。最悪O(log(N+1))。
        tree.requirePoint(id)
        tree.removeNodes(id)
        id.x = x
        id.y = y
        tree.addNodes(id)

    proc rangeExtreme[K, V, X, Y](node: ThreeSidedNode[K, V, X, Y],
            lower, upper: K, lowerFree, upperFree, maximum: bool):
            Option[tuple[value: V, id: ThreeSidedPointId[X, Y]]] =
        ## 半開区間の極値を集約する。完全包含部分木はO(1)、境界経路だけ辿る。
        mixin `<`
        type Answer = tuple[value: V, id: ThreeSidedPointId[X, Y]]
        if node.isNil: return none(Answer)
        if lowerFree and upperFree:
            if maximum: return some((value: node.maxValue, id: node.maxPoint))
            return some((value: node.minValue, id: node.minPoint))
        if not lowerFree and node.key < lower:
            return rangeExtreme(node.right, lower, upper, false, upperFree, maximum)
        if not upperFree and not (node.key < upper):
            return rangeExtreme(node.left, lower, upper, lowerFree, false, maximum)
        result = some((value: node.value, id: node.point))
        let left = rangeExtreme(node.left, lower, upper, lowerFree, true, maximum)
        let right = rangeExtreme(node.right, lower, upper, true, upperFree, maximum)
        for candidate in [left, right]:
            if candidate.isSome and prefer(candidate.get.value, candidate.get.id,
                    result.get.value, result.get.id, maximum):
                result = candidate

    proc findPoint[K, V, X, Y](tree: ThreeSidedRangeTree[X, Y],
            node: ThreeSidedNode[K, V, X, Y], lower, upper: K, limit: V,
            maximum: bool): Option[ThreeSidedPoint[X, Y]] =
        ## 区間の極値が上限・下限条件を満たせばその点を返す。最悪O(log(N+1))。
        mixin `<`
        tree.requireTree()
        if not (lower < upper): return none(ThreeSidedPoint[X, Y])
        let answer = rangeExtreme(node, lower, upper, false, false, maximum)
        if answer.isSome:
            let value = answer.get.value
            if (maximum and not (value < limit)) or
                    (not maximum and not (limit < value)):
                return some(tree.get(answer.get.id))
        none(ThreeSidedPoint[X, Y])

    proc findBelow*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            xLower, xUpper: X, yUpper: Y): Option[ThreeSidedPoint[X, Y]] =
        ## xLower <= x < xUpper, y <= yUpper の点を一つ返す。最悪O(log(N+1))。
        tree.requireTree()
        findPoint(tree, tree.byX, xLower, xUpper, yUpper, false)

    proc findAbove*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            xLower, xUpper: X, yLower: Y): Option[ThreeSidedPoint[X, Y]] =
        ## xLower <= x < xUpper, yLower <= y の点を一つ返す。最悪O(log(N+1))。
        tree.requireTree()
        findPoint(tree, tree.byX, xLower, xUpper, yLower, true)

    proc findLeft*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            yLower, yUpper: Y, xUpper: X): Option[ThreeSidedPoint[X, Y]] =
        ## yLower <= y < yUpper, x <= xUpper の点を一つ返す。最悪O(log(N+1))。
        tree.requireTree()
        findPoint(tree, tree.byY, yLower, yUpper, xUpper, false)

    proc findRight*[X, Y](tree: ThreeSidedRangeTree[X, Y],
            yLower, yUpper: Y, xLower: X): Option[ThreeSidedPoint[X, Y]] =
        ## yLower <= y < yUpper, xLower <= x の点を一つ返す。最悪O(log(N+1))。
        tree.requireTree()
        findPoint(tree, tree.byY, yLower, yUpper, xLower, true)
