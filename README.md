OCaml Bitset shootout
---------------------

Contestants :

  - [Zarith](https://github.com/ocaml/zarith)
  - [Batteries BitSet](https://github.com/ocaml-batteries-team/batteries-included/blob/master/src/batBitSet.ml), Pure
  - [Bit vector](https://github.com/backtracking/bitv), Pure
  - [Bitarray](https://github.com/travisbrady/ocaml-bitarray)  Unreleased, Ctypes bindings
  - [Ocbitset](https://github.com/rleonid/ocbitset) Unreleased, Another Ctypes bindings
  - [Containers CCBV](https://github.com/c-cube/ocaml-containers/blob/master/src/data/CCBV.mli), Pure

Creation:

| Name            |   Time/Run |    mWd/Run |   mjWd/Run |   Prom/Run | Percentage |
|----------------:|-----------:|-----------:|-----------:|-----------:|-----------:|
| Zarith 10       |     1.75us |    350.00w |      0.39w |      0.39w |      0.10% |
| Zarith 100      |    21.11us |  3_997.00w |     58.28w |     58.28w |      1.21% |
| Zarith 1000     |   616.37us | 36_650.00w | 37_657.60w | 36_656.60w |     35.38% |
| Batteries 10    |     1.97us |    725.00w |      0.96w |      0.96w |      0.11% |
| Batteries 100   |    23.44us |  7_205.07w |    182.40w |    182.40w |      1.35% |
| Batteries 1000  | 1_271.31us | 71_004.00w | 67_029.34w | 66_028.34w |     72.97% |
| Bitv 10         |     2.21us |    735.00w |      1.78w |      1.78w |      0.13% |
| Bitv 100        |    25.48us |  7_305.00w |    192.82w |    192.82w |      1.46% |
| Bitv 1000       | 1_326.62us | 72_004.00w | 70_031.26w | 69_030.26w |     76.14% |
| Bitarray 10     |    14.02us |    704.53w |    160.30w |    160.30w |      0.80% |
| Bitarray 100    |   142.52us |  7_033.47w |  1_632.33w |  1_632.33w |      8.18% |
| Bitarray 1000   | 1_742.30us | 69_194.80w | 30_019.62w | 29_018.62w |    100.00% |
| Ocbitset 10     |    10.88us |    185.00w |    110.26w |    110.26w |      0.62% |
| Ocbitset 100    |   107.98us |  1_805.02w |  1_100.01w |  1_100.01w |      6.20% |
| Ocbitset 1000   | 1_149.71us | 17_004.00w | 12_008.65w | 11_007.65w |     65.99% |
| Containers 10   |     2.14us |    695.00w |      1.66w |      1.66w |      0.12% |
| Containers 100  |    25.11us |  6_905.00w |    179.54w |    179.54w |      1.44% |
| Containers 1000 |   912.96us | 68_004.00w | 69_023.00w | 68_022.00w |     52.40% |

Union: 

| Name            |       Time/Run |    mWd/Run |   mjWd/Run |   Prom/Run | Percentage |
|----------------:|---------------:|-----------:|-----------:|-----------:|-----------:|
| Zarith 10       |       422.18ns |    488.00w |            |            |      0.03% |
| Zarith 100      |     5_427.81ns |  6_274.00w |      1.53w |      1.53w |      0.37% |
| Zarith 1000     |    62_793.61ns | 65_765.00w |     16.51w |     16.51w |      4.28% |
| Batteries 10    |    13_013.90ns |    664.00w |      0.15w |      0.15w |      0.89% |
| Batteries 100   |   140_247.58ns |  6_604.00w |      1.63w |      1.63w |      9.56% |
| Batteries 1000  | 1_466_826.36ns | 66_004.00w |     16.17w |     16.17w |    100.00% |
| Bitvector 10    |     1_684.92ns |    690.00w |      0.16w |      0.16w |      0.11% |
| Bitvector 100   |    17_096.73ns |  6_900.00w |      1.72w |      1.72w |      1.17% |
| Bitvector 1000  |   171_945.31ns | 69_000.00w |     17.36w |     17.36w |     11.72% |
| Bitarray 10     |    13_712.15ns |    782.33w |    160.01w |    160.01w |      0.93% |
| Bitarray 100    |   135_600.39ns |  7_793.66w |  1_602.58w |  1_602.58w |      9.24% |
| Bitarray 1000   | 1_381_005.67ns | 78_335.84w | 16_014.92w | 16_014.92w |     94.15% |
| Ocbitset 10     |     9_462.48ns |    110.00w |    110.03w |    110.03w |      0.65% |
| Ocbitset 100    |    93_810.17ns |  1_100.02w |  1_100.02w |  1_100.02w |      6.40% |
| Ocbitset 1000   | 1_019_175.09ns | 11_000.25w | 11_062.38w | 11_062.38w |     69.48% |
| Containers 10   |     1_492.60ns |    680.00w |      0.17w |      0.17w |      0.10% |
| Containers 100  |    14_703.03ns |  6_800.00w |      1.71w |      1.71w |      1.00% |
| Containers 1000 |   152_476.23ns | 68_000.00w |     17.12w |     17.12w |     10.39% |
