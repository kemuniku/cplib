---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  _extendedVerifiedWith:
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
  code: "## fuse\u30DE\u30AF\u30ED\u3068\u52D5\u7684\u30D3\u30C3\u30C8\u30BB\u30C3\
    \u30C8\u7528\u306E\u878D\u5408\u6F14\u7B97\u3067\u3059\u3002\ninclude cplib/collections/private/bitset_avx512_fuse_shift\n\
    \nproc orShiftLeftAssign*(x: var BitSetAvx512, shift: int) =\n    ## x |= x <<\
    \ shift\u3092\u4E00\u6642\u9818\u57DF\u306A\u3057\u3067\u8A08\u7B97\u3057\u307E\
    \u3059\u3002O(len(x)/64)\u3002\n    if shift < 0:\n        raise newException(ValueError,\
    \ \"shift count must be non-negative\")\n    if shift > 0 and shift < x.size:\n\
    \        fusedShiftLeft(addr x.bits[0], x.bits.len.csize_t, shift.csize_t)\n \
    \       x.trim()\n\nproc orShiftRightAssign*(x: var BitSetAvx512, shift: int)\
    \ =\n    ## x |= x >> shift\u3092\u4E00\u6642\u9818\u57DF\u306A\u3057\u3067\u8A08\
    \u7B97\u3057\u307E\u3059\u3002O(len(x)/64)\u3002\n    if shift < 0:\n        raise\
    \ newException(ValueError, \"shift count must be non-negative\")\n    if shift\
    \ > 0 and shift < x.size:\n        fusedShiftRight(addr x.bits[0], x.bits.len.csize_t,\
    \ shift.csize_t)\n\nproc fuseData(x: BitSetAvx512): ptr uint64 {.inline.} =\n\
    \    ## \u878D\u5408\u30AB\u30FC\u30CD\u30EB\u3078\u6E21\u3059\u5148\u982D\u30DD\
    \u30A4\u30F3\u30BF\u3092\u8FD4\u3057\u307E\u3059\u3002\n    if x.bits.len > 0:\
    \ unsafeAddr x.bits[0] else: nil\n\nproc fuseWords(x: BitSetAvx512): csize_t {.inline.}\
    \ =\n    ## \u878D\u5408\u30AB\u30FC\u30CD\u30EB\u304C\u51E6\u7406\u3059\u308B\
    \u30EF\u30FC\u30C9\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\n    x.bits.len.csize_t\n\
    \nmacro fuse*(body: untyped): untyped =\n    ## \u30D3\u30C3\u30C8\u30BB\u30C3\
    \u30C8\u306E\u4EE3\u5165\u5F0F\u3092\u878D\u5408\u3057\u307E\u3059\u3002\u5404\
    \u5F0FO(\u5F0F\u306E\u5927\u304D\u3055 * \u30D3\u30C3\u30C8\u6570/64)\u3002\n\
    \    ## x = x or (y and z)\u3001x = x | (x << k)\u306A\u3069\u3092\u8A18\u8FF0\
    \u3067\u304D\u307E\u3059\u3002\n    ## |=\u3001&=\u3001^=\u306B\u3082\u5BFE\u5FDC\
    \u3057\u307E\u3059\u3002\u4F8B: x |= y and z\u3001dp |= dp << k\u3002\n    ##\
    \ \u8AD6\u7406\u5F0F\u306E\u8449\u3068\u4EE3\u5165\u5148\u304C\u5909\u6570\u540D\
    \u306A\u3089\u4E00\u6642\u96C6\u5408\u306A\u3057\u3067SIMD\u51E6\u7406\u3057\u307E\
    \u3059\u3002\n    ## \u5165\u529B3\u7A2E\u985E\u4EE5\u4E0B\u306E\u8AD6\u7406\u5F0F\
    \u306FAVX-512\u306E\u771F\u7406\u5024\u8868\u547D\u4EE4\u306B\u307E\u3068\u3081\
    \u307E\u3059\u3002\n    ## \u81EA\u8EAB\u306E\u5DE6\u53F3\u30B7\u30D5\u30C8\u3068\
    \u306EOR\u3082\u878D\u5408\u3057\u3001\u305D\u308C\u4EE5\u5916\u306F\u901A\u5E38\
    \u306E\u6F14\u7B97\u3078\u623B\u3057\u307E\u3059\u3002\n    ## \u4EE3\u5165\u5148\
    \u306E\u9577\u3055\u304C\u7570\u306A\u308B\u5834\u5408\u3082\u901A\u5E38\u306E\
    \u4EE3\u5165\u3078\u623B\u3057\u307E\u3059\u3002\u6587\u306F\u8A18\u8FF0\u9806\
    \u306B\u5B9F\u884C\u3057\u307E\u3059\u3002\n    proc unwrap(n: NimNode): NimNode\
    \ =\n        if n.kind == nnkPar and n.len == 1: unwrap(n[0]) else: n\n    proc\
    \ op(n: NimNode): string =\n        if n.kind in {nnkInfix, nnkPrefix}: $n[0]\
    \ else: \"\"\n    proc normal(n: NimNode): NimNode =\n        result = copyNimTree(n)\n\
    \        if n.kind == nnkAsgn:\n            result[1] = normal(n[1])\n       \
    \ elif n.kind == nnkPar and n.len == 1:\n            result[0] = normal(n[0])\n\
    \        elif n.kind in {nnkInfix, nnkPrefix} and op(n) in [\"and\", \"or\", \"\
    xor\", \"not\", \"shl\", \"shr\", \"&\", \"|\", \"^\", \"~\", \"<<\", \">>\"]:\n\
    \            let s = case op(n)\n                of \"and\": \"&\"\n         \
    \       of \"or\": \"|\"\n                of \"xor\": \"^\"\n                of\
    \ \"not\": \"~\"\n                of \"shl\": \"<<\"\n                of \"shr\"\
    : \">>\"\n                else: op(n)\n            result[0] = ident(s)\n    \
    \        result[1] = normal(n[1])\n            if n.kind == nnkInfix and s notin\
    \ [\"<<\", \">>\"]:\n                result[2] = normal(n[2])\n    result = newStmtList()\n\
    \    let statements = if body.kind == nnkStmtList: body else: newStmtList(body)\n\
    \    for original in statements:\n        var statement = original\n        var\
    \ fallback: NimNode\n        if original.kind == nnkInfix and op(original) in\
    \ [\"|=\", \"&=\", \"^=\"]:\n            fallback = newTree(nnkInfix, original[0],\
    \ original[1], normal(original[2]))\n            # \u6DFB\u5B57\u306A\u3069\u306B\
    \u526F\u4F5C\u7528\u304C\u3042\u308B\u5834\u5408\u3082\u4EE3\u5165\u5148\u3092\
    \u4E00\u5EA6\u3060\u3051\u8A55\u4FA1\u3057\u307E\u3059\u3002\n            if original[1].kind\
    \ notin {nnkIdent, nnkSym}:\n                result.add(fallback)\n          \
    \      continue\n            let binary = ident(op(original)[0..0])\n        \
    \    statement = newAssignment(original[1], newTree(nnkInfix, binary, original[1],\
    \ original[2]))\n        else:\n            fallback = normal(statement)\n   \
    \     if statement.kind != nnkAsgn:\n            error(\"fuse expects =, |=, &=\
    \ or ^= assignments\", statement)\n        let dst = statement[0]\n        let\
    \ rhs = unwrap(statement[1])\n        if dst.kind notin {nnkIdent, nnkSym}:\n\
    \            result.add(fallback)\n            continue\n        var shifted:\
    \ NimNode\n        if rhs.kind == nnkInfix and op(rhs) in [\"or\", \"|\"]:\n \
    \           for side in 1..2:\n                let a = unwrap(rhs[side])\n   \
    \             let b = unwrap(rhs[3-side])\n                if a == dst and b.kind\
    \ == nnkInfix and op(b) in [\"shl\", \"shr\", \"<<\", \">>\"] and unwrap(b[1])\
    \ == dst:\n                    shifted = b\n        if shifted != nil:\n     \
    \       let fn = if op(shifted) in [\"shl\", \"<<\"]: bindSym\"orShiftLeftAssign\"\
    \ else: bindSym\"orShiftRightAssign\"\n            result.add(newCall(fn, dst,\
    \ shifted[2]))\n            continue\n        var leaves: seq[NimNode]\n     \
    \   var supported = true\n        proc collect(node: NimNode) =\n            let\
    \ n = unwrap(node)\n            if n.kind in {nnkIdent, nnkSym}:\n           \
    \     for leaf in leaves:\n                    if leaf == n: return\n        \
    \        leaves.add(n)\n            elif n.kind == nnkInfix and op(n) in [\"and\"\
    , \"or\", \"xor\", \"&\", \"|\", \"^\"]:\n                collect(n[1]); collect(n[2])\n\
    \            elif n.kind == nnkPrefix and op(n) in [\"not\", \"~\"]:\n       \
    \         collect(n[1])\n            else:\n                supported = false\n\
    \        collect(rhs)\n        if not supported or leaves.len == 0:\n        \
    \    result.add(fallback)\n            continue\n        proc expression(node:\
    \ NimNode, width: int): string =\n            let n = unwrap(node)\n         \
    \   if n.kind in {nnkIdent, nnkSym}:\n                for i, leaf in leaves:\n\
    \                    if leaf == n: return \"v\" & $i\n            let a = expression(n[1],\
    \ width)\n            if n.kind == nnkPrefix:\n                if width == 0:\
    \ return \"(~\" & a & \")\"\n                return \"_mm\" & $width & \"_xor_si\"\
    \ & $width & \"(\" & a & \", _mm\" & $width & \"_set1_epi64\" & (if width == 256:\
    \ \"x\" else: \"\") & \"(-1))\"\n            let b = expression(n[2], width)\n\
    \            let operation = case op(n)\n                of \"and\", \"&\": \"\
    and\"\n                of \"or\", \"|\": \"or\"\n                else: \"xor\"\
    \n            if width == 0:\n                let symbol = case operation\n  \
    \                  of \"and\": \"&\"\n                    of \"or\": \"|\"\n \
    \                   else: \"^\"\n                return \"(\" & a & symbol & b\
    \ & \")\"\n            \"_mm\" & $width & \"_\" & operation & \"_si\" & $width\
    \ & \"(\" & a & \",\" & b & \")\"\n        proc truth(node: NimNode, row: int):\
    \ bool =\n            let n = unwrap(node)\n            if n.kind in {nnkIdent,\
    \ nnkSym}:\n                for i, leaf in leaves:\n                    if leaf\
    \ == n: return (row and (1 shl (2-i))) != 0\n            let a = truth(n[1], row)\n\
    \            if n.kind == nnkPrefix: return not a\n            let b = truth(n[2],\
    \ row)\n            case op(n)\n            of \"and\", \"&\": a and b\n     \
    \       of \"or\", \"|\": a or b\n            else: a xor b\n        let kernel\
    \ = genSym(nskProc, \"bitsetFuseKernel\")\n        let name = \"cplib_\" & kernel.repr.replace(\"\
    `\", \"\")\n        var code = \"#include <immintrin.h>\\n#include <stdint.h>\\\
    n#include <stddef.h>\\n\"\n        for width in [256, 512]:\n            let suffix\
    \ = $width\n            let target = if width == 256: \"avx2\" else: \"avx512f\"\
    \n            let castType = if width == 256: \"__m256i\" else: \"void\"\n   \
    \         code.add(\"__attribute__((target(\\\"\" & target & \"\\\"))) static\
    \ void \" & name & suffix & \"(uint64_t *dst, uint64_t **src, size_t n) {\\nsize_t\
    \ i=0;\\n\")\n            code.add(\"for (; i+\" & $(width div 64) & \"<=n; i+=\"\
    \ & $(width div 64) & \") {\\n\")\n            for j in 0..<leaves.len:\n    \
    \            code.add(\"__m\" & suffix & \"i v\" & $j & \" = _mm\" & suffix &\
    \ \"_loadu_si\" & suffix & \"((const \" & castType & \" *)(src[\" & $j & \"]+i));\\\
    n\")\n            var value = expression(rhs, width)\n            if width ==\
    \ 512 and leaves.len <= 3:\n                var mask = 0\n                for\
    \ row in 0..7:\n                    if truth(rhs, row): mask = mask or (1 shl\
    \ row)\n                value = \"_mm512_ternarylogic_epi64(v0,\" & (if leaves.len\
    \ >= 2: \"v1\" else: \"v0\") & \",\" & (if leaves.len >= 3: \"v2\" else: \"v0\"\
    ) & \",\" & $mask & \")\"\n            code.add(\"_mm\" & suffix & \"_storeu_si\"\
    \ & suffix & \"((\" & castType & \" *)(dst+i),\" & value & \");\\n}\\nfor (;i<n;++i)\
    \ {\\n\")\n            for j in 0..<leaves.len:\n                code.add(\"uint64_t\
    \ v\" & $j & \" = src[\" & $j & \"][i];\\n\")\n            code.add(\"dst[i]=\"\
    \ & expression(rhs, 0) & \";\\n}\\n}\\n\")\n        code.add(\"static void \"\
    \ & name & \"(uint64_t *dst, uint64_t **src, size_t n) {\\nif (__builtin_cpu_supports(\\\
    \"avx512f\\\")) \" & name & \"512(dst,src,n); else \" & name & \"256(dst,src,n);\\\
    n}\\n\")\n        # \u95A2\u6570\u5185\u304B\u3089\u306E\u547C\u3073\u51FA\u3057\
    \u3067\u3082\u30AB\u30FC\u30CD\u30EB\u306F\u30D5\u30A1\u30A4\u30EB\u30B9\u30B3\
    \u30FC\u30D7\u306B\u914D\u7F6E\u3057\u307E\u3059\u3002\n        # \u5BA3\u8A00\
    \u30FB\u5B9A\u7FA9\u3084\u30B8\u30A7\u30CD\u30EA\u30C3\u30AF\u306E\u5B9F\u4F53\
    \u5316\u306B\u3088\u308B\u91CD\u8907\u306F\u30AC\u30FC\u30C9\u3067\u9632\u304E\
    \u307E\u3059\u3002\n        let declaration = newLit(\"\\n#ifndef \" & name &\
    \ \"_DEFINED\\n#define \" & name & \"_DEFINED\\n\" & code & \"#endif\\n$1 $2$3\"\
    )\n        let cname = newLit(name)\n        let pointers = genSym(nskVar, \"\
    sources\")\n        var values = newNimNode(nnkBracket)\n        for leaf in leaves:\
    \ values.add(newCall(bindSym\"fuseData\", leaf))\n        let first = leaves[0]\n\
    \        var checks = newStmtList()\n        for leaf in leaves:\n           \
    \ checks.add quote do:\n                if len(`leaf`) != len(`first`):\n    \
    \                raise newException(ValueError, \"BitSet sizes must match\")\n\
    \        result.add quote do:\n            block:\n                `checks`\n\
    \                if len(`dst`) != len(`first`):\n                    `fallback`\n\
    \                else:\n                    proc `kernel`(dst: ptr uint64, src:\
    \ ptr ptr uint64, n: csize_t) {.codegenDecl: `declaration`.} =\n             \
    \           {.emit: [`cname`, \"(\", dst, \",\", src, \",\", n, \");\"].}\n  \
    \                  var `pointers` = `values`\n                    `kernel`(fuseData(`dst`),\
    \ addr `pointers`[0], fuseWords(`dst`))\n                    trim(`dst`)\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  isVerificationFile: false
  path: cplib/collections/private/bitset_avx512_fuse.nim
  requiredBy:
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/bitset_avx512.nim
  timestamp: '2026-09-14 23:18:26+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_fuse_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
  - verify/AI/bitset_avx512_prev_set_bit_test.nim
documentation_of: cplib/collections/private/bitset_avx512_fuse.nim
layout: document
redirect_from:
- /library/cplib/collections/private/bitset_avx512_fuse.nim
- /library/cplib/collections/private/bitset_avx512_fuse.nim.html
title: cplib/collections/private/bitset_avx512_fuse.nim
---
