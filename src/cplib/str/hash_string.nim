import random
type HashString* =object
    hash:uint
    size:uint
const MASK30 = (1u shl 30) - 1
const MASK31 = (1u shl 31) - 1
const RH_MOD = (1u shl 61) - 1
const POW_CALC = 500000

randomize()

proc calc_mod(x: uint): uint =
    result = (x shr 61) + (x and RH_MOD)
    if result > RH_MOD:
        result -= RH_MOD

proc mul(a, b: uint): uint =
    let
        a_upper = a shr 31
        a_lower = a and MASK31
        b_upper = b shr 31
        b_lower = b and MASK31
        mid = a_lower * b_upper + a_upper * b_lower
        mid_upper = mid shr 30
        mid_lower = mid and MASK30
    result = a_upper * b_upper * 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower


proc inner_pow(a, n: uint): uint =
    var a = a
    var n = n
    result = 1
    while n > 0:
        if (n and 1u) != 0u:
            result = mul(result, a).calc_mod
        a = mul(a, a).calc_mod
        n = n shr 1

let hashstring_base:uint = rand(129u..(1u shl 30))
let inv_hashstring_base:uint = inner_pow(hashstring_base,RH_MOD-2)
var pows : seq[uint] = newseq[uint](POW_CALC+1)
var invpows : seq[uint] = newseq[uint](POW_CALC+1)
pows[0] = 1
invpows[0] = 1
for i in 1..POW_CALC:
    pows[i] = (mul(pows[i-1],hashstring_base).calc_mod)
    invpows[i] = (mul(invpows[i-1],inv_hashstring_base).calc_mod)

proc base_pow(n:uint):uint=
    if n >= uint(len(pows)):
        return inner_pow(hashstring_base,n)
    else:
        return pows[n]

proc tohash*(S:string):HashString=
    var hash = 0u
    var tmp = 1u
    for i in countdown(len(S)-1,0,1):
        hash = (hash+mul(uint(int(S[i])),tmp)).calc_mod
        tmp = mul(tmp,hashstring_base).calc_mod 
    result = HashString(hash:hash,size:uint(len(S)))

proc tohash*(S:char):HashString=
    result = HashString(hash:uint(int(S)),size:1)

proc `&`*(L,R:HashString):HashString=
    result = HashString(hash:(mul(L.hash,base_pow(R.size)).calc_mod+R.hash).calc_mod,size:L.size+R.size)

proc `==`*(L,R:HashString):bool=
    return (L.size == R.size) and (L.hash == R.hash)

proc len*(H:HashString):int=int(H.size)

proc `*`*(H:HashString,x:int):HashString=
    result = "".toHash()
    var
        x = x
        tmp = H
    while x > 0:
        if x mod 2 != 0: result = result&tmp
        if x > 1: tmp = tmp & tmp
        x = x shr 1

proc removePrefix(H,suffix:HashString):HashString=
    var hash = (H.hash + (RH_MOD - mul(suffix.hash,base_pow(uint(len(H)-len(suffix)))).calc_mod)).calc_mod
    var l = uint(len(H)-len(suffix))
    return HashString(hash:hash,size:l)

type RollingHashBase = ref object
    S : string
    prefixs : seq[uint]
    size : uint 

type RollingHash= object
    R : RollingHashBase
    l : uint
    r : uint

proc len*(S:RollingHashBase):int=
    return int(S.size)

proc len*(S:RollingHash):int=
    return int(S.r-S.l)

proc get_substring(R:RollingHashBase,l,r:uint):RollingHash=
    #半開区間とする。
    assert l in 0u..<R.size and r in 1u..R.size and l < r
    result.R = R
    result.l = l
    result.r = r

proc `[]`*(R:RollingHashBase,slice:HSlice[int,int]):RollingHash=
    assert slice.a >= 0 and slice.b >= 0
    return R.get_substring(uint(slice.a),uint(slice.b)+1)


proc `[]`*(S:RollingHash,slice:HSlice[int,int]):RollingHash=
    assert slice.a in 0..<len(S) and slice.b in 0..<len(S)
    return S.R.get_substring(S.l+uint(slice.a),S.l+uint(slice.b)+1)

proc `[]`*(S:RollingHash,idx:int):char=
    return S.R.S[idx+int(S.l)]

proc initRollingHash*(S:string):RollingHash=
    var rolling = RollingHashBase()
    rolling.S = S
    rolling.prefixs = newSeq[uint](len(S)+1)
    rolling.prefixs[0] = 0
    for i in 1..len(S):
        rolling.prefixs[i] = (mul(rolling.prefixs[i-1],hashstring_base) + uint(int(S[i-1]))).calc_mod()
    rolling.size = uint(len(S))
    return rolling[0..<len(S)]



converter toHashString*(self:RollingHash):HashString=
    return HashString(hash:(self.R.prefixs[self.r] + (RH_MOD - mul(self.R.prefixs[self.l],base_pow(self.r-self.l)).calc_mod)).calc_mod,size:self.r-self.l)

proc`$`*(S:RollingHash):string=
    return S.R.S[S.l..<S.r]

proc `==`*(S,T:RollingHash):bool=
    return (S.R.prefixs[S.r] + (RH_MOD - mul(S.R.prefixs[S.l],base_pow(S.r-S.l)).calc_mod)).calc_mod == 
           (T.R.prefixs[T.r] + (RH_MOD - mul(T.R.prefixs[T.l],base_pow(T.r-T.l)).calc_mod)).calc_mod

proc LCP*(S,T:RollingHash):int=
    var ok = 0
    var ng = min(len(S),len(T))+1
    while abs(ng-ok) > 1:
        var mid = (ok + ng) div 2
        if S[0..<mid] == T[0..<mid]: ok = mid
        else: ng = mid
    return ok

proc cmp*(S,T:RollingHash):int=
    var S = S
    var T = T
    var flg = 1
    if len(S) > len(T):
        swap(S,T)
        flg *= -1
    var lcp = LCP(S,T)
    if len(S) == lcp:
        if len(S) == len(T):
            return 0
        else:
            return -1*flg
    else:
        if S[lcp] < T[lcp]:
            return -1*flg
        else:
            return flg

proc `<`*(S,T:RollingHash):bool=
    return cmp(S,T) < 0