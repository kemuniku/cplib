---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/replayable_input_test.nim
    title: verify/AI/replayable_input_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/replayable_input_test.nim
    title: verify/AI/replayable_input_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/replayable_input_many_aplusb_test.nim
    title: verify/tmpl/replayable_input_many_aplusb_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/replayable_input_many_aplusb_test.nim
    title: verify/tmpl/replayable_input_many_aplusb_test.nim
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
  code: "when not declared CPLIB_TMPL_REPLAYABLE_INPUT:\n    const CPLIB_TMPL_REPLAYABLE_INPUT*\
    \ = 1\n    import macros, tables, typetraits\n\n    type\n        ReplayInputRun\
    \ = object\n            kind: pointer\n            start: int\n        ReplayInputBufferBase\
    \ = ref object of RootObj\n        ReplayInputBuffer[T] = ref object of ReplayInputBufferBase\n\
    \            values: seq[T]\n        ReplayInputState = object\n            entries:\
    \ seq[int]\n            runs: seq[ReplayInputRun]\n            buffers: Table[pointer,\
    \ ReplayInputBufferBase]\n            position, runPosition, depth: int\n\n  \
    \  proc replayInputTypeId[T](): pointer {.inline.} =\n        ## \u578B\u3054\u3068\
    \u306B\u7570\u306A\u308B\u8B58\u5225\u5B50\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\u578B\u5225\u540D\u306F\u540C\u3058\u8B58\u5225\u5B50\u306B\u306A\u308A\
    \u307E\u3059\u3002\n        var token {.global.}: byte\n        addr token\n\n\
    \    proc replayInputBuffer[T](state: var ReplayInputState,\n                \
    \             kind: pointer): ReplayInputBuffer[T] =\n        ## \u578B\u3054\u3068\
    \u306E\u9023\u7D9A\u30D0\u30C3\u30D5\u30A1\u3092\u53D6\u5F97\u3057\u3001\u672A\
    \u4F5C\u6210\u306A\u3089\u751F\u6210\u3057\u307E\u3059\u3002\u671F\u5F85O(1)\u3002\
    \n        let existing = state.buffers.getOrDefault(kind)\n        if existing\
    \ != nil:\n            return ReplayInputBuffer[T](existing)\n        result =\
    \ ReplayInputBuffer[T]()\n        state.buffers[kind] = result\n\n    template\
    \ replayInputRead(state: var ReplayInputState, T: typedesc,\n                \
    \            source: untyped, onlyInts: static[bool]): untyped =\n        ## \u5024\
    \u3092\u8A18\u9332\u30FB\u518D\u751F\u3057\u307E\u3059\u3002\u5C0F\u3055\u306A\
    \u975E\u7BA1\u7406\u578B\u306F\u76F4\u63A5\u683C\u7D0D\u3057\u3001\u307B\u304B\
    \u306F\u578B\u5225\u30D0\u30C3\u30D5\u30A1\u306B\u4FDD\u5B58\u3057\u307E\u3059\
    \u3002\n        block:\n            var value: T\n            when not onlyInts:\n\
    \                let kind = replayInputTypeId[T]()\n            when supportsCopyMem(T)\
    \ and sizeof(T) <= sizeof(int):\n                const inlineValue = true\n  \
    \          else:\n                const inlineValue = false\n            if state.position\
    \ < state.entries.len:\n                let entry = state.entries[state.position]\n\
    \                when not onlyInts:\n                    if state.runPosition\
    \ + 1 < state.runs.len and\n                            state.runs[state.runPosition\
    \ + 1].start == state.position:\n                        inc state.runPosition\n\
    \                    if state.runs[state.runPosition].kind != kind:\n        \
    \                raise newException(ValueError, \"replayed input type mismatch\"\
    )\n                when inlineValue:\n                    # \u53C2\u7167\u7BA1\
    \u7406\u304C\u4E0D\u8981\u306A\u578B\u3060\u3051\u3092\u3001\u4FDD\u5B58\u6642\
    \u3068\u540C\u3058\u30D0\u30A4\u30C8\u5217\u304B\u3089\u5FA9\u5143\u3057\u307E\
    \u3059\u3002\n                    copyMem(addr value, unsafeAddr entry, sizeof(T))\n\
    \                else:\n                    value = replayInputBuffer[T](state,\
    \ kind).values[entry]\n                inc state.position\n            else:\n\
    \                if state.depth == 0 and state.entries.len > 0:\n            \
    \        state.entries.setLen(0)\n                    when not onlyInts:\n   \
    \                     state.runs.setLen(0)\n                        state.runPosition\
    \ = 0\n                        state.buffers.clear()\n                    state.position\
    \ = 0\n                value = source\n                if state.depth > 0:\n \
    \                   when not onlyInts:\n                        if state.runs.len\
    \ == 0 or state.runs[^1].kind != kind:\n                            state.runs.add(ReplayInputRun(kind:\
    \ kind, start: state.entries.len))\n                        state.runPosition\
    \ = state.runs.len - 1\n                    var entry: int\n                 \
    \   when inlineValue:\n                        copyMem(addr entry, addr value,\
    \ sizeof(T))\n                    else:\n                        let buffer =\
    \ replayInputBuffer[T](state, kind)\n                        entry = buffer.values.len\n\
    \                        buffer.values.add(value)\n                    state.entries.add(entry)\n\
    \                    inc state.position\n            value\n\n    macro replayableInput*(body:\
    \ untyped): untyped =\n        ## ii\u30FBlii\u30FBsi\u30FBinput\u3092\u8A18\u9332\
    \u518D\u751F\u306B\u5BFE\u5FDC\u3055\u305B\u3001peekInput\u7D42\u4E86\u6642\u306B\
    \u5165\u529B\u4F4D\u7F6E\u3092\u623B\u3059\u3002\n        ## \u8A18\u9332\u30FB\
    \u518D\u751F\u306F1\u8981\u7D20\u3042\u305F\u308A\u671F\u5F85\u511F\u5374O(1)\uFF08\
    \u5165\u529B\u3084\u5024\u306E\u30B3\u30D4\u30FC\u3092\u9664\u304F\uFF09\u3001\
    \u7A7A\u9593\u306F\u8A18\u9332\u91CF\u306B\u6BD4\u4F8B\u3059\u308B\u3002\n   \
    \     ## \u518D\u751F\u6642\u306F\u5404\u8981\u7D20\u306E\u578B\u3092\u4E00\u81F4\
    \u3055\u305B\u3001\u5148\u8AAD\u307F\u3057\u305F\u5165\u529B\u306F\u3053\u306E\
    \u30D6\u30ED\u30C3\u30AF\u5185\u3067\u6D88\u8CBB\u3059\u308B\u3053\u3068\u3002\
    \n        ## \u5916\u90E8\u306E\u95A2\u6570\u30FB\u30C6\u30F3\u30D7\u30EC\u30FC\
    \u30C8\u5185\u306E\u5165\u529B\u3084\u4FEE\u98FE\u4ED8\u304D\u547C\u3073\u51FA\
    \u3057\u3001\u95A2\u6570\u5024\u7D4C\u7531\u306E\u5165\u529B\u306F\u5BFE\u8C61\
    \u5916\u3002\n        let state = genSym(nskVar, \"replayState\")\n        let\
    \ readOne = genSym(nskTemplate, \"replayReadOne\")\n        let readMany = genSym(nskTemplate,\
    \ \"replayReadMany\")\n        var onlyInts = true\n\n        proc transform(node:\
    \ NimNode): NimNode =\n            ## \u5BFE\u8C61\u306E\u5165\u529B\u547C\u3073\
    \u51FA\u3057\u3068\u5148\u8AAD\u307F\u30D6\u30ED\u30C3\u30AF\u3092\u518D\u5E30\
    \u7684\u306B\u5909\u63DB\u3059\u308B\u3002\n            if node.kind in {nnkCall,\
    \ nnkCommand} and\n                    node[0].kind in {nnkIdent, nnkSym}:\n \
    \               if node[0].eqIdent(\"peekInput\"):\n                    if node.len\
    \ != 2 or node[1].kind != nnkStmtList:\n                        error(\"peekInput\
    \ requires a block\", node)\n                    let checkpoint = genSym(nskLet,\
    \ \"checkpoint\")\n                    let runCheckpoint = genSym(nskLet, \"runCheckpoint\"\
    )\n                    let inner = transform(node[1])\n                    return\
    \ quote do:\n                        block:\n                            let `checkpoint`\
    \ = `state`.position\n                            let `runCheckpoint` = `state`.runPosition\n\
    \                            inc `state`.depth\n                            try:\n\
    \                                `inner`\n                            finally:\n\
    \                                `state`.position = `checkpoint`\n           \
    \                     `state`.runPosition = `runCheckpoint`\n                \
    \                dec `state`.depth\n                if node[0].eqIdent(\"ii\"\
    ) and node.len == 1:\n                    return newCall(readOne, ident\"int\"\
    )\n                if node[0].eqIdent(\"si\") and node.len == 1:\n           \
    \         onlyInts = false\n                    return newCall(readOne, ident\"\
    string\")\n                if node[0].eqIdent(\"lii\") and node.len == 2:\n  \
    \                  return newCall(readMany, transform(node[1]), ident\"int\")\n\
    \                if node[0].eqIdent(\"input\"):\n                    onlyInts\
    \ = false\n                    if node.len == 2:\n                        return\
    \ newCall(readOne, node[1])\n                    if node.len == 3:\n         \
    \               return newCall(readMany, transform(node[1]), node[2])\n      \
    \          if node[0].eqIdent(\"replayableInput\"):\n                    error(\"\
    replayableInput cannot be nested; nest peekInput instead\", node)\n          \
    \  result = copyNimNode(node)\n            for child in node:\n              \
    \  result.add(transform(child))\n\n        let transformed = transform(body)\n\
    \        let onlyIntsNode = newLit(onlyInts)\n        result = quote do:\n   \
    \         block:\n                var `state`: ReplayInputState\n            \
    \    template `readOne`(T: typedesc): untyped =\n                    ## 1\u8981\
    \u7D20\u3092\u5165\u529B\u307E\u305F\u306F\u518D\u751F\u3059\u308B\u3002\n   \
    \                 replayInputRead(`state`, T, input(T), `onlyIntsNode`)\n    \
    \            template `readMany`(count: int, T: typedesc): untyped =\n       \
    \             ## count\u8981\u7D20\u3092\u5165\u529B\u307E\u305F\u306F\u518D\u751F\
    \u3059\u308B\u3002O(count)\u3002\n                    block:\n               \
    \         let length = count\n                        var values = newSeq[T](length)\n\
    \                        for i in 0 ..< length:\n                            values[i]\
    \ = `readOne`(T)\n                        values\n                `transformed`\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/replayable_input.nim
  requiredBy: []
  timestamp: '2026-09-17 19:05:28+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/replayable_input_test.nim
  - verify/AI/replayable_input_test.nim
  - verify/tmpl/replayable_input_many_aplusb_test.nim
  - verify/tmpl/replayable_input_many_aplusb_test.nim
documentation_of: cplib/tmpl/replayable_input.nim
layout: document
redirect_from:
- /library/cplib/tmpl/replayable_input.nim
- /library/cplib/tmpl/replayable_input.nim.html
title: cplib/tmpl/replayable_input.nim
---
