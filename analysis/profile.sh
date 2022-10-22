# file name
file_name=$1_$2_$3_$(date +"%Y_%m_%d_%I_%M_%p").data
# for flops analysis
sudo perf stat -o data_stat/$file_name -e fp_comp_ops_exe.sse_packed_double,fp_comp_ops_exe.sse_packed_single,fp_comp_ops_exe.sse_scalar_double,fp_comp_ops_exe.sse_scalar_single,fp_comp_ops_exe.x87 /home/schundu3/anaconda3/envs/s-tnqs/bin/python $1 $2 $3

# for memory analysis
sudo perf mem record -o data_mem/$file_name.record.data /home/schundu3/anaconda3/envs/s-tnqs/bin/python $1 $2 $3
sudo perf mem -t load report --sort=mem -i data_mem/$file_name.record.data > data_mem/$file_name.data