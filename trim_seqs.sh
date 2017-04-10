for i in *.pe.fq.gz
do
    trim-low-abund.py -M 16e9 -k 20 ${i} -o ${i}_pass_1.trim.pe.fq.gz --gzip
done 
