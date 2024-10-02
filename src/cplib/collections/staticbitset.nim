when not declared CPLIB_COLLECTIONS_STATIC_BITSET:
    const CPLIB_COLLECTIONS_STATIC_BITSET* = 1
    import math,bitops,algorithm,strutils
    
    type BitSet*[size:static int] {.byref.}= object
        bits : array[(size+63) div 64,uint]
    
    proc varor(x:var uint,y:uint) {.importcpp:"# |= #".}
    proc varand(x:var uint,y:uint) {.importcpp:"# &= #".}
    proc varxor(x:var uint,y:uint) {.importcpp:"# ^= #".}
    proc varshr(x:var uint,y:int) {.importcpp:"# >>= #".}
    proc varshl(x:var uint,y:int) {.importcpp:"# <<= #".}

    proc initBitSet*(x:static int):BitSet[x]=
        discard

    proc initBitSet*(v:seq[bool],size:static int):Bitset[size]=
        const mask = ((1 shl 6) - 1)
        for i in 0..<len(v):
            if v[i]:
                varor(result.bits[i shr 6],1u shl (i and mask))

    proc initBitSet*(v:seq[int],size:static int):Bitset[size]=
        const mask = ((1 shl 6) - 1)
        for i in v:
            varor(result.bits[i shr 6],1u shl (i and mask))
    
    proc `&`*[size](x,y:BitSet[size]):BitSet[size]=
        for i in 0..<len(result.bits):
            result.bits[i] = x.bits[i] and y.bits[i]
    
    proc `&=`*[size](x:var BitSet[size],y:BitSet[size])=
        for i in 0..<len(y.bits):
            varand(x.bits[i],y.bits[i])
    
    proc `|`*[size](x,y:BitSet[size]):BitSet[size]=
        for i in 0..<len(y.bits):
            result.bits[i] = x.bits[i] or y.bits[i]
    
    proc `|=`*[size](x:var BitSet[size],y:BitSet[size])=
        for i in 0..<len(y.bits):
            varor(x.bits[i],y.bits[i])
    
    proc `^`*[size](x,y:BitSet[size]):BitSet[size]=
        for i in 0..<len(y.bits):
            result.bits[i] = x.bits[i] xor y.bits[i]
    
    proc `^=`*[size](x:var BitSet[size],y:BitSet[size])=
        for i in 0..<len(y.bits):
            varxor(x.bits[i],y.bits[i])
    
    proc `>>`*[size](bitset:BitSet[size],x:int):BitSet[size]=
        if x >= size:
            return
        for i in 0..<len(bitset.bits):
            if i+(x div 64) < len(result.bits):
                result.bits[i] = bitset.bits[i+(x div 64)]
        var tmp = 0u
        var mod64 = x mod 64
        if mod64 != 0:
            for i in countdown(len(bitset.bits)-1,0,1):
                var msk = result.bits[i] and ((1u shl mod64) - 1)
                result.bits[i].varshr(mod64)
                result.bits[i].varor(tmp shl (64-mod64))
                tmp = msk
    
    proc `<<`*[size](bitset:BitSet[size],x:int):BitSet[size]=
        if x >= size:
            return
        for i in 0..<len(bitset.bits):
            if i-(x div 64) >= 0:
                result.bits[i] = bitset.bits[i-(x div 64)]
        var tmp = 0u
        var mod64 = x mod 64
        if mod64 != 0:
            for i in 0..<len(bitset.bits):
                var msk = result.bits[i] and bitnot((1u shl mod64) - 1)
                result.bits[i].varshl(mod64)
                result.bits[i].varor(tmp shr (64-mod64))
                tmp = msk
    
    proc andpopcount*[size](x,y:BitSet[size]):int=
        for i in 0..<min(len(x.bits),len(y.bits)):
            result += (x.bits[i] and y.bits[i]).popcount()
    
    proc orpopcount*[size](x,y:BitSet[size]):int=
        for i in 0..<min(len(x.bits),len(y.bits)):
            result += (x.bits[i] or y.bits[i]).popcount()
    
    proc xorpopcount*[size](x,y:BitSet[size]):int=
        for i in 0..<min(len(x.bits),len(y.bits)):
            result += (x.bits[i] xor y.bits[i]).popcount()
    
    proc `~`*[size](x:BitSet[size]):BitSet[size]=
        for i in 0..<len(x.bits)-1:
            result.bits[i] = bitnot(x.bits[i])
        var mod64 = size mod 64
        if mod64 == 0:
            result.bits[^1] = bitnot(x.bits[^1])
        else:
            result.bits[^1] = x.bits[^1] xor ((1u shl mod64) - 1)
    proc popcount*[size](x:BitSet[size]):int=
        for i in 0..<len(x.bits):
            result += x.bits[i].popcount()
    
    proc `[]`*[size](bitset:BitSet[size],idx:Natural):bool=
        return bitset.bits[idx shr 6].testBit(idx and 63)

    proc `[]=`*[size](bitset:var BitSet[size],idx:Natural,x:bool)=
        if x:
            bitset.bits[idx shr 6].setBit((idx and 63))
        else:
            bitset.bits[idx shr 6].clearBit((idx and 63))
    
    proc `[]=`*[size](bitset:var BitSet[size],idx:Natural,x:int)=
        if x == 1:
            bitset.bits[idx shr 6].setBit((idx and 63))
        elif x == 0:
            bitset.bits[idx shr 6].clearBit((idx and 63))
    
    proc `$`*[size](bitset:BitSet[size]):string=
        var tmp : seq[char]
        for i in 0..<size:
            if bitset[i]:
                tmp.add '1'
            else:
                tmp.add '0'
        return tmp.reversed().join("")