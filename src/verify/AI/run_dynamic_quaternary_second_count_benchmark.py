#!/usr/bin/env python3
"""点更新と第2相異最大値の頻度クエリを、変更前後の同一traceで順番に比較する。"""
import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
import platform
import random
import statistics
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("baseline", type=Path)
    parser.add_argument("final", type=Path)
    parser.add_argument("output", type=Path, help="リポジトリ外の新規CSV（同名JSONも作成）")
    parser.add_argument("--cpu", type=int, default=min(os.sched_getaffinity(0)))
    parser.add_argument("--n", type=int, default=200000)
    parser.add_argument("--ops", type=int, default=200000)
    parser.add_argument("--width", type=int, default=30)
    parser.add_argument("--rate", type=int, default=50)
    parser.add_argument("--seeds", type=int, nargs="+", default=[0, 1, 2])
    parser.add_argument("--repeats", type=int, default=3)
    parser.add_argument("--isa", type=int, choices=range(4), default=0)
    parser.add_argument("--patterns", nargs="+", choices=["random", "low_cardinality", "constant"],
                        default=["random", "low_cardinality", "constant"])
    args = parser.parse_args()
    if (args.cpu not in os.sched_getaffinity(0) or args.n < 1 or args.ops < 0
            or not 0 <= args.width <= 30 or not 0 <= args.rate <= 100
            or args.repeats < 1 or any(not 0 <= seed <= 1000 for seed in args.seeds)
            or len(args.seeds) != len(set(args.seeds)) or len(args.patterns) != len(set(args.patterns))):
        parser.error("CPU、N、Q、ビット幅、更新率、反復数、seedまたはpatternが不正です")
    root = Path(__file__).resolve().parents[3]
    output = args.output.resolve()
    if output.suffix != ".csv":
        parser.error("出力名の拡張子は.csvにしてください")
    if output.exists() or output.with_suffix(".json").exists():
        parser.error("出力CSVまたはJSONが既に存在します")
    if root == output or root in output.parents:
        parser.error("出力先はリポジトリ外にしてください")
    binaries = {"baseline": args.baseline.resolve(), "final": args.final.resolve()}
    rss_available = Path("/usr/bin/time").is_file()
    metadata = {
        "arguments": {k: str(v) if isinstance(v, Path) else v for k, v in vars(args).items()},
        "platform": platform.platform(),
        "peak_rss_available": rss_available,
        "binaries": {k: {"path": str(v), "sha256": hashlib.sha256(v.read_bytes()).hexdigest()}
                     for k, v in binaries.items()},
        "note": "B16/W64。cpuTimeは構築と操作を分離。trace生成・入出力は計測外。更新数はQ*rate//100。"
                + ("RSSはtraceを含むプロセス全体。" if rss_available else "/usr/bin/timeがないためRSSは取得せずnullとする。"),
    }
    jobs = [(variant, pattern, seed, rep) for variant in binaries
            for pattern in args.patterns for seed in args.seeds for rep in range(args.repeats)]
    random.Random(751083).shuffle(jobs)
    fields = ["variant", "pattern", "seed", "rep", "n", "q", "width", "update_percent", "isa",
              "active_kernel", "updates", "queries", "build_seconds", "operation_seconds",
              "storage_bytes", "trace_checksum", "checksum", "peak_rss_kib"]
    rows = []
    checksums = {}
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("x", newline="") as stream:
        writer = csv.DictWriter(stream, fields)
        writer.writeheader()
        for variant, pattern, seed, rep in jobs:
            with tempfile.TemporaryDirectory(prefix="quad-second-count-") as temporary:
                rss = Path(temporary) / "rss.txt"
                command = ["taskset", "-c", str(args.cpu)]
                if rss_available:
                    command += ["/usr/bin/time", "-f", "%M", "-o", str(rss)]
                command += [str(binaries[variant]), str(args.n), str(args.ops), str(args.width), str(args.rate),
                           pattern, str(seed), str(args.isa), str(rep)]
                result = subprocess.run(command, text=True, capture_output=True, check=False)
                if result.returncode == 77:
                    raise RuntimeError(f"ISA {args.isa} は利用できません: {variant}")
                if result.returncode:
                    raise RuntimeError(f"{variant} failed ({result.returncode}): {result.stderr}")
                columns = next(csv.reader([result.stdout.strip()]))
                if len(columns) != 16:
                    raise RuntimeError("ベンチマークの出力列数が不正です")
                expected_arguments = [str(args.n), str(args.ops), str(args.width), str(args.rate),
                                      pattern, str(seed), str(args.isa), str(rep)]
                if columns[:8] != expected_arguments:
                    raise RuntimeError("ベンチマークの出力引数が一致しません")
                row = dict(zip(fields, [variant, pattern, seed, rep, args.n, args.ops, args.width, args.rate,
                                       args.isa, columns[10], int(columns[8]), int(columns[9]),
                                       float(columns[11]), float(columns[12]), int(columns[13]),
                                       int(columns[14]), int(columns[15]),
                                       int(rss.read_text()) if rss_available else None]))
                key = (pattern, seed)
                pair = (row["trace_checksum"], row["checksum"])
                if key in checksums and checksums[key] != pair:
                    raise RuntimeError(f"同一traceの入力または結果checksumが一致しません: {key}")
                checksums[key] = pair
                writer.writerow(row)
                stream.flush()
                rows.append(row)
                print(f"{variant} {pattern} seed={seed} rep={rep}: {row['operation_seconds']:.6f}s", flush=True)
    summary = []
    for pattern in args.patterns:
        for seed in args.seeds:
            item = {"pattern": pattern, "seed": seed}
            for variant in binaries:
                group = [r for r in rows if r["variant"] == variant and r["pattern"] == pattern
                         and r["seed"] == seed]
                assert len(group) == args.repeats
                item[variant] = {
                    "repeats": len(group),
                    "build_median": statistics.median(r["build_seconds"] for r in group),
                    "operation_median": statistics.median(r["operation_seconds"] for r in group),
                    "operation_max": max(r["operation_seconds"] for r in group),
                    "build_plus_operation_median": statistics.median(r["build_seconds"] + r["operation_seconds"]
                                                                      for r in group),
                    "storage_bytes": group[0]["storage_bytes"],
                    "rss_median_kib": statistics.median(r["peak_rss_kib"] for r in group) if rss_available else None,
                }
            item["operation_speedup"] = item["baseline"]["operation_median"] / item["final"]["operation_median"]
            summary.append(item)
    metadata["summary"] = summary
    output.with_suffix(".json").write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
