when not declared CPLIB_UTILS_COUNT_SET_BITS:
    const CPLIB_UTILS_COUNT_SET_BITS* = 1

    proc count_set_bits*(n: uint64, bit: int): uint64 =
        ## 閉区間[0, n]で、0始まりのbit番目が1である整数の個数を返す。時間・追加領域O(1)。
        ## nはuint64全域、bitは0..63に対応し、範囲外のbitはValueError。
        ## bit < 63では長さ2^(bit+1)の完全な周期を数え、最後の周期の1の部分を加える。
        ## bit = 63ではnを周期長で割った商は0。n+1や64bitシフトを使わず、答は最大2^63。
        if bit < 0 or bit > 63:
            raise newException(ValueError, "bitは0..63である必要があります")
        let half = 1u64 shl bit
        if bit < 63:
            result = (n shr (bit + 1)) shl bit
        if (n and half) != 0:
            result += (n and (half - 1)) + 1
