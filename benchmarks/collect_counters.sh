for circ in "ghz" "ham" "mermin_bell"
do
	for qubits in "3" "4" "5" "6" "7" "8" "9" "10"
	do
		for version in "dense" "sparse"
		do
			filename=$circ$qubits$version
			./bench supermarq $circ $qubits $version > ../../data/results/$filename
		done
	done
done
