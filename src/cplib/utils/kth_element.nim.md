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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_KTH_ELEMENT:\n    const COMPETITIVE_UTILS_KTH_ELEMENT*\
    \ = 1\n    import random,sequtils\n    randomize()\n    proc kth_element*[T](X:seq[T],K:int):T=\n\
    \        var now = 0\n        var r = len(X)\n        var C = newseqwith(r,0)\n\
    \        var X = X\n        while true:\n            var L = 0\n            var\
    \ S = 1\n            swap(X[rand(0..<r)],X[r-1])\n            C[r-1] = 0\n   \
    \         for i in 0..<(r-1):\n                var tmp = cmp(X[i],X[r-1])\n  \
    \              if tmp < 0:\n                    L += 1\n                elif tmp\
    \ == 0:\n                    S += 1\n                C[i] = tmp\n            if\
    \ now+L > K:\n                var idx = 0\n                for i in 0..<(r-1):\n\
    \                    if C[i] < 0:\n                        swap(X[i],X[idx])\n\
    \                        idx += 1\n                r = idx\n            elif now+L+S\
    \ > K:\n                return X[r-1]\n            else:\n                var\
    \ idx = 0\n                for i in 0..<(r-1):\n                    if C[i] >\
    \ 0:\n                        swap(X[i],X[idx])\n                        idx +=\
    \ 1\n                now += L+S\n                r = idx\n    \n    proc kth_element_break*[T](nums\
    \ : var seq[T], k:int):T=\n        ## \u5F15\u6570\u306Enums\u306E\u9806\u756A\
    \u304C\u30D0\u30E9\u30D0\u30E9\u306B\u306A\u308A\u307E\u3059\uFF01\n        var\
    \ target = k\n        var left = 0\n        var right = len(nums) - 1\n      \
    \  \n        while left <= right:\n            if left == right:\n           \
    \     return nums[left]\n            \n            # \u30E9\u30F3\u30C0\u30E0\u30D4\
    \u30DC\u30C3\u30C8\u9078\u629E\n            var pivot_idx = rand(left..right)\n\
    \            var pivot = nums[pivot_idx]\n            \n            # 3-way Partition\
    \ (\u30AA\u30E9\u30F3\u30C0\u306E\u56FD\u65D7\u554F\u984C\u306E\u30A2\u30EB\u30B4\
    \u30EA\u30BA\u30E0)\n            var lt = left      # pivot\u3088\u308A\u5C0F\u3055\
    \u3044\u8981\u7D20\u306E\u53F3\u7AEF\n            var i = left       # \u30B9\u30AD\
    \u30E3\u30F3\u7528\u30DD\u30A4\u30F3\u30BF\n            var gt = right     # pivot\u3088\
    \u308A\u5927\u304D\u3044\u8981\u7D20\u306E\u5DE6\u7AEF\n            \n       \
    \     while i <= gt:\n                var c = cmp(nums[i],pivot)\n           \
    \     if c < 0:\n                    swap(nums[lt],nums[i])\n                \
    \    # nums[lt], nums[i] = nums[i], nums[lt]\n                    lt += 1\n  \
    \                  i += 1\n                elif c > 0:\n                    swap(nums[i],nums[gt])\n\
    \                    # nums[i], nums[gt] = nums[gt], nums[i]\n               \
    \     gt -= 1\n                else:\n                    i += 1\n           \
    \ if lt <= target and target <= gt:\n                # \u30BF\u30FC\u30B2\u30C3\
    \u30C8\u304C\u300C\u30D4\u30DC\u30C3\u30C8\u3068\u540C\u3058\u5024\u300D\u306E\
    \u7BC4\u56F2\u5185\u306B\u5165\u308C\u3070\u7D42\u4E86\n                return\
    \ nums[lt]\n            elif target < lt:\n                # \u5DE6\u5074\u3092\
    \u63A2\u7D22\n                right = lt - 1\n            else:\n            \
    \    # \u53F3\u5074\u3092\u63A2\u7D22\n                left = gt + 1"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/kth_element.nim
  requiredBy: []
  timestamp: '2026-05-26 10:40:09+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/utils/kth_element.nim
layout: document
redirect_from:
- /library/cplib/utils/kth_element.nim
- /library/cplib/utils/kth_element.nim.html
title: cplib/utils/kth_element.nim
---
