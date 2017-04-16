
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
  let zar_10 = ZarithTest.create_single_elements s10 in
  let zar_100 = ZarithTest.create_single_elements s100 in
  let zar_1000 = ZarithTest.create_single_elements s1000 in

  assert (all_set zar_100 s100 ZarithTest.is_set);

  let bat_10 = BatteriesTest.create_single_elements s10 in
  let bat_100 = BatteriesTest.create_single_elements s100 in
  let bat_1000 = BatteriesTest.create_single_elements s1000 in

  assert (all_set bat_100 s100 BatteriesTest.is_set);

  let biv_10 = BitvectorTest.create_single_elements s10 in
  let biv_100 = BitvectorTest.create_single_elements s100 in
  let biv_1000 = BitvectorTest.create_single_elements s1000 in

  assert (all_set biv_100 s100 BitvectorTest.is_set);

  let bia_10 = BitarrayTest.create_single_elements s10 in
  let bia_100 = BitarrayTest.create_single_elements s100 in
  let bia_1000 = BitarrayTest.create_single_elements s1000 in

  assert (all_set bia_100 s100 BitarrayTest.is_set);

  let ocb_10 = OcbitsetTest.create_single_elements s10 in
  let ocb_100 = OcbitsetTest.create_single_elements s100 in
  let ocb_1000 = OcbitsetTest.create_single_elements s1000 in

  assert (all_set ocb_100 s100 OcbitsetTest.is_set);

  (* But first, let's make sure they're actually the same. *)
  let elemsl = Array.to_list elems in
  let s100l  = Array.to_list s100 |> int_list_dedup in

  let same s is_set =
    elemsl
    |> List.filter ~f:(is_set s)
    |> int_list_dedup
    |> fun l -> l = s100l
  in
  let zarith_same = same (ZarithTest.reduce zar_100) ZarithTest.is_set in
  Printf.printf "Zarith same results: %b\n" zarith_same;

  let batteries_same = same (BatteriesTest.reduce bat_100) BatteriesTest.is_set in
  Printf.printf "Batteries same results: %b\n" batteries_same;

  let bitvector_same = same (BitvectorTest.reduce biv_100) BitvectorTest.is_set in
  Printf.printf "Bitv same results: %b\n" bitvector_same;

  let bitarray_same = same (BitarrayTest.reduce bia_100) BitarrayTest.is_set in
  Printf.printf "Bitarray same results: %b\n" bitarray_same;

  let ocbarray_same = same (OcbitsetTest.reduce ocb_100) OcbitsetTest.is_set in
  Printf.printf "Ocbitset same results: %b\n" ocbarray_same;

  let open Core_bench.Std in
  let btc name size t sample =
    Bench.Test.create ~name:(Printf.sprintf "%s %d" name size)
      (fun () -> ignore (t sample))
  in
  Core.Command.run (Bench.make_command
    [ btc "Zarith" 10       ZarithTest.reduce zar_10
    ; btc "Zarith" 100      ZarithTest.reduce zar_100
    ; btc "Zarith" 1000     ZarithTest.reduce zar_1000

    ; btc "Batteries" 10    BatteriesTest.reduce bat_10
    ; btc "Batteries" 100   BatteriesTest.reduce bat_100
    ; btc "Batteries" 1000  BatteriesTest.reduce bat_1000

    ; btc "Bitvector" 10    BitvectorTest.reduce biv_10
    ; btc "Bitvector" 100   BitvectorTest.reduce biv_100
    ; btc "Bitvector" 1000  BitvectorTest.reduce biv_1000

    ; btc "Bitarray" 10     BitarrayTest.reduce bia_10
    ; btc "Bitarray" 100    BitarrayTest.reduce bia_100
    ; btc "Bitarray" 1000   BitarrayTest.reduce bia_1000

    ; btc "Ocbitset" 10     OcbitsetTest.reduce ocb_10
    ; btc "Ocbitset" 100    OcbitsetTest.reduce ocb_100
    ; btc "Ocbitset" 1000   OcbitsetTest.reduce ocb_1000

    ])
