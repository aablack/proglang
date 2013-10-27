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

val test24 = match (Const 10, Wildcard) = SOME [];

val test25 = match (Tuple [Const 10, Unit], Variable "x") = SOME [ ("x", Tuple [Const 10, Unit]) ];

val test26 = match (Const 10, UnitP) = NONE;

val test27 = match (Unit, UnitP) = SOME [];

val test28 = match (Const 20, ConstP 19) = NONE;

val test29 = match (Const 20, ConstP 20) = SOME [];

val test30 = match (Tuple [Const 20, Unit],
		    TupleP [ConstP 20, ConstP 0]) = NONE;

val test31 = match (Constructor ("x", Unit),
		    ConstructorP ("y", UnitP)) = NONE;

val test32 = match (Constructor ("x", Unit),
		    ConstructorP ("x", UnitP)) = SOME [];

val test32 = match (Constructor ("x", Tuple [Const 10]),
		    ConstructorP ("x", TupleP [ConstP 10])) = SOME [];

val test33 = match (Tuple [Const 10, Const 20],
		    TupleP [Variable "x", Wildcard]) = SOME [("x", Const 10)];

val test34 = match (Tuple [Unit, Unit],
		    TupleP [UnitP]) = NONE;

val test35 = first_match (Tuple [Unit, Const 10])
			 [UnitP,
			  ConstructorP ("x", UnitP),
			  ConstP 10,
			  TupleP [UnitP, Variable "x"]] = SOME [("x", Const 10)];

val test36 = first_match (Tuple [Unit, Const 10])
			 [UnitP,
			  ConstructorP ("x", UnitP),
			  ConstP 10,
			  TupleP [ConstP 10, Variable "x"]] = NONE;
