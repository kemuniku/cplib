when not declared CPLIB_COLLECTIONS_BITSET:
    const CPLIB_COLLECTIONS_BITSET* = 1
    import math,bitops
    
    type BitSet* {.byref.}= object
        bits : seq[uint]
    
    proc varor(x:var uint,y:uint) {.importcpp:"# |= #".}
    proc varand(x:var uint,y:uint) {.importcpp:"# &= #".}
    proc varxor(x:var uint,y:uint) {.importcpp:"# ^= #".}

    proc initBitSet*(v:seq[bool]):Bitset=
        result.bits = newseq[uint](ceilDiv(len(v),64))
        const mask = ((1 shl 6) - 1)
        for i in 0..<len(v):
            if v[i]:
                varor(result.bits[i shr 6],1u shl (i and mask))
    
    proc `&`*(x,y:BitSet):BitSet=
        result.bits = newseq[uint](min(len(x.bits),len(y.bits)))
        for i in 0..<len(result.bits):
            result.bits[i] = x.bits[i] and y.bits[i]
    
    proc `&=`*(x:var BitSet,y:BitSet)=
        for i in 0..<len(y.bits):
            varand(x.bits[i],y.bits[i])
        for j in len(y.bits)..<len(x.bits):
            discard x.bits.pop()
    
    proc `|`*(x,y:BitSet):BitSet=
        result.bits = newseq[uint](max(len(x.bits),len(y.bits)))
        if len(y.bits) < len(x.bits):
            for i in 0..<len(y.bits):
                result.bits[i] = x.bits[i] or y.bits[i]
            for i in len(y.bits)..<len(x.bits):
                result.bits[i] = x.bits[i]
        else:
            for i in 0..<len(x.bits):
                result.bits[i] = x.bits[i] or y.bits[i]
            for i in len(x.bits)..<len(y.bits):
                result.bits[i] = y.bits[i]
    
    proc `|=`*(x:var BitSet,y:BitSet)=
        if len(y.bits) < len(x.bits):
            for i in 0..<len(y.bits):
                varor(x.bits[i],y.bits[i])
        else:
            for i in 0..<len(x.bits):
                varor(x.bits[i],y.bits[i])
            for i in len(x.bits)..<len(y.bits):
                x.bits.add(y.bits[i])
    
    proc `^=`*(x:var BitSet,y:BitSet)=
        if len(y.bits) < len(x.bits):
            for i in 0..<len(y.bits):
                varxor(x.bits[i],y.bits[i])
        else:
            for i in 0..<len(x.bits):
                varxor(x.bits[i],y.bits[i])
            for i in len(x.bits)..<len(y.bits):
                x.bits.add(y.bits[i])
    
    proc andpopcount*(x,y:BitSet):int=
        for i in 0..<min(len(x.bits),len(y.bits)):
            result += (x.bits[i] and y.bits[i]).popcount()

    proc popcount*(x:BitSet):int=
        for i in 0..<len(x.bits):
            result += x.bits[i].popcount()
    
    proc `[]`*(bitset:BitSet,idx:Natural):bool=
        return bitset.bits[idx shr 6].testBit(idx and 63)

    proc `[]=`*(bitset:var BitSet,idx:Natural,x:bool)=
        while len(bitset.bits)-1 < idx shr 6:
            bitset.bits.add(0u)
        if x:
            bitset.bits[idx shr 6].setBit((idx and 63))
        else:
            bitset.bits[idx shr 6].clearBit((idx and 63))