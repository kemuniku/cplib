import os, osproc, streams, base64, strutils
import std/tempfiles

proc binaryProgram*(binary: string): string =
    ## ELF実行ファイルをBase64で埋め込むLinux用Nimソースを生成する。時間・領域 O(B)。
    if binary.len < 4 or binary[0..<4] != "\x7fELF":
        raise newException(ValueError, "--binary requires a Linux ELF executable")
    result = """# https://github.com/kemuniku/cplib
when not defined(linux):
    {.error: "This binary wrapper requires Linux".}
import os, osproc, base64, posix
import std/tempfiles

proc cplibRunBinary(): tuple[code, signal: cint] =
    # 作業ディレクトリ内の通常ファイルを実行し、終了後に削除する。
    let directory = createTempDir("cplib-binary-", "", getCurrentDir())
    defer: removeDir(directory)
    setFilePermissions(directory, {fpUserRead, fpUserWrite, fpUserExec})
    let executable = directory / "program"
    writeFile(executable, decode(""" & escape(encode(binary)) & """))
    setFilePermissions(executable, {fpUserRead, fpUserWrite, fpUserExec})
    let process = startProcess(executable, args=commandLineParams(), options={poParentStreams})
    defer: process.close()
    var status: cint
    while waitpid(Pid(process.processID), status, 0) == -1:
        if errno != EINTR: raiseOSError(osLastError())
    if WIFSIGNALED(status):
        result.signal = WTERMSIG(status)
    else:
        result.code = WEXITSTATUS(status)

let cplibStatus = cplibRunBinary()
if cplibStatus.signal != 0:
    signal(cplibStatus.signal, SIG_DFL)
    discard kill(getpid(), cplibStatus.signal)
    exitnow(cint(128 + cplibStatus.signal))
exitnow(cplibStatus.code)
"""

proc compileBinaryProgram*(source, compiler, sourceDirectory: string;
                           options: seq[string]): string =
    ## 展開済みソースをコンパイルして埋め込む。コンパイルを除き時間・領域 O(S+B)。
    when not defined(linux):
        raise newException(ValueError, "--binary generation requires Linux")
    if compiler.len == 0:
        raise newException(ValueError, "--nim-compiler must not be empty")
    for option in options:
        if not option.startsWith("-"):
            raise newException(ValueError, "--nim-option must be a compiler option")
        let key = option.split({':', '='})[0].toLowerAscii.replace("_",
                "").replace("-", "")
        if key in ["r", "run", "eval", "out", "o", "outdir", "nimcache"]:
            raise newException(ValueError, "--nim-option cannot change execution or output paths")
    let directory = createTempDir("cplib-binary-build-", "")
    defer: removeDir(directory)
    let input = directory / "expanded.nim"
    let executable = directory / "program"
    writeFile(input, source)
    let args = @["cpp", "-d:release", "--opt:speed", "--multimethods:on",
        "--hints:off", "--warning[SmallLshouldNotBeUsed]:off",
        "--path:" & sourceDirectory, "--path:" & getCurrentDir()] & options &
        @["--nimcache:" & directory / "cache", "--out:" & executable, input]
    let process = startProcess(compiler, args = args,
        options = {poUsePath, poStdErrToStdOut})
    defer: process.close()
    process.inputStream.close()
    let diagnostics = process.outputStream.readAll()
    if process.waitForExit() != 0:
        raise newException(ValueError, "binary compilation failed:\n" & diagnostics)
    result = binaryProgram(readFile(executable))
