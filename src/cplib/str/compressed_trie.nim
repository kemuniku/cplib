when not declared CPLIB_STR_COMPRESSED_TRIE:
    import cplib/str/static_string
    import algorithm
    import cplib/graph/graph
    const CPLIB_STR_COMPRESSED_TRIE* = 1
    type CompressedTrieNode* = ref object
        parent* : CompressedTrieNode
        child* : array['a'..'z',CompressedTrieNode]
        s* : StaticString
        cnt* : int32
        subtree_sum* : int32

    proc initCompressedTrie*(S:seq[StaticString],sorted:bool=false):CompressedTrieNode=
        var S = S
        if not sorted:
            S.sort()
        var root = CompressedTrieNode(s:S[0][0..<0])
        var stack = @[root]
        for s in S:
            while not s.startsWith(stack[^1].s):
                discard stack.pop()
            var l = lcp(stack[^1].s,s)
            if l == len(s):
                stack[^1].cnt += 1
                continue
            if stack[^1].child[s[l]].isNil():
                stack[^1].child[s[l]] = CompressedTrieNode(parent:stack[^1],s:s,cnt:1,subtree_sum:1)
                stack.add(stack[^1].child[s[l]])
            else:
                var x = lcp(s,stack[^1].child[s[l]].s)
                var tmp = CompressedTrieNode(parent:stack[^1],s:s[0..<x],cnt:0,subtree_sum:0)
                stack[^1].child[s[l]].parent = tmp
                tmp.child[stack[^1].child[s[l]].s[x]] = stack[^1].child[s[l]]
                tmp.child[s[x]] = CompressedTrieNode(parent:tmp,s:s,cnt:1,subtree_sum:1)
                stack[^1].child[s[l]] = tmp
                stack.add(tmp)
                stack.add(tmp.child[s[x]])
        while len(stack) != 1:
            discard stack.pop()
        var dfs_stack = @[(root,false)]
        while len(dfs_stack) > 0:
            let (node,visited) = dfs_stack.pop()
            if visited:
                node.subtree_sum = node.cnt
                for c in 'a'..'z':
                    if not node.child[c].isNil():
                        node.subtree_sum += node.child[c].subtree_sum
            else:
                dfs_stack.add((node,true))
                for c in 'a'..'z':
                    if not node.child[c].isNil():
                        dfs_stack.add((node.child[c],false))
        return root

    proc debug_dfs(node:CompressedTrieNode,depth:int = 0)=
        echo node.s
        for c in 'a'..'z':
            if node.child[c].isNil():
                continue
            debug_dfs(node.child[c],depth+1)

    proc toGraph*(root:CompressedTrieNode):WeightedDirectedGraph[StaticString]=
        var p = @[(-1,StaticString())]
        var cnt = 1
        proc dfs(node:CompressedTrieNode,id:int)=
            for c in 'a'..'z':
                if not node.child[c].isNil():
                    cnt += 1
                    var l = lcp(node.s,node.child[c].s)
                    p.add((id,node.child[c].s[l..<len(node.child[c].s)]))
                    dfs(node.child[c],cnt-1)
        dfs(root,0)
        result = initWeightedDirectedGraph(len(p),StaticString)
        for i in 1..<len(p):
            result.add_edge(p[i][0],i,p[i][1])

    type VirtualTrieNode = ref object
        current_node* : CompressedTrieNode
        now* : StaticString

    proc get_virtualnode*(node:CompressedTrieNode):VirtualTrieNode=
        return VirtualTrieNode(current_node:node,now:node.s[0..<0])

    proc get_child*(node:VirtualTrieNode,c:char):VirtualTrieNode=
        if len(node.now) == 0:
            if node.current_node.child[c].s.len() == node.current_node.s.len() + 1:
                return VirtualTrieNode(current_node:node.current_node.child[c],now:node.current_node.s[0..<0])
            else:
                return VirtualTrieNode(current_node:node.current_node,now:node.current_node.child[c].s[node.current_node.s.len()..<(node.current_node.s.len()+1)])
            
        else:
            if node.current_node.child[node.now[0]].s.len() - node.current_node.s.len() == node.now.len() + 1:
                return VirtualTrieNode(current_node:node.current_node.child[node.now[0]],now:node.now[0..<0])
            return VirtualTrieNode(current_node:node.current_node,now:node.current_node.child[node.now[0]].s[(node.current_node.s.len())..<(node.current_node.s.len()+len(node.now)+1)])

    proc has_child*(node:VirtualTrieNode,c:char):bool=
        if len(node.now) == 0:
            return not node.current_node.child[c].isNil()
        return node.current_node.child[node.now[0]].s[len(node.current_node.s) + len(node.now)] == c

    proc get_cnt*(node:VirtualTrieNode):int=
        if node.now.len() != 0:
            return 0
        return node.current_node.cnt

    proc get_subtree_sum*(node:VirtualTrieNode):int=
        if node.now.len() == 0:
            return node.current_node.subtree_sum
        return node.current_node.child[node.now[0]].subtree_sum