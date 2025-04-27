when not declared CPLIB_COLLECTIONS_AVLTREE:
    const CPLIB_COLLECTIONS_AVLTREE* = 1
    # 以下をNimに移植
    # https://nachiavivias.github.io/cp-library/cpp/array/bbst-list.html
    type AvlTreeNode*[K] = ref object
        l*, r*, p*: AvlTreeNode[K]
        h*, len*: int
        key*: K
    proc update[K](node: AvlTreeNode[K]) =
        node.h = 0
        node.len = 1
        if not node.l.isNil:
            if node.l.h + 1 > node.h: node.h = node.l.h + 1
            node.len += node.l.len
        if not node.r.isNil:
            if node.r.h + 1 > node.h: node.h = node.r.h + 1
            node.len += node.r.len
    proc set_children[K](node, l, r: AvlTreeNode[K]) =
        node.l = l
        if not l.isNil: l.p = node
        node.r = r
        if not r.isNil: r.p = node
        node.update()
    proc rebalance[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        var l = node.l
        var r = node.r
        var lh = if not l.isNil: l.h else: 0
        var rh = if not r.isNil: r.h else: 0
        if lh + 1 < rh:
            var rl = r.l
            var rr = r.r
            var rlh = if not rl.isNil: rl.h else: 0
            var rrh = if not rr.isNil: rr.h else: 0
            if rlh <= rrh:
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
        elif rh + 1 < lh:
            var ll = l.l
            var lr = l.r
            var llh = if not ll.isNil: ll.h else: 0
            var lrh = if not lr.isNil: lr.h else: 0
            if lrh <= llh:
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
        while not node.p.isNil:
            var cp = node.p
            if cp.l == node: cp.l = node.rebalance
            else: cp.r = node.rebalance
            node = cp
        return node.rebalance
    proc rootOf*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        result = node
        while not result.p.isNil: result = result.p
    proc node_search[K](node: AvlTreeNode[K], key: K, strict: bool): (AvlTreeNode[K], AvlTreeNode[K]) =
        var node = node
        var result_l: AvlTreeNode[K] = nil
        var result_r: AvlTreeNode[K] = nil
        while not node.isNil:
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
        if node.isNil: return x
        var (ql, qr) = node.lower_bound_node(x.key)
        if not ql.isNil and ql.r.isNil:
            ql.set_children(ql.l, x)
            return ql.rebalance_to_root
        qr.set_children(x, qr.r)
        return qr.rebalance_to_root
    proc erase*[K](node, x, nxt: AvlTreeNode[K]): AvlTreeNode[K] =
        var xp = x.p
        if x.r.isNil:
            var xl = x.l
            if not xl.isNil: xl.p = xp
            if not xp.isNil:
                if xp.l == x: xp.l = xl
                else: xp.r = xl
            if xp.isNil: result = xl
            else: result = xp.rebalance_to_root
        else:
            var nxtp = nxt.p
            var nxtr = nxt.r
            if not xp.isNil:
                if xp.l == x: xp.l = nxt
                else: xp.r = nxt
            nxt.p = xp
            nxt.l = x.l
            if not nxt.l.isNil: nxt.l.p = nxt
            if x.r == nxt:
                nxt.update
                result = nxt.rebalance_to_root
            else:
                if nxtp.l == nxt: nxtp.l = nxtr
                else: nxtp.r = nxtr
                if not nxtr.isNil: nxtr.p = nxtp
                nxt.r = x.r
                nxt.r.p = nxt
                nxt.update
                result = nxtp.rebalance_to_root
        x.l = nil
        x.r = nil
        x.p = nil
        x.update
    proc next*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        if not node.r.isNil:
            node = node.r
            while not node.l.isNil: node = node.l
            return node
        while not node.p.isNil and node.p.r == node: node = node.p
        return node.p
    proc prev*[K](node: AvlTreeNode[K]): AvlTreeNode[K] =
        var node = node
        if not node.l.isNil:
            node = node.l
            while not node.r.isNil: node = node.r
            return node
        while not node.p.isNil and node.p.l == node: node = node.p
        return node.p
    proc get*[K](node: AvlTreeNode[K], idx: int): AvlTreeNode[K] =
        assert idx >= 0
        if idx >= node.len: return nil
        result = node
        var idx = idx
        while (result.l.isNil and idx != 0) or (not result.l.isNil and result.l.len != idx):
            if result.l.isNil or result.l.len < idx:
                idx -= (if result.l.isNil: 1 else: result.l.len + 1)
                assert(not result.r.isNil)
                result = result.r
            else:
                result = result.l
    proc index*[K](node: AvlTreeNode[K]): int =
        var node = node
        if node.isNil: return 0
        result = (if node.l.isNil: 0 else: node.l.len)
        while not node.p.isNil:
            if node.p.r == node:
                if node.p.l.isNil: result += 1
                else: result += node.p.l.len + 1
            node = node.p
