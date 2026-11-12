---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/memo_test.nim
    title: verify/AI/memo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/memo_test.nim
    title: verify/AI/memo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/memo_test.nim
    title: verify/utils/memo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/memo_test.nim
    title: verify/utils/memo_test.nim
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
  code: "when not declared CPLIB_UTILS_MEMO:\n    const CPLIB_UTILS_MEMO* = 1\n  \
    \  import macros\n    import tables\n    macro memo*(p: untyped): untyped =\n\
    \        ## \u95A2\u6570\u306E\u623B\u308A\u5024\u3092\u5F15\u6570\u3054\u3068\
    \u306B\u30AD\u30E3\u30C3\u30B7\u30E5\u3059\u308B\u3002\u524D\u65B9\u5BA3\u8A00\
    \u3092\u4F7F\u3063\u305F\u76F8\u4E92\u518D\u5E30\u306B\u3082\u5BFE\u5FDC\u3059\
    \u308B\u3002\n        expectKind(p, nnkProcDef)\n\n        let name = p[0]\n \
    \       let params = p[3]\n        let retType = params[0]\n\n        if retType.kind\
    \ == nnkEmpty:\n            error(\"memo proc must have an explicit return type\"\
    , p)\n\n        var argNames: seq[NimNode] = @[]\n        var argTypes: seq[NimNode]\
    \ = @[]\n\n        for i in 1 ..< params.len:\n            let identDefs = params[i]\n\
    \            let typ = identDefs[^2]\n\n            for j in 0 ..< identDefs.len\
    \ - 2:\n                argNames.add identDefs[j]\n                argTypes.add\
    \ typ\n\n        if argNames.len == 0:\n            error(\"memo proc must have\
    \ at least one argument\", p)\n\n        let keyType =\n            if argNames.len\
    \ == 1:\n                argTypes[0]\n            else:\n                var t\
    \ = nnkTupleTy.newTree()\n                for i in 0 ..< argNames.len:\n     \
    \               t.add nnkIdentDefs.newTree(\n                        argNames[i],\n\
    \                        argTypes[i],\n                        newEmptyNode()\n\
    \                    )\n                t\n\n        let keyExpr =\n         \
    \   if argNames.len == 1:\n                argNames[0]\n            else:\n  \
    \              var t = nnkTupleConstr.newTree()\n                for i in 0 ..<\
    \ argNames.len:\n                    t.add nnkExprColonExpr.newTree(argNames[i],\
    \ argNames[i])\n                t\n\n        let cacheName = genSym(nskVar, $name\
    \ & \"Cache\")\n        let implName = genSym(nskProc, $name & \"Impl\")\n   \
    \     let keyName = genSym(nskLet, \"key\")\n\n        # \u5B9F\u88C5\u95A2\u6570\
    \u3092\u30E9\u30C3\u30D1\u30FC\u5185\u306B\u7F6E\u304D\u3001\u524D\u65B9\u5BA3\
    \u8A00\u306E\u91CD\u8907\u3092\u907F\u3051\u308B\u3002\n        var implProc =\
    \ copyNimTree(p)\n        implProc[0] = implName\n        implProc[4] = newEmptyNode()\n\
    \n        # impl(args...) \u306E\u547C\u3073\u51FA\u3057\u5F0F\n        var callImpl\
    \ = newCall(implName)\n        for a in argNames:\n            callImpl.add(a)\n\
    \n        # \u30AD\u30E3\u30C3\u30B7\u30E5\u4ED8\u304D\u30E9\u30C3\u30D1\u30FC\
    \n        var wrapperProc = copyNimTree(p)\n        wrapperProc[4] = newEmptyNode()\n\
    \        wrapperProc[6] = quote do:\n            `implProc`\n            let `keyName`\
    \ = `keyExpr`\n\n            if `cacheName`.hasKey(`keyName`):\n             \
    \   return `cacheName`[`keyName`]\n\n            result = `callImpl`\n       \
    \     `cacheName`[`keyName`] = result\n\n        result = quote do:\n        \
    \    var `cacheName` = initTable[`keyType`, `retType`]()\n            `wrapperProc`\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/memo.nim
  requiredBy: []
  timestamp: '2026-10-30 10:23:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/memo_test.nim
  - verify/AI/memo_test.nim
  - verify/utils/memo_test.nim
  - verify/utils/memo_test.nim
documentation_of: cplib/utils/memo.nim
layout: document
redirect_from:
- /library/cplib/utils/memo.nim
- /library/cplib/utils/memo.nim.html
title: cplib/utils/memo.nim
---
