#!/bin/bash

export PLUMED_MAXBACKUP=0
for nt in 1 2 4 6 8 10 12; do
    export PLUMED_NUM_THREADS=$nt
    for nat in 100 500 1000; do
        plumed benchmark --nsteps=500 --natoms=$nat --atom-distribution=sc >"sc_${nt}_${nat}.out"
    done
done
