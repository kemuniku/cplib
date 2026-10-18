"""同じCPUでoffline実装の前後にFastを実行し、全標本を保存する。"""
import argparse
import json
import os
import subprocess
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("binary")
parser.add_argument("--binary-reference", help="same benchmark linked against a saved offline implementation")
parser.add_argument("--reference-label", default="binary")
parser.add_argument("--candidate-label", default="quaternary")
parser.add_argument("--cpu", type=int, required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--size", type=int, default=200000)
parser.add_argument("--repeats", type=int, default=3)
parser.add_argument("--seeds", nargs="+", type=int, default=[11, 29, 47])
parser.add_argument("--scenarios", nargs="+", default=["mixed60", "set30", "set32", "equal", "front", "endpoints", "boundary", "sum"])
args = parser.parse_args()
assert args.cpu in os.sched_getaffinity(0)
hz = os.sysconf("SC_CLK_TCK")

def cpu_times():
    for line in Path("/proc/stat").read_text().splitlines():
        if line.startswith(f"cpu{args.cpu} "):
            return list(map(int, line.split()[1:]))
    raise RuntimeError("target CPU absent")

with open(args.output, "w", encoding="utf-8") as output:
    for scenario in args.scenarios:
        for seed in args.seeds:
            for repeat in range(args.repeats):
                middle = [(args.candidate_label, args.binary, "offline"), ("compressed", args.binary, "compressed")]
                if args.binary_reference:
                    middle.insert(0, (args.reference_label, args.binary_reference, "offline"))
                if repeat % 2:
                    middle.reverse()
                modes = [("fast", args.binary, "fast")] + middle + [("fast", args.binary, "fast")]
                group = []
                for order, (label, executable, mode) in enumerate(modes):
                    before = cpu_times()
                    command = ["/usr/bin/time", "-f", "%M %U %S", "taskset", "-c", str(args.cpu),
                               executable, mode, scenario, str(seed), str(args.size), str(args.size)]
                    completed = subprocess.run(command, check=True, capture_output=True, text=True)
                    after = cpu_times()
                    record = json.loads(completed.stdout)
                    assert record["affinity"] == str(args.cpu), record
                    rss, user, system = completed.stderr.strip().splitlines()[-1].split()
                    busy = sum(after[i] - before[i] for i in [0, 1, 2]) / hz
                    record.update(implementation=label, rep=repeat, order=order, cpu=args.cpu,
                                  rss_kib=int(rss), process_cpu_seconds=float(user)+float(system),
                                  target_cpu_busy_seconds=busy,
                                  other_cpu_busy_estimate=busy-float(user)-float(system),
                                  target_cpu_steal_seconds=(after[7]-before[7])/hz)
                    group.append(record)
                    output.write(json.dumps(record) + "\n")
                    output.flush()
                assert len({record["checksum"] for record in group}) == 1, group
                assert len({record["traceChecksum"] for record in group}) == 1, group
        print(scenario, "PASS", flush=True)
