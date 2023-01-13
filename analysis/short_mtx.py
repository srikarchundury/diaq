import scipy.sparse as sparse
import scipy.io as sio
import scipy.stats as stats
import numpy as np

sp_matrix = sio.mmread("cryg2500.mtx")

sp_matrix = sp_matrix.tocsr()

for num in [200,600,1000,1400,1800,2200]:
    sp_matrix_subset = sp_matrix[:num,:num]
    sio.mmwrite("cryg" + str(num) + ".mtx" , sp_matrix_subset.tocoo())


./bench suitesparse cryg2200 cryg2200 dense > ../../data/results/cryg2200dense
./bench suitesparse cryg2200 cryg2200 sparse > ../../data/results/cryg2200sparse