# verification-helper: PROBLEM https://judge.yosupo.jp/problem/suffixarray
import cplib/str/static_string

import algorithm,sequtils,strutils
var S = stdin.readLine().toStaticString()
var tmp = S.initSuffixArray()

echo tmp.mapit(it.l).join(" ")