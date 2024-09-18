---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/root_rangesum.nim
    title: cplib/collections/root_rangesum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/range_kth_smallest
    links:
    - https://judge.yosupo.jp/problem/range_kth_smallest
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest\n\
    import sequtils,algorithm,sugar,strutils\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nimport cplib/utils/mo\nimport cplib/collections/root_rangesum\n\nvar\
    \ N,Q = ii()\nvar A = newseqwith(N,ii())\nvar cmp = A.sorted().deduplicate(true)\n\
    var X = A.mapit(cmp.lowerBound(it))\nvar M = initMo(N,Q)\nvar querys : seq[int]\n\
    for i in 0..<Q:\n    var l,r,k = ii()\n    M.insert(l,r)\n    querys.add(k)\n\
    var ans = newseq[int](Q)\nvar st = initrangesum(newseqwith(len(cmp),0))\n\nproc\
    \ ad(i:int)=\n    st[X[i]] = st[X[i]] + 1\n\nproc dl(i:int)=\n    st[X[i]] = st[X[i]]\
    \ - 1\n\nproc mem(idx:int)=\n    var k = querys[idx]\n    var tmp = st.max_right(0,(x:int)\
    \ => (x <= k))\n    ans[idx] = cmp[tmp]\n\nM.run(ad,ad,dl,dl,mem)\n\necho ans.join(\"\
    \\n\")"
  dependsOn:
  - cplib/utils/mo.nim
  - cplib/collections/root_rangesum.nim
  - cplib/collections/root_rangesum.nim
  - cplib/utils/mo.nim
  isVerificationFile: true
  path: verify/collections/range_kth_smallest_test.nim
  requiredBy: []
  timestamp: '2024-09-15 20:15:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_kth_smallest_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_kth_smallest_test.nim
- /verify/verify/collections/range_kth_smallest_test.nim.html
title: verify/collections/range_kth_smallest_test.nim
---
