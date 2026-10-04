# 一般CRTの検証

`import cplib/math/crt` で `crt(r, m: openArray[int]): tuple[r, m: int]` を使用できます。
法が互いに素でない合同式を含め、成功時は `0 <= r < m = lcm(入力の法)` を返します。
解なしは `(0, 0)`、空列は `(0, 1)` です。法1、負の剰余、重複・包含する法にも対応します。
入力は符号付き `int` です。`uint` / `uint64` の値は `high(int)` 以下であることを確認してから変換してください。

長さ不一致と正でない法は `ValueError` です。全入力の形を先に検査します。
入力順に合同式を併合し、整合する途中の最小公倍数が `high(int)` を超えた時点で
`OverflowDefect` を送出します。その後の合同式によって解なしとなる場合でも、
先にオーバーフローしたなら例外となります。この制約外では入力順によって
例外と解なしのどちらを先に検出するかが変わる場合があります。
assertionsを無効にしたreleaseでもこれらの検査は有効です。

64ビット環境では `high(int) = 2^63 - 1` が返却可能な法の上限です。
途中の逆元との積は既存の `Int128` を使います。
結果の剰余の差は正規化後に計算するので、`low(int)` を含む剰余でも安全です。
`nim cpp` と `__int128` 対応コンパイラ（g++等）が必要です。
計算量は合同式数を `n`、最大法を `M` として `O(n log M)`、補助空間は `O(1)` です。
BigInt CRTとGarner法はこのAPIの対象外です。

```nim
import cplib/math/crt

assert crt([4, 4], [6, 8]) == (4, 24)
assert crt([0, 1], [2, 4]) == (0, 0)
assert crt([-1, -1], [3, 5]) == (14, 15)
```

自己完結回帰は `src/verify/math/crt_test.nim` に集約しています。
既存の `verify.yml` が Nim 1.6.20 / 2.2.4 で実行します。

```sh
nim cpp --path:src --nimcache:/tmp/crt-debug-cache -o:/tmp/crt-debug -r src/verify/math/crt_test.nim
nim cpp --path:src -d:release --assertions:off --nimcache:/tmp/crt-release-cache -o:/tmp/crt-release -r src/verify/math/crt_test.nim
nim cpp --path:src -d:release --passC:-fsanitize=undefined --passC:-fno-sanitize-recover=undefined --passL:-fsanitize=undefined --nimcache:/tmp/crt-ubsan-cache -o:/tmp/crt-ubsan -r src/verify/math/crt_test.nim
```

小法の全探索・周期内の解の一意性、順序入替・同値剰余・冗長合同式、
不正入力、符号付き整数上下限、巨大な共有因子、最小公倍数のオーバーフローを検証します。
64ビットの境界・固定seed乱数ケースは既存の `BigInt` による多倍長算術と照合し、
各prefixの解の存在条件を各法のgcdから独立に検査します。
[ABC193E](https://atcoder.jp/contests/abc193/tasks/abc193_e) の利用例は、
小さな周期の時刻全探索と公式サンプルに照合します。
関連する数論回帰は `src/verify/AI/{inv_gcd,ext_gcd,int128}_test.nim` です。

返却値の規約は[AtCoder LibraryのCRT](https://atcoder.github.io/ac-library/production/document_ja/math.html)
を参照しました。AtCoder Libraryは[CC0](https://github.com/atcoder/ac-library/blob/master/LICENSE)です。
