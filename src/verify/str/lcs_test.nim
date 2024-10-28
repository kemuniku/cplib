# verification-helper: PROBLEM https://atcoder.jp/contests/tessoku-book/tasks/tessoku_book_t

import sequtils,strutils
import cplib/str/lcs

var S = stdin.readline().toseq()
var T = stdin.readline().toseq()
echo LCS(S,T)