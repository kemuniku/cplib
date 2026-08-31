# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/warshall_floyd_avx
import cplib/utils/constants

var g = initWeightedDirectedGraph(3)
g.add_edge(0, 1, 2)
g.add_edge(1, 2, 3)
g.add_edge(0, 2, 10)
let wf = g.warshall_floyd()
assert not wf.negative_cycle
assert wf.d[0][2] == 5

# Exercise both the four-lane AVX2 loop and its scalar tail with costs which
# cannot be represented by int32.
var wide = initWeightedDirectedGraph(10)
wide.add_edge(0, 1, int(3_000_000_000))
wide.add_edge(1, 2, int(4_000_000_000))
wide.add_edge(2, 9, int(5_000_000_000))
wide.add_edge(0, 9, int(20_000_000_000))
let wideWf = wide.warshall_floyd()
assert not wideWf.negative_cycle
assert wideWf.d[0][2] == int(7_000_000_000)
assert wideWf.d[0][9] == int(12_000_000_000)
assert wideWf.d[9][0] == INF64

let empty = initWeightedDirectedGraph(0).warshall_floyd()
assert not empty.negative_cycle
assert empty.d.len == 0

# Cross a cache-block boundary in every phase of the blocked algorithm.
var blocked = initWeightedDirectedGraph(193)
for i in 0..<192:
    blocked.add_edge(i, i + 1, 1)
let blockedWf = blocked.warshall_floyd()
assert not blockedWf.negative_cycle
assert blockedWf.d[0][192] == 192
assert blockedWf.d[192][0] == INF64

# int32 uses eight AVX2 lanes and a separately tuned cache block.
var g32 = initWeightedDirectedGraph(11, int32)
g32.add_edge(0, 1, 300_000_000.int32)
g32.add_edge(1, 2, 400_000_000.int32)
g32.add_edge(2, 10, 50_000_000.int32)
g32.add_edge(0, 10, 900_000_000.int32)
let wf32 = g32.warshall_floyd()
assert not wf32.negative_cycle
assert wf32.d[0][2] == 700_000_000.int32
assert wf32.d[0][10] == 750_000_000.int32
assert wf32.d[10][0] == INF32

let empty32 = initWeightedDirectedGraph(0, int32).warshall_floyd()
assert not empty32.negative_cycle
assert empty32.d.len == 0

var blocked32 = initWeightedDirectedGraph(257, int32)
for i in 0..<256:
    blocked32.add_edge(i, i + 1, 1.int32)
let blockedWf32 = blocked32.warshall_floyd()
assert not blockedWf32.negative_cycle
assert blockedWf32.d[0][256] == 256.int32
assert blockedWf32.d[256][0] == INF32

var static32 = initWeightedDirectedStaticGraph(4, int32)
static32.add_edge(0, 1, 2.int32)
static32.add_edge(1, 2, 3.int32)
static32.add_edge(2, 3, 4.int32)
static32.add_edge(0, 3, 20.int32)
static32.build()
let staticWf32 = static32.warshall_floyd()
assert not staticWf32.negative_cycle
assert staticWf32.d[0][3] == 9.int32

var ng = initWeightedDirectedGraph(2)
ng.add_edge(0, 1, -2)
ng.add_edge(1, 0, -2)
assert ng.warshall_floyd().negative_cycle
