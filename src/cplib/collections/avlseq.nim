
const ATCODER_SEGTREE_HPP* = 1
import atcoder/internal_bit
import std/sequtils, std/algorithm
import atcoder/rangeutils
when not declared CPLIB_COLLECTIONS_AVLTREE:
    const CPLIB_COLLECTIONS_AVLTREE* = 1
    when compileOption("mm", "orc") or compileOption("mm", "arc"):
        {.fatal: "Plese Use refc".}
    # 以下をNimに移植
    # https://nachiavivias.github.io/cp-library/cpp/array/bbst-list.html
    type AvlSeqNode*[K;t:static[tuple]] = ref object
        l*, r*, p*: AvlSeqNode[K,t]
        h*, len*: int
        key*: K
        fold* : K
    
    proc get_avlseq_nilnode*[nodetype](): auto =
        let nil_node {.global.} = (block:
            var nil_node = nodetype(h: 0, len: 0)
            nil_node.l = nil_node
            nil_node.r = nil_node
            nil_node.p = nil_node
            nil_node.fold = nodetype.t.e()
            nil_node
        )
        return nil_node
    proc update[nodetype](node: nodetype) =
        node.h = max(node.l.h + 1, node.r.h + 1)
        node.len = 1 + node.l.len + node.r.len
        node.fold = nodetype.t.op(node.l.fold, nodetype.t.op(node.key, node.r.fold))
    proc set_children[nodetype](node, l, r: nodetype) =
        node.l = l
        if l != get_avlseq_nilnode[nodetype](): l.p = node
        node.r = r
        if r != get_avlseq_nilnode[nodetype](): r.p = node
        node.update()
    proc rebalance[nodetype](node: nodetype): nodetype =
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
    proc rebalance_to_root[nodetype](node: nodetype): nodetype =
        var node = node
        while node.p != get_avlseq_nilnode[nodetype]():
            var cp = node.p
            if cp.l == node: cp.l = node.rebalance
            else: cp.r = node.rebalance
            node = cp
        return node.rebalance
    proc rootOf*[nodetype](node: nodetype): nodetype =
        result = node
        while result.p != get_avlseq_nilnode[nodetype](): result = result.p
    proc node_search*[nodetype](node: nodetype, index: int): (nodetype,nodetype) =
        var node = node
        var result_l = get_avlseq_nilnode[nodetype]()
        var result_r = get_avlseq_nilnode[nodetype]()
        var lsum = 0
        while node != get_avlseq_nilnode[nodetype]():
            if (index <= node.l.len+lsum):
                result_r = node
                node = node.l
            else:
                lsum += node.l.len + 1
                result_l = node
                node = node.r
        return (result_l, result_r)
    # proc lower_bound_node*[K,p](node: AvlSeqNode[K,p], key: K): (AvlSeqNode[K,p], AvlSeqNode[K,p]) = node_search[K,p](node, key, false)
    # proc upper_bound_node*[K,p](node: AvlSeqNode[K,p], key: K): (AvlSeqNode[K,p], AvlSeqNode[K,p]) = node_search[K,p](node, key, true)
    proc insert*[nodetype](node, x: nodetype,idx:int): nodetype =
        if node == get_avlseq_nilnode[nodetype](): return x
        var (ql, qr) = node.node_search(idx)
        if ql != get_avlseq_nilnode[nodetype]() and ql.r == get_avlseq_nilnode[nodetype]():
            ql.set_children(ql.l, x)
            return ql.rebalance_to_root
        qr.set_children(x, qr.r)
        return qr.rebalance_to_root
    proc erase*[nodetype](node, x, nxt: nodetype): nodetype =
        var xp = x.p
        result = get_avlseq_nilnode[nodetype]()
        if x.r == get_avlseq_nilnode[nodetype]():
            var xl = x.l
            if xl != get_avlseq_nilnode[nodetype](): xl.p = xp
            if xp != get_avlseq_nilnode[nodetype]():
                if xp.l == x: xp.l = xl
                else: xp.r = xl
            if xp == get_avlseq_nilnode[nodetype](): result = xl
            else: result = xp.rebalance_to_root
        else:
            var nxtp = nxt.p
            var nxtr = nxt.r
            if xp != get_avlseq_nilnode[nodetype]():
                if xp.l == x: xp.l = nxt
                else: xp.r = nxt
            nxt.p = xp
            nxt.l = x.l
            if nxt.l != get_avlseq_nilnode[nodetype](): nxt.l.p = nxt
            if x.r == nxt:
                nxt.update
                result = nxt.rebalance_to_root
            else:
                if nxtp.l == nxt: nxtp.l = nxtr
                else: nxtp.r = nxtr
                if nxtr != get_avlseq_nilnode[nodetype](): nxtr.p = nxtp
                nxt.r = x.r
                nxt.r.p = nxt
                nxt.update
                result = nxtp.rebalance_to_root
        x.l = get_avlseq_nilnode[nodetype]()
        x.r = get_avlseq_nilnode[nodetype]()
        x.p = get_avlseq_nilnode[nodetype]()
        x.update
    proc next*[nodetype](node: nodetype): nodetype =
        var node = node
        if node.r != get_avlseq_nilnode[nodetype]():
            node = node.r
            while node.l != get_avlseq_nilnode[nodetype](): node = node.l
            return node
        while node.p.r == node: node = node.p
        return node.p
    proc prev*[nodetype](node: nodetype): nodetype =
        var node = node
        if node.l != get_avlseq_nilnode[nodetype]():
            node = node.l
            while node.r != get_avlseq_nilnode[nodetype](): node = node.r
            return node
        while node.p.l == node: node = node.p
        return node.p
    proc get*[nodetype](node: nodetype, idx: int): nodetype =
        assert idx >= 0
        if idx >= node.len: return get_avlseq_nilnode[nodetype]()
        result = node
        var idx = idx
        while result.l.len != idx:
            if result.l.len < idx:
                idx -= result.l.len + 1
                result = result.r
            else:
                result = result.l
    proc index*[nodetype](node: nodetype): int =
        var node = node
        if node == get_avlseq_nilnode[nodetype](): return 0
        result = node.l.len
        while node.p != get_avlseq_nilnode[nodetype]():
            if node.p.r == node: result += node.p.l.len + 1
            node = node.p



#{.push inline.}
type SegTree*[T,K:AvlSeqNode] = object
    root* : T

template calc_op*[ST:SegTree](self:ST or typedesc[ST], a, b:ST.S):auto =
    block:
        let u = ST.p.op(a, b)
        u
template calc_e*[ST:SegTree](self:ST or typedesc[ST]):auto =
    block:
        let u = ST.p.e()
        u

template NodeType*[S](op0, e0:untyped):typedesc[AvlSeqNode] =
    proc op1(l, r:S):S {.gensym inline.} = op0(l, r)
    proc e1():S {.gensym inline.} = e0()
    AvlSeqNode[S, (op:op1, e:e1)]


proc newnode*[ST:SegTree](x: ST.K): auto=
    var nil_node = get_avlseq_nilnode[ST.T]()
    return ST.T(p: nil_node, l: nil_node, r: nil_node, len: 1, h: 1, key: x,fold:x)

proc insert*[ST:SegTree](self:var ST,x:ST.K,idx:int)=
    var node = newnode[ST](x)
    self.root = insert[ST.T](self.root,node,idx)

proc init*[ST:SegTree](self: typedesc[ST], v:seq[int]):auto =
    result = ST()
    result.root = get_avlseq_nilnode[ST.T]()
    for i in 0..<len(v):
        result.insert(v[i],i)

template getType*(ST:typedesc[SegTree], S:typedesc, op, e:untyped):typedesc[SegTree] =
    SegTreeType[S](op, e)

template initSegTree*[T](v:seq[T] or int, op, e:untyped):auto =
    SegTree[NodeType[T](op, e),T].init(v)

include cplib/tmpl/sheep

# static:
#     type x = type(SegTree[NodeType[int]((l,r:int)=>(l+r),()=>0)])
#     echo x
#     echo SegTree[NodeType[int]((l,r:int)=>(l+r),()=>0)].T
#     echo SegTree[NodeType[int]((l,r:int)=>(l+r),()=>0)].T.K

proc `[]`*[ST:SegTree](self:var ST,idx:int):ST.K=
    var node = self.root.node_search(idx)
    assert node[1].len > 0
    return node[1].key


proc dfs[nodetype](node:nodetype)=
    if node.l != get_avlseq_nilnode[nodetype]():
        dfs(node.l)
    echo node.key
    if node.r != get_avlseq_nilnode[nodetype]():
        dfs(node.r)


proc delete*[ST:SegTree](self:var ST,idx:int)=
    var node = self.root.node_search(idx)
    assert node[1].len > 0
    self.root = self.root.erase(node[1],node[1].next)


var st = initSegTree[int](@[],(l,r:int)=>(l+r),()=>0)

include cplib/tmpl/sheep
var N = ii()
var P = lii(N)

for i in range(N):
    st.insert(i+1,P[i]-1)
    st.delete(i)

echo (0..<N).toseq().mapit(st[it]).join(" ")