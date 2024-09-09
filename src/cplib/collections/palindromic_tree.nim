when not declared CPLIB_COLLECTIONS_PALINDROMIC_TREE:
    const CPLIB_COLLECTIONS_PALINDROMIC_TREE* = 1
    import sequtils, algorithm
    type PalindromicTreeNode* = object
        link*: seq[ref PalindromicTreeNode]
        suffix_link*: ref PalindromicTreeNode
        len, count, id: int

    type PalindromicTree* = object
        amax: int
        nodes*: seq[ref PalindromicTreeNode]

    proc len*(node: PalindromicTreeNode): int = node.len
    proc count*(node: PalindromicTreeNode): int = node.count
    proc id*(node: PalindromicTreeNode): int = node.id
    
    proc newPalindromicTreeNode(pt: var PalindromicTree, amax, len: int): ref PalindromicTreeNode =
        result = new PalindromicTreeNode
        result[].link = newSeq[ref PalindromicTreeNode](amax)
        result[].suffix_link = nil
        result[].len = len
        result[].count = 0
        result[].id = pt.nodes.len
        pt.nodes.add(result)

    proc init(amax: int): PalindromicTree =
        discard result.newPalindromicTreeNode(amax, -1)
        discard result.newPalindromicTreeNode(amax, 0)
        result.amax = amax
        result.nodes[1][].suffix_link = result.nodes[0]


    proc initPalindromicTree*(a: seq[int], amax: int = -1): PalindromicTree =
        var amax = amax
        if amax < 0: amax = a.max
        result = init(amax)
        proc find_longest(pos: int, node: ref PalindromicTreeNode): ref PalindromicTreeNode =
            var ln = pos - node[].len - 1
            if ln >= 0 and a[ln] == a[pos]:
                return node
            return find_longest(pos, node[].suffix_link)
        var current_node = result.nodes[0]
        for i in 0..<a.len:
            current_node = find_longest(i, current_node)
            if current_node[].link[a[i]] == nil:
                current_node[].link[a[i]] = result.newPalindromicTreeNode(amax, current_node[].len + 2)
            if current_node == result.nodes[0]:
                current_node[].link[a[i]][].suffix_link = result.nodes[1]
            else:
                current_node[].link[a[i]][].suffix_link = find_longest(i, current_node[].suffix_link)[].link[a[i]]
            current_node = current_node[].link[a[i]]
            current_node[].count += 1

    proc initPalindromicTree*(s: string, c: char = 'a'): PalindromicTree =
        return initPalindromicTree(s.mapIt(int(it) - int(c)), 26)

    proc get_palindrome*(pt: PalindromicTree, node: ref PalindromicTreeNode): seq[int] =
        if node == pt.nodes[0] or node == pt.nodes[1]: return newSeq[int](0)
        var ans = newSeq[int](0)
        proc dfs(x: ref PalindromicTreeNode): bool =
            if x == node: return true
            for i in 0..<pt.amax:
                if x[].link[i] == nil: continue
                if dfs(x[].link[i]):
                    ans.add(i)
                    return true
            return false
        discard dfs(pt.nodes[0])
        discard dfs(pt.nodes[1])
        for i in ans.len..<node[].len:
            ans.add(ans[node[].len-1-i])
        return ans

    proc update_count*(pt: PalindromicTree) =
        for node in pt.nodes[1..<pt.nodes.len].reversed:
            node[].suffix_link[].count += node[].count
