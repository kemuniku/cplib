import os, strutils, strformat

const LIBRARY_ROOT = "../src/cplib/"
for filename in walkDirRec(LIBRARY_ROOT):
    if not filename.endsWith(".nim"): continue
    var command = &"nimpretty --maxLineLen:300 {filename.absolutePath}"
    assert execShellCmd(command) != 0, &"{command} end with non-zero status code"
