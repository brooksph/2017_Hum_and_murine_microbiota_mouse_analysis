for i in *trim.pe.fq.gz
do 
    ../../sourmash/sourmash compute -k 31 --scaled 1000 ${i} -f
done
