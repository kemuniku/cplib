import base64, strutils, tables

proc compressSource*(source: string): string =
    ## LZ形式で圧縮する。探索数と一致長に上限を設けて O(N) 時間・空間。
    var heads = initTable[string, int]()
    var previous = newSeq[int](source.len)
    var pos = 0
    while pos < source.len:
        let flagPos = result.len
        result.add('\0')
        var flags = 0
        for bit in 0..<8:
            if pos >= source.len: break
            var bestLength = 0
            var bestDistance = 0
            if pos + 2 < source.len:
                let key = source[pos..pos + 2]
                var candidate = heads.getOrDefault(key, -1)
                var attempts = 0
                while candidate >= 0 and pos - candidate <= 65535 and attempts < 64:
                    var length = 0
                    while length < 258 and pos + length < source.len and
                            source[candidate + length] == source[pos + length]:
                        inc length
                    if length > bestLength:
                        bestLength = length
                        bestDistance = pos - candidate
                    candidate = previous[candidate]
                    inc attempts
            let consumed = if bestLength >= 3: bestLength else: 1
            if bestLength >= 3:
                flags = flags or (1 shl bit)
                result.add(char(bestDistance shr 8))
                result.add(char(bestDistance and 255))
                result.add(char(bestLength - 3))
            else:
                result.add(source[pos])
            for index in pos..<pos + consumed:
                if index + 2 < source.len:
                    let key = source[index..index + 2]
                    previous[index] = heads.getOrDefault(key, -1)
                    heads[key] = index
            pos += consumed
        result[flagPos] = char(flags)

proc compressedProgram*(source, original: string, attachOriginal: bool): string =
    ## 復元マクロを生成し、指定時は元コードを未使用のテンプレート内に添付して3行空ける。
    if attachOriginal:
        result.add("template originalSource() =\n")
        for line in original.splitLines():
            result.add(" " & line & "\n")
        result.add(repeat('\n', 3))
    let restoreProgram = """import base64
macro cplibUnpackSource(): untyped =
    # コンパイル時に展開済みコードを復元する。
    let z = decode(""" & '"' & encode(compressSource(source)) & """")
    var s = ""
    var i = 0
    while i < z.len:
        let f = ord(z[i])
        inc i
        for b in 0..<8:
            if i >= z.len: break
            if (f and (1 shl b)) == 0:
                s.add(z[i])
                inc i
            else:
                let d = ord(z[i])*256+ord(z[i+1])
                let n = ord(z[i+2])+3
                i += 3
                for j in 0..<n: s.add(s[s.len-d])
    result = parseStmt(s)
cplibUnpackSource()
"""
    result.add("# https://github.com/kemuniku/cplib\n")
    result.add("import macros;macro cplibRestore(s:static[string]):untyped = parseStmt(s)\n")
    result.add("cplibRestore(" & escape(restoreProgram) & ")\n")
