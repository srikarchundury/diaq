#!/bin/bash
# This script is used to list all the tests in the tests.cpp file, something for my convenience, later I shall write a testing framework to automate this process

file = "./cpp_tests/test_main.cpp"
print("\n-- List of Tests --\n")

# read this file
with open(file, 'r') as f:
	# read all lines
	lines = f.readlines()
	# iterate over lines
	for line in lines:
		if "strcmp" in line:
			try:
				deets = line.split('"')
				test_name = deets[1]
				print(f"./cpu_build/bin/tests {test_name}")
			except:
				continue

print("\n-- End of List --\n")