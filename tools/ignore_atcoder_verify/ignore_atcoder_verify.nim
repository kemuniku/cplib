import os, re, strformat, strutils, parseopt
import declare_commandline_option

const REPOSITORY_ROOT = "../"
const VERIFY_ROOT_FROM_REPOSITORY_ROOT = "src/verify/"
const VERIFY_ROOT = REPOSITORY_ROOT & VERIFY_ROOT_FROM_REPOSITORY_ROOT

declareCommandlineOption("revert", "r", "Revert verifies", false)
var opt = commandLineParams().join(" ").initOptParser
var revert = false
for kind, key, val in opt.getopt:
    if is_revert(kind, key, val): revert = true
    else:
        var cmd = (if kind == cmdLongOption: "--" else: "-") & key & (if val != "": ": " else: "") & val
        raise newException(ValueError, &"unknown option: {cmd}")

for f in walkDirRec(VERIFY_ROOT):
    var matches = newSeq[string](1)
    var pos = find(f, re"src/verify/(.*).nim$", matches)
    if pos == -1 or matches[0] == "cplib": continue
    var split_filename = f.split("/")
    block:
        var reader = open(f, FileMode.fmRead)
        defer: close(reader)
        var line = readLine(reader)
        if "atcoder" in line:
            if split_filename[^1][0] != '_' and not revert:
                echo &"ignore {f}"
                split_filename[^1] = "_" & split_filename[^1]
            if split_filename[^1][0] == '_' and revert:
                echo &"revert {f}"
                split_filename[^1] = split_filename[^1][1..^1]

    var fn = split_filename.join("/")
    if f != fn:
        var mv_command = &"mv {f} {fn}"
        assert execShellCmd(mv_command) == 0, &"{mv_command} end with non-zero status code"


