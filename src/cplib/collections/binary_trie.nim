when not declared CPLIB_COLLECTIONS_BINARY_TRIE:
    const CPLIB_COLLECTION_BINARY_TRIE* = 1
    type BinaryTrieNode = ref object
        child : array[2,BinaryTrieNode]
        value : int
    type BinaryTrie = object
        root : BinaryTrieNode
        h: int


    proc initBineryTrie*(h:int):BinaryTrie=
        return BinaryTrie(root:BinaryTrieNode(),h:h)

    proc add*(self:BinaryTrie,x:int,v:int=1)=
        var now = self.root
        now.value += v
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.child[0].isNil():
                    now.child[0] = BinaryTrieNode()
                now = now.child[0]
            else:
                if now.child[1].isNil():
                    now.child[1] = BinaryTrieNode()
                now = now.child[1]
            now.value += v

    proc del*(self:BinaryTrie,x:int,v:int=1)=
        var now = self.root
        now.value -= v
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.child[0].isNil():
                    now.child[0] = BinaryTrieNode()
                now = now.child[0]
            else:
                if now.child[1].isNil():
                    now.child[1] = BinaryTrieNode()
                now = now.child[1]
            now.value -= v

    proc count*(self:BinaryTrie,x:int):int=
        var now = self.root
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.child[0].isNil():
                    return 0
                now = now.child[0]
            else:
                if now.child[1].isNil():
                    return 0
                now = now.child[1]
        return now.value

    proc get_kth*(self:BinaryTrie,k:int,xor_value:int=0):int=
        ## 存在するならば値を返す
        ## しないならば-1を返す
        var now = self.root
        if now.value <= k:
            return -1
        var cnt = 0
        
        for i in countdown(self.h-1,0,1):
            if now.child[0].isNil():
                now = now.child[1]
                result = (result shl 1) or 1
            elif now.child[1].isNil():
                now = now.child[0]
                result = (result shl 1)
            else:
                if (xor_value and (1 shl i)) == 0:
                    if cnt + now.child[0].value > k:
                        now = now.child[0]
                        result = (result shl 1)
                    else:
                        cnt += now.child[0].value
                        now = now.child[1]
                        result = (result shl 1) or 1
                else:
                    if cnt + now.child[1].value > k:
                        now = now.child[1]
                        result = (result shl 1) or 1
                    else:
                        cnt += now.child[1].value
                        now = now.child[0]
                        result = (result shl 1) 

    proc `$`*(self:BinaryTrie):string=
        var S : seq[int]
        proc dfs_node(self:BinaryTrieNode,now:int)=
            if not self.child[0].isNil():
                dfs_node(self.child[0],(now shl 1))
            if not self.child[1].isNil():
                dfs_node(self.child[1],(now shl 1) + 1)
            if self.child[0].isNil() and self.child[1].isNil():
                if self.value != 0:
                    S.add(now)
        dfs_node(self.root,0)
        return $S