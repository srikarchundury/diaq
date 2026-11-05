"""Run the Python tests that check results against numpy; exit 1 if any fails.

A test fails when its exit code is not 0 or its output says FAILED / failed. Used by
.github/workflows/tests.yml; locally:

  PYTHONPATH=cpu_build/lib python python_tests/run_ci.py
"""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TESTS = [  # script and arguments
    ["test_matrix_reshape.py"],
    ["test_transpose_kron.py"],
    ["test_tensordot.py"],
    ["test_tensordot_random.py"],
    ["test_dq_times_np.py"],
    ["test_np_times_dq.py"],
    ["test_precision.py"],
    ["test_format_conversion_1.py"],
    ["test_api_vs_numpy.py"],
]

failed = []
for test in TESTS:
    proc = subprocess.run([sys.executable, "-W", "ignore", *test], cwd=HERE, capture_output=True, text=True,
                          timeout=600)
    out = proc.stdout + proc.stderr
    ok = proc.returncode == 0 and "FAILED" not in out and " failed" not in out.lower()
    print(f"{'PASS' if ok else 'FAIL'}  {' '.join(test)}", flush=True)
    if not ok:
        failed.append(test[0])
        print(out[-3000:])
print(f"{len(TESTS) - len(failed)} of {len(TESTS)} Python tests passed")
sys.exit(1 if failed else 0)
