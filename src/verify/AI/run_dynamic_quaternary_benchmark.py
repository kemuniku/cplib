#!/usr/bin/env python3
"""構築済みの四分岐/二分岐バイナリを同一trace・単一CPUで順番を混ぜて比較する。"""
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

p = argparse.ArgumentParser(description=__doc__)
p.add_argument("quad", type=Path)
p.add_argument("binary", type=Path)
p.add_argument("output", type=Path, help="リポジトリ外の新規CSV")
p.add_argument("--cpu", type=int, default=min(os.sched_getaffinity(0)))
p.add_argument("--repeats", type=int, default=5)
p.add_argument("--seeds", type=int, default=3)
p.add_argument("--n", type=int, default=200000)
p.add_argument("--width", type=int, choices=[18, 32, 60], default=60)
p.add_argument("--ops", type=int, default=200000)
p.add_argument("--rate", type=int, default=50)
p.add_argument("--pattern", choices=["random", "biased", "constant", "endpoints", "hotspot", "front_insert", "threshold_cycle"], default="random")
p.add_argument("--compare-isa", action="store_true", help="同じB16/W64でscalarとAVX-512も比較")
p.add_argument("--wide", action="store_true", help="B32/W256,W512のAVX2測定を追加。最適化/prefixは構築時のdefineで選ぶ")
a = p.parse_args()
if a.cpu not in os.sched_getaffinity(0) or a.repeats < 1 or not 1 <= a.seeds <= 1001 or a.n < 1 or a.ops < 0 or not 0 <= a.rate <= 100:
    p.error("CPU、反復数、seed数、N、Q、更新率が不正です")
root = Path(__file__).resolve().parents[3]
output = a.output.resolve()
if output.exists() or output.with_suffix(".json").exists():
    p.error("出力CSVまたはJSONが既に存在します")
if root == output or root in output.parents:
    p.error("出力先はリポジトリ外にしてください")
configs = [("binary", 32, 4096, 2), ("quad", 16, 4096, 2), ("quad", 24, 4096, 2), ("quad", 32, 8192, 3)]
if a.compare_isa:
    configs += [("quad", 16, 4096, 1), ("quad", 16, 4096, 3)]
if a.wide:
    configs += [("quad", 32, 16384, 2), ("quad", 32, 32768, 2)]
jobs = [(c, seed, rep) for c in configs for seed in range(a.seeds) for rep in range(a.repeats)]
random.Random(652801).shuffle(jobs)
binaries = {"quad": a.quad.resolve(), "binary": a.binary.resolve()}
metadata = {
    "arguments": {k: str(v) if isinstance(v, Path) else v for k, v in vars(a).items()},
    "platform": platform.platform(),
    "binaries": {k: {"path": str(v), "sha256": hashlib.sha256(v.read_bytes()).hexdigest()} for k, v in binaries.items()},
    "note": "測定中は他の負荷を避ける。cpuTimeは構築/操作のみ、RSSは入力traceを含むプロセス全体。"
}
output.parent.mkdir(parents=True, exist_ok=True)
fields = ["variant", "branch", "leaf_bits", "isa", "seed", "rep", "build_seconds", "operation_seconds", "storage_bytes", "checksum", "peak_rss_kib"]
rows, checksums = [], {}
with output.open("x", newline="") as f:
    writer = csv.DictWriter(f, fields)
    writer.writeheader()
    for (variant, branch, leaf, isa), seed, rep in jobs:
        with tempfile.TemporaryDirectory(prefix="dwm-time-") as tmp:
            rss = Path(tmp) / "rss.txt"
            args = ["taskset", "-c", str(a.cpu), "/usr/bin/time", "-f", "%M", "-o", str(rss), str(binaries[variant]), str(branch), str(isa), str(leaf), str(a.n), str(a.width), str(a.ops), str(a.rate), a.pattern, str(rep), str(seed)]
            result = subprocess.run(args, text=True, capture_output=True, check=False)
            if result.returncode == 77:
                print(f"ISA unavailable: {variant} B{branch} ISA={isa}", flush=True)
                continue
            if result.returncode:
                raise RuntimeError(result.stderr)
            columns = next(csv.reader([result.stdout.strip()]))
            if len(columns) != 13:
                raise RuntimeError("ベンチマークの出力列数が不正です")
            row = dict(zip(fields, [variant, branch, leaf, isa, seed, rep, float(columns[9]), float(columns[10]), int(columns[11]), int(columns[12]), int(rss.read_text())]))
            if seed in checksums and checksums[seed] != row["checksum"]:
                raise RuntimeError("同一traceのchecksumが一致しません")
            checksums[seed] = row["checksum"]
            writer.writerow(row)
            f.flush()
            rows.append(row)
            print(f"{variant} B{branch}/{leaf} seed={seed} rep={rep}: {row['operation_seconds']:.6f}s", flush=True)
summary = []
for c in configs:
    for seed in range(a.seeds):
        group = [r for r in rows if (r["variant"], r["branch"], r["leaf_bits"], r["isa"]) == c and r["seed"] == seed]
        if not group:
            continue
        assert len(group) == a.repeats
        summary.append({"config": c, "seed": seed, "repeats": len(group), "operation_median": statistics.median(r["operation_seconds"] for r in group), "operation_max": max(r["operation_seconds"] for r in group), "build_plus_operation_median": statistics.median(r["build_seconds"] + r["operation_seconds"] for r in group), "storage_bytes": group[0]["storage_bytes"], "rss_median_kib": statistics.median(r["peak_rss_kib"] for r in group)})
metadata["summary"] = summary
output.with_suffix(".json").write_text(json.dumps(metadata, ensure_ascii=False, indent=2) + "\n")
print(json.dumps(summary, ensure_ascii=False, indent=2))
