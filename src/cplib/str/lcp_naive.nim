when not declared CPLIB_STR_LCP_NAIVE:
    const CPLIB_STR_LCP_NAIVE* = 1
    proc lcp_naive*[U](S,T:openArray[U]):int=
        for i in 0..<(min(len(S),len(T))):
            if S[i] != T[i]:
                return i
        return min(len(S),len(T))
