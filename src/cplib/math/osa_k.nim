when not declared CPLIB_MATH_OSAK:
    import algorithm,tables
    import cplib/str/run_length_encode
    const CPLIB_MATH_OSAK* = 1

    type PrimeFactorTable = ref object
        table:seq[int]
    
    proc initPrimeFactorTableLinear(maxn:int):PrimeFactorTable =
        ## 最大素因数のテーブルを線形篩でO(maxn)で構築する。
        var table = newseq[int](maxn+1)
        var primes = newSeqOfCap[int](maxn div 24)
        for i in 2..maxn div 2:
            if table[i] == 0:
                table[i] = i
                primes.add(i)
            let limit = maxn div i
            for p in primes:
                if p > limit:
                    break
                # pはiの最小素因数以下なので、最大素因数は変わらない。
                table[i*p] = table[i]
                if i mod p == 0:
                    break
        for i in maxn div 2+1..maxn:
            if table[i] == 0:
                table[i] = i
        return PrimeFactorTable(table:move(table))

    proc initPrimeFactorTable*(maxn:int):PrimeFactorTable =
        ## maxn以下の最大素因数のテーブルを構築する。大きな範囲では線形篩を使う。
        if maxn >= 3000000:
            return initPrimeFactorTableLinear(maxn)
        var table = newseq[int](maxn+1)
        for i in 2..maxn:
            if table[i] == 0:
                for j in countup(i,maxn,i):
                    table[j] = i
        return PrimeFactorTable(table:move(table))

    proc primefactor*(table:PrimeFactorTable,x:int):seq[int]=
        ## xの素因数を昇順に返す。O(log x)。
        assert len(table.table) > x, "xは篩のテーブルの範囲内である必要があります"
        assert x >= 1, "xは1以上である必要があります"
        if x > 1 and table.table[x] == x:
            return @[x]
        var x = x
        # 正のintの素因数の個数はbit幅未満。
        var factors {.noInit.}:array[sizeof(int)*8,int]
        var count = 0
        while x != 1:
            factors[count] = table.table[x]
            x = x div factors[count]
            inc count
        if count > 0:
            result = newSeq[int](count)
            for i in 0..<count:
                result[i] = factors[i]
        result.reverse()
    
    proc primefactor_table*(table:PrimeFactorTable,x:int):Table[int,int]=
        for p in primefactor(table,x):
            if p in result:
                result[p] += 1
            else:
                result[p] = 1
    
    proc primefactor_tuple*(table:PrimeFactorTable,x:int):seq[(int,int)]=
        result = primefactor(table,x).run_length_encode()
