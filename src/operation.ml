
open StdLabels
open Setup

module IntSet = Set.Make (struct type t = int let compare = compare end)

let int_list_dedup l =
  List.fold_left l ~init:IntSet.empty ~f:(fun s e -> IntSet.add e s)
  |> IntSet.elements

let all_set ss es is_set =
  let n = Array.length es in
  assert (n = Array.length ss);
  let rec loop i =
    if i = n then
      true
    else if is_set ss.(i) es.(i) then
      loop (i + 1)
    else
        false
  in
  loop 0

let () =

  (* Samples *)
  let s10 = sample 10 in
  let s100 = sample 100 in
  let s1000 = sample 1000 in

  (* Single values, we time their creation in create.ml *)
  let zar_10 = singles s10 zar_singleton in
  let zar_100 = singles s100 zar_singleton in
  let zar_1000 = singles s1000 zar_singleton in

  assert (all_set zar_100 s100 (ZarithBitSet.is_set zar_index));

  let bat_10 = singles s10 bat_singleton in
  let bat_100 = singles s100 bat_singleton in
  let bat_1000 = singles s1000 bat_singleton in

  assert (all_set bat_100 s100 (BatteriesBitSet.is_set bat_index));

  let biv_10 = singles s10 biv_singleton in
  let biv_100 = singles s100 biv_singleton in
  let biv_1000 = singles s1000 biv_singleton in

  assert (all_set biv_100 s100 (BitvectorSet.is_set biv_index));

  let bia_10 = singles s10 bia_singleton in
  let bia_100 = singles s100 bia_singleton in
  let bia_1000 = singles s1000 bia_singleton in

  assert (all_set bia_100 s100 (BitarraySet.is_set bia_index));

  let ocb_10 = singles s10 ocb_singleton in
  let ocb_100 = singles s100 ocb_singleton in
  let ocb_1000 = singles s1000 ocb_singleton in

  assert (all_set ocb_100 s100 (OCbitSet.is_set ocb_index));

  (* Construct the empties for the start of the fold. *)
  let zar_e10 = ZarithBitSet.empty () in
  let zar_e100 = ZarithBitSet.empty () in
  let zar_e1000 = ZarithBitSet.empty () in

  let bat_e10 = BatteriesBitSet.empty () in
  let bat_e100 = BatteriesBitSet.empty () in
  let bat_e1000 = BatteriesBitSet.empty () in

  let biv_e10 = BitvectorSet.empty biv_index in
  let biv_e100 = BitvectorSet.empty biv_index in
  let biv_e1000 = BitvectorSet.empty biv_index in

  let bia_e10 = BitarraySet.empty bia_index in
  let bia_e100 = BitarraySet.empty bia_index in
  let bia_e1000 = BitarraySet.empty bia_index in

  let ocb_e10 = OCbitSet.empty ocb_index in
  let ocb_e100 = OCbitSet.empty ocb_index in
  let ocb_e1000 = OCbitSet.empty ocb_index in

  (* Time these *)
  let zarith10 () = Array.fold_left zar_10 ~init:zar_e10 ~f:ZarithBitSet.union in
  let zarith100 () = Array.fold_left zar_100 ~init:zar_e100 ~f:ZarithBitSet.union in
  let zarith1000 () = Array.fold_left zar_1000 ~init:zar_e1000 ~f:ZarithBitSet.union in

  let batteries10 () = Array.fold_left bat_10 ~init:bat_e10 ~f:BatteriesBitSet.union in
  let batteries100 () = Array.fold_left bat_100 ~init:bat_e100 ~f:BatteriesBitSet.union in
  let batteries1000 () = Array.fold_left bat_1000 ~init:bat_e1000 ~f:BatteriesBitSet.union in

  let biv10 () = Array.fold_left biv_10 ~init:biv_e10 ~f:BitvectorSet.union in
  let biv100 () = Array.fold_left biv_100 ~init:biv_e100 ~f:BitvectorSet.union in
  let biv1000 () = Array.fold_left biv_1000 ~init:biv_e1000 ~f:BitvectorSet.union in

  let bia10 () = Array.fold_left bia_10 ~init:bia_e10 ~f:BitarraySet.union in
  let bia100 () = Array.fold_left bia_100 ~init:bia_e100 ~f:BitarraySet.union in
  let bia1000 () = Array.fold_left bia_1000 ~init:bia_e1000 ~f:BitarraySet.union in

  let ocb10 () = Array.fold_left ocb_10 ~init:ocb_e10 ~f:OCbitSet.union in
  let ocb100 () = Array.fold_left ocb_100 ~init:ocb_e100 ~f:OCbitSet.union in
  let ocb1000 () = Array.fold_left ocb_1000 ~init:ocb_e1000 ~f:OCbitSet.union in

  (* But first, let's make sure they're the same. *)
  let elemsl = Array.to_list elems in
  let s100l  = Array.to_list s100 |> int_list_dedup in

  let same s is_set =
    elemsl
    |> List.filter ~f:(is_set s)
    |> int_list_dedup
    |> fun l -> l = s100l
  in
  let zarith_same = same (zarith100 ()) (ZarithBitSet.is_set zar_index) in
  Printf.printf "Zarith same results: %b\n" zarith_same;

  let batteries_same = same (batteries100 ()) (BatteriesBitSet.is_set bat_index) in
  Printf.printf "Batteries same results: %b\n" batteries_same;

  let bitvector_same = same (biv100 ()) (BitvectorSet.is_set biv_index) in
  Printf.printf "Bitv same results: %b\n" bitvector_same;

  let bitarray_same = same (bia100 ()) (BitarraySet.is_set bia_index) in
  Printf.printf "Bitarray same results: %b\n" bitarray_same;

  let ocbarray_same = same (ocb100 ()) (OCbitSet.is_set ocb_index) in
  Printf.printf "Ocbitset same results: %b\n" ocbarray_same;

  let ign f () = ignore (f ()) in
  let open Core_bench.Std in
  Core.Command.run (Bench.make_command
    [
      Bench.Test.create ~name:"Ocbitset 10" (ign ocb10)
    ; Bench.Test.create ~name:"Ocbitset 100" (ign ocb100)
    ; Bench.Test.create ~name:"Ocbitset 1000" (ign ocb1000)

    ; Bench.Test.create ~name:"Bitarray 10" (ign bia10)
    ; Bench.Test.create ~name:"Bitarray 100" (ign bia100)
    ; Bench.Test.create ~name:"Bitarray 1000" (ign bia1000)

    ; Bench.Test.create ~name:"Bitv 10" (ign biv10)
    ; Bench.Test.create ~name:"Bitv 100" (ign biv100)
    ; Bench.Test.create ~name:"Bitv 1000" (ign biv1000)

    ; Bench.Test.create ~name:"Batteries 10" (ign batteries10)
    ; Bench.Test.create ~name:"Batteries 100" (ign batteries100)
    ; Bench.Test.create ~name:"Batteries 1000" (ign batteries1000)

    ; Bench.Test.create ~name:"Zarith 10" (ign zarith10)
    ; Bench.Test.create ~name:"Zarith 100" (ign zarith100)
    ; Bench.Test.create ~name:"Zarith 1000" (ign zarith1000)

    ])
