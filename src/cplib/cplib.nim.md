---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '{.warning[UnusedImport]: off.}

    {.hint[XDeclaredButNotUsed]: off.}

    import geometry/ccw

    import geometry/distance

    import geometry/angle

    import geometry/projection

    import geometry/base

    import geometry/polygon

    import geometry/intersect

    import utils/mo

    import utils/constants

    import utils/binary_search

    import utils/lis

    import utils/inversion_number

    import utils/bititers

    import itertools/combinations

    import modint/barrett_impl

    import modint/modint

    import modint/montgomery_impl

    import matrix/matops

    import matrix/matrix

    import graph/bellmanford

    import graph/SCC

    import graph/maxk_dijkstra

    import graph/graph

    import graph/dijkstra

    import graph/warshall_floyd

    import graph/topologicalsort

    import graph/reverse_edge

    import graph/restore_shortest_path_from_prev

    import graph/grid_to_graph

    import tree/diameter

    import tree/heavylightdecomposition

    import tree/prufer

    import tree/tree

    import math/isqrt

    import math/divisor

    import math/primefactor

    import math/fractions

    import math/powmod

    import math/nearest_equiv

    import math/inner_math

    import math/combination

    import math/euler_phi

    import math/isprime

    import tmpl/citrus

    import tmpl/qcfium

    import tmpl/sheep

    import str/rolling_hash

    import str/run_length_encode

    import str/manachar

    import str/zalgorithm

    import collections/avltreenode

    import collections/rollback_unionfind

    import collections/unionfind

    import collections/defaultdict

    import collections/SWAG

    import collections/segtree_var

    import collections/hashtable

    import collections/avlset

    import collections/segtree

    import collections/tatyamset

    import collections/hashset

    import collections/QSWAG

    '
  dependsOn: []
  isVerificationFile: false
  path: cplib/cplib.nim
  requiredBy: []
  timestamp: '2023-11-21 22:59:53+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/cplib.nim
layout: document
redirect_from:
- /library/cplib/cplib.nim
- /library/cplib/cplib.nim.html
title: cplib/cplib.nim
---