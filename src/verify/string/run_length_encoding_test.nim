# verify-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=ALDS1_4_B
include cplib/tmpl/citrus
import cplib/string/string_utils

var s = input(string)
print(s.run_length_encode.mapIt(it[0]).join(""))
