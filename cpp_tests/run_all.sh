#!/usr/bin/env bash
# Run every named C++ test of cpp_tests/test_main.cpp; exit 1 if any fails.
# A test fails when it exits non-zero or prints false / FAIL / mismatch / error / corruption.
# ("test" is skipped: it needs a test-case index.)
#
#   bash cpp_tests/run_all.sh cpu_build/bin/tests
set -uo pipefail
bin="${1:-cpu_build/bin/tests}"
here="$(cd "$(dirname "$0")" && pwd)"
names=$(grep -o 'strcmp(argv\[1\], *"[^"]*")' "$here/test_main.cpp" | sed 's/.*"\(.*\)")/\1/' | grep -v '^test$')
pass=0; fail=0
for t in $names; do
  out=$(timeout 120 "$bin" "$t" 2>&1); code=$?
  if [ $code -eq 0 ] && ! echo "$out" | grep -qi -E 'false|fail|wrong|mismatch|error|invalid|corrupt'; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1)); echo "FAIL $t (exit $code)"; echo "$out" | tail -20
  fi
done
echo "$pass passed, $fail failed"
[ $fail -eq 0 ]
