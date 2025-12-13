import numpy as np
import diaq as dq


def test_precision_1():
	np.random.seed(0)
	s = 32
	mat_a = np.random.rand(s, s) + 1j * np.random.rand(s, s)
	mat_b = np.random.rand(s, s) + 1j * np.random.rand(s, s)
	dq_mat_a = dq.from_numpy(mat_a)
	dq_mat_a.print_meta()

	dense_back_a = dq.to_numpy(dq_mat_a).reshape((s, s))
	assert np.testing.assert_allclose(mat_a, dense_back_a, atol=1e-7, rtol=1e-07) == None

	dq_mat_b = dq.from_numpy(mat_b)
	dq_mat_b.print_meta()

	dq_mat_c = dq.product(dq_mat_a, dq_mat_b)
	dq_mat_c.print_meta()
	mat_c = dq.to_numpy(dq_mat_c).reshape((s, s))

	dense_mat_c = np.dot(mat_a, mat_b)
	assert np.testing.assert_allclose(mat_c, dense_mat_c, atol=1e-7, rtol=1e-07) == None


def test_precision_2():
	Hadamard = np.array([
		[1/np.sqrt(2), 1/np.sqrt(2)],
		[1/np.sqrt(2), -1/np.sqrt(2)]
	], dtype=complex)
	dq_H = dq.from_numpy(Hadamard)

	mat_a = np.kron(np.kron(np.kron(np.kron(Hadamard, Hadamard), Hadamard), Hadamard), Hadamard)
	mat_b = np.kron(np.kron(np.kron(np.kron(Hadamard, Hadamard), Hadamard), Hadamard), Hadamard)

	dense_mat_c = np.dot(mat_a, mat_b)

	dq_H_H = dq.kroneckerProduct(dq_H, dq_H)
	print("#"*50)
	print("dq_H_H:")
	dq_H_H.print_meta()
	print("#"*50)

	dq_H_H_H = dq.kroneckerProduct(dq_H_H, dq_H)
	print("#"*50)
	print("dq_H_H_H:")
	dq_H_H_H.print_meta()
	print("#"*50)

	dq_H_H_H_H = dq.kroneckerProduct(dq_H_H_H, dq_H)
	print("#"*50)
	print("dq_H_H_H_H:")
	dq_H_H_H_H.print_meta()
	print("#"*50)

	dq_H_H_H_H_H = dq.kroneckerProduct(dq_H_H_H_H, dq_H)
	print("#"*50)
	print("dq_H_H_H_H_H:")
	dq_H_H_H_H_H.print_meta()
	print("#"*50)

	dq_mat_b = dq.kroneckerProduct(dq.kroneckerProduct(dq.kroneckerProduct(dq.kroneckerProduct(dq_H, dq_H), dq_H), dq_H), dq_H)

	dq_mat_c = dq.product(dq_H_H_H_H_H, dq_mat_b)
	print("#"*50)
	print("dq_mat_c:")
	dq_mat_c.print_meta()
	print("#"*50)

	mat_c = dq.to_numpy(dq_mat_c).reshape((32, 32))

	assert np.testing.assert_allclose(mat_c, dense_mat_c, atol=1e-7, rtol=1e-07) == None


if __name__ == "__main__":
	for name, func in list(globals().items()):
		if callable(func) and name.startswith("test_"):
			print(f"\033[92mRunning {name}\033[0m", end=" --> ")
			func()
			print(f"\033[92mTest {name} passed\033[0m")
