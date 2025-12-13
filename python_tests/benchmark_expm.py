import diaq as dq
import numpy as np
import scipy as sc
from scipy.linalg import expm
from time import perf_counter
import argparse


def generate_sparse_band_matrix(n, density=0.01, num_diagonals=7, seed=None):
	if seed is not None:
		np.random.seed(seed)

	H = np.zeros((n, n), dtype=np.float64)
	half_band = num_diagonals // 2

	for offset in range(-half_band, half_band + 1):
		if np.random.rand() < density:
			continue  # randomly skip some diagonals
		diag_len = n - abs(offset)
		diag_vals = np.random.rand(diag_len)
		if offset >= 0:
			H[np.arange(n - offset), np.arange(offset, n)] = diag_vals
		else:
			H[np.arange(-offset, n), np.arange(n + offset)] = diag_vals

	return H



def main():
	parser = argparse.ArgumentParser()
	parser.add_argument("--t", type=float, required=True)
	parser.add_argument("--qubits", type=int, required=True)
	parser.add_argument("--diags", type=int, required=True)
	parser.add_argument("--density", type=float, default=0.01, help="Probability to skip a band")
	parser.add_argument("--format", choices=["numpy", "csr", "diaq"], required=True)
	parser.add_argument("--itrs", type=int, default=10)
	parser.add_argument("--seed", type=int, default=42)
	parser.add_argument("--outfile", type=str, default="output.txt")
	args = parser.parse_args()

	size = 2 ** args.qubits
	H = generate_sparse_band_matrix(size, density=args.density, num_diagonals=args.diags, seed=args.seed)

	if args.format == "diaq":
		H_dq = dq.from_numpy(H)
	elif args.format == "csr":
		H = sc.sparse.csr_matrix(H)

	timings = []
	for _ in range(args.itrs):
		start = perf_counter()
		if args.format == "diaq":
			dq.expm_negative(H_dq, args.t)
		elif args.format == "csr":
			sc.sparse.linalg.expm(-1j * H * args.t)
		else:
			expm(-1j * H * args.t)
		timings.append(perf_counter() - start)

	avg_time = np.mean(timings)
	std_time = np.std(timings)

	with open(args.outfile, "w") as f:
		f.write(f"Qubits: {args.qubits}\n")
		f.write(f"Num diagonals: {args.diags}\n")
		f.write(f"t: {args.t}\n")
		f.write(f"Format: {args.format}\n")
		f.write(f"Iters: {args.itrs}\n")
		f.write(f"Avg time: {avg_time:.6f} s\n")
		f.write(f"Std time: {std_time:.6f} s\n")
	print(f"[DONE] {args.format} | qubits={args.qubits}, diags={args.diags}, avg_time={avg_time:.6f}s")


if __name__ == '__main__':
	main()
