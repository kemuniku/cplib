when not declared CPLIB_COLLECTIONS_WORD_SIZE_TREE:
    const CPLIB_COLLECTIONS_WORD_SIZE_TREE* = 1
    import bitops
    type WordsizeTree = object
        A0 : uint
        A1 : array[64,uint]
        A2 : array[64*64,uint]
        A3 : array[64*64*64,uint]

    proc initWordsizeTree*():WordsizeTree=
        discard

    proc initWordsizeTree*(v:seq[bool]):WordsizeTree=
        for i in 0..<len(v):
            if v[i]: result.A3[i shr 6] = result.A3[i shr 6] or (1u shl (i and(0b111111)))
        for i in 0..<((len(v)+(63)) shr 6):
            if result.A3[i] != 0:result.A2[i shr 6] = result.A2[i shr 6] or (1u shl (i and(0b111111)))
        for i in 0..<((len(v)+(64*64-1)) shr 12):
            if result.A2[i] != 0:result.A1[i shr 6] = result.A1[i shr 6] or (1u shl (i and(0b111111)))
        for i in 0..<((len(v)+(64*64*64-1)) shr 18):
            if result.A1[i] != 0:result.A0 = result.A0 or (1u shl (i and(0b111111)))


    proc incl*(self:var WordsizeTree,x:int)=
        var y = x and (0b111111)
        var x = x shr 6
        self.A3[x] = self.A3[x] or (1u shl y)
        y = x and (0b111111)
        x = x shr 6
        self.A2[x] = self.A2[x] or (1u shl y)
        y = x and (0b111111)
        x = x shr 6
        self.A1[x] = self.A1[x] or (1u shl y)
        y = x and (0b111111)
        x = x shr 6
        self.A0 = self.A0 or (1u shl y)

    proc `[]`*(self:var WordsizeTree,x:int):bool=
        var y = x and (0b111111)
        var x = x shr 6
        return (self.A3[x] and (1u shl y)) != 0

    proc excl*(self:var WordsizeTree,x:int)=
        if self[x]:
            var y = x and (0b111111)
            var x = x shr 6
            self.A3[x].clearBit(y)
            if self.A3[x] != 0:return
            y = x and (0b111111)
            x = x shr 6
            self.A2[x].clearBit(y)
            if self.A2[x] != 0:return
            y = x and (0b111111)
            x = x shr 6
            self.A1[x].clearBit(y)
            if self.A1[x] != 0:return
            y = x and (0b111111)
            x = x shr 6
            self.A0.clearBit(y)


    proc ge*(self:var WordsizeTree,x:int):int=
        ## あるbit位置より上の場所に立ってるbitを調べたい
        var y = x and (0b111111)
        var x = x shr 6
        var t = self.A3[x] and (bitnot(0u) shl y)
        if t != 0:
            return (x shl 6) or (t.firstSetBit()-1)
        
        y = (x and (0b111111))+1
        x = x shr 6
        t = self.A2[x] and (bitnot(0u) shl y)
        if y != 64 and t != 0:
            x = (x shl 6) or (t.firstSetBit()-1)
            return (x shl 6) or (self.A3[x].firstSetBit()-1)
        
        y = (x and (0b111111))+1
        x = x shr 6
        t = self.A1[x] and (bitnot(0u) shl y)
        if y != 64 and t != 0:
            x = (x shl 6) or (t.firstSetBit()-1)
            x = (x shl 6) or (self.A2[x].firstSetBit()-1)
            return (x shl 6) or (self.A3[x].firstSetBit()-1)
        y = (x and (0b111111))+1
        x = x shr 6
        t = self.A0 and (bitnot(0u) shl y)
        if y != 64 and t != 0:
            x = (t.firstSetBit()-1)
            x = (x shl 6) or (self.A1[x].firstSetBit()-1)
            x = (x shl 6) or (self.A2[x].firstSetBit()-1)
            return (x shl 6) or (self.A3[x].firstSetBit()-1)
        return -1

    proc le*(self:var WordsizeTree,x:int):int=
        ## あるbit位置より上の場所に立ってるbitを調べたい
        var y = 64-(x and (0b111111))-1
        var x = x shr 6
        var t = self.A3[x] and (bitnot(0u) shr y)
        if t != 0:
            return (x shl 6) or (t.fastLog2())
        y = 64-((x and (0b111111)))
        x = x shr 6
        t = self.A2[x] and (bitnot(0u) shr y)
        if y != 64 and t != 0:
            x = (x shl 6) or (t.fastLog2())
            return (x shl 6) or (self.A3[x].fastLog2())
        y = 64-((x and (0b111111)))
        x = x shr 6
        t = self.A1[x] and (bitnot(0u) shr y)
        if y != 64 and t != 0:
            x = (x shl 6) or (t.fastLog2())
            x = (x shl 6) or (self.A2[x].fastLog2())
            return (x shl 6) or (self.A3[x].fastLog2())
        y = 64-((x and (0b111111)))
        x = x shr 6
        t = self.A0 and (bitnot(0u) shr y)
        if y != 64 and t != 0:
            x = (t.fastLog2())
            x = (x shl 6) or (self.A1[x].fastLog2())
            x = (x shl 6) or (self.A2[x].fastLog2())
            return (x shl 6) or (self.A3[x].fastLog2())
        return -1