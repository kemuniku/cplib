type SegmentTreeNode* = ref object
    value : int
    left : SegmentTreeNode
    right : SegmentTreeNode

type PSegmentTree* = ref object
    root : SegmentTreeNode
    lastnode : int
    op : proc(l:int,r:int):int
    e : int

proc initSegmentTree*(v:seq[int],op : proc(l:int,r:int):int,e:int):PSegmentTree=
    var size = 1
    while size < len(v):
        size *= 2
    proc buildNode(l:int,r:int):SegmentTreeNode=
        if r-l == 1:
            if l < len(v):
                return SegmentTreeNode(value:v[l], left:nil, right:nil)
            else:
                return SegmentTreeNode(value:e, left:nil, right:nil)
        var L = buildNode(l,(l+r) shr 1)
        var R = buildNode((l+r) shr 1, r)
        return SegmentTreeNode(value:op(L.value,R.value), left:L, right:R)
    result = PSegmentTree(root:buildNode(0,size), lastnode:size, op:op, e:e)

proc update*(st:PSegmentTree,idx:int,value:int):PSegmentTree=
    proc dfs(node:SegmentTreeNode,l:int,r:int):SegmentTreeNode=
        if r-l == 1:
            return SegmentTreeNode(value:value,left:nil,right:nil)
        var mid = (l+r) shr 1
        if idx < mid:
            var left = dfs(node.left,l,mid)
            var right = node.right
            return SegmentTreeNode(value:st.op(left.value,right.value), left:left, right:right)
        else:
            var left = node.left
            var right = dfs(node.right,mid,r)
            return SegmentTreeNode(value:st.op(left.value,right.value), left:left, right:right)
    result = PSegmentTree(root:dfs(st.root,0,st.lastnode), lastnode:st.lastnode, op:st.op, e:st.e)

proc query*(st:PSegmentTree,l:int,r:int):int=
    proc dfs(node:SegmentTreeNode,nl,nr:int):int=
        if l >= nr or r <= nl:
            return st.e
        if l <= nl and nr <= r:
            return node.value
        var mid = (nl + nr) shr 1
        var left_value = dfs(node.left,nl,mid)
        var right_value = dfs(node.right,mid,nr)
        return st.op(left_value,right_value)
    return dfs(st.root,0,st.lastnode)

