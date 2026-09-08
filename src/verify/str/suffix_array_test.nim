import algorithm, random
import cplib/str/suffix_array

proc naiveSuffixArray(s: openArray[int]): seq[int] =
    ## 接尾辞を直接比較して正解の SA を作成します。
    let values = @s
    result = newSeq[int](s.len)
    for i in 0..<s.len:
        result[i] = i
    result.sort(proc(l, r: int): int =
        var i = 0
        while l + i < values.len and r + i < values.len:
            if values[l + i] != values[r + i]:
                return system.cmp(values[l + i], values[r + i])
            inc i
        return system.cmp(values.len - l, values.len - r))

proc naiveLcp(s: openArray[int], sa: openArray[int]): seq[int] =
    ## 隣接する接尾辞を直接比較して正解の LCP を作成します。
    result = newSeq[int](max(sa.len - 1, 0))
    for i in 0..<result.len:
        while result[i] + sa[i] < s.len and result[i] + sa[i + 1] < s.len and
                s[result[i] + sa[i]] == s[result[i] + sa[i + 1]]:
            inc result[i]

proc checkAll(s: var seq[int], pos: int) =
    ## 3 種類の値からなる列を全列挙して検証します。
    if pos == s.len:
        let sa = suffix_array(s, 2)
        doAssert sa == naiveSuffixArray(s)
        doAssert lcp_array(s, sa) == naiveLcp(s, sa)
        var text = newString(s.len)
        for i, value in s:
            text[i] = char(value * 127)
        doAssert suffix_array(text) == sa
        doAssert lcp_array(text, sa) == naiveLcp(s, sa)
        return
    for value in 0..2:
        s[pos] = value
        checkAll(s, pos + 1)

doAssert suffix_array("") == @[]
doAssert suffix_array("banana") == @[5, 3, 1, 0, 4, 2]
doAssert lcp_array("", @[]) == @[]
doAssert lcp_array("banana", suffix_array("banana")) == @[1, 3, 0, 0, 2]
doAssert suffix_array(@[0, 0, 0], 0) == @[2, 1, 0]
doAssert suffix_array(@[1, 1, 1], 1) == @[2, 1, 0]
doAssert lcp_array(@[0, 0, 0], @[2, 1, 0]) == @[1, 2]
for n in 0..8:
    var s = newSeq[int](n)
    checkAll(s, 0)

for n in [64, 127, 256, 1024]:
    var s = newSeq[int](n)
    for i in 0..<n:
        s[i] = (i * 17 + i div 7) mod 5
    let sa = suffix_array(s, 4)
    doAssert sa == naiveSuffixArray(s)
    doAssert lcp_array(s, sa) == naiveLcp(s, sa)

proc checkBytes(values: seq[int]) =
    ## NUL と上位ビットを含む文字列を整数列の素朴解と比較します。
    var text = newString(values.len)
    for i, value in values:
        text[i] = char(value)
    let expected = naiveSuffixArray(values)
    doAssert suffix_array(text) == expected
    doAssert suffix_array(values, 255) == expected
    doAssert suffix_array(values) == expected
    doAssert lcp_array(text, expected) == naiveLcp(values, expected)

var rng = initRand(20260908)
for trial in 0..<2000:
    var values = newSeq[int](rng.rand(128))
    let upper = [1, 2, 4, 25, 255][trial mod 5]
    for value in values.mitems:
        value = rng.rand(upper)
    checkBytes(values)

for n in [1, 2, 3, 31, 32, 33, 255, 256, 257, 1024]:
    var values = newSeq[int](n)
    for i in 0..<n:
        values[i] = i mod 256
    checkBytes(values)
    values.reverse()
    checkBytes(values)
    for i in 0..<n:
        values[i] = 255
    checkBytes(values)

let sparse = @[int.high, int.low, 0, int.high, -1, int.low]
let sparseSa = naiveSuffixArray(sparse)
doAssert suffix_array(sparse) == sparseSa
doAssert lcp_array(sparse, sparseSa) == naiveLcp(sparse, sparseSa)
doAssert suffix_array(@["b", "a", "b", "a"]) == @[3, 1, 2, 0]
