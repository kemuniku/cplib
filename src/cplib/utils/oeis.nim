when not declared CPLIB_UTILS_OEIS:
    const CPLIB_UTILS_OEIS* = 1
    # HTTPS通信のため、httpclientの読み込み前にSSLを有効にする。
    # net/httpclientを先に読み込む場合は、メインファイル先頭でも指定する。
    {.define: ssl.}
    import httpclient, json, strutils
    import cplib/math/fractions

    type
        OEISResultKind* = enum
            oeisSequence,
            oeisMatrixRowMajor,
            oeisMatrixAntidiagonal,
            oeisNumerator,
            oeisDenominator

        OEISResult* = object
            id*: string
            name*: string
            data*: string
            query*: string
            url*: string
            kind*: OEISResultKind

    const OEISSearchUrl = "https://oeis.org/search"

    proc makeQuery[T: SomeInteger](values: openArray[T]): string =
        for i, value in values:
            if i > 0:
                result.add(',')
            result.add($value)

    proc searchQuery(client: HttpClient, query: string, kind: OEISResultKind): seq[OEISResult] =
        if query.len == 0:
            return

        let response = client.get(OEISSearchUrl & "?q=" & query & "&fmt=json")
        if response.code != Http200:
            raise newException(IOError, "OEIS request failed: " & $response.code)

        let root = parseJson(response.body)
        var entries: JsonNode
        if root.kind == JObject:
            if not root.hasKey("results"):
                return
            entries = root["results"]
        elif root.kind == JArray:
            entries = root
        else:
            return

        if entries.kind != JArray:
            return

        for entry in entries.items:
            if entry.kind != JObject or not entry.hasKey("number"):
                continue
            let number = entry["number"].getInt()
            var name, data = ""
            if entry.hasKey("name") and entry["name"].kind == JString:
                name = entry["name"].getStr()
            if entry.hasKey("data") and entry["data"].kind == JString:
                data = entry["data"].getStr()
            let id = "A" & align($number, 6, '0')
            result.add(OEISResult(
                id: id,
                name: name,
                data: data,
                query: query,
                url: "https://oeis.org/" & id,
                kind: kind
            ))

    proc addResults(destination: var seq[OEISResult], source: openArray[OEISResult]) =
        for item in source:
            destination.add(item)

    proc searchOEIS*[T: SomeInteger](values: openArray[T]): seq[OEISResult] =
        ## 整数列をOEISで検索する。通信・JSON解析を除く処理時間はO(n)。
        let query = makeQuery(values)
        if query.len == 0:
            return
        let client = newHttpClient()
        defer: client.close()
        result = searchQuery(client, query, oeisSequence)

    proc searchOEIS*[T: SomeInteger](matrix: openArray[seq[T]]): seq[OEISResult] =
        ## 2次元整数配列を行方向と反対角線方向で検索する。通信・JSON解析を除く処理時間はO(HW)。
        var rowMajor, antidiagonal: seq[T]
        var maxWidth = 0
        for row in matrix:
            maxWidth = max(maxWidth, row.len)
            for value in row:
                rowMajor.add(value)

        if rowMajor.len == 0:
            return

        for diagonal in 0 ..< matrix.len + maxWidth - 1:
            for row in 0 ..< matrix.len:
                if diagonal >= row:
                    let column = diagonal - row
                    if column < matrix[row].len:
                        antidiagonal.add(matrix[row][column])

        let client = newHttpClient()
        defer: client.close()
        result.addResults(searchQuery(client, makeQuery(rowMajor), oeisMatrixRowMajor))
        result.addResults(searchQuery(client, makeQuery(antidiagonal), oeisMatrixAntidiagonal))

    proc searchOEIS*[T: SomeInteger](f: proc(x, y: int): T {.closure.},
                                    xRange: Slice[int] = 0 .. 9,
                                    yRange: Slice[int] = 0 .. 9): seq[OEISResult] =
        ## f(x, y)から2次元整数配列を作り、行方向と反対角線方向で検索する。
        ## searchOEIS(f)は各軸0..9を使い、searchOEIS(f, 1..5, 2..6)で範囲を指定できる。
        ## xは行、yは列で、各範囲の両端を含む。範囲が空なら関数評価・通信を行わない。
        ## 関数評価は各要素につき1回。生成にO(HW)、追加領域にO(HW)を要する。
        if xRange.a > xRange.b or yRange.a > yRange.b:
            return
        var matrix: seq[seq[T]]
        for x in xRange:
            var row: seq[T]
            for y in yRange:
                row.add(f(x, y))
            matrix.add(row)
        result = searchOEIS(matrix)

    proc searchOEIS*[T: SomeInteger](values: openArray[Fraction[T]]): seq[OEISResult] =
        ## 有理数列を既約分数に直し、分子列と分母列を別々に検索する。処理時間はO(n)。
        var numerators, denominators: seq[T]
        for value in values:
            if value.den == T(0):
                raise newException(ValueError, "OEIS rational search requires nonzero denominators")
            var reduced = value
            reduced.reduce()
            numerators.add(reduced.num)
            denominators.add(reduced.den)

        if values.len == 0:
            return

        let client = newHttpClient()
        defer: client.close()
        result.addResults(searchQuery(client, makeQuery(numerators), oeisNumerator))
        result.addResults(searchQuery(client, makeQuery(denominators), oeisDenominator))

    proc kindName(kind: OEISResultKind): string =
        case kind
        of oeisSequence:
            result = "整数列"
        of oeisMatrixRowMajor:
            result = "2次元配列（行方向の連結）"
        of oeisMatrixAntidiagonal:
            result = "2次元配列（反対角線方向）"
        of oeisNumerator:
            result = "有理数列（分子）"
        of oeisDenominator:
            result = "有理数列（分母）"

    proc termsPreview(data: string, limit: int = 12): string =
        if data.len == 0:
            return
        let terms = data.split(',')
        let shown = min(terms.len, limit)
        for i in 0 ..< shown:
            if i > 0:
                result.add(", ")
            result.add(terms[i].strip())
        if shown < terms.len:
            result.add(", …")

    proc `$`*(item: OEISResult): string =
        ## OEIS検索結果を項目情報が分かる文字列にする。
        result = item.id
        if item.name.len > 0:
            result.add(": " & item.name)
        result.add("\n  検索形式: " & kindName(item.kind))
        result.add("\n  URL: " & item.url)
        if item.data.len > 0:
            result.add("\n  OEISの項: " & termsPreview(item.data))

    proc `$`*(items: seq[OEISResult]): string =
        ## OEIS検索結果の列を見やすい複数行の文字列にする。
        if items.len == 0:
            return "OEIS検索結果はありませんでした。"
        result = "OEIS検索結果（" & $items.len & "件）"
        for i, item in items:
            result.add("\n\n" & $(i + 1) & ". " & $item)
