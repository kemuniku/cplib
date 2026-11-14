---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: py
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/python.py\"\
    , line 96, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import argparse\nfrom fractions import Fraction as F\nfrom itertools import\
    \ permutations\nimport random\nimport subprocess\nimport time\nimport sys\n\n\
    if hasattr(sys, \"set_int_max_str_digits\"):\n    sys.set_int_max_str_digits(0)\n\
    \n\ndef sign(x):\n    return (x > 0) - (x < 0)\n\n\ndef determinant(a):\n    if\
    \ len(a) == 1:\n        return a[0][0]\n    return sum((-1) ** i * a[0][i] * determinant([r[:i]\
    \ + r[i+1:] for r in a[1:]]) for i in range(len(a)))\n\n\ndef circle(points, method,\
    \ radius):\n    a, b, c = points\n    if method == 1:\n        return a, F(radius\
    \ * radius)\n    if method == 2:\n        return a, sum((x-y)**2 for x, y in zip(a,\
    \ b))\n    if a == b == c:\n        return a, F(0)\n    matrix = [[x, y, F(1)]\
    \ for x, y in points]\n    det = determinant(matrix)\n    if det == 0:\n     \
    \   return None\n    rhs = [-x*x-y*y for x, y in points]\n    coefficients = [determinant([row[:i]\
    \ + [rhs[j]] + row[i+1:] for j, row in enumerate(matrix)]) / det for i in range(3)]\n\
    \    center = tuple(-z/2 for z in coefficients[:2])\n    return center, sum(x*x\
    \ for x in center)-coefficients[2]\n\n\ndef power(c, p):\n    center, r2 = c\n\
    \    return sum((x-y)**2 for x, y in zip(center, p)) - r2\n\n\ndef location(c,\
    \ p):\n    return {1: 0, 0: 1, -1: 2}[sign(power(c, p))]\n\n\ndef line_coeff(c,\
    \ a, b):\n    v = [y-x for x, y in zip(a, b)]\n    w = [x-y for x, y in zip(a,\
    \ c[0])]\n    A = sum(x*x for x in v)\n    B = 2 * sum(x*y for x, y in zip(v,\
    \ w))\n    C = power(c, a)\n    return A, B, C, B*B-4*A*C\n\n\ndef line_count(c,\
    \ a, b):\n    d = line_coeff(c, a, b)[3]\n    return 0 if d < 0 else 1 if d ==\
    \ 0 else 2\n\n\ndef segment_count(c, a, b):\n    if a == b:\n        return int(power(c,\
    \ a) == 0)\n    A, B, C, D = line_coeff(c, a, b)\n    if D < 0:\n        return\
    \ 0\n    if D == 0:\n        return int(0 <= -B/(2*A) <= 1)\n    def variations(x):\n\
    \        signs = [sign(z) for z in (A*x*x+B*x+C, 2*A*x+B, D/(4*A)) if z != 0]\n\
    \        return sum(a != b for a, b in zip(signs, signs[1:]))\n    return variations(0)\
    \ - variations(1) + int(C == 0)\n\n\ndef circle_count(a, b):\n    distance = sum((x-y)**2\
    \ for x, y in zip(a[0], b[0]))\n    if distance == 0:\n        return (1 if a[1]\
    \ == 0 else -1) if a == b else 0\n    delta = 4*a[1]*b[1]-(distance-a[1]-b[1])**2\n\
    \    return 0 if delta < 0 else 1 if delta == 0 else 2\n\n\ndef tangent_count(c,\
    \ p):\n    v = power(c, p)\n    if c[1] == 0:\n        return -1 if v == 0 else\
    \ 1\n    return 0 if v < 0 else 1 if v == 0 else 2\n\n\ndef common_count(a, b):\n\
    \    d = sum((x-y)**2 for x, y in zip(a[0], b[0]))\n    if d == 0:\n        return\
    \ -1 if a == b else 0\n    if a[1] == b[1] == 0:\n        return 1\n    if a[1]\
    \ == 0:\n        return tangent_count(b, a[0])\n    if b[1] == 0:\n        return\
    \ tangent_count(a, b[0])\n    delta = d-a[1]-b[1]\n    determinant = delta**2-4*a[1]*b[1]\n\
    \    if determinant < 0:\n        return 2\n    if determinant == 0:\n       \
    \ return 3 if delta > 0 else 1\n    return 4 if delta > 0 else 0\n\n\ndef generate():\n\
    \    rng = random.Random(61006)\n    cases = []\n    types = ('int', 'int128',\
    \ 'bigint', 'fraction-int', 'fraction-int128', 'fraction-bigint')\n    for kind\
    \ in types:\n        for i in range(300):\n            if kind == 'fraction-bigint':\n\
    \                def val():\n                    if i % 4 == 0:\n            \
    \            return F(rng.getrandbits(160)*rng.choice((-1, 1)), rng.getrandbits(160)\
    \ or 1)\n                    return F(rng.randrange(-10, 11), rng.randrange(1,\
    \ 11))\n            elif kind == 'bigint':\n                base = rng.choice((0,\
    \ -(2**600), 2**600))\n                def val(): return F(base + rng.randrange(0,\
    \ 10))\n            elif 'fraction' in kind:\n                bound = 2 if kind\
    \ == 'fraction-int' else 10\n                def val(): return F(rng.randrange(-bound,\
    \ bound+1), 2)\n            else:\n                base = rng.choice((0, -1000000,\
    \ 1000000))\n                def val(): return F(base + rng.randrange(0, 5))\n\
    \            points = [tuple(val() for _ in range(2)) for _ in range(9)]\n   \
    \         method = i % 3\n            ra, rb = rng.randrange(0, 3), rng.randrange(0,\
    \ 3)\n            if kind in (\"int\", \"fraction-int\") and method == 0:\n  \
    \              a = points[0]\n                points[:3] = [a, (a[0]+1, a[1]),\
    \ (a[0], a[1]+1)]\n            if i % 17 == 0:\n                points[2] = points[1]\
    \ = points[0]\n            elif i % 19 == 0:\n                points[1] = points[0]\n\
    \            if i % 13 == 0:\n                points[3] = points[0] if method\
    \ == 0 else points[1]\n            if i % 11 == 0:\n                points[6:8]\
    \ = points[:2]\n            if points[4] == points[5]:\n                points[5]\
    \ = (points[5][0]+1, points[5][1])\n            for ordering in (points[:3], points[:3][::-1]):\n\
    \                ps = ordering + points[3:]\n                cases.append((kind,\
    \ method, ps, ra, rb))\n    # 4x4 incircle determinant\u3082\u4F7F\u3044\u3001\
    \u5168\u9806\u5217\u30FB\u5883\u754C\u30FB\u6307\u5B9A\u578B\u306E\u5951\u7D04\
    \u5185\u306E\u5E73\u884C\u79FB\u52D5\u3092\u78BA\u8A8D\u3059\u308B\u3002\n   \
    \ for kind in ('int', 'int128', 'bigint', 'fraction-int', 'fraction-int128', 'fraction-bigint'):\n\
    \        for offset in ((0, 10**30, -10**30) if kind in (\"int128\", \"fraction-int128\"\
    ) else ((0, 2**600, -(2**600)) if \"bigint\" in kind else (0, 1000000, -1000000))):\n\
    \            defining = [(F(offset), F(offset)), (F(offset+4), F(offset)), (F(offset),\
    \ F(offset+4))]\n            for ordering in permutations(defining):\n       \
    \         outside = (offset+4, offset-1) if offset > 0 else (offset+5, offset+5)\n\
    \                for query in ((offset+4, offset+4), (offset+2, offset+2), outside):\n\
    \                    ps = list(ordering)+[tuple(map(F, query))]+[defining[0],\
    \ defining[1], defining[0], defining[1], defining[2]]\n                    cases.append((kind,\
    \ 0, ps, 0, 2))\n    return cases\n\n\ndef main():\n    parser = argparse.ArgumentParser()\n\
    \    parser.add_argument('binaries', nargs='+')\n    args = parser.parse_args()\n\
    \    cases = generate()\n    lines, expected = [], []\n    for kind, method, ps,\
    \ ra, rb in cases:\n        tokens = [kind, str(method)]\n        for p in ps:\n\
    \            for v in p:\n                tokens += [str(v.numerator), str(v.denominator)]\n\
    \        tokens += [str(ra), str(rb)]\n        lines.append(' '.join(tokens))\n\
    \        c = circle(ps[:3], method, ra)\n        if c is None:\n            expected.append('INVALID')\n\
    \            continue\n        loc = location(c, ps[3])\n        if method ==\
    \ 0 and len(set(ps[:3])) == 3:\n            mat = [[x, y, x*x+y*y, F(1)] for x,\
    \ y in ps[:4]]\n            orientation = determinant([[x, y, F(1)] for x, y in\
    \ ps[:3]])\n            s = sign(determinant(mat)*orientation)\n            assert\
    \ loc == {-1: 0, 0: 1, 1: 2}[s]\n        other = (ps[8], F(rb*rb))\n        expected.append('\
    \ '.join([*(str(x.numerator)+'/'+str(x.denominator) for x in (*c[0], c[1])),\n\
    \            str(loc), str(line_count(c, *ps[4:6])), str(segment_count(c, *ps[6:8])),\n\
    \            str(circle_count(c, other)), str(tangent_count(c, ps[3])), str(common_count(c,\
    \ other))]))\n    for binary in args.binaries:\n        start = time.monotonic()\n\
    \        result = subprocess.run([binary], input='\\n'.join(lines)+'\\n', text=True,\
    \ capture_output=True)\n        if result.returncode != 0:\n            raise\
    \ AssertionError((binary, result.returncode, len(result.stdout.splitlines()),\
    \ result.stderr[-2000:]))\n        actual = result.stdout.splitlines()\n     \
    \   assert len(actual) == len(expected), (binary, len(actual), len(expected),\
    \ result.stderr)\n        for i, (a, e) in enumerate(zip(actual, expected)):\n\
    \            assert a == e, (binary, i, lines[i], a, e)\n        print(f'{binary}:\
    \ {len(cases)} independent rational/determinant/Sturm cases passed in {time.monotonic()-start:.2f}s')\n\
    \n\nif __name__ == '__main__':\n    main()\n"
  dependsOn: []
  isVerificationFile: false
  path: verify/AI/exact_circle_oracle.py
  requiredBy: []
  timestamp: '1970-01-01 00:00:00+00:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/AI/exact_circle_oracle.py
layout: document
redirect_from:
- /library/verify/AI/exact_circle_oracle.py
- /library/verify/AI/exact_circle_oracle.py.html
title: verify/AI/exact_circle_oracle.py
---
