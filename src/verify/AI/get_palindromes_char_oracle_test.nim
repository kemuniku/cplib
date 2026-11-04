# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/str/manacher
import sequtils
proc oracle[T](s: openArray[T]): seq[(int,int)] =
    if s.len == 0: return @[]
    result = newSeq[(int,int)](2*s.len-1)
    for center in 0..<result.len:
        var l = center div 2
        var r = (center+1) div 2
        while l >= 0 and r < s.len and s[l] == s[r]:
            dec l
            inc r
        result[center] = if l+1 == r: (-1,-1) else: (l+1,r)
var cases = 0
for n in 0..8:
    var count = 1
    for i in 0..<n: count *= 3
    for mask in 0..<count:
        var k = mask
        var s = newSeq[int](n)
        for i in 0..<n:
            s[i] = k mod 3
            k = k div 3
        assert get_palindromes(s,-1) == oracle(s)
        var chars = newString(n)
        for i in 0..<n: chars[i] = char(ord('a')+s[i])
        assert get_palindromes(chars) == oracle(chars)
        let odd = manacher(chars)
        for i in 0..<n:
            var radius = 0
            while i-radius >= 0 and i+radius < n and chars[i-radius] == chars[i+radius]: inc radius
            assert odd[i] == radius
        inc cases
let bytes = ['\0','\255','\128','\255','\0']
assert get_palindromes(bytes,'$') == oracle(bytes)
assert get_palindromes(@["alpha","beta","beta","alpha"],"partition") == oracle(@["alpha","beta","beta","alpha"])
type EqOnly = object
    x: int
proc `==`(a,b: EqOnly): bool = a.x == b.x
let values = [EqOnly(x:1),EqOnly(x:2),EqOnly(x:1)]
assert get_palindromes(values,EqOnly(x: -1)) == oracle(values)
assert get_palindromes("a$a") == oracle("a$a")
echo "Hello World"
