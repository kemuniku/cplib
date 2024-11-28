# verification-helper: PROBLEM https://atcoder.jp/contests/arc050/tasks/arc050_d
import sequtils,algorithm,strutils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/str/static_string
import cplib/str/merged_static_string

var N = ii()
var S = stdin.readline().toStaticString()

proc f(S,T:StaticString):int=
    var A = S&T
    var B = T&S
    return cmp(A,B)

var tmp : seq[StaticString]

for i in 0..<(N):
    tmp.add(S[i..<N])

tmp.sort(f)

echo tmp.mapit(it.l + 1).join("\n")