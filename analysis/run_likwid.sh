for circuit in "ghz" "bit_code" "ham" "mermin_bell" "phase_code"; do
    for n_qubits in 3 6 9 12 15 18 21 24 27 30; do 
        for backend in "numpy" "jax" "sparse"; do
            ./likwid_measure.sh $circuit $n_qubits $backend;
        done;
    done;
done;
