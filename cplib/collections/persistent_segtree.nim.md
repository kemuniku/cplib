---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_segtree_test.nim
    title: verify/AI/persistent_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/persistent_segtree_test.nim
    title: verify/AI/persistent_segtree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_PERSISTENT_SEGTREE:\n    const CPLIB_COLLECTIONS_PERSISTENT_SEGTREE*\
    \ = 1\n    type SegmentTreeNode* = ref object\n        value : int\n        left\
    \ : SegmentTreeNode\n        right : SegmentTreeNode\n\n    type PSegmentTree*\
    \ = ref object\n        root : SegmentTreeNode\n        lastnode : int\n     \
    \   op : proc(l:int,r:int):int\n        e : int\n\n    proc initSegmentTree*(v:openArray[int],op\
    \ : proc(l:int,r:int):int,e:int):PSegmentTree=\n        let v = @v\n        var\
    \ size = 1\n        while size < len(v):\n            size *= 2\n        proc\
    \ buildNode(l:int,r:int):SegmentTreeNode=\n            if r-l == 1:\n        \
    \        if l < len(v):\n                    return SegmentTreeNode(value:v[l],\
    \ left:nil, right:nil)\n                else:\n                    return SegmentTreeNode(value:e,\
    \ left:nil, right:nil)\n            var L = buildNode(l,(l+r) shr 1)\n       \
    \     var R = buildNode((l+r) shr 1, r)\n            return SegmentTreeNode(value:op(L.value,R.value),\
    \ left:L, right:R)\n        result = PSegmentTree(root:buildNode(0,size), lastnode:size,\
    \ op:op, e:e)\n\n    proc update*(st:PSegmentTree,idx:int,value:int):PSegmentTree=\n\
    \        proc dfs(node:SegmentTreeNode,l:int,r:int):SegmentTreeNode=\n       \
    \     if r-l == 1:\n                return SegmentTreeNode(value:value,left:nil,right:nil)\n\
    \            var mid = (l+r) shr 1\n            if idx < mid:\n              \
    \  var left = dfs(node.left,l,mid)\n                var right = node.right\n \
    \               return SegmentTreeNode(value:st.op(left.value,right.value), left:left,\
    \ right:right)\n            else:\n                var left = node.left\n    \
    \            var right = dfs(node.right,mid,r)\n                return SegmentTreeNode(value:st.op(left.value,right.value),\
    \ left:left, right:right)\n        result = PSegmentTree(root:dfs(st.root,0,st.lastnode),\
    \ lastnode:st.lastnode, op:st.op, e:st.e)\n\n    proc query*(st:PSegmentTree,l:int,r:int):int=\n\
    \        proc dfs(node:SegmentTreeNode,nl,nr:int):int=\n            if l >= nr\
    \ or r <= nl:\n                return st.e\n            if l <= nl and nr <= r:\n\
    \                return node.value\n            var mid = (nl + nr) shr 1\n  \
    \          var left_value = dfs(node.left,nl,mid)\n            var right_value\
    \ = dfs(node.right,mid,nr)\n            return st.op(left_value,right_value)\n\
    \        return dfs(st.root,0,st.lastnode)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/persistent_segtree.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/persistent_segtree_test.nim
  - verify/AI/persistent_segtree_test.nim
documentation_of: cplib/collections/persistent_segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/persistent_segtree.nim
- /library/cplib/collections/persistent_segtree.nim.html
title: cplib/collections/persistent_segtree.nim
---
