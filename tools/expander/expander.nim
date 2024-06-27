import os, parseopt, sequtils, strutils, strformat, logging, sets, deques
import declare_commandline_option

var filename = ""
var lib_dirs = @[""]
var git_urls = @[""]
var single_line = false
var quiet = false
var logger = newConsoleLogger(fmtStr="$time - [$levelname]: "); addHandler(logger)
var loaded_file = initHashset[string]()
var outfile = "combined.nim"

declareCommandlineOption("help", "h", "Show help text", false)
declareCommandlineOption("single-line", "s", "Single line import", false)
declareCommandlineOption("lib", "l", "Path to libarary, any number can be passed", true)
declareCommandlineOption("git-url", "g", "GitHub URL of the library, any number can be passed, must be the same as --lib argument number", true)
declareCommandlineOption("quiet", "q", "Expander run without output logs", false)
declareCommandlineOption("output-file", "o", "Output file path", false)
usage_text &= " source\n\n"

var opt = commandLineParams().join(" ").initOptParser
for kind, key, val in opt.getopt:
    if is_help(kind, key, val):
        echo usage_text & help_text
        quit()
    if kind == cmdArgument: filename = key
    elif is_single_line(kind, key, val): single_line = true
    elif is_lib(kind, key, val): lib_dirs.add((if val.endsWith("/"): val else: val & "/") & "src/")
    elif is_git_url(kind, key, val): git_urls.add(if val.endsWith("/"): val else: val & "/")
    elif is_quiet(kind, key, val): quiet = true
    elif is_output_file(kind, key, val): outfile = val
    else:
        var cmd = (if kind == cmdLongOption: "--" else: "-") & key & (if val != "": ": " else: "") & val
        raise newException(ValueError, &"unknown option: {cmd}")
assert filename != "", "filename must not be empty"
for i in 1..<lib_dirs.len:
    if i >= git_urls.len: git_urls.add("")
    if not quiet: info(&"Library Directory: {lib_dirs[i]}, git_url: {git_urls[i]}")


var combined = newSeq[string]()
if single_line:
    combined.add("import macros;macro ImportExpand(s:untyped):untyped = parseStmt($s[2])")
proc read_source(dir, filename, git_url: string, is_main, direct_import: bool): seq[string] =
    var fullfilename = dir & filename & (if filename.endsWith(".nim"): "" else: ".nim")
    if fullfilename in loaded_file: return
    if not quiet: info(&"file: {fullfilename}")
    loaded_file.incl(fullfilename)
    var result_lines = newSeq[string]()
    var lines: Deque[string]
    block:
        var file = open(fullfilename, FileMode.fmRead)
        defer: close(file)
        lines = file.readAll.split("\n").toDeque
    var is_example = false
    var example_indent_width: int
    while lines.len > 0:
        var line = lines.popFirst()
        var indent = (proc(line: var string): string =
            var indent_count = 0
            for i in 0..<line.len:
                if line[i] != ' ': break
                indent_count += 1
            line = line.substr(indent_count, line.len)
            return " ".repeat(indent_count)
        )(line)
        if is_example and not line.isEmptyOrWhitespace and indent.len <= example_indent_width:
            is_example = false
        proc process_multi_import_include_line(prefix: string): bool =
            if line.startsWith(prefix):
                line.removePrefix(prefix)
                var libs = line.split(",").mapIt(strip(it))
                proc get_lib_content(lib: string): seq[string] =
                    for i in 0..<lib_dirs.len:
                        var lib_dir = lib_dirs[i]
                        if fileExists(lib_dir & lib & ".nim"):
                            var git_url = git_urls[i]
                            for item in read_source(lib_dir, lib, git_url, false, is_main):
                                result_lines.add(item)
                            return newSeq[string]()
                    return @[&"{indent}{prefix} {lib}"]
                for lib in libs:
                    for line in get_lib_content(lib):
                        result_lines.add(line)
                return true
            return false
        if process_multi_import_include_line("import"): continue
        if process_multi_import_include_line("include"): continue
        if is_example or line.startsWith("##"): continue
        if line.startsWith("runnableExamples:"):
            is_example = true
            example_indent_width = indent.len
            continue
        result_lines.add(indent & line)
    if direct_import and single_line:
        for line in result_lines.mitems:
            line = line.replace("\\", "\\\\")
            line = line.replace("\"", "\\\"")
        var s0 = result_lines.join("\\n")
        combined.add(&"# source: {git_url}src/{filename}.nim")
        combined.add(&"ImportExpand \"{filename}\" <=== \"\"\"{s0}\"\"\"")
        return newSeq[string]()
    if is_main or not single_line:
        if not is_main: combined.add(&"# source: {git_url}src/{filename}.nim")
        else: combined.add("")
        for line in result_lines: combined.add(line)
        return newSeq[string]()
    return result_lines
discard read_source("./", filename, "", true, false)
block:
    var file = open(outfile, fmWrite)
    defer: close(file)
    file.write(combined.join("\n"))
