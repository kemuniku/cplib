# verification-helper: PROBLEM https://yukicoder.me/problems/no/2858
include cplib/tmpl/sheep
import cplib/str/hash_string
var T = ii()

for _ in range(T):
    var N,M = ii()
    var S = si()
    #Sを無限個連結した文字列について、
    #1.あるiからM文字連続のものが回文かを判定する。
    #2.あるiからM+1文字連続のものが回文かをはんていする。
    var ans = INF
    var HS = S.initRollingHash()
    var HRS = (reversed(S).join("")).initRollingHash()

    proc solve(i,x:int):bool=
        if (i+x) < N:
            return HS[i..<(i+x)] == HRS[(N-1-(i+x-1))..(N-1-i)]
        var tmp1 = HS[i..<N].toHashString()
        var tmp2 = HRS[0..(N-1-i)].toHashString()
        tmp1 = tmp1 & (HS * ((x-len(i..<N)) // N))
        tmp2 = (HRS * ((x-len(i..<N)) // N)) & tmp2
        var nokori = x-(((x-len(i..<N)) // N)*N + len(i..<N))
        tmp1 = tmp1 & HS[0..<nokori]
        tmp2 = HRS[(N-nokori)..(N-1)] & tmp2
        return tmp1 == tmp2


    for i in range(N):
        if solve(i,M):
            ans.min = (M-(N-i)+(N-1))//N + 1
        if solve(i,M+1):
            ans.min = (M+1-(N-i)+(N-1))//N + 1

    if ans == INF:
        echo -1
    else:
        echo ans