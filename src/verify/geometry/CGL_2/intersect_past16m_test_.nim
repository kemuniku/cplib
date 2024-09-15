#FIXME: remove "_" in filename after PAST 16 testcases added to AtCoder Dropbox
# verification-helper: PROBLEM https://atcoder.jp/contests/past202309-open/tasks/past202309_m
include cplib/geometry/intersect
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

proc get(): Point[float] = initPoint(float(ii()), float(ii()))
var s1, s2 = initSegment(get(), get())
if intersect(s1, s2): echo "Yes"
else: echo "No"
