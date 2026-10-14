---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://github.com/example/library.git
    - https://github.com/example/library/blob/
    - https://github.com/example/library/blob/main
    - https://github.com/example/library/tree/main
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import os, strutils\n\nconst repoRoot = currentSourcePath().parentDir.parentDir.parentDir.parentDir\n\
    \nproc runCommand(command, directory: string): string {.compileTime.} =\n    let\
    \ executed = gorgeEx(\"cd \" & quoteShell(directory) & \" && \" & command)\n \
    \   doAssert executed.exitCode == 0, command & \"\\n\" & executed.output\n   \
    \ executed.output\n\n# \u30B3\u30F3\u30D1\u30A4\u30EB\u6642\u306B\u691C\u67FB\u3057\
    \u3001\u5B9F\u884C\u6642\u306E10\u79D2\u5236\u9650\u306B\u5916\u90E8\u30B3\u30F3\
    \u30D1\u30A4\u30EB\u3092\u542B\u3081\u306A\u3044\u3002\nstatic:\n    let created\
    \ = gorgeEx(\"mktemp -d -t cplib-expander-XXXXXXXX\")\n    doAssert created.exitCode\
    \ == 0\n    let directory = created.output.strip\n    let nim = getEnv(\"NIM\"\
    , \"nim\")\n    let compiler = quoteShell(nim)\n    let expander = directory /\
    \ \"expander\"\n    discard runCommand(compiler & \" cpp --hints:off -d:release\
    \ --nimcache:\" &\n        quoteShell(directory / \"expander-cache\") & \" -o:\"\
    \ & quoteShell(\n                expander) &\n        \" \" & quoteShell(repoRoot\
    \ / \"tools/expander/expander.nim\"), directory)\n    proc checkSource(source:\
    \ string; files: seq[(string, string)];\n                     fragments: seq[string];\n\
    \                             compileOriginal: bool) {.compileTime.} =\n     \
    \   for entry in files: writeFile(directory / entry[0], entry[1])\n        writeFile(directory\
    \ / \"main.nim\", source)\n        let flags = \" cpp -r --hints:off --nimcache:\"\
    \ & quoteShell(directory /\n                \"program-cache\") &\n           \
    \ \" -o:\" & quoteShell(directory / \"program\") & \" --path:. \"\n        if\
    \ compileOriginal:\n            discard runCommand(compiler & flags & \"main.nim\"\
    , directory)\n        for options in [\"\", \"--original-source\", \"--single-line\"\
    , \"--compress\",\n                \"--compress --original-source\"]:\n      \
    \      if not compileOriginal and \"--original-source\" in options: continue\n\
    \            discard runCommand(quoteShell(expander) & \" --quiet \" & options\
    \ &\n                    \" main.nim\", directory)\n            let expanded =\
    \ readFile(directory / \"combined.nim\")\n            if \"--original-source\"\
    \ in options:\n                doAssert expanded.startsWith(\"template originalSource()\
    \ =\\n \" &\n                    source.splitLines()[0])\n            if options\
    \ == \"\" or options == \"--original-source\":\n                for fragment in\
    \ fragments: doAssert fragment in expanded\n            discard runCommand(compiler\
    \ & flags & \"combined.nim\", directory)\n    checkSource(\"import#[comment]#\
    \ \\\"strutils\\\"\\ninclude \\\"quoted\\\"\\ndoAssert \\\"foo\\\".toUpperAscii\
    \ == \\\"FOO\\\"\\ndoAssert quoted == 7\\n\",\n        @[(\"quoted.nim\", \"const\
    \ quoted = 7\\n\")],\n        @[\"import #[comment]# \\\"strutils\\\"\", \"include\
    \ \\\"quoted\\\"\"], true)\n    checkSource(\"var importance = 0\\nvar include_count\
    \ = 0\\nvar import2 = 0\\nvar include\xE9 = 0\\nproc imported() = inc importance\\\
    nproc included() = inc include_count\\nimportance = 1\\ninclude_count = 1\\nimport2\
    \ = 2\\ninclude\xE9 = 3\\nimported()\\nincluded()\\nblock:\\n  imported()\\n \
    \ included()\\ndoAssert importance == 3\\ndoAssert include_count == 3\\ndoAssert\
    \ import2 == 2\\ndoAssert include\xE9 == 3\\n\",\n        @[],\n        @[\"var\
    \ importance = 0\\nvar include_count = 0\\nvar import2 = 0\\nvar include\xE9 =\
    \ 0\\nproc imported() = inc importance\\nproc included() = inc include_count\\\
    nimportance = 1\\ninclude_count = 1\\nimport2 = 2\\ninclude\xE9 = 3\\nimported()\\\
    nincluded()\\nblock:\\n  imported()\\n  included()\\ndoAssert importance == 3\\\
    ndoAssert include_count == 3\\ndoAssert import2 == 2\\ndoAssert include\xE9 ==\
    \ 3\\n\"], true)\n    checkSource(\"import first, second\\nimport  third\\ninclude\
    \ fourth\\nblock:\\n  include  fifth\\n  doAssert fifthValue == 5\\ndoAssert firstValue\
    \ + secondValue + thirdValue + fourthValue == 10\\n\",\n        @[(\"first.nim\"\
    , \"const firstValue* = 1\\n\"), (\"second.nim\",\n                \"const secondValue*\
    \ = 2\\n\"), (\"third.nim\",\n                \"const thirdValue* = 3\\n\"), (\"\
    fourth.nim\",\n                \"const fourthValue = 4\\n\"), (\"fifth.nim\",\n\
    \                \"const fifthValue = 5\\n\")],\n        @[\"const firstValue*\
    \ = 1\", \"const secondValue* = 2\",\n                \"const thirdValue* = 3\"\
    , \"const fourthValue = 4\",\n                \"  const fifthValue = 5\"], true)\n\
    \    checkSource(\"import\\tfirst\\ninclude\\tsecond\\ndoAssert firstValue + secondValue\
    \ == 3\\n\",\n        @[(\"first.nim\", \"const firstValue* = 1\\n\"), (\"second.nim\"\
    ,\n                \"const secondValue = 2\\n\")],\n        @[\"const firstValue*\
    \ = 1\", \"const secondValue = 2\"], false)\n    discard runCommand(\"mkdir -p\
    \ src\", directory)\n    writeFile(directory / \"src\" / \"demo.nim\", \"const\
    \ answer = 7\\n\")\n    writeFile(directory / \"main.nim\", \"include demo\\ndoAssert\
    \ answer == 7\\n\")\n    discard runCommand(\"git init -q\", directory)\n    discard\
    \ runCommand(\"git add src/demo.nim\", directory)\n    discard runCommand(\"git\
    \ -c user.name=verify -c user.email=verify@example.com commit -qm initial\", directory)\n\
    \    let commit = runCommand(\"git rev-parse HEAD\", directory).strip\n    let\
    \ permalink = \"https://github.com/example/library/blob/\" & commit & \"/src/demo.nim\"\
    \n    for repositoryUrl in [\"https://github.com/example/library.git\",\n    \
    \        \"https://github.com/example/library/blob/main\",\n            \"https://github.com/example/library/tree/main\"\
    ]:\n        let expandWithUrl = quoteShell(expander) &\n            \" --quiet\
    \ -l:. -g:\" & quoteShell(repositoryUrl) & \" main.nim\"\n        discard runCommand(expandWithUrl,\
    \ directory)\n        doAssert \"# source: \" & permalink in readFile(directory\
    \ / \"combined.nim\")\n    writeFile(directory / \"src\" / \"demo.nim\", \"const\
    \ answer = 8\\n\")\n    writeFile(directory / \"main.nim\", \"include demo\\ndoAssert\
    \ answer == 8\\n\")\n    discard runCommand(quoteShell(expander) &\n        \"\
    \ --quiet -l:. -g:https://github.com/example/library/blob/main main.nim\", directory)\n\
    \    let modified = readFile(directory / \"combined.nim\")\n    doAssert \"# source:\
    \ \" & permalink in modified\n    doAssert \"const answer = 8\" in modified\n\
    \    let removed = gorgeEx(\"rm -rf -- \" & quoteShell(directory))\n    doAssert\
    \ removed.exitCode == 0\n\necho \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/tools/expander_test.nim
  requiredBy: []
  timestamp: '2026-10-14 21:42:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tools/expander_test.nim
layout: document
redirect_from:
- /verify/verify/tools/expander_test.nim
- /verify/verify/tools/expander_test.nim.html
title: verify/tools/expander_test.nim
---
