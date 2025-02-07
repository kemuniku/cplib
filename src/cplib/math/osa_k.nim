when not declared CPLIB_MATH_OSAK:
    import algorithm,tables
    import cplib/str/run_length_encode
    const CPLIB_MATH_OSAK* = 1

    type PrimeFactorTable = ref object
        table:seq[int]
    
    proc initPrimeFactorTable*(maxn:int):PrimeFactorTable =
        var table = newseq[int](maxn+1)
        for i in 2..maxn:
            if table[i] == 0:
                for j in countup(i,maxn,i):
                    table[j] = i
        return PrimeFactorTable(table:table)

    proc primefactor*(table:PrimeFactorTable,x:int):seq[int]=
        assert len(table.table) > x
        assert x >= 1
        var x = x
        while x != 1:
            result.add(table.table[x])
            x = x div table.table[x]
        result.reverse()
    
    proc primefactor_table*(table:PrimeFactorTable,x:int):Table[int,int]=
        for p in primefactor(table,x):
            if p in result:
                result[p] += 1
            else:
                result[p] = 1
    
    proc primefactor_tuple*(table:PrimeFactorTable,x:int):seq[(int,int)]=
        result = primefactor(table,x).run_length_encode()


