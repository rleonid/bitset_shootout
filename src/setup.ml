
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

  let single_mask i elem =
    Z.(shift_left one (IntMap.find elem i.indices))

  let singleton = single_mask

  let empty _i =
    Z.zero

  let set i s elem =
    Z.logor s (single_mask i elem)

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

(* Bit sets on top of Zarith *)
module ZarithPrecomputeMasksBitSet = struct

  type t = Z.t

  type index =
    { size    : int
    ; indices : Z.t IntMap.t
    }

  let index arr =
    { size    = Array.length arr
    ; indices = Array.fold_left arr ~init:(0, IntMap.empty)
                  ~f:(fun (i, sm) a ->
                       let m = Z.(shift_left one i) in
                       (i + 1, IntMap.add a m sm))
                |> snd
    }

  let single_mask i elem =
    IntMap.find elem i.indices

  let singleton = single_mask

  let empty _i =
    Z.zero

  let set i s elem =
    Z.logor s (single_mask i elem)

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
    BitSet.set s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    let s = BitSet.create i.size in
    set i s elem

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

  let set i s elem =
    Bitv.set s (IntMap.find elem i.indices) true;
    s

  let singleton i elem =
    set i (empty i) elem

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

  let set i s elem =
    Bitarray.set_bit s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    set i (empty i) elem

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

  let set i s elem =
    Ocbitset.set s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    set i (empty i) elem

  let is_set i t elem = Ocbitset.get t (IntMap.find elem i.indices)

  let union = Ocbitset.union

  let diff = Ocbitset.difference

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

  let set i s elem =
    CCBV.set s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    set i (empty i) elem

  let is_set i t elem = CCBV.get t (IntMap.find elem i.indices)

  let union = CCBV.union

  let negate y =
    let yc = CCBV.copy y in
    CCBV.iter yc CCBV.(fun i _ -> CCBV.flip yc i);  (* Is this safe? *)
    yc

  let diff x y =
    CCBV.union x (negate y)

end

(* Containers. *)
module Ncbitset = struct

  type t = Cn.t

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

  let empty i = Cn.create ~size:i.size false

  let set i s elem =
    Cn.set s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    set i (empty i) elem

  let is_set i t elem = Cn.get t (IntMap.find elem i.indices)

  let union = Cn.union

  let negate = Cn.negate

  let diff = Cn.diff

end


let test_size = 4000

(* Fixed width. *)
module FixedWidthBs = struct
  
  module Fw = Fixed_width.Make(struct let size = test_size end)

  type t = Fw.t

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

  let empty _i = Fw.create false

  let set i s elem =
    Fw.set s (IntMap.find elem i.indices);
    s

  let singleton i elem =
    set i (empty i) elem

  let is_set i t elem = Fw.get t (IntMap.find elem i.indices)

  let union = Fw.union

  let negate = Fw.negate

  let diff = Fw.diff

end


let elems = Array.init test_size ~f:(fun i -> i)

let permute () =
  let a = Array.copy elems in
  for n = test_size - 1 downto 1 do
    let k = Random.int (n + 1) in
    let temp = a.(n) in
    a.(n) <- a.(k);
    a.(k) <- temp
  done;
  a

let sample m =
  Array.init m ~f:(fun _ -> Random.int test_size)

let permutation m =
  Array.sub (permute ()) ~pos:0 ~len:m

module Test (Bs : sig
  type index
  type t
  val index : int array -> index
  val empty : index -> t
  val singleton : index -> int -> t
  val set : index -> t -> int -> t
  val is_set : index -> t -> int -> bool
  val union : t -> t -> t
  val diff : t -> t -> t
end) = struct

  (* Create the indices *)
  let index = Bs.index elems

  (* Singleton constructors, curried with the index *)
  let singleton = Bs.singleton index

  let create_single_elements mi =
    Array.map mi ~f:(fun i -> singleton elems.(i))

  let create_multiple_elements mi =
    Array.fold_left mi ~init:(Bs.empty index) ~f:(Bs.set index)

  let is_set = Bs.is_set index

  let reduce op mi =
    let n = Array.length mi in
    let rec loop a i =
      if i = n then
        a
      else
        loop (op a (mi.(i))) (i + 1)
    in
    loop mi.(0) 1

  let reduce_union = reduce Bs.union

  let reduce_union_test samples =
    let m = Array.map ~f:create_multiple_elements samples in
    fun () -> reduce_union m

  let reduce_diff = reduce Bs.diff

  let reduce_diff_test samples =
    let m = Array.map ~f:create_multiple_elements samples in
    fun () -> reduce_diff m

end

module ZarithTest = Test(ZarithBitSet)
module ZarithPrecomputeMasksTest = Test(ZarithPrecomputeMasksBitSet)
module BatteriesTest = Test(BatteriesBitSet)
module BitvectorTest = Test(BitvectorSet)
module BitarrayTest = Test(BitarraySet)
module OcbitsetTest = Test(OCbitSet)
module ContainersTest = Test(Cbitset)
module NewContainersTest = Test(Ncbitset)
module FixedWidthTest = Test(FixedWidthBs)

