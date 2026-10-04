# Garner による CRT 解の剰余復元

```nim
import cplib/math/garner

echo garner([2, 3, 2], [3, 5, 7], 100) # 23
echo garner([2, 3, 2], [3, 5, 7], 6)   # 5
echo garner([-1, -1], [3, 5], 7)       # 0（最小非負解14の剰余）
```

`garner(residues, moduli: openArray[int], targetMod: int): int` は
`x ≡ residues[i] (mod moduli[i])` の最小非負解 `x` について
`x mod targetMod` を返します。結果は `0..<targetMod` に入ります。
入力列は変更しません。空列の解は0、`targetMod = 1` の結果も0です。

入力列は同じ長さで、入力法と `targetMod` は `1..high(int)`、
入力法同士は互いに素である必要があります。入力法1は複数含めても構いません。
`targetMod` と入力法が互いに素である必要はありません。
剰余は `low(int)..high(int)` の任意の整数を指定できます。
長さ不一致、正でない法、互いに素でない入力法は `ValueError` です。
検査は release／assertions off／danger でも行い、`targetMod = 1` でも省略しません。
非互いに素な合同式の一般化は既存の `crt` を使ってください。

`k = moduli.len`、`M = max(1, max(moduli))` として時間は
`O(k² + k log M)`、補助空間は `O(k)` です。空列では `O(1)` です。
法の積や CRT 解全体を構築しないため、それらが int／Int128 の範囲を
超えても復元できます。配列長 `k+1` が int に収まり、確保可能なメモリが必要です。

各段階で、既に求めた混合基数の桁による部分和と次の基数の係数を、
残りの各入力法および `targetMod` で逐次保持します。
第i段階で係数の逆元を `inv_gcd` から取得し、対応する桁を `0..<moduli[i]`
で決定します。係数はそれ以前の法の積の剰余なので、gcd検査で新しい法と
以前の法すべての互いに素性を確認できます。法1の桁は0になります。
すべての桁をこの範囲で選ぶことで、復元する解は法の積より小さい最小非負解です。
`targetMod` は更新先だけであり、逆元計算には使いません。

剰余の差は `-(high(int)-1)..high(int)-1` に収まります。
乗算と積和は既存の Int128 に拡張してから行います。64bit int では
非負の積和は `H²+H < 2^126`（`H = high(int)`）であり、符号付き128bitに収まります。
剰余を取った後で int に戻すため、int の乗算オーバーフローを避けます。
Int128 と同様に C++ backend と GNU `__int128_t` 対応コンパイラが必要です。
検証環境は Linux x86_64／GCC、Nim 1.6.20 と 2.2.4 です。
Nim VM／JS／MSVC は対象外、32bit・他のCPUやコンパイラは未検証です。

回帰は `src/verify/math/garner_test.nim` にまとめています。
小法全探索と既存 CRT の照合、多倍長整数の直接 CRT 和による独立 oracle、
整数上下限、入力順反転、固定 seed 乱数、法1、共通因子を持つ復元先、
法の積が128bitを超える場合、不正入力と入力保持を検査します。
多倍長 oracle は独自の Euclid 計算を使い、Garner／inv_gcd／Int128 を呼びません。
oracle 自身も小法全探索と照合します。

```sh
nim cpp --path:src --nimcache:/tmp/garner-debug-cache -o:/tmp/garner-debug -r src/verify/math/garner_test.nim
nim cpp --path:src -d:release --assertions:off --nimcache:/tmp/garner-release-cache -o:/tmp/garner-release -r src/verify/math/garner_test.nim
```

既存の verify workflow が両 Nim 版で実行します。専用 CI は追加しません。
