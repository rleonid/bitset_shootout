
open StdLabels
open Setup

let () =
  (* Samples *)
  let s10 = permutation 10 in
  let s100 = permutation 100 in
  let s1000 = permutation 1000 in

  let open Core.Std in
  let open Core_bench.Std in
  let btc name op =
    Bench.Test.create_indexed ~name ~args:[10;100;1000]
      (function
        | 10   -> Staged.stage (fun () -> op s10)
        | 100  -> Staged.stage (fun () -> op s100)
        | 1000 -> Staged.stage (fun () -> op s1000)
        | _    -> assert false)
  in
  Core.Command.run (Bench.make_command
    [(* btc "Zarith"                  ZarithTest.create_multiple_elements
    (*; btc "Zarith Precompute Masks" ZarithPrecomputeMasksTest.create_multiple_elements  *)
    ; btc "Batteries"               BatteriesTest.create_multiple_elements
    ; btc "Bitv"                    BitvectorTest.create_multiple_elements
    ; btc "Bitarray"                BitarrayTest.create_multiple_elements
    ; btc "Ocbitset"                OcbitsetTest.create_multiple_elements
    
    ; *) btc "Containers"           ContainersTest.create_multiple_elements
    ; btc "New Containers"          NewContainersTest.create_multiple_elements
    ; btc "Fxed Width"              FixedWidthTest.create_multiple_elements
    ])
