# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/lichaotree
import cplib/utils/constants

type Segment = tuple[a, b, l, r: int]

proc check(coords: seq[int]) =
    let tree = initLiChaoTree(coords)
    var lines: seq[Segment] = @[]
    proc verify() =
        for x in coords:
            var expected = INF64
            for line in lines:
                if line.l <= x and x < line.r:
                    expected = min(expected, line.a*x + line.b)
            doAssert tree.get_min(x) == expected
    verify()
    for (a, b) in [(0, 0), (-1, 1_600_000_000), (1, -1_600_000_000), (-2, 17), (2, -19)]:
        tree.add_line(a, b)
        lines.add((a, b, low(int), high(int)))
        verify()
    for segment in [
        (-3, 11, 1_400_000_000, 1_800_000_000),
        (4, -20, 1_550_000_000, 1_650_000_000),
        (0, -50, 1_700_000_000, 1_800_000_000),
        (0, -100, 1_800_000_000, 1_900_000_000),
        (0, -100, 1_550_000_000, 1_550_000_000)]:
        tree.add_segment(segment[0], segment[1], segment[2], segment[3])
        lines.add(segment)
        verify()

check(@[1_500_000_000, 1_600_000_000, 1_700_000_000])
check(@[1_500_000_000, 1_700_000_000])
check(@[1_500_000_000, 1_600_000_000, 1_650_000_000, 1_700_000_000])
check(@[1_700_000_000, 1_500_000_000, 1_700_000_000, 1_600_000_000])
check(@[1_700_000_000])
check(@[int(low(int32)), -1, 0, 1, int(high(int32))])

let boundaryTree = initLiChaoTree(@[1_500_000_000, 1_700_000_000])
boundaryTree.add_segment(0, -7, 1_400_000_000, 1_800_000_000)
doAssert boundaryTree.get_min(1_500_000_000) == -7
doAssert boundaryTree.get_min(1_700_000_000) == -7
let emptyTree = initLiChaoTree(newSeq[int]())
emptyTree.add_segment(0, -1, -10, 10)
echo "Hello World"
