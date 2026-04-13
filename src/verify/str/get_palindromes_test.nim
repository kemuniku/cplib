# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_palindromes

include cplib/tmpl/sheep
import cplib/str/manacher
import cplib/str/can_reverse_hash_string

var S = si()

var HS = S.initRollingHash()

var palindromes = get_palindromes(S)

for i in range(len(palindromes)):
    var (l,r) = palindromes[i]
    assert HS[l..<r].isPalindrome()
    if l != 0 and r != len(S) and l != -1:
        assert not HS[(l-1)..<(r+1)].isPalindrome()

echo palindromes.mapit(it[1]-it[0]).join(" ")