# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes
import cplib/str/can_reverse_hash_string
import cplib/utils/binary_search
import strutils

var S = stdin.readLine().initRollingHash()
var L : seq[int]

for i in 0..<(2*len(S)-1):
    if i mod 2 == 0:
        var i = i div 2
        proc is_ok(arg:int):bool=
            return S[(i-arg)..(i+arg)].isPalindrome()
        L.add meguru_bisect(0,min(i,len(S)-i-1)+1,is_ok)*2 + 1
    else:
        var i = (i+1) div 2
        proc is_ok(arg:int):bool=
            return S[(i-arg)..<(i+arg)].isPalindrome()
        L.add meguru_bisect(0,min(i,len(S)-i)+1,is_ok)*2

echo L.join(" ")