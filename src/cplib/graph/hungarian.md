# Hungarian法による最小費用割当

```nim
import cplib/graph/hungarian
let answer = min_cost_assignment(@[@[4'i32, 1, 3], @[2'i32, 0, 5]])
# feasible=true, cost=3, columnOfRow=@[1,0]
```

N×Mの矩形行列で、全行を相異なる列へ割り当てる。返り値は
`MinCostAssignmentResult(feasible: bool, cost: int64, columnOfRow: seq[int])`。
負費用と同費用に対応し、列番号は0始まり。`allowed`を省略すれば全辺を許可し、
同形のbool行列を渡すとtrueの辺だけを使う。費用値をINFとして予約しない。
N>Mまたは完全割当がなければfalse/0/空列、空行列はtrue/0/空列。
形状違反はValueError、入力は変更しない。

## 入力型と実行経路

- `min_cost_assignment` の **int32入力** は高速版を使う。CPU/OSが対応すればAVX-512、
  それ以外はAVX2。AVX2も利用できなければValueError（空行列でも同じ）。
  入力はint32全域、内部はint64。N≤32767、N,M<high(int)と利用可能メモリが必要。
- **int/int8/int16/int64入力** は従来の汎用128bit経路を維持する。
  int64全域の費用、N≤2³¹−1、N,M<high(int)に対応し、最終費用がint64範囲外なら
  release/dangerでもOverflowDefect。int32への暗黙の切り詰めは行わない。
- `min_cost_assignment_wide` は入力型に関係なく汎用128bit版を明示選択する。
  int32をAVX2未対応機で使う場合や、従来の同値規則が必要な場合にも利用できる。

高速版は同距離なら未割当列を優先し、密行列を行最小値で貪欲初期化する。
最適費用は同じでも汎用版とは同値解の列順が異なる場合がある。
例えば `[[0,0,0],[0,1,1],[1,0,0]]` の汎用版は `[1,0,2]`、高速版は `[2,0,1]`。
SSE/AVX2/AVX512同士は列順まで同じ。時間O(N²M)、追加領域O(N+M)。

詳細指定には `min_cost_assignment_int32_fast` を使う。

```nim
let forced = min_cost_assignment_int32_fast(cost, allowed, vector=assignmentVectorAvx2)
let stable = min_cost_assignment_int32_fast(cost, allowed, tieBreak=assignmentStable)
let scalar = min_cost_assignment_int32_fast(cost, allowed, backend=assignmentScalar)
```

`vector`の既定は`assignmentVectorAuto`。`assignmentVectorAvx2`と
`assignmentVectorAvx512`はその方式を要求し、非対応ならValueError。
`min_cost_assignment_int32_avx2` / `min_cost_assignment_int32_avx512` も明示要求用。
`assignmentVectorSse`は比較用で、SSE4.2非対応時のみスカラーへ戻る。
`backend=assignmentScalar`はvectorより優先する。`assignmentStable`は最小列番号の
同値規則を選び、貪欲初期化を無効化する。初期化融合・密行列初期割当を比較する
`fuseInitialization` / `greedyDense` は通常trueのまま使う。

## CPU/OSと数値の安全性

GCC/Clangのx86 C/C++用。CPUIDのXSAVE/OSXSAVE/AVXを調べてからXGETBVを実行する。
AVX2はXCR0のXMM/YMM（0x6）とAVX2ビット、AVX512はさらにopmask/ZMM（0xe6）と
AVX512Fを要求する。DQ/BW/VLは不要。検出はモジュール初期化時に保存する。
関数ごとのtarget属性でAVX2とAVX512を分離し、全体の高ISAフラグは不要。
全体に`-march=native`や`-mavx*`を追加すると非対応CPUでの安全性は保証されない。
非x86や対応コンパイラ以外では高速版の自動経路は非対応エラーになる。

`assignment_int32_avx2_available()` / `assignment_int32_avx512_available()`で検出結果を
取得できる。`assignment_int32_vector_backend(requested)`は選択結果を返す。
検証用の `-d:hungarianDisableAvx512` はAVX512を除外しAutoをAVX2へ、
`-d:hungarianDisableAvx2` は両AVXを除外しAutoをエラーにする。
`-d:hungarianForceScalar` はSIMDを除外するので、明示的にスカラー経路を使う。

ポテンシャル・距離・way・列ID・総費用は64bitを維持する。AVX2は4列、AVX512は8列を
緩和し、残りをスカラー処理する。行最小値は入力そのものの比較だけなのでint32を使う。
費用をint64へ拡張して2³¹を足した上限をQ=2³²−1とする。成功する増加距離D≤NQ、
成功済みDの和T≤N²Q、−v≤T、u≤Q+T。不能探索の確定距離もNQ+T以下なので、
距離候補は(2N²+N+1)Q以下。N=32767で9,222,949,830,832,259,070 < INT64_MAX。
途中のoffset演算もこの範囲内で、INF=INT64_MAXを加減算しない。

探索中の双対変数を固定し、根からの絶対距離を保存する。自由列への距離Dが確定したら
根のuにD、訪問済みマッチ列jのuにD−dist[j]、vにその負をまとめて加える。
これは通常のdelta更新を合算したもので、dual実行可能性とtightなマッチ辺を保つ。
同距離の未割当列を先に選んでも、残った同距離列の更新量は0なので最適性を保つ。

## 検証・測定

Nim1.6.20/2.2.4、GCC/G++13.3.0、C/C++でdebug/release/danger、検出無効化、
ASan+UBSanを検証。小さい全探索、汎用128bitとの比較、負値、同値、int32端値、
末尾幅、矩形、禁則・不能、ramp/binary悪条件を12,655ケースで確認する。
境界テストは65,538/65,539列、ID>65535、32bitを超える総費用を含む。
サニタイザはARC+setjmp、detect_leaks=0。実AVX2-only機、Clang、非x86、最大行数、
リーク検査は未検証。AVX512無効化時のAuto→AVX2と、AVX2関数へのAVX512命令混入なしを確認。

Xeon Gold 5118 @2.30GHzを公開したKVM、Nim2.2.4 C++ / -O3で、前処理を含むAPI全体を測定。
同じアルゴリズムと64bit幅で比較した15条件・960標本の実験では、AVX512の対AVX2速度比は
512²乱数で1.55～1.73倍、禁則辺で1.52～1.83倍、ramp悪条件で1.88～1.94倍、
binary悪条件で1.67～1.95倍。同値の多い軽い入力ではAVX2が速い場合もある。
CPU機能による自動選択は、全入力で最速の方式を保証するものではない。
これらは統合前の同一カーネルを使った実験値で、汎用128bitや旧CPU設定との比ではない。

再現用の `tools/benchmarks/hungarian.nim` を次のように実行できる。

```sh
nim cpp -d:danger -d:hungarianAutoVectorize --opt:speed --path:src --passC:-O3 -o:/tmp/hungarian-bench tools/benchmarks/hungarian.nim
for plan in interleaved0 interleaved1 avx2 avx512 avx512 avx2; do
  taskset -c 0 /tmp/hungarian-bench "$plan"
done
```

入力生成と参照解との照合は時間外。確保、行最小値、貪欲初期化、解復元を含める。
seed=20261011+N*1009+M、2回warmupで50ms目標のbatch数を決め、8標本の中央値を使う。
各標本前に100ms待機と1回warmup。交互の開始順を反転し、別プロセスでも2巡する。
物理クロック・ホスト負荷は未測定/未制御で、待機が周波数復帰を保証するとはしない。
