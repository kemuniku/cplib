#!/usr/bin/env bash
set -euo pipefail
# 使用例: NIM=/path/to/nim bash src/verify/AI/run_dynamic_quaternary_validation.sh /tmp/dwm-check
# 通常CIは各 *_test.nim の短縮版。ここでは全量、portable、sanitizer、expanderを順に実行する。
repo=$(cd "$(dirname "$0")/../../.." && pwd)
nim=${NIM:-nim}
out=$(realpath -m "${1:?出力先をリポジトリ外に指定してください}")
case "$out/" in "$repo/"*) echo '出力先はリポジトリ外にしてください' >&2; exit 2;; esac
mkdir -p "$out"
tests=(dynamic_quaternary_vector dynamic_quaternary_waveletmatrix dynamic_quaternary_boundary
       dynamic_bplus_bitvector dynamic_bplus_stress dynamic_bplus_boundary)
run_test() {
    local label=$1 source=$2 backend=$3
    shift 3
    local memory=()
    if [[ $backend == c ]]; then memory+=(--gc:orc); fi
    "$nim" "$backend" -d:release "${memory[@]}" --path:"$repo/src" --nimcache:"$out/cache_$label" \
        -o:"$out/$label" "$@" "$repo/src/verify/AI/${source}_test.nim" >"$out/${label}_compile.log" 2>&1
    ASAN_OPTIONS=detect_leaks=0 UBSAN_OPTIONS=halt_on_error=1:print_stacktrace=1 \
        /usr/bin/time -f '%e seconds, %M KiB' "$out/$label" >"$out/$label.log" 2>"$out/$label.time"
    echo "$label passed ($(cat "$out/$label.time"))"
}
for test in "${tests[@]}"; do
    run_test "ci_$test" "$test" cpp
    run_test "full_$test" "$test" c -d:dynamicWmFullTest
    run_test "portable_$test" "$test" c -d:dynamicWmFullTest -d:dynamicWmPortable -d:cplibDynamicBitVectorPortable
    run_test "asan_$test" "$test" c -d:dynamicWmFullTest -d:debug -d:noSignalHandler \
        --passC:-fsanitize=address,undefined --passC:-fno-sanitize-recover=all \
        --passC:-ftls-model=local-exec --passC:-fno-omit-frame-pointer --passL:-fsanitize=address,undefined
done
for config in quadBranch24 quadBranch32; do
    run_test "$config" dynamic_quaternary_waveletmatrix c -d:dynamicWmFullTest -d:"$config" \
        -d:debug -d:noSignalHandler --passC:-fsanitize=address,undefined \
        --passC:-fno-sanitize-recover=all --passC:-ftls-model=local-exec \
        --passC:-fno-omit-frame-pointer --passL:-fsanitize=address,undefined
done
run_test large dynamic_quaternary_large c -d:dynamicWmFullTest -d:debug -d:noSignalHandler \
    --passC:-fsanitize=address,undefined --passC:-fno-sanitize-recover=all \
    --passC:-ftls-model=local-exec --passC:-fno-omit-frame-pointer --passL:-fsanitize=address,undefined
"$nim" c -d:release --gc:orc --nimcache:"$out/cache_expander" -o:"$out/expander" \
    "$repo/tools/expander/expander.nim" >"$out/expander_compile.log" 2>&1
for mode in plain single_line compress; do
    flags=()
    if [[ $mode == single_line ]]; then flags+=(--single-line); fi
    if [[ $mode == compress ]]; then flags+=(--compress); fi
    (cd "$repo" && "$out/expander" --quiet "${flags[@]}" --lib:"$repo" \
        --output-file:"$out/expanded_$mode.nim" src/verify/AI/dynamic_quaternary_boundary_test.nim)
    "$nim" cpp -d:release --gc:orc --nimcache:"$out/cache_expanded_$mode" -o:"$out/expanded_$mode" \
        "$out/expanded_$mode.nim" >"$out/expanded_${mode}_compile.log" 2>&1
    "$out/expanded_$mode" >"$out/expanded_$mode.log"
    echo "expanded $mode passed"
done
