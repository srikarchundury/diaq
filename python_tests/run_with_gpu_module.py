"""Run a DiaQ Python test script against the GPU build's module (diaq_gpu exposes the same API as diaq):

  python python_tests/run_with_gpu_module.py python_tests/test_spmv.py
"""
import runpy
import sys
import types

import diaq_gpu

sys.modules["diaq"] = diaq_gpu
try:  # the tests colour their output with colorama; without it, plain text
    import colorama  # noqa: F401
except ImportError:
    _c = types.ModuleType("colorama")
    _plain = type("Plain", (), {"__getattr__": lambda self, name: ""})()
    _c.Fore = _c.Style = _c.Back = _plain
    _c.init = lambda *a, **k: None
    sys.modules["colorama"] = _c
script = sys.argv[1]
sys.argv = sys.argv[1:]
runpy.run_path(script, run_name="__main__")
