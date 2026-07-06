# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, tables
import cplib/collections/defaultdict

var d = initDefaultDict[string, int](0)
assert d.len == 0
assert d["missing"] == 0
assert d.len == 1
d["a"] += 2
d["b"] = 5
assert d["a"] == 2
assert d.hasKey("b")
assert d.contains("a")
var keys: seq[string]
for k in d.keys:
  keys.add(k)
keys.sort()
assert keys == @["a", "b", "missing"]
var vals: seq[int]
for v in d.values:
  vals.add(v)
vals.sort()
assert vals == @[0, 2, 5]
for k, v in d.mpairs:
  if k == "a":
    v = 7
assert d["a"] == 7
var popped = 0
assert d.pop("a", popped)
assert popped == 7
assert d.take("b", popped)
assert popped == 5
d.del("missing")
assert d.len == 0

let c = toDefaultDict({"x": 1, "y": 2}.toTable, -1)
assert c["x"] == 1
assert c["z"] == -1
let e = toDefaultDict([("x", 1), ("y", 2)], -1)
assert e == c
assert $e == """{"x": 1, "y": 2}""" or $e == """{"y": 2, "x": 1}"""
d.clear()
assert d.len == 0
