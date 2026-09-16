---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/optimize_cpp_test.nim
    title: verify/AI/optimize_cpp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/optimize_cpp_test.nim
    title: verify/AI/optimize_cpp_test.nim
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
  code: "when not declared CPLIB_TMPL_OPTIMIZE:\n    const CPLIB_TMPL_OPTIMIZE* =\
    \ 1\n    import macros, strutils, os, std/compilesettings\n    macro optimize*(arg:\
    \ static string = \"\"\"nim c -d:danger -d:second_compile -d:useMalloc --gc:arc\
    \ --panics:on --opt:speed --checks:off --passC:\"-flto -m64 -march=native -ffast-math\
    \ -funroll-loops -fipa-pta\" --passL:\"-flto\" --hints:off \"\"\") =\n       \
    \ ## \u6700\u9069\u5316\u8A2D\u5B9A\u3067\u518D\u30B3\u30F3\u30D1\u30A4\u30EB\u3057\
    \u3001\u5931\u6557\u6642\u306F\u547C\u3073\u51FA\u3057\u5143\u306E\u30B3\u30F3\
    \u30D1\u30A4\u30EB\u3082\u5931\u6557\u3055\u305B\u308B\u3002\n        let isSecond\
    \ = defined(second_compile)\n        let isDebug = defined(debug)\n\n        if\
    \ (not isSecond) and (not isDebug):\n            if \"-d:second_compile\" notin\
    \ arg:\n                error(\"plz add -d:second_compile\")\n            let\
    \ sourcePath = querySetting(SingleValueSetting.projectFull)\n            let outFile\
    \ = querySetting(SingleValueSetting.outFile)\n            let outDir = querySetting(SingleValueSetting.outDir)\n\
    \            let outPath = outDir / outFile\n            let projectDir = sourcePath.parentDir\n\
    \            let libraryDir = currentSourcePath().parentDir.parentDir.parentDir\n\
    \            let searchPaths = querySettingSeq(MultipleValueSetting.searchPaths)\n\
    \            var cmd = \"cd \" & quoteShell(projectDir) & \" && \" & arg & \"\
    \ \"\n            # --path \u306F\u5148\u982D\u306B\u8FFD\u52A0\u3055\u308C\u308B\
    \u305F\u3081\u3001\u5143\u306E\u63A2\u7D22\u9806\u3092\u4FDD\u3064\u3088\u3046\
    \u9006\u9806\u3067\u6E21\u3059\u3002\n            for i in countdown(searchPaths.high,\
    \ 0):\n                cmd.add(\"--path:\" & quoteShell(searchPaths[i]) & \" \"\
    )\n            # \u518D\u30B3\u30F3\u30D1\u30A4\u30EB\u3067\u3082\u3001\u30A4\u30F3\
    \u30B9\u30C8\u30FC\u30EB\u6E08\u307F\u306E\u5225\u7248\u3067\u306F\u306A\u304F\
    \u3053\u306E\u30E9\u30A4\u30D6\u30E9\u30EA\u3092\u53C2\u7167\u3059\u308B\u3002\
    \n            if libraryDir.len > 0:\n                cmd.add(\"--path:\" & quoteShell(libraryDir)\
    \ & \" \")\n            cmd.add(\"-o:\" & quoteShell(outPath) & \" \" & quoteShell(sourcePath))\n\
    \n            echo \"--- Self-Recompiling with optimized settings ---\"\n    \
    \        echo \"Command: \", cmd\n            echo \"\\n\\n\\n\"\n\n         \
    \   let execution = gorgeEx(cmd)\n            if execution.exitCode != 0:\n  \
    \              error(\"Optimized compilation failed (exit code \" & $execution.exitCode\
    \ & \"):\\n\" & execution.output)\n            warning(execution.output)\n   \
    \         echo \"\\n\\n\\n\"\n\n            quit(0)\n\n    template optimizeCpp*(arg:\
    \ static string = \"\"\"nim cpp -d:danger -d:second_compile -d:useMalloc --gc:arc\
    \ --panics:on --opt:speed --checks:off --passC:\"-flto -m64 -march=native -ffast-math\
    \ -funroll-loops -fipa-pta\" --passL:\"-flto\" --hints:off \"\"\") =\n       \
    \ ## C++\u30D0\u30C3\u30AF\u30A8\u30F3\u30C9\u3067\u6700\u9069\u5316\u3057\u3066\
    \u518D\u30B3\u30F3\u30D1\u30A4\u30EB\u3057\u3001\u5931\u6557\u6642\u306F\u547C\
    \u3073\u51FA\u3057\u5143\u3082\u5931\u6557\u3055\u305B\u308B\u3002\n        optimize(arg)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/optimize.nim
  requiredBy: []
  timestamp: '2026-09-17 01:48:32+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/optimize_cpp_test.nim
  - verify/AI/optimize_cpp_test.nim
  - verify/AI/optimize_test.nim
  - verify/AI/optimize_test.nim
documentation_of: cplib/tmpl/optimize.nim
layout: document
redirect_from:
- /library/cplib/tmpl/optimize.nim
- /library/cplib/tmpl/optimize.nim.html
title: cplib/tmpl/optimize.nim
---
