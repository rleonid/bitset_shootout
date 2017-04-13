OCaml Bitset shootout
---------------------

Contestants :

  - [Zarith](https://github.com/ocaml/zarith)
  - [Batteries BitSet](https://github.com/ocaml-batteries-team/batteries-included/blob/master/src/batBitSet.ml)
  - [Bit vector](https://github.com/backtracking/bitv)
  - [Bitarray](https://github.com/travisbrady/ocaml-bitarray)  Unreleased

Creation:


| Name                  |   Time/Run |    mWd/Run |   mjWd/Run |   Prom/Run | Percentage |
|----------------------:|-----------:|-----------:|-----------:|-----------:|-----------:|
| Zarith create 10      |     1.46us |     15.00w |            |            |      0.08% |
| Zarith create 100     |    17.10us |    105.00w |            |            |      0.91% |
| Zarith create 1000    |   192.75us |      4.00w |  1_001.08w |            |     10.24% |
| Batteries create 10   |     2.11us |    725.00w |      0.96w |      0.96w |      0.11% |
| Batteries create 100  |    24.90us |  7_205.07w |    182.59w |    182.59w |      1.32% |
| Batteries create 1000 |   874.11us | 71_004.00w | 67_021.79w | 66_020.79w |     46.45% |
| Bitv create 10        |     2.26us |    735.00w |      1.79w |      1.79w |      0.12% |
| Bitv create 100       |    26.97us |  7_305.00w |    192.90w |    192.90w |      1.43% |
| Bitv create 1000      |   847.23us | 72_004.00w | 70_022.11w | 69_021.11w |     45.02% |
| Bitarray create 10    |    14.73us |    707.40w |    160.24w |    160.24w |      0.78% |
| Bitarray create 100   |   154.01us |  7_043.17w |  1_628.72w |  1_628.72w |      8.18% |
| Bitarray create 1000  | 1_881.86us | 69_268.84w | 30_021.02w | 29_020.02w |    100.00% |


  
