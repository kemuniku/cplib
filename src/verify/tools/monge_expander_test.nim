# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import os, strutils

when false:
    import cplib/utils/larsch
    import cplib/utils/smawk
    import cplib/graph/monge_shortest_path
    import "../tools/expander/expander.nim"
    import "../tools/expander/compression.nim"
    import "../tools/expander/declare_commandline_option.nim"

const repoRoot = currentSourcePath().parentDir.parentDir.parentDir.parentDir

proc runCommand(command, directory: string): string {.compileTime.} =
    let executed = gorgeEx("cd " & quoteShell(directory) & " && " & command)
    doAssert executed.exitCode == 0, command & "\n" & executed.output
    executed.output

static:
    let created = gorgeEx("mktemp -d -t cplib-monge-expand-XXXXXXXX")
    doAssert created.exitCode == 0
    let directory = created.output.strip
    let compiler = quoteShell(getEnv("NIM", "nim"))
    let expander = directory / "expander"
    discard runCommand(compiler & " cpp --hints:off -d:release --nimcache:" &
        quoteShell(directory / "expander-cache") & " -o:" & quoteShell(
                expander) &
        " " & quoteShell(repoRoot / "tools/expander/expander.nim"), directory)
    let source = """
import cplib/utils/larsch
import cplib/utils/smawk
import cplib/graph/monge_shortest_path
proc cost(i, j: int): int = (j - i) * (j - i) - 3
let paths = mongeShortestPaths(7, cost, 0, high(int))
doAssert paths.costs[6] == -12
doAssert paths.pathTo(6) == @[0, 1, 2, 3, 4, 5, 6]
let exact = restoreMongeShortestPathsExactEdges(7, 2, cost, 0, high(int))
doAssert exact.costs[6] == 12
doAssert exact.pathTo(6) == @[0, 3, 6]
doAssert mongeShortestPathsExactEdges(7, 0, cost, 0, high(int))[0] == 0
proc compare(row, oldCol, newCol: int): bool = newCol > oldCol
var search = initLarsch(8, compare)
for row in 0..<8: doAssert search.next() == row
proc transition(to, source, finalized: int): int = finalized + cost(source, to)
let dp = onlineTotallyMonotoneDP(7, 0, transition)
doAssert dp.costs == paths.costs
let minima = smawk(3, 3, compare)
doAssert minima == @[2, 2, 2]
"""
    writeFile(directory / "main.nim", source)
    let flags = " cpp -r --hints:off -d:release --nimcache:" &
        quoteShell(directory / "program-cache") & " -o:" & quoteShell(
                directory / "program")
    discard runCommand(compiler & flags & " --path:" & quoteShell(repoRoot /
            "src") &
        " main.nim", directory)
    for options in ["", "--single-line", "--compress",
            "--compress --original-source"]:
        discard runCommand(quoteShell(expander) & " --quiet --lib:" &
                quoteShell(repoRoot) &
            " " & options & " main.nim", directory)
        discard runCommand(compiler & flags & " combined.nim", directory)
    doAssert gorgeEx("rm -rf -- " & quoteShell(directory)).exitCode == 0

echo "Hello World"
