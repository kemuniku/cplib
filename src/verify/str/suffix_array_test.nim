import algorithm
import cplib/str/suffix_array

proc naiveSuffixArray(s: openArray[int]): seq[int] =
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

proc checkAll(s: var seq[int], pos: int) =
    if pos == s.len:
        doAssert suffix_array(s, 2) == naiveSuffixArray(s)
        return
    for value in 0..2:
        s[pos] = value
        checkAll(s, pos + 1)

doAssert suffix_array("") == @[]
doAssert suffix_array("banana") == @[5, 3, 1, 0, 4, 2]
doAssert suffix_array(@[0, 0, 0], 0) == @[2, 1, 0]
doAssert suffix_array(@[1, 1, 1], 1) == @[2, 1, 0]
for n in 0..8:
    var s = newSeq[int](n)
    checkAll(s, 0)

for n in [64, 127, 256, 1024]:
    var s = newSeq[int](n)
    for i in 0..<n:
        s[i] = (i * 17 + i div 7) mod 5
    doAssert suffix_array(s, 4) == naiveSuffixArray(s)
