when not declared CPLIB_COLLECTIONS_AVLTREE:
    const CPLIB_COLLECTIONS_AVLTREE* = 1
    # 以下をNimに移植
    # https://nachiavivias.github.io/cp-library/cpp/array/bbst-list.html
    type AvlTreeNode*[K] = ref object
        l*, r*, p*: AvlTreeNode[K]
        h*, len*: int
        key*: K
    proc get_avltree_nilnode*[K](): AvlTreeNode[K] =
        let nil_node {.global.} = (block:
            var nil_node = AvlTreeNode[K](h: 0, len: 0)
            nil_node.l = nil_node
            nil_node.r = nil_node
            nil_node.p = nil_node
            nil_node
        )
        return nil_node
    proc update[K](node: AvlTreeNode[K]) =
        node.h = max(node.l.h + 1, node.r.h + 1)
        node.len = 1 + node.l.len + node.r.len
    proc set_children[K](node, l, r: AvlTreeNode[K]) =
        node.l = l
        if l != get_avltree_nilnode[K](): l.p = node
        node.r = r
        if r != get_avltree_nilnode[K](): r.p = node
        node.update()
    proc rebalance[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        var l = node.l
        var r = node.r
        if l.h + 1 < r.h:
            var rl = r.l
            var rr = r.r
            if rl.h <= rr.h:
                r.p = node.p
                node.set_children(l, rl)
                r.set_children(node, rr)
                return r
            else:
                rl.p = node.p
                node.set_children(l, rl.l)
                r.set_children(rl.r, rr)
                rl.set_children(node, r)
                return rl
        elif r.h + 1 < l.h:
            var ll = l.l
            var lr = l.r
            if lr.h <= ll.h:
                l.p = node.p
                node.set_children(lr, r)
                l.set_children(ll, node)
                return l
            else:
                lr.p = node.p
                node.set_children(lr.r, r)
                l.set_children(ll, lr.l)
                lr.set_children(l, node)
                return lr
        node.update
        return node
    proc rebalance_to_root[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        while node.p != get_avltree_nilnode[K]():
            var cp = node.p
            if cp.l == node: cp.l = node.rebalance
            else: cp.r = node.rebalance
            node = cp
        return node.rebalance
    proc rootOf*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        result = node
        while result.p != get_avltree_nilnode[K](): result = result.p
    proc node_search[K](node: AvlTreeNode[K], key: K, strict: bool): (AvlTreeNode[K], AvlTreeNode[K]) =
        var node = node
        var result_l = get_avltree_nilnode[K]()
        var result_r = get_avltree_nilnode[K]()
        while node != get_avltree_nilnode[K]():
            if (strict and key < node.key) or (not strict and key <= node.key):
                result_r = node
                node = node.l
            else:
                result_l = node
                node = node.r
        return (result_l, result_r)
    proc lower_bound_node*[K](node: AvlTreeNode[K], key: K): (AvlTreeNode[K], AvlTreeNode[K]) = node_search[K](node, key, false)
    proc upper_bound_node*[K](node: AvlTreeNode[K], key: K): (AvlTreeNode[K], AvlTreeNode[K]) = node_search[K](node, key, true)
    proc insert*[K](node, x: AvlTreeNode[K]): AvlTreeNode[K] =
        if node == get_avltree_nilnode[K](): return x
        var (ql, qr) = node.lower_bound_node(x.key)
        if ql != get_avltree_nilnode[K]() and ql.r == get_avltree_nilnode[K]():
            ql.set_children(ql.l, x)
            return ql.rebalance_to_root
        qr.set_children(x, qr.r)
        return qr.rebalance_to_root
    proc erase*[K](node, x, nxt: AvlTreeNode[K]): AvlTreeNode[K] =
        var xp = x.p
        result = get_avltree_nilnode[K]()
        if x.r == get_avltree_nilnode[K]():
            var xl = x.l
            if xl != get_avltree_nilnode[K](): xl.p = xp
            if xp != get_avltree_nilnode[K]():
                if xp.l == x: xp.l = xl
                else: xp.r = xl
            if xp == get_avltree_nilnode[K](): result = xl
            else: result = xp.rebalance_to_root
        else:
            var nxtp = nxt.p
            var nxtr = nxt.r
            if xp != get_avltree_nilnode[K]():
                if xp.l == x: xp.l = nxt
                else: xp.r = nxt
            nxt.p = xp
            nxt.l = x.l
            if nxt.l != get_avltree_nilnode[K](): nxt.l.p = nxt
            if x.r == nxt:
                nxt.update
                result = nxt.rebalance_to_root
            else:
                if nxtp.l == nxt: nxtp.l = nxtr
                else: nxtp.r = nxtr
                if nxtr != get_avltree_nilnode[K](): nxtr.p = nxtp
                nxt.r = x.r
                nxt.r.p = nxt
                nxt.update
                result = nxtp.rebalance_to_root
        x.l = get_avltree_nilnode[K]()
        x.r = get_avltree_nilnode[K]()
        x.p = get_avltree_nilnode[K]()
        x.update
    proc next*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        if node.r != get_avltree_nilnode[K]():
            node = node.r
            while node.l != get_avltree_nilnode[K](): node = node.l
            return node
        while node.p.r == node: node = node.p
        return node.p
    proc prev*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        if node.l != get_avltree_nilnode[K]():
            node = node.l
            while node.r != get_avltree_nilnode[K](): node = node.r
            return node
        while node.p.l == node: node = node.p
        return node.p
    proc get*[K](node: AvlTreeNode[K], idx: int): AvlTreeNode[K] =
        if idx >= node.len: return get_avltree_nilnode[K]()
        result = node
        var idx = idx
        while result.l.len != idx:
            if result.l.len < idx:
                idx -= result.l.len + 1
                result = result.r
            else:
                result = result.l

