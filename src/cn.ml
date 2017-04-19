
(** {2 Imperative Bitvectors} *)

let __width = Sys.word_size - 1

(** We use OCamls ints to store the bits. We index them from the
    least significant bit. We create masks to zero out the most significant
    bits that aren't used to store values. *)
let __lsb_masks =
  let a = Array.make (__width + 1) 0 in
  for i = 1 to __width do
    a.(i) <- a.(i-1) lor (1 lsl (i - 1))
  done;
  a

let __all_ones = __lsb_masks.(__width)

(* count the 1 bits in [n]. See https://en.wikipedia.org/wiki/Hamming_weight *)
let __count_bits n =
  let rec recurse count n =
    if n = 0 then count else recurse (count+1) (n land (n-1))
  in
  recurse 0 n

(*$Q
  (Q.int_bound (Sys.word_size - 1)
    (fun i -> __count_bits __lsb_masks.(i) == i)
*)

type t = {
  mutable a : int array;
  mutable size : int;
}

let length t = t.size

let empty () = { a = [| |] ; size = 0 }

let __to_array_legnth size =
  if size mod __width = 0 then size / __width else (size / __width) + 1

let create ~size default =
  if size = 0 then { a = [| |] ; size }
  else begin
    let n = __to_array_legnth size in
    let arr = if default
      then Array.make n __all_ones
      else Array.make n 0
    in
    (* adjust last bits *)
    let r = size mod __width in
    if default && r <> 0
    then Array.unsafe_set arr (n-1) __lsb_masks.(r);
    { a = arr; size }
  end

(*$Q
  (Q.pair Q.small_int Q.bool (fun size b -> create ~size b |> length = size)
*)

(*$T
  create ~size:17 true |> cardinal = 17
  create ~size:32 true |> cardinal = 32
  create ~size:132 true |> cardinal = 132
  create ~size:200 false |> cardinal = 0
  create ~size:29 true |> to_sorted_list = CCList.range 0 28
*)

let copy bv = { a = Array.copy bv.a ; size = bv.size }

(*$Q
  (Q.list Q.small_int) (fun l -> \
    let bv = of_list l in to_list bv = to_list (copy bv))
*)

let capacity bv = __width * Array.length bv.a

let cardinal bv =
  let n = ref 0 in
  for i = 0 to Array.length bv.a - 1 do
    n := !n + __count_bits bv.a.(i)
  done;
  !n

(*$Q
  (Q.small_int (fun size -> create ~size true |> cardinal = size)
*)

let __really_resize bv ~desired ~current size =
  let a' = Array.make desired 0 in
  Array.blit bv.a 0 a' 0 current;
  bv.a <- a';
  bv.size <- size

let __grow bv size =
  if size <= capacity bv                                   (* within capacity *)
  then bv.size <- size
  else                                                     (* beyond capacity *)
    let desired = __to_array_legnth size in
    let current = Array.length bv.a in
    __really_resize bv ~desired ~current size

let __shrink bv size =
  let desired = __to_array_legnth size in
  let current = Array.length bv.a in
  __really_resize bv ~desired ~current size

let resize bv size =
  if size < bv.size                                                 (* shrink *)
  then __shrink bv size
  else if size = bv.size
  then ()
  else __grow bv size

(*$R
  let bv1 = CCBV.create ~size:87 true in
  assert_equal ~printer:string_of_int 87 (CCBV.cardinal bv1);
*)

(*$Q
  Q.small_int (fun n -> CCBV.cardinal (CCBV.create ~size:n true) = n)
*)

let is_empty bv =
  try
    for i = 0 to Array.length bv.a - 1 do
      if bv.a.(i) <> 0 then raise Exit
    done;
    true
  with Exit ->
    false

let get bv i =
  if i < 0 then invalid_arg "get: negative index" else
    let n = i / __width in
    let i = i mod __width in
    if n < Array.length bv.a
    then (Array.unsafe_get bv.a n) land (1 lsl i) <> 0
    else false

(*$R
  let bv = CCBV.create ~size:99 false in
  assert_bool "32 must be false" (not (CCBV.get bv 32));
  assert_bool "88 must be false" (not (CCBV.get bv 88));
  assert_bool "5 must be false" (not (CCBV.get bv 5));
  CCBV.set bv 32;
  CCBV.set bv 88;
  CCBV.set bv 5;
  assert_bool "32 must be true" (CCBV.get bv 32);
  assert_bool "88 must be true" (CCBV.get bv 88);
  assert_bool "5 must be true" (CCBV.get bv 5);
  assert_bool "33 must be false" (not (CCBV.get bv 33));
  assert_bool "44 must be false" (not (CCBV.get bv 44));
  assert_bool "1 must be false" (not (CCBV.get bv 1));
*)

let set bv i =
  if i < 0 then invalid_arg "set: negative index" else
    let n = i / __width in
    let j = i mod __width in
    if i >= bv.size then __grow bv i;
    Array.unsafe_set bv.a n ((Array.unsafe_get bv.a n) lor (1 lsl j))

(*$T
  let bv = create ~size:3 false in set bv 0; get bv 0
  let bv = create ~size:3 false in set bv 1; not (get bv 0)
*)

let reset bv i =
  if i < 0 then invalid_arg "reset: negative index" else
    let n = i / __width in
    let j = i mod __width in
    if i >= bv.size then __grow bv i;
    Array.unsafe_set bv.a n ((Array.unsafe_get bv.a n) land (lnot (1 lsl j)))

(*$T
  let bv = create ~size:3 false in set bv 0; reset bv 0; not (get bv 0)
*)

let flip bv i =
  if i < 0 then invalid_arg "reset: negative index" else
    let n = i / __width in
    let i = i mod __width in
    if i >= bv.size then __grow bv i;
    let i = i - n * __width in
    Array.unsafe_set bv.a n ((Array.unsafe_get bv.a n) lxor (1 lsl i))

(*$R
  let bv = of_list [1;10; 11; 30] in
  flip bv 10;
  assert_equal [1;11;30] (to_sorted_list bv);
  assert_equal false (get bv 10);
  flip bv 10;
  assert_equal true (get bv 10);
  flip bv 5;
  assert_equal [1;5;10;11;30] (to_sorted_list bv);
  assert_equal true (get bv 5);
  flip bv 100;
  assert_equal [1;5;10;11;30;100] (to_sorted_list bv);
  assert_equal true (get bv 100);
*)

let clear bv =
  Array.fill bv.a 0 (Array.length bv.a - 1) 0

(*$T
  let bv = create ~size:37 true in cardinal bv = 37 && (clear bv; cardinal bv= 0)
*)

(*$R
  let bv = CCBV.of_list [1; 5; 200] in
  assert_equal ~printer:string_of_int 3 (CCBV.cardinal bv);
  CCBV.clear bv;
  assert_equal ~printer:string_of_int 0 (CCBV.cardinal bv);
  assert_bool "must be empty" (CCBV.is_empty bv);
*)

let iter bv f =
  let len = Array.length bv.a in
  for n = 0 to len - 1 do
    let j = __width * n in
    for i = 0 to __width - 1 do
      f (j+i) (bv.a.(n) land (1 lsl i) <> 0)
    done
  done

(*$R
  let bv = create ~size:30 false in
  set bv 5;
  let n = ref 0 in
  iter bv (fun i b -> incr n; assert_equal b (i=5));
  assert_bool "at least 30" (!n >= 30)
*)

let iter_true bv f =
  let len = Array.length bv.a in
  for n = 0 to len - 1 do
    let j = __width * n in
    for i = 0 to __width - 1 do
      if bv.a.(n) land (1 lsl i) <> 0
      then f (j+i)
    done
  done

(*$T
  of_list [1;5;7] |> iter_true |> Sequence.to_list |> List.sort CCOrd.compare = [1;5;7]
*)

(*$inject
  let _gen = Q.Gen.(map of_list (list nat))
  let _pp bv = Q.Print.(list string) (List.map string_of_int (to_list bv))
  let _small bv = length bv

  let gen_bv = Q.make ~small:_small ~print:_pp _gen
*)

(*$QR
  gen_bv (fun bv ->
    let l' = Sequence.to_rev_list (CCBV.iter_true bv) in
    let bv' = CCBV.of_list l' in
    CCBV.cardinal bv = CCBV.cardinal bv'
  )
*)

let to_list bv =
  let l = ref [] in
  iter_true bv (fun i -> l := i :: !l);
  !l

(*$R
  let bv = CCBV.of_list [1; 5; 156; 0; 222] in
  assert_equal ~printer:string_of_int 5 (CCBV.cardinal bv);
  CCBV.set bv 201;
  assert_equal ~printer:string_of_int 6 (CCBV.cardinal bv);
  let l = CCBV.to_list bv in
  let l = List.sort compare l in
  assert_equal [0;1;5;156;201;222] l;
*)

let to_sorted_list bv =
  List.rev (to_list bv)

(* Interpret these as indices. *)
let of_list l =
  let size = (List.fold_left max 0 l) + 1 in
  let bv = create ~size false in
  List.iter (fun i -> set bv i) l;
  bv

(*$T
  of_list [1;32;64] |> CCFun.flip get 64
  of_list [1;32;64] |> CCFun.flip get 32
  of_list [1;31;63] |> CCFun.flip get 63
*)

exception FoundFirst of int

let first bv =
  try
    iter_true bv (fun i -> raise (FoundFirst i));
    raise Not_found
  with FoundFirst i ->
    i

(*$T
  of_list [50; 10; 17; 22; 3; 12] |> first = 3
*)

let filter bv p =
  iter_true bv
    (fun i -> if not (p i) then reset bv i)

(*$T
  let bv = of_list [1;2;3;4;5;6;7] in filter bv (fun x->x mod 2=0); \
    to_sorted_list bv = [2;4;6]
*)

let negate_self b =
  let len = Array.length b.a in
  for n = 0 to len - 1 do
    Array.unsafe_set b.a n (lnot (Array.unsafe_get b.a n))
  done;
  let r = b.size mod __width in
  if r <> 0 then
    let l = Array.length b.a - 1 in
    Array.unsafe_set b.a l (__lsb_masks.(r) land (Array.unsafe_get b.a l))

(*$T
  let v = of_list [1;2;5;7;] in negate_self v; \
    cardinal v = (List.length [0;3;4;6])
*)

let negate b =
  let a =  Array.map (lnot) b.a in
  let r = b.size mod __width in
  if r <> 0 then begin
    let l = Array.length b.a - 1 in
    Array.unsafe_set a l (__lsb_masks.(r) land (Array.unsafe_get a l))
  end;
  { a ; size = b.size }

(*$Q
  (Q.small_int (fun size -> create ~size false |> negate |> cardinal = size)
*)

(* Underlying size grows for union. *)
let union_into ~into bv =
  if into.size < bv.size
  then __grow into bv.size;
  for i = 0 to (Array.length into.a) - 1 do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) lor (Array.unsafe_get bv.a i))
  done

(* To avoid potentially 2 passes, figure out what we need to copy. *)
let union b1 b2 =
  if b1.size <= b2.size
  then begin
    let into = copy b2 in
    for i = 0 to (Array.length b1.a) - 1 do
      Array.unsafe_set into.a i
        ((Array.unsafe_get into.a i) lor (Array.unsafe_get b1.a i))
    done;
    into
  end else begin
    let into = copy b1 in
    for i = 0 to (Array.length b1.a) - 1 do
      Array.unsafe_set into.a i
        ((Array.unsafe_get into.a i) lor (Array.unsafe_get b2.a i))
    done;
    into
  end

(*$R
  let bv1 = CCBV.of_list [1;2;3;4] in
  let bv2 = CCBV.of_list [4;200;3] in
  let bv = CCBV.union bv1 bv2 in
  let l = List.sort compare (CCBV.to_list bv) in
  assert_equal [1;2;3;4;200] l;
  ()
*)

(*$T
  union (of_list [1;2;3;4;5]) (of_list [7;3;5;6]) |> to_sorted_list = CCList.range 1 7
*)

(* Underlying size shrinks for inter. *)
let inter_into ~into bv =
  if into.size > bv.size
  then __shrink into bv.size;
  for i = 0 to (Array.length into.a) - 1 do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) land (Array.unsafe_get bv.a i))
  done

let inter b1 b2 =
  if b1.size <= b2.size
  then begin
    let into = copy b1 in
    for i = 0 to (Array.length b1.a) - 1 do
      Array.unsafe_set into.a i
        ((Array.unsafe_get into.a i) land (Array.unsafe_get b2.a i))
    done;
    into
  end else begin
    let into = copy b2 in
    for i = 0 to (Array.length b2.a) - 1 do
      Array.unsafe_set into.a i
        ((Array.unsafe_get into.a i) land (Array.unsafe_get b1.a i))
    done;
    into
  end

(*$T
  inter (of_list [1;2;3;4]) (of_list [2;4;6;1]) |> to_sorted_list = [1;2;4]
*)

(*$R
  let bv1 = CCBV.of_list [1;2;3;4] in
  let bv2 = CCBV.of_list [4;200;3] in
  CCBV.inter_into ~into:bv1 bv2;
  let l = List.sort compare (CCBV.to_list bv1) in
  assert_equal [3;4] l;
*)

(* Underlying size depends on the 'in_' set for diff, so we don't change
  it's size! *)
let diff_into ~into bv =
  let n = min (Array.length into.a) (Array.length bv.a) in
  for i = 0 to n - 1 do
    Array.unsafe_set into.a i
      ((Array.unsafe_get into.a i) land (lnot (Array.unsafe_get bv.a i)))
  done

let diff ~in_ not_in =
  let into = copy in_ in
  diff_into ~into not_in;
  into

let select bv arr =
  let l = ref [] in
  begin try
      iter_true bv
        (fun i ->
           if i >= Array.length arr
           then raise Exit
           else l := arr.(i) :: !l)
    with Exit -> ()
  end;
  !l

(*$R
  let bv = CCBV.of_list [1;2;5;400] in
  let arr = [|"a"; "b"; "c"; "d"; "e"; "f"|] in
  let l = List.sort compare (CCBV.select bv arr) in
  assert_equal ["b"; "c"; "f"] l;
*)

let selecti bv arr =
  let l = ref [] in
  begin try
      iter_true bv
        (fun i ->
           if i >= Array.length arr
           then raise Exit
           else l := (arr.(i), i) :: !l)
    with Exit -> ()
  end;
  !l

(*$R
  let bv = CCBV.of_list [1;2;5;400] in
  let arr = [|"a"; "b"; "c"; "d"; "e"; "f"|] in
  let l = List.sort compare (CCBV.selecti bv arr) in
  assert_equal [("b",1); ("c",2); ("f",5)] l;
*)

(*$T
  selecti (of_list [1;4;3]) [| 0;1;2;3;4;5;6;7;8 |] \
    |> List.sort CCOrd.compare = [1, 1; 3,3; 4,4]
*)

type 'a sequence = ('a -> unit) -> unit

let to_seq bv k = iter_true bv k

(*$Q
  Q.(small_int) (fun i -> \
      let i = max 1 i in \
      let bv = create ~size:i true in \
      i = (to_seq bv |> Sequence.length))
  *)

let of_seq seq =
  let l = ref [] and maxi = ref 0 in
  seq (fun x -> l := x :: !l; maxi := max !maxi x);
  let bv = create ~size:(!maxi+1) false in
  List.iter (fun i -> set bv i) !l;
  bv

(*$T
  CCList.range 0 10 |> CCList.to_seq |> of_seq |> to_seq \
    |> CCList.of_seq |> List.sort CCOrd.compare = CCList.range 0 10
*)

let print out bv =
  Format.pp_print_string out "bv {";
  iter bv
    (fun _i b ->
       Format.pp_print_char out (if b then '1' else '0')
    );
  Format.pp_print_string out "}"
