# How to use the plumed benchmark command

The lesson contains: 
- a [manual](README.md) for plumed benchmark
- a [small tutorial](Tutorial.md) in which I show how to measure and confront performances working with the COORDINATION action
- a small introduction to creating a [flame graph](Perf.md) from a plumed benchmark run.
- a [list of input files](Inputs.md) that we have used in the past when benchmarking PLUMED.

The tutorial has also a companion [notebook](Tutorial_notebook.ipynb), with all the scripts I used to make the images

You should try to follow the tutorial with the manual opened in a second tab.


```mermaid
flowchart LR
A[benchmark manpage]
B[A benchmark tutorial]
C["A benchmark tutorial (notebook)"]
D["Flamegraph with perf from plumed benchmark"]

B <==> C
click A "README.md" "A manpage for plumed benchmark"
click B "Tutorial.md" "A tutorial on the coordination"
click C "Tutorial_notebook.ipynb" "The notebook with the scripts relative to the tutorial on the coordination"
click D "Perf.md" "A simple tutorial creating a flame graph using perf"
```
