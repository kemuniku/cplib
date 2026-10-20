# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min
import algorithm
import cplib/collections/kinetic_tournament

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
var lines: seq[tuple[a, b: int]]
for i in 0..<n:
    let a = ii()
    let b = ii()
    lines.add((a, b))
var queries: seq[tuple[x, count, index: int]]
for i in 0..<q:
    let t = ii()
    if t == 0:
        let a = ii()
        let b = ii()
        lines.add((a, b))
    else:
        queries.add((ii(), lines.len, queries.len))
queries.sort(proc(l, r: tuple[x, count, index: int]): int = cmp(l.x, r.x))
var answers = newSeq[int](queries.len)
let tree = initKineticTournament(lines, low(int))
for query in queries:
    tree.heaten(query.x)
    answers[query.index] = tree.query(0, query.count)
for answer in answers:
    echo answer
