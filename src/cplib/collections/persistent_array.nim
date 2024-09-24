when not declared CPLIB_COLLECTIONS_PERSISTENT_ARRAY:
    const CPLIB_COLLECTIONS_PERSISTENT_ARRAY* = 1
    import bitops

    type PersistentArrayNode*[shift:static int,T] {.acyclic.} = ref object
        arr :seq[PersistentArrayNode[shift,T]]
        value: T

    type PersistentArray*[shift:static int,T] = ref object
        size : int
        root : PersistentArrayNode[shift,T]
        h:int

    proc initPersistentArray*[T](v:seq[T],shift:static int = 5):PersistentArray[shift,T] =
        var v = v
        var bitsize = fastLog2(len(v))+1
        var h = (bitsize+shift-1) div shift
        result = PersistentArray[shift,T]()
        result.size = len(v)
        result.root = PersistentArrayNode[shift,T]()
        result.h = h
        proc dfs[shift,T](node:PersistentArrayNode[shift,T],now:int,depth:int):bool=
            if depth == h:
                if now < len(v):
                    node.value = v[now]
                else:
                    return false
            else:
                for i in 0..<(1 shl shift):
                    node.arr.add PersistentArrayNode[shift,T]()
                    if not dfs(node.arr[i],(now shl shift) or i,depth+1):
                        return false
            return true
        discard dfs[shift,T](result.root,0,0)


    proc toseq*[shift,T](PA:PersistentArray[shift,T]):seq[T]=
        var PA = PA
        var v : seq[T]
        proc dfs[shift,T](node:PersistentArrayNode[shift,T],now:int,depth:int):bool=
            if depth == PA.h:
                if now < PA.size:
                    v.add node.value
                else:
                    return false
            else:
                for i in 0..<(1 shl shift):
                    if not dfs(node.arr[i],(now shl shift) or i,depth+1):
                        return false
            return true
        discard dfs(PA.root,0,0)
        return v

    proc `[]`*[shift,T](PA:PersistentArray[shift,T],index:Natural):T=
        assert index in 0..<PA.size
        var idx = index
        var indexs = newseq[int](PA.h)
        for i in countdown(PA.h-1,0,1):
            indexs[i] = idx and ((1 shl shift)-1)
            idx = idx shr shift
        var now = PA.root
        for i in 0..<PA.h:
            now = now.arr[indexs[i]]
        return now.value

    proc change_value*[shift,T](PA:PersistentArray[shift,T],index:Natural,value:T):PersistentArray[shift,T]=
        assert index in 0..<PA.size
        var idx = index
        var indexs = newseq[int](PA.h)
        for i in countdown(PA.h-1,0,1):
            indexs[i] = idx and ((1 shl shift)-1)
            idx = idx shr shift
        var now = PA.root
        var stack : seq[PersistentArrayNode[shift,T]]
        for i in 0..<PA.h:
            stack.add(now)
            now = now.arr[indexs[i]]
        now = PersistentArrayNode[shift,T](value:value)
        for i in countdown(PA.h-1,0,1):
            var tmp = PersistentArrayNode[shift,T](arr:stack[i].arr)
            tmp.arr[indexs[i]] = now
            now = tmp
        return PersistentArray[shift,T](root:now,size:PA.size,h:PA.h)
