# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import os, strutils

# verify-helperの依存追跡用。実際のexpanderは別プロセスでコンパイルする。
when false:
    import "../tools/expander/expander.nim"
    import "../tools/expander/compression.nim"
    import "../tools/expander/declare_commandline_option.nim"

const repoRoot = currentSourcePath().parentDir.parentDir.parentDir.parentDir

proc runCommand(command, directory: string): string {.compileTime.} =
    let executed = gorgeEx("cd " & quoteShell(directory) & " && " & command)
    doAssert executed.exitCode == 0, command & "\n" & executed.output
    executed.output

# コンパイル時に検査し、実行時の10秒制限に外部コンパイルを含めない。
static:
    let created = gorgeEx("mktemp -d -t cplib-expander-XXXXXXXX")
    doAssert created.exitCode == 0
    let directory = created.output.strip
    let nim = getEnv("NIM", "nim")
    let compiler = quoteShell(nim)
    let expander = directory / "expander"
    discard runCommand(compiler & " cpp --hints:off -d:release --nimcache:" &
        quoteShell(directory / "expander-cache") & " -o:" & quoteShell(
                expander) &
        " " & quoteShell(repoRoot / "tools/expander/expander.nim"), directory)
    proc checkSource(source: string; files: seq[(string, string)];
                     fragments: seq[string];
                             compileOriginal: bool) {.compileTime.} =
        for entry in files: writeFile(directory / entry[0], entry[1])
        writeFile(directory / "main.nim", source)
        let flags = " cpp -r --hints:off --nimcache:" & quoteShell(directory /
                "program-cache") &
            " -o:" & quoteShell(directory / "program") & " --path:. "
        if compileOriginal:
            discard runCommand(compiler & flags & "main.nim", directory)
        for options in ["", "--original-source", "--single-line", "--compress",
                "--compress --original-source"]:
            if not compileOriginal and "--original-source" in options: continue
            discard runCommand(quoteShell(expander) & " --quiet " & options &
                    " main.nim", directory)
            let expanded = readFile(directory / "combined.nim")
            if "--original-source" in options:
                doAssert expanded.startsWith("template originalSource() =\n " &
                    source.splitLines()[0])
            if options == "" or options == "--original-source":
                for fragment in fragments: doAssert fragment in expanded
            discard runCommand(compiler & flags & "combined.nim", directory)
    checkSource("import#[comment]# \"strutils\"\ninclude \"quoted\"\ndoAssert \"foo\".toUpperAscii == \"FOO\"\ndoAssert quoted == 7\n",
        @[("quoted.nim", "const quoted = 7\n")],
        @["import #[comment]# \"strutils\"", "include \"quoted\""], true)
    checkSource("var importance = 0\nvar include_count = 0\nvar import2 = 0\nvar includeé = 0\nproc imported() = inc importance\nproc included() = inc include_count\nimportance = 1\ninclude_count = 1\nimport2 = 2\nincludeé = 3\nimported()\nincluded()\nblock:\n  imported()\n  included()\ndoAssert importance == 3\ndoAssert include_count == 3\ndoAssert import2 == 2\ndoAssert includeé == 3\n",
        @[],
        @["var importance = 0\nvar include_count = 0\nvar import2 = 0\nvar includeé = 0\nproc imported() = inc importance\nproc included() = inc include_count\nimportance = 1\ninclude_count = 1\nimport2 = 2\nincludeé = 3\nimported()\nincluded()\nblock:\n  imported()\n  included()\ndoAssert importance == 3\ndoAssert include_count == 3\ndoAssert import2 == 2\ndoAssert includeé == 3\n"], true)
    checkSource("import first, second\nimport  third\ninclude fourth\nblock:\n  include  fifth\n  doAssert fifthValue == 5\ndoAssert firstValue + secondValue + thirdValue + fourthValue == 10\n",
        @[("first.nim", "const firstValue* = 1\n"), ("second.nim",
                "const secondValue* = 2\n"), ("third.nim",
                "const thirdValue* = 3\n"), ("fourth.nim",
                "const fourthValue = 4\n"), ("fifth.nim",
                "const fifthValue = 5\n")],
        @["const firstValue* = 1", "const secondValue* = 2",
                "const thirdValue* = 3", "const fourthValue = 4",
                "  const fifthValue = 5"], true)
    checkSource("import\tfirst\ninclude\tsecond\ndoAssert firstValue + secondValue == 3\n",
        @[("first.nim", "const firstValue* = 1\n"), ("second.nim",
                "const secondValue = 2\n")],
        @["const firstValue* = 1", "const secondValue = 2"], false)
    discard runCommand("mkdir -p src", directory)
    writeFile(directory / "src" / "demo.nim", "const answer = 7\n")
    writeFile(directory / "main.nim", "include demo\ndoAssert answer == 7\n")
    discard runCommand("git init -q", directory)
    discard runCommand("git add src/demo.nim", directory)
    discard runCommand("git -c user.name=verify -c user.email=verify@example.com commit -qm initial", directory)
    let commit = runCommand("git rev-parse HEAD", directory).strip
    let permalink = "https://github.com/example/library/blob/" & commit & "/src/demo.nim"
    for repositoryUrl in ["https://github.com/example/library.git",
            "https://github.com/example/library/blob/main",
            "https://github.com/example/library/tree/main"]:
        let expandWithUrl = quoteShell(expander) &
            " --quiet -l:. -g:" & quoteShell(repositoryUrl) & " main.nim"
        discard runCommand(expandWithUrl, directory)
        doAssert "# source: " & permalink in readFile(directory / "combined.nim")
    writeFile(directory / "src" / "demo.nim", "const answer = 8\n")
    writeFile(directory / "main.nim", "include demo\ndoAssert answer == 8\n")
    discard runCommand(quoteShell(expander) &
        " --quiet -l:. -g:https://github.com/example/library/blob/main main.nim", directory)
    let modified = readFile(directory / "combined.nim")
    doAssert "# source: " & permalink in modified
    doAssert "const answer = 8" in modified
    let removed = gorgeEx("rm -rf -- " & quoteShell(directory))
    doAssert removed.exitCode == 0

echo "Hello World"
