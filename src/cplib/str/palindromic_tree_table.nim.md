---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_table_test.nim
    title: verify/str/palindromic_tree_table_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/palindromic_tree_table_test.nim
    title: verify/str/palindromic_tree_table_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_PALINDROMIC_TREE_TABLE:\n    ## \u672B\u5C3E\u8FFD\
    \u52A0\u306B\u5BFE\u5FDC\u3059\u308B\u56DE\u6587\u6728\u3002T\u306F\u30CF\u30C3\
    \u30B7\u30E5\u3068\u7B49\u5024\u6BD4\u8F03\u306B\u5BFE\u5FDC\u3059\u308B\u578B\
    \u3002\n    ## \u8A08\u7B97\u91CF\u306F\u8981\u7D20\u306E\u30B3\u30D4\u30FC\u30FB\
    \u30CF\u30C3\u30B7\u30E5\u30FB\u7B49\u5024\u6BD4\u8F03\u304CO(1)\u306E\u5834\u5408\
    \u3002Table\u306E\u64CD\u4F5C\u306B\u306F\u30CF\u30C3\u30B7\u30E5\u306E\u5E73\u5747\
    O(1)\u3092\u4EEE\u5B9A\u3059\u308B\u3002\n    const CPLIB_STR_PALINDROMIC_TREE_TABLE*\
    \ = 1\n    import tables\n\n    type\n        TablePalindromicTreeCountState =\
    \ ref object\n            updated: bool\n        TablePalindromicTreeNode*[T]\
    \ = ref object\n            link*: Table[T, TablePalindromicTreeNode[T]]\n   \
    \         parent*: TablePalindromicTreeNode[T] # link\u306E\u9006\u5411\u304D\u306E\
    \u30EA\u30F3\u30AF\u3002\u6839\u3067\u306Fnil\n            suffix_link*: TablePalindromicTreeNode[T]\n\
    \            series_link*: TablePalindromicTreeNode[T] # \u9577\u3055\u306E\u5DEE\
    \u5206\u304C\u7570\u306A\u308B\u6700\u9577\u306E\u63A5\u5C3E\u56DE\u6587\u3078\
    \u306E\u30EA\u30F3\u30AF\n            character*: T # \u89AA\u306E\u4E21\u7AEF\
    \u306B\u8FFD\u52A0\u3057\u305F\u8981\u7D20\u3002\u6839\u3067\u306F\u4F7F\u7528\
    \u3057\u306A\u3044\n            len, id, diff: int\n            terminal_count,\
    \ total_count: int\n            count_state: TablePalindromicTreeCountState\n\
    \        TablePalindromicTree*[T] = object\n            data: seq[T]\n       \
    \     count_state: TablePalindromicTreeCountState\n            nodes*: seq[TablePalindromicTreeNode[T]]\n\
    \            last_node*: TablePalindromicTreeNode[T]\n            prefix_nodes*:\
    \ seq[TablePalindromicTreeNode[T]] # \u5404\u63A5\u982D\u8F9E\u306E\u6700\u9577\
    \u56DE\u6587\u63A5\u5C3E\u8F9E\u3002\u7A7A\u306E\u63A5\u982D\u8F9E\u306F\u542B\
    \u307E\u306A\u3044\n\n    proc len*[T](node: TablePalindromicTreeNode[T]): int\
    \ =\n        ## \u56DE\u6587\u306E\u9577\u3055\u3092O(1)\u3067\u8FD4\u3059\u3002\
    \n        node.len\n\n    proc count*[T](node: TablePalindromicTreeNode[T]): int\
    \ =\n        ## O(1)\u3002update_count\u5F8C\u306F\u7DCF\u51FA\u73FE\u56DE\u6570\
    \u3001\u69CB\u7BC9\u30FB\u8FFD\u52A0\u5F8C\u306F\u6700\u9577\u56DE\u6587\u63A5\
    \u5C3E\u8F9E\u3068\u3057\u3066\u306E\u51FA\u73FE\u56DE\u6570\u3092\u8FD4\u3059\
    \u3002\n        if node.count_state.updated: node.total_count else: node.terminal_count\n\
    \n    proc id*[T](node: TablePalindromicTreeNode[T]): int =\n        ## \u30CE\
    \u30FC\u30C9\u306EID\u3092O(1)\u3067\u8FD4\u3059\u3002\u9577\u3055-1\u30680\u306E\
    \u6839\u306EID\u306F\u305D\u308C\u305E\u308C0\u30681\u3002\n        node.id\n\n\
    \    proc diff*[T](node: TablePalindromicTreeNode[T]): int =\n        ## suffix_link\u5148\
    \u3068\u306E\u9577\u3055\u306E\u5DEE\u3092O(1)\u3067\u8FD4\u3059\u3002\u6839\u3067\
    \u306F0\u3092\u8FD4\u3059\u3002\n        node.diff\n\n    proc len*[T](pt: TablePalindromicTree[T]):\
    \ int =\n        ## \u73FE\u5728\u306E\u5217\u306E\u9577\u3055\u3092O(1)\u3067\
    \u8FD4\u3059\u3002\n        pt.data.len\n\n    proc newTablePalindromicTreeNode[T](pt:\
    \ var TablePalindromicTree[T], length: int): TablePalindromicTreeNode[T] =\n \
    \       ## \u30CE\u30FC\u30C9\u3092\u751F\u6210\u3057\u3066\u6728\u306B\u8FFD\u52A0\
    \u3059\u308B\u3002\u511F\u5374O(1)\u3002\n        result = TablePalindromicTreeNode[T](link:\
    \ initTable[T, TablePalindromicTreeNode[T]](2),\n            len: length, id:\
    \ pt.nodes.len, count_state: pt.count_state)\n        pt.nodes.add(result)\n\n\
    \    proc initTablePalindromicTree*[T](): TablePalindromicTree[T] =\n        ##\
    \ \u7A7A\u306E\u56DE\u6587\u6728\u3092O(1)\u3067\u4F5C\u308B\u3002last_node\u306F\
    \u9577\u30550\u306E\u6839\u3092\u6307\u3059\u3002\n        result.count_state\
    \ = TablePalindromicTreeCountState()\n        discard result.newTablePalindromicTreeNode(-1)\n\
    \        discard result.newTablePalindromicTreeNode(0)\n        result.nodes[1].suffix_link\
    \ = result.nodes[0]\n        result.nodes[1].series_link = result.nodes[0]\n \
    \       result.last_node = result.nodes[1]\n\n    proc find_longest[T](pt: TablePalindromicTree[T],\
    \ node: TablePalindromicTreeNode[T]): TablePalindromicTreeNode[T] =\n        ##\
    \ \u672B\u5C3E\u306E\u8981\u7D20\u3067\u4E21\u7AEF\u3092\u62E1\u5F35\u3067\u304D\
    \u308B\u6700\u9577\u306E\u63A5\u5C3E\u56DE\u6587\u3092\u63A2\u3059\u3002\u6700\
    \u60AAO(pt.len)\u3002\n        result = node\n        let pos = pt.data.len -\
    \ 1\n        while true:\n            let left = pos - result.len - 1\n      \
    \      if left >= 0 and pt.data[left] == pt.data[pos]: return\n            result\
    \ = result.suffix_link\n\n    proc add*[T](pt: var TablePalindromicTree[T], value:\
    \ T): TablePalindromicTreeNode[T] {.discardable.} =\n        ## \u672B\u5C3E\u306B\
    \u8981\u7D20\u3092\u8FFD\u52A0\u3057\u3001\u6700\u9577\u56DE\u6587\u63A5\u5C3E\
    \u8F9E\u3092\u8FD4\u3059\u3002\u671F\u5F85\u511F\u5374O(1)\u30011\u56DE\u306E\u6700\
    \u60AAO(pt.len)\u3002\n        ## \u51FA\u73FE\u56DE\u6570\u306E\u96C6\u8A08\u3092\
    \u7121\u52B9\u5316\u3059\u308B\u3002\u7DCF\u51FA\u73FE\u56DE\u6570\u304C\u5FC5\
    \u8981\u306A\u3089update_count\u3067\u518D\u96C6\u8A08\u3059\u308B\u3002\n   \
    \     pt.data.add(value)\n        let parent = pt.find_longest(pt.last_node)\n\
    \        result = parent.link.getOrDefault(value)\n        if result == nil:\n\
    \            result = pt.newTablePalindromicTreeNode(parent.len + 2)\n       \
    \     result.parent = parent\n            result.character = value\n         \
    \   if parent == pt.nodes[0]:\n                result.suffix_link = pt.nodes[1]\n\
    \            else:\n                result.suffix_link = pt.find_longest(parent.suffix_link).link[value]\n\
    \            let suffix = result.suffix_link\n            result.diff = result.len\
    \ - suffix.len\n            result.series_link = if result.diff == suffix.diff:\
    \ suffix.series_link else: suffix\n            parent.link[value] = result\n \
    \       inc result.terminal_count\n        pt.prefix_nodes.add(result)\n     \
    \   pt.last_node = result\n        pt.count_state.updated = false\n\n    proc\
    \ initTablePalindromicTree*[T](a: openArray[T]): TablePalindromicTree[T] =\n \
    \       ## \u5217\u304B\u3089\u56DE\u6587\u6728\u3092\u69CB\u7BC9\u3059\u308B\u3002\
    \u30CF\u30C3\u30B7\u30E5\u3068\u7B49\u5024\u6BD4\u8F03\u304CO(1)\u306A\u3089\u671F\
    \u5F85O(a.len)\u3002\n        result = initTablePalindromicTree[T]()\n       \
    \ for value in a:\n            result.add(value)\n\n    proc get_palindrome*[T](node:\
    \ TablePalindromicTreeNode[T]): seq[T] =\n        ## \u89AA\u30EA\u30F3\u30AF\u304B\
    \u3089\u56DE\u6587\u3092O(node.len)\u3067\u5FA9\u5143\u3059\u308B\u3002\u6839\u3067\
    \u306F\u7A7A\u306E\u5217\u3092\u8FD4\u3059\u3002\n        result = newSeq[T](max(0,\
    \ node.len))\n        var current = node\n        var left = 0\n        var right\
    \ = result.len - 1\n        while current.len > 0:\n            result[left] =\
    \ current.character\n            result[right] = current.character\n         \
    \   inc left\n            dec right\n            current = current.parent\n\n\
    \    proc get_palindrome*[T](pt: TablePalindromicTree[T], node: TablePalindromicTreeNode[T]):\
    \ seq[T] =\n        ## \u6307\u5B9A\u3057\u305F\u30CE\u30FC\u30C9\u306E\u56DE\u6587\
    \u3092O(node.len)\u3067\u5FA9\u5143\u3059\u308B\u3002\n        node.get_palindrome()\n\
    \n    proc update_count*[T](pt: TablePalindromicTree[T]) =\n        ## \u73FE\u5728\
    \u306E\u5217\u3067\u306E\u5404\u56DE\u6587\u306E\u7DCF\u51FA\u73FE\u56DE\u6570\
    \u3092O(pt.nodes.len)\u3067\u518D\u96C6\u8A08\u3059\u308B\u3002\u7E70\u308A\u8FD4\
    \u3057\u547C\u3073\u51FA\u3057\u53EF\u80FD\u3002\n        for node in pt.nodes:\n\
    \            node.total_count = node.terminal_count\n        for i in countdown(pt.nodes.len\
    \ - 1, 1):\n            let node = pt.nodes[i]\n            node.suffix_link.total_count\
    \ += node.total_count\n        pt.count_state.updated = true\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/palindromic_tree_table.nim
  requiredBy: []
  timestamp: '2026-10-01 03:07:49+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/palindromic_tree_table_test.nim
  - verify/str/palindromic_tree_table_test.nim
documentation_of: cplib/str/palindromic_tree_table.nim
layout: document
redirect_from:
- /library/cplib/str/palindromic_tree_table.nim
- /library/cplib/str/palindromic_tree_table.nim.html
title: cplib/str/palindromic_tree_table.nim
---
