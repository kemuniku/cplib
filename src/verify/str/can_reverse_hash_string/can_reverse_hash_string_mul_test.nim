# verification-helper: PROBLEM https://yukicoder.me/problems/no/2858
include cplib/tmpl/sheep
import cplib/str/can_reverse_hash_string
var T = ii()

for _ in range(T):
    var N,M = ii()
    var S = si()
    #Sを無限個連結した文字列について、
    #1.あるiからM文字連続のものが回文かを判定する。
    #2.あるiからM+1文字連続のものが回文かをはんていする。
    var ans = INF
    var HS = S.initRollingHash()

    proc solve(i,x:int):bool=
        if (i+x) < N:
            return HS[i..<(i+x)].isPalindrome()
        var tmp = HS[i..<N].toHashString()
        tmp = tmp & (HS * ((x-len(i..<N)) // N))
        var nokori = x-(((x-len(i..<N)) // N)*N + len(i..<N))
        tmp = tmp & HS[0..<nokori]
        return tmp.isPalindrome()


    for i in range(N):
        if solve(i,M):
            ans.min = (M-(N-i)+(N-1))//N + 1
        if solve(i,M+1):
            ans.min = (M+1-(N-i)+(N-1))//N + 1

    if ans == INF:
        echo -1
    else:
        echo ans