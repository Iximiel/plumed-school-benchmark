#!/bin/bash

export PLUMED_MAXBACKUP=0
export PLUMED_NUM_THREADS=8

plumed benchmark --nsteps=30 \
    --natoms=500 \
    --plumed="plumedCube.dat:plumedNL110Cube.dat" \
    --atom-distribution=cube >cube_500.out
