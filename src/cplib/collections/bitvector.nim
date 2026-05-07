when not declared CPLIB_COLLECTIONS_BITVECTOR:
    const CPLIB_COLLECTIONS_BITVECTOR* = 1
    import bitops,sequtils

    type BitVector* = object
        bits : seq[uint64]
        csum : seq[int]

    proc newBitVector*(length:int):BitVector=
        result.bits = newSeq[uint64]((length+63) div 64 + 1)
        result.csum = newSeq[int](((length+63) div 64)+1)

    proc set*(self:var BitVector,idx:int)=
        ## buildする前にだけ呼ぶ
        self.bits[idx div 64].setBit(idx mod 64)

    proc build*(self:var BitVector)=
        for i in 0..<(len(self.bits)-1):
            self.csum[i+1] = self.csum[i] + popcount(self.bits[i])

    proc access*(self:var BitVector,idx:int):bool=
        self.bits[idx div 64].testBit(idx mod 64)

    proc `[]`*(self:var BitVector,idx:int):bool=
        self.bits[idx div 64].testBit(idx mod 64)
    
    proc rank*(self:var BitVector,idx:int):int=
        return self.csum[idx div 64] + popcount(self.bits[idx div 64] and ((1u shl (idx and 63)) - 1))

