for i in *pe.fq.gz
do 
    ../../sourmash/sourmash compute -k 31 --scaled 1000 ${i}
done
