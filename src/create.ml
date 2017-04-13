
open StdLabels
open Setup

let () =
  (* Samples *)
  let s10 = sample 10 in
  let s100 = sample 100 in
  let s1000 = sample 1000 in

  let open Core_bench.Std in
  Core.Command.run (Bench.make_command
    [ Bench.Test.create ~name:"Zarith create 10"      (fun () -> ignore (singles s10   zar_singleton))
    ; Bench.Test.create ~name:"Zarith create 100"     (fun () -> ignore (singles s100  zar_singleton))
    ; Bench.Test.create ~name:"Zarith create 1000"    (fun () -> ignore (singles s1000 zar_singleton))

    ; Bench.Test.create ~name:"Batteries create 10"   (fun () -> ignore (singles s10   bat_singleton))
    ; Bench.Test.create ~name:"Batteries create 100"  (fun () -> ignore (singles s100  bat_singleton))
    ; Bench.Test.create ~name:"Batteries create 1000" (fun () -> ignore (singles s1000 bat_singleton))

    ; Bench.Test.create ~name:"Bitv create 10"        (fun () -> ignore (singles s10   biv_singleton))
    ; Bench.Test.create ~name:"Bitv create 100"       (fun () -> ignore (singles s100  biv_singleton))
    ; Bench.Test.create ~name:"Bitv create 1000"      (fun () -> ignore (singles s1000 biv_singleton))

    ; Bench.Test.create ~name:"Bitarray create 10"    (fun () -> ignore (singles s10   bia_singleton))
    ; Bench.Test.create ~name:"Bitarray create 100"   (fun () -> ignore (singles s100  bia_singleton))
    ; Bench.Test.create ~name:"Bitarray create 1000"  (fun () -> ignore (singles s1000 bia_singleton))
 
    ])
