OCaml Bitset shootout
---------------------

### Contestants

  - [Zarith](https://github.com/ocaml/zarith)
  - [Batteries BitSet](https://github.com/ocaml-batteries-team/batteries-included/blob/master/src/batBitSet.ml), Pure
  - [Bit vector](https://github.com/backtracking/bitv), Pure
  - [Ocbitset](https://github.com/rleonid/ocbitset) Unreleased, Another Ctypes bindings
  - [Containers CCBV](https://github.com/c-cube/ocaml-containers/blob/master/src/data/CCBV.mli), Pure

### Setup

Given a universe of 4000 elements, we test
[bitsets, bitvectors, bitarrays](https://en.wikipedia.org/wiki/Bit_array) operations.

The results are [Core_bench](https://github.com/janestreet/core_bench) micro
benchmarks.

### Creation

Time necessary to create an element with `n` bits set.

|  Name            |  Time R^2|  Time/Run|  Cycls/Run|      mWd/Run|  mjWd/Run|  Prom/Run|    mGC/Run|  mjGC/Run|  Percentage| 
| ----------------:|---------:|---------:|----------:|------------:|---------:|---------:|----------:|---------:|-----------:|
|  Zarith:10       |     0.93 |   2.15us |    6.44kc |     865.00w |    0.11w |    0.11w |   3.30e-3 |          |      0.79% |
|  Zarith:100      |     1.00 |  24.48us |   73.43kc |  10_001.00w |    3.46w |    3.46w |  38.16e-3 |          |      8.96% |
|  Zarith:1000     |     0.98 | 273.17us |  819.45kc | 100_341.00w |   36.94w |   36.94w | 382.85e-3 |  0.11e-3 |    100.00% |
|  Batteries:10    |     0.98 |   1.66us |    4.98kc |     197.00w |          |          |   0.75e-3 |          |      0.61% |
|  Batteries:100   |     0.97 |  17.63us |   52.88kc |     865.00w |    0.45w |    0.45w |   3.30e-3 |          |      6.45% |
|  Batteries:1000  |     0.80 | 219.06us |  657.15kc |   5_509.19w |    2.87w |    2.87w |  21.01e-3 |          |     80.19% |
|  Bitv:10         |     0.95 |   1.60us |    4.81kc |     105.00w |          |          |   0.40e-3 |          |      0.59% |
|  Bitv:100        |     0.96 |  17.09us |   51.26kc |     375.01w |          |          |   1.43e-3 |          |      6.26% |
|  Bitv:1000       |     0.85 | 190.29us |  570.85kc |   3_075.07w |    0.90w |    0.90w |  11.73e-3 |          |     69.66% |
|  Ocbitset:10     |     0.84 |   2.62us |    7.85kc |      50.00w |   11.00w |   11.00w |   0.20e-3 |  0.01e-3 |      0.96% |
|  Ocbitset:100    |     0.96 |  18.84us |   56.50kc |     320.00w |   11.03w |   11.03w |   1.23e-3 |  0.02e-3 |      6.90% |
|  Ocbitset:1000   |     0.87 | 206.70us |  620.05kc |   3_020.00w |   11.11w |   11.11w |  11.52e-3 |  0.02e-3 |     75.67% |
|  Containers:10   |     0.96 |   1.60us |    4.80kc |     145.00w |          |          |   0.55e-3 |          |      0.59% |
|  Containers:100  |     0.99 |  15.51us |   46.52kc |     230.00w |          |          |   0.88e-3 |          |      5.68% |
|  Containers:1000 |     0.98 | 159.32us |  477.93kc |     243.00w |    0.13w |    0.13w |   0.93e-3 |          |     58.32% |

Zarith suffers because we have to `shift_one` to create the appropriate value
to `logor` with. The confidence intervals underestimate the true values. And
in general, the times are only for relative comparison.

### Union

Time necessary to compute `n` unions of bitsets with 2000 (half) elements.

| Name            | Time R^2 |       Time/Run |  Cycls/Run |     mWd/Run |   mjWd/Run |   Prom/Run |   mGC/Run | mjGC/Run | Percentage |
|----------------:|---------:|---------------:|-----------:|------------:|-----------:|-----------:|----------:|---------:|-----------:|
| Zarith:10       |     0.99 |       877.31ns |     2.63kc |   1_187.00w |      0.45w |      0.45w |   4.53e-3 |          |      0.06% |
| Zarith:100      |     0.97 |     5_635.38ns |    16.91kc |   7_352.00w |      0.82w |      0.82w |  28.05e-3 |          |      0.37% |
| Zarith:1000     |     0.83 |    59_455.35ns |   178.36kc |  67_590.00w |      2.30w |      2.30w | 257.86e-3 |  0.01e-3 |      3.94% |
| Batteries:10    |     0.98 |    12_867.57ns |    38.60kc |     601.00w |      0.15w |      0.15w |   2.29e-3 |          |      0.85% |
| Batteries:100   |     1.00 |   137_258.57ns |   411.75kc |   6_541.00w |      1.77w |      1.77w |  24.95e-3 |          |      9.09% |
| Batteries:1000  |     0.94 | 1_509_800.46ns | 4_529.16kc |  65_941.00w |     17.87w |     17.87w | 251.67e-3 |          |    100.00% |
| Bitvector:10    |     0.91 |     3_162.18ns |     9.49kc |   1_249.01w |      0.46w |      0.46w |   4.77e-3 |          |      0.21% |
| Bitvector:100   |     0.93 |    32_098.55ns |    96.29kc |  13_669.00w |      5.57w |      5.57w |  52.16e-3 |  0.01e-3 |      2.13% |
| Bitvector:1000  |     0.95 |   312_429.51ns |   937.23kc | 137_869.78w |     56.44w |     56.44w | 526.07e-3 |  0.13e-3 |     20.69% |
| Ocbitset:10     |     0.62 |     8_809.32ns |    26.43kc |     106.00w |     98.94w |     98.94w |   0.43e-3 |  0.05e-3 |      0.58% |
| Ocbitset:100    |     0.44 |    90_083.24ns |   270.23kc |   1_096.02w |  1_092.48w |  1_092.48w |   4.43e-3 |  0.49e-3 |      5.97% |
| Ocbitset:1000   |     0.58 |   962_892.04ns | 2_888.50kc |  10_996.16w | 11_029.43w | 11_029.43w |  44.44e-3 |  4.96e-3 |     63.78% |
| Containers:10   |     1.00 |     1_132.74ns |     3.40kc |     619.00w |      0.16w |      0.16w |   2.36e-3 |          |      0.08% |
| Containers:100  |     0.93 |    13_557.41ns |    40.67kc |   6_739.00w |      1.91w |      1.91w |  25.71e-3 |          |      0.90% |
| Containers:1000 |     0.91 |   129_957.80ns |   389.85kc |  67_939.00w |     19.43w |     19.43w | 259.24e-3 |  0.06e-3 |      8.61% |

- The cost of jumping to C hurts the wrappers.

### Diff

Time necessary to compute `n` diff of bitsets with 2000 (half) elements.

| Name            | Time R^2 |       Time/Run |  Cycls/Run |    mWd/Run |   mjWd/Run |   Prom/Run |   mGC/Run | mjGC/Run | Percentage |
|----------------:|---------:|---------------:|-----------:|-----------:|-----------:|-----------:|----------:|---------:|-----------:|
| Zarith:10       |     0.91 |       430.57ns |     1.29kc |    601.00w |      0.15w |      0.15w |   2.29e-3 |          |      0.03% |
| Zarith:100      |     0.84 |     6_837.60ns |    20.51kc |  6_541.00w |      1.81w |      1.81w |  24.96e-3 |          |      0.48% |
| Zarith:1000     |     0.99 |    52_189.52ns |   156.56kc | 65_941.00w |     18.35w |     18.35w | 251.59e-3 |  0.04e-3 |      3.63% |
| Batteries:10    |     0.97 |    12_638.40ns |    37.91kc |    601.00w |      0.15w |      0.15w |   2.29e-3 |          |      0.88% |
| Batteries:100   |     0.96 |   138_430.37ns |   415.27kc |  6_541.00w |      1.77w |      1.77w |  24.95e-3 |          |      9.62% |
| Batteries:1000  |     0.92 | 1_438_534.47ns | 4_315.38kc | 65_941.00w |     17.87w |     17.87w | 251.60e-3 |          |    100.00% |
| Bitvector:10    |     1.00 |     1_362.97ns |     4.09kc |    628.00w |      0.12w |      0.12w |   2.40e-3 |          |      0.09% |
| Bitvector:100   |     1.00 |    14_833.74ns |    44.50kc |  6_838.00w |      1.90w |      1.90w |  26.09e-3 |          |      1.03% |
| Bitvector:1000  |     0.81 |   172_407.28ns |   517.19kc | 68_938.00w |     19.18w |     19.18w | 263.07e-3 |  0.06e-3 |     11.98% |
| Ocbitset:10     |     0.65 |     8_900.31ns |    26.70kc |    106.00w |     99.09w |     99.09w |   0.43e-3 |  0.05e-3 |      0.62% |
| Ocbitset:100    |     0.44 |    97_873.84ns |   293.60kc |  1_096.02w |  1_088.42w |  1_088.42w |   4.42e-3 |  0.49e-3 |      6.80% |
| Ocbitset:1000   |     0.66 |   940_302.97ns | 2_820.75kc | 10_996.16w | 11_009.92w | 11_009.92w |  44.39e-3 |  4.93e-3 |     65.37% |
| Containers:10   |     0.93 |       927.29ns |     2.78kc |    619.00w |      0.16w |      0.16w |   2.36e-3 |          |      0.06% |
| Containers:100  |     0.89 |    12_164.95ns |    36.49kc |  6_739.00w |      1.91w |      1.91w |  25.71e-3 |          |      0.85% |
| Containers:1000 |     0.82 |   124_538.08ns |   373.59kc | 67_939.00w |     19.43w |     19.43w | 259.23e-3 |  0.06e-3 |      8.66% |

- Containers requires a custom, slow, negation.
- Bitarray, also requires a negation.
- Bitv also requires a negation but achieves good performance ?

