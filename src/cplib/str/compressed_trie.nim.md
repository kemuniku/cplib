---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_COMPRESSED_TRIE:\n    import cplib/str/static_string\n\
    \    import algorithm\n    import cplib/graph/graph\n    const CPLIB_STR_COMPRESSED_TRIE*\
    \ = 1\n    type CompressedTrieNode* = ref object\n        parent* : CompressedTrieNode\n\
    \        child* : array['a'..'z',CompressedTrieNode]\n        s* : StaticString\n\
    \        cnt* : int32\n        subtree_sum* : int32\n\n    proc initCompressedTrie*(S:seq[StaticString],sorted:bool=false):CompressedTrieNode=\n\
    \        var S = S\n        if not sorted:\n            S.sort()\n        var\
    \ root = CompressedTrieNode(s:S[0][0..<0])\n        var stack = @[root]\n    \
    \    for s in S:\n            while not s.startsWith(stack[^1].s):\n         \
    \       discard stack.pop()\n            var l = lcp(stack[^1].s,s)\n        \
    \    if l == len(s):\n                stack[^1].cnt += 1\n                continue\n\
    \            if stack[^1].child[s[l]].isNil():\n                stack[^1].child[s[l]]\
    \ = CompressedTrieNode(parent:stack[^1],s:s,cnt:1,subtree_sum:1)\n           \
    \     stack.add(stack[^1].child[s[l]])\n            else:\n                var\
    \ x = lcp(s,stack[^1].child[s[l]].s)\n                var tmp = CompressedTrieNode(parent:stack[^1],s:s[0..<x],cnt:0,subtree_sum:0)\n\
    \                stack[^1].child[s[l]].parent = tmp\n                tmp.child[stack[^1].child[s[l]].s[x]]\
    \ = stack[^1].child[s[l]]\n                tmp.child[s[x]] = CompressedTrieNode(parent:tmp,s:s,cnt:1,subtree_sum:1)\n\
    \                stack[^1].child[s[l]] = tmp\n                stack.add(tmp)\n\
    \                stack.add(tmp.child[s[x]])\n        while len(stack) != 1:\n\
    \            discard stack.pop()\n        var dfs_stack = @[(root,false)]\n  \
    \      while len(dfs_stack) > 0:\n            let (node,visited) = dfs_stack.pop()\n\
    \            if visited:\n                node.subtree_sum = node.cnt\n      \
    \          for c in 'a'..'z':\n                    if not node.child[c].isNil():\n\
    \                        node.subtree_sum += node.child[c].subtree_sum\n     \
    \       else:\n                dfs_stack.add((node,true))\n                for\
    \ c in 'a'..'z':\n                    if not node.child[c].isNil():\n        \
    \                dfs_stack.add((node.child[c],false))\n        return root\n\n\
    \    proc debug_dfs(node:CompressedTrieNode,depth:int = 0)=\n        echo node.s\n\
    \        for c in 'a'..'z':\n            if node.child[c].isNil():\n         \
    \       continue\n            debug_dfs(node.child[c],depth+1)\n\n    proc toGraph*(root:CompressedTrieNode):WeightedDirectedGraph[StaticString]=\n\
    \        var p = @[(-1,StaticString())]\n        var cnt = 1\n        proc dfs(node:CompressedTrieNode,id:int)=\n\
    \            for c in 'a'..'z':\n                if not node.child[c].isNil():\n\
    \                    cnt += 1\n                    var l = lcp(node.s,node.child[c].s)\n\
    \                    p.add((id,node.child[c].s[l..<len(node.child[c].s)]))\n \
    \                   dfs(node.child[c],cnt-1)\n        dfs(root,0)\n        result\
    \ = initWeightedDirectedGraph(len(p),StaticString)\n        for i in 1..<len(p):\n\
    \            result.add_edge(p[i][0],i,p[i][1])\n\n    type VirtualTrieNode =\
    \ ref object\n        current_node* : CompressedTrieNode\n        now* : StaticString\n\
    \n    proc get_virtualnode*(node:CompressedTrieNode):VirtualTrieNode=\n      \
    \  return VirtualTrieNode(current_node:node,now:node.s[0..<0])\n\n    proc get_child*(node:VirtualTrieNode,c:char):VirtualTrieNode=\n\
    \        if len(node.now) == 0:\n            if node.current_node.child[c].s.len()\
    \ == node.current_node.s.len() + 1:\n                return VirtualTrieNode(current_node:node.current_node.child[c],now:node.current_node.s[0..<0])\n\
    \            else:\n                return VirtualTrieNode(current_node:node.current_node,now:node.current_node.child[c].s[node.current_node.s.len()..<(node.current_node.s.len()+1)])\n\
    \            \n        else:\n            if node.current_node.child[node.now[0]].s.len()\
    \ - node.current_node.s.len() == node.now.len() + 1:\n                return VirtualTrieNode(current_node:node.current_node.child[node.now[0]],now:node.now[0..<0])\n\
    \            return VirtualTrieNode(current_node:node.current_node,now:node.current_node.child[node.now[0]].s[(node.current_node.s.len())..<(node.current_node.s.len()+len(node.now)+1)])\n\
    \n    proc has_child*(node:VirtualTrieNode,c:char):bool=\n        if len(node.now)\
    \ == 0:\n            return not node.current_node.child[c].isNil()\n        return\
    \ node.current_node.child[node.now[0]].s[len(node.current_node.s) + len(node.now)]\
    \ == c\n\n    proc get_cnt*(node:VirtualTrieNode):int=\n        if node.now.len()\
    \ != 0:\n            return 0\n        return node.current_node.cnt\n\n    proc\
    \ get_subtree_sum*(node:VirtualTrieNode):int=\n        if node.now.len() == 0:\n\
    \            return node.current_node.subtree_sum\n        return node.current_node.child[node.now[0]].subtree_sum"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/graph/graph.nim
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  isVerificationFile: false
  path: cplib/str/compressed_trie.nim
  requiredBy: []
  timestamp: '2026-05-26 11:04:37+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/str/compressed_trie.nim
layout: document
redirect_from:
- /library/cplib/str/compressed_trie.nim
- /library/cplib/str/compressed_trie.nim.html
title: cplib/str/compressed_trie.nim
---
