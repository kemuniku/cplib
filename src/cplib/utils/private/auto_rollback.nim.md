---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
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
  code: "when not declared CPLIB_UTILS_PRIVATE_AUTO_ROLLBACK:\n    const CPLIB_UTILS_PRIVATE_AUTO_ROLLBACK*\
    \ = 1\n    import macros, bitops\n    import cplib/utils/private/temporary_rollback_log\n\
    \n    type AutoRollbackLog = seq[proc() {.closure.}]\n\n    proc remember[T](history:\
    \ var AutoRollbackLog, location: ptr T) =\n        ## \u5B89\u5B9A\u3057\u305F\
    \u30A2\u30C9\u30EC\u30B9\u306B\u3042\u308B\u5024\u306E\u5FA9\u5143\u51E6\u7406\
    \u3092\u8A18\u9332\u3059\u308B\u3002\u6642\u9593\u30FB\u9818\u57DF\u306F\u5024\
    \u306E\u30B5\u30A4\u30BA\u306B\u6BD4\u4F8B\u3059\u308B\u3002\n        let previous\
    \ = location[]\n        history.add(proc() = location[] = previous)\n\n    proc\
    \ restore(history: var AutoRollbackLog, position: int) =\n        ## \u6307\u5B9A\
    \u4F4D\u7F6E\u4EE5\u964D\u306E\u5909\u66F4\u3092\u9006\u9806\u306B\u5FA9\u5143\
    \u3059\u308B\u3002\u5FA9\u5143\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\u30A4\
    \u30BA\u306B\u6BD4\u4F8B\u3059\u308B\u6642\u9593\u3002\n        while history.len\
    \ > position:\n            let undo = history.pop()\n            undo()\n\n  \
    \  proc swapLocations[T](left, right: ptr T) =\n        ## \u30A2\u30C9\u30EC\u30B9\
    \u3092\u4E00\u5EA6\u305A\u3064\u8A55\u4FA1\u3057\u305F\u5024\u3092\u4EA4\u63DB\
    \u3059\u308B\u3002\u56FA\u5B9A\u9577\u914D\u5217\u306B\u3082\u5BFE\u5FDC\u3059\
    \u308B\u3002\n        let previous = left[]\n        left[] = right[]\n      \
    \  right[] = previous\n\n    macro discardRollbackResult(body: typed): untyped\
    \ =\n        ## \u30B9\u30B3\u30FC\u30D7\u672B\u5C3E\u306E\u623B\u308A\u5024\u3060\
    \u3051\u3092\u6368\u3066\u3001return\u3084break\u306E\u5F8C\u306B\u6587\u3092\u633F\
    \u5165\u3057\u306A\u3044\u3002\n        if body.getTypeInst.typeKind in {ntyVoid,\
    \ ntyNone}:\n            body\n        else:\n            newTree(nnkDiscardStmt,\
    \ body)\n\n    template autoRollbackOriginal(target: untyped) {.pragma.}\n\n \
    \   proc originalUpdate(symbol: NimNode): NimNode {.compileTime.} =\n        ##\
    \ \u65E2\u306B\u81EA\u52D5\u5909\u63DB\u3055\u308C\u305F\u540C\u540D\u306E\u95A2\
    \u6570\u304B\u3089\u5143\u306E\u66F4\u65B0\u95A2\u6570\u3092\u53D6\u5F97\u3059\
    \u308B\u3002\n        if symbol.kind in {nnkClosedSymChoice, nnkOpenSymChoice}:\n\
    \            for candidate in symbol:\n                let original = originalUpdate(candidate)\n\
    \                if result.isNil: result = original\n                elif result\
    \ != original:\n                    error(\"\u81EA\u52D5rollback\u306E\u5BFE\u8C61\
    \u95A2\u6570\u3092\u4E00\u610F\u306B\u7279\u5B9A\u3067\u304D\u307E\u305B\u3093\
    \u3002\u5225\u540D\u306E\u95A2\u6570\u3067\u5305\u3093\u3067\u6307\u5B9A\u3057\
    \u3066\u304F\u3060\u3055\u3044\", symbol)\n            return\n        result\
    \ = symbol\n        while result.kind == nnkSym and result.symKind in {nskProc,\
    \ nskFunc}:\n            let impl = result.getImpl\n            var original =\
    \ result\n            for pragma in impl[4]:\n                if pragma.kind in\
    \ {nnkExprColonExpr, nnkCall} and\n                        pragma[0] == bindSym\"\
    autoRollbackOriginal\":\n                    original = pragma[1]\n          \
    \  if original == result: break\n            result = original\n\n    proc temporaryBegin()\
    \ =\n        ## \u578B\u691C\u67FB\u6642\u306B\u4E00\u6642\u5B9F\u884C\u30D6\u30ED\
    \u30C3\u30AF\u306E\u958B\u59CB\u4F4D\u7F6E\u3092\u6B8B\u3059\u3002\u5909\u63DB\
    \u5F8C\u306E\u30B3\u30FC\u30C9\u306B\u306F\u6B8B\u3089\u306A\u3044\u3002\n   \
    \     discard\n\n    proc temporaryBoundary(n: NimNode): bool {.compileTime.}\
    \ =\n        ## \u5165\u308C\u5B50\u306ETemporary\u3092\u578B\u691C\u67FB\u7528\
    \u306E\u76EE\u5370\u304B\u3089\u8B58\u5225\u3059\u308B\u3002\n        n.kind in\
    \ {nnkBlockStmt, nnkBlockExpr} and\n            n[1].kind in {nnkStmtList, nnkStmtListExpr}\
    \ and n[1].len >= 2 and\n            n[1][0].kind == nnkCall and n[1][0][0] ==\
    \ bindSym\"temporaryBegin\"\n\n    proc prepareTemporary*(body: NimNode): NimNode\
    \ {.compileTime.} =\n        ## \u5165\u308C\u5B50\u306ETemporary\u3092\u76EE\u5370\
    \u4ED8\u304D\u306E\u30D6\u30ED\u30C3\u30AF\u3078\u7F6E\u63DB\u3057\u3001\u578B\
    \u691C\u67FB\u5F8C\u306B\u307E\u3068\u3081\u3066\u5909\u63DB\u3067\u304D\u308B\
    \u3088\u3046\u306B\u3059\u308B\u3002\n        if body.kind in {nnkCall, nnkCommand}\
    \ and body.len == 2 and body[0].eqIdent(\"Temporary\"):\n            return newTree(nnkBlockStmt,\
    \ newEmptyNode(), newStmtList(\n                newCall(bindSym\"temporaryBegin\"\
    ), prepareTemporary(body[1])))\n        result = body.copyNimNode\n        for\
    \ child in body: result.add(prepareTemporary(child))\n\n    type AutoRollbackCode*\
    \ = tuple[declarations, transformed: NimNode]\n\n    proc buildAutoRollback*(target,\
    \ history: NimNode, diagnosticName: string,\n            blockMode: bool = false):\
    \ AutoRollbackCode {.compileTime.} =\n        ## \u66F4\u65B0\u95A2\u6570\u307E\
    \u305F\u306F\u30D6\u30ED\u30C3\u30AF\u3092\u5909\u63DB\u3057\u3001\u5FC5\u8981\
    \u306A\u95A2\u6570\u5B9A\u7FA9\u3068\u5909\u63DB\u7D50\u679C\u3092\u8FD4\u3059\
    \u3002\n        type Replacement = tuple[source, target: NimNode]\n        type\
    \ FunctionVersion = tuple[source, target: NimNode, readOnly, localArgs: seq[bool]]\n\
    \        var functions: seq[FunctionVersion]\n        var callPath: seq[tuple[symbol,\
    \ origin: NimNode]]\n        var forwards = newStmtList()\n        var definitions\
    \ = newStmtList()\n        var indexDeclarations = newStmtList()\n        var\
    \ indexCaches: seq[tuple[container, name: NimNode, selector: string]]\n      \
    \  let historyType = if blockMode: bindSym\"TemporaryRollbackLog\" else: bindSym\"\
    AutoRollbackLog\"\n\n        proc sourcePosition(n: NimNode): string =\n     \
    \       ## \u5143\u306E\u30BD\u30FC\u30B9\u4F4D\u7F6E\u3092\u30D5\u30A1\u30A4\u30EB\
    \u540D\u30681\u59CB\u307E\u308A\u306E\u884C\u30FB\u5217\u3067\u8868\u3059\u3002\
    \n            let position = n.lineInfoObj\n            position.filename & \"\
    :\" & $position.line & \":\" & $(position.column + 1)\n\n        proc unsupported(n:\
    \ NimNode, detail: string) =\n            ## \u539F\u56E0\u30FB\u5BFE\u8C61\u306E\
    \u5F0F\u30FB\u5B9A\u7FA9\u4F4D\u7F6E\u30FB\u547C\u3073\u51FA\u3057\u7D4C\u8DEF\
    \u3092\u307E\u3068\u3081\u3066\u5831\u544A\u3059\u308B\u3002\n            var\
    \ message = diagnosticName & \": \" & detail\n            message.add(\"\\n  \u5BFE\
    \u8C61: \" & n.repr)\n            message.add(\"\\n  \u5BFE\u8C61\u306E\u4F4D\u7F6E\
    : \" & sourcePosition(n))\n            if callPath.len > 0:\n                message.add(\"\
    \\n  \u5909\u63DB\u4E2D\u306E\u95A2\u6570: \" & callPath[^1].symbol.strVal)\n\
    \                message.add(\"\\n  \u95A2\u6570\u306E\u5B9A\u7FA9: \" & sourcePosition(callPath[^1].symbol.getImpl))\n\
    \                message.add(\"\\n  \u547C\u3073\u51FA\u3057\u7D4C\u8DEF:\")\n\
    \                for i, frame in callPath:\n                    if i == 0:\n \
    \                       message.add(\"\\n    \" & frame.symbol.strVal & \" (\"\
    \ & sourcePosition(frame.symbol.getImpl) & \")\")\n                    else:\n\
    \                        message.add(\"\\n    -> \" & frame.symbol.strVal & \"\
    \ (\" & sourcePosition(frame.origin) & \")\")\n                        message.add(\"\
    \\n       \" & frame.origin.repr)\n            let origin = if callPath.len >\
    \ 1: callPath[1].origin else: n\n            error(message, origin)\n\n      \
    \  proc isScalar(t: NimNode): bool =\n            ## \u5C65\u6B74\u306B\u5B89\u5168\
    \u306B\u5024\u3092\u4FDD\u6301\u3067\u304D\u308B\u7D44\u307F\u8FBC\u307F\u306E\
    \u578B\u304B\u5224\u5B9A\u3059\u308B\u3002\n            t.typeKind in {ntyBool,\
    \ ntyChar, ntyEnum, ntyInt, ntyInt8, ntyInt16,\n                ntyInt32, ntyInt64,\
    \ ntyUInt, ntyUInt8, ntyUInt16, ntyUInt32,\n                ntyUInt64, ntyFloat,\
    \ ntyFloat32, ntyFloat64, ntyRange}\n\n        proc concreteKind(t: NimNode):\
    \ NimTypeKind =\n            ## \u30B8\u30A7\u30CD\u30EA\u30C3\u30AF\u578B\u3082\
    \u5B9F\u4F53\u306E\u578B\u7A2E\u5225\u3067\u5224\u5B9A\u3059\u308B\u3002\n   \
    \         if t.typeKind != ntyGenericInst: return t.typeKind\n            let\
    \ impl = t.getTypeImpl\n            case impl.kind\n            of nnkObjectTy:\
    \ ntyObject\n            of nnkRefTy: ntyRef\n            of nnkTupleTy, nnkTupleConstr:\
    \ ntyTuple\n            else: impl.typeKind\n\n        proc isValue(t: NimNode):\
    \ bool =\n            ## \u53C2\u7167\u3092\u542B\u307E\u306A\u3044\u30BF\u30D7\
    \u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306F\u8981\u7D20\u3082\u5024\u578B\
    \u306A\u3089\u4FDD\u5B58\u3067\u304D\u308B\u3002\n            if isScalar(t):\
    \ return true\n            let impl = t.getTypeImpl\n            case impl.kind\n\
    \            of nnkTupleTy:\n                for field in impl:\n            \
    \        if field.kind != nnkIdentDefs or not isValue(field[^2]): return false\n\
    \                return true\n            of nnkTupleConstr:\n               \
    \ for field in impl:\n                    if not isValue(field): return false\n\
    \                return true\n            of nnkBracketExpr:\n               \
    \ return impl[0].eqIdent(\"array\") and isValue(impl[^1])\n            else:\n\
    \                return false\n\n        proc lookup(n: NimNode, replacements:\
    \ seq[Replacement]): NimNode =\n            ## \u5143\u306E\u30B7\u30F3\u30DC\u30EB\
    \u306B\u5BFE\u5FDC\u3059\u308B\u65B0\u3057\u3044\u30B7\u30F3\u30DC\u30EB\u3092\
    \u8FD4\u3059\u3002\n            for item in replacements:\n                if\
    \ n == item.source: return item.target\n            n\n\n        proc magicOf(symbol:\
    \ NimNode): string =\n            ## \u30B3\u30F3\u30D1\u30A4\u30E9\u7D44\u307F\
    \u8FBC\u307F\u64CD\u4F5C\u306E\u8B58\u5225\u540D\u3092\u53D6\u5F97\u3059\u308B\
    \u3002\n            let impl = symbol.getImpl\n            if impl.kind notin\
    \ {nnkProcDef, nnkFuncDef}: return \"\"\n            for pragma in impl[4]:\n\
    \                if pragma.kind == nnkExprColonExpr and pragma[0].eqIdent(\"magic\"\
    ):\n                    return pragma[1].strVal\n\n        proc staticCallee(n:\
    \ NimNode): NimNode =\n            ## \u95A2\u6570\u306E\u30BF\u30D7\u30EB\u30EA\
    \u30C6\u30E9\u30EB\u3092\u5B9A\u6570\u6DFB\u5B57\u3067\u9078\u3076\u547C\u3073\
    \u51FA\u3057\u3092\u9759\u7684\u306B\u89E3\u6C7A\u3059\u308B\u3002\n         \
    \   if n.kind == nnkBracketExpr and n.len == 2 and n[1].kind in {nnkIntLit..nnkUInt64Lit}:\n\
    \                let values = staticCallee(n[0])\n                let index =\
    \ n[1].intVal\n                if values.kind in {nnkTupleConstr, nnkPar, nnkBracket}\
    \ and\n                        index >= 0 and index < values.len:\n          \
    \          for value in values:\n                        if value.kind != nnkSym\
    \ or value.symKind notin {nskProc, nskFunc}: return n\n                    return\
    \ staticCallee(values[index.int])\n            n\n\n        proc containsVariant(n:\
    \ NimNode): bool =\n            ## \u30D5\u30A3\u30FC\u30EB\u30C9\u306E\u751F\u5B58\
    \u671F\u9593\u304C\u5207\u308A\u66FF\u308F\u308Bvariant object\u304B\u5224\u5B9A\
    \u3059\u308B\u3002\n            if n.kind == nnkRecCase: return true\n       \
    \     if n.kind == nnkIdentDefs: return false\n            if n.kind == nnkBracketExpr\
    \ and n.typeKind == ntyGenericInst:\n                return containsVariant(n.getTypeImpl)\n\
    \            if n.kind in {nnkSym, nnkRefTy, nnkVarTy}:\n                let t\
    \ = if n.kind == nnkSym: n.getTypeImpl else: n[0].getTypeImpl\n              \
    \  if t == n: return false\n                return containsVariant(t)\n      \
    \      for child in n:\n                if containsVariant(child): return true\n\
    \n        proc convertFunction(symbol: NimNode, readOnly: seq[bool], origin: NimNode,\n\
    \            localArgs: seq[bool] = @[]): NimNode\n        proc rewriteBody(input:\
    \ NimNode, logParam: NimNode,\n                initialReplacements: seq[Replacement],\
    \ initialLocals, readOnlyParams: seq[NimNode],\n                functionBody:\
    \ bool): NimNode\n\n        proc convertFunction(symbol: NimNode, readOnly: seq[bool],\
    \ origin: NimNode,\n            localArgs: seq[bool] = @[]): NimNode =\n     \
    \       ## \u95A2\u6570\u3068\u547C\u3073\u51FA\u3057\u5148\u3092\u5C65\u6B74\u5F15\
    \u6570\u4ED8\u304D\u306E\u95A2\u6570\u306B\u8907\u88FD\u3059\u308B\u3002\u518D\
    \u5E30\u547C\u3073\u51FA\u3057\u306B\u3082\u5BFE\u5FDC\u3059\u308B\u3002\n   \
    \         let symbol = originalUpdate(symbol)\n            if symbol.kind != nnkSym\
    \ or symbol.symKind notin {nskProc, nskFunc}:\n                unsupported(symbol,\
    \ \"\u9759\u7684\u306B\u7279\u5B9A\u3067\u304D\u308Bproc\u307E\u305F\u306Ffunc\u304C\
    \u5FC5\u8981\u3067\u3059\")\n            for item in functions:\n            \
    \    if item.source == symbol and item.readOnly == readOnly and\n            \
    \            item.localArgs == localArgs: return item.target\n            callPath.add((symbol,\
    \ origin))\n            let impl = symbol.getImpl\n            if impl.kind notin\
    \ {nnkProcDef, nnkFuncDef} or impl[6].kind == nnkEmpty:\n                unsupported(symbol,\
    \ \"\u672C\u4F53\u3092\u53D6\u5F97\u3067\u304D\u306A\u3044\u95A2\u6570\u306F\u5909\
    \u63DB\u3067\u304D\u307E\u305B\u3093\")\n            for pragma in impl[4]:\n\
    \                if not pragma.eqIdent(\"inline\") and not pragma.eqIdent(\"noinline\"\
    ) and not pragma.eqIdent(\"discardable\") and\n                        not pragma.eqIdent(\"\
    noSideEffect\") and not pragma.eqIdent(\"gensym\") and\n                     \
    \   not pragma.eqIdent(\"systemRaisesDefect\"):\n                    unsupported(pragma,\
    \ \"\u672A\u5BFE\u5FDC\u306E\u95A2\u6570pragma\u3067\u3059\")\n            let\
    \ signature = symbol.getTypeInst[0]\n            if signature[0].kind != nnkEmpty\
    \ and not isValue(signature[0]):\n                unsupported(symbol, \"\u95A2\
    \u6570\u300C\" & symbol.strVal & \"\u300D\u306E\u623B\u308A\u5024\u578B\u300C\"\
    \ &\n                    signature[0].repr & \"\u300D\u306F\u672A\u5BFE\u5FDC\u3067\
    \u3059\u3002\u623B\u308A\u5024\u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\
    \u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306B\u9650\u308A\u307E\
    \u3059\")\n            let generated = genSym(nskProc, symbol.strVal & \"WithRollback\"\
    )\n            functions.add((symbol, generated, readOnly, localArgs))\n     \
    \       let logParam = genSym(nskParam, \"history\")\n            var replacements:\
    \ seq[Replacement]\n            var locals: seq[NimNode]\n            var readOnlyParams:\
    \ seq[NimNode]\n            var params = newTree(nnkFormalParams, signature[0].copyNimTree)\n\
    \            params.add(newIdentDefs(logParam, newTree(nnkVarTy, historyType)))\n\
    \            var originalParams: seq[NimNode]\n            for i in 1..<impl[3].len:\n\
    \                for j in 0..<impl[3][i].len - 2: originalParams.add(impl[3][i][j])\n\
    \            var parameterIndex = 0\n            for i in 1..<signature.len:\n\
    \                let formal = signature[i]\n                let parameterType\
    \ = formal[^2]\n                if parameterType.kind != nnkVarTy and not isScalar(parameterType)\
    \ and\n                        concreteKind(parameterType) notin {ntyRef, ntySequence,\
    \ ntyString,\n                            ntyObject, ntyTuple, ntyArray}:\n  \
    \                  let parameter = originalParams[parameterIndex]\n          \
    \          unsupported(parameter, \"\u95A2\u6570\u300C\" & symbol.strVal & \"\u300D\
    \u306E\u7B2C\" &\n                        $(parameterIndex + 1) & \"\u5F15\u6570\
    \u300C\" & parameter.strVal & \"\u300D\u306E\u578B\u300C\" &\n               \
    \         parameterType.repr & \"\u300D\u306F\u672A\u5BFE\u5FDC\u3067\u3059\"\
    )\n                for j in 0..<formal.len - 2:\n                    let old =\
    \ originalParams[parameterIndex]\n                    if readOnly[parameterIndex]\
    \ or (parameterType.kind != nnkVarTy and\n                            concreteKind(parameterType)\
    \ in {ntyObject, ntyTuple, ntyArray}):\n                        readOnlyParams.add(old)\n\
    \                        readOnlyParams.add(formal[j])\n                    let\
    \ localArg = parameterIndex < localArgs.len and localArgs[parameterIndex]\n  \
    \                  inc parameterIndex\n                    let fresh = genSym(nskParam,\
    \ old.strVal)\n                    replacements.add((old, fresh))\n          \
    \          replacements.add((formal[j], fresh))\n                    params.add(newIdentDefs(fresh,\
    \ formal[^2].copyNimTree))\n                    if formal[^2].kind != nnkVarTy\
    \ or localArg:\n                        locals.add(old)\n                    \
    \    locals.add(formal[j])\n\n            let body = rewriteBody(impl[6], logParam,\
    \ replacements, locals, readOnlyParams, true)\n            var pragmas = newNimNode(nnkPragma)\n\
    \            for pragma in impl[4]:\n                if pragma.eqIdent(\"discardable\"\
    ): pragmas.add(ident\"discardable\")\n            let definition = newProc(generated,\
    \ [newEmptyNode()], body, pragmas = pragmas)\n            definition[3] = params\n\
    \            var forward = definition.copyNimTree\n            forward[6] = newEmptyNode()\n\
    \            forwards.add(forward)\n            definitions.add(definition)\n\
    \            discard callPath.pop()\n            result = generated\n\n      \
    \  proc rewriteBody(input: NimNode, logParam: NimNode,\n                initialReplacements:\
    \ seq[Replacement], initialLocals, readOnlyParams: seq[NimNode],\n           \
    \     functionBody: bool): NimNode =\n            ## \u95A2\u6570\u307E\u305F\u306F\
    \u4E00\u6642\u5B9F\u884C\u30D6\u30ED\u30C3\u30AF\u306E\u672C\u4F53\u3092\u691C\
    \u67FB\u3057\u3001\u5909\u66F4\u5C65\u6B74\u3092\u8A18\u9332\u3059\u308B\u5F62\
    \u3078\u5909\u63DB\u3059\u308B\u3002\n            var replacements = initialReplacements\n\
    \            var locals = initialLocals\n            proc collect(n: NimNode)\
    \ =\n                ## \u30ED\u30FC\u30AB\u30EB\u5909\u6570\u3092\u8B58\u5225\
    \u3057\u3066\u3001\u8907\u88FD\u5148\u306E\u540D\u524D\u3092\u5272\u308A\u5F53\
    \u3066\u308B\u3002\n                if temporaryBoundary(n) or n.kind == nnkConstSection:\
    \ return\n                if n.kind in {nnkProcDef, nnkFuncDef, nnkIteratorDef,\
    \ nnkLambda,\n                        nnkTemplateDef, nnkMacroDef, nnkDefer, nnkTryStmt}:\n\
    \                    unsupported(n, \"\u95A2\u6570\u5185\u306E\u95A2\u6570\u5B9A\
    \u7FA9\u30FBdefer\u30FB\u4F8B\u5916\u51E6\u7406\u306F\u672A\u5BFE\u5FDC\u3067\u3059\
    \")\n                if functionBody and n.kind == nnkSym and n.symKind == nskResult:\n\
    \                    replacements.add((n, ident\"result\"))\n                \
    \    locals.add(n)\n                if n.kind in {nnkVarSection, nnkLetSection}:\n\
    \                    for declaration in n:\n                        if declaration.kind\
    \ notin {nnkIdentDefs, nnkVarTuple}:\n                            unsupported(declaration,\
    \ \"\u672A\u5BFE\u5FDC\u306E\u5909\u6570\u5BA3\u8A00\u3067\u3059\")\n        \
    \                for i in 0..<declaration.len - 2:\n                         \
    \   let old = declaration[i]\n                            if not isValue(old.getTypeInst):\n\
    \                                unsupported(old, \"\u30ED\u30FC\u30AB\u30EB\u5909\
    \u6570\u300C\" & old.strVal & \"\u300D\u306E\u578B\u300C\" &\n               \
    \                     old.getTypeInst.repr & \"\u300D\u306F\u672A\u5BFE\u5FDC\u3067\
    \u3059\u3002\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\u30FB\
    \u56FA\u5B9A\u9577\u914D\u5217\u306B\u9650\u308A\u307E\u3059\")\n            \
    \                let kind = if n.kind == nnkVarSection: nskVar else: nskLet\n\
    \                            replacements.add((old, genSym(kind, old.strVal)))\n\
    \                            locals.add(old)\n                if n.kind == nnkForStmt:\n\
    \                    if n.len != 3 or n[0].kind != nnkSym:\n                 \
    \       unsupported(n, \"for\u306F\u5358\u4E00\u306E\u5909\u6570\u306B\u3088\u308B\
    \u6574\u6570\u533A\u9593\u306E\u8D70\u67FB\u306B\u9650\u308A\u307E\u3059\")\n\
    \                    replacements.add((n[0], genSym(nskForVar, n[0].strVal)))\n\
    \                    locals.add(n[0])\n                for child in n: collect(child)\n\
    \            collect(input)\n\n            proc fromReadOnly(n: NimNode): bool\
    \ =\n                ## \u5024\u6E21\u3057\u306E\u8907\u5408\u578B\u3092\u8D77\
    \u70B9\u3068\u3059\u308B\u53C2\u7167\u304B\u5224\u5B9A\u3059\u308B\u3002\u6DFB\
    \u5B57\u306E\u8A08\u7B97\u306B\u4F7F\u3046\u5024\u306F\u542B\u3081\u306A\u3044\
    \u3002\n                if n.kind == nnkSym:\n                    for parameter\
    \ in readOnlyParams:\n                        if n == parameter: return true\n\
    \                    return false\n                if n.kind in {nnkDotExpr, nnkBracketExpr,\
    \ nnkCheckedFieldExpr,\n                        nnkHiddenAddr, nnkHiddenDeref}:\n\
    \                    return fromReadOnly(n[0])\n                if n.kind in {nnkHiddenStdConv,\
    \ nnkHiddenSubConv, nnkConv}:\n                    return fromReadOnly(n[^1])\n\
    \                for child in n:\n                    if fromReadOnly(child):\
    \ return true\n\n            proc external(location: NimNode): bool =\n      \
    \          ## \u66F8\u304D\u8FBC\u307F\u5148\u304C\u5909\u63DB\u5BFE\u8C61\u95A2\
    \u6570\u306E\u547C\u3073\u51FA\u3057\u5F8C\u3082\u751F\u5B58\u3059\u308B\u304B\
    \u5224\u5B9A\u3059\u308B\u3002\n                if fromReadOnly(location):\n \
    \                   unsupported(location, \"\u5024\u6E21\u3057\u306E\u8907\u5408\
    \u578B\u3068\u305D\u306E\u53C2\u7167\u5148\u306F\u8AAD\u307F\u53D6\u308A\u5C02\
    \u7528\u3067\u3059\")\n                if location.kind in {nnkHiddenAddr, nnkHiddenDeref}:\n\
    \                    if location.kind == nnkHiddenDeref and concreteKind(location[0].getTypeInst)\
    \ == ntyPtr:\n                        unsupported(location, \"\u30DD\u30A4\u30F3\
    \u30BF\u7D4C\u7531\u306E\u66F8\u304D\u8FBC\u307F\u306F\u672A\u5BFE\u5FDC\u3067\
    \u3059\")\n                    if location.kind == nnkHiddenDeref and concreteKind(location[0].getTypeInst)\
    \ == ntyRef:\n                        return true\n                    return\
    \ external(location[0])\n                if location.kind == nnkCheckedFieldExpr:\n\
    \                    unsupported(location, \"variant object\u3078\u306E\u66F8\u304D\
    \u8FBC\u307F\u306F\u672A\u5BFE\u5FDC\u3067\u3059\")\n                if location.kind\
    \ == nnkDotExpr:\n                    if containsVariant(location[0].getTypeInst):\n\
    \                        unsupported(location, \"variant object\u3078\u306E\u66F8\
    \u304D\u8FBC\u307F\u306F\u672A\u5BFE\u5FDC\u3067\u3059\")\n                  \
    \  return external(location[0])\n                if location.kind == nnkBracketExpr:\n\
    \                    if concreteKind(location[0].getTypeInst) notin {ntyArray,\
    \ ntySequence, ntyTuple}:\n                        unsupported(location, \"\u8981\
    \u7D20\u3078\u306E\u66F8\u304D\u8FBC\u307F\u306Farray\u30FBseq\u30FBtuple\u306B\
    \u9650\u308A\u307E\u3059\")\n                    return external(location[0])\n\
    \                if location.kind == nnkSym:\n                    for local in\
    \ locals:\n                        if location == local:\n                   \
    \         return concreteKind(location.getTypeInst) == ntyRef\n              \
    \      return true\n                unsupported(location, \"\u66F8\u304D\u8FBC\
    \u307F\u5148\u306E\u5BFF\u547D\u3092\u78BA\u8A8D\u3067\u304D\u307E\u305B\u3093\
    \")\n\n            proc rewrite(n: NimNode): NimNode\n\n            proc stableContainer(n:\
    \ NimNode): bool =\n                ## \u6DFB\u5B57\u4EE5\u5916\u3092\u518D\u53C2\
    \u7167\u3057\u3066\u3082\u526F\u4F5C\u7528\u306E\u306A\u3044\u914D\u5217\u306E\
    \u5834\u6240\u304B\u5224\u5B9A\u3059\u308B\u3002\n                case n.kind\n\
    \                of nnkSym: true\n                of nnkDotExpr, nnkHiddenDeref,\
    \ nnkHiddenAddr: stableContainer(n[0])\n                else: false\n\n      \
    \      proc recordChange(location, address: NimNode): NimNode =\n            \
    \    ## \u9759\u7684\u306B\u8B58\u5225\u3067\u304D\u308B\u914D\u5217\u8981\u7D20\
    \u306B\u306F\u3001\u547C\u3073\u51FA\u3057\u9593\u3067\u518D\u5229\u7528\u3059\
    \u308B\u6DFB\u5B57\u5224\u5B9A\u9818\u57DF\u3092\u7528\u610F\u3059\u308B\u3002\
    \n                var target = location\n                while target.kind in\
    \ {nnkHiddenAddr, nnkHiddenDeref}: target = target[0]\n                if not\
    \ blockMode or target.kind != nnkBracketExpr or target.len != 2 or\n         \
    \               concreteKind(target[0].getTypeInst) notin {ntyArray, ntySequence}\
    \ or\n                        not stableContainer(target[0]):\n              \
    \      return newCall(bindSym\"remember\", logParam, address)\n              \
    \  var source = target[0]\n                while source.kind in {nnkHiddenAddr,\
    \ nnkHiddenDeref}: source = source[0]\n                let selector = if source.kind\
    \ == nnkDotExpr: \".\" & source[1].strVal\n                    elif source.kind\
    \ == nnkSym and source.symKind != nskParam: source.repr\n                    else:\
    \ \"\"\n                var cache: NimNode\n                for item in indexCaches:\n\
    \                    if sameType(item.container, target[0]) and item.selector\
    \ == selector:\n                        cache = item.name\n                  \
    \      break\n                if cache.isNil:\n                    cache = genSym(nskProc,\
    \ \"temporaryIndexCache\")\n                    let storage = genSym(nskVar, \"\
    indexCacheStorage\")\n                    indexCaches.add((target[0], cache, selector))\n\
    \                    # \u30E2\u30B8\u30E5\u30FC\u30EB\u76F4\u4E0B\u306E\u30EB\u30FC\
    \u30D7\u5185\u3067\u3082\u518D\u521D\u671F\u5316\u3055\u308C\u306A\u3044\u3088\
    \u3046\u3001\u4FDD\u6301\u9818\u57DF\u3092\u95A2\u6570\u5185\u306B\u7F6E\u304F\
    \u3002\n                    indexDeclarations.add quote do:\n                \
    \        proc `cache`(): ptr TemporaryIndexCache {.inline.} =\n              \
    \              var `storage` {.global, threadvar.}: TemporaryIndexCache\n    \
    \                        addr `storage`\n                let container = rewrite(target[0])\n\
    \                let count = genSym(nskLet, \"temporaryArrayLength\")\n      \
    \          let cacheValue = newTree(nnkDerefExpr, newCall(cache))\n          \
    \      result = quote do:\n                    block:\n                      \
    \  let `count` = len(`container`)\n                        if `count` > 0:\n \
    \                           rememberIndexed(`logParam`, `address`,\n         \
    \                       unsafeAddr `container`[low(`container`)], `count`, `cacheValue`)\n\
    \                        else:\n                            remember(`logParam`,\
    \ `address`)\n\n            proc mutate(n: NimNode, positions: seq[int]): NimNode\
    \ =\n                ## \u5909\u66F4\u5148\u3092\u4E00\u5EA6\u3060\u3051\u8A55\
    \u4FA1\u3057\u3001\u5916\u90E8\u306E\u5024\u306E\u307F\u5909\u66F4\u524D\u306B\
    \u8A18\u9332\u3059\u308B\u3002\n                result = newStmtList()\n     \
    \           var operation = newCall(n[0])\n                let swapping = magicOf(n[0])\
    \ == \"Swap\"\n                if swapping: operation = newCall(bindSym\"swapLocations\"\
    )\n                for i in 1..<n.len:\n                    if i in positions:\n\
    \                        let location = n[i]\n                        if not isValue(location.getTypeInst):\n\
    \                            unsupported(location, \"\u66F8\u304D\u8FBC\u307F\u5148\
    \u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\u30FB\u56FA\
    \u5B9A\u9577\u914D\u5217\u306B\u9650\u308A\u307E\u3059\")\n                  \
    \      let address = genSym(nskLet, \"location\")\n                        result.add(newLetStmt(address,\
    \ newTree(nnkAddr, rewrite(location))))\n                        if external(location):\n\
    \                            result.add(recordChange(location, address))\n   \
    \                     operation.add(if swapping: address else: newTree(nnkDerefExpr,\
    \ address))\n                    else:\n                        operation.add(rewrite(n[i]))\n\
    \                result.add(operation)\n                result = newTree(nnkBlockStmt,\
    \ newEmptyNode(), result)\n\n            proc rewrite(n: NimNode): NimNode =\n\
    \                ## \u69CB\u6587\u3092\u691C\u67FB\u3057\u306A\u304C\u3089\u3001\
    \u4EE3\u5165\u3068\u95A2\u6570\u547C\u3073\u51FA\u3057\u3092\u5909\u63DB\u3059\
    \u308B\u3002\n                if n.kind in {nnkCall, nnkCommand, nnkInfix, nnkPrefix}:\n\
    \                    let callee = staticCallee(n[0])\n                    if callee\
    \ != n[0]:\n                        let call = n.copyNimTree\n               \
    \         call[0] = callee\n                        return rewrite(call)\n   \
    \             if temporaryBoundary(n):\n                    if n.kind == nnkBlockExpr\
    \ and not isValue(n.getTypeInst):\n                        unsupported(n, \"Temporary\u306E\
    \u7D50\u679C\u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\
    \u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306B\u9650\u308A\u307E\u3059\")\n      \
    \              var inner = newStmtList()\n                    for i in 1..<n[1].len:\
    \ inner.add(n[1][i])\n                    let position = genSym(nskLet, \"temporaryPosition\"\
    )\n                    let converted = rewriteBody(inner, logParam, replacements,\
    \ @[], readOnlyParams, false)\n                    return quote do:\n        \
    \                let `position` = beginTemporary(`logParam`)\n               \
    \         try:\n                            `converted`\n                    \
    \    finally:\n                            endTemporary(`logParam`, `position`)\n\
    \                case n.kind\n                of nnkObjConstr:\n             \
    \       if concreteKind(n.getTypeInst) != ntyObject:\n                       \
    \ unsupported(n, \"\u53C2\u7167\u306E\u751F\u6210\u306F\u5909\u66F4\u5148\u306E\
    \u5BFF\u547D\u3092\u4FDD\u8A3C\u3067\u304D\u306A\u3044\u305F\u3081\u672A\u5BFE\
    \u5FDC\u3067\u3059\")\n                    result = newNimNode(n.kind, n)\n  \
    \                  for child in n: result.add(rewrite(child))\n              \
    \      return\n                of nnkConstSection, nnkBindStmt, nnkMixinStmt:\n\
    \                    return newEmptyNode()\n                of nnkPragmaBlock:\n\
    \                    for pragma in n[0]:\n                        if pragma.kind\
    \ != nnkExprColonExpr or not pragma[0].eqIdent(\"line\"):\n                  \
    \          unsupported(pragma, \"\u672A\u5BFE\u5FDC\u306E\u30D6\u30ED\u30C3\u30AF\
    pragma\u3067\u3059\")\n                    return newTree(nnkPragmaBlock, n[0].copyNimTree,\
    \ rewrite(n[1]))\n                of nnkSym:\n                    return lookup(n,\
    \ replacements)\n                of nnkHiddenAddr, nnkHiddenDeref:\n         \
    \           return rewrite(n[0])\n                of nnkHiddenStdConv, nnkHiddenSubConv:\n\
    \                    if n.getTypeInst.typeKind in {ntyOpenArray, ntyVarargs}:\n\
    \                        unsupported(n, \"openArray\u30FBvarargs\u3078\u306E\u5909\
    \u63DB\u306F\u672A\u5BFE\u5FDC\u3067\u3059\")\n                    return rewrite(n[^1])\n\
    \                of nnkReturnStmt:\n                    if n.len == 1 and n[0].kind\
    \ in {nnkAsgn, nnkFastAsgn}:\n                        if not functionBody:\n \
    \                           let value = genSym(nskLet, \"returnValue\")\n    \
    \                        let expression = rewrite(n[0][1])\n                 \
    \           return quote do:\n                                block:\n       \
    \                             let `value` = `expression`\n                   \
    \                 restore(`logParam`, 0)\n                                   \
    \ return `value`\n                        return newTree(nnkReturnStmt, rewrite(n[0][1]))\n\
    \                    if not functionBody:\n                        let returnValue\
    \ = genSym(nskLet, \"returnValue\")\n                        let currentResult\
    \ = ident\"result\"\n                        return quote do:\n              \
    \              when declared(`currentResult`):\n                             \
    \   let `returnValue` = `currentResult`\n                                restore(`logParam`,\
    \ 0)\n                                return `returnValue`\n                 \
    \           else:\n                                restore(`logParam`, 0)\n  \
    \                              return\n                    result = newNimNode(n.kind,\
    \ n)\n                    for child in n: result.add(rewrite(child))\n       \
    \             return\n                of nnkAsgn, nnkFastAsgn:\n             \
    \       if not isValue(n[0].getTypeInst):\n                        unsupported(n,\
    \ \"\u53C2\u7167\u30FB\u30B3\u30F3\u30C6\u30CA\u30FBobject\u5168\u4F53\u306E\u4EE3\
    \u5165\u306F\u672A\u5BFE\u5FDC\u3067\u3059\")\n                    let left =\
    \ rewrite(n[0])\n                    let right = rewrite(n[1])\n             \
    \       if not external(n[0]): return newAssignment(left, right)\n           \
    \         let address = genSym(nskLet, \"location\")\n                    let\
    \ value = genSym(nskLet, \"value\")\n                    let record = recordChange(n[0],\
    \ address)\n                    return quote do:\n                        block:\n\
    \                            let `address` = addr `left`\n                   \
    \         let `value` = `right`\n                            `record`\n      \
    \                      `address`[] = `value`\n                of nnkCall, nnkCommand,\
    \ nnkInfix, nnkPrefix:\n                    if n[0].kind != nnkSym or n[0].symKind\
    \ notin {nskProc, nskFunc}:\n                        unsupported(n, \"\u52D5\u7684\
    \u306A\u95A2\u6570\u547C\u3073\u51FA\u3057\u306F\u672A\u5BFE\u5FDC\u3067\u3059\
    \")\n                    if n[0] == bindSym\"failedAssertImpl\" or\n         \
    \                   (n[0].owner == (bindSym\"countTrailingZeroBits\").owner and\n\
    \                            n[0].eqIdent(\"countTrailingZeroBits\")):\n     \
    \                   result = newCall(n[0])\n                        for i in 1..<n.len:\
    \ result.add(rewrite(n[i]))\n                        return\n                \
    \    let magic = magicOf(n[0])\n                    if magic in [\"Inc\", \"Dec\"\
    ]: return mutate(n, @[1])\n                    if magic == \"Swap\": return mutate(n,\
    \ @[1, 2])\n                    if magic.len > 0:\n                        if\
    \ magic notin [\"AddI\", \"SubI\", \"MulI\", \"DivI\", \"ModI\", \"AddU\", \"\
    SubU\",\n                                \"MulU\", \"DivU\", \"ModU\", \"AddF64\"\
    , \"SubF64\", \"MulF64\", \"DivF64\",\n                                \"EqI\"\
    , \"LeI\", \"LtI\", \"EqF64\", \"LeF64\", \"LtF64\", \"LeU\", \"LtU\",\n     \
    \                           \"EqEnum\", \"LeEnum\", \"LtEnum\", \"EqCh\", \"LeCh\"\
    , \"LtCh\", \"EqB\", \"LeB\", \"LtB\",\n                                \"Not\"\
    , \"And\", \"Or\", \"Xor\", \"BitandI\", \"BitorI\", \"BitxorI\", \"BitnotI\"\
    ,\n                                \"ShlI\", \"ShrI\", \"AshrI\", \"UnaryMinusI\"\
    , \"UnaryMinusI64\", \"UnaryMinusF64\",\n                                \"UnaryPlusI\"\
    , \"AbsI\", \"AbsF64\", \"MinI\", \"MaxI\", \"MinF64\", \"MaxF64\",\n        \
    \                        \"DotDot\", \"LengthSeq\", \"LengthArray\", \"LengthStr\"\
    , \"Ord\", \"Chr\", \"Succ\", \"Pred\"]:\n                            unsupported(n,\
    \ \"\u672A\u5BFE\u5FDC\u306E\u7D44\u307F\u8FBC\u307F\u64CD\u4F5C\u3067\u3059:\
    \ \" & magic)\n                        result = newNimNode(n.kind, n)\n      \
    \                  result.add(n[0])\n                        for i in 1..<n.len:\
    \ result.add(rewrite(n[i]))\n                        return\n                \
    \    let formalParams = n[0].getTypeInst[0]\n                    var argumentReadOnly:\
    \ seq[bool]\n                    var localArgs: seq[bool]\n                  \
    \  for i in 1..<n.len:\n                        let localArg = formalParams[i][^2].kind\
    \ == nnkVarTy and not external(n[i])\n                        if localArg and\
    \ not isValue(formalParams[i][^2][0]):\n                            unsupported(n[i],\
    \ \"\u30ED\u30FC\u30AB\u30EB\u5909\u6570\u306Evar\u5F15\u6570\u306F\u6570\u5024\
    \u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\
    \u5217\u306B\u9650\u308A\u307E\u3059\")\n                        localArgs.add(localArg)\n\
    \                        argumentReadOnly.add(not isScalar(formalParams[i][^2])\
    \ and fromReadOnly(n[i]))\n                    result = newCall(convertFunction(n[0],\
    \ argumentReadOnly, n, localArgs), logParam)\n                    for i in 1..<n.len:\
    \ result.add(rewrite(n[i]))\n                    return\n                of nnkForStmt:\n\
    \                    let iter = n[^2]\n                    if iter.kind notin\
    \ {nnkInfix, nnkCall} or iter[0].kind != nnkSym or\n                         \
    \   iter[0].owner.strVal != \"system\" or\n                            iter[0].strVal\
    \ notin [\"..<\", \"..\", \"countup\", \"countdown\"]:\n                     \
    \   unsupported(iter, \"for\u306Fsystem\u306E\u6574\u6570\u533A\u9593\u30A4\u30C6\
    \u30EC\u30FC\u30BF\u306B\u9650\u308A\u307E\u3059\")\n                    var convertedIter\
    \ = newNimNode(iter.kind, iter)\n                    convertedIter.add(iter[0])\n\
    \                    for i in 1..<iter.len: convertedIter.add(rewrite(iter[i]))\n\
    \                    return newTree(nnkForStmt, lookup(n[0], replacements), convertedIter,\
    \ rewrite(n[^1]))\n                of nnkVarSection, nnkLetSection:\n        \
    \            result = newNimNode(n.kind, n)\n                    for declaration\
    \ in n:\n                        var converted = newNimNode(declaration.kind)\n\
    \                        for i in 0..<declaration.len - 2:\n                 \
    \           converted.add(lookup(declaration[i], replacements))\n            \
    \            converted.add(if declaration.kind == nnkVarTuple: newEmptyNode()\n\
    \                            else: declaration[0].getTypeInst)\n             \
    \           converted.add(rewrite(declaration[^1]))\n                        result.add(converted)\n\
    \                    return\n                of nnkConv:\n                   \
    \ if not isScalar(n.getTypeInst): unsupported(n, \"\u5024\u4EE5\u5916\u3078\u306E\
    \u578B\u5909\u63DB\u306F\u672A\u5BFE\u5FDC\u3067\u3059\")\n                  \
    \  return newCall(n.getTypeInst, rewrite(n[^1]))\n                of nnkEmpty,\
    \ nnkIdent, nnkCommentStmt, nnkCharLit..nnkNilLit,\n                        nnkStmtList,\
    \ nnkStmtListExpr, nnkIfStmt, nnkIfExpr, nnkElifBranch,\n                    \
    \    nnkElifExpr, nnkElse, nnkElseExpr, nnkWhileStmt, nnkBlockStmt,\n        \
    \                nnkBlockExpr, nnkBreakStmt, nnkContinueStmt,\n              \
    \          nnkDiscardStmt, nnkRaiseStmt, nnkCaseStmt, nnkOfBranch, nnkPar, nnkDotExpr,\n\
    \                        nnkBracketExpr, nnkCheckedFieldExpr, nnkTupleConstr,\
    \ nnkBracket, nnkExprColonExpr:\n                    discard\n               \
    \ else:\n                    unsupported(n, \"\u672A\u5BFE\u5FDC\u306E\u69CB\u6587\
    \u3067\u3059: \" & $n.kind)\n                if n.len == 0: return n.copyNimTree\n\
    \                result = newNimNode(n.kind, n)\n                for child in\
    \ n: result.add(rewrite(child))\n\n            result = rewrite(input)\n\n   \
    \     if blockMode:\n            if target.getTypeInst.typeKind notin {ntyVoid,\
    \ ntyNone, ntyStmt} and not isValue(target.getTypeInst):\n                unsupported(target,\
    \ \"Temporary\u306E\u7D50\u679C\u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\
    \u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306B\u9650\u308A\u307E\
    \u3059\")\n            result.transformed = rewriteBody(target, history, @[],\
    \ @[], @[], false)\n        else:\n            let signature = target.getTypeInst[0]\n\
    \            result.transformed = convertFunction(target, newSeq[bool](signature.len\
    \ - 1), target)\n        result.declarations = newStmtList(indexDeclarations,\
    \ forwards, definitions)\n\n    macro runAutoRollbackImpl*(solver, apply, answer:\
    \ typed, runner: untyped): untyped =\n        ## \u5171\u901A\u306E\u81EA\u52D5\
    \u5909\u63DB\u3092\u7528\u3044\u3001\u5404apply\u30921\u56DE\u305A\u3064\u53D6\
    \u308A\u6D88\u305B\u308B\u5B9F\u884C\u51E6\u7406\u3092\u751F\u6210\u3059\u308B\
    \u3002\n        let history = genSym(nskVar, \"history\")\n        let checkpoints\
    \ = genSym(nskVar, \"checkpoints\")\n        let code = buildAutoRollback(apply,\
    \ history, \"runAutoRollback\")\n        let declarations = code.declarations\n\
    \        let signature = apply.getTypeInst[0]\n        let transformed = code.transformed\n\
    \        var wrapper = newProc(genSym(nskProc, \"applyWithRollback\"), [newEmptyNode()])\n\
    \        var call = newCall(transformed, history)\n        for i in 1..<signature.len:\n\
    \            let argument = genSym(nskParam, \"argument\" & $i)\n            wrapper[3].add(newIdentDefs(argument,\
    \ signature[i][^2]))\n            call.add(argument)\n        wrapper[6] = quote\
    \ do:\n            `checkpoints`.add(`history`.len)\n            `call`\n    \
    \    let callback = wrapper[0]\n        let undo = genSym(nskProc, \"rollback\"\
    )\n        let execute = newCall(runner, solver, callback, undo, answer)\n   \
    \     result = quote do:\n            block:\n                var `history`: AutoRollbackLog\n\
    \                var `checkpoints`: seq[int]\n                `declarations`\n\
    \                `wrapper`\n                proc `undo`() =\n                \
    \    restore(`history`, `checkpoints`.pop())\n                try:\n         \
    \           `execute`\n                finally:\n                    restore(`history`,\
    \ 0)\n\n    macro withAutoRollbackImpl*(update: typed, body: untyped): untyped\
    \ =\n        ## \u66F4\u65B0\u95A2\u6570\u3092\u540C\u540D\u3067\u5229\u7528\u3067\
    \u304D\u308B\u30B9\u30B3\u30FC\u30D7\u3068snapshot\u30FBrollback\u3092\u751F\u6210\
    \u3059\u308B\u3002\n        let original = originalUpdate(update)\n        let\
    \ history = genSym(nskVar, \"history\")\n        let code = buildAutoRollback(original,\
    \ history, \"withAutoRollback\")\n        let declarations = code.declarations\n\
    \        let signature = original.getTypeInst[0]\n        let name = ident(original.strVal)\n\
    \        var wrapper = newProc(name, [signature[0].copyNimTree])\n        var\
    \ call = newCall(code.transformed, history)\n        var defaults: seq[NimNode]\n\
    \        for i in 1..<original.getImpl[3].len:\n            let formal = original.getImpl[3][i]\n\
    \            for j in 0..<formal.len - 2: defaults.add(formal[^1])\n        var\
    \ parameterIndex = 0\n        for i in 1..<signature.len:\n            let formal\
    \ = signature[i]\n            for j in 0..<formal.len - 2:\n                let\
    \ argument = genSym(nskParam, formal[j].strVal)\n                wrapper[3].add(newIdentDefs(argument,\
    \ formal[^2].copyNimTree, defaults[parameterIndex].copyNimTree))\n           \
    \     inc parameterIndex\n                call.add(argument)\n        wrapper[6]\
    \ = newStmtList(call)\n        wrapper[4] = newTree(nnkPragma, newTree(nnkExprColonExpr,\
    \ bindSym\"autoRollbackOriginal\", original))\n        for pragma in original.getImpl[4]:\n\
    \            if pragma.eqIdent(\"discardable\"): wrapper[4].add(ident\"discardable\"\
    )\n        let snapshot = ident\"snapshot\"\n        let rollback = ident\"rollback\"\
    \n        result = quote do:\n            try:\n                var `history`:\
    \ AutoRollbackLog\n                `declarations`\n                `wrapper`\n\
    \                proc `snapshot`(): int {.used.} =\n                    ## \u73FE\
    \u5728\u306E\u5C65\u6B74\u4F4D\u7F6E\u3092\u53D6\u5F97\u3059\u308B\u3002O(1)\u3002\
    \n                    `history`.len\n                proc `rollback`(position:\
    \ int) {.used.} =\n                    ## \u540C\u3058\u30B9\u30B3\u30FC\u30D7\
    \u5185\u306E\u6709\u52B9\u306A\u5C65\u6B74\u4F4D\u7F6E\u3078\u623B\u3059\u3002\
    \u5FA9\u5143\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\u30A4\u30BA\u306B\u6BD4\
    \u4F8B\u3059\u308B\u6642\u9593\u3002\n                    if position < 0 or position\
    \ > `history`.len:\n                        raise newException(ValueError, \"\
    rollback\u5148\u304C\u73FE\u5728\u306E\u5C65\u6B74\u7BC4\u56F2\u5916\u3067\u3059\
    \")\n                    restore(`history`, position)\n                try:\n\
    \                    discardRollbackResult:\n                        `body`\n\
    \                finally:\n                    restore(`history`, 0)\n       \
    \     finally:\n                discard\n\n    macro temporaryImpl*(body: typed):\
    \ untyped =\n        ## \u578B\u691C\u67FB\u6E08\u307F\u306E\u30D6\u30ED\u30C3\
    \u30AF\u5185\u306E\u5909\u66F4\u3092\u8A18\u9332\u3057\u3001\u8131\u51FA\u6642\
    \u306B\u5FC5\u305A\u5FA9\u5143\u3059\u308B\u3002\n        let history = genSym(nskVar,\
    \ \"history\")\n        let code = buildAutoRollback(body, history, \"Temporary\"\
    , true)\n        let declarations = code.declarations\n        let converted =\
    \ code.transformed\n        result = quote do:\n            var `history`: TemporaryRollbackLog\n\
    \            `declarations`\n            try:\n                `converted`\n \
    \           finally:\n                restore(`history`, 0)\n"
  dependsOn:
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: false
  path: cplib/utils/private/auto_rollback.nim
  requiredBy:
  - cplib/utils/auto_rollback.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/rollback_mo.nim
  - cplib/utils/rollback_mo.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/offline_dynamic_queries.nim
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/auto_rollback_test.nim
  - verify/AI/auto_rollback_test.nim
  - verify/AI/auto_rollback_values_test.nim
  - verify/AI/auto_rollback_values_test.nim
documentation_of: cplib/utils/private/auto_rollback.nim
layout: document
redirect_from:
- /library/cplib/utils/private/auto_rollback.nim
- /library/cplib/utils/private/auto_rollback.nim.html
title: cplib/utils/private/auto_rollback.nim
---
