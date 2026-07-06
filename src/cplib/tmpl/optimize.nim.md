---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/optimize_test.nim
    title: verify/AI/optimize_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/optimize_test.nim
    title: verify/AI/optimize_test.nim
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
  code: "import macros,strutils,std/compilesettings\nmacro optimize*(arg: static string\
    \ = \"\"\"nim c -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on\
    \ --opt:speed --checks:off --passC:\"-flto -m64 -march=native -ffast-math\" --hints:off\
    \ \"\"\") =\n    let isSecond = defined(second_compile)\n    let isDebug = defined(debug)\n\
    \n    if (not isSecond) and (not isDebug):\n        if \"-d:second_compile\" notin\
    \ arg:\n            error(\"plz add -d:second_compile\")\n        let sourcePath\
    \ = querySetting(SingleValueSetting.projectFull)\n        let projectDir = sourcePath[0..<sourcePath.rfind('/')]\n\
    \        let outFile = querySetting(SingleValueSetting.outFile)\n        let outFlag\
    \ = if outFile.len > 0: \"-o:\" & outFile & \" \" else: \"-o:a.out \"\n      \
    \  var cmd = \"cd \" & projectDir & \" && export PATH=$HOME/.nimble/bin:$PATH\
    \ && \" & arg\n        cmd.add(outFlag & sourcePath)\n\n        echo \"--- Self-Recompiling\
    \ with optimized settings ---\"\n        echo \"Command: \", cmd\n        echo\
    \ \"\\n\\n\\n\"\n\n        let output = staticExec(cmd)\n        warning(output)\n\
    \        echo \"\\n\\n\\n\"\n\n        quit(0)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/optimize.nim
  requiredBy: []
  timestamp: '2026-04-15 20:27:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/optimize_test.nim
  - verify/AI/optimize_test.nim
documentation_of: cplib/tmpl/optimize.nim
layout: document
redirect_from:
- /library/cplib/tmpl/optimize.nim
- /library/cplib/tmpl/optimize.nim.html
title: cplib/tmpl/optimize.nim
---
