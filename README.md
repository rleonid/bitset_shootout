OCaml Bitset shootout
---------------------

Contestants :

  - [Zarith](https://github.com/ocaml/zarith)
  - [Batteries BitSet](https://github.com/ocaml-batteries-team/batteries-included/blob/master/src/batBitSet.ml)
  - [Bit vector](https://github.com/backtracking/bitv)
  - [Bitarray](https://github.com/travisbrady/ocaml-bitarray)  Unreleased

Creation:
┌───────────────────────┬────────────┬────────────┬────────────┬────────────┬────────────┐
│ Name                  │   Time/Run │    mWd/Run │   mjWd/Run │   Prom/Run │ Percentage │
├───────────────────────┼────────────┼────────────┼────────────┼────────────┼────────────┤
│ Zarith create 10      │     1.46us │     15.00w │            │            │      0.08% │
│ Zarith create 100     │    17.10us │    105.00w │            │            │      0.91% │
│ Zarith create 1000    │   192.75us │      4.00w │  1_001.08w │            │     10.24% │
│ Batteries create 10   │     2.11us │    725.00w │      0.96w │      0.96w │      0.11% │
│ Batteries create 100  │    24.90us │  7_205.07w │    182.59w │    182.59w │      1.32% │
│ Batteries create 1000 │   874.11us │ 71_004.00w │ 67_021.79w │ 66_020.79w │     46.45% │
│ Bitv create 10        │     2.26us │    735.00w │      1.79w │      1.79w │      0.12% │
│ Bitv create 100       │    26.97us │  7_305.00w │    192.90w │    192.90w │      1.43% │
│ Bitv create 1000      │   847.23us │ 72_004.00w │ 70_022.11w │ 69_021.11w │     45.02% │
│ Bitarray create 10    │    14.73us │    707.40w │    160.24w │    160.24w │      0.78% │
│ Bitarray create 100   │   154.01us │  7_043.17w │  1_628.72w │  1_628.72w │      8.18% │
│ Bitarray create 1000  │ 1_881.86us │ 69_268.84w │ 30_021.02w │ 29_020.02w │    100.00% │
└───────────────────────┴────────────┴────────────┴────────────┴────────────┴────────────┘

Union:
┌────────────────┬────────────────┬────────────┬────────────┬────────────┬────────────┐
│ Name           │       Time/Run │    mWd/Run │   mjWd/Run │   Prom/Run │ Percentage │
├────────────────┼────────────────┼────────────┼────────────┼────────────┼────────────┤
│ Bitv 10        │     1_814.37ns │    690.00w │      0.16w │      0.16w │      0.10% │
│ Bitv 100       │    17_989.47ns │  6_900.00w │      1.72w │      1.72w │      0.98% │
│ Bitv 1000      │   196_096.95ns │ 69_000.00w │     17.36w │     17.36w │     10.72% │
│ Bitarray 10    │    19_109.60ns │    779.59w │    160.15w │    160.15w │      1.04% │
│ Bitarray 100   │   165_841.00ns │  7_858.99w │  1_602.50w │  1_602.50w │      9.06% │
│ Bitarray 1000  │ 1_516_948.78ns │ 78_393.16w │ 16_014.47w │ 16_014.47w │     82.89% │
│ Batteries 10   │    13_737.36ns │    664.00w │      0.15w │      0.15w │      0.75% │
│ Batteries 100  │   154_086.43ns │  6_604.00w │      1.63w │      1.63w │      8.42% │
│ Batteries 1000 │ 1_830_022.22ns │ 66_004.00w │     16.16w │     16.16w │    100.00% │
│ Zarith 10      │       534.05ns │    488.00w │            │            │      0.03% │
│ Zarith 100     │     6_773.28ns │  6_274.00w │      1.53w │      1.53w │      0.37% │
│ Zarith 1000    │    89_438.59ns │ 65_765.00w │     16.52w │     16.52w │      4.89% │
└────────────────┴────────────────┴────────────┴────────────┴────────────┴────────────┘


  
