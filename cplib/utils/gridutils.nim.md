---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/gridutils_test.nim
    title: verify/AI/gridutils_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/gridutils_test.nim
    title: verify/AI/gridutils_test.nim
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
  code: "when not declared CPLIB_UTILS_GRIDUTILS:\n    const CPLIB_UTILS_GRIDUTILS*\
    \ = 1\n\n    const dij4* = @[(0,1),(-1,0),(0,-1),(1,0)]\n    const dij8* = @[(0,1),(-1,1),(-1,0),(-1,-1),(0,-1),(1,-1),(1,0),(1,1)]\n\
    \n    iterator griditer*(i,j,H,W:int,dij:openArray[(int,int)] = dij4):(int,int)=\n\
    \        for (di,dj) in dij:\n            if i+di in 0..<H and j+dj in 0..<W:\n\
    \                yield (i+di,j+dj)\n    \n    proc gridfind*[T](grid : openArray[seq[T]],value:T):(int,int)=\n\
    \        # \u898B\u3064\u304B\u3063\u305F\u3089 (i,j) \u306E\u5185\u8F9E\u66F8\
    \u9806\u6700\u5C0F\n        # \u305D\u3046\u3067\u306A\u3044\u5834\u5408\u306F\
    \ (-1,-1)\n        for i in 0..<len(grid):\n            for j in 0..<len(grid[i]):\n\
    \                if grid[i][j] == value:\n                    return (i,j)\n \
    \       return (-1,-1)\n\n    proc gridfinds*[T](grid : openArray[seq[T]],value:T):seq[(int,int)]=\n\
    \        for i in 0..<len(grid):\n            for j in 0..<len(grid[i]):\n   \
    \             if grid[i][j] == value:\n                    result.add((i,j))\n\
    \n    proc gridfind*(grid : openArray[string],value:char):(int,int)=\n       \
    \ # \u898B\u3064\u304B\u3063\u305F\u3089 (i,j) \u306E\u5185\u8F9E\u66F8\u9806\u6700\
    \u5C0F\n        # \u305D\u3046\u3067\u306A\u3044\u5834\u5408\u306F (-1,-1)\n \
    \       for i in 0..<len(grid):\n            for j in 0..<len(grid[i]):\n    \
    \            if grid[i][j] == value:\n                    return (i,j)\n     \
    \   return (-1,-1)\n\n    proc gridfinds*(grid : openArray[string],value:char):seq[(int,int)]=\n\
    \        for i in 0..<len(grid):\n            for j in 0..<len(grid[i]):\n   \
    \             if grid[i][j] == value:\n                    result.add((i,j))\n\
    \n    proc height*[T](grid: openArray[seq[T]]): int {.inline.} =\n        grid.len\n\
    \n    proc height*(grid: openArray[string]): int {.inline.} =\n        grid.len\n\
    \n    proc width*[T](grid: openArray[seq[T]]): int {.inline.} =\n        if grid.len\
    \ == 0: 0 else: grid[0].len\n\n    proc width*(grid: openArray[string]): int {.inline.}\
    \ =\n        if grid.len == 0: 0 else: grid[0].len\n    \n    proc getid*[T](grid:\
    \ openArray[seq[T]],i,j:int):int=\n        return i*(grid.width) + j\n\n    proc\
    \ getid*(grid: openArray[string],i,j:int):int=\n        return i*(grid.width)\
    \ + j\n\n    proc to_pos*[T](grid: openArray[seq[T]],id:int):(int,int)=\n    \
    \    return (id div grid.width,id mod grid.width)\n\n    proc to_pos*(grid: openArray[string],id:int):(int,int)=\n\
    \        return (id div grid.width,id mod grid.width)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/gridutils.nim
  requiredBy: []
  timestamp: '2026-07-06 19:10:53+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/gridutils_test.nim
  - verify/AI/gridutils_test.nim
documentation_of: cplib/utils/gridutils.nim
layout: document
redirect_from:
- /library/cplib/utils/gridutils.nim
- /library/cplib/utils/gridutils.nim.html
title: cplib/utils/gridutils.nim
---
