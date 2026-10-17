"""Alternate a separately built benchmark on one CPU; retain every completed run."""
import argparse
import json
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("binary")
parser.add_argument("--cpu", type=int, required=True)
parser.add_argument("--output", required=True)
parser.add_argument("--size", type=int, default=200000)
parser.add_argument("--repeats", type=int, default=3)
parser.add_argument("--seeds", nargs="+", type=int, default=[11, 29, 47])
args = parser.parse_args()
with open(args.output, "w", encoding="utf-8") as output:
    for scenario in ["mixed60", "set30", "set32", "equal", "front", "endpoints", "boundary", "sum"]:
        for seed in args.seeds:
            for repeat in range(args.repeats):
                modes = ["fast", "offline"] if scenario == "sum" else ["fast", "offline", "compressed"]
                if repeat % 2:
                    modes.reverse()
                group = []
                for mode in modes:
                    command = ["/usr/bin/time", "-f", "%M", "taskset", "-c", str(args.cpu),
                               args.binary, mode, scenario, str(seed), str(args.size), str(args.size)]
                    completed = subprocess.run(command, check=True, capture_output=True, text=True)
                    record = json.loads(completed.stdout)
                    record.update(rep=repeat, cpu=args.cpu,
                                  rss_kib=int(completed.stderr.strip().splitlines()[-1]))
                    group.append(record)
                    output.write(json.dumps(record) + "\n")
                    output.flush()
                assert len({record["checksum"] for record in group}) == 1, group
        print(scenario, "PASS", flush=True)
