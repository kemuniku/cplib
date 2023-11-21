# verification-helper: PROBLEM https://yukicoder.me/problems/no/1469
import sequtils, strutils
import cplib/str/run_length_encode

var s = stdin.readLine
echo s.run_length_encode.mapIt(it[0]).join("")
