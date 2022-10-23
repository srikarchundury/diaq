# file name
file_name=$1_$2_$3_$(date +"%Y_%m_%d_%I_%M_%p").data

# for flops analysis
sudo perf stat -o metrics/data_stat_noh/$file_name -e fp_comp_ops_exe.sse_packed_double,fp_comp_ops_exe.sse_packed_single,fp_comp_ops_exe.sse_scalar_double,fp_comp_ops_exe.sse_scalar_single,fp_comp_ops_exe.x87 /home/schundu3/anaconda3/envs/s-tnqs/bin/python test_lib.py $1 $2 $3 --without-h | tee metrics/python_out_noh/$file_name

# for memory analysis
sudo perf mem record -o metrics/data_mem_noh/$file_name.record.data /home/schundu3/anaconda3/envs/s-tnqs/bin/python test_lib.py $1 $2 $3
sudo perf mem -t load report --sort=mem -i metrics/data_mem/$file_name.record.data > metrics/data_mem/$file_name.data