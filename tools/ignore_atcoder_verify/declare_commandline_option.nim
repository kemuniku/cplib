import macros, strutils

var usage_text* = "usage: ./expander.o"
var help_text* = """
expand a Nim source code.

positional arguments:
    source: Source File

Options:
"""
macro declareCommandlineOption*(name, shortname, description: string, value_expected: bool) =
    let proc_name = ident("is_" & ($`name`).replace("-", "_"))
    quote do:
        proc `proc_name`(kind: CmdLineKind, key, val: string): bool =
            result = (kind == cmdLongOption and key == `name`) or (kind == cmdShortOption and key == `shortname`)
            if result and `value_expected` and val == "":
                raise newException(ValueError, "Value expected for option " & `name`)
        usage_text &= " [-" & `shortname` & "|--" & `name` & "]"
        help_text &= &"    -" & `shortname` & ", --" & `name` & ": " & `description` & "\n"
