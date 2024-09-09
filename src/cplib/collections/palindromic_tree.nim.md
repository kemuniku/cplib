---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/palindromic_tree_test.nim
    title: verify/collections/palindromic_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/palindromic_tree_test.nim
    title: verify/collections/palindromic_tree_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_PALINDROMIC_TREE:\n    const CPLIB_COLLECTIONS_PALINDROMIC_TREE*\
    \ = 1\n    import sequtils, algorithm\n    type PalindromicTreeNode* = object\n\
    \        link*: seq[ref PalindromicTreeNode]\n        suffix_link*: ref PalindromicTreeNode\n\
    \        len, count, id: int\n\n    type PalindromicTree* = object\n        amax:\
    \ int\n        nodes*: seq[ref PalindromicTreeNode]\n\n    proc len*(node: PalindromicTreeNode):\
    \ int = node.len\n    proc count*(node: PalindromicTreeNode): int = node.count\n\
    \    proc id*(node: PalindromicTreeNode): int = node.id\n    \n    proc newPalindromicTreeNode(pt:\
    \ var PalindromicTree, amax, len: int): ref PalindromicTreeNode =\n        result\
    \ = new PalindromicTreeNode\n        result[].link = newSeq[ref PalindromicTreeNode](amax)\n\
    \        result[].suffix_link = nil\n        result[].len = len\n        result[].count\
    \ = 0\n        result[].id = pt.nodes.len\n        pt.nodes.add(result)\n\n  \
    \  proc init(amax: int): PalindromicTree =\n        discard result.newPalindromicTreeNode(amax,\
    \ -1)\n        discard result.newPalindromicTreeNode(amax, 0)\n        result.amax\
    \ = amax\n        result.nodes[1][].suffix_link = result.nodes[0]\n\n\n    proc\
    \ initPalindromicTree*(a: seq[int], amax: int = -1): PalindromicTree =\n     \
    \   var amax = amax\n        if amax < 0: amax = a.max\n        result = init(amax)\n\
    \        proc find_longest(pos: int, node: ref PalindromicTreeNode): ref PalindromicTreeNode\
    \ =\n            var ln = pos - node[].len - 1\n            if ln >= 0 and a[ln]\
    \ == a[pos]:\n                return node\n            return find_longest(pos,\
    \ node[].suffix_link)\n        var current_node = result.nodes[0]\n        for\
    \ i in 0..<a.len:\n            current_node = find_longest(i, current_node)\n\
    \            if current_node[].link[a[i]] == nil:\n                current_node[].link[a[i]]\
    \ = result.newPalindromicTreeNode(amax, current_node[].len + 2)\n            if\
    \ current_node == result.nodes[0]:\n                current_node[].link[a[i]][].suffix_link\
    \ = result.nodes[1]\n            else:\n                current_node[].link[a[i]][].suffix_link\
    \ = find_longest(i, current_node[].suffix_link)[].link[a[i]]\n            current_node\
    \ = current_node[].link[a[i]]\n            current_node[].count += 1\n\n    proc\
    \ initPalindromicTree*(s: string, c: char = 'a'): PalindromicTree =\n        return\
    \ initPalindromicTree(s.mapIt(int(it) - int(c)), 26)\n\n    proc get_palindrome*(pt:\
    \ PalindromicTree, node: ref PalindromicTreeNode): seq[int] =\n        if node\
    \ == pt.nodes[0] or node == pt.nodes[1]: return newSeq[int](0)\n        var ans\
    \ = newSeq[int](0)\n        proc dfs(x: ref PalindromicTreeNode): bool =\n   \
    \         if x == node: return true\n            for i in 0..<pt.amax:\n     \
    \           if x[].link[i] == nil: continue\n                if dfs(x[].link[i]):\n\
    \                    ans.add(i)\n                    return true\n           \
    \ return false\n        discard dfs(pt.nodes[0])\n        discard dfs(pt.nodes[1])\n\
    \        for i in ans.len..<node[].len:\n            ans.add(ans[node[].len-1-i])\n\
    \        return ans\n\n    proc update_count*(pt: PalindromicTree) =\n       \
    \ for node in pt.nodes[1..<pt.nodes.len].reversed:\n            node[].suffix_link[].count\
    \ += node[].count\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/palindromic_tree.nim
  requiredBy: []
  timestamp: '2024-09-10 01:09:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/palindromic_tree_test.nim
  - verify/collections/palindromic_tree_test.nim
documentation_of: cplib/collections/palindromic_tree.nim
layout: document
redirect_from:
- /library/cplib/collections/palindromic_tree.nim
- /library/cplib/collections/palindromic_tree.nim.html
title: cplib/collections/palindromic_tree.nim
---
