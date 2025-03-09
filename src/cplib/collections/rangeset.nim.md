---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/collections/rangeset_test_.nim
    title: verify/collections/rangeset_test_.nim
  - icon: ':warning:'
    path: verify/collections/rangeset_test_.nim
    title: verify/collections/rangeset_test_.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import cplib/collections/avlset\nimport options\ntype RangeSet*[T] = ref\
    \ object\n    st* : AVLSortedMultiSet[(int,int,T)]\n    default* : T\n\nproc initRangeSet*[T](default:T):RangeSet[T]=\n\
    \    return RangeSet[T](st:initAvlSortedMultiSet[(int,int,T)](@[(low(int),high(int),default)]),default:default)\n\
    \nproc update*[T](self:RangeSet[T],l,r:int,value:T)=\n    #\u307E\u305A\u3001\
    [l,r)\u304C\u5B8C\u5168\u306B\u5185\u5305\u3057\u3066\u3044\u308B\u533A\u9593\u306B\
    \u3064\u3044\u3066\u6D88\u53BB\u3059\u308B\n    var l = l\n    var r = r\n   \
    \ while true:\n        var x = self.st.ge((l,low(int),self.default))\n       \
    \ if x.isNone():\n            break\n        var (a,b,c) = x.get()\n        if\
    \ b <= r:\n            discard self.st.excl((a,b,c))\n        elif a < r:\n  \
    \          #\u533A\u9593\u306E\u53F3\u3067\u88AB\u3063\u3066\u3044\u308B\u3088\
    \u3046\u306A\u5834\u5408\n            self.st.excl((a,b,c))\n            if c\
    \ == value:\n                r = b\n            else:\n                self.st.incl((r,b,c))\n\
    \            break\n        else:\n            if a == r and c == value:\n   \
    \             self.st.excl((a,b,c))\n                r = b\n            break\n\
    \    var x = self.st.le((l,high(int),self.default))\n    if x.issome():\n    \
    \    var (a,b,c) = x.get()\n        if r < b:\n            if c != value:\n  \
    \              self.st.excl((a,b,c))\n                self.st.incl((a,l,c))\n\
    \                self.st.incl((r,b,c))\n            else:\n                return\n\
    \        elif l < b:\n            if c != value:\n                self.st.excl((a,b,c))\n\
    \                self.st.incl((a,l,c))\n            else:\n                self.st.excl((a,b,c))\n\
    \                l = a\n        elif l == b:\n            if c == value:\n   \
    \             self.st.excl((a,b,c))\n                l = a\n    self.st.incl((l,r,value))\n\
    \nproc get_segment*[T](self:RangeSet[T],x:int):(int,int,int)=\n    #\u3053\u308C\
    \u6700\u5927\u5024\u533A\u9593\u304C\u7DE8\u96C6\u3055\u308C\u3066\u3044\u308B\
    \u3068\u304D\u306B\u30D0\u30B0\u308A\u307E\u3059\n    self.st.le((x,high(int),self.default)).get()"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: false
  path: cplib/collections/rangeset.nim
  requiredBy:
  - verify/collections/rangeset_test_.nim
  - verify/collections/rangeset_test_.nim
  timestamp: '2024-11-28 13:30:55+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/rangeset.nim
layout: document
redirect_from:
- /library/cplib/collections/rangeset.nim
- /library/cplib/collections/rangeset.nim.html
title: cplib/collections/rangeset.nim
---
