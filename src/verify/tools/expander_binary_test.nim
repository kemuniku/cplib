# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import os, osproc, streams, strutils, base64, posix
import "../../../tools/expander/binary"

when false:
    import "../tools/expander/expander.nim"
    import "../tools/expander/binary.nim"
    import "../tools/expander/compression.nim"
    import "../tools/expander/declare_commandline_option.nim"

const repoRoot = currentSourcePath().parentDir.parentDir.parentDir.parentDir
const directory = block:
    let made = gorgeEx("mktemp -d -t cplib-331-XXXXXXXX")
    doAssert made.exitCode == 0
    made.output.strip

proc run(command: string; expected = 0): string {.compileTime.} =
    let executed = gorgeEx("cd " & quoteShell(directory) & " && " & command)
    doAssert executed.exitCode == expected, command & "\n" & executed.output
    executed.output

static:
    let compiler = quoteShell(getEnv("NIM", "nim"))
    let flags = " cpp --hints:off -d:release --opt:speed --multimethods:on " &
        "--warning[SmallLshouldNotBeUsed]:off --maxLoopIterationsVM:10000000000000 " &
        "--nimcache:cache -o:"
    discard run(compiler & flags & "expander " &
        quoteShell(repoRoot / "tools/expander/expander.nim"))
    discard run("mkdir -p lib/src buildtmp " & quoteShell("output space"))
    writeFile(directory / "lib/src/leaf.nim", "const marker* = \"|expanded|\"\n")
    writeFile(directory / "main.nim", """import os, strutils, posix
import leaf
when not defined(binaryTestFlag):
    {.error: "compiler option was not forwarded".}
writeFile("generation_executed", "ran")
if paramStr(1) == "interactive":
    stdout.write($stdin.readChar & "!\n")
    stdout.flushFile()
    quit(if stdin.readChar == 'A': 0 else: 1)
if paramStr(1) == "signal":
    discard kill(getpid(), SIGTERM)
stdout.write(stdin.readAll)
stdout.write(marker & commandLineParams().join("~"))
stderr.write(getEnv("CPLIB_331_TOKEN") & "|" & getCurrentDir())
stdout.flushFile()
stderr.flushFile()
exitnow(cint(parseInt(paramStr(1))))
""")
    discard run(compiler & flags & "oracle --path:lib/src -d:binaryTestFlag main.nim")
    let withTemp = "TMPDIR=" & quoteShell(directory / "buildtmp") & " "
    let expanderArgs = withTemp & quoteShellCommand(@[directory / "expander",
        "--quiet",
        "--binary", "--nim-compiler:" & getEnv("NIM", "nim"),
        "--nim-option:-d:binaryTestFlag", "--lib:" & directory / "lib",
        "--output-file:" & directory / "output space/embedded.nim", "main.nim"])
    discard run(expanderArgs)
    doAssert not fileExists(directory / "generation_executed")
    doAssert run("find buildtmp -mindepth 1").len == 0
    discard run(compiler & flags & "wrapper " & quoteShell("output space/embedded.nim"))
    let otherCompiler = getEnv("NIM_BINARY_OTHER")
    if otherCompiler.len != 0:
        discard run(quoteShell(otherCompiler) & flags & "wrapper_other " &
            quoteShell("output space/embedded.nim"))
    for options in ["--binary --compress", "--binary --single-line",
            "--binary --original-source", "--nim-option:-d:release",
            "--nim-compiler:nim", "--binary --nim-option:-r",
            "--binary --nim-option:--run:on",
            "--binary --nim-option:--out:other",
            "--binary --nim-option:--nimcache:other",
            "--binary --nim-option:other.nim", "--binary --nim-compiler:",
            "--binary --nim-option:"]:
        writeFile(directory / "unchanged.nim", "sentinel")
        let failed = gorgeEx("cd " & quoteShell(directory) &
            " && " & withTemp & "./expander --quiet -o:unchanged.nim " &
                    options & " main.nim")
        doAssert failed.exitCode != 0
        doAssert readFile(directory / "unchanged.nim") == "sentinel"
        doAssert run("find buildtmp -mindepth 1").len == 0
    writeFile(directory / "invalid.nim", "this is not valid Nim\n")
    let failedCompile = gorgeEx("cd " & quoteShell(directory) &
        " && " & withTemp & "./expander --quiet --binary --nim-compiler:" &
                compiler &
        " -o:unchanged.nim invalid.nim")
    doAssert failedCompile.exitCode != 0
    doAssert "binary compilation failed" in failedCompile.output
    doAssert readFile(directory / "unchanged.nim") == "sentinel"
    doAssert run("find buildtmp -mindepth 1").len == 0
    let missingCompiler = gorgeEx("cd " & quoteShell(directory) &
        " && " & withTemp & "./expander --quiet --binary --nim-compiler:./missing-compiler" &
        " -o:unchanged.nim main.nim")
    doAssert missingCompiler.exitCode != 0
    doAssert readFile(directory / "unchanged.nim") == "sentinel"
    doAssert run("find buildtmp -mindepth 1").len == 0

putEnv("CPLIB_331_TOKEN", "environment-preserved")
proc binaryFolders(): int =
    for kind, path in walkDir(directory):
        if kind == pcDir and path.extractFilename.startsWith("cplib-binary-"):
            inc result

let before = binaryFolders()
var executables = @["oracle", "wrapper"]
if fileExists(directory / "wrapper_other"): executables.add("wrapper_other")
for length in [0, 1, 2, 3, 255, 256, 257, 65535, 65536]:
    var bytes = newString(length)
    for i in 0..<length: bytes[i] = char(i mod 256)
    writeFile(directory / "input", bytes)
    for status in [0, 37, 137, 255]:
        let args = @[$status, "a b", "quote'\"$;()", ""]
        let expectedOutput = bytes & "|expanded|" & args.join("~")
        for executable in executables:
            let command = "cd " & quoteShell(directory) & " && " &
                quoteShellCommand(@[directory / executable] & args) &
                " <input >output 2>error"
            doAssert execCmd(command) == status
            doAssert readFile(directory / "output") == expectedOutput
            doAssert readFile(directory / "error") ==
                "environment-preserved|" & directory
        doAssert binaryFolders() == before

for executable in executables:
    let process = startProcess(directory / executable, workingDir = directory,
        args = ["signal"], options = {})
    var status: cint
    doAssert waitpid(Pid(process.processID), status, 0) != -1
    doAssert WIFSIGNALED(status) and WTERMSIG(status) == SIGTERM
    process.close()
    doAssert binaryFolders() == before
    let interactive = startProcess(directory / executable,
        workingDir = directory,
        args = ["interactive"], options = {})
    interactive.inputStream.write("Q")
    interactive.inputStream.flush()
    doAssert interactive.outputStream.readLine() == "Q!"
    interactive.inputStream.write("A")
    interactive.inputStream.flush()
    doAssert interactive.waitForExit() == 0
    interactive.close()
    doAssert binaryFolders() == before

for length in [4, 5, 6, 7, 255, 256, 257, 65535, 65536]:
    var bytes = "\x7fELF"
    for i in 4..<length: bytes.add(char(i mod 256))
    let generated = binaryProgram(bytes)
    let start = generated.find("decode(\"") + "decode(\"".len
    let finish = generated.find('"', start)
    doAssert decode(generated[start..<finish]) == bytes
for invalid in ["", "a", "ab", "abc", "abcd"]:
    var rejected = false
    try: discard binaryProgram(invalid)
    except ValueError: rejected = true
    doAssert rejected
removeDir(directory)
echo "Hello World"
