import os, re, parseopt, strutils, strformat, logging, sets, deques
import declare_commandline_option

var git_url = ""
var filename = ""
var lib_dir = @[getCurrentDir()]
var indent_width = 4
var single_line = false
var quiet = false
var expand_atcoder = false
var logger = newConsoleLogger(fmtStr="$time - [$levelname]: "); addHandler(logger)
var loaded_file = initHashset[string]()

declareCommandlineOption("help", "h", "Show help text", false)
declareCommandlineOption("single-line", "s", "Single line import", false)
declareCommandlineOption("lib", "l", "Path to libarary, any number can be passed", true)
declareCommandlineOption("expand-atcoder", "e", "expand Nim-ACL", false)
declareCommandlineOption("git-url", "g", "GitHub URL of the library", true)
declareCommandlineOption("quiet", "q", "Expander run without output logs", false)
declareCommandlineOption("indent-width", "i", "Indent width", true)
usage_text &= " source\n\n"

var opt = commandLineParams().join(" ").initOptParser
for kind, key, val in opt.getopt:
    info(kind, " key: ", key, " val: ", val)
    if is_help(kind, key, val):
        echo usage_text & help_text
        quit()
    if kind == cmdArgument: filename = key
    elif is_single_line(kind, key, val): single_line = true
    elif is_expand_atcoder(kind, key, val): expand_atcoder = true
    elif is_lib(kind, key, val): lib_dir.add(val)
    elif is_git_url(kind, key, val): git_url = val
    elif is_quiet(kind, key, val): quiet = true
    elif is_indent_width(kind, key, val): indent_width = val.parseInt
    else:
        var cmd = (if kind == cmdLongOption: "--" else: "-") & key & (if val != "": ": " else: "") & val
        raise newException(ValueError, &"unknown option: {cmd}")
assert filename != "", "filename must not be empty"

var lines: Deque[string]
block:
    var file = open(filename, FileMode.fmRead)
    defer: close(file)
    lines = file.readAll.split("\n").toDeque