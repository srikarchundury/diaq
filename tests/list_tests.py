#!/bin/bash
# This script is used to list all the tests in the tests.cpp file

file = "tests/tests.cpp"
# read this file
with open(file, 'r') as f:
	# read all lines
	lines = f.readlines()
	# initialize a list to store test names
	test_names = []
	# iterate over lines
	for line in lines:
		# if the line contains the word TEST_CASE
		if "if(strcmp(argv[1]," in line:
			deets = line.split("\"")
			test_names.append(deets[1])

# print the formatted list of tests
print("\n-- List of Tests --\n")
for i, test in enumerate(test_names, 1):
	print(f"./cpu_build/bin/tests {test}")