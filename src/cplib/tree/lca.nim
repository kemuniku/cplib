when not declared CPLIB_TREE_LCA:
    const CPLIB_TREE_LCA* = 1
    import bitops, sequtils
    import cplib/graph/graph

    template lcaUninit(T: typedesc, n: int): untyped =
        ## 使用する要素を後から設定する整数配列を確保する。O(N)
        when declared(newSeqUninit): newSeqUninit[T](n)
        else: newSeqUninitialized[T](n)
    # Schieber–Vishkin法。葉のDFS区間から縦パスを作り、祖先の縦パスをビット列で表す。
    # https://doi.org/10.1007/BFb0040379
    type LowestCommonAncestor* = ref object
        # 以下のポインタは保持するseqの参照。構築後は配列を伸縮しない。
        dataPtr, prefixPtr, pathPtr: ptr UncheckedArray[uint32]
        branchPtr: ptr UncheckedArray[uint8]
        headPtr: ptr UncheckedArray[int32]
        n: int
        # 頂点ごとにラベル、祖先マスク、深さを格納する。
        data, prefixLCA, pathAttach: seq[uint32]
        prefixBranch: seq[uint8]
        parents, headParent: seq[int32]
        ordered: bool
        # kindは一般の木=0、頂点番号順の鎖=1、スター=2、長い経路を持つ木=3。
        kind, root: int

    when defined(cpp) and (defined(gcc) or defined(clang)):
        {.emit: """
#include <cstdint>
namespace cplib_lca {
template<bool Ordered>
static NI build(const std::int32_t* __restrict parent,
        const NI* __restrict order, NI n, NI root,
        std::int32_t* __restrict size, std::uint32_t* __restrict data,
        std::uint8_t* __restrict branches, std::int32_t* __restrict head) {
    // 葉の区間と縦パスの情報を、配列同士が重ならない条件で構築する。
    for (NI i = n - 1; i > 0; --i) {
        if (i > 16) {
            const NI future = Ordered ? i - 16 : order[i - 16];
            __builtin_prefetch(size + parent[future], 1, 3);
        }
        const NI v = Ordered ? i : order[i];
        const std::int32_t count = size[v] == 0 ? 1 : size[v];
        size[v] = count;
        size[parent[v]] += count;
    }
    if (size[root] == 0) size[root] = 1;
    const std::uint32_t root_label = 1U << (31 - __builtin_clz(static_cast<unsigned>(size[root])));
    data[3 * root] = data[3 * root + 1] = root_label;
    data[3 * root + 2] = 0;
    branches[root] = 0;
    head[root_label] = -1;
    NI deepest = root;
    std::uint32_t max_depth = 0;
    for (NI i = 1; i < n; ++i) {
        // 後で参照する親の情報を先にキャッシュへ読み込む。
        if (i + 16 < n) {
            const NI future = Ordered ? i + 16 : order[i + 16];
            const NI p = parent[future];
            __builtin_prefetch(data + 3 * p, 0, 3);
            __builtin_prefetch(branches + p, 0, 3);
            __builtin_prefetch(size + p, 1, 3);
        }
        const NI v = Ordered ? i : order[i];
        const NI p = parent[v];
        const std::uint32_t end = size[p];
        const std::uint32_t begin = end - size[v];
        size[p] = begin;
        size[v] = end;
        const unsigned shift = 31 - __builtin_clz(begin ^ end);
        const std::uint32_t label = end & (~0U << shift);
        const std::uint32_t bit = label & -label;
        branches[v] = i < 64 ? i : branches[p];
        data[3 * v] = label;
        data[3 * v + 1] = data[3 * p + 1] | bit;
        const std::uint32_t depth = data[3 * p + 2] + 1;
        data[3 * v + 2] = depth;
        if (depth > max_depth) { max_depth = depth; deepest = v; }
        if (label != data[3 * p]) head[label] = p;
    }
    return deepest;
}
}
""".}
        proc lcaBuildOrdered(parent: ptr int32, order: ptr int, n, root: int,
                size: ptr int32, data: ptr uint32, branches: ptr uint8, head: ptr int32): int
            {.importcpp: "cplib_lca::build<true>(@)", nodecl.}
        proc lcaBuildGeneral(parent: ptr int32, order: ptr int, n, root: int,
                size: ptr int32, data: ptr uint32, branches: ptr uint8, head: ptr int32): int
            {.importcpp: "cplib_lca::build<false>(@)", nodecl.}

    {.push boundChecks: off, overflowChecks: off.}
    proc initLCAFromParent*(parent: openArray[int], root: int): LowestCommonAncestor =
        ## 根付き木の親配列から構築する。parent[root]は参照しない。N < 2^31。時間・空間O(N)
        let n = parent.len
        assert n <= high(int32).int, "頂点数は2^31未満である必要があります"
        assert 0 <= root and root < n, "根の頂点番号が範囲外です"
        result = LowestCommonAncestor(n: n, root: root, parents: lcaUninit(int32, n))
        let parentData = cast[ptr UncheckedArray[int32]](addr result.parents[0])
        var invalid = 0'u32
        var unordered = uint32(root != 0)
        var nonPath = uint32(root != 0)
        var nonStar = 0'u32
        template copyParent(v: int) =
            ## 親番号をコピーし、範囲と頂点番号順の条件を集計する。O(1)
            let p = parent[v]
            invalid = invalid or uint32(p < 0) or uint32(p >= n)
            unordered = unordered or uint32(p >= v)
            nonPath = nonPath or uint32(p != v - 1)
            nonStar = nonStar or uint32(p != root)
            parentData[v] = cast[int32](p)
        for v in 0..<root: copyParent(v)
        for v in root + 1..<n: copyParent(v)
        assert invalid == 0, "親の頂点番号が範囲外です"
        let ordered = unordered == 0
        result.parents[root] = -1
        result.ordered = ordered
        if nonPath == 0:
            result.kind = 1
            return
        if nonStar == 0:
            result.kind = 2
            return
        result.data = lcaUninit(uint32, 3 * n)
        result.prefixBranch = lcaUninit(uint8, n)
        result.prefixLCA = lcaUninit(uint32, 64 * 64)
        var order: seq[int]
        if not ordered:
            var head = newSeqWith(n, -1)
            var next = newSeq[int](n)
            for v in 0..<n:
                if v != root:
                    next[v] = head[parent[v]]
                    head[parent[v]] = v
            order = newSeqOfCap[int](n)
            order.add(root)
            var i = 0
            while i < order.len:
                var v = head[order[i]]
                while v != -1:
                    order.add(v)
                    v = next[v]
                inc i
            assert order.len == n, "指定した根から全頂点に到達できる必要があります"
        template vertex(i: int): int =
            ## 親が子より先に現れる順序のi番目の頂点を返す。O(1)
            (if ordered: i else: order[i])
        var deepest = root
        var size = newSeq[int32](n)
        when defined(cpp) and (defined(gcc) or defined(clang)):
            result.headParent = lcaUninit(int32, n + 1)
            if ordered:
                deepest = lcaBuildOrdered(addr result.parents[0], nil, n, root,
                    addr size[0], addr result.data[0], addr result.prefixBranch[0], addr result.headParent[0])
            else:
                deepest = lcaBuildGeneral(addr result.parents[0], addr order[0], n, root,
                    addr size[0], addr result.data[0], addr result.prefixBranch[0], addr result.headParent[0])
        else:
            for i in countdown(n - 1, 1):
                let v = vertex(i)
                size[v] = max(1'i32, size[v])
                size[result.parents[v]] += size[v]
            size[root] = max(1'i32, size[root])
            let leaves = size[root].int
            result.headParent = lcaUninit(int32, leaves + 1)
            # DFS順の葉の区間から、最下位ビットが最大の番号を縦パスのラベルにする。
            let rootLabel = 1'u32 shl fastLog2(leaves)
            result.data[3 * root] = rootLabel
            result.data[3 * root + 1] = rootLabel
            result.data[3 * root + 2] = 0
            result.prefixBranch[root] = 0
            result.headParent[rootLabel] = -1
            for i in 1..<n:
                let v = vertex(i)
                let p = result.parents[v].int
                let stop = size[p].int
                let start = stop - size[v].int
                size[p] = start.int32
                size[v] = stop.int32
                let k = fastLog2(start xor stop)
                let label = stop.uint32 and (high(uint32) shl k)
                let bit = label and (0'u32 - label)
                result.prefixBranch[v] = (if i < 64: i.uint8 else: result.prefixBranch[p])
                result.data[3 * v] = label
                result.data[3 * v + 1] = result.data[3 * p + 1] or bit
                result.data[3 * v + 2] = result.data[3 * p + 2] + 1
                if result.data[3 * v + 2] > result.data[3 * deepest + 2]: deepest = v
                if label != result.data[3 * p]:
                    result.headParent[label] = p.int32
        # 先頭64頂点は祖先を含むので、その中でのLCAを小さな表へまとめる。
        result.prefixLCA[0] = root.uint32
        for i in 1..<min(n, 64):
            let v = vertex(i)
            let p = result.prefixBranch[result.parents[v]].int
            result.prefixLCA[i * 64 + i] = v.uint32
            for j in 0..<i:
                let ancestor = result.prefixLCA[p * 64 + j]
                result.prefixLCA[i * 64 + j] = ancestor
                result.prefixLCA[j * 64 + i] = ancestor
        # 根から最深頂点までの縦パスが2本以下なら、追加の表は作らない。
        if result.data[3 * deepest + 2] >= 64 and countSetBits(result.data[3 * deepest + 1]) > 2:
            # 最深頂点への経路に接続する祖先を記録し、長い経路上のLCAを直接返す。
            result.pathAttach = newSeqWith(n, high(uint32))
            let attach = cast[ptr UncheckedArray[uint32]](addr result.pathAttach[0])
            var v = deepest
            while v != -1:
                attach[v] = cast[uint32](v)
                v = parentData[v].int
            for i in 1..<n:
                let v = vertex(i)
                if attach[v] == high(uint32):
                    attach[v] = attach[parentData[v]]
            result.pathPtr = attach
            result.kind = 3
        result.dataPtr = cast[ptr UncheckedArray[uint32]](addr result.data[0])
        result.prefixPtr = cast[ptr UncheckedArray[uint32]](addr result.prefixLCA[0])
        result.headPtr = cast[ptr UncheckedArray[int32]](addr result.headParent[0])
        result.branchPtr = cast[ptr UncheckedArray[uint8]](addr result.prefixBranch[0])
    {.pop.}

    proc undirectedAdj(g: UnDirectedGraph or DirectedGraph): seq[seq[int]] =
        ## 辺の向きと重みを無視した隣接リストを作る。O(N + M)
        result = newSeq[seq[int]](g.len)
        for v in 0..<g.len:
            for (u, _) in g.to_and_cost(v):
                result[v].add(u)
                result[u].add(v)

    proc undirectedAdj(adj: openArray[seq[int]]): seq[seq[int]] =
        ## 隣接リストの辺の向きを無視した隣接リストを作る。O(N + M)
        result = newSeq[seq[int]](adj.len)
        for v in 0..<adj.len:
            for u in adj[v]:
                assert 0 <= u and u < adj.len, "頂点番号が範囲外です"
                result[v].add(u)
                result[u].add(v)

    proc fromAdj(adj: seq[seq[int]] or UnDirectedGraph, root: int, forest: bool): LowestCommonAncestor =
        ## 隣接リストを親配列へ変換して構築する。O(N + M)
        let n = adj.len
        var parent = newSeqWith(n + int(forest), -2)
        var stack: seq[int]
        if forest:
            parent[n] = -1
        else:
            assert 0 <= root and root < n, "根の頂点番号が範囲外です"
            parent[root] = -1
            stack.add(root)
        for start in 0..<max(1, n):
            if forest:
                if start == n or parent[start] != -2: continue
                parent[start] = n
                stack.add(start)
            elif start != 0:
                break
            while stack.len > 0:
                let v = stack.pop()
                template visit(u: int) =
                    ## 未訪問の頂点を探索候補に追加する。償却O(1)
                    if parent[u] == -2:
                        parent[u] = v
                        stack.add(u)
                when adj is UnDirectedGraph:
                    for (u, _) in adj.to_and_cost(v): visit(u)
                else:
                    for u in adj[v]: visit(u)
        result = initLCAFromParent(parent, if forest: n else: root)

    proc initLCA*(g: UnDirectedGraph or DirectedGraph, root: int): LowestCommonAncestor =
        ## 辺の向きと重みを無視すると木になるgから構築する。時間・空間O(N + M)、木ではO(N)
        when g is UnDirectedGraph:
            fromAdj(g, root, false)
        else:
            fromAdj(undirectedAdj(g), root, false)

    proc initLCA*(adj: openArray[seq[int]], root: int): LowestCommonAncestor =
        ## 木の隣接リストから辺の向きを無視して構築する。時間・空間O(N + M)、木ではO(N)
        fromAdj(undirectedAdj(adj), root, false)

    proc initLCAFromForest*(g: UnDirectedGraph or DirectedGraph): LowestCommonAncestor =
        ## 森に根Nを追加し、各成分の最小番号の頂点と結ぶ。辺の向きと重みは無視する。O(N + M)
        when g is UnDirectedGraph:
            fromAdj(g, g.len, true)
        else:
            fromAdj(undirectedAdj(g), g.len, true)

    proc initLCAFromForest*(adj: openArray[seq[int]]): LowestCommonAncestor =
        ## 森の隣接リストの向きを無視し、根Nを追加して各成分の最小頂点と結ぶ。O(N + M)
        fromAdj(undirectedAdj(adj), adj.len, true)

    proc numVertices*(tree: LowestCommonAncestor): int =
        ## 頂点数を返す。森の場合は追加した根を含む。O(1)
        tree.parents.len

    proc parentOf*(tree: LowestCommonAncestor, v: int): int =
        ## 頂点vの親を返す。根の場合は-1を返す。O(1)
        tree.parents[v].int

    proc depth*(tree: LowestCommonAncestor, v: int): int =
        ## 根から頂点vまでの辺数を返す。O(1)
        assert 0 <= v and v < tree.n, "頂点番号が範囲外です"
        if tree.kind == 1: v
        elif tree.kind == 2: int(v != tree.root)
        else: tree.data[3 * v + 2].int

    {.push boundChecks: off, overflowChecks: off.}
    proc lcaInsideBranch(tree: LowestCommonAncestor, u, v: int): int {.noinline.} =
        ## 同じ接点を持つ頂点間のLCAを、縦パスのビット演算で返す。O(1)
        let a = tree.dataPtr[3 * u]
        let b = tree.dataPtr[3 * v]
        var x = u
        var y = v
        if a != b:
            let common = tree.dataPtr[3 * u + 1] and tree.dataPtr[3 * v + 1] and (high(uint32) shl fastLog2(a xor b))
            let lowA = tree.dataPtr[3 * u + 1] xor common
            if lowA != 0:
                let k = fastLog2(lowA)
                x = tree.headPtr[(a and (high(uint32) shl k)) or (1'u32 shl k)].int
            let lowB = tree.dataPtr[3 * v + 1] xor common
            if lowB != 0:
                let k = fastLog2(lowB)
                y = tree.headPtr[(b and (high(uint32) shl k)) or (1'u32 shl k)].int
        if tree.ordered: min(x, y)
        elif tree.dataPtr[3 * x + 2] <= tree.dataPtr[3 * y + 2]: x
        else: y

    proc lca*(tree: LowestCommonAncestor, u, v: int): int {.inline.} =
        ## 頂点uとvの最小共通祖先を返す。O(1)
        assert 0 <= u and u < tree.n and 0 <= v and v < tree.n, "頂点番号が範囲外です"
        if tree.kind != 0:
            if tree.kind == 3:
                let a = tree.pathPtr[u].int
                let b = tree.pathPtr[v].int
                if a != b:
                    if tree.ordered: return min(a, b)
                    return (if tree.dataPtr[3 * a + 2] <= tree.dataPtr[3 * b + 2]: a else: b)
            elif tree.kind == 1:
                return min(u, v)
            else:
                return (if u == v: u else: tree.root)
        let branchA = tree.branchPtr[u].int
        let branchB = tree.branchPtr[v].int
        if branchA != branchB: return tree.prefixPtr[branchA * 64 + branchB].int
        tree.lcaInsideBranch(u, v)
    {.pop.}

    proc dist*(tree: LowestCommonAncestor, u, v: int): int =
        ## 頂点uとvを結ぶパスの辺数を返す。O(1)
        tree.depth(u) + tree.depth(v) - 2 * tree.depth(tree.lca(u, v))

    proc median*(tree: LowestCommonAncestor, x, y, z: int): int =
        ## 根をxとしたときのyとzの最小共通祖先を返す。O(1)
        tree.lca(x, y) xor tree.lca(y, z) xor tree.lca(x, z)
