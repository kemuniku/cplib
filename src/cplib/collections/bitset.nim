when not declared CPLIB_COLLECTIONS_BITSET:
    const CPLIB_COLLECTIONS_BITSET* = 1
    import bitops

    const WordBits = 64

    type BitSet* {.byref.} = object
        bits: seq[uint]
        size: int

    proc varor(x: var uint, y: uint) {.importcpp: "# |= #".}
    proc varand(x: var uint, y: uint) {.importcpp: "# &= #".}
    proc varxor(x: var uint, y: uint) {.importcpp: "# ^= #".}

    proc initBitSet*(N: int): BitSet =
        if N < 0:
            raise newException(ValueError, "BitSet size must be non-negative")
        result.size = N
        result.bits = newSeq[uint]((N + WordBits - 1) div WordBits)

    proc initBitSet*(v: openArray[bool], N: int): BitSet =
        if len(v) > N:
            raise newException(ValueError, "initial value is longer than BitSet size")
        result = initBitSet(N)
        for i in 0..<len(v):
            if v[i]:
                result.bits[i shr 6].varor(1u shl (i and 63))

    proc initBitSet*(v: openArray[bool]): BitSet =
        result = initBitSet(v, len(v))

    proc initBitSetFromIndexes*(indexes: openArray[int], N: int): BitSet =
        result = initBitSet(N)
        for i in indexes:
            if i < 0 or i >= N:
                raise newException(IndexDefect, "BitSet index out of bounds")
            result.bits[i shr 6].varor(1u shl (i and 63))

    proc len*(bitset: BitSet): int {.inline.} =
        bitset.size

    proc checkSameSize(x, y: BitSet) {.inline.} =
        if x.size != y.size:
            raise newException(ValueError, "BitSet sizes must match")

    proc checkIndex(bitset: BitSet, idx: Natural) {.inline.} =
        if idx >= bitset.size:
            raise newException(IndexDefect, "BitSet index out of bounds")

    proc trim(bitset: var BitSet) {.inline.} =
        let mod64 = bitset.size and 63
        if mod64 != 0:
            bitset.bits[^1].varand((1u shl mod64) - 1)

    proc `&`*(x, y: BitSet): BitSet =
        checkSameSize(x, y)
        result = initBitSet(x.size)
        for i in 0..<len(result.bits):
            result.bits[i] = x.bits[i] and y.bits[i]

    proc `&=`*(x: var BitSet, y: BitSet) =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            x.bits[i].varand(y.bits[i])

    proc `|`*(x, y: BitSet): BitSet =
        checkSameSize(x, y)
        result = initBitSet(x.size)
        for i in 0..<len(result.bits):
            result.bits[i] = x.bits[i] or y.bits[i]

    proc `|=`*(x: var BitSet, y: BitSet) =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            x.bits[i].varor(y.bits[i])

    proc `^`*(x, y: BitSet): BitSet =
        checkSameSize(x, y)
        result = initBitSet(x.size)
        for i in 0..<len(result.bits):
            result.bits[i] = x.bits[i] xor y.bits[i]

    proc `^=`*(x: var BitSet, y: BitSet) =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            x.bits[i].varxor(y.bits[i])

    proc `>>`*(bitset: BitSet, x: int): BitSet =
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x >= bitset.size:
            return
        let wordShift = x shr 6
        let bitShift = x and 63
        for dst in 0..<(len(bitset.bits) - wordShift):
            let src = dst + wordShift
            result.bits[dst] = bitset.bits[src] shr bitShift
            if bitShift != 0 and src + 1 < len(bitset.bits):
                result.bits[dst].varor(bitset.bits[src + 1] shl (WordBits - bitShift))

    proc `<<`*(bitset: BitSet, x: int): BitSet =
        if x < 0:
            raise newException(ValueError, "shift count must be non-negative")
        result = initBitSet(bitset.size)
        if x >= bitset.size:
            return
        let wordShift = x shr 6
        let bitShift = x and 63
        for dst in countdown(len(bitset.bits) - 1, wordShift):
            let src = dst - wordShift
            result.bits[dst] = bitset.bits[src] shl bitShift
            if bitShift != 0 and src > 0:
                result.bits[dst].varor(bitset.bits[src - 1] shr (WordBits - bitShift))
        result.trim()

    proc andpopcount*(x, y: BitSet): int =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            result += (x.bits[i] and y.bits[i]).popcount()

    proc orpopcount*(x, y: BitSet): int =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            result += (x.bits[i] or y.bits[i]).popcount()

    proc xorpopcount*(x, y: BitSet): int =
        checkSameSize(x, y)
        for i in 0..<len(x.bits):
            result += (x.bits[i] xor y.bits[i]).popcount()

    proc `~`*(x: BitSet): BitSet =
        result = initBitSet(x.size)
        for i in 0..<len(x.bits):
            result.bits[i] = bitnot(x.bits[i])
        result.trim()

    proc popcount*(x: BitSet): int =
        for i in 0..<len(x.bits):
            result += x.bits[i].popcount()

    iterator items*(bitset: BitSet): int =
        for wordIndex in 0..<len(bitset.bits):
            var word = bitset.bits[wordIndex]
            while word != 0:
                let bitIndex = word.countTrailingZeroBits()
                yield wordIndex * WordBits + bitIndex
                word = word and (word - 1)

    proc lowestBit*(bitset: BitSet): int =
        for wordIndex in 0..<len(bitset.bits):
            if bitset.bits[wordIndex] != 0:
                return wordIndex * WordBits + bitset.bits[wordIndex].countTrailingZeroBits()
        -1

    proc `[]`*(bitset: BitSet, idx: Natural): bool =
        bitset.checkIndex(idx)
        bitset.bits[idx shr 6].testBit(idx and 63)

    proc `[]=`*(bitset: var BitSet, idx: Natural, x: bool) =
        bitset.checkIndex(idx)
        if x:
            bitset.bits[idx shr 6].setBit(idx and 63)
        else:
            bitset.bits[idx shr 6].clearBit(idx and 63)

    proc `[]=`*(bitset: var BitSet, idx: Natural, x: int) =
        if x == 1:
            bitset[idx] = true
        elif x == 0:
            bitset[idx] = false

    proc `$`*(bitset: BitSet): string =
        result = newString(bitset.size)
        for i in 0..<bitset.size:
            result[bitset.size - i - 1] = if bitset[i]: '1' else: '0'
