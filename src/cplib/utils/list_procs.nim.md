---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/list_procs_test.nim
    title: verify/utils/list_procs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/list_procs_test.nim
    title: verify/utils/list_procs_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import lists\nproc insertPrev*[T](L: var DoublyLinkedList[T], a,b: DoublyLinkedNode[T])=\n\
    \    if L.head == a:\n        L.head = b\n        a.prev = b\n        b.next =\
    \ a\n    else:\n        a.prev.next = b\n        b.prev = a.prev\n        a.prev\
    \ = b\n        b.next = a\n\nproc insert*[T](L: var DoublyLinkedList[T], a,b:\
    \ DoublyLinkedNode[T])=\n    if L.tail == a:\n        L.tail = b\n        a.next\
    \ = b\n        b.prev = a\n    else:\n        a.next.prev = b\n        b.next\
    \ = a.next\n        a.next = b\n        b.prev = a"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/list_procs.nim
  requiredBy: []
  timestamp: '2024-11-28 13:20:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/list_procs_test.nim
  - verify/utils/list_procs_test.nim
documentation_of: cplib/utils/list_procs.nim
layout: document
redirect_from:
- /library/cplib/utils/list_procs.nim
- /library/cplib/utils/list_procs.nim.html
title: cplib/utils/list_procs.nim
---
