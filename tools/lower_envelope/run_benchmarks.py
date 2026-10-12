import csv
import io
import os
from pathlib import Path
import statistics
import subprocess
import sys


def measure(executable, kind, n):
    """Linuxのwait4で、1実行の構築CPU時間とプロセス最大RSSを測る。"""
    process = subprocess.Popen(
        [executable, kind, str(n)], stdout=subprocess.PIPE,
        stderr=subprocess.PIPE, text=True,
    )
    _, status, usage = os.wait4(process.pid, 0)
    process.returncode = os.waitstatus_to_exitcode(status)
    stdout = process.stdout.read()
    stderr = process.stderr.read()
    if process.returncode:
        raise RuntimeError(stdout + stderr)
    values = []
    for line in stdout.splitlines():
        fields = dict(field.split("=", 1) for field in line.split(",")[1:])
        values.append((float(fields["seconds"]), int(fields["vertices"])))
    return values, usage.ru_maxrss


def main():
    """各ケースを独立プロセスで3回測定し、CSVを標準出力へ出す。"""
    executable = str(Path(sys.argv[1]).resolve())
    n = int(sys.argv[2]) if len(sys.argv) > 2 else 200000
    output = io.StringIO()
    writer = csv.writer(output, lineterminator="\n")
    writer.writerow(["case", "N", "lower_seconds_median", "upper_seconds_median",
                     "lower_vertices", "upper_vertices", "max_peak_rss_kib"])
    for kind in ["random_segments", "random_rays", "disjoint", "nested",
                 "islands", "points", "parallel", "crossings"]:
        runs = [measure(executable, kind, n) for _ in range(3)]
        assert all(run[0][0][1] == runs[0][0][0][1] and
                   run[0][1][1] == runs[0][0][1][1] for run in runs)
        writer.writerow([kind, n,
                         f"{statistics.median(run[0][0][0] for run in runs):.6f}",
                         f"{statistics.median(run[0][1][0] for run in runs):.6f}",
                         runs[0][0][0][1], runs[0][0][1][1],
                         max(run[1] for run in runs)])
    print(output.getvalue(), end="")


if __name__ == "__main__":
    main()
