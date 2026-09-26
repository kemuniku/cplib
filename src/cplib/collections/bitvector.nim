when not declared CPLIB_COLLECTIONS_BITVECTOR:
    const CPLIB_COLLECTIONS_BITVECTOR* = 1
    import bitops

    when (defined(amd64) or defined(i386)) and (defined(gcc) or defined(clang)):
        # x86ではPOPCNT対応CPUを前提に、popcountをCPU命令にする。
        {.passC: "-mpopcnt".}

    # releaseでもdebug指定時は境界・オーバーフローチェックを残す。
    when defined(release) and not defined(debug):
        {.push boundChecks: off, overflowChecks: off.}

    type BitVector* = object
        bits : seq[uint64]
        csum : seq[int]

    proc newBitVector*(length:int):BitVector=
        result.bits = newSeq[uint64]((length+63) div 64 + 1)
        result.csum = newSeq[int](((length+63) div 64)+1)

    proc set*(self:var BitVector,idx:int) {.inline.} =
        ## buildする前にだけ呼ぶ
        self.bits[idx shr 6].setBit(idx and 63)

    proc setWord*(self:var BitVector,idx:int,value:uint64) {.inline.} =
        ## idx番目の64bitワードを O(1) で上書きする。長さ外のビットは0にし、設定後にbuildする。
        self.bits[idx] = value

    proc build*(self:var BitVector)=
        for i in 0..<(len(self.bits)-1):
            self.csum[i+1] = self.csum[i] + popcount(self.bits[i])

    proc access*(self:var BitVector,idx:int):bool=
        self.bits[idx shr 6].testBit(idx and 63)

    proc `[]`*(self:var BitVector,idx:int):bool=
        self.bits[idx shr 6].testBit(idx and 63)
    
    proc rank*(self:var BitVector,idx:int):int {.inline.} =
        ## [0,idx) の1の個数を O(1) で返す。build後に呼ぶ。
        let block_index = idx shr 6
        return self.csum[block_index] + popcount(self.bits[block_index] and ((1'u64 shl (idx and 63)) - 1))

    when defined(release) and not defined(debug):
        {.pop.}
