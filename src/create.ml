
open StdLabels
open Setup

let () =
  (* Samples *)
  let s10 = sample 10 in
  let s100 = sample 100 in
  let s1000 = sample 1000 in

  let open Core_bench.Std in
  let btc name size t sample =
    Bench.Test.create ~name:(Printf.sprintf "%s %d" name size)
      (fun () -> ignore (t sample))
  in
  Core.Command.run (Bench.make_command
    [ btc "Zarith"    10    ZarithTest.create_single_elements     s10
    ; btc "Zarith"    100   ZarithTest.create_single_elements     s100
    ; btc "Zarith"    1000  ZarithTest.create_single_elements     s1000

    ; btc "Batteries" 10    BatteriesTest.create_single_elements  s10
    ; btc "Batteries" 100   BatteriesTest.create_single_elements  s100
    ; btc "Batteries" 1000  BatteriesTest.create_single_elements  s1000

    ; btc "Bitv"      10    BitvectorTest.create_single_elements  s10
    ; btc "Bitv"      100   BitvectorTest.create_single_elements  s100
    ; btc "Bitv"      1000  BitvectorTest.create_single_elements  s1000

    ; btc "Bitarray"  10    BitarrayTest.create_single_elements   s10
    ; btc "Bitarray"  100   BitarrayTest.create_single_elements   s100
    ; btc "Bitarray"  1000  BitarrayTest.create_single_elements   s1000

    ; btc "Ocbitset"  10    OcbitsetTest.create_single_elements   s10
    ; btc "Ocbitset"  100   OcbitsetTest.create_single_elements   s100
    ; btc "Ocbitset"  1000  OcbitsetTest.create_single_elements   s1000

    ])
