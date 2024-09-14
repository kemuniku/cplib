when not declared CPLIB_COLLECTIONS_BINARY_TRIE:
    const CPLIB_COLLECTION_BINARY_TRIE* = 1
    type BinaryTrieNode = ref object
        zero:BinaryTrieNode
        one:BinaryTrieNode
        value : int
    type BinaryTrie = object
        root : BinaryTrieNode
        h: int


    proc initBineryTrie*(h:int):BinaryTrie=
        return BinaryTrie(root:BinaryTrieNode(),h:h)

    proc incl*(self:BinaryTrie,x:int,v:int=1)=
        var now = self.root
        now.value += v
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    now.zero = BinaryTrieNode()
                now = now.zero
            else:
                if now.one.isNil():
                    now.one = BinaryTrieNode()
                now = now.one
            now.value += v

    proc excl*(self:BinaryTrie,x:int,v:int=1)=
        var now = self.root
        now.value -= v
        assert now.value >= 0
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    now.zero = BinaryTrieNode()
                now = now.zero
            else:
                if now.one.isNil():
                    now.one = BinaryTrieNode()
                now = now.one
            now.value -= v
            assert now.value >= 0

    proc count*(self:BinaryTrie,x:int):int=
        var now = self.root
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    return 0
                now = now.zero
            else:
                if now.one.isNil():
                    return 0
                now = now.one
        return now.value

    proc contains*(self:BinaryTrie,x:int):bool=
        return self.count(x) != 0

    proc get_kth*(self:BinaryTrie,k:int,xor_value:int=0):int=
        ## 存在するならば値を返す
        ## しないならば-1を返す
        var now = self.root
        if now.value <= k:
            return -1
        var cnt = 0
        
        for i in countdown(self.h-1,0,1):
            if now.zero.isNil():
                now = now.one
                result = (result shl 1) or 1
            elif now.one.isNil():
                now = now.zero
                result = (result shl 1)
            else:
                if (xor_value and (1 shl i)) == 0:
                    if cnt + now.zero.value > k:
                        now = now.zero
                        result = (result shl 1)
                    else:
                        cnt += now.zero.value
                        now = now.one
                        result = (result shl 1) or 1
                else:
                    if cnt + now.one.value > k:
                        now = now.one
                        result = (result shl 1) or 1
                    else:
                        cnt += now.one.value
                        now = now.zero
                        result = (result shl 1) 
    
    proc `[]`*(self:BinaryTrie,idx:int):int=
        return self.get_kth(idx)

    proc `$`*(self:BinaryTrie):string=
        var S : seq[int]
        proc dfs_node(self:BinaryTrieNode,now:int)=
            if not self.zero.isNil():
                dfs_node(self.zero,(now shl 1))
            if not self.one.isNil():
                dfs_node(self.one,(now shl 1) + 1)
            if self.zero.isNil() and self.one.isNil():
                if self.value != 0:
                    S.add(now)
        dfs_node(self.root,0)
        return $S