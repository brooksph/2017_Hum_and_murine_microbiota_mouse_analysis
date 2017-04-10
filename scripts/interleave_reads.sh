for filename in *_R1_001.fastq.gz
do
     # first, make the base by removing .extract.fastq.gz
     base=$(basename $filename 001.fastq.gz)
     echo $base

     # now, construct the R2 filename by replacing R1 with R2
     baseR2=${base/_R1_/_R2_}
     echo $baseR2

     # construct the output filename
     output=${base/_R1_/}_001.pe.fq.gz

     (interleave-reads.py ${base}001.fastq.gz ${baseR2}001.fastq.gz | \
         gzip > $output)
done
