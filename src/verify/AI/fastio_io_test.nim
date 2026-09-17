# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

include cplib/tmpl/fastio
import posix, strutils, random

proc temporaryFile(): File {.importc: "tmpfile", header: "<stdio.h>".}
let inputFile = temporaryFile()
doAssert inputFile != nil
var rng = initRand(123456)

proc signedValues[T: SomeSignedInt](): seq[T] =
    @[low(T), high(T), T(0), T(-1), T(1), T(37)]
proc unsignedValues[T: SomeUnsignedInt](): seq[T] =
    @[low(T), high(T), T(1), T(37), T(127)]
proc values[T: SomeInteger](): seq[T] =
    when T is SomeSignedInt: signedValues[T]()
    else: unsignedValues[T]()
proc writeValues[T: SomeInteger]() =
    for round in 0..1:
        for x in values[T](): inputFile.write($x & " \t\r\n")

template allTypes(action: untyped) =
    action[int8]()
    action[int16]()
    action[int32]()
    action[int64]()
    action[int]()
    action[uint8]()
    action[uint16]()
    action[uint32]()
    action[uint64]()
    action[uint]()
allTypes(writeValues)

var nineDigits = newSeq[uint32](4096)
for x in nineDigits.mitems:
    x = uint32(rand(rng, 100000000..999999999))
    inputFile.write($x & "\n")
var signedRandom = newSeq[int64](4096)
for x in signedRandom.mitems:
    x = rand(rng, -1000000000..1000000000).int64
    inputFile.write($x & " ")
inputFile.write("\n")
const blockSize = 1 shl 20
let splitValues = @[$low(int64), $high(int64), $high(uint64), "+00000000000000000000000000042"]
for token in splitValues:
    for offset in [1, 7, 15, 31]:
        let padding = (blockSize - offset - (inputFile.getFilePos().int mod blockSize) + blockSize) mod blockSize
        inputFile.write(repeat(' ', padding))
        inputFile.write(token & "\n")
let longToken = repeat("abcdefghij", blockSize div 3)
let tokens = @["hello", "\xff\xfeabc", longToken, "tail"]
for i, token in tokens:
    inputFile.write(token)
    if i != tokens.high: inputFile.write("\n")
inputFile.flushFile()
inputFile.setFilePos(0)
doAssert posix.dup2(inputFile.getFileHandle(), 0) == 0

proc checkValues[T: SomeInteger]() =
    let expected = values[T]()
    for x in expected: doAssert input(T) == x
    doAssert input(expected.len, T) == expected
    doAssert input(0, T).len == 0
    var text = ""
    for i,x in expected:
        if i != 0: text.add("|")
        text.add($x)
    doAssert expected.join("|") == text
allTypes(checkValues)
doAssert input(nineDigits.len, uint32) == nineDigits
doAssert input(signedRandom.len, int64) == signedRandom
for token in splitValues:
    for offset in [1, 7, 15, 31]:
        if token == $low(int64): doAssert input(int64) == low(int64)
        elif token == $high(int64): doAssert input(int64) == high(int64)
        elif token == $high(uint64): doAssert input(uint64) == high(uint64)
        else: doAssert input(uint32) == 42
for token in tokens: doAssert si() == token
doAssert si() == ""
doAssert input(int64) == 0
doAssert input(uint64) == 0
doAssert fastioGetChar() == -1

let outputFile = temporaryFile()
doAssert outputFile != nil
stdout.flushFile()
let savedStdout = posix.dup(1)
doAssert savedStdout >= 0
doAssert posix.dup2(outputFile.getFileHandle(), 1) == 1
var expectedOutput = ""
proc checkOutput[T: SomeInteger]() =
    let a = values[T]()
    for x in a:
        print(x)
        expectedOutput.add($x & "\n")
    print(*a, sep = "|")
    for i,x in a:
        if i != 0: expectedOutput.add('|')
        expectedOutput.add($x)
    expectedOutput.add('\n')
allTypes(checkOutput)
print(*nineDigits, sep = "\n")
for x in nineDigits: expectedOutput.add($x & "\n")
let longSeparator = repeat('=', 70000)
print(*[low(int64), high(int64)], sep = longSeparator)
expectedOutput.add($low(int64) & longSeparator & $high(int64) & "\n")
stdout.write("write\n")
echo "echo"
print("print")
expectedOutput.add("write\necho\nprint\n")
stdout.flushFile()
doAssert posix.dup2(savedStdout, 1) == 1
discard posix.close(savedStdout)
outputFile.setFilePos(0)
doAssert outputFile.readAll() == expectedOutput
inputFile.close()
outputFile.close()
echo "Hello World"
