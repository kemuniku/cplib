---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_line_add_get_min_test.nim
    title: verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_line_add_get_min_test.nim
    title: verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_test.nim
    title: verify/collections/convex_hull_trick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/convex_hull_trick_test.nim
    title: verify/collections/convex_hull_trick_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_CONVEX_HULL_TRICK:\n    const CPLIB_COLLECTIONS_CONVEX_HULL_TRICK*\
    \ = 1\n    import cplib/math/int128\n    import cplib/collections/avltreenode\n\
    \    import cplib/collections/private/convex_hull_trick_impl\n\n    type ConvexHullTrick*\
    \ = object\n        root: AvlTreeNode[CHTLine]\n\n    proc initConvexHullTrick*():\
    \ ConvexHullTrick =\n        ## \u50BE\u304D\u30FB\u30AF\u30A8\u30EA\u5EA7\u6A19\
    \u304C\u4EFB\u610F\u306E\u6700\u5C0F\u5024CHT\u3092\u521D\u671F\u5316\u3057\u307E\
    \u3059\u3002O(1)\u3002\n        ConvexHullTrick()\n\n    proc chtSetStart(node,\
    \ previous: AvlTreeNode[CHTLine]) =\n        ## \u76F4\u7DDA\u304C\u6700\u5C0F\
    \u306B\u306A\u308B\u533A\u9593\u306E\u5DE6\u7AEF\u3092\u66F4\u65B0\u3057\u307E\
    \u3059\u3002O(1)\u3002\n        if not node.isNil:\n            node.key.start\
    \ = if previous.isNil: -(to_Int128(1) << 65)\n                             else:\
    \ chtStart(previous.key, node.key)\n\n    proc add_line*(self: var ConvexHullTrick,\
    \ a, b: int) =\n        ## \u4EFB\u610F\u306E\u50BE\u304D\u306Eax+b\u3092\u8FFD\
    \u52A0\u3057\u307E\u3059\u3002\u511F\u5374O(log N)\u3002\n        let line = CHTLine(a:\
    \ a, b: b)\n        var (left, right) = self.root.lower_bound_node(line)\n   \
    \     if not right.isNil and right.key.a == a:\n            if right.key.b <=\
    \ b: return\n            let next = right.next\n            self.root = self.root.erase(right,\
    \ next)\n            right = next\n        if not left.isNil and not right.isNil\
    \ and chtRedundant(left.key, line, right.key):\n            return\n        while\
    \ not left.isNil:\n            let previous = left.prev\n            if previous.isNil\
    \ or not chtRedundant(previous.key, left.key, line): break\n            self.root\
    \ = self.root.erase(left, right)\n            left = previous\n        while not\
    \ right.isNil:\n            let next = right.next\n            if next.isNil or\
    \ not chtRedundant(line, right.key, next.key): break\n            self.root =\
    \ self.root.erase(right, next)\n            right = next\n        let node = AvlTreeNode[CHTLine](key:\
    \ line, h: 1, len: 1)\n        chtSetStart(node, left)\n        chtSetStart(right,\
    \ node)\n        self.root = self.root.insert(node)\n\n    proc get_min*(self:\
    \ ConvexHullTrick, x: int): int =\n        ## \u4EFB\u610F\u306E\u6574\u6570\u5EA7\
    \u6A19x\u3067\u306E\u6700\u5C0F\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\u5EA7\
    \u6A19\u306E\u4E8B\u524D\u767B\u9332\u306F\u4E0D\u8981\u3002\u7A7A\u306E\u5834\
    \u5408\u306Fassert\u3002O(log N)\u3002\n        assert not self.root.isNil, \"\
    CHT: no lines\"\n        var node = self.root\n        var best: AvlTreeNode[CHTLine]\n\
    \        let coordinate = to_Int128(x)\n        while not node.isNil:\n      \
    \      if node.key.start <= coordinate:\n                best = node\n       \
    \         node = node.r\n            else:\n                node = node.l\n  \
    \      chtAnswer(chtValue(best.key, x))\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: false
  path: cplib/collections/convex_hull_trick.nim
  requiredBy: []
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - verify/collections/convex_hull_trick_line_add_get_min_test.nim
  - verify/collections/convex_hull_trick_test.nim
  - verify/collections/convex_hull_trick_test.nim
documentation_of: cplib/collections/convex_hull_trick.nim
layout: document
redirect_from:
- /library/cplib/collections/convex_hull_trick.nim
- /library/cplib/collections/convex_hull_trick.nim.html
title: cplib/collections/convex_hull_trick.nim
---
