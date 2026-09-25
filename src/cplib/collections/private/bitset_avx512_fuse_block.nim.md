---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs_bitset.nim
    title: cplib/str/lcs_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs_bitset.nim
    title: cplib/str/lcs_bitset.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_add_test.nim
    title: verify/AI/bitset_avx512_add_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_add_test.nim
    title: verify/AI/bitset_avx512_add_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
    title: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
    title: verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_block_test.nim
    title: verify/AI/bitset_avx512_fuse_block_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_block_test.nim
    title: verify/AI/bitset_avx512_fuse_block_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_test.nim
    title: verify/AI/bitset_avx512_fuse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_fuse_test.nim
    title: verify/AI/bitset_avx512_fuse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_prev_set_bit_test.nim
    title: verify/AI/bitset_avx512_prev_set_bit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_prev_set_bit_test.nim
    title: verify/AI/bitset_avx512_prev_set_bit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_shift_assign_test.nim
    title: verify/AI/bitset_avx512_shift_assign_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx512_shift_assign_test.nim
    title: verify/AI/bitset_avx512_shift_assign_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_bitset_test.nim
    title: verify/AI/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/edit_distance_bitset_test.nim
    title: verify/AI/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_bitset_test.nim
    title: verify/str/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/edit_distance_bitset_test.nim
    title: verify/str/edit_distance_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_bitset_test.nim
    title: verify/str/lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/restore_lcs_bitset_test.nim
    title: verify/str/restore_lcs_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
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
  code: "## \u8907\u6570\u4EE3\u5165\u3092SSA\u5F62\u5F0F\u306B\u76F4\u3057\u3001\u7E70\
    \u308A\u8D8A\u3057\u3092\u6301\u3064\u4E00\u3064\u306E\u8D70\u67FB\u306B\u878D\
    \u5408\u3057\u307E\u3059\u3002\ntype\n    FuseBlockKind = enum\n        fbInput,\
    \ fbAnd, fbOr, fbXor, fbNot, fbAdd, fbShl, fbLow\n    FuseBlockNode = object\n\
    \        kind: FuseBlockKind\n        a, b, input, shift: int\n        seed: bool\n\
    \nproc fuseBlock(body: NimNode): NimNode =\n    ## \u540C\u4E00\u9577\u306E\u8AD6\
    \u7406\u5F0F\u30FB\u52A0\u7B97\u30FB\u5B9A\u6570\u5DE6\u30B7\u30D5\u30C8\u306E\
    \u30D6\u30ED\u30C3\u30AF\u3092\u878D\u5408\u3057\u3001\u672A\u5BFE\u5FDC\u6642\
    \u306Fnil\u3092\u8FD4\u3057\u307E\u3059\u3002\n    let statements = if body.kind\
    \ == nnkStmtList: body else: newStmtList(body)\n    if statements.len < 2: return\
    \ nil\n    var nodes: seq[FuseBlockNode]\n    var names, external, outputNames,\
    \ captureNames: seq[NimNode]\n    var versions, outputIds, captures: seq[int]\n\
    \    var local: seq[bool]\n    var supported = true\n    var writesLowBit = false\n\
    \    proc unwrap(n: NimNode): NimNode =\n        if n.kind == nnkPar and n.len\
    \ == 1: unwrap(n[0]) else: n\n    proc lookup(xs: seq[NimNode], n: NimNode): int\
    \ =\n        for i, x in xs:\n            if x == n: return i\n        -1\n  \
    \  proc addNode(kind: FuseBlockKind, a = -1, b = -1, input = -1, shift = 0, seed\
    \ = false): int =\n        nodes.add(FuseBlockNode(kind: kind, a: a, b: b, input:\
    \ input, shift: shift, seed: seed))\n        nodes.high\n    proc externalId(n:\
    \ NimNode): int =\n        result = lookup(external, n)\n        if result < 0:\n\
    \            result = external.len\n            external.add(n)\n    proc read(n:\
    \ NimNode): int =\n        let idx = lookup(names, n)\n        if idx >= 0: return\
    \ versions[idx]\n        result = addNode(fbInput, input = externalId(n))\n  \
    \      names.add(n); versions.add(result); local.add(false)\n    proc expression(node:\
    \ NimNode): int =\n        let n = unwrap(node)\n        if n.kind in {nnkIdent,\
    \ nnkSym}: return read(n)\n        if n.kind == nnkPrefix and $n[0] in [\"not\"\
    , \"~\"]:\n            return addNode(fbNot, expression(n[1]))\n        if n.kind\
    \ == nnkInfix:\n            let op = $n[0]\n            if op in [\"shl\", \"\
    <<\"]:\n                let amount = unwrap(n[2])\n                if amount.kind\
    \ in {nnkIntLit..nnkUInt64Lit} and amount.intVal >= 0 and amount.intVal < 64:\n\
    \                    let a = expression(n[1])\n                    if amount.intVal\
    \ == 0: return a\n                    return addNode(fbShl, a, shift = amount.intVal.int)\n\
    \            elif op in [\"and\", \"&\", \"or\", \"|\", \"xor\", \"^\", \"+\"\
    ]:\n                let a = expression(n[1])\n                let b = expression(n[2])\n\
    \                let kind = case op\n                    of \"and\", \"&\": fbAnd\n\
    \                    of \"or\", \"|\": fbOr\n                    of \"xor\", \"\
    ^\": fbXor\n                    else: fbAdd\n                return addNode(kind,\
    \ a, b)\n        supported = false\n        -1\n    proc assign(name: NimNode,\
    \ id: int, declaration = false) =\n        var idx = lookup(names, name)\n   \
    \     if idx < 0:\n            idx = names.len\n            names.add(name); versions.add(id);\
    \ local.add(declaration)\n        else:\n            if declaration: supported\
    \ = false\n            versions[idx] = id\n        if not local[idx]:\n      \
    \      discard externalId(name)\n            let outIdx = lookup(outputNames,\
    \ name)\n            if outIdx < 0:\n                outputNames.add(name); outputIds.add(id)\n\
    \            else: outputIds[outIdx] = id\n    for statement in statements:\n\
    \        if not supported: return nil\n        if statement.kind in {nnkLetSection,\
    \ nnkVarSection}:\n            if statement.len != 1 or statement[0].len != 3\
    \ or statement[0][1].kind != nnkEmpty:\n                return nil\n         \
    \   let name = statement[0][0]\n            if name.kind notin {nnkIdent, nnkSym}:\
    \ return nil\n            assign(name, expression(statement[0][2]), true)\n  \
    \          continue\n        var lhs, rhs: NimNode\n        if statement.kind\
    \ == nnkAsgn:\n            lhs = statement[0]; rhs = unwrap(statement[1])\n  \
    \      elif statement.kind == nnkInfix and $statement[0] in [\"|=\", \"&=\", \"\
    ^=\", \"+=\", \"<<=\"]:\n            lhs = statement[1]\n            rhs = newTree(nnkInfix,\
    \ ident(($statement[0])[0..^2]), lhs, statement[2])\n        else: return nil\n\
    \        if lhs.kind == nnkBracketExpr and lhs.len == 2 and lhs[0].kind in {nnkIdent,\
    \ nnkSym}:\n            if lhs[1].kind notin {nnkIntLit..nnkUInt64Lit} or lhs[1].intVal\
    \ != 0 or rhs.kind notin {nnkIdent, nnkSym} or $rhs notin [\"true\", \"false\"\
    ]:\n                return nil\n            writesLowBit = true\n            let\
    \ a = read(lhs[0])\n            let value = $rhs == \"true\"\n            if nodes[a].kind\
    \ == fbShl:\n                assign(lhs[0], addNode(fbShl, nodes[a].a, shift =\
    \ nodes[a].shift, seed = value))\n            else:\n                assign(lhs[0],\
    \ addNode(fbLow, a, seed = value))\n        elif lhs.kind in {nnkIdent, nnkSym}:\n\
    \            if rhs.kind == nnkCall and rhs.len == 2 and rhs[0].kind in {nnkIdent,\
    \ nnkSym} and $rhs[0] == \"lastBit\":\n                captureNames.add(lhs);\
    \ captures.add(expression(rhs[1]))\n            else:\n                assign(lhs,\
    \ expression(rhs))\n        else: return nil\n    if not supported or external.len\
    \ == 0 or (outputIds.len == 0 and captures.len == 0): return nil\n    # \u6700\
    \u7D42\u51FA\u529B\u304B\u3089\u5FC5\u8981\u306A\u7BC0\u70B9\u3060\u3051\u3092\
    \u6B8B\u3057\u3001\u5171\u6709\u3059\u308B\u4E2D\u9593\u5024\u306F\u4E00\u5EA6\
    \u3060\u3051\u8A08\u7B97\u3057\u307E\u3059\u3002\n    var needed = newSeq[bool](nodes.len)\n\
    \    var uses = newSeq[int](nodes.len)\n    proc visit(id: int) =\n        inc\
    \ uses[id]\n        if needed[id]: return\n        needed[id] = true\n       \
    \ let node = nodes[id]\n        if node.a >= 0: visit(node.a)\n        if node.b\
    \ >= 0: visit(node.b)\n    for id in outputIds: visit(id)\n    for id in captures:\
    \ visit(id)\n    let kernel = genSym(nskProc, \"bitsetFuseBlockKernel\")\n   \
    \ let name = \"cplib_\" & kernel.repr.replace(\"`\", \"\")\n    var code = fuseArithmeticHelpers\n\
    \    for width in [0, 512]:\n        let typ = if width == 0: \"uint64_t\" else:\
    \ \"__m512i\"\n        let zero = if width == 0: \"0\" else: \"_mm512_setzero_si512()\"\
    \n        code.add((if width == 512: \"__attribute__((target(\\\"avx512f\\\")))\
    \ \" else: \"\") &\n            \"static void \" & name & $width & \"(uint64_t\
    \ **data,size_t n,size_t bits,uint64_t *last) {\\n\")\n        for j in 0..<captures.len:\
    \ code.add(\"last[\" & $j & \"]=0;\\n\")\n        code.add(\"if (!n) return;\\\
    n\")\n        for j in 0..<external.len: code.add(\"uint64_t *__restrict d\" &\
    \ $j & \"=data[\" & $j & \"];\\n\")\n        for id, node in nodes:\n        \
    \    if not needed[id]: continue\n            if node.kind == fbAdd: code.add(\"\
    unsigned carry\" & $id & \"=0;\\n\")\n            if node.kind == fbShl:\n   \
    \             let init = if node.seed: \"(UINT64_C(1)<<\" & $(64-node.shift) &\
    \ \")\" else: \"0\"\n                let value = if width == 0: init else: \"\
    _mm512_set_epi64(\" & init & \",0,0,0,0,0,0,0)\"\n                code.add(typ\
    \ & \" prev\" & $id & \"=\" & value & \";\\n\")\n        for j in 0..<captures.len:\
    \ code.add(typ & \" cap\" & $j & \"=\" & zero & \";\\n\")\n        code.add(\"\
    size_t i=0;\\n\")\n        proc blockCode(masked: bool): string =\n          \
    \  var lines = \"\"\n            var emitted = newSeq[bool](nodes.len)\n     \
    \       for id, node in nodes:\n                if needed[id] and node.kind ==\
    \ fbInput:\n                    let ptrExpr = \"d\" & $node.input & \"+i\"\n \
    \                   let value = if width == 0: \"d\" & $node.input & \"[i]\"\n\
    \                        elif masked: \"_mm512_maskz_loadu_epi64(valid,\" & ptrExpr\
    \ & \")\"\n                        else: \"_mm512_loadu_si512((const void *)(\"\
    \ & ptrExpr & \"))\"\n                    lines.add(typ & \" v\" & $id & \"=\"\
    \ & value & \";\\n\")\n                    emitted[id] = true\n            proc\
    \ render(id: int): string =\n                result = \"v\" & $id\n          \
    \      if emitted[id]: return\n                let node = nodes[id]\n        \
    \        var value: string\n                if width == 512 and node.kind in {fbAnd,\
    \ fbOr, fbXor, fbNot}:\n                    var atoms: seq[int]\n            \
    \        proc collect(j: int) =\n                        let child = nodes[j]\n\
    \                        if j != id and (uses[j] > 1 or child.kind notin {fbAnd,\
    \ fbOr, fbXor, fbNot}):\n                            if j notin atoms: atoms.add(j)\n\
    \                        else:\n                            collect(child.a)\n\
    \                            if child.b >= 0: collect(child.b)\n             \
    \       collect(id)\n                    if atoms.len <= 3:\n                \
    \        proc truth(j, row: int): bool =\n                            let idx\
    \ = atoms.find(j)\n                            if idx >= 0: return (row and (1\
    \ shl (2-idx))) != 0\n                            let a = truth(nodes[j].a, row)\n\
    \                            if nodes[j].kind == fbNot: return not a\n       \
    \                     let b = truth(nodes[j].b, row)\n                       \
    \     case nodes[j].kind\n                            of fbAnd: a and b\n    \
    \                        of fbOr: a or b\n                            else: a\
    \ xor b\n                        var mask = 0\n                        for row\
    \ in 0..7:\n                            if truth(id, row): mask = mask or (1 shl\
    \ row)\n                        var args: seq[string]\n                      \
    \  for atom in atoms: args.add(render(atom))\n                        while args.len\
    \ < 3: args.add(args[0])\n                        value = \"_mm512_ternarylogic_epi64(\"\
    \ & args.join(\",\") & \",\" & $mask & \")\"\n                if value.len ==\
    \ 0:\n                    let a = render(node.a)\n                    case node.kind\n\
    \                    of fbNot:\n                        value = if width == 0:\
    \ \"(~\" & a & \")\" else: \"_mm512_xor_si512(\" & a & \",_mm512_set1_epi64(-1))\"\
    \n                    of fbShl:\n                        let prev = \"prev\" &\
    \ $id\n                        if width == 0:\n                            value\
    \ = \"((\" & a & \"<<\" & $node.shift & \")|(\" & prev & \">>\" & $(64-node.shift)\
    \ & \"))\"\n                        else:\n                            value =\
    \ \"_mm512_or_si512(_mm512_slli_epi64(\" & a & \",\" & $node.shift & \"),_mm512_srli_epi64(_mm512_alignr_epi64(\"\
    \ & a & \",\" & prev & \",7),\" & $(64-node.shift) & \"))\"\n                \
    \    of fbLow:\n                        let op = if node.seed: \"|\" else: \"\
    &~\"\n                        if width == 0: value = \"(\" & a & op & \"(uint64_t)(i==0))\"\
    \n                        else:\n                            let fn = if node.seed:\
    \ \"_mm512_mask_or_epi64\" else: \"_mm512_mask_andnot_epi64\"\n              \
    \              if node.seed: value = fn & \"(\" & a & \",i==0?1:0,\" & a & \"\
    ,_mm512_set1_epi64(1))\"\n                            else: value = fn & \"(\"\
    \ & a & \",i==0?1:0,_mm512_set1_epi64(1),\" & a & \")\"\n                    else:\n\
    \                        let b = render(node.b)\n                        if node.kind\
    \ == fbAdd:\n                            value = (if width == 0: \"cplib_fuse_add64\"\
    \ else: \"cplib_fuse_add512\") & \"(\" & a & \",\" & b & \",&carry\" & $id & \"\
    )\"\n                        else:\n                            let op = case\
    \ node.kind\n                                of fbAnd: \"and\"\n             \
    \                   of fbOr: \"or\"\n                                else: \"\
    xor\"\n                            if width == 0:\n                          \
    \      value = \"(\" & a & (if op == \"and\": \"&\" elif op == \"or\": \"|\" else:\
    \ \"^\") & b & \")\"\n                            else: value = \"_mm512_\" &\
    \ op & \"_si512(\" & a & \",\" & b & \")\"\n                lines.add(typ & \"\
    \ \" & result & \"=\" & value & \";\\n\")\n                if node.kind == fbShl:\
    \ lines.add(\"prev\" & $id & \"=v\" & $node.a & \";\\n\")\n                emitted[id]\
    \ = true\n            # \u5168\u5165\u529B\u3068\u4E2D\u9593\u5024\u3092\u8AAD\
    \u3080\u307E\u3067\u51FA\u529B\u3092\u4E0A\u66F8\u304D\u3057\u307E\u305B\u3093\
    \u3002\n            for id in outputIds: discard render(id)\n            for id\
    \ in captures: discard render(id)\n            for j, id in outputIds:\n     \
    \           let outIdx = lookup(external, outputNames[j])\n                if\
    \ width == 0: lines.add(\"d\" & $outIdx & \"[i]=v\" & $id & \";\\n\")\n      \
    \          elif masked: lines.add(\"_mm512_mask_storeu_epi64(d\" & $outIdx & \"\
    +i,valid,v\" & $id & \");\\n\")\n                else: lines.add(\"_mm512_storeu_si512((void\
    \ *)(d\" & $outIdx & \"+i),v\" & $id & \");\\n\")\n            for j, id in captures:\
    \ lines.add(\"cap\" & $j & \"=v\" & $id & \";\\n\")\n            lines\n     \
    \   if width == 512:\n            code.add(\"for (;i+8<=n;i+=8) {\\n\" & blockCode(false)\
    \ & \"}\\n\")\n            code.add(\"if (i<n) { __mmask8 valid=(__mmask8)((1u<<(n-i))-1);\\\
    n\" & blockCode(true) & \"}\\n\")\n            if captures.len > 0:\n        \
    \        code.add(\"uint64_t maskWords[8]={0}; maskWords[((bits-1)/64)&7]=UINT64_C(1)<<((bits-1)&63);\\\
    n\")\n                code.add(\"__m512i mask=_mm512_loadu_si512((const void *)maskWords);\\\
    n\")\n            for j in 0..<captures.len:\n                code.add(\"last[\"\
    \ & $j & \"]=_mm512_test_epi64_mask(cap\" & $j & \",mask)!=0;\\n\")\n        else:\n\
    \            code.add(\"for (;i<n;++i) {\\n\" & blockCode(false) & \"}\\n\")\n\
    \            for j in 0..<captures.len:\n                code.add(\"last[\" &\
    \ $j & \"]=(cap\" & $j & \">>((bits-1)&63))&1;\\n\")\n        code.add(\"}\\n\"\
    )\n    code.add(\"static void \" & name & \"(uint64_t **data,size_t n,size_t bits,uint64_t\
    \ *last) {\\n\")\n    code.add(\"if (__builtin_cpu_supports(\\\"avx512f\\\"))\
    \ \" & name & \"512(data,n,bits,last); else \" & name & \"0(data,n,bits,last);\\\
    n}\\n\")\n    let declaration = newLit(\"\\n#ifndef \" & name & \"_DEFINED\\n#define\
    \ \" & name & \"_DEFINED\\n\" & code & \"#endif\\n$1 $2$3\")\n    let cname =\
    \ newLit(name)\n    let pointers = genSym(nskVar, \"pointers\")\n    let last\
    \ = genSym(nskVar, \"last\")\n    var values = newNimNode(nnkBracket)\n    let\
    \ first = external[0]\n    var conditions: NimNode = newLit(true)\n    for j,\
    \ leaf in external:\n        values.add(newCall(bindSym\"fuseData\", leaf))\n\
    \        let same = quote do: len(`leaf`) == len(`first`)\n        conditions\
    \ = newTree(nnkInfix, ident\"and\", conditions, same)\n        for i in 0..<j:\n\
    \            let a = newLit(i); let b = newLit(j)\n            let independent\
    \ = quote do: len(`first`) == 0 or `pointers`[`a`] != `pointers`[`b`]\n      \
    \      conditions = newTree(nnkInfix, ident\"and\", conditions, independent)\n\
    \    if writesLowBit:\n        let nonempty = quote do: len(`first`) > 0\n   \
    \     conditions = newTree(nnkInfix, ident\"and\", conditions, nonempty)\n   \
    \ var finish = newStmtList()\n    for leaf in outputNames:\n        finish.add(newCall(bindSym\"\
    trim\", leaf))\n    for j, leaf in captureNames:\n        let idx = newLit(j)\n\
    \        finish.add quote do: `leaf` = `last`[`idx`] != 0\n    let captureCount\
    \ = newLit(max(1, captures.len))\n    let fallback = newCall(bindSym\"fuseSingleStatements\"\
    , body)\n    result = quote do:\n        block:\n            var `pointers` =\
    \ `values`\n            if `conditions`:\n                proc `kernel`(data:\
    \ ptr ptr uint64, n, bits: csize_t, last: ptr uint64) {.codegenDecl: `declaration`.}\
    \ =\n                    {.emit: [`cname`, \"(\", data, \",\", n, \",\", bits,\
    \ \",\", last, \");\"].}\n                var `last`: array[`captureCount`, uint64]\n\
    \                `kernel`(addr `pointers`[0], fuseWords(`first`), csize_t(len(`first`)),\
    \ addr `last`[0])\n                `finish`\n            else:\n             \
    \   `fallback`\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx512_fuse_block.nim
  requiredBy:
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/str/lcs_bitset.nim
  - cplib/str/lcs_bitset.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/str/edit_distance_bitset.nim
  timestamp: '2026-09-17 21:00:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/backwards_index_simd_test.nim
  - verify/utils/backwards_index_simd_test.nim
  - verify/AI/bitset_avx512_add_test.nim
  - verify/AI/bitset_avx512_add_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_shift_assign_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/bitset_avx512_fuse_block_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/edit_distance_bitset_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/AI/bitset_avx512_fuse_arithmetic_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/edit_distance_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
  - verify/str/restore_lcs_bitset_test.nim
documentation_of: cplib/collections/private/bitset_avx512_fuse_block.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx512_fuse_block.nim
- /library/cplib/collections/private/bitset_avx512_fuse_block.nim.html
title: cplib/collections/private/bitset_avx512_fuse_block.nim
---
