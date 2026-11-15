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
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import strutils\nimport cplib/geometry/base\nimport cplib/geometry/circle\n\
    import cplib/geometry/minimum_enclosing_circle\nimport cplib/math/bigint\nimport\
    \ cplib/math/int128\nimport cplib/math/fractions\n\nvar tokens: seq[string]\n\
    var index: int\nproc read(): string =\n    result = tokens[index]\n    inc index\n\
    proc scalar[T](): T =\n    let n = read()\n    let d = read()\n    when T is Fraction[int]:\n\
    \        Fraction[int](num: parseInt(n), den: parseInt(d))\n    elif T is Fraction[Int128]:\n\
    \        Fraction[Int128](num: parseInt128(n), den: parseInt128(d))\n    elif\
    \ T is Fraction[BigInt]:\n        Fraction[BigInt](num: parseBigInt(n), den: parseBigInt(d))\n\
    \    elif T is Int128: parseInt128(n)\n    elif T is BigInt: parseBigInt(n)\n\
    \    else: parseInt(n)\nproc point[T](): Point[T] = initPoint(scalar[T](), scalar[T]())\n\
    proc run[T]() =\n    let methodId = parseInt(read())\n    let a = point[T]()\n\
    \    let b = point[T]()\n    let c = point[T]()\n    let query = point[T]()\n\
    \    let line = Line[T](s: point[T](), t: point[T]())\n    let segment = Segment[T](s:\
    \ point[T](), t: point[T]())\n    let centerB = point[T]()\n    let ra = parseInt(read())\n\
    \    let rb = parseInt(read())\n    proc check[S](circle: Circle[S]) =\n     \
    \   let center = circle.center_exact\n        let radiusSquared = circle.radius_squared_exact\n\
    \        let other = initCircle(centerB, rb)\n        echo $center.x & \" \" &\
    \ $center.y & \" \" & $radiusSquared & \" \" &\n            $ord(circle.classify(query))\
    \ & \" \" & $intersection_count(circle, line) & \" \" &\n            $intersection_count(circle,\
    \ segment) & \" \" & $intersection_count(circle, other) & \" \" &\n          \
    \  $tangent_count(circle, query) & \" \" & $common_tangent_count(circle, other)\n\
    \    try:\n        case methodId\n        of 0: check(initCircle(a, b, c))\n \
    \       of 1: check(initCircle(a, ra))\n        else: check(initCircle(a, b))\n\
    \    except ValueError:\n        echo \"INVALID\"\nproc runMec[T]() =\n    let\
    \ seed = parseBiggestInt(read())\n    let n = parseInt(read())\n    var points:\
    \ seq[Point[T]]\n    for _ in 0..<n: points.add(point[T]())\n    if n == 0:\n\
    \        try:\n            discard minimum_enclosing_circle(points, seed)\n  \
    \          quit(\"empty MEC was accepted\")\n        except ValueError:\n    \
    \        echo \"EMPTY\"\n            return\n    let circle = minimum_enclosing_circle(points,\
    \ seed)\n    for p in points:\n        if not circle.contains(p): quit(\"MEC does\
    \ not contain input\")\n    let center = circle.center_exact\n    echo $center.x\
    \ & \" \" & $center.y & \" \" & $circle.radius_squared_exact\n\nvar line: string\n\
    while stdin.readLine(line):\n    tokens = line.splitWhitespace()\n    index =\
    \ 1\n    if tokens[0].startsWith(\"mec-\"):\n        case tokens[0][4..^1]\n \
    \       of \"int\": runMec[int]()\n        of \"int128\": runMec[Int128]()\n \
    \       of \"bigint\": runMec[BigInt]()\n        of \"fraction-int\": runMec[Fraction[int]]()\n\
    \        of \"fraction-int128\": runMec[Fraction[Int128]]()\n        of \"fraction-bigint\"\
    : runMec[Fraction[BigInt]]()\n        else: quit(\"unknown MEC type\")\n     \
    \   continue\n    case tokens[0]\n    of \"int\": run[int]()\n    of \"int128\"\
    : run[Int128]()\n    of \"bigint\": run[BigInt]()\n    of \"fraction-int\": run[Fraction[int]]()\n\
    \    of \"fraction-int128\": run[Fraction[Int128]]()\n    of \"fraction-bigint\"\
    : run[Fraction[BigInt]]()\n    else: quit(\"unknown type\")\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/geometry/base.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/modint/montgomery_impl.nim
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
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/math/isprime.nim
  - cplib/math/bigint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: verify/AI/exact_circle_oracle_driver.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/AI/exact_circle_oracle_driver.nim
layout: document
redirect_from:
- /library/verify/AI/exact_circle_oracle_driver.nim
- /library/verify/AI/exact_circle_oracle_driver.nim.html
title: verify/AI/exact_circle_oracle_driver.nim
---
