
open StdLabels

module IntMap =
  Map.Make (struct type t = int let compare = compare end)

(* Bit sets on top of Zarith *)
module ZarithBitSet = struct

  type t = Z.t
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

  let empty _i =
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

  type t = BitSet.t
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

  let empty _i = BitSet.empty ()

  let is_set i t elem = BitSet.mem t (IntMap.find elem i.indices)

  let union = BitSet.union

  let inter = BitSet.inter

  let diff = BitSet.diff

end

module BitvectorSet = struct

  type t = Bitv.t
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

  type t = Bitarray.t
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

  type t = Ocbitset.t

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

  let empty i = Ocbitset.create i.size

  let singleton i elem =
    let s = empty i in
    Ocbitset.set s (IntMap.find elem i.indices);
    s

  let is_set i t elem = Ocbitset.get t (IntMap.find elem i.indices)

  let union = Ocbitset.union

end

(* Containers. *)
module Cbitset = struct

  type t = CCBV.t

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

  let empty _i = CCBV.empty ()

  let singleton i elem =
    let s = CCBV.create ~size:i.size false in
    CCBV.set s (IntMap.find elem i.indices);
    s

  let is_set i t elem = CCBV.get t (IntMap.find elem i.indices)

  let union = CCBV.union

end

let test_size = 4000

let elems = Array.init test_size ~f:(fun i -> i)

let sample m =
  Array.init m ~f:(fun _ -> Random.int test_size)

module Test (Bs : sig
  type index
  type t
  val index : int array -> index
  val empty : index -> t
  val singleton : index -> int -> t
  val is_set : index -> t -> int -> bool
  val union : t -> t -> t
end) = struct

  (* Create the indices *)
  let index = Bs.index elems

  (* Singleton constructors, curried with the index *)
  let singleton = Bs.singleton index

  let create_single_elements mi =
    Array.map mi ~f:(fun i -> singleton elems.(i))

  let is_set = Bs.is_set index

  let reduce =
    Array.fold_left ~init:(Bs.empty index) ~f:Bs.union

end

module ZarithTest = Test(ZarithBitSet)
module BatteriesTest = Test(BatteriesBitSet)
module BitvectorTest = Test(BitvectorSet)
module BitarrayTest = Test(BitarraySet)
module OcbitsetTest = Test(OCbitSet)
module ContainersTest = Test(Cbitset)

