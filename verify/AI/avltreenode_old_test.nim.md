---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode_old.nim
    title: cplib/collections/avltreenode_old.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode_old.nim
    title: cplib/collections/avltreenode_old.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport cplib/collections/avltreenode_old\n\nproc newNode(x:\
    \ int): AvlTreeNode[int] =\n  let nilNode = get_avltree_nilnode[int]()\n  AvlTreeNode[int](p:\
    \ nilNode, l: nilNode, r: nilNode, h: 1, len: 1, key: x)\n\nlet nilNode = get_avltree_nilnode[int]()\n\
    var root = nilNode\nlet n2 = newNode(2)\nlet n1 = newNode(1)\nlet n3 = newNode(3)\n\
    root = root.insert(n2)\nroot = root.insert(n1)\nroot = root.insert(n3)\n\nassert\
    \ root.rootOf == root\nassert root.len == 3\nassert root.get(0).key == 1\nassert\
    \ root.get(1).key == 2\nassert root.get(2).key == 3\nassert root.get(3) == nilNode\n\
    assert root.get(1).index == 1\nassert root.get(1).prev.key == 1\nassert root.get(1).next.key\
    \ == 3\n\nlet (lbLeft, lbRight) = root.lower_bound_node(2)\nassert lbLeft.key\
    \ == 1\nassert lbRight.key == 2\nlet (ubLeft, ubRight) = root.upper_bound_node(2)\n\
    assert ubLeft.key == 2\nassert ubRight.key == 3\n\nlet erased = root.get(1)\n\
    root = root.erase(erased, erased.next)\nassert root.len == 2\nassert root.get(0).key\
    \ == 1\nassert root.get(1).key == 3\nassert erased.l == nilNode and erased.r ==\
    \ nilNode and erased.p == nilNode\n"
  dependsOn:
  - cplib/collections/avltreenode_old.nim
  - cplib/collections/avltreenode_old.nim
  isVerificationFile: true
  path: verify/AI/avltreenode_old_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/avltreenode_old_test.nim
layout: document
redirect_from:
- /verify/verify/AI/avltreenode_old_test.nim
- /verify/verify/AI/avltreenode_old_test.nim.html
title: verify/AI/avltreenode_old_test.nim
---
