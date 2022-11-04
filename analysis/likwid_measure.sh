# file name
file_name=$1_$2_$3_$(date +"%Y_%m_%d_%I_%M_%p").csv
# for flops analysis
likwid-perfctr -O -o likwid_metrics/$file_name -g FLOPS_DP -g FLOPS_SP -g MEM1 -g MEM2 python test_lib.py $1 $2 $3
