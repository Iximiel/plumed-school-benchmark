# A simple benchmark example


Now we'll get our hands dirty.

I will make a short demonstration only using the COORDINATION command in plumed, since it is available with a zero-configuration plumed.

We will use the following input as a base for the benchmark
```plumed
cpu: COORDINATION GROUPA=@mdatoms R_0=1

PRINT ARG=* FILE=Colvar FMT=%8.4f STRIDE=1

FLUSH STRIDE=1
```

I will also remove the  backups of the output files with `export PLUMED_MAXBACKUP=0`

#first run

```bash
plumed benchmark --nsteps=500 --natoms=500 --atom-distribution=sc > sc_500.out
```

The first lines of the output are a header with the information needed to reproduce the benchmark run:

```
BENCH:  Welcome to PLUMED benchmark
BENCH:  Using --kernel=this
BENCH:  Using --plumed=plumed.dat
BENCH:  Using --nsteps=500
BENCH:  Using --natoms=500
BENCH:  Using --maxtime=-1
BENCH:  Using --sleep=0
BENCH:  Using --atom-distribution=sc
BENCH:  Initializing the setup of the kernel(s)
```

The final lines contain the time information collected by the internal plumed timers
```
BENCH:  Single run, skipping comparative analysis
BENCH:  
BENCH:  Kernel:      this
BENCH:  Input:       plumed.dat
BENCH:                                                Cycles        Total      Average      Minimum      Maximum
BENCH:  A Initialization                                   1     0.001484     0.001484     0.001484     0.001484
BENCH:  B0 First step                                      1     0.002423     0.002423     0.002423     0.002423
BENCH:  B1 Warm-up                                        99     0.244222     0.002467     0.002401     0.002930
BENCH:  B2 Calculation part 1                            200     0.498634     0.002493     0.002421     0.003136
BENCH:  B3 Calculation part 2                            200     0.498418     0.002492     0.002405     0.003284
PLUMED:                                               Cycles        Total      Average      Minimum      Maximum
PLUMED:                                                    1     1.244841     1.244841     1.244841     1.244841
PLUMED: 1 Prepare dependencies                           500     0.000224     0.000000     0.000000     0.000002
PLUMED: 2 Sharing data                                   500     0.001107     0.000002     0.000002     0.000021
PLUMED: 3 Waiting for data                               500     0.000278     0.000001     0.000000     0.000002
PLUMED: 4 Calculating (forward loop)                     500     1.235230     0.002470     0.002370     0.003254
PLUMED: 5 Applying (backward loop)                       500     0.000402     0.000001     0.000000     0.000005
PLUMED: 6 Update                                         500     0.004534     0.000009     0.000005     0.000056

```
Most of our conclusions will be taken from these parts of the output

## OpenMP


```plumed
cpu: COORDINATION GROUPA=@mdatoms R_0=1

PRINT ARG=* FILE=Colvar FMT=%8.4f STRIDE=1

FLUSH STRIDE=1
```

```bash
for nt in 1 2 4 6 8 10 12; do
    export PLUMED_NUM_THREADS=$nt
    for nat in 100 500 1000; do
        plumed benchmark --nsteps=500 --natoms=$nat --atom-distribution=sc > sc_${nt}_${nat}.out
    done
done
```

My CPU has 6 physical cores but can execute 12 threads. By looking at all the possibilities we can see how t

To extract the data we can use a bash script like:
```bash
for threads in 1 2 4 6 8 10 12; do
    {
    for natoms in 100 500 1000; do
        echo -n "$natoms "
        fname=sc_${threads}_${natoms}.out
        sed -n '/PLUMED: *Cycles *Total *Average *Minimum *Maximum/{n ; p}' "${fname}" |
            awk '{printf "%f ", $3}'
        echo ""
    done
    } > "times_${threads}.out"
done
```

and obtain for each set of threads (here with 6) a table like this :
```
100 0.021471 
500 0.308065 
1000 1.150924 
```

and with a simple python script:
```python
import matplotlib.pyplot as plt
import numpy as np
nthreads=[1,2,4,6,8,10,12]

simPerThread={}
for threads in nthreads:
    simPerThread[threads]=np.loadtxt(f"./run/times_{threads}.out")
fig,ax =plt.subplots()

ncols = len(simPerThread)
x = simPerThread[nthreads[0]][:,0]
x_coord=np.arange(len(x))
width = 0.8/ncols
ax.set_xticks(x_coord + width * 0.5 * (ncols - 1), x)

for multiplier, nt in enumerate(nthreads):
    offset = width * multiplier

    toplot = simPerThread[nt][:,1]
    ax.bar(
            x_coord + offset,
            toplot,
            width,
            label=f"{nt} threads",
        )
       
ax.legend()
ax.set_xlabel("number of Atoms")
ax.set_ylabel("time (s)")
```
We obtain 

![](CoordinationVSthreads.png)


or my python package that I set up for not adapting the bash script over and over

- coordination
- coordination with  NL
- coordination with NL -exaggerated cut off
- explain the header and the post-log

some graph and pp
perf example
