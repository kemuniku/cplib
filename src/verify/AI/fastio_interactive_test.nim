# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

{.define: fastioMmap.}
include cplib/tmpl/sheep_interactive
import posix

var toSolution, fromSolution: array[2, cint]
doAssert pipe(toSolution) == 0
doAssert pipe(fromSolution) == 0
stdout.flushFile()
let child = fork()
doAssert child >= 0

if child == 0:
    discard alarm(5)
    doAssert dup2(toSolution[0], 0) == 0
    doAssert dup2(fromSolution[1], 1) == 1
    for fd in [toSolution[0], toSolution[1], fromSolution[0], fromSolution[1]]:
        discard posix.close(fd)
    doAssert ii() == 7
    print("?", 1)
    doAssert input(int) == -42
    print(1, 2, 3, sep = '|')
    doAssert input(uint64) == high(uint64)
    print(*[1, 2, 3], sep = ',')
    doAssert input(3, uint32) == @[0u32, high(uint32), 42u32]
    print(42)
    doAssert input(char) == 'L'
    doAssert input(char) == 'R'
    print("token")
    doAssert input(string) == "ok"
    print(*["a", "b"])
    doAssert lii(3) == @[-1, 0, 1]
    print(*newSeq[int]())
    doAssert si() == "tail"
    print((f: stdout, sepc: " ", endc: "\n", flush: true), "!", 7)
    doAssert ii() == 0
    doAssert si() == ""
    doAssert input(char) == '\0'
    quit(0)

discard posix.close(toSolution[0])
discard posix.close(fromSolution[1])

proc exchange(response, expected: string) =
    doAssert posix.write(toSolution[1], response.cstring, response.len) == response.len
    var line = ""
    while true:
        var ready = TPollfd(fd: fromSolution[0], events: POLLIN)
        doAssert poll(addr ready, Tnfds(1), 3000) == 1
        var c: char
        doAssert posix.read(fromSolution[0], addr c, 1) == 1
        if c == '\n': break
        line.add(c)
    doAssert line == expected, line

exchange("7\n", "? 1")
exchange("-42\n", "1|2|3")
exchange("18446744073709551615\n", "1,2,3")
exchange("0 4294967295 42\n", "42")
exchange("LR\n", "token")
exchange("ok\n", "a b")
exchange("-1 0 1\n", "")
exchange("tail\n", "! 7")
discard posix.close(toSolution[1])
discard posix.close(fromSolution[0])
var status: cint
doAssert waitpid(child, status, 0) == child
doAssert WIFEXITED(status) and WEXITSTATUS(status) == 0
echo "Hello World"
