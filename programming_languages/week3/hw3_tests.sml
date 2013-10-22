use "hw3.sml";

val test1 = only_capitals ["I", "am", "Fred"] = ["I", "Fred"]

val test2 = longest_string1 ["this", "is", "an", "incomprehensive", "list", "of",
"strings"] = "incomprehensive"

val test3 = longest_string1 ["have", "a", "nice", "day"] = "have";

val test4 = longest_string2 ["this", "is", "an", "incomprehensive", "list", "of",
"strings"] = "incomprehensive"

val test5 = longest_string2 ["have", "a", "nice", "day"] = "nice";

val test6 = longest_string3 ["this", "is", "an", "incomprehensive", "list", "of",
"strings"] = "incomprehensive"

val test7 = longest_string3 ["have", "a", "nice", "day"] = "have";

val test8 = longest_string4 ["this", "is", "an", "incomprehensive", "list", "of",
"strings"] = "incomprehensive"

val test9 = longest_string4 ["have", "a", "nice", "day"] = "nice";

val test10 = longest_capitalized ["apple", "pineapple", "watermelon", "Pear"] = "Pear";

val test11 = longest_capitalized ["apple", "pineapple", "watermelon"] = "";

val test12 = rev_string "abc" = "cba";

val test13 = first_answer (fn x => if x >= 5 then SOME x else NONE)
			  [1, 4, 5, 9] = 5;

val test14 = (first_answer (fn x => if x >= 5 then SOME x else NONE)
			  [1, 4, 3, 2]; false) handle NoAnswer => true;

val test15 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1, 1, 1] = SOME [1,1,1];

val test16 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [1, 1, 2] = NONE;

val test17 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [] = SOME [];

val test18 = count_wildcards (TupleP [Variable "foo", Wildcard, Wildcard,
                              ConstructorP ("bar", Wildcard)]) = 3;

val test19 = count_wildcards (TupleP [Variable "foo", ConstructorP ("bar",
                              ConstP 100)]) = 0;

val test20 = count_wild_and_variable_lengths (TupleP [Variable "foo", Wildcard, Wildcard,
						      ConstructorP ("bar", Variable "foobarfoo")]) = 14;

val test21 = count_some_var ("foo", (ConstructorP("foo", TupleP [Variable "foo",
                             Wildcard, TupleP [Variable "foo"]]))) = 2;

val test22 = check_pat (TupleP [Variable "x", Variable "x", ConstructorP ("x", Variable "x")]) = false;

val test23 = check_pat (TupleP [Variable "x", Variable "y", ConstructorP ("x", Variable "z")]) = true;





(*
val test2 = longest_string1 ["A","bc","C"] = "bc"

val test3 = longest_string2 ["A","bc","C"] = "bc"

val test4a= longest_string3 ["A","bc","C"] = "bc"

val test4b= longest_string4 ["A","B","C"] = "C"

val test5 = longest_capitalized ["A","bc","C"] = "A";

val test6 = rev_string "abc" = "cba";

val test7 = first_answer (fn x => if x > 3 then SOME x else NONE) [1,2,3,4,5] = 4

val test8 = all_answers (fn x => if x = 1 then SOME [x] else NONE) [2,3,4,5,6,7] = NONE

val test9a = count_wildcards Wildcard = 1

val test9b = count_wild_and_variable_lengths (Variable("a")) = 1

val test9c = count_some_var ("x", Variable("x")) = 1;

val test10 = check_pat (Variable("x")) = true

val test11 = match (Const(1), UnitP) = NONE

val test12 = first_match Unit [UnitP] = SOME []
*)
