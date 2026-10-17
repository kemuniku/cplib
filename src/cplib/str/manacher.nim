when not declared CPLIB_STR_MANACHER:
    const CPLIB_STR_MANACHER* = 1
    import sequtils
    proc manacher*[T](s: openArray[T]): seq[int] =
        result = newSeq[int](s.len)
        if s.len == 0:
            return
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
    proc manacher*(s: string): seq[int] = manacher[char](s)

    proc get_palindromes*[T](S: openArray[T], partition: T): seq[(int, int)] =
        ## 各中心の回文区間を O(N) 時間で返す。charでは出力以外 O(1) 空間。
        when T is char:
            let n = S.len
            if n == 0: return @[]
            result = newSeq[(int, int)](2*n-1)
            var left = 0
            var right = -1
            for i in 0..<n:
                var radius = 1
                if i <= right:
                    let mirror = left + right - i
                    let interval = result[2*mirror]
                    radius = min((interval[1] - interval[0] + 1) div 2, right - i + 1)
                while i-radius >= 0 and i+radius < n and S[i-radius] == S[i+radius]:
                    inc radius
                result[2*i] = (i-radius+1, i+radius)
                if i+radius-1 > right:
                    left = i-radius+1
                    right = i+radius-1
            left = 0
            right = -1
            for i in 1..<n:
                var radius = 0
                if i <= right:
                    let mirror = left + right - i + 1
                    let interval = result[2*mirror-1]
                    if interval[0] >= 0:
                        radius = min((interval[1] - interval[0]) div 2, right - i + 1)
                while i-radius-1 >= 0 and i+radius < n and S[i-radius-1] == S[i+radius]:
                    inc radius
                result[2*i-1] = if radius == 0: (-1, -1) else: (i-radius, i+radius)
                if i+radius-1 > right:
                    left = i-radius
                    right = i+radius-1

        else:
            if len(S) == 0:
                return @[]
            result = newseq[(int, int)](2*len(S)-1)
            var tmp = newseqwith(2*len(S)-1, partition)
            for i in 0..<len(S):
                tmp[i*2] = S[i]
            var mana = manacher(tmp)
            for i in 0..<(2*len(S)-1):
                if i mod 2 == 0:
                    var x = (mana[i]+1) div 2 - 1
                    var idx = i div 2
                    result[i] = (idx-x, idx+x+1)
                else:
                    var x = mana[i] div 2
                    if x == 0:
                        result[i] = (-1, -1)
                    else:
                        var idx = i div 2 + 1
                        result[i] = (idx-x, idx+x)

    proc get_palindromes*(s: string, partition: char = '$'): seq[(int, int)] =
        ## Sに含まれる回文の中心として考えられる位置は文字、文字と文字の間の2N-1通り
        ## これらについて、その位置を中心とする回文を[l,r)のtupleで返す。
        ## ただし、存在しない場合は(-1,-1)を返す。
        ## partitionはsに含まれない
        return get_palindromes[char](s, partition)
