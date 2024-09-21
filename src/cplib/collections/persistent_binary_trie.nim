## --mm:arc推奨かも。
when not declared CPLIB_COLLECTIONS_PERSITENT_BINARY_TRIE:
    const CPLIB_COLLECTION_PERSITENT_BINARY_TRIE* = 1
    type PersistentBinaryTrieNode = ref object
        zero:PersistentBinaryTrieNode
        one:PersistentBinaryTrieNode
        value : int
    type PersistentBinaryTrie* = object
        root : PersistentBinaryTrieNode
        h: int

    proc initPersistentBineryTrie*(h:int):PersistentBinaryTrie=
        return PersistentBinaryTrie(root:PersistentBinaryTrieNode(),h:h)

    proc incl*(self:PersistentBinaryTrie,x:Natural,v:int=1):PersistentBinaryTrie=
        var now = PersistentBinaryTrieNode(zero:self.root.zero,one:self.root.one,value:self.root.value+v)
        result.root = now
        result.h = self.h
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    now.zero = PersistentBinaryTrieNode(value:v)
                else:
                    now.zero = PersistentBinaryTrieNode(zero:now.zero.zero,one:now.zero.one,value:now.zero.value+v)
                now = now.zero
            else:
                if now.one.isNil():
                    now.one = PersistentBinaryTrieNode(value:v)
                else:
                    now.one = PersistentBinaryTrieNode(zero:now.one.zero,one:now.one.one,value:now.one.value+v)
                now = now.one

    proc excl*(self:PersistentBinaryTrie,x:Natural,v:int=1):PersistentBinaryTrie=
        var now = PersistentBinaryTrieNode(zero:self.root.zero,one:self.root.one,value:self.root.value-v)
        result.root = now
        result.h = self.h
        assert now.value >= 0
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                assert not now.zero.isNil()
                now.zero = PersistentBinaryTrieNode(zero:now.zero.zero,one:now.zero.one,value:now.zero.value-v)
                now = now.zero
            else:
                assert not now.one.isNil()
                now.one = PersistentBinaryTrieNode(zero:now.one.zero,one:now.one.one,value:now.one.value-v)
                now = now.one
            assert now.value >= 0
    
    proc count*(self:PersistentBinaryTrie,x:Natural):int=
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

    proc set_value*(self:PersistentBinaryTrie,x:Natural,v:int):PersistentBinaryTrie=
        var cnt = self.count(x)
        return self.incl(x,v-cnt)

    proc contains*(self:PersistentBinaryTrie,x:Natural):bool=
        return self.count(x) != 0

    proc get_kth*(self:PersistentBinaryTrie,k:Natural,xor_value:int=0):int=
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
    
    proc upperBound*(self:PersistentBinaryTrie,x:Natural):int=
        ## x以下の要素数
        var now = self.root
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    return result
                now = now.zero
            else:
                if not now.zero.isNil():
                    result += now.zero.value
                if now.one.isNil():
                    return result
                now = now.one
        result += now.value
    proc lowerBound*(self:PersistentBinaryTrie,x:Natural):int=
        ## x未満の要素数
        var now = self.root
        for i in countdown(self.h-1,0,1):
            if (x and (1 shl i)) == 0:
                if now.zero.isNil():
                    return result
                now = now.zero
            else:
                if not now.zero.isNil():
                    result += now.zero.value
                if now.one.isNil():
                    return result
                now = now.one
    proc `[]`*(self:PersistentBinaryTrie,idx:Natural):int=
        return self.get_kth(idx)

    proc RLE*(self:PersistentBinaryTrie):seq[(int,int)]=
        var S : seq[(int,int)]
        proc dfs_node(self:PersistentBinaryTrieNode,now:int)=
            if not self.zero.isNil():
                dfs_node(self.zero,(now shl 1))
            if not self.one.isNil():
                dfs_node(self.one,(now shl 1) + 1)
            if self.zero.isNil() and self.one.isNil():
                if self.value != 0:
                    S.add((now,self.value))
        dfs_node(self.root,0)
        return S
    proc `$`*(self:PersistentBinaryTrie):string=
        return $(self.RLE())

