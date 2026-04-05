when not declared CPLIB_STR_MANACHER:
    const CPLIB_STR_MANACHER* = 1
    import sequtils
    proc manacher*[T](s: seq[T]): seq[int] =
        result = newSeq[int](s.len)
        result[0] = 0
        var c = 0
        for i in 0..<s.len:
            var l = 2*c - i
            if l in 0..<s.len and i + result[l] < c + result[c]:
                result[i] = result[l]
            else:
                var j = c + result[c] - i
                while i-j >= 0 and i+j < s.len and s[i-j] == s[i+j]: j += 1
                result[i] = j
                c = i
    proc manacher*(s: string): seq[int] = manacher(s.toSeq)

    proc get_palindromes*[T](S:seq[T],partition:T): seq[(int,int)]=
        if len(S) == 0:
            return @[]
        result = newseq[(int,int)](2*len(S)-1)
        var tmp = newseqwith(2*len(S)-1,partition)
        for i in 0..<len(S):
            tmp[i*2] = S[i]
        var mana = manacher(tmp)
        for i in 0..<(2*len(S)-1):
            if i mod 2 == 0:
                var x = (mana[i]+1) div 2 - 1
                var idx = i div 2
                result[i] = (idx-x,idx+x+1)
            else:
                var x = mana[i] div 2
                if x == 0:
                    result[i] = (-1,-1)
                else:
                    var idx = i div 2 + 1
                    result[i] = (idx-x,idx+x)

    proc get_palindromes*(s:string,partition:char = '$') : seq[(int,int)]=
        ## Sに含まれる回文の中心として考えられる位置は文字、文字と文字の間の2N-1通り
        ## これらについて、その位置を中心とする回文を[l,r)のtupleで返す。
        ## ただし、存在しない場合は(-1,-1)を返す。
        ## partitionはsに含まれない
        return get_palindromes(s.toseq(),partition)
