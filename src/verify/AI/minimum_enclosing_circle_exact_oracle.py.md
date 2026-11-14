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
    \ combinations\nimport random\nimport subprocess\nimport sys\nimport time\nfrom\
    \ exact_circle_oracle import circle, power\n\n\ndef oracle(points):\n    if not\
    \ points:\n        return None\n    candidates = [(p, F(0)) for p in points]\n\
    \    for a, b in combinations(points, 2):\n        center = tuple((x+y)/2 for\
    \ x, y in zip(a, b))\n        candidates.append((center, sum((x-y)**2 for x, y\
    \ in zip(center, a))))\n    for subset in combinations(points, 3):\n        candidate\
    \ = circle(subset, 0, 0)\n        if candidate is not None:\n            candidates.append(candidate)\n\
    \    feasible = [c for c in candidates if all(power(c, p) <= 0 for p in points)]\n\
    \    return min(feasible, key=lambda c: c[1])\n\n\ndef generate():\n    rng =\
    \ random.Random(28563355030)\n    types = ('int', 'int128', 'bigint', 'fraction-int',\
    \ 'fraction-int128', 'fraction-bigint')\n    sets = []\n    for kind in types:\n\
    \        for i in range(80):\n            n = rng.randrange(0, 9)\n          \
    \  def value():\n                x = rng.randrange(-2, 3) if kind in ('int', 'fraction-int')\
    \ else rng.randrange(-10, 11)\n                return F(x, 2 if 'fraction' in\
    \ kind else 1)\n            points = [tuple(value() for _ in range(2)) for _ in\
    \ range(n)]\n            if i % 5 == 0:\n                points = [(p[0], F(3))\
    \ for p in points]\n            if i % 7 == 0 and points:\n                points\
    \ += [points[0]] * 3\n            sets.append((kind, points))\n        # \u5EA7\
    \u6A19\u30FB\u5206\u6BCD\u306E\u5171\u901A\u5C3A\u5EA6\u3092\u5927\u304D\u304F\
    \u3057\u3066\u3001\u652F\u6301\u96C6\u5408\u3068\u534A\u5F84\u4E8C\u4E57\u3092\
    \u53B3\u5BC6\u7167\u5408\u3059\u308B\u3002\n        if 'fraction' in kind:\n \
    \           scale = F(1, {'fraction-int': 2, 'fraction-int128': 1000, 'fraction-bigint':\
    \ 2**2048-1}[kind])\n            origin = F(0)\n        else:\n            scale\
    \ = F(1)\n            origin = F({'int': 1000000, 'int128': 10**30, 'bigint':\
    \ 2**2048}[kind])\n        for grid in ([(0, 0), (1, 0)], [(0, 0), (4, 0), (2,\
    \ 4)], [(0, 0), (4, 0), (1, 1)],\n                     [(0, 0), (4, 0), (0, 4),\
    \ (4, 4)], [(0, 0)]*20):\n            sets.append((kind, [(origin+scale*x, origin+scale*y)\
    \ for x, y in grid]))\n        if kind == 'bigint':\n            sets.append((kind,\
    \ [(F(-2**2048), F(0)), (F(2**2048-1), F(0))]))\n    # \u5C0F\u3055\u306A\u6574\
    \u6570\u683C\u5B50\u304B\u3089\u5168\u3066\u306E1/2/3/4\u70B9\u96C6\u5408\u3092\
    \u8ABF\u3079\u308B\u3002\n    grid = [(F(x), F(y)) for x in range(3) for y in\
    \ range(3)]\n    for n in range(1, 5):\n        for points in combinations(grid,\
    \ n): sets.append(('int', list(points)))\n    for kind, points in sets:\n    \
    \    expected = oracle(points)\n        for seed in (0, 1, -1, 63355030):\n  \
    \          for ordering in (points, list(reversed(points))):\n               \
    \ yield kind, seed, ordering, expected\n\n\ndef main():\n    parser = argparse.ArgumentParser()\n\
    \    parser.add_argument('binaries', nargs='+')\n    args = parser.parse_args()\n\
    \    cases = list(generate())\n    lines, expected = [], []\n    for kind, seed,\
    \ points, result in cases:\n        tokens = ['mec-'+kind, str(seed), str(len(points))]\n\
    \        for point in points:\n            for value in point: tokens += [str(value.numerator),\
    \ str(value.denominator)]\n        lines.append(' '.join(tokens))\n        expected.append('EMPTY'\
    \ if result is None else ' '.join(str(v.numerator)+'/'+str(v.denominator) for\
    \ v in (*result[0], result[1])))\n    for binary in args.binaries:\n        start\
    \ = time.monotonic()\n        result = subprocess.run([binary], input='\\n'.join(lines)+'\\\
    n', text=True, capture_output=True)\n        assert result.returncode == 0, (binary,\
    \ result.stderr[-2000:])\n        actual = result.stdout.splitlines()\n      \
    \  assert len(actual) == len(expected), (len(actual), len(expected))\n       \
    \ for i, (a, e) in enumerate(zip(actual, expected)):\n            assert a ==\
    \ e, (binary, i, lines[i], a, e)\n        print(f'{binary}: {len(cases)} MEC all-1/2/3-support\
    \ oracle cases passed in {time.monotonic()-start:.2f}s', flush=True)\n\n\nif __name__\
    \ == '__main__':\n    main()\n"
  dependsOn: []
  isVerificationFile: false
  path: verify/AI/minimum_enclosing_circle_exact_oracle.py
  requiredBy: []
  timestamp: '1970-01-01 00:00:00+00:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/AI/minimum_enclosing_circle_exact_oracle.py
layout: document
redirect_from:
- /library/verify/AI/minimum_enclosing_circle_exact_oracle.py
- /library/verify/AI/minimum_enclosing_circle_exact_oracle.py.html
title: verify/AI/minimum_enclosing_circle_exact_oracle.py
---
