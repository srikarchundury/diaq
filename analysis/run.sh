for circuit in "ghz" "bit_code" "ham" "mermin_bell" "phase_code"; do
    for n_qubits in 3 4 5 6 7 8; do 
        for backend in "numpy" "jax"; do
            ./profile.sh $circuit $n_qubits $backend;
            ./profile_without_h.sh $circuit $n_qubits $backend;
        done;
    done;
done;