(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

	     
fun all_except_option(item, items) =
    case items of
	[] => NONE
      | x::xs => if x = item then SOME xs else
		 case all_except_option(item, xs) of
		     NONE => NONE
		   | SOME lst => SOME (x::lst)


fun get_substitutions1(subs, s) =
    case subs of
	[] => []
      | head::rest => case all_except_option(s, head) of
			  NONE => get_substitutions1(rest, s)
			| SOME lst => lst@get_substitutions1(rest, s)


fun get_substitutions2(subs, s) =
    let fun get_subs(subs, result) =
	    case subs of
		[] => result
              | x::xs => case all_except_option(s, x) of
                             NONE => get_subs(xs, result)
			   | SOME lst => get_subs(xs, result@lst)
    in
        get_subs(subs, [])
    end


fun similar_names(subs, {first=f,middle=m,last=l}) =
    let fun get_alt_names(first_names) =
	    case first_names of
		[] => []
	      | x::xs => {first=x,middle=m,last=l}::get_alt_names(xs)
    in
        {first=f,middle=m,last=l}::get_alt_names(get_substitutions1(subs, f))
    end


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove


fun card_color card =
    let val (s, r) = card in
	case s of
	    Spades => Black
	  | Clubs => Black
	  | Diamonds => Red
	  | Hearts => Red
    end


fun card_value card =
    let val (s, r) = card in
	case r of
	    Jack => 10
	  | King => 10
	  | Queen => 10
	  | Ace => 11
	  | Num x => x
    end


fun remove_card(cards, card, e) =
    case all_except_option(card, cards) of
        NONE => raise e
      | SOME lst => lst


fun all_same_color(cards) =
    case cards of
	[] => true
      | _::[] => true
      | head::neck::rest => card_color(head) = card_color(neck) andalso
			    all_same_color(neck::rest)


fun sum_cards(cards) =
    let fun sum(cards, total) =
	    case cards of
		[] => total
	      | x::xs => sum(xs, total + card_value(x))
    in
        sum(cards, 0)
    end


fun score(cards, goal) =
    let val sum = sum_cards(cards)
        val diff = sum - goal
        val prelim = if diff > 0 then 3 * diff else abs(diff)
    in
        if all_same_color(cards) then prelim div 2 else prelim
    end
	

fun officiate(card_list, moves, goal) =
    let fun run(card_list, held_cards, moves) =
            let fun calc_score() =
		    score(held_cards, goal)
            in
		if sum_cards(held_cards) > goal then
		    calc_score()
		else
		    case moves of
			[] => calc_score()
		      | (Discard c)::rest => run(card_list,
						 remove_card(held_cards, c, IllegalMove),
						 rest)
		      | Draw::rest => case card_list of
					  [] => calc_score()
					| x::xs => run(xs, x::held_cards, rest)
            end
    in
        run(card_list, [], moves)
    end


	
(* challenge problems *)
	
exception ListEmpty
	      

(* card ranks can map to multiple values. Ace maps to either 1 or 11 *)
fun card_value_challenge card =
    let val (s, r) = card in
	case r of
	    Jack => [10]
	  | King => [10]
	  | Queen => [10]
	  | Ace => [1,11]
	  | Num x => [x]
    end


(* get the list of sums for all card value combinations *)
fun sum_cards_challenge cards =
    let fun add_to_list(lst, v) =
	    case lst of
		[] => []
	      | x::xs => (x + v)::add_to_list(xs, v)
					     
	fun sum_combination(lst1, lst2) =
	    case lst1 of
		[] => []
	      | x::xs => add_to_list(lst2, x)@sum_combination(xs, lst2)
    in	
	case cards of
	    [] => [0]
	  | x::xs => sum_combination(card_value_challenge(x), sum_cards_challenge(xs))
    end

	
fun score_challenge(cards, goal) =
    let	fun best_score sums =
	    let fun get_score sum =
		    let val diff = sum - goal in
			if diff > 0 then 3 * diff else abs(diff)
		    end
	    in
		case sums of
		    [] => get_score 0
		  | x::[] => get_score x
		  | x::xs => Int.min(get_score x, best_score xs)
	    end
		
	val prelim = best_score(sum_cards_challenge cards) in
        if all_same_color(cards) then prelim div 2 else prelim
    end


fun officiate_challenge(card_list, moves, goal) =
    let fun run(card_list, held_cards, moves) =
            let fun calc_score() =
		    score_challenge(held_cards, goal)

		fun all_sums_exceed_goal(possible_sums) =
		    case possible_sums of
			x::[] => x > goal
		      | x::xs => x > goal andalso all_sums_exceed_goal(xs)
								      
            in
		if all_sums_exceed_goal(sum_cards_challenge held_cards) then
		    calc_score()
		else
		    case moves of
			[] => calc_score()
		      | (Discard c)::rest => run(card_list,
						 remove_card(held_cards, c, IllegalMove),
						 rest)
		      | (Draw)::rest => case card_list of
					    [] => calc_score()
					  | x::xs => run(xs, x::held_cards, rest)
            end
    in
        run(card_list, [], moves)
    end
