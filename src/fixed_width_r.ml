
(** Fixed width! Imperative Bitvectors *)

let width_ = Sys.word_size - 1

(** We use OCamls ints to store the bits. We index them from the
    least significant bit. We create masks to zero out the most significant
    bits that aren't used to store values. This is necessary when we are
    constructing or negating a bit vector. *)
let lsb_masks_ =
  let a = Array.make (width_ + 1) 0 in
  for i = 1 to width_ do
    a.(i) <- a.(i-1) lor (1 lsl (i - 1))
  done;
  a

let all_ones_ = lsb_masks_.(width_)

(* count the 1 bits in [n]. See https://en.wikipedia.org/wiki/Hamming_weight *)
let count_bits_ n =
  let rec recurse count n =
    if n = 0 then count else recurse (count+1) (n land (n-1))
  in
  recurse 0 n


type t = {
  mutable a : int array;
}

let size = ref (-1)
let mask = ref lsb_masks_.(0)
let final_length = ref 0
let array_length = ref (-1)
let last_array_index = ref (!array_length - 1)

let setup new_size =
  begin
    let r = new_size mod width_ in
    size := new_size;
    mask := lsb_masks_.(r);
    final_length := max r width_;
    array_length := (if new_size mod width_ = 0 then new_size / width_ else (new_size / width_) + 1);
    last_array_index := !array_length - 1
  end


let empty () = { a = [| |]  }

let create default =
  let a = if default
    then Array.make !array_length all_ones_
    else Array.make !array_length 0
  in
  (* adjust last bits *)
  if default && !mask <> 0 then Array.unsafe_set a !last_array_index !mask;
  { a; }

let copy bv = { a = Array.copy bv.a }

let capacity = width_ * !array_length

let cardinal bv =
  let n = ref 0 in
  for i = 0 to !last_array_index do
    n := !n + count_bits_ bv.a.(i)         (* MSB of last element are all 0 *)
  done;
  !n

let is_empty bv =
  try
    for i = 0 to !last_array_index do
      if bv.a.(i) <> 0 then raise Exit     (* MSB of last element are all 0 *)
    done;
    true
  with Exit ->
    false

(* Use the safe array access and throw an exception if out of bounds.
    This can be compiled away with -unsafe. *)
let get bv i =
  let n = i / width_ in
  let j = i mod width_ in
  bv.a.(n) land (1 lsl j) <> 0

let set bv i =
  let n = i / width_ in
  let j = i mod width_ in
  bv.a.(n) <- bv.a.(n) lor (1 lsl j)

let reset bv i =
  let n = i / width_ in
  let j = i mod width_ in
  bv.a.(n) <- bv.a.(n) land (lnot (1 lsl j))

let flip bv i =
  let n = i / width_ in
  let j = i mod width_ in
  bv.a.(n) <- bv.a.(n) lxor (1 lsl j)

let clear bv =
  Array.fill bv.a 0 !array_length 0

let iter bv f =
  for n = 0 to !last_array_index - 2 do
    let j = width_ * n in
    for i = 0 to width_ - 1 do
      f (j+i) (bv.a.(n) land (1 lsl i) <> 0)
    done
  done;
  let j = width_ * !last_array_index in
  for i = 0 to !final_length - 1 do
    f (j + i) (bv.a.(!last_array_index) land (1 lsl i) <> 0)
  done

let iter_true bv f =
  iter bv (fun i b -> if b then f i else ())

let to_list bv =
  let l = ref [] in
  iter_true bv (fun i -> l := i :: !l);
  !l

let to_sorted_list bv =
  List.rev (to_list bv)

(* Interpret these as indices. *)
let of_list l =
  let bv = create false in
  List.iter (set bv) l;
  bv

exception FoundFirst of int

let first_exn bv =
  try
    iter_true bv (fun i -> raise (FoundFirst i));
    raise Not_found
  with FoundFirst i ->
    i

let first bv =
  try Some (first_exn bv)
  with Not_found -> None

let filter bv p =
  iter_true bv
    (fun i -> if not (p i) then reset bv i)

let negate_self b =
  for n = 0 to !last_array_index do
    Array.unsafe_set b.a n (lnot (Array.unsafe_get b.a n))
  done;
  if !mask <> 0 then
    Array.unsafe_set b.a !last_array_index
      (!mask land (Array.unsafe_get b.a !last_array_index))

let negate b =
  let a = Array.map (lnot) b.a in
  if !mask <> 0 then begin
    Array.unsafe_set a !last_array_index
      (!mask land (Array.unsafe_get a !last_array_index))
  end;
  { a }

let union_into ~into bv =
  for i = 0 to !last_array_index do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) lor (Array.unsafe_get bv.a i))
  done

(* To avoid potentially 2 passes, figure out what we need to copy. *)
let union b1 b2 =
  let into = copy b1 in
  union_into ~into b2;
  into

(* Underlying size shrinks for inter. *)
let inter_into ~into bv =
  for i = 0 to !last_array_index do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) land (Array.unsafe_get bv.a i))
  done

let inter b1 b2 =
  let into = copy b1 in
  inter_into ~into b2;
  into

let diff_into ~into bv =
  for i = 0 to !last_array_index do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) land (lnot (Array.unsafe_get bv.a i)))
  done

let diff in_ not_in =
  let into = copy in_ in
  diff_into ~into not_in;
  into

let select bv arr =
  let l = ref [] in
  begin try
      iter_true bv
        (fun i ->
          if i >= !last_array_index
          then raise Exit
          else l := arr.(i) :: !l)
    with Exit -> ()
  end;
  !l

let selecti bv arr =
  let l = ref [] in
  begin try
      iter_true bv
        (fun i ->
          if i >= !array_length
          then raise Exit
          else l := (arr.(i), i) :: !l)
    with Exit -> ()
  end;
  !l

type 'a sequence = ('a -> unit) -> unit

let to_seq bv k = iter_true bv k

let of_seq seq =
  let l = ref [] and maxi = ref 0 in
  seq (fun x -> l := x :: !l; maxi := max !maxi x);
  let bv = create false in
  List.iter (fun i -> set bv i) !l;
  bv

let print out bv =
  Format.pp_print_string out "bv {";
  iter bv
    (fun _i b ->
      Format.pp_print_char out (if b then '1' else '0')
    );
  Format.pp_print_string out "}"
