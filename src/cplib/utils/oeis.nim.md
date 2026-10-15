---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/oeis_function_test.nim
    title: verify/utils/oeis_function_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/oeis_function_test.nim
    title: verify/utils/oeis_function_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/oeis_ssl_test.nim
    title: verify/utils/oeis_ssl_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/oeis_ssl_test.nim
    title: verify/utils/oeis_ssl_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://oeis.org/
    - https://oeis.org/search
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_OEIS:\n    const CPLIB_UTILS_OEIS* = 1\n  \
    \  # HTTPS\u901A\u4FE1\u306E\u305F\u3081\u3001httpclient\u306E\u8AAD\u307F\u8FBC\
    \u307F\u524D\u306BSSL\u3092\u6709\u52B9\u306B\u3059\u308B\u3002\n    # net/httpclient\u3092\
    \u5148\u306B\u8AAD\u307F\u8FBC\u3080\u5834\u5408\u306F\u3001\u30E1\u30A4\u30F3\
    \u30D5\u30A1\u30A4\u30EB\u5148\u982D\u3067\u3082\u6307\u5B9A\u3059\u308B\u3002\
    \n    {.define: ssl.}\n    import httpclient, json, strutils\n    import cplib/math/fractions\n\
    \n    type\n        OEISResultKind* = enum\n            oeisSequence,\n      \
    \      oeisMatrixRowMajor,\n            oeisMatrixAntidiagonal,\n            oeisNumerator,\n\
    \            oeisDenominator\n\n        OEISResult* = object\n            id*:\
    \ string\n            name*: string\n            data*: string\n            query*:\
    \ string\n            url*: string\n            kind*: OEISResultKind\n\n    const\
    \ OEISSearchUrl = \"https://oeis.org/search\"\n\n    proc makeQuery[T: SomeInteger](values:\
    \ openArray[T]): string =\n        for i, value in values:\n            if i >\
    \ 0:\n                result.add(',')\n            result.add($value)\n\n    proc\
    \ searchQuery(client: HttpClient, query: string, kind: OEISResultKind): seq[OEISResult]\
    \ =\n        if query.len == 0:\n            return\n\n        let response =\
    \ client.get(OEISSearchUrl & \"?q=\" & query & \"&fmt=json\")\n        if response.code\
    \ != Http200:\n            raise newException(IOError, \"OEIS request failed:\
    \ \" & $response.code)\n\n        let root = parseJson(response.body)\n      \
    \  var entries: JsonNode\n        if root.kind == JObject:\n            if not\
    \ root.hasKey(\"results\"):\n                return\n            entries = root[\"\
    results\"]\n        elif root.kind == JArray:\n            entries = root\n  \
    \      else:\n            return\n\n        if entries.kind != JArray:\n     \
    \       return\n\n        for entry in entries.items:\n            if entry.kind\
    \ != JObject or not entry.hasKey(\"number\"):\n                continue\n    \
    \        let number = entry[\"number\"].getInt()\n            var name, data =\
    \ \"\"\n            if entry.hasKey(\"name\") and entry[\"name\"].kind == JString:\n\
    \                name = entry[\"name\"].getStr()\n            if entry.hasKey(\"\
    data\") and entry[\"data\"].kind == JString:\n                data = entry[\"\
    data\"].getStr()\n            let id = \"A\" & align($number, 6, '0')\n      \
    \      result.add(OEISResult(\n                id: id,\n                name:\
    \ name,\n                data: data,\n                query: query,\n        \
    \        url: \"https://oeis.org/\" & id,\n                kind: kind\n      \
    \      ))\n\n    proc addResults(destination: var seq[OEISResult], source: openArray[OEISResult])\
    \ =\n        for item in source:\n            destination.add(item)\n\n    proc\
    \ searchOEIS*[T: SomeInteger](values: openArray[T]): seq[OEISResult] =\n     \
    \   ## \u6574\u6570\u5217\u3092OEIS\u3067\u691C\u7D22\u3059\u308B\u3002\u901A\u4FE1\
    \u30FBJSON\u89E3\u6790\u3092\u9664\u304F\u51E6\u7406\u6642\u9593\u306FO(n)\u3002\
    \n        let query = makeQuery(values)\n        if query.len == 0:\n        \
    \    return\n        let client = newHttpClient()\n        defer: client.close()\n\
    \        result = searchQuery(client, query, oeisSequence)\n\n    proc searchOEIS*[T:\
    \ SomeInteger](matrix: openArray[seq[T]]): seq[OEISResult] =\n        ## 2\u6B21\
    \u5143\u6574\u6570\u914D\u5217\u3092\u884C\u65B9\u5411\u3068\u53CD\u5BFE\u89D2\
    \u7DDA\u65B9\u5411\u3067\u691C\u7D22\u3059\u308B\u3002\u901A\u4FE1\u30FBJSON\u89E3\
    \u6790\u3092\u9664\u304F\u51E6\u7406\u6642\u9593\u306FO(HW)\u3002\n        var\
    \ rowMajor, antidiagonal: seq[T]\n        var maxWidth = 0\n        for row in\
    \ matrix:\n            maxWidth = max(maxWidth, row.len)\n            for value\
    \ in row:\n                rowMajor.add(value)\n\n        if rowMajor.len == 0:\n\
    \            return\n\n        for diagonal in 0 ..< matrix.len + maxWidth - 1:\n\
    \            for row in 0 ..< matrix.len:\n                if diagonal >= row:\n\
    \                    let column = diagonal - row\n                    if column\
    \ < matrix[row].len:\n                        antidiagonal.add(matrix[row][column])\n\
    \n        let client = newHttpClient()\n        defer: client.close()\n      \
    \  result.addResults(searchQuery(client, makeQuery(rowMajor), oeisMatrixRowMajor))\n\
    \        result.addResults(searchQuery(client, makeQuery(antidiagonal), oeisMatrixAntidiagonal))\n\
    \n    proc searchOEIS*[T: SomeInteger](f: proc(x, y: int): T {.closure.},\n  \
    \                                  xRange: Slice[int] = 0 .. 9,\n            \
    \                        yRange: Slice[int] = 0 .. 9): seq[OEISResult] =\n   \
    \     ## f(x, y)\u304B\u30892\u6B21\u5143\u6574\u6570\u914D\u5217\u3092\u4F5C\u308A\
    \u3001\u884C\u65B9\u5411\u3068\u53CD\u5BFE\u89D2\u7DDA\u65B9\u5411\u3067\u691C\
    \u7D22\u3059\u308B\u3002\n        ## searchOEIS(f)\u306F\u5404\u8EF80..9\u3092\
    \u4F7F\u3044\u3001searchOEIS(f, 1..5, 2..6)\u3067\u7BC4\u56F2\u3092\u6307\u5B9A\
    \u3067\u304D\u308B\u3002\n        ## x\u306F\u884C\u3001y\u306F\u5217\u3067\u3001\
    \u5404\u7BC4\u56F2\u306E\u4E21\u7AEF\u3092\u542B\u3080\u3002\u7BC4\u56F2\u304C\
    \u7A7A\u306A\u3089\u95A2\u6570\u8A55\u4FA1\u30FB\u901A\u4FE1\u3092\u884C\u308F\
    \u306A\u3044\u3002\n        ## \u95A2\u6570\u8A55\u4FA1\u306F\u5404\u8981\u7D20\
    \u306B\u3064\u304D1\u56DE\u3002\u751F\u6210\u306BO(HW)\u3001\u8FFD\u52A0\u9818\
    \u57DF\u306BO(HW)\u3092\u8981\u3059\u308B\u3002\n        if xRange.a > xRange.b\
    \ or yRange.a > yRange.b:\n            return\n        var matrix: seq[seq[T]]\n\
    \        for x in xRange:\n            var row: seq[T]\n            for y in yRange:\n\
    \                row.add(f(x, y))\n            matrix.add(row)\n        result\
    \ = searchOEIS(matrix)\n\n    proc searchOEIS*[T: SomeInteger](values: openArray[Fraction[T]]):\
    \ seq[OEISResult] =\n        ## \u6709\u7406\u6570\u5217\u3092\u65E2\u7D04\u5206\
    \u6570\u306B\u76F4\u3057\u3001\u5206\u5B50\u5217\u3068\u5206\u6BCD\u5217\u3092\
    \u5225\u3005\u306B\u691C\u7D22\u3059\u308B\u3002\u51E6\u7406\u6642\u9593\u306F\
    O(n)\u3002\n        var numerators, denominators: seq[T]\n        for value in\
    \ values:\n            if value.den == T(0):\n                raise newException(ValueError,\
    \ \"OEIS rational search requires nonzero denominators\")\n            var reduced\
    \ = value\n            reduced.reduce()\n            numerators.add(reduced.num)\n\
    \            denominators.add(reduced.den)\n\n        if values.len == 0:\n  \
    \          return\n\n        let client = newHttpClient()\n        defer: client.close()\n\
    \        result.addResults(searchQuery(client, makeQuery(numerators), oeisNumerator))\n\
    \        result.addResults(searchQuery(client, makeQuery(denominators), oeisDenominator))\n\
    \n    proc kindName(kind: OEISResultKind): string =\n        case kind\n     \
    \   of oeisSequence:\n            result = \"\u6574\u6570\u5217\"\n        of\
    \ oeisMatrixRowMajor:\n            result = \"2\u6B21\u5143\u914D\u5217\uFF08\u884C\
    \u65B9\u5411\u306E\u9023\u7D50\uFF09\"\n        of oeisMatrixAntidiagonal:\n \
    \           result = \"2\u6B21\u5143\u914D\u5217\uFF08\u53CD\u5BFE\u89D2\u7DDA\
    \u65B9\u5411\uFF09\"\n        of oeisNumerator:\n            result = \"\u6709\
    \u7406\u6570\u5217\uFF08\u5206\u5B50\uFF09\"\n        of oeisDenominator:\n  \
    \          result = \"\u6709\u7406\u6570\u5217\uFF08\u5206\u6BCD\uFF09\"\n\n \
    \   proc termsPreview(data: string, limit: int = 12): string =\n        if data.len\
    \ == 0:\n            return\n        let terms = data.split(',')\n        let\
    \ shown = min(terms.len, limit)\n        for i in 0 ..< shown:\n            if\
    \ i > 0:\n                result.add(\", \")\n            result.add(terms[i].strip())\n\
    \        if shown < terms.len:\n            result.add(\", \u2026\")\n\n    proc\
    \ `$`*(item: OEISResult): string =\n        ## OEIS\u691C\u7D22\u7D50\u679C\u3092\
    \u9805\u76EE\u60C5\u5831\u304C\u5206\u304B\u308B\u6587\u5B57\u5217\u306B\u3059\
    \u308B\u3002\n        result = item.id\n        if item.name.len > 0:\n      \
    \      result.add(\": \" & item.name)\n        result.add(\"\\n  \u691C\u7D22\u5F62\
    \u5F0F: \" & kindName(item.kind))\n        result.add(\"\\n  URL: \" & item.url)\n\
    \        if item.data.len > 0:\n            result.add(\"\\n  OEIS\u306E\u9805\
    : \" & termsPreview(item.data))\n\n    proc `$`*(items: seq[OEISResult]): string\
    \ =\n        ## OEIS\u691C\u7D22\u7D50\u679C\u306E\u5217\u3092\u898B\u3084\u3059\
    \u3044\u8907\u6570\u884C\u306E\u6587\u5B57\u5217\u306B\u3059\u308B\u3002\n   \
    \     if items.len == 0:\n            return \"OEIS\u691C\u7D22\u7D50\u679C\u306F\
    \u3042\u308A\u307E\u305B\u3093\u3067\u3057\u305F\u3002\"\n        result = \"\
    OEIS\u691C\u7D22\u7D50\u679C\uFF08\" & $items.len & \"\u4EF6\uFF09\"\n       \
    \ for i, item in items:\n            result.add(\"\\n\\n\" & $(i + 1) & \". \"\
    \ & $item)\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: false
  path: cplib/utils/oeis.nim
  requiredBy: []
  timestamp: '2026-10-14 21:36:14+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/oeis_function_test.nim
  - verify/utils/oeis_function_test.nim
  - verify/utils/oeis_ssl_test.nim
  - verify/utils/oeis_ssl_test.nim
documentation_of: cplib/utils/oeis.nim
layout: document
redirect_from:
- /library/cplib/utils/oeis.nim
- /library/cplib/utils/oeis.nim.html
title: cplib/utils/oeis.nim
---
