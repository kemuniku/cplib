import os, re, strformat

const LIBRARY_ROOT = "../src/cplib/"
const GITHUB_REPOSITORY = "https://github.com/kemuniku/cplib"
var import_string = """
{.warning[UnusedImport]: off.}
{.hint[XDeclaredButNotUsed]: off.}
"""
for f in walkDirRec(LIBRARY_ROOT):
    var matches = newSeq[string](1)
    var pos = find(f, re"src/cplib/(.*).nim$", matches)
    if pos == -1 or matches[0] == "cplib": continue
    import_string &= &"import {matches[0]}\n"

block:
    var f = open(LIBRARY_ROOT & "cplib.nim", FileMode.fmWrite)
    defer: close(f)
    f.write(import_string)

if dirExists(&"{LIBRARY_ROOT}htmldocs"):
    removeDir(&"{LIBRARY_ROOT}hemldocs")
var doc_gen_command = &"cd {LIBRARY_ROOT} && nim doc --project --index:off --git.url:{GITHUB_REPOSITORY} --outdir:htmldocs cplib.nim"
assert execShellCmd(doc_gen_command) == 0, &"{doc_gen_command} end with non-zero status code"

# modify content in cplib.html for readability
var newcontent: string
block:
    var f = open(LIBRARY_ROOT & "htmldocs/cplib.html", FileMode.fmRead)
    defer: close(f)
    var content = f.readAll
    newcontent = replacef(content, re"""(<a class="reference external" href="[A-z/]*\.html">[A-z/]*</a>),""", "$1<br/>")
block:
    var f = open(LIBRARY_ROOT & "htmldocs/cplib.html", FileMode.fmWrite)
    defer: close(f)
    f.write(newcontent)


