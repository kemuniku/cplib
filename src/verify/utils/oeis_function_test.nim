# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

type
    HttpClient = ref object
    MockResponse = object
        code: int
        body: string

const Http200 = 200
var requests: seq[string]
var closedClients = 0

proc newHttpClient(): HttpClient = HttpClient()
proc close(client: HttpClient) = inc closedClients
proc get(client: HttpClient, url: string): MockResponse =
    requests.add(url)
    MockResponse(code: Http200,
        body: "[{\"number\":27,\"name\":\"test\",\"data\":\"1,2,3\"}]")

include cplib/utils/oeis

proc f(x, y: int): int = x * 10 + y

block:
    let matches = searchOEIS(f, 1..2, 3..5)
    doAssert matches.len == 2
    doAssert matches[0].query == "13,14,15,23,24,25"
    doAssert matches[1].query == "13,14,23,15,24,25"
    doAssert matches[0].kind == oeisMatrixRowMajor
    doAssert matches[1].kind == oeisMatrixAntidiagonal
    doAssert requests == @[
        "https://oeis.org/search?q=13,14,15,23,24,25&fmt=json",
        "https://oeis.org/search?q=13,14,23,15,24,25&fmt=json"]
    doAssert closedClients == 1

block:
    var calls: seq[(int, int)]
    let offset = 100'i64
    let captured = proc(x, y: int): int64 =
        calls.add((x, y))
        offset + int64(x * 10 + y)
    let matches = searchOEIS(captured, xRange = -1..1, yRange = 2..3)
    doAssert calls == @[(-1, 2), (-1, 3), (0, 2), (0, 3), (1, 2), (1, 3)]
    doAssert matches[0].query == "92,93,102,103,112,113"
    doAssert matches[1].query == "92,93,102,103,112,113"

block:
    var calls: seq[(int, int)]
    let matches = searchOEIS(proc(x, y: int): int =
        calls.add((x, y))
        f(x, y))
    doAssert calls.len == 100
    doAssert calls[0] == (0, 0)
    doAssert calls[^1] == (9, 9)
    doAssert matches[0].query.split(',').len == 100
    doAssert matches[1].query.split(',').len == 100

block:
    let matches = searchOEIS(proc(x, y: int): uint64 = uint64(y), 0..0, 2..4)
    doAssert matches[0].query == "2,3,4"
    doAssert matches[1].query == "2,3,4"

block:
    let requestCount = requests.len
    let closeCount = closedClients
    var calls = 0
    let counted = proc(x, y: int): int =
        inc calls
        f(x, y)
    doAssert searchOEIS(counted, 1..0, 0..2).len == 0
    doAssert searchOEIS(counted, 0..2, 1..0).len == 0
    doAssert calls == 0
    doAssert requests.len == requestCount
    doAssert closedClients == closeCount

block:
    let requestCount = requests.len
    var failed = false
    try:
        discard searchOEIS(proc(x, y: int): int =
            raise newException(ValueError, "test"), 0..1, 0..1)
    except ValueError:
        failed = true
    doAssert failed
    doAssert requests.len == requestCount

echo "Hello World"
