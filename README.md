OCaml Bitset shootout
---------------------

Contestants :

  - [Zarith](https://github.com/ocaml/zarith)
  - [Batteries BitSet](https://github.com/ocaml-batteries-team/batteries-included/blob/master/src/batBitSet.ml), Pure
  - [Bit vector](https://github.com/backtracking/bitv), Pure
  - [Bitarray](https://github.com/travisbrady/ocaml-bitarray)  Unreleased, Ctypes bindings
  - [Ocbitset](https://github.com/rleonid/ocbitset) Unreleased, Another Ctypes bindings

Creation:

| Name           |   Time/Run |    mWd/Run |   mjWd/Run |   Prom/Run | Percentage |
|---------------:|-----------:|-----------:|-----------:|-----------:|-----------:|
| Zarith 10      |     1.82us |    350.00w |      0.39w |      0.39w |      0.09% |
| Zarith 100     |    21.76us |  3_997.00w |     58.18w |     58.18w |      1.02% |
| Zarith 1000    | 1_014.22us | 36_650.00w | 37_661.52w | 36_660.52w |     47.56% |
| Batteries 10   |     2.19us |    725.00w |      0.96w |      0.96w |      0.10% |
| Batteries 100  |    24.71us |  7_205.07w |    182.47w |    182.47w |      1.16% |
| Batteries 1000 | 1_352.04us | 71_004.00w | 67_030.94w | 66_029.94w |     63.40% |
| Bitv 10        |     2.35us |    735.00w |      1.78w |      1.78w |      0.11% |
| Bitv 100       |    30.56us |  7_305.00w |    192.70w |    192.70w |      1.43% |
| Bitv 1000      |   963.81us | 72_004.00w | 70_024.81w | 69_023.81w |     45.19% |
| Bitarray 10    |    16.22us |    707.67w |    160.31w |    160.31w |      0.76% |
| Bitarray 100   |   168.42us |  7_022.14w |  1_631.41w |  1_631.41w |      7.90% |
| Bitarray 1000  | 2_132.58us | 69_286.37w | 30_023.04w | 29_022.04w |    100.00% |
| Ocbitset 10    |    11.91us |    185.00w |    110.18w |    110.18w |      0.56% |
| Ocbitset 100   |   144.28us |  1_805.02w |  1_104.80w |  1_104.80w |      6.77% |
| Ocbitset 1000  | 1_432.16us | 17_004.00w | 12_009.55w | 11_008.55w |     67.16% |


Union: 

| Name           |       Time/Run |    mWd/Run |   mjWd/Run |   Prom/Run | Percentage |
|---------------:|---------------:|-----------:|-----------:|-----------:|-----------:|
| Zarith 10      |       540.90ns |    488.00w |            |            |      0.03% |
| Zarith 100     |     5_970.56ns |  6_274.00w |      1.53w |      1.53w |      0.37% |
| Zarith 1000    |    76_726.11ns | 65_765.00w |     16.51w |     16.51w |      4.72% |
| Batteries 10   |    15_913.51ns |    664.00w |      0.15w |      0.15w |      0.98% |
| Batteries 100  |   157_427.45ns |  6_604.00w |      1.63w |      1.63w |      9.69% |
| Batteries 1000 | 1_624_544.42ns | 66_004.00w |     16.17w |     16.17w |    100.00% |
| Bitv 10        |     1_835.72ns |    690.00w |      0.16w |      0.16w |      0.11% |
| Bitv 100       |    18_714.75ns |  6_900.00w |      1.72w |      1.72w |      1.15% |
| Bitv 1000      |   213_125.54ns | 69_000.00w |     17.36w |     17.36w |     13.12% |
| Bitarray 10    |    15_906.43ns |    782.02w |    160.01w |    160.01w |      0.98% |
| Bitarray 100   |   149_437.19ns |  7_835.10w |  1_602.47w |  1_602.47w |      9.20% |
| Bitarray 1000  | 1_518_249.08ns | 78_162.06w | 16_011.04w | 16_011.04w |     93.46% |
| Ocbitset 10    |    13_885.67ns |    110.00w |    110.16w |    110.16w |      0.85% |
| Ocbitset 100   |   125_692.38ns |  1_100.02w |  1_100.97w |  1_100.97w |      7.74% |
| Ocbitset 1000  | 1_157_846.86ns | 11_000.24w | 11_054.93w | 11_054.93w |     71.27% |
