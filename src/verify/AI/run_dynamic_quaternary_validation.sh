#!/usr/bin/env bash
set -euo pipefail
# NIM=/path/to/nim bash src/verify/AI/run_dynamic_quaternary_validation.sh /tmp/dwm-check
# 複数versionは --nim /path/nim-1.6/bin/nim --nim /path/nim-2.2/bin/nim。詳細は --help。
repo=$(cd "$(dirname "$0")/../../.." && pwd)
exec python3 "$repo/src/verify/AI/run_dynamic_quaternary_validation.py" "$@"
