import times, os, strutils
import cplib/str/trie_string

let n = (if paramCount() > 0: parseInt(paramStr(1)) else: 100000)
let shape = (if paramCount() > 1: paramStr(2) else: "chains")
when defined(array2):
    var t = initTrieStringArray(char(0)..char(1))
elif defined(array26):
    var t = initTrieStringArray(char(0)..char(25))
elif defined(array256):
    var t = initTrieStringArray(char(0)..char(255))
else:
    var t = initTrieStringTable(char)
var handles = newSeq[int](n + 1)
var second = newSeq[int](n + 1)
var start = cpuTime()
for i in 1..n:
    if shape == "chains":
        handles[i] = t.add(handles[i - 1], char(0))
        second[i] = t.add(second[i - 1], (if i == 1: char(1) else: char(0)))
    else:
        handles[i] = t.add(handles[(i - 1) div 2], char(i mod 2))
let build = cpuTime() - start
var checksum = 0
start = cpuTime()
for i in 1..n:
    let parent = (if shape == "chains": handles[i - 1] else: handles[(i - 1) div 2])
    let c = (if shape == "chains": char(0) else: char(i mod 2))
    checksum = checksum xor t.add(parent, c)
let duplicate = cpuTime() - start
start = cpuTime()
for i in 1..n:
    checksum = checksum xor t.pop(handles[i])
let popTime = cpuTime() - start
start = cpuTime()
for i in 1..1000000:
    let a = i mod n + 1
    let b = (i * 7919) mod n + 1
    if shape == "chains":
        checksum += t.compare(handles[a], second[b])
    else:
        checksum += t.compare(handles[a], handles[b])
let compare = cpuTime() - start
echo "shape=", shape, " nodes=", t.nodeCount, " add_s=", build,
    " duplicate_s=", duplicate, " pop_s=", popTime,
    " compare_1m_s=", compare, " checksum=", checksum
