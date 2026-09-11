# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/algorithm
import cplib/str/run_enumerate

proc min_period(s: string, l, r: int): int =
    for p in 1..(r - l):
        var ok = true
        for i in (l + p)..<r:
            if s[i] != s[i - p]:
                ok = false
                break
        if ok:
            return p

proc brute_runs(s: string): seq[(int, int, int)] =
    let n = s.len
    for l in 0..<n:
        for r in (l + 1)..n:
            let p = min_period(s, l, r)
            if r - l >= 2 * p and
                    (l == 0 or s[l - 1] != s[l + p - 1]) and
                    (r == n or s[r] != s[r - p]):
                result.add((p, l, r))
    result.sort()

proc check_all(alphabet: string, max_len: int) =
    for n in 0..max_len:
        var total = 1
        for _ in 0..<n:
            total *= alphabet.len
        for mask in 0..<total:
            var
                s = newString(n)
                x = mask
            for i in 0..<n:
                s[i] = alphabet[x mod alphabet.len]
                x = x div alphabet.len
            assert run_enumerate(s) == brute_runs(s)

check_all("ab", 8)
check_all("abc", 7)

assert run_enumerate("aaaa") == @[(1, 0, 4)]
assert RunEnumerate("aaaa") == @[(1, 0, 4)]
assert run_enumerate("ababab") == @[(2, 0, 6)]
assert run_enumerate("abc") == @[]
assert run_enumerate(@[1, 2, 1, 2, 1, 2]) == @[(2, 0, 6)]
