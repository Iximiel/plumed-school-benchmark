#!/bin/bash

export PLUMED_NUM_THREADS=8
export PLUMED_MAXBACKUP=0
module load plumed/wFairBench

for nat in 500 1000 2000; do
    echo $nat
    plumed benchmark --nsteps=500 \
        --natoms=$nat \
        --plumed="plumed.dat:plumedNL110_shortstride.dat:plumedNL150_shortstride.dat:plumedNL200_shortstride.dat:plumedNL110.dat:plumedNL150.dat:plumedNL200.dat:plumedNL110_mediumstride.dat" \
        --atom-distribution="sc" >sc_NL_all_${nat}.out

    # plumed benchmark --nsteps=500 \
    #     --natoms=$nat \
    #     --plumed="plumed.dat:plumedNL110.dat:plumedNL150.dat:plumedNL200.dat" \
    #     --atom-distribution=sc >sc_NL_${nat}.out
done
