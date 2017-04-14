
open StdLabels

module IntMap =
  Map.Make (struct type t = int let compare = compare end)

(* Bit sets on top of Zarith *)

module ZarithBitSet = struct

  type index =
    { size    : int
    ; indices : int IntMap.t
    }

  let index arr =
    { size    = Array.length arr
    ; indices = Array.fold_left arr ~init:(0, IntMap.empty)
                  ~f:(fun (i, sm) a -> (i + 1, IntMap.add a i sm))
                |> snd
    }

  (* One could compute all of the individual sets ahead of time, but that
     won't make the comparison fair.
  type index = Z.t IntMap.t

  let index arr =
    Array.fold_left arr ~init:(0, IntMap.empty)
                ~f:(fun (i, s) v ->
                      let m = Z.(shift_left one i) in
                      (i + 1, IntMap.add v m s))
                  |> snd
  *)

  let single_mask i elem =
    Z.(shift_left one (IntMap.find elem i.indices))

  let singleton = single_mask

  let empty () =
    Z.zero

  let set i s elem =
    Z.logand s (single_mask i elem)

  let is_set i t elem =
    let m = single_mask i elem in
    Z.(equal m (logand m t))

  let union =
    Z.logor

  let inter =
    Z.logand

  let diff x y =
    Z.logand x (Z.lognot y)

end

module BatteriesBitSet = struct

  module BitSet = Batteries.BitSet

  type index =
    { size    : int
    ; indices : int IntMap.t
    }

  let index arr =
    { size    = Array.length arr
    ; indices = Array.fold_left arr ~init:(0, IntMap.empty)
                  ~f:(fun (i, sm) a -> (i + 1, IntMap.add a i sm))
                |> snd
    }

  let set i s elem =
    BitSet.set s (IntMap.find elem i.indices)

  let singleton i elem =
    let s = BitSet.create i.size in
    set i s elem;
    s

  let empty = BitSet.empty

  let is_set i t elem = BitSet.mem t (IntMap.find elem i.indices)

  let union = BitSet.union

  let inter = BitSet.inter

  let diff = BitSet.diff

end

module BitvectorSet = struct

  type index =
    { indices : int IntMap.t
    ; size    : int
    }

  let index arr =
    { indices = Array.fold_left arr ~init:(0, IntMap.empty)
                  ~f:(fun (i, sm) a -> (i + 1, IntMap.add a i sm))
                |> snd
    ; size    = Array.length arr
    }

  let empty i = Bitv.create i.size false

  let singleton i elem =
    let s = empty i in
    Bitv.set s (IntMap.find elem i.indices) true;
    s

  let is_set i t elem = Bitv.get t (IntMap.find elem i.indices)

  let union = Bitv.bw_or
  let inter = Bitv.bw_and
  let diff x y = Bitv.bw_and x (Bitv.bw_not y)

end

(* Not an option, too many missing operations.
module CSet = struct

  module Bitarray = Core_extended.Bitarray

  type index =
    { indices : (string * int) list
    ; size    : int
    }

  let index arr =
    { indices = Array.mapi arr ~f:(fun i a -> (a, i)) |> Array.to_list
    ; size    = Array.length arr
    }

  let empty i = Bitarray.create i.size

  let singleton i elem =
    let s = emptiy i in
    Bitarray.set s (List.Assoc.get elem i.indices |> Option.value_exn ~msg:"") true;
    s
end *)

module BitarraySet = struct

  type index =
    { indices : int64 IntMap.t
    ; size    : int64 (* Really? *)
    }

  let index arr =
    { indices = Array.fold_left arr ~init:(Int64.zero, IntMap.empty)
                    ~f:(fun (i, sm) a -> (Int64.succ i, IntMap.add a i sm))
                  |> snd
    ; size    = Int64.of_int (Array.length arr)
    }

  let empty i = Bitarray.create i.size

  let singleton i elem =
    let s = empty i in
    Bitarray.set_bit s (IntMap.find elem i.indices);
    s

  let is_set i t elem = Bitarray.get_bit t (IntMap.find elem i.indices)

  let union = Bitarray.bitwise_or
  let inter = Bitarray.bitwise_and
  let diff x y = Bitarray.bitwise_and x (Bitarray.bitwise_not y)

end

module OCbitSet = struct

  type index =
    { indices : int IntMap.t
    ; size    : int (* Really? *)
    }

  let index arr =
    { indices = Array.fold_left arr ~init:(0, IntMap.empty)
                    ~f:(fun (i, sm) a -> (i + 1, IntMap.add a i sm))
                  |> snd
    ; size    = Array.length arr
    }

  let empty i = Ocbitset.create i.size

  let singleton i elem =
    let s = empty i in
    Ocbitset.set s (IntMap.find elem i.indices);
    s

  let is_set i t elem = Ocbitset.get t (IntMap.find elem i.indices)

  let union = Ocbitset.union

end

let test_size = 4000

let elems = Array.init test_size ~f:(fun i -> i)

let sample m =
  Array.init m ~f:(fun _ -> Random.int test_size)

let singles mi singleton =
  Array.map mi ~f:(fun i -> singleton elems.(i))

(* Create the indices *)
let zar_index = ZarithBitSet.index elems
let bat_index = BatteriesBitSet.index elems
let biv_index = BitvectorSet.index elems
let bia_index = BitarraySet.index elems
let ocb_index = OCbitSet.index elems

(* Singleton constructors, curried with the index *)
let zar_singleton = ZarithBitSet.singleton zar_index
let bat_singleton = BatteriesBitSet.singleton bat_index
let biv_singleton = BitvectorSet.singleton biv_index
let bia_singleton = BitarraySet.singleton bia_index
let ocb_singleton = OCbitSet.singleton ocb_index

