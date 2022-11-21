for circ in "mermin_bell"
do
	for qubits in "3" "4" "5" "6" "7" "8" "9"
	do
		for version in "dense" "sparse"
		do
			filename=$circ$qubits$version
			./bench $circ $qubits $version > $filename
		done
	done
done
