---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    ERROR: 1e-6
    PROBLEM: https://atcoder.jp/contests/abc286/tasks/abc286_ex
    links:
    - https://atcoder.jp/contests/abc286/tasks/abc286_ex
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc286/tasks/abc286_ex\n\
    # verification-helper: ERROR 1e-6\nimport sequtils, strutils, std/math\nimport\
    \ cplib/geometry/base\nimport cplib/geometry/polygon\nimport cplib/geometry/intersect\n\
    import cplib/geometry/distance\n\nvar n = stdin.readLine.parseInt\nproc get():\
    \ (int, int) =\n    var s = stdin.readLine.split.map(parseInt)\n    return (s[0],\
    \ s[1])\nvar v = newSeqWith(n, initPoint(get()))\nvar s = initPoint(get())\nvar\
    \ t = initPoint(get())\nproc valid(): bool =\n    for i in 0..<n:\n        var\
    \ p1 = v[i]\n        var p2 = v[(i+1) mod n]\n        if intersect(initSegment(s,\
    \ t), initSegment(p1, p2)): return true\n    return false\nif not valid():\n \
    \   echo sqrt(float(norm(s - t)))\n    quit()\nvar vi = convex_hull(v & @[s, t])\n\
    var pos: int\nfor i in 0..<vi.len:\n    if vi.v[i] == s: (pos = i; break)\nvi.v\
    \ = vi.v[pos..<vi.len] & vi.v[0..<pos]\nfor i in 0..<vi.len:\n    if vi.v[i] ==\
    \ t: (pos = i; break)\nvar a1, a2 = 0.0\nfor i in 0..<pos:\n    a1 += float(norm(vi.v[i],\
    \ vi.v[i+1])).sqrt\n\nfor i in 1..<(vi.len-pos):\n    a2 += float(norm(vi.v[^(i)],\
    \ vi.v[^(i+1)])).sqrt\na2 += float(norm(vi.v[^1], vi.v[0])).sqrt\necho min(a1,\
    \ a2)\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/distance.nim
  - cplib/geometry/distance.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/geometry/convex_hull_abc286ex_test.nim
  requiredBy: []
  timestamp: '2024-03-28 19:09:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/convex_hull_abc286ex_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/convex_hull_abc286ex_test.nim
- /verify/verify/geometry/convex_hull_abc286ex_test.nim.html
title: verify/geometry/convex_hull_abc286ex_test.nim
---
