---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    \ninclude cplib/tmpl/fastio\nimport posix, strutils, random\n\nproc temporaryFile():\
    \ File {.importc: \"tmpfile\", header: \"<stdio.h>\".}\nlet inputFile = temporaryFile()\n\
    doAssert inputFile != nil\nvar rng = initRand(123456)\n\nproc signedValues[T:\
    \ SomeSignedInt](): seq[T] =\n    @[low(T), high(T), T(0), T(-1), T(1), T(37)]\n\
    proc unsignedValues[T: SomeUnsignedInt](): seq[T] =\n    @[low(T), high(T), T(1),\
    \ T(37), T(127)]\nproc values[T: SomeInteger](): seq[T] =\n    when T is SomeSignedInt:\
    \ signedValues[T]()\n    else: unsignedValues[T]()\nproc writeValues[T: SomeInteger]()\
    \ =\n    for round in 0..1:\n        for x in values[T](): inputFile.write($x\
    \ & \" \\t\\r\\n\")\n\ntemplate allTypes(action: untyped) =\n    action[int8]()\n\
    \    action[int16]()\n    action[int32]()\n    action[int64]()\n    action[int]()\n\
    \    action[uint8]()\n    action[uint16]()\n    action[uint32]()\n    action[uint64]()\n\
    \    action[uint]()\nallTypes(writeValues)\n\nvar nineDigits = newSeq[uint32](4096)\n\
    for x in nineDigits.mitems:\n    x = uint32(rand(rng, 100000000..999999999))\n\
    \    inputFile.write($x & \"\\n\")\nvar signedRandom = newSeq[int64](4096)\nfor\
    \ x in signedRandom.mitems:\n    x = rand(rng, -1000000000..1000000000).int64\n\
    \    inputFile.write($x & \" \")\ninputFile.write(\"\\n\")\nconst blockSize =\
    \ 1 shl 20\nlet splitValues = @[$low(int64), $high(int64), $high(uint64), \"+00000000000000000000000000042\"\
    ]\nfor token in splitValues:\n    for offset in [1, 7, 15, 31]:\n        let padding\
    \ = (blockSize - offset - (inputFile.getFilePos().int mod blockSize) + blockSize)\
    \ mod blockSize\n        inputFile.write(repeat(' ', padding))\n        inputFile.write(token\
    \ & \"\\n\")\nlet longToken = repeat(\"abcdefghij\", blockSize div 3)\nlet tokens\
    \ = @[\"hello\", \"\\xff\\xfeabc\", longToken, \"tail\"]\nfor i, token in tokens:\n\
    \    inputFile.write(token)\n    if i != tokens.high: inputFile.write(\"\\n\"\
    )\ninputFile.flushFile()\ninputFile.setFilePos(0)\ndoAssert posix.dup2(inputFile.getFileHandle(),\
    \ 0) == 0\n\nproc checkValues[T: SomeInteger]() =\n    let expected = values[T]()\n\
    \    for x in expected: doAssert input(T) == x\n    doAssert input(expected.len,\
    \ T) == expected\n    doAssert input(0, T).len == 0\n    var text = \"\"\n   \
    \ for i,x in expected:\n        if i != 0: text.add(\"|\")\n        text.add($x)\n\
    \    doAssert expected.join(\"|\") == text\nallTypes(checkValues)\ndoAssert input(nineDigits.len,\
    \ uint32) == nineDigits\ndoAssert input(signedRandom.len, int64) == signedRandom\n\
    for token in splitValues:\n    for offset in [1, 7, 15, 31]:\n        if token\
    \ == $low(int64): doAssert input(int64) == low(int64)\n        elif token == $high(int64):\
    \ doAssert input(int64) == high(int64)\n        elif token == $high(uint64): doAssert\
    \ input(uint64) == high(uint64)\n        else: doAssert input(uint32) == 42\n\
    for token in tokens: doAssert si() == token\ndoAssert si() == \"\"\ndoAssert input(int64)\
    \ == 0\ndoAssert input(uint64) == 0\ndoAssert fastioGetChar() == -1\n\nlet outputFile\
    \ = temporaryFile()\ndoAssert outputFile != nil\nstdout.flushFile()\nlet savedStdout\
    \ = posix.dup(1)\ndoAssert savedStdout >= 0\ndoAssert posix.dup2(outputFile.getFileHandle(),\
    \ 1) == 1\nvar expectedOutput = \"\"\nproc checkOutput[T: SomeInteger]() =\n \
    \   let a = values[T]()\n    for x in a:\n        print(x)\n        expectedOutput.add($x\
    \ & \"\\n\")\n    print(*a, sep = \"|\")\n    for i,x in a:\n        if i != 0:\
    \ expectedOutput.add('|')\n        expectedOutput.add($x)\n    expectedOutput.add('\\\
    n')\nallTypes(checkOutput)\nprint(*nineDigits, sep = \"\\n\")\nfor x in nineDigits:\
    \ expectedOutput.add($x & \"\\n\")\nlet longSeparator = repeat('=', 70000)\nprint(*[low(int64),\
    \ high(int64)], sep = longSeparator)\nexpectedOutput.add($low(int64) & longSeparator\
    \ & $high(int64) & \"\\n\")\nstdout.write(\"write\\n\")\necho \"echo\"\nprint(\"\
    print\")\nexpectedOutput.add(\"write\\necho\\nprint\\n\")\nstdout.flushFile()\n\
    doAssert posix.dup2(savedStdout, 1) == 1\ndiscard posix.close(savedStdout)\noutputFile.setFilePos(0)\n\
    doAssert outputFile.readAll() == expectedOutput\ninputFile.close()\noutputFile.close()\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/AI/fastio_io_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:22:45+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fastio_io_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fastio_io_test.nim
- /verify/verify/AI/fastio_io_test.nim.html
title: verify/AI/fastio_io_test.nim
---
