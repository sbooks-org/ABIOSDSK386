#!/bin/sh
# Test driver: run every tests/case-*.sh against each implementation.
# Each case script takes the tool path as $1 and passes/fails via exit
# status.  Expected divergences between the two implementations are
# handled inside the case scripts.
set -eu
cd "$(dirname "$0")/.."

fail=0
for bin in ./addini ./addini.py; do
    if [ ! -x "$bin" ]; then
        echo "missing $bin — run 'make build' first" >&2
        exit 1
    fi
    echo "=== $bin ==="
    for case in tests/case-*.sh; do
        if out=$(sh "$case" "$bin" 2>&1); then
            echo "  PASS  $case"
        else
            echo "  FAIL  $case"
            printf '%s\n' "$out" | sed 's/^/        /'
            fail=1
        fi
    done
done
echo "=== done ==="
[ "$fail" -eq 0 ]
