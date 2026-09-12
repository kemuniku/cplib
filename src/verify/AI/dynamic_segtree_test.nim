# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sets
import cplib/collections/dynamic_segtree

var rng = initRand(20260912)

block:
    let st = newDynamicSegWith(0, l + r, 0)
    assert st.len == 0
    assert st.get_all() == 0
    assert st.get(0, 0) == 0
    assert st[0..<0] == 0
    assert st.node_count == 0

for n in [1, 2, 3, 7, 16, 31, 64, 99]:
    let st = newDynamicSegWith(n, l + r, 0)
    var expected = newSeq[int](n)
    var touched = initHashSet[int]()
    for step in 0..<1500:
        let p = rng.rand(n - 1)
        let value = rng.rand(-100..100)
        st[p] = value
        expected[p] = value
        touched.incl(p)
        var a = rng.rand(n)
        var b = rng.rand(n)
        if a > b: swap(a, b)
        var total, part: int
        for i in 0..<n:
            total += expected[i]
            if a <= i and i < b: part += expected[i]
            assert st[i] == expected[i]
        assert st.get(a, b) == part
        assert st[a..<b] == part
        assert st.get_all() == total
        assert st.node_count == touched.len

block:
    let n = 37
    let st = newDynamicSegWith(n, l & r, "")
    var expected = newSeq[string](n)
    for step in 0..<500:
        let p = rng.rand(n - 1)
        let value = if step mod 5 == 0: "" else: $char(ord('a') + rng.rand(25))
        st.update(p, value)
        expected[p] = value
        for a in 0..n:
            var part = ""
            for b in a..n:
                assert st.get(a, b) == part
                if b < n: part.add(expected[b])

block:
    let st = newDynamicSegWith(11, min(l, r), int.high)
    assert st[5] == int.high
    st[3] = 9
    st[8] = -2
    assert st.get(0, 3) == int.high
    assert st[3..7] == 9
    assert st.get_all() == -2
    st[8] = int.high
    assert st.get_all() == 9
    assert st.node_count == 2

for descending in [false, true]:
    let n = int.high
    let st = newDynamicSegWith(n, l + r, 0)
    let stride = n div 8192
    for i in 0..<4096:
        let p = if descending: n - 1 - i * stride else: i * stride
        st[p] = 1
        assert st.node_count == i + 1
    assert st.get_all() == 4096
    assert st.get(0, n) == 4096
    for i in 0..<4096:
        let p = if descending: n - 1 - i * stride else: i * stride
        assert st[p] == 1
        assert st.get(p, p + 1) == 1
        assert st.get(p + 1, p + min(n - p, stride)) == 0
        st[p] = 0
        assert st.node_count == 4096
    assert st.get_all() == 0

echo "Hello World"
