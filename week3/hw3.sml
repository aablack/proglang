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

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

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
      | x::ys => case f x of
		     SOME k => k
		   | NONE => first_answer f ys
