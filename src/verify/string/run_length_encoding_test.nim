# verification-helper: PROBLEM https://yukicoder.me/problems/no/1469
include cplib/tmpl/citrus
import cplib/string/string_utils

var s = input(string)
print(s.run_length_encode.mapIt(it[0]).join(""))
