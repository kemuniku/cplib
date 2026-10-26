---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep_interactive.nim
    title: cplib/tmpl/sheep_interactive.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep_interactive.nim
    title: cplib/tmpl/sheep_interactive.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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
    \n{.define: fastioMmap.}\ninclude cplib/tmpl/sheep_interactive\nimport posix\n\
    \nvar toSolution, fromSolution: array[2, cint]\ndoAssert pipe(toSolution) == 0\n\
    doAssert pipe(fromSolution) == 0\nstdout.flushFile()\nlet child = fork()\ndoAssert\
    \ child >= 0\n\nif child == 0:\n    discard alarm(5)\n    doAssert dup2(toSolution[0],\
    \ 0) == 0\n    doAssert dup2(fromSolution[1], 1) == 1\n    for fd in [toSolution[0],\
    \ toSolution[1], fromSolution[0], fromSolution[1]]:\n        discard posix.close(fd)\n\
    \    doAssert ii() == 7\n    print(\"?\", 1)\n    doAssert input(int) == -42\n\
    \    print(1, 2, 3, sep = '|')\n    doAssert input(uint64) == high(uint64)\n \
    \   print(*[1, 2, 3], sep = ',')\n    doAssert input(3, uint32) == @[0u32, high(uint32),\
    \ 42u32]\n    print(42)\n    doAssert input(char) == 'L'\n    doAssert input(char)\
    \ == 'R'\n    print(\"token\")\n    doAssert input(string) == \"ok\"\n    print(*[\"\
    a\", \"b\"])\n    doAssert lii(3) == @[-1, 0, 1]\n    print(*newSeq[int]())\n\
    \    doAssert si() == \"tail\"\n    print((f: stdout, sepc: \" \", endc: \"\\\
    n\", flush: true), \"!\", 7)\n    doAssert ii() == 0\n    doAssert si() == \"\"\
    \n    doAssert input(char) == '\\0'\n    quit(0)\n\ndiscard posix.close(toSolution[0])\n\
    discard posix.close(fromSolution[1])\n\nproc exchange(response, expected: string)\
    \ =\n    doAssert posix.write(toSolution[1], response.cstring, response.len) ==\
    \ response.len\n    var line = \"\"\n    while true:\n        var ready = TPollfd(fd:\
    \ fromSolution[0], events: POLLIN)\n        doAssert poll(addr ready, Tnfds(1),\
    \ 3000) == 1\n        var c: char\n        doAssert posix.read(fromSolution[0],\
    \ addr c, 1) == 1\n        if c == '\\n': break\n        line.add(c)\n    doAssert\
    \ line == expected, line\n\nexchange(\"7\\n\", \"? 1\")\nexchange(\"-42\\n\",\
    \ \"1|2|3\")\nexchange(\"18446744073709551615\\n\", \"1,2,3\")\nexchange(\"0 4294967295\
    \ 42\\n\", \"42\")\nexchange(\"LR\\n\", \"token\")\nexchange(\"ok\\n\", \"a b\"\
    )\nexchange(\"-1 0 1\\n\", \"\")\nexchange(\"tail\\n\", \"! 7\")\ndiscard posix.close(toSolution[1])\n\
    discard posix.close(fromSolution[0])\nvar status: cint\ndoAssert waitpid(child,\
    \ status, 0) == child\ndoAssert WIFEXITED(status) and WEXITSTATUS(status) == 0\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep_interactive.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep_interactive.nim
  - cplib/tmpl/sheep.nim
  isVerificationFile: true
  path: verify/AI/fastio_interactive_test.nim
  requiredBy: []
  timestamp: '2026-10-17 20:24:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fastio_interactive_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fastio_interactive_test.nim
- /verify/verify/AI/fastio_interactive_test.nim.html
title: verify/AI/fastio_interactive_test.nim
---
