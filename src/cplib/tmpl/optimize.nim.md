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
  code: "import macros,strutils\nmacro optimize*(arg: static string = \"\"\"nim c\
    \ -d:danger -d:second_compile -d:useMalloc --gc:arc --panics:on --opt:speed --checks:off\
    \ --passC:\"-flto -m64 -march=native -ffast-math\" \"\"\") =\n    let isSecond\
    \ = defined(second_compile)\n    let isDebug = defined(debug)\n\n    if not isSecond\
    \ and not isDebug:\n        if \"-d:second_compile\" notin arg:\n            error(\"\
    plz add -d:second_compile\")\n        let info = instantiationInfo(fullPaths=true)\n\
    \        let sourcePath = info.filename\n        var cmd = \"export PATH=$HOME/.nimble/bin:$PATH\
    \ && \" & arg\n        cmd.add(\"-o:a.out \" & sourcePath)\n\n        echo \"\
    --- Self-Recompiling with optimized settings ---\"\n        echo \"Command: \"\
    , cmd\n        echo \"\\n\\n\\n\"\n\n        let output = staticExec(cmd)\n  \
    \      echo output\n        echo \"\\n\\n\\n\"\n        quit(0)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/optimize.nim
  requiredBy: []
  timestamp: '2026-04-15 04:30:25+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/tmpl/optimize.nim
layout: document
redirect_from:
- /library/cplib/tmpl/optimize.nim
- /library/cplib/tmpl/optimize.nim.html
title: cplib/tmpl/optimize.nim
---
