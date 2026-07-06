# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/can_reverse_hash_string

let aba = "aba".tohash
let ab = "ab".tohash
assert aba.isPalindrome
assert not ab.isPalindrome
assert ab.reversed == "ba".tohash
assert "ab".tohash & "c".tohash == "abc".tohash
assert "ab".tohash * 3 == "ababab".tohash
assert get_emptystring_hash() & aba == aba
assert 65.tohash == 'A'.tohash

let rh = initRollingHash("abacaba")
assert $rh[0..2] == "aba"
assert rh[0..2].isPalindrome
assert rh[0..2].reversed == rh[0..2]
assert rh[0..2] == rh[4..6]
assert rh[0] == 'a'
assert rh[0..6].LCP(rh[4..6]) == 3
assert cmp(rh[0..2], rh[1..3]) < 0
let hs: HashString = rh[0..2]
assert hs == aba
