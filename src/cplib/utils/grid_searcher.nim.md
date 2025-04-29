---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_get_test_.nim
    title: verify/utils/grid_searcher/skate_get_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_get_test_.nim
    title: verify/utils/grid_searcher/skate_get_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_get_tuple_test_.nim
    title: verify/utils/grid_searcher/skate_get_tuple_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_get_tuple_test_.nim
    title: verify/utils/grid_searcher/skate_get_tuple_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_test_.nim
    title: verify/utils/grid_searcher/skate_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_test_.nim
    title: verify/utils/grid_searcher/skate_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_tuple_test_.nim
    title: verify/utils/grid_searcher/skate_tuple_test_.nim
  - icon: ':warning:'
    path: verify/utils/grid_searcher/skate_tuple_test_.nim
    title: verify/utils/grid_searcher/skate_tuple_test_.nim
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
  code: "when not declared CPLIB_UTILS_GRID_SEARCHER:\n    const CPLIB_UTILS_GRID_SEARCHER*\
    \ = 1\n    import cplib/collections/avlset\n    import options\n    type GridSearcher\
    \ = object\n        row : AvlSortedMultiSet[(int,int)]\n        col : AvlSortedMultiSet[(int,int)]\n\
    \n    proc initGridSearcher*():GridSearcher=\n        return GridSearcher(row:initAvlSortedMultiSet[(int,int)](),col:initAvlSortedMultiSet[(int,int)]())\n\
    \n    proc incl*(grid:var GridSearcher,i,j:int)=\n        grid.row.incl((i,j))\n\
    \        grid.col.incl((j,i))\n    \n    proc incl*(grid:var GridSearcher,ij:(int,int))=\n\
    \        grid.row.incl(ij)\n        grid.col.incl((ij[1],ij[0]))\n\n    proc excl*(grid:var\
    \ GridSearcher,i,j:int)=\n        grid.row.excl((i,j))\n        grid.col.excl((j,i))\n\
    \n    proc excl*(grid:var GridSearcher,ij:(int,int))=\n        grid.row.excl(ij)\n\
    \        grid.col.excl((ij[1],ij[0]))\n\n    proc contains*(grid:GridSearcher,i,j:int):bool=grid.row.contains((i,j))\n\
    \    proc contains*(grid:GridSearcher,ij:(int,int)):bool=grid.row.contains(ij)\n\
    \n    proc up*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n        ## (i,j)\u3088\
    \u308A\u3082\u4E0A\u306B\u3042\u308B\u58C1(=j\u304C\u7B49\u3057\u304F\u3066i\u3088\
    \u308A\u5C0F\u3055\u3044\u3088\u3046\u306A\u5834\u6240\u306B\u3042\u308B\u58C1\
    )\u3092\u63A2\u3059\n        result = grid.col.lt((j,i))\n        if result.isNone()\
    \ or result.get()[0] != j:\n            return none((int,int))\n        var (j,i)\
    \ = result.get()\n        return some((i,j))\n    \n    proc up*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.up(ij[0],ij[1])\n\n    proc up_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u4E0A\u306B\u3042\u308B\u58C1(=j\u304C\u7B49\
    \u3057\u304F\u3066i\u3088\u308A\u5C0F\u3055\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3057\u3001(i+1,j)\u3092\u8FD4\u3059\n \
    \       result = grid.col.lt((j,i))\n        if result.isNone() or result.get()[0]\
    \ != j:\n            return none((int,int))\n        var (j,i) = result.get()\n\
    \        return some((i+1,j))\n    \n    proc up_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.up_move(ij[0],ij[1])\n\n\n    proc down*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u4E0B\u306B\u3042\u308B\u58C1(=j\u304C\u7B49\
    \u3057\u304F\u3066i\u3088\u308A\u5927\u304D\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3059\n        result = grid.col.gt((j,i))\n\
    \        if result.isNone() or result.get()[0] != j:\n            return none((int,int))\n\
    \        var (j,i) = result.get()\n        return some((i,j))\n    \n    proc\
    \ down*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n        return\
    \ grid.down(ij[0],ij[1])\n\n    proc down_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u4E0B\u306B\u3042\u308B\u58C1(=j\u304C\u7B49\
    \u3057\u304F\u3066i\u3088\u308A\u5927\u304D\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3057\u3001(i-1,j)\u3092\u8FD4\u3059\n \
    \       result = grid.col.gt((j,i))\n        if result.isNone() or result.get()[0]\
    \ != j:\n            return none((int,int))\n        var (j,i) = result.get()\n\
    \        return some((i-1,j))\n\n    proc down_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.down_move(ij[0],ij[1])\n\n    proc left*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u5DE6\u306B\u3042\u308B\u58C1(=i\u304C\u7B49\
    \u3057\u304F\u3066j\u3088\u308A\u5C0F\u3055\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3059\n        result = grid.row.lt((i,j))\n\
    \        if result.isNone() or  result.get()[0] != i:\n            return none((int,int))\n\
    \    \n    proc left*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.left(ij[0],ij[1])\n\n    proc left_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u5DE6\u306B\u3042\u308B\u58C1(=i\u304C\u7B49\
    \u3057\u304F\u3066j\u3088\u308A\u5C0F\u3055\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3057\u3001(i,j+1)\u3092\u8FD4\u3059\n \
    \       result = grid.row.lt((i,j))\n        if result.isNone() or  result.get()[0]\
    \ != i:\n            return none((int,int))\n        var (i,j) = result.get()\n\
    \        return some((i,j+1))\n    \n    proc left_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.left_move(ij[0],ij[1])\n\n    proc right*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u53F3\u306B\u3042\u308B\u58C1(=i\u304C\u7B49\
    \u3057\u304F\u3066j\u3088\u308A\u5927\u304D\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3059\n        result = grid.row.gt((i,j))\n\
    \        if result.isNone() or result.get()[0] != i:\n            return none((int,int))\n\
    \    \n    proc right*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.right(ij[0],ij[1])\n\n    proc right_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=\n\
    \        ## (i,j)\u3088\u308A\u3082\u53F3\u306B\u3042\u308B\u58C1(=i\u304C\u7B49\
    \u3057\u304F\u3066j\u3088\u308A\u5927\u304D\u3044\u3088\u3046\u306A\u5834\u6240\
    \u306B\u3042\u308B\u58C1)\u3092\u63A2\u3057\u3001(i,j-1)\u3092\u8FD4\u3059\n \
    \       result = grid.row.gt((i,j))\n        if result.isNone() or result.get()[0]\
    \ != i:\n            return none((int,int))\n        var (i,j) = result.get()\n\
    \        return some((i,j-1))\n    \n    proc right_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=\n\
    \        return grid.right_move(ij[0],ij[1])\n\n    proc updownleftright*(grid:var\
    \ GridSearcher,i,j:int):array[4, Option[(int,int)]]=\n        return [grid.up(i,j),grid.down(i,j),grid.left(i,j),grid.right(i,j)]\n\
    \    \n    proc updownleftright*(grid:var GridSearcher,ij:(int,int)):array[4,\
    \ Option[(int,int)]]=\n        return [grid.up(ij),grid.down(ij),grid.left(ij),grid.right(ij)]\n\
    \n    proc updownleftright_get*(grid:var GridSearcher,i,j:int):seq[(int,int)]=\n\
    \        for xy in grid.updownleftright(i,j):\n            if xy.isSome():\n \
    \               result.add(xy.get())\n    \n    proc updownleftright_get*(grid:var\
    \ GridSearcher,ij:(int,int)):seq[(int,int)]=\n        for xy in grid.updownleftright(ij):\n\
    \            if xy.isSome():\n                result.add(xy.get())\n\n    proc\
    \ updownleftright_move*(grid:var GridSearcher,i,j:int):array[4, Option[(int,int)]]=\n\
    \        return [grid.up_move(i,j),grid.down_move(i,j),grid.left_move(i,j),grid.right_move(i,j)]\n\
    \n    proc updownleftright_move*(grid:var GridSearcher,ij:(int,int)):array[4,\
    \ Option[(int,int)]]=\n        return [grid.up_move(ij),grid.down_move(ij),grid.left_move(ij),grid.right_move(ij)]\n\
    \    \n    proc updownleftright_move_get*(grid:var GridSearcher,i,j:int):seq[(int,int)]=\n\
    \        for xy in grid.updownleftright_move(i,j):\n            if xy.isSome():\n\
    \                result.add(xy.get())\n    \n    proc updownleftright_move_get*(grid:var\
    \ GridSearcher,ij:(int,int)):seq[(int,int)]=\n        for xy in grid.updownleftright_move(ij):\n\
    \            if xy.isSome():\n                result.add(xy.get())\n\n\n    proc\
    \ len*(grid:GridSearcher):int=\n        return len(grid.row)"
  dependsOn:
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  isVerificationFile: false
  path: cplib/utils/grid_searcher.nim
  requiredBy:
  - verify/utils/grid_searcher/skate_get_test_.nim
  - verify/utils/grid_searcher/skate_get_test_.nim
  - verify/utils/grid_searcher/skate_get_tuple_test_.nim
  - verify/utils/grid_searcher/skate_get_tuple_test_.nim
  - verify/utils/grid_searcher/skate_test_.nim
  - verify/utils/grid_searcher/skate_test_.nim
  - verify/utils/grid_searcher/skate_tuple_test_.nim
  - verify/utils/grid_searcher/skate_tuple_test_.nim
  timestamp: '2025-04-27 19:08:43+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/utils/grid_searcher.nim
layout: document
redirect_from:
- /library/cplib/utils/grid_searcher.nim
- /library/cplib/utils/grid_searcher.nim.html
title: cplib/utils/grid_searcher.nim
---
