---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults
layout: my_default
---
<head><link rel="stylesheet" href="style.css"> </head>
<!-- Side navigation -->
<div class="sidenav">
	<hr/>
		<b> Tensor-Network based Quantum Simulation (TNQS) </b>
	<hr/>
  <a href="#1">Motivation</a>
  <a href="#2">Problem Statement</a>
  <a href="#3">Empirical/Visual Analysis</a>
  <a href="#8">Sparsity Analysis</a>
  <a href="#4">Algorithms and Data Structures</a>
  <a href="#5">Key Outcomes</a>
  <a href="#6">Preliminary Results</a>
  <a href="#7">Future Scope</a>
	<hr/>
	<b> Project Info </b>
	<hr/>
	<div class="sub_link">
	<a href="https://github.ncsu.edu/tnqs/" target="_blank"> Git Organisation (TNQS)</a>
	<a href="https://github.ncsu.edu/tnqs/sparse-tnqs/archive/refs/heads/main.zip" class="sub_link"> Download Library (zip)</a>
	<hr/>
	<b> Group Info </b>
	<hr/>
	<a href="https://arcb.csc.ncsu.edu/~mueller/" target="_blank" class="sub_link"> Dr. Frank Mueller</a>
	<a href="http://fruitfly1026.github.io/" target="_blank" class="sub_link"> Dr. Jiajia Li</a>
	<a href="https://srikarchundury.github.io" target="_blank" class="sub_link"> Srikar Chundury</a>
	<a href="https://www.linkedin.com/in/blake-burgstahler/" target="_blank" class="sub_link"> Blake Burgstahler</a>
	<hr/>
	<b> More Info </b>
	<hr/>
	<a href="https://github.ncsu.edu/tnqs/sparse-tnqs/tree/main/literature_survey" target="_blank" class="sub_link"> Literature Survey</a>
	<a href="https://github.ncsu.edu/tnqs/sparse-tnqs/tree/main/discussions" target="_blank" class="sub_link"> Reports/Discussions</a>
	</div>
	<hr/>
	<a href="https://arcb.csc.ncsu.edu/~mueller/cross.html" target="_blank"> <b> About PPoSS project </b> </a>
	<hr/>
</div>


<div class="main_content">

<br/>
<hr id="1" />

## Motivation ##
* Quantum circuit simulation can be posed as a directed graph problem, where each node is a "tensor" representing the quantum gate (unitary matrix) operation on a set of input qubits. Example- <br/>
<center>
	<figure style="display: inline-block;">
		<img src="images/circuit_example.png" width="300">
		<figcaption>GHZ circuit from supermarQ</figcaption>
	</figure>
		&nbsp;
	<figure style="display: inline-block;">
		<img src="images/tn_example.png" width="300">
		<figcaption>Qiskit-generated DAG</figcaption>
	</figure>
</center>

<br/>

### State-Vector and Unitary Simulation ###

* The state of these input qubits evolves as the quantum circuit proceeds in time steps. With each state evolution, we are essentially performing a "contraction" (multiplication) of the input tensor (vector/matrix) with a gate tensor (X, Y, Z, CX, CCX etc) until we reach the end of the circuit.
* The order in which is contraction is performed is crucial for performance; just like how order of n matrix multiplications is crucial for performance.
* Despite its promise, simulating large quantum circuits is a daunting task due to the exponential growth of the state space. Hence there can be times when a single tensor is too huge to be stored as it is. Here is where tensor-networks come handy.

### Tensor Network Simulation ###

* Tensors, as we know, are multi-dimensional maps or functions, with a 2-dimensional tensor equivalent to a matrix. Tensor networks are modeled as graphs, with tensors as vertices and tensor methods, like contraction and decomposition, as edges. They have broad implications in various fields, including applied mathematics, chemistry, physics, and machine learning etc.
* There are algorithms to get the most optimal path (like opt_einsum). Read "Algorithms for Tensor Network Contraction Ordering" under literature_survey.
* Once an optimal path is chosen, the complex quantum circuit which had multiple intermediate gates/tensors, boils down to just one big really sparse unitary matrix. Modern simulation tools like qiskit have methods to get this unitary for any given quantum circuit. As seen below (notice the increase in dimensionality after contraction)-<br/>
Note: In this example, the circles represent tensors in the network, for instance, the yellow circle represents the Hadamard gate and all the green ones represent CNOT gates. The lines (edges) represent bond interactions. The measurements have been removed, since this is a unitary simulation. In the notation "i{x}_qq({y})", x represents the time step and y represents the qubit that tensor acts on.
<center>
	<figure style="display: inline-block;">
		<img src="images/ghz_tn.png" width="500" height="200">
		<figcaption>GHZ tensor network before contraction</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/tn_post_contraction.png" width="300">
		<figcaption>GHZ tensor network after contraction</figcaption>
	</figure>
</center>
<br/>

* Tensor Networks can be grouped into classes based on topology- MPS, TTN, PEPS, MERA and more.
<center>
	<figure style="display: inline-block;">
		<img src="images/mps.png" width="500">
		<figcaption>Matrix Product State</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/peps.png" width="300">
		<figcaption>Projected Entangled Pair State</figcaption>
	</figure>
</center>
<br/>

* For more information related to tensor networks, refer to <a href="http://tensornetwork.org/" target="_blank"> Tensor-Networks</a>.

<hr id="2" />

## Quantum Sparsity - Problem Statement ##
Explore and analyze the sparsity in the above-mentioned simulations and exploit it to reduce the overall simulation time.

Approach:
* Numerical Library: "dia_lite" (placeholder name)
* Quantum Algorithm-level Library: TODO

<hr id="3" />

## Preliminary Empirical/Visual Analysis (Fall '22) ##

* Obtained final unitaries using quimb, qiskit (unitary simulator) for quantum circuit benchmarks described in the supermarQ paper (refer literature survey below). Some results (for 3 qubit benchmark circuits):

	<center>
	<figure style="display: inline-block;">
		<img src="images/ghz_circuit.png" height="160">
		<figcaption>GHZ circuit</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/ghz_unitary.png" width="600">
		<figcaption>GHZ unitary matrix</figcaption>
	</figure>
	<hr width="80%"/>
	<figure style="display: inline-block;">
		<img src="images/ham_circuit.png" height="140" width="450">
		<figcaption>Hamiltonian circuit</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/ham_unitary.png" width="600">
		<figcaption>Hamiltonian unitary matrix</figcaption>
	</figure>
	<hr width="80%"/>
	<figure style="display: inline-block;">
		<img src="images/mermin_bell_circuit.png" height="140" width="450">
		<figcaption>Mermin Bell Pair Generation circuit</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/mermin_bell_unitary.png" width="600">
		<figcaption>Mermin Bell Pair Generation unitary matrix</figcaption>
	</figure>
	<hr width="80%"/>
	</center>
<br/>

* Final unitaries can be compactly represented using just the diagonals and anti-diagonals.
* Final unitaries' range of values is limited and can easily be written as constant times a matrix with just +1,0,-1 paving scope for reducing #flops in contraction kernels.
* The intermediate matrices in the contration path also have similar sparsity patterns.
* We then designed a new sparse data structure-
    * A quantum sparse matrix (QSM) is a collection of "diagonals" stored as a hashmap, with each diagonal's index as the key (0 for main diagonal, 1 for super diagonal, -1 for sub diagonal and so on.)
    * Each diagonal is represented using 2 arrays (one for indices and one for the actual values) that store only non-zero values; diagonal is also sparse.
    * Each value is a complex number. We later moved away from this approach; to store real and imaginary numbers separately.

	<center>
	<figure style="display: inline-block;">
	<img src="images/vqe_prep_circuit.png" width="60%">
	<figcaption>VQE preparation circuit - taken from Qiskit textbook</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
	<img src="images/vqe_prep_unitary.png" width="600">
	<figcaption>Unitary of this circuit</figcaption>
	</figure>
	</center>


<hr id="8" />

### Sparsity Analysis ###

<center>
	<figure style="display: inline-block;">
		<img src="images/ghz_diagonal_before.png" width="400">
		<figcaption>GHZ</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/ghz_diagonal_during.png" width="400">
		<figcaption>During left to right contraction</figcaption>
	</figure>
	<hr width="80%"/>
	<figure style="display: inline-block;">
		<img src="images/ham_diagonal_before.png" width="400">
		<figcaption>HAM</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/ham_diagonal_during.png" width="400">
		<figcaption>During left to right contraction</figcaption>
	</figure>
	<hr width="80%"/>
	<figure style="display: inline-block;">
		<img src="images/mermin_diagonal_before.png" width="400">
		<figcaption>Mermin Bell</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/mermin_diagonal_during.png" width="400">
		<figcaption>During left to right contraction</figcaption>
	</figure>
	<hr width="80%"/>
	</center>
<br/>


<hr id="4" />

### Kernel Algorithms ###
* Any square matrix of size n has 2n-1 principal diagonals.
* Any square matrix can be written as a sum of 2n-1 matrices (each matrix with just one diagonal).
* Matrix-Matrix (A.B) multiplication algorithm: can be divided into subproblems like so-
	* (A<sub>-n</sub> + ... + A<sub>0</sub> + A<sub>1</sub> + ... + A<sub>n</sub>) . (B<sub>-n</sub> + ... + B<sub>0</sub> + B<sub>1</sub> + ... + B<sub>n</sub>)
	* A<sub>-n</sub> . (B<sub>-n</sub> + ... + B<sub>0</sub> + B<sub>1</sub> + ... + B<sub>n</sub>) + A<sub>-(n-1)</sub> . (B<sub>-n</sub> + ... + B<sub>0</sub> + B<sub>1</sub> + ... + B<sub>n</sub>) + ...
	* A<sub>-n</sub> . B<sub>-n</sub> + A<sub>-n</sub> . (B<sub>-(n-1)</sub> + ... + ...  [ (2n-1) (2n-1) terms, 2n-1 is the number of diagonals ]
	* Each of the above multiplication takes linear time and is independent of any other term in the summation and hence is parallelizable.
	* So, overall time complexity would be of the order O(n\*d\*d) where n is the length of each diagonal, d is the number of diagonals.
	* In quantum simulations, as we've seen from the analysis, the number of diagonals is far smaller than the size of the matrix (See VQE example above, the vqe prep for 4 qubits results in a 16x16 matrix, but with elements only on 4 anti-diagonals). Hence, we claim that this approach significantly improves the multiplication operation (a.k.a the contraction step).

<hr  width="80%"/>

### Data Structures ###
* 2 variations of diagonal matrix formats- Sparse Diagonal and Compressed Sparse Diagonal.
* Sparse Diagonal: Diagonals are represented using their index (gives us the position) and their a vector of their values. (half leveraging quantum sparsity)
* Compressed Sparse Diagonal: The sparsity within diagonals is leveraged to store the vectors in a compressed fashion (like with CSR). So, a digonal here has an index, an array that stores non-zero indices within the diagonal and another array that stores the actual complex values.
* In both versions, matrices are a map of diagonal indices to respective diagonal objects.
* We implemented the "Sparse Diagonal" format using c++11.
* Tested using supermarq (refer literature survey) benchmark circuits and counter the number of #flops for different cases. We ran for different sizes of these circuits from 3 to 16. Later, we also generated data for circuits >16 qubits and were able to test till 26 qubits on the ARC cluster's Cascade machine.
<center>
<figure style="display: inline-block;">
	<img src="images/ghz_flops_comparison.png" width="400">
	<figcaption>GHZ FLOPS comparison</figcaption>
</figure>
&nbsp;
<figure style="display: inline-block;">
	<img src="images/ham_flops_comparison.png" width="400">
	<figcaption>HAM FLOPS comparison</figcaption>
</figure>
&nbsp;
<figure style="display: inline-block;">
	<img src="images/mermin_bell_flops_comparison.png" width="400">
	<figcaption>MERMIN_BELL FLOPS comparison</figcaption>
</figure>
</center>

* QAOA Max-Cut- Consider the below circuit that uses QAOA to find max-cut of a square, after stripping off measurements and Hadamards) <a href="https://qiskit.org/textbook/ch-applications/qaoa.html" target="_blank"> Qiskit Ref</a>.
	<center>
	<figure style="display: inline-block;">
		<img src="images/qaoa_maxcut_circuit.png" width="600">
		<figcaption>MAX-CUT Circuit</figcaption>
	</figure>
	&nbsp;
	<figure style="display: inline-block;">
		<img src="images/maxcut.gif" width="400">
		<figcaption>Intermediate Unitaries (this is a GIF)</figcaption>
	</figure>
	</center>

	* Simulating this QAOA example (MAX-CUT)- Numpy vs our approach-
	<center>
	<figure style="display: inline-block;">
		<img src="images/qaoa_maxcut_flops_comparison.png" width="400">
		<figcaption>FLOPS comparison (Dense vs our approach)</figcaption>
	</figure>


<hr id="5" />

## Key Outcomes (so far) ##

* Developed a new sparse data structure that exploits the found sparsity pattern to improve memory requirements and compute requirements for operations like contraction/decomposition. This new data structure stores all diagonals as a map, indexed by their indices, and values are contiguous arrays. The new sparse data structure allows the simulation of very wide circuits with memory demands that grow linearly (or close to) with qubits and matrix multiplication that becomes big-oh linear (or factor of it) for a small number of diagonals.
* Developed a numerical library that realizes this data structure.
* Modified the numerical library to work for higher order tensors using matricization in a way that maximizes the number of diagonals to work better for the new data structure. Implemented reshape, transpose, trace, sum for tensors, and internally efficiently stored them as matrices.
* Exposed a pip installable python interface of the C++ library using pybind11.
* Integrated the numerical library and the "sparse" library (Scipy, COO format) with opt_einsum package for testing with Quimb.
* Tested supermarQ benchmark circuits' tn-simulation using jax, numpy, tensorflow, torch, sparse, and our new library.
* Multi-threading helped reduce the time taken to format convert by ~64.9% (for 16 threads).
* To address the issue of complex arrays curtailing vectorization using SSE4.2 intrinsics, we now store two separate arrays for real and imaginary numbers within the new data structure. This improved the matrix multiplication performance by ~13.7% (for 26 qubit GHZ simulation).


<hr id="6" />

## Preliminary Results (Spring '23) ##

<center>
	<figure style="display: inline-block;">
		<img src="images/dense_qsparse.png" width="60%">
		<figcaption>Unitary Contraction (Numpy vs Our Format)</figcaption>
	</figure>
</center>


<center>
	<figure style="display: inline-block;">
		<img src="images/quimb_detailed_analysis.png" width="85%">
		<figcaption>QUIMB Unitary Contraction</figcaption>
	</figure>
</center>


<hr id="7" />

## Future Plans (Fall '23) ##

* Move away from SSE and towards AVX.
* Compare the library's implementation with state-of-the-art dense kernels like that of open BLAS 3's cGEMM implementation.
* Explore better utilization of cache through techniques like blocking. It is anticipated that utilizing the library will enable simulation of very large qubit circuits (>20) that cause other libraries like numpy to run out of memory.
* Develop a quantum algorithm level library like Koala/Qiskit/Quimb that is tailored to our numerical library and stores gates in our library's format would eliminate the need for any format conversions and is expected to result in the greatest performance gains.
* Explore the possibility of identifying sub-circuits that can be efficiently simulated using the data structure through techniques like memoization.

<br/>

<hr id="8" />

</div>
