
open StdLabels
open Setup

let () =
  (* Samples *)
  let s10 = sample 10 in
  let s100 = sample 100 in
  let s1000 = sample 1000 in

  let open Core_bench.Std in
  Core.Command.run (Bench.make_command
    [ Bench.Test.create ~name:"Zarith 10"      (fun () -> ignore (singles s10   zar_singleton))
    ; Bench.Test.create ~name:"Zarith 100"     (fun () -> ignore (singles s100  zar_singleton))
    ; Bench.Test.create ~name:"Zarith 1000"    (fun () -> ignore (singles s1000 zar_singleton))

    ; Bench.Test.create ~name:"Batteries 10"   (fun () -> ignore (singles s10   bat_singleton))
    ; Bench.Test.create ~name:"Batteries 100"  (fun () -> ignore (singles s100  bat_singleton))
    ; Bench.Test.create ~name:"Batteries 1000" (fun () -> ignore (singles s1000 bat_singleton))

    ; Bench.Test.create ~name:"Bitv 10"        (fun () -> ignore (singles s10   biv_singleton))
    ; Bench.Test.create ~name:"Bitv 100"       (fun () -> ignore (singles s100  biv_singleton))
    ; Bench.Test.create ~name:"Bitv 1000"      (fun () -> ignore (singles s1000 biv_singleton))

    ; Bench.Test.create ~name:"Bitarray 10"    (fun () -> ignore (singles s10   bia_singleton))
    ; Bench.Test.create ~name:"Bitarray 100"   (fun () -> ignore (singles s100  bia_singleton))
    ; Bench.Test.create ~name:"Bitarray 1000"  (fun () -> ignore (singles s1000 bia_singleton))

    ; Bench.Test.create ~name:"Ocbitset 10"    (fun () -> ignore (singles s10   ocb_singleton))
    ; Bench.Test.create ~name:"Ocbitset 100"   (fun () -> ignore (singles s100  ocb_singleton))
    ; Bench.Test.create ~name:"Ocbitset 1000"  (fun () -> ignore (singles s1000 ocb_singleton))
    ])
