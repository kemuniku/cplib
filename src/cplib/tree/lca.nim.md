---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lca_test.nim
    title: verify/AI/lca_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lca_test.nim
    title: verify/AI/lca_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/la_jump_on_tree_yosupo_test.nim
    title: verify/tree/lca/la_jump_on_tree_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/la_jump_on_tree_yosupo_test.nim
    title: verify/tree/lca/la_jump_on_tree_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/lca_from_parent_yosupo_test.nim
    title: verify/tree/lca/lca_from_parent_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/lca_from_parent_yosupo_test.nim
    title: verify/tree/lca/lca_from_parent_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/lca_yosupo_test.nim
    title: verify/tree/lca/lca_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/lca/lca_yosupo_test.nim
    title: verify/tree/lca/lca_yosupo_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://arxiv.org/abs/2005.11188
    - https://doi.org/10.1007/BFb0040379
    - https://www.lrvideckis.com/blog/2024/02/29/linear_level_ancestors.html
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TREE_LCA:\n    const CPLIB_TREE_LCA* = 1\n    import\
    \ bitops, sequtils\n    import cplib/graph/graph\n\n    template lcaUninit(T:\
    \ typedesc, n: int): untyped =\n        ## \u4F7F\u7528\u3059\u308B\u8981\u7D20\
    \u3092\u5F8C\u304B\u3089\u8A2D\u5B9A\u3059\u308B\u6574\u6570\u914D\u5217\u3092\
    \u78BA\u4FDD\u3059\u308B\u3002O(N)\n        when declared(newSeqUninit): newSeqUninit[T](n)\n\
    \        else: newSeqUninitialized[T](n)\n    # Schieber\u2013Vishkin\u6CD5\u3002\
    \u8449\u306EDFS\u533A\u9593\u304B\u3089\u7E26\u30D1\u30B9\u3092\u4F5C\u308A\u3001\
    \u7956\u5148\u306E\u7E26\u30D1\u30B9\u3092\u30D3\u30C3\u30C8\u5217\u3067\u8868\
    \u3059\u3002\n    # https://doi.org/10.1007/BFb0040379\n    type LowestCommonAncestor*\
    \ = ref object\n        # \u4EE5\u4E0B\u306E\u30DD\u30A4\u30F3\u30BF\u306F\u4FDD\
    \u6301\u3059\u308Bseq\u306E\u53C2\u7167\u3002\u69CB\u7BC9\u5F8C\u306F\u914D\u5217\
    \u3092\u4F38\u7E2E\u3057\u306A\u3044\u3002\n        dataPtr, prefixPtr, pathPtr:\
    \ ptr UncheckedArray[uint32]\n        branchPtr: ptr UncheckedArray[uint8]\n \
    \       headPtr: ptr UncheckedArray[int32]\n        n: int\n        # \u9802\u70B9\
    \u3054\u3068\u306B\u30E9\u30D9\u30EB\u3001\u7956\u5148\u30DE\u30B9\u30AF\u3001\
    \u6DF1\u3055\u3092\u683C\u7D0D\u3059\u308B\u3002\n        data, prefixLCA, pathAttach:\
    \ seq[uint32]\n        prefixBranch: seq[uint8]\n        parents, headParent:\
    \ seq[int32]\n        ordered: bool\n        # kind\u306F\u4E00\u822C\u306E\u6728\
    =0\u3001\u9802\u70B9\u756A\u53F7\u9806\u306E\u9396=1\u3001\u30B9\u30BF\u30FC=2\u3001\
    \u9577\u3044\u7D4C\u8DEF\u3092\u6301\u3064\u6728=3\u3002\n        kind, root:\
    \ int\n        laEnabled: bool\n        laIndex: seq[uint32]\n        laJump,\
    \ laLadder: seq[int32]\n        laBase: seq[int]\n\n    proc buildLA(tree: LowestCommonAncestor,\
    \ order: seq[int]) =\n        ## Euler tour\u306E\u30B8\u30E3\u30F3\u30D7\u3068\
    \u3001\u6700\u9577\u7D4C\u8DEF\u30925\u500D\u306B\u5EF6\u9577\u3057\u305Fladder\u3092\
    \u69CB\u7BC9\u3059\u308B\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N)\n        # https://arxiv.org/abs/2005.11188\n\
    \        # https://www.lrvideckis.com/blog/2024/02/29/linear_level_ancestors.html\n\
    \        let n = tree.n\n        template vertex(i: int): int =\n            ##\
    \ \u89AA\u304C\u5B50\u3088\u308A\u5148\u306B\u73FE\u308C\u308B\u9806\u5E8F\u306E\
    i\u756A\u76EE\u306E\u9802\u70B9\u3092\u8FD4\u3059\u3002O(1)\n            (if tree.ordered:\
    \ i else: order[i])\n        template dep(v: int): int =\n            ## \u69CB\
    \u7BC9\u6E08\u307F\u306E\u9802\u70B9\u306E\u6DF1\u3055\u3092\u8FD4\u3059\u3002\
    O(1)\n            tree.data[3 * v + 2].int\n        var leaf = lcaUninit(int32,\
    \ n)\n        for v in 0..<n: leaf[v] = v.int32\n        for i in countdown(n\
    \ - 1, 1):\n            let v = vertex(i)\n            let p = tree.parents[v].int\n\
    \            if dep(leaf[v].int) > dep(leaf[p].int): leaf[p] = leaf[v]\n     \
    \   tree.laBase = lcaUninit(int, n)\n        var total = 0\n        for i in 0..<n:\n\
    \            let v = vertex(i)\n            if v == tree.root or leaf[v] != leaf[tree.parents[v]]:\n\
    \                let bottom = leaf[v].int\n                let length = min(5\
    \ * (dep(bottom) - dep(v) + 1), dep(bottom) + 1)\n                tree.laBase[bottom]\
    \ = total + dep(bottom)\n                total += length\n        tree.laLadder\
    \ = lcaUninit(int32, total)\n        for i in 0..<n:\n            let v = vertex(i)\n\
    \            if v == tree.root or leaf[v] != leaf[tree.parents[v]]:\n        \
    \        let bottom = leaf[v].int\n                let length = min(5 * (dep(bottom)\
    \ - dep(v) + 1), dep(bottom) + 1)\n                let start = tree.laBase[bottom]\
    \ - dep(bottom)\n                var u = bottom\n                for j in 0..<length:\n\
    \                    tree.laLadder[start + j] = u.int32\n                    u\
    \ = tree.parents[u].int\n        for v in 0..<n: tree.laBase[v] = tree.laBase[leaf[v]]\n\
    \        var child = newSeqWith(n, -1'i32)\n        var sibling = lcaUninit(int32,\
    \ n)\n        for v in 0..<n:\n            if v != tree.root:\n              \
    \  let p = tree.parents[v].int\n                sibling[v] = child[p]\n      \
    \          child[p] = v.int32\n        tree.laIndex = lcaUninit(uint32, n)\n \
    \       tree.laJump = lcaUninit(int32, 2 * n)\n        var stack = newSeqOfCap[int32](dep(leaf[tree.root].int)\
    \ + 1)\n        stack.add(tree.root.int32)\n        var index = 1\n        tree.laIndex[tree.root]\
    \ = index.uint32\n        tree.laJump[index] = tree.root.int32\n        while\
    \ stack.len > 0:\n            let v = stack[^1].int\n            let u = child[v].int\n\
    \            if u != -1:\n                child[v] = sibling[u]\n            \
    \    stack.add(u.int32)\n                inc index\n                tree.laIndex[u]\
    \ = index.uint32\n            else:\n                discard stack.pop()\n   \
    \             if stack.len == 0: break\n                inc index\n          \
    \  let jump = index and -index\n            tree.laJump[index] = stack[max(0,\
    \ stack.len - 1 - jump)]\n\n    when defined(cpp) and (defined(gcc) or defined(clang)):\n\
    \        {.emit: \"\"\"\n#include <cstdint>\nnamespace cplib_lca {\ntemplate<bool\
    \ Ordered>\nstatic NI build(const std::int32_t* __restrict parent,\n        const\
    \ NI* __restrict order, NI n, NI root,\n        std::int32_t* __restrict size,\
    \ std::uint32_t* __restrict data,\n        std::uint8_t* __restrict branches,\
    \ std::int32_t* __restrict head) {\n    // \u8449\u306E\u533A\u9593\u3068\u7E26\
    \u30D1\u30B9\u306E\u60C5\u5831\u3092\u3001\u914D\u5217\u540C\u58EB\u304C\u91CD\
    \u306A\u3089\u306A\u3044\u6761\u4EF6\u3067\u69CB\u7BC9\u3059\u308B\u3002\n   \
    \ for (NI i = n - 1; i > 0; --i) {\n        if (i > 16) {\n            const NI\
    \ future = Ordered ? i - 16 : order[i - 16];\n            __builtin_prefetch(size\
    \ + parent[future], 1, 3);\n        }\n        const NI v = Ordered ? i : order[i];\n\
    \        const std::int32_t count = size[v] == 0 ? 1 : size[v];\n        size[v]\
    \ = count;\n        size[parent[v]] += count;\n    }\n    if (size[root] == 0)\
    \ size[root] = 1;\n    const std::uint32_t root_label = 1U << (31 - __builtin_clz(static_cast<unsigned>(size[root])));\n\
    \    data[3 * root] = data[3 * root + 1] = root_label;\n    data[3 * root + 2]\
    \ = 0;\n    branches[root] = 0;\n    head[root_label] = -1;\n    NI deepest =\
    \ root;\n    std::uint32_t max_depth = 0;\n    for (NI i = 1; i < n; ++i) {\n\
    \        // \u5F8C\u3067\u53C2\u7167\u3059\u308B\u89AA\u306E\u60C5\u5831\u3092\
    \u5148\u306B\u30AD\u30E3\u30C3\u30B7\u30E5\u3078\u8AAD\u307F\u8FBC\u3080\u3002\
    \n        if (i + 16 < n) {\n            const NI future = Ordered ? i + 16 :\
    \ order[i + 16];\n            const NI p = parent[future];\n            __builtin_prefetch(data\
    \ + 3 * p, 0, 3);\n            __builtin_prefetch(branches + p, 0, 3);\n     \
    \       __builtin_prefetch(size + p, 1, 3);\n        }\n        const NI v = Ordered\
    \ ? i : order[i];\n        const NI p = parent[v];\n        const std::uint32_t\
    \ end = size[p];\n        const std::uint32_t begin = end - size[v];\n       \
    \ size[p] = begin;\n        size[v] = end;\n        const unsigned shift = 31\
    \ - __builtin_clz(begin ^ end);\n        const std::uint32_t label = end & (~0U\
    \ << shift);\n        const std::uint32_t bit = label & -label;\n        branches[v]\
    \ = i < 64 ? i : branches[p];\n        data[3 * v] = label;\n        data[3 *\
    \ v + 1] = data[3 * p + 1] | bit;\n        const std::uint32_t depth = data[3\
    \ * p + 2] + 1;\n        data[3 * v + 2] = depth;\n        if (depth > max_depth)\
    \ { max_depth = depth; deepest = v; }\n        if (label != data[3 * p]) head[label]\
    \ = p;\n    }\n    return deepest;\n}\n}\n\"\"\".}\n        proc lcaBuildOrdered(parent:\
    \ ptr int32, order: ptr int, n, root: int,\n                size: ptr int32, data:\
    \ ptr uint32, branches: ptr uint8, head: ptr int32): int\n            {.importcpp:\
    \ \"cplib_lca::build<true>(@)\", nodecl.}\n        proc lcaBuildGeneral(parent:\
    \ ptr int32, order: ptr int, n, root: int,\n                size: ptr int32, data:\
    \ ptr uint32, branches: ptr uint8, head: ptr int32): int\n            {.importcpp:\
    \ \"cplib_lca::build<false>(@)\", nodecl.}\n\n    {.push boundChecks: off, overflowChecks:\
    \ off.}\n    proc initLCAFromParent*(parent: openArray[int], root: int, no_la:\
    \ bool = false): LowestCommonAncestor =\n        ## \u6839\u4ED8\u304D\u6728\u306E\
    \u89AA\u914D\u5217\u304B\u3089\u69CB\u7BC9\u3059\u308B\u3002parent[root]\u306F\
    \u53C2\u7167\u3057\u306A\u3044\u3002N < 2^31\u3002\u6642\u9593\u30FB\u7A7A\u9593\
    O(N)\n        ## no_la=true\u3067LA\u7528\u306E\u524D\u8A08\u7B97\u3092\u7701\u7565\
    \u3059\u308B\u3002\n        let n = parent.len\n        assert n <= high(int32).int,\
    \ \"\u9802\u70B9\u6570\u306F2^31\u672A\u6E80\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        assert 0 <= root and root < n, \"\u6839\u306E\
    \u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        result\
    \ = LowestCommonAncestor(n: n, root: root, parents: lcaUninit(int32, n), laEnabled:\
    \ not no_la)\n        let parentData = cast[ptr UncheckedArray[int32]](addr result.parents[0])\n\
    \        var invalid = 0'u32\n        var unordered = uint32(root != 0)\n    \
    \    var nonPath = uint32(root != 0)\n        var nonStar = 0'u32\n        template\
    \ copyParent(v: int) =\n            ## \u89AA\u756A\u53F7\u3092\u30B3\u30D4\u30FC\
    \u3057\u3001\u7BC4\u56F2\u3068\u9802\u70B9\u756A\u53F7\u9806\u306E\u6761\u4EF6\
    \u3092\u96C6\u8A08\u3059\u308B\u3002O(1)\n            let p = parent[v]\n    \
    \        invalid = invalid or uint32(p < 0) or uint32(p >= n)\n            unordered\
    \ = unordered or uint32(p >= v)\n            nonPath = nonPath or uint32(p !=\
    \ v - 1)\n            nonStar = nonStar or uint32(p != root)\n            parentData[v]\
    \ = cast[int32](p)\n        for v in 0..<root: copyParent(v)\n        for v in\
    \ root + 1..<n: copyParent(v)\n        assert invalid == 0, \"\u89AA\u306E\u9802\
    \u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        let ordered\
    \ = unordered == 0\n        result.parents[root] = -1\n        result.ordered\
    \ = ordered\n        if nonPath == 0:\n            result.kind = 1\n         \
    \   return\n        if nonStar == 0:\n            result.kind = 2\n          \
    \  return\n        result.data = lcaUninit(uint32, 3 * n)\n        result.prefixBranch\
    \ = lcaUninit(uint8, n)\n        result.prefixLCA = lcaUninit(uint32, 64 * 64)\n\
    \        var order: seq[int]\n        if not ordered:\n            var head =\
    \ newSeqWith(n, -1)\n            var next = newSeq[int](n)\n            for v\
    \ in 0..<n:\n                if v != root:\n                    next[v] = head[parent[v]]\n\
    \                    head[parent[v]] = v\n            order = newSeqOfCap[int](n)\n\
    \            order.add(root)\n            var i = 0\n            while i < order.len:\n\
    \                var v = head[order[i]]\n                while v != -1:\n    \
    \                order.add(v)\n                    v = next[v]\n             \
    \   inc i\n            assert order.len == n, \"\u6307\u5B9A\u3057\u305F\u6839\
    \u304B\u3089\u5168\u9802\u70B9\u306B\u5230\u9054\u3067\u304D\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059\"\n        template vertex(i: int): int =\n   \
    \         ## \u89AA\u304C\u5B50\u3088\u308A\u5148\u306B\u73FE\u308C\u308B\u9806\
    \u5E8F\u306Ei\u756A\u76EE\u306E\u9802\u70B9\u3092\u8FD4\u3059\u3002O(1)\n    \
    \        (if ordered: i else: order[i])\n        var deepest = root\n        var\
    \ size = newSeq[int32](n)\n        when defined(cpp) and (defined(gcc) or defined(clang)):\n\
    \            result.headParent = lcaUninit(int32, n + 1)\n            if ordered:\n\
    \                deepest = lcaBuildOrdered(addr result.parents[0], nil, n, root,\n\
    \                    addr size[0], addr result.data[0], addr result.prefixBranch[0],\
    \ addr result.headParent[0])\n            else:\n                deepest = lcaBuildGeneral(addr\
    \ result.parents[0], addr order[0], n, root,\n                    addr size[0],\
    \ addr result.data[0], addr result.prefixBranch[0], addr result.headParent[0])\n\
    \        else:\n            for i in countdown(n - 1, 1):\n                let\
    \ v = vertex(i)\n                size[v] = max(1'i32, size[v])\n             \
    \   size[result.parents[v]] += size[v]\n            size[root] = max(1'i32, size[root])\n\
    \            let leaves = size[root].int\n            result.headParent = lcaUninit(int32,\
    \ leaves + 1)\n            # DFS\u9806\u306E\u8449\u306E\u533A\u9593\u304B\u3089\
    \u3001\u6700\u4E0B\u4F4D\u30D3\u30C3\u30C8\u304C\u6700\u5927\u306E\u756A\u53F7\
    \u3092\u7E26\u30D1\u30B9\u306E\u30E9\u30D9\u30EB\u306B\u3059\u308B\u3002\n   \
    \         let rootLabel = 1'u32 shl fastLog2(leaves)\n            result.data[3\
    \ * root] = rootLabel\n            result.data[3 * root + 1] = rootLabel\n   \
    \         result.data[3 * root + 2] = 0\n            result.prefixBranch[root]\
    \ = 0\n            result.headParent[rootLabel] = -1\n            for i in 1..<n:\n\
    \                let v = vertex(i)\n                let p = result.parents[v].int\n\
    \                let stop = size[p].int\n                let start = stop - size[v].int\n\
    \                size[p] = start.int32\n                size[v] = stop.int32\n\
    \                let k = fastLog2(start xor stop)\n                let label =\
    \ stop.uint32 and (high(uint32) shl k)\n                let bit = label and (0'u32\
    \ - label)\n                result.prefixBranch[v] = (if i < 64: i.uint8 else:\
    \ result.prefixBranch[p])\n                result.data[3 * v] = label\n      \
    \          result.data[3 * v + 1] = result.data[3 * p + 1] or bit\n          \
    \      result.data[3 * v + 2] = result.data[3 * p + 2] + 1\n                if\
    \ result.data[3 * v + 2] > result.data[3 * deepest + 2]: deepest = v\n       \
    \         if label != result.data[3 * p]:\n                    result.headParent[label]\
    \ = p.int32\n        # \u5148\u982D64\u9802\u70B9\u306F\u7956\u5148\u3092\u542B\
    \u3080\u306E\u3067\u3001\u305D\u306E\u4E2D\u3067\u306ELCA\u3092\u5C0F\u3055\u306A\
    \u8868\u3078\u307E\u3068\u3081\u308B\u3002\n        result.prefixLCA[0] = root.uint32\n\
    \        for i in 1..<min(n, 64):\n            let v = vertex(i)\n           \
    \ let p = result.prefixBranch[result.parents[v]].int\n            result.prefixLCA[i\
    \ * 64 + i] = v.uint32\n            for j in 0..<i:\n                let ancestor\
    \ = result.prefixLCA[p * 64 + j]\n                result.prefixLCA[i * 64 + j]\
    \ = ancestor\n                result.prefixLCA[j * 64 + i] = ancestor\n      \
    \  # \u6839\u304B\u3089\u6700\u6DF1\u9802\u70B9\u307E\u3067\u306E\u7E26\u30D1\u30B9\
    \u304C2\u672C\u4EE5\u4E0B\u306A\u3089\u3001\u8FFD\u52A0\u306E\u8868\u306F\u4F5C\
    \u3089\u306A\u3044\u3002\n        if result.data[3 * deepest + 2] >= 64 and countSetBits(result.data[3\
    \ * deepest + 1]) > 2:\n            # \u6700\u6DF1\u9802\u70B9\u3078\u306E\u7D4C\
    \u8DEF\u306B\u63A5\u7D9A\u3059\u308B\u7956\u5148\u3092\u8A18\u9332\u3057\u3001\
    \u9577\u3044\u7D4C\u8DEF\u4E0A\u306ELCA\u3092\u76F4\u63A5\u8FD4\u3059\u3002\n\
    \            result.pathAttach = newSeqWith(n, high(uint32))\n            let\
    \ attach = cast[ptr UncheckedArray[uint32]](addr result.pathAttach[0])\n     \
    \       var v = deepest\n            while v != -1:\n                attach[v]\
    \ = cast[uint32](v)\n                v = parentData[v].int\n            for i\
    \ in 1..<n:\n                let v = vertex(i)\n                if attach[v] ==\
    \ high(uint32):\n                    attach[v] = attach[parentData[v]]\n     \
    \       result.pathPtr = attach\n            result.kind = 3\n        result.dataPtr\
    \ = cast[ptr UncheckedArray[uint32]](addr result.data[0])\n        result.prefixPtr\
    \ = cast[ptr UncheckedArray[uint32]](addr result.prefixLCA[0])\n        result.headPtr\
    \ = cast[ptr UncheckedArray[int32]](addr result.headParent[0])\n        result.branchPtr\
    \ = cast[ptr UncheckedArray[uint8]](addr result.prefixBranch[0])\n        if not\
    \ no_la: result.buildLA(order)\n    {.pop.}\n\n    proc undirectedAdj(g: UnDirectedGraph\
    \ or DirectedGraph): seq[seq[int]] =\n        ## \u8FBA\u306E\u5411\u304D\u3068\
    \u91CD\u307F\u3092\u7121\u8996\u3057\u305F\u96A3\u63A5\u30EA\u30B9\u30C8\u3092\
    \u4F5C\u308B\u3002O(N + M)\n        result = newSeq[seq[int]](g.len)\n       \
    \ for v in 0..<g.len:\n            for (u, _) in g.to_and_cost(v):\n         \
    \       result[v].add(u)\n                result[u].add(v)\n\n    proc undirectedAdj(adj:\
    \ openArray[seq[int]]): seq[seq[int]] =\n        ## \u96A3\u63A5\u30EA\u30B9\u30C8\
    \u306E\u8FBA\u306E\u5411\u304D\u3092\u7121\u8996\u3057\u305F\u96A3\u63A5\u30EA\
    \u30B9\u30C8\u3092\u4F5C\u308B\u3002O(N + M)\n        result = newSeq[seq[int]](adj.len)\n\
    \        for v in 0..<adj.len:\n            for u in adj[v]:\n               \
    \ assert 0 <= u and u < adj.len, \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\
    \u3067\u3059\"\n                result[v].add(u)\n                result[u].add(v)\n\
    \n    proc fromAdj(adj: seq[seq[int]] or UnDirectedGraph, root: int, forest, no_la:\
    \ bool): LowestCommonAncestor =\n        ## \u96A3\u63A5\u30EA\u30B9\u30C8\u3092\
    \u89AA\u914D\u5217\u3078\u5909\u63DB\u3057\u3066\u69CB\u7BC9\u3059\u308B\u3002\
    O(N + M)\n        let n = adj.len\n        var parent = newSeqWith(n + int(forest),\
    \ -2)\n        var stack: seq[int]\n        if forest:\n            parent[n]\
    \ = -1\n        else:\n            assert 0 <= root and root < n, \"\u6839\u306E\
    \u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n            parent[root]\
    \ = -1\n            stack.add(root)\n        for start in 0..<max(1, n):\n   \
    \         if forest:\n                if start == n or parent[start] != -2: continue\n\
    \                parent[start] = n\n                stack.add(start)\n       \
    \     elif start != 0:\n                break\n            while stack.len > 0:\n\
    \                let v = stack.pop()\n                template visit(u: int) =\n\
    \                    ## \u672A\u8A2A\u554F\u306E\u9802\u70B9\u3092\u63A2\u7D22\
    \u5019\u88DC\u306B\u8FFD\u52A0\u3059\u308B\u3002\u511F\u5374O(1)\n           \
    \         if parent[u] == -2:\n                        parent[u] = v\n       \
    \                 stack.add(u)\n                when adj is UnDirectedGraph:\n\
    \                    for (u, _) in adj.to_and_cost(v): visit(u)\n            \
    \    else:\n                    for u in adj[v]: visit(u)\n        result = initLCAFromParent(parent,\
    \ (if forest: n else: root), no_la)\n\n    proc initLCA*(g: UnDirectedGraph or\
    \ DirectedGraph, root: int, no_la: bool = false): LowestCommonAncestor =\n   \
    \     ## \u8FBA\u306E\u5411\u304D\u3068\u91CD\u307F\u3092\u7121\u8996\u3059\u308B\
    \u3068\u6728\u306B\u306A\u308Bg\u304B\u3089\u69CB\u7BC9\u3059\u308B\u3002\u6642\
    \u9593\u30FB\u7A7A\u9593O(N + M)\u3001\u6728\u3067\u306FO(N)\n        ## no_la=true\u3067\
    LA\u7528\u306E\u524D\u8A08\u7B97\u3092\u7701\u7565\u3059\u308B\u3002\n       \
    \ when g is UnDirectedGraph:\n            fromAdj(g, root, false, no_la)\n   \
    \     else:\n            fromAdj(undirectedAdj(g), root, false, no_la)\n\n   \
    \ proc initLCA*(adj: openArray[seq[int]], root: int, no_la: bool = false): LowestCommonAncestor\
    \ =\n        ## \u6728\u306E\u96A3\u63A5\u30EA\u30B9\u30C8\u304B\u3089\u8FBA\u306E\
    \u5411\u304D\u3092\u7121\u8996\u3057\u3066\u69CB\u7BC9\u3059\u308B\u3002\u6642\
    \u9593\u30FB\u7A7A\u9593O(N + M)\u3001\u6728\u3067\u306FO(N)\n        ## no_la=true\u3067\
    LA\u7528\u306E\u524D\u8A08\u7B97\u3092\u7701\u7565\u3059\u308B\u3002\n       \
    \ fromAdj(undirectedAdj(adj), root, false, no_la)\n\n    proc initLCAFromForest*(g:\
    \ UnDirectedGraph or DirectedGraph, no_la: bool = false): LowestCommonAncestor\
    \ =\n        ## \u68EE\u306B\u6839N\u3092\u8FFD\u52A0\u3057\u3001\u5404\u6210\u5206\
    \u306E\u6700\u5C0F\u756A\u53F7\u306E\u9802\u70B9\u3068\u7D50\u3076\u3002\u8FBA\
    \u306E\u5411\u304D\u3068\u91CD\u307F\u306F\u7121\u8996\u3059\u308B\u3002O(N +\
    \ M)\n        ## no_la=true\u3067LA\u7528\u306E\u524D\u8A08\u7B97\u3092\u7701\u7565\
    \u3059\u308B\u3002\n        when g is UnDirectedGraph:\n            fromAdj(g,\
    \ g.len, true, no_la)\n        else:\n            fromAdj(undirectedAdj(g), g.len,\
    \ true, no_la)\n\n    proc initLCAFromForest*(adj: openArray[seq[int]], no_la:\
    \ bool = false): LowestCommonAncestor =\n        ## \u68EE\u306E\u96A3\u63A5\u30EA\
    \u30B9\u30C8\u306E\u5411\u304D\u3092\u7121\u8996\u3057\u3001\u6839N\u3092\u8FFD\
    \u52A0\u3057\u3066\u5404\u6210\u5206\u306E\u6700\u5C0F\u9802\u70B9\u3068\u7D50\
    \u3076\u3002O(N + M)\n        ## no_la=true\u3067LA\u7528\u306E\u524D\u8A08\u7B97\
    \u3092\u7701\u7565\u3059\u308B\u3002\n        fromAdj(undirectedAdj(adj), adj.len,\
    \ true, no_la)\n\n    proc numVertices*(tree: LowestCommonAncestor): int =\n \
    \       ## \u9802\u70B9\u6570\u3092\u8FD4\u3059\u3002\u68EE\u306E\u5834\u5408\u306F\
    \u8FFD\u52A0\u3057\u305F\u6839\u3092\u542B\u3080\u3002O(1)\n        tree.parents.len\n\
    \n    proc parentOf*(tree: LowestCommonAncestor, v: int): int =\n        ## \u9802\
    \u70B9v\u306E\u89AA\u3092\u8FD4\u3059\u3002\u6839\u306E\u5834\u5408\u306F-1\u3092\
    \u8FD4\u3059\u3002O(1)\n        tree.parents[v].int\n\n    proc depth*(tree: LowestCommonAncestor,\
    \ v: int): int =\n        ## \u6839\u304B\u3089\u9802\u70B9v\u307E\u3067\u306E\
    \u8FBA\u6570\u3092\u8FD4\u3059\u3002O(1)\n        assert 0 <= v and v < tree.n,\
    \ \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        if\
    \ tree.kind == 1: v\n        elif tree.kind == 2: int(v != tree.root)\n      \
    \  else: tree.data[3 * v + 2].int\n\n    proc la*(tree: LowestCommonAncestor,\
    \ v, k: int): int =\n        ## v\u304B\u3089k\u8FBA\u4E0A\u306E\u7956\u5148\u3092\
    \u8FD4\u3059\u3002LA\u6709\u52B9\u3067\u306E\u69CB\u7BC9\u304C\u5FC5\u8981\u3002\
    k\u304C\u8CA0\u307E\u305F\u306F\u6839\u3092\u8D85\u3048\u308B\u5834\u5408\u306F\
    -1\u3002O(1)\n        assert tree.laEnabled, \"LA\u3092\u4F7F\u7528\u3059\u308B\
    \u306B\u306Fno_la=false\u3067\u69CB\u7BC9\u3057\u3066\u304F\u3060\u3055\u3044\"\
    \n        assert 0 <= v and v < tree.n, \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\
    \u56F2\u5916\u3067\u3059\"\n        if k < 0: return -1\n        let targetDepth\
    \ = tree.depth(v) - k\n        if targetDepth < 0: return -1\n        if k ==\
    \ 0: return v\n        if k == 1: return tree.parents[v].int\n        if tree.kind\
    \ == 1: return v - k\n        let step = 1 shl fastLog2(k shr 1)\n        let\
    \ index = (tree.laIndex[v].int and -step) or step\n        let jump = tree.laJump[index].int\n\
    \        tree.laLadder[tree.laBase[jump] - targetDepth].int\n\n    {.push boundChecks:\
    \ off, overflowChecks: off.}\n    proc lcaInsideBranch(tree: LowestCommonAncestor,\
    \ u, v: int): int {.noinline.} =\n        ## \u540C\u3058\u63A5\u70B9\u3092\u6301\
    \u3064\u9802\u70B9\u9593\u306ELCA\u3092\u3001\u7E26\u30D1\u30B9\u306E\u30D3\u30C3\
    \u30C8\u6F14\u7B97\u3067\u8FD4\u3059\u3002O(1)\n        let a = tree.dataPtr[3\
    \ * u]\n        let b = tree.dataPtr[3 * v]\n        var x = u\n        var y\
    \ = v\n        if a != b:\n            let common = tree.dataPtr[3 * u + 1] and\
    \ tree.dataPtr[3 * v + 1] and (high(uint32) shl fastLog2(a xor b))\n         \
    \   let lowA = tree.dataPtr[3 * u + 1] xor common\n            if lowA != 0:\n\
    \                let k = fastLog2(lowA)\n                x = tree.headPtr[(a and\
    \ (high(uint32) shl k)) or (1'u32 shl k)].int\n            let lowB = tree.dataPtr[3\
    \ * v + 1] xor common\n            if lowB != 0:\n                let k = fastLog2(lowB)\n\
    \                y = tree.headPtr[(b and (high(uint32) shl k)) or (1'u32 shl k)].int\n\
    \        if tree.ordered: min(x, y)\n        elif tree.dataPtr[3 * x + 2] <= tree.dataPtr[3\
    \ * y + 2]: x\n        else: y\n\n    proc lca*(tree: LowestCommonAncestor, u,\
    \ v: int): int {.inline.} =\n        ## \u9802\u70B9u\u3068v\u306E\u6700\u5C0F\
    \u5171\u901A\u7956\u5148\u3092\u8FD4\u3059\u3002O(1)\n        assert 0 <= u and\
    \ u < tree.n and 0 <= v and v < tree.n, \"\u9802\u70B9\u756A\u53F7\u304C\u7BC4\
    \u56F2\u5916\u3067\u3059\"\n        if tree.kind != 0:\n            if tree.kind\
    \ == 3:\n                let a = tree.pathPtr[u].int\n                let b =\
    \ tree.pathPtr[v].int\n                if a != b:\n                    if tree.ordered:\
    \ return min(a, b)\n                    return (if tree.dataPtr[3 * a + 2] <=\
    \ tree.dataPtr[3 * b + 2]: a else: b)\n            elif tree.kind == 1:\n    \
    \            return min(u, v)\n            else:\n                return (if u\
    \ == v: u else: tree.root)\n        let branchA = tree.branchPtr[u].int\n    \
    \    let branchB = tree.branchPtr[v].int\n        if branchA != branchB: return\
    \ tree.prefixPtr[branchA * 64 + branchB].int\n        tree.lcaInsideBranch(u,\
    \ v)\n    {.pop.}\n\n    proc dist*(tree: LowestCommonAncestor, u, v: int): int\
    \ =\n        ## \u9802\u70B9u\u3068v\u3092\u7D50\u3076\u30D1\u30B9\u306E\u8FBA\
    \u6570\u3092\u8FD4\u3059\u3002O(1)\n        tree.depth(u) + tree.depth(v) - 2\
    \ * tree.depth(tree.lca(u, v))\n\n    proc la*(tree: LowestCommonAncestor, starting,\
    \ goal, d: int): int =\n        ## starting\u304B\u3089goal\u3078d\u8FBA\u9032\
    \u3093\u3060\u9802\u70B9\u3092\u8FD4\u3059\u3002d\u304C\u8CA0\u307E\u305F\u306F\
    \u30D1\u30B9\u306E\u8FBA\u6570\u3092\u8D85\u3048\u308B\u5834\u5408\u306F-1\u3002\
    O(1)\n        assert tree.laEnabled, \"LA\u3092\u4F7F\u7528\u3059\u308B\u306B\u306F\
    no_la=false\u3067\u69CB\u7BC9\u3057\u3066\u304F\u3060\u3055\u3044\"\n        let\
    \ ancestor = tree.lca(starting, goal)\n        let up = tree.depth(starting) -\
    \ tree.depth(ancestor)\n        let length = up + tree.depth(goal) - tree.depth(ancestor)\n\
    \        if d < 0 or d > length: return -1\n        if d <= up: tree.la(starting,\
    \ d)\n        else: tree.la(goal, length - d)\n\n    proc median*(tree: LowestCommonAncestor,\
    \ x, y, z: int): int =\n        ## \u6839\u3092x\u3068\u3057\u305F\u3068\u304D\
    \u306Ey\u3068z\u306E\u6700\u5C0F\u5171\u901A\u7956\u5148\u3092\u8FD4\u3059\u3002\
    O(1)\n        tree.lca(x, y) xor tree.lca(y, z) xor tree.lca(x, z)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/lca.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/lca_test.nim
  - verify/AI/lca_test.nim
  - verify/tree/lca/lca_from_parent_yosupo_test.nim
  - verify/tree/lca/lca_from_parent_yosupo_test.nim
  - verify/tree/lca/lca_yosupo_test.nim
  - verify/tree/lca/lca_yosupo_test.nim
  - verify/tree/lca/la_jump_on_tree_yosupo_test.nim
  - verify/tree/lca/la_jump_on_tree_yosupo_test.nim
documentation_of: cplib/tree/lca.nim
layout: document
redirect_from:
- /library/cplib/tree/lca.nim
- /library/cplib/tree/lca.nim.html
title: cplib/tree/lca.nim
---
