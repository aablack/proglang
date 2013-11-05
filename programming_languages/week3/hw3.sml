(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let
        val r = g f1 f2 
    in
        case p of
            Wildcard          => f1 ()
          | Variable x        => f2 x
          | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
          | ConstructorP(_,p) => r p
          | _                 => 0
    end

(* Q1 *)
fun only_capitals lst =
    List.filter (fn s => Char.isUpper (String.sub (s, 0))) lst

(* Q2 *)
fun longest_string1 lst =
    List.foldl (fn (s1, s2) => if String.size s1 > String.size s2 then s1 else s2) "" lst

(* Q3 *)
fun longest_string2 lst =
    List.foldl (fn (s1, s2) => if String.size s1 >= String.size s2 then s1 else s2) "" lst

(* Q4 *)
fun longest_string_helper f lst =
	List.foldl (fn (a, b) => if f (String.size a, String.size b) then a else b) "" lst

val longest_string3 = longest_string_helper (fn (a, b) => a > b)

val longest_string4 = longest_string_helper (fn (a, b) => a >= b)

(* Q5 *)
val longest_capitalized = longest_string1 o only_capitals

(* Q6 *)
val rev_string = String.implode o rev o String.explode;

(* Q7 *)
fun first_answer f lst =
    case lst of
	[] => raise NoAnswer
      | x::xs => case f x of
		     SOME k => k
		   | NONE => first_answer f xs

(* Q8 *)
fun all_answers f lst =
    let fun aux(lst, acc) =
        case lst of
             [] => acc
           | x::xs => case f x of
                           NONE => raise NoAnswer
                         | SOME lst => aux (xs, lst@acc)
    in
        SOME (aux (lst, [])) handle NoAnswer => NONE
    end

(* Q9 *)
fun count_wildcards pat =
    g (fn () => 1) (fn _ => 0) pat

fun count_wild_and_variable_lengths pat =
    g (fn () => 1) String.size pat

fun count_some_var (name, pat) =
    g (fn () => 0) (fn n => if name=n then 1 else 0) pat

(* Q10 *)
fun check_pat pat =
    let fun get_vars (pat) =
	    case pat of
		Wildcard          => []
              | Variable x        => [x]
              | TupleP ps         => List.foldl (fn (p, acc) => (get_vars p)@acc) [] ps
              | ConstructorP(_,p) => get_vars  p
              | _                 => []
	fun distinctp (lst) =
	    case lst of
		[] => true
	      | x::xs => not (List.exists (fn j => j = x) xs) andalso distinctp xs
    in
	distinctp (get_vars pat)
    end

(* Q11 *)
fun match (valu, pat) =
    case (valu, pat) of
	(_, Wildcard) => SOME []
      | (v, Variable s) => SOME [(s, v)]
      | (Unit, UnitP) => SOME []
      | (Const x, ConstP y) => if x = y then SOME [] else NONE
      | (Tuple vs, TupleP ps) => if length vs = length ps
				 then all_answers match (ListPair.zip (vs, ps))
				 else NONE
      | (Constructor (s1, v), ConstructorP (s2, p)) => if s1 = s2
						       then match (v, p)
						       else NONE
      | _ => NONE

(* Q12 *)
fun first_match valu pats =
    SOME (first_answer (fn p => match (valu, p)) pats)
    handle NoAnswer => NONE

(* Q13 *)
datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

exception TypeError

fun typecheck_patterns (constructors:(string*string*typ) list, patterns) =
    let fun get_general_type(typ1, typ2) =
	    case (typ1, typ2) of
		(t, Anything) => t
	      | (Anything, t) => t
	      | (UnitT, UnitT) => UnitT
	      | (IntT, IntT) => IntT
	      | (TupleT ts1, TupleT ts2) => if length ts1 = length ts2
					    then TupleT (List.map get_general_type
								  (ListPair.zip (ts1, ts2)))
					    else raise TypeError
	      | (Datatype s1, Datatype s2) => if s1 = s2 then Datatype s1 else raise TypeError
	      | _ => raise TypeError

	fun get_type pat =
	    case pat of
		Wildcard => Anything
	      | Variable x => Anything
	      | UnitP => UnitT
	      | ConstP n => IntT
	      | TupleP ps => TupleT (List.map (fn x => get_type x) ps)
	      | ConstructorP (s, p) => case List.find (fn x => #1 x = s) constructors of
					   NONE => raise TypeError
					 | SOME ctr => (get_general_type(#3 ctr, get_type p);
							Datatype (#2 ctr))
				   	
    in
	if null patterns then
	    NONE
	else
	    SOME (List.foldl (fn (x, acc) => get_general_type (get_type x, acc)) Anything patterns)
	    handle TypeError => NONE
    end

