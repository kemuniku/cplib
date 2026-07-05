when not declared CPLIB_STR_LCP_NAIVE:
    const CPLIB_STR_LCP_NAIVE* = 1
    proc lcp_naive*(S,T:seq or string):int=
        for i in 0..<(min(len(S),len(T))):
            if S[i] != T[i]:
                return i
        return min(len(S),len(T))
