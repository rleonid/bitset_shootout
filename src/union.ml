
open StdLabels
open MoreLabels
open Setup

module IntSet = Set.Make (struct type t = int let compare = compare end)

let () =

  (* Samples *)
  let t2 = test_size / 2 in
  let args = [10;100;1000] in
  let s10 = Array.init 10 ~f:(fun _ -> permutation t2) in
  let s100 = Array.init 100 ~f:(fun _ -> permutation t2) in
  let s1000 = Array.init 1000 ~f:(fun _ -> permutation t2) in

  (* Single values, we time their creation in create.ml *)
  let open Core.Std in
  let staged op = function
    | 10   -> Staged.stage (op s10)
    | 100  -> Staged.stage (op s100)
    | 1000 -> Staged.stage (op s1000)
    | _    -> assert false
  in
  let zar = staged ZarithTest.reduce_union_test in
  let bat = staged BatteriesTest.reduce_union_test in
  let biv = staged BitvectorTest.reduce_union_test in
  let bia = staged BitarrayTest.reduce_union_test in
  let ocb = staged OcbitsetTest.reduce_union_test in
  let con = staged ContainersTest.reduce_union_test in

  (* But first, let's make sure they're actually the same. *)
  let int_union =
    let sets_a = Array.map s100 ~f:(fun int_arr -> IntSet.of_list (Array.to_list int_arr)) in
    let sets_l = Array.to_list sets_a in
    match sets_l with
    | []     -> assert false
    | h :: t -> List.fold_left t ~init:h ~f:IntSet.union
  in

  let same is_set =
    IntSet.fold int_union ~init:true ~f:(fun v b -> b && (is_set v))
  in

  let unst s = (Staged.unstage s) () in
  let zarith_same = same (ZarithTest.is_set (unst (zar 100))) in
  Printf.printf "Zarith same results: %b\n" zarith_same;

  let batteries_same = same (BatteriesTest.is_set (unst (bat 100))) in
  Printf.printf "Batteries same results: %b\n" batteries_same;

  let bitvector_same = same (BitvectorTest.is_set (unst (biv 100))) in
  Printf.printf "Bitv same results: %b\n" bitvector_same;

  let bitarray_same = same (BitarrayTest.is_set (unst (bia 100))) in
  Printf.printf "Bitarray same results: %b\n" bitarray_same;

  let ocbarray_same = same (OcbitsetTest.is_set (unst (ocb 100))) in
  Printf.printf "Ocbitset same results: %b\n" ocbarray_same;

  let conarray_same = same (ContainersTest.is_set (unst (con 100))) in
  Printf.printf "Containers same results: %b\n" conarray_same;

  let open Core_bench.Std in
  let btc name t =
    Bench.Test.create_indexed ~name ~args t
  in
  Core.Command.run (Bench.make_command
    [ btc "Zarith" zar
    (*; btc "Zarith Precompute Masks" zarp *)
    ; btc "Batteries" bat
    ; btc "Bitvector" biv
    ; btc "Bitarray" bia
    ; btc "Ocbitset" ocb
    ; btc "Containers" con
    ])
