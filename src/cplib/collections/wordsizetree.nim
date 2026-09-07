## 計算量ではNを入力配列長、Uを容量2^24とします。木の段数と整数のビット幅は固定です。
when not declared CPLIB_COLLECTIONS_WORD_SIZE_TREE:
    const CPLIB_COLLECTIONS_WORD_SIZE_TREE* = 1
    import bitops
    type WordsizeTree = object
        A0 : uint
        A1 : array[64,uint]
        A2 : array[64*64,uint]
        A3 : array[64*64*64,uint]

    proc initWordsizeTree*():WordsizeTree=
        ## 空のビット集合木を作成します。時間計算量: O(U/64)、戻り値の空間: O(U/64)（全領域のゼロ初期化を含む）。
        discard

    proc initWordsizeTree*(v:openArray[bool]):WordsizeTree=
        ## 真偽値配列からビット集合木を作成します。時間計算量: O(N + U/64)、戻り値の空間: O(U/64)（全領域のゼロ初期化を含む）。
        # 各ビットの値による分岐を避け、64ビットずつまとめて格納します。
        for blockIndex in 0..<((len(v) + 63) shr 6):
            let start = blockIndex shl 6
            var bits = 0u
            for bit in 0..<min(64, len(v) - start):
                bits = bits or (uint(v[start + bit]) shl bit)
            result.A3[blockIndex] = bits
        for i in 0..<((len(v)+(63)) shr 6):
            if result.A3[i] != 0:result.A2[i shr 6] = result.A2[i shr 6] or (1u shl (i and(0b111111)))
        for i in 0..<((len(v)+(64*64-1)) shr 12):
            if result.A2[i] != 0:result.A1[i shr 6] = result.A1[i shr 6] or (1u shl (i and(0b111111)))
        for i in 0..<((len(v)+(64*64*64-1)) shr 18):
            if result.A1[i] != 0:result.A0 = result.A0 or (1u shl (i and(0b111111)))


    proc incl*(self:var WordsizeTree,x:int)=
        ## 要素xを追加します。 時間計算量: O(1)、追加空間: O(1)。
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
        ## 要素xが含まれているかを返します。 時間計算量: O(1)、追加空間: O(1)。
        var y = x and (0b111111)
        var x = x shr 6
        return (self.A3[x] and (1u shl y)) != 0

    proc excl*(self:var WordsizeTree,x:int)=
        ## 要素xを削除します。 時間計算量: O(1)、追加空間: O(1)。
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
        ## x以上の最小の要素を返し、存在しなければ-1を返します。 時間計算量: O(1)、追加空間: O(1)。
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
        ## x以下の最大の要素を返し、存在しなければ-1を返します。 時間計算量: O(1)、追加空間: O(1)。
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
