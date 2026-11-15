---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import math, strutils, random\nimport cplib/geometry/base\nimport cplib/geometry/circle\n\
    import cplib/math/bigint\nimport cplib/math/int128\nimport cplib/math/fractions\n\
    \nproc bi(x: int): BigInt = initBigInt(x)\nproc rat(n, d: int): Fraction[BigInt]\
    \ = initFraction(bi(n), bi(d))\nproc close(a, b: float): bool = abs(a - b) <=\
    \ 2e-8 * max(1.0, max(abs(a), abs(b)))\ntemplate rejects(body: untyped) =\n  \
    \  block:\n        var rejected = false\n        try: body\n        except ValueError:\
    \ rejected = true\n        doAssert rejected\n\nproc checkType[T](zero, one, two,\
    \ minusOne: T) =\n    let o = initPoint(zero, zero)\n    let a = initPoint(one,\
    \ zero)\n    let b = initPoint(zero, one)\n    let c = initPoint(minusOne, zero)\n\
    \    let circle = initCircle(a, b, c)\n    static:\n        doAssert typeof(circle)\
    \ is Circle[T]\n        doAssert typeof(initCircle(o, 1)) is Circle[T]\n     \
    \   doAssert typeof(initCircle(o, a)) is Circle[T]\n        doAssert typeof(initDiameterCircle(o,\
    \ a)) is Circle[T]\n        when T is Fraction:\n            doAssert typeof(circle.radius_squared_exact.num)\
    \ is typeof(zero.num)\n        else:\n            doAssert typeof(circle.radius_squared_exact)\
    \ is Fraction[T]\n    doAssert circle.points == [a, b, c]\n    doAssert $toExactPoint(initPoint(circle.point_scale,\
    \ circle.point_scale)).x == \"1/1\"\n    let diameter = initDiameterCircle(o,\
    \ a)\n    doAssert $diameter.radius_squared_exact == \"1/4\"\n    doAssert $diameter.center_exact.x\
    \ == \"1/2\"\n    doAssert $toExactPoint(initPoint(diameter.point_scale, diameter.point_scale)).x\
    \ == \"2/1\"\n    for p in diameter.points_exact: doAssert diameter.on_circle(p)\n\
    \    doAssert circle == initCircle(c, b, a)\n    doAssert circle == initCircle(b,\
    \ c, a)\n    doAssert circle == initCircle(o, 1)\n    doAssert circle == initCircle(o,\
    \ a)\n    doAssert ($circle.center_exact.x == \"0/1\" and $circle.center_exact.y\
    \ == \"0/1\")\n    doAssert $circle.radius_squared_exact == \"1/1\"\n    doAssert\
    \ circle.contains(o) and circle.classify(o) == circleInside\n    doAssert circle.on_circle(a)\
    \ and circle.classify(a) == circleBoundary\n    doAssert not circle.contains(initPoint(two,\
    \ zero))\n    doAssert circle.classify(initPoint(two, zero)) == circleOutside\n\
    \    doAssert close(circle.center_approx.x, 0) and close(circle.radius_approx,\
    \ 1)\n    doAssert close(circle.toFloatCircle.radius, 1)\n    let z = initCircle(o,\
    \ o, o)\n    doAssert z == initCircle(o, 0) and z == initCircle(o, o)\n    doAssert\
    \ z.on_circle(o) and z.classify(o) == circleBoundary\n    doAssert not z.contains(a)\
    \ and z.classify(a) == circleOutside\n    doAssert $z.radius_squared_exact ==\
    \ \"0/1\"\n    doAssert z.radius_approx == 0\n    doAssert intersection_count(z,\
    \ z) == 1\n    doAssert intersection_count(circle, circle) == -1\n    doAssert\
    \ common_tangent_count(circle, circle) == -1\n    doAssert tangent_count(z, o)\
    \ == -1\n    doAssert tangent_count(z, a) == 1\n    doAssert tangent_count(circle,\
    \ o) == 0\n    doAssert tangent_count(circle, a) == 1\n    doAssert tangent_count(circle,\
    \ initPoint(two, zero)) == 2\n    rejects: discard initCircle(a, a, b)\n    rejects:\
    \ discard initCircle(a, o, c)\n    rejects: discard initCircle(o, -1)\n    rejects:\
    \ discard default(Circle[T]).contains(o)\n    let line = Line[T](s: a, t: c)\n\
    \    doAssert intersection_count(circle, line) == 2\n    doAssert intersection_count(circle,\
    \ Line[T](s: b, t: initPoint(one, one))) == 1\n    doAssert intersection_count(circle,\
    \ Line[T](s: initPoint(zero, two), t: initPoint(one, two))) == 0\n    doAssert\
    \ intersection_count(circle, Segment[T](s: a, t: o)) == 1\n    doAssert intersection_count(circle,\
    \ Segment[T](s: a, t: a)) == 1\n    doAssert intersection_count(circle, Segment[T](s:\
    \ o, t: o)) == 0\n    doAssert intersection_count(circle, Segment[T](s: c, t:\
    \ a)) == 2\n    rejects: discard intersection_count(circle, Line[T](s: a, t: a))\n\
    \    for segment in [Segment[T](s: a, t: o), Segment[T](s: c, t: a), Segment[T](s:\
    \ a, t: a), Segment[T](s: o, t: o)]:\n        doAssert cross_points_approx(circle,\
    \ segment).points.len == intersection_count(circle, segment)\n    let intersections\
    \ = cross_points_approx(circle, line)\n    doAssert intersections.points.len ==\
    \ 2\n    for p in intersections.points:\n        doAssert close(hypot(p.x, p.y),\
    \ 1)\n    doAssert cross_points_approx(circle, circle).kind == circleInfinite\n\
    \    doAssert cross_points_approx(z, z).points.len == 1\n    doAssert tangent_lines_approx(z,\
    \ o).kind == circleInfinite\n    doAssert tangent_lines_approx(z, a).tangents.len\
    \ == 1\n    for p in [a, initPoint(two, zero)]:\n        let tangents = tangent_lines_approx(circle,\
    \ p)\n        doAssert tangents.tangents.len == tangent_count(circle, p)\n   \
    \     for tangent in tangents.tangents:\n            doAssert close(hypot(tangent.first.x,\
    \ tangent.first.y), 1)\n            doAssert close(hypot(tangent.direction.x,\
    \ tangent.direction.y), 1)\n            doAssert close(dot(tangent.first, tangent.direction),\
    \ 0)\n            doAssert close(cross(tangent.second - tangent.first, tangent.direction),\
    \ 0)\n\ncheckType(0, 1, 2, -1)\ncheckType(0'i64, 1'i64, 2'i64, -1'i64)\ncheckType(bi(0),\
    \ bi(1), bi(2), bi(-1))\ncheckType(parseInt128(\"0\"), parseInt128(\"1\"), parseInt128(\"\
    2\"), parseInt128(\"-1\"))\ncheckType(initFraction(0), initFraction(1), initFraction(2),\
    \ initFraction(-1))\ncheckType(initFraction(parseInt128(\"0\")), initFraction(parseInt128(\"\
    1\")), initFraction(parseInt128(\"2\")), initFraction(parseInt128(\"-1\")))\n\
    checkType(rat(0, 1), rat(1, 1), rat(2, 1), rat(-1, 1))\n\nlet translated = initCircle(initPoint(1000000,\
    \ 1000000), initPoint(1000002, 1000000), initPoint(1000001, 1000001))\ndoAssert\
    \ translated.center_exact == initPoint(initFraction(1000001), initFraction(1000000))\n\
    doAssert translated.classify(initPoint(1000001, 1000000)) == circleInside\nlet\
    \ generated = initCircle(initPoint(1000000, 1000000), 1000)\nstatic: doAssert\
    \ typeof(generated) is Circle[int]\ndoAssert generated.points[0].x == 1001000\n\
    doAssert $generated.radius_squared_exact == \"1000000/1\"\nlet denominator = initCircle(initPoint(Fraction[int](num:\
    \ 1, den: -2), Fraction[int](num: -1, den: -3)), 2)\ndoAssert $denominator.center_exact.x\
    \ == \"-1/2\" and $denominator.center_exact.y == \"1/3\"\nfor invalid in [Fraction[int](num:\
    \ 1, den: 0), Fraction[int](num: 0, den: 0)]:\n    rejects: discard initCircle(initPoint(invalid,\
    \ invalid), 0)\nlet fractionRadius = initCircle(initPoint(initFraction(0), initFraction(0)),\
    \ initFraction(1, 2))\ndoAssert $fractionRadius.radius_squared_exact == \"1/4\"\
    \nrejects: discard initCircle(initPoint(0, 0), initFraction(1, 2))\nlet unit =\
    \ initCircle(initPoint(0, 0), 1)\nfor pair in [(3, 1, 0, 4), (2, 1, 1, 3), (1,\
    \ 1, 2, 2), (1, 2, 1, 1), (0, 2, 0, 0)]:\n    let other = initCircle(initPoint(pair[0],\
    \ 0), pair[1])\n    doAssert intersection_count(unit, other) == pair[2]\n    doAssert\
    \ common_tangent_count(unit, other) == pair[3]\n    for circles in [(unit, other),\
    \ (other, unit)]:\n        let tangents = common_tangents(circles[0], circles[1])\n\
    \        doAssert tangents.tangents.len == pair[3]\n        for tangent in tangents.tangents:\n\
    \            let first = tangent.first - circles[0].center_approx\n          \
    \  let second = tangent.second - circles[1].center_approx\n            doAssert\
    \ close(hypot(first.x, first.y), circles[0].radius)\n            doAssert close(hypot(second.x,\
    \ second.y), circles[1].radius)\n            doAssert close(dot(first, tangent.direction),\
    \ 0)\n            doAssert close(dot(second, tangent.direction), 0)\n        \
    \    doAssert close(cross(tangent.second - tangent.first, tangent.direction),\
    \ 0)\n    doAssert intersection_count(other, unit) == pair[2]\n    doAssert cross_points_approx(unit,\
    \ other).points.len == pair[2]\nlet giant = parseBigInt(\"1\" & repeat('0', 1000))\n\
    let bigCircle = initCircle(initPoint(giant, -giant), 1)\nstatic: doAssert typeof(bigCircle)\
    \ is Circle[BigInt]\ndoAssert bigCircle.center_exact.x == initFraction(giant)\n\
    doAssert bigCircle.on_circle(initPoint(giant + bi(1), -giant))\ndoAssert not bigCircle.contains(initPoint(giant\
    \ + bi(2), -giant))\nrejects: discard bigCircle.center_approx\nlet giantDisjointSegment\
    \ = Segment[BigInt](s: initPoint(giant + bi(2), -giant), t: initPoint(giant +\
    \ bi(3), -giant))\ndoAssert cross_points(bigCircle, giantDisjointSegment).points.len\
    \ == 0\nlet giantOuter = initCircle(initPoint(giant, -giant), 3)\nlet giantInner\
    \ = initCircle(initPoint(giant + bi(1), -giant), 1)\ndoAssert common_tangents(giantOuter,\
    \ giantInner).tangents.len == 0\n\nlet small = initFraction(bi(1), giant)\nlet\
    \ tiny = initCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(small, rat(0, 1)))\n\
    doAssert tiny.radius_squared_exact == small * small\nrejects: discard tiny.radius_approx\n\
    let subnormal = initCircle(initPoint(rat(0, 1), rat(0, 1)), initPoint(initFraction(bi(5),\
    \ parseBigInt(\"1\" & repeat('0', 324))), rat(0, 1)))\ndoAssert subnormal.radius_approx\
    \ > 0 and subnormal.radius_approx < 1e-308\nlet largeDen = initFraction(giant\
    \ + bi(1), giant)\nlet ratio = initCircle(initPoint(largeDen, largeDen), 1)\n\
    doAssert close(ratio.center_approx.x, 1)\nlet far = initCircle(initPoint(bi(0),\
    \ bi(0)), initPoint(giant, bi(0)), initPoint(bi(0), giant))\ndoAssert far.on_circle(initPoint(giant,\
    \ giant))\ndoAssert far.contains(initPoint(giant div bi(2), giant div bi(2)))\n\
    let giantRadius = initCircle(initPoint(bi(0), bi(0)), giant)\ndoAssert giantRadius.radius_squared_exact.num\
    \ == giant * giant\ndoAssert giantRadius.on_circle(initPoint(giant, bi(0)))\n\
    rejects: discard giantRadius.radius_approx\nlet epsilon = initFraction(bi(1),\
    \ parseBigInt(\"1\" & repeat('0', 100)))\nlet bigUnit = initCircle(initPoint(rat(0,\
    \ 1), rat(0, 1)), 1)\nlet nearBoundary = initPoint(rat(1, 1) + epsilon, rat(0,\
    \ 1))\ndoAssert bigUnit.classify(nearBoundary) == circleOutside\ndoAssert tangent_lines_approx(bigUnit,\
    \ nearBoundary).tangents.len == 2\nlet nearLine = Line[Fraction[BigInt]](s: initPoint(rat(-2,\
    \ 1), rat(1, 1) - epsilon), t: initPoint(rat(2, 1), rat(1, 1) - epsilon))\ndoAssert\
    \ intersection_count(bigUnit, nearLine) == 2\ndoAssert cross_points_approx(bigUnit,\
    \ nearLine).points.len == 2\nlet nearCircle = initCircle(initPoint(rat(2, 1) -\
    \ epsilon, rat(0, 1)), 1)\ndoAssert intersection_count(bigUnit, nearCircle) ==\
    \ 2\ndoAssert cross_points_approx(bigUnit, nearCircle).points.len == 2\ndoAssert\
    \ common_tangents(bigUnit, nearCircle).tangents.len == common_tangent_count(bigUnit,\
    \ nearCircle)\nlet savedEPS = GEOMETRY_EPS\nGEOMETRY_EPS = 100\nfor p in [nearBoundary,\
    \ initPoint(rat(1, 1), rat(0, 1))]:\n    doAssert bigUnit.on_circle(p) == (p ==\
    \ initPoint(rat(1, 1), rat(0, 1)))\nGEOMETRY_EPS = savedEPS\nlet wide = parseInt128(\"\
    1000000000000000000000000000000\")\nlet wideCircle = initCircle(initPoint(wide,\
    \ wide), parseInt128(\"1\"))\nstatic: doAssert typeof(wideCircle) is Circle[Int128]\n\
    doAssert wideCircle.on_circle(initPoint(wide + parseInt128(\"1\"), wide))\ndoAssert\
    \ $wideCircle.radius_squared_exact == \"1/1\"\nstatic:\n    doAssert typeof(initCircle(initPoint(0.0,\
    \ 0.0), 1)) is Circle[float]\n    doAssert typeof(initCircle(initPoint(0, 0),\
    \ 1.0)) is Circle[float]\nvar tangentRng = initRand(85791)\nfor trial in 0..<1000:\n\
    \    let x = tangentRng.rand(-20..20)\n    let y = tangentRng.rand(-20..20)\n\
    \    let ra = tangentRng.rand(0..10)\n    let rb = tangentRng.rand(0..10)\n  \
    \  let a = initCircle(initPoint(0, 0), ra)\n    let b = initCircle(initPoint(x,\
    \ y), rb)\n    let dsq = x * x + y * y\n    if dsq == 0:\n        doAssert common_tangents(a,\
    \ b).kind == (if ra == rb: circleInfinite else: circleFinite)\n        continue\n\
    \    let sumsq = (ra + rb) * (ra + rb)\n    let diffsq = (ra - rb) * (ra - rb)\n\
    \    var expected = 0\n    if ra == 0 and rb == 0: expected = 1\n    elif ra ==\
    \ 0 or rb == 0:\n        expected = if dsq == sumsq: 1 elif dsq > sumsq: 2 else:\
    \ 0\n    else:\n        if dsq == diffsq: expected = 1\n        elif dsq > diffsq:\
    \ expected = 2\n        if dsq == sumsq: inc expected\n        elif dsq > sumsq:\
    \ expected += 2\n    let forward = common_tangents(a, b)\n    let backward = common_tangents(b,\
    \ a)\n    doAssert forward.tangents.len == expected and backward.tangents.len\
    \ == expected\n    for tangent in forward.tangents:\n        let first = tangent.first\n\
    \        let second = tangent.second - initPoint(float(x), float(y))\n       \
    \ doAssert close(hypot(first.x, first.y), float(ra))\n        doAssert close(hypot(second.x,\
    \ second.y), float(rb))\n        doAssert close(dot(first, tangent.direction),\
    \ 0)\n        doAssert close(dot(second, tangent.direction), 0)\n        doAssert\
    \ close(cross(tangent.second - tangent.first, tangent.direction), 0)\n       \
    \ var found = false\n        for reverse in backward.tangents:\n            if\
    \ close(reverse.first.x, tangent.second.x) and close(reverse.first.y, tangent.second.y)\
    \ and\n                    close(reverse.second.x, tangent.first.x) and close(reverse.second.y,\
    \ tangent.first.y): found = true\n        doAssert found\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/int128.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/int128.nim
  - cplib/math/isprime.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle.nim
  - cplib/math/bigint.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/math/fractions.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/bigint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/exact_circle_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/exact_circle_test.nim
layout: document
redirect_from:
- /verify/verify/AI/exact_circle_test.nim
- /verify/verify/AI/exact_circle_test.nim.html
title: verify/AI/exact_circle_test.nim
---
