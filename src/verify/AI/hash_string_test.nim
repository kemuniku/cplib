# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/str/hash_string

let a = "ab".tohash
let b = 'c'.tohash
let abc = "abc".tohash
assert len(a) == 2
assert a & b == abc
assert get_emptystring_hash() & abc == abc
assert "xy".tohash * 3 == "xyxyxy".tohash
assert "abc".tohash.removePrefix("ab".tohash) == "c".tohash
assert 65.tohash == 'A'.tohash

let rh = initRollingHash("banana")
assert $rh[1..3] == "ana"
assert rh[1..3] == rh[3..5]
assert rh[0] == 'b'
assert rh[1..5].LCP(rh[3..5]) == 3
assert cmp(rh[1..3], rh[1..3]) == 0
assert rh[1..3] < rh[0..2]
let hs: HashString = rh[1..3]
assert hs == "ana".tohash
