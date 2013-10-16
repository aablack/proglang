(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

	     
fun all_except_option(x, items) =
    case items of
	[] => NONE
      | xx::yy => if same_string(xx, x) then SOME yy else
		  case all_except_option(x, yy) of
		      NONE => NONE
		    | SOME lst => SOME (xx::lst)


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
	      | xx::yy => case all_except_option(s, xx) of
			      NONE => get_subs(yy, result)
			    | SOME lst => get_subs(yy, result@lst)
    in
	get_subs(subs, [])
    end


fun similar_names(subs, {first=x,middle=y,last=z}) =
    let fun get_alt_names(first_names) =
	    case first_names of
		[] => []
	      | xx::yy => {first=xx,middle=y,last=z}::get_alt_names(yy)
    in
	{first=x,middle=y,last=z}::get_alt_names(get_substitutions1(subs, x))
    end


(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove


(* By specifying the type of s and r we enforce a valid card: suit*rank,
is being passed in. This is probably not essential for the homework. *)
fun card_color(s:suit, r:rank) =
    case s of
	Spades => Black
      | Clubs => Black
      | Diamonds => Red
      | Hearts => Red


fun card_value(s:suit, r:rank) =
    case r of
	Jack => 10
      | King => 10
      | Queen => 10
      | Ace => 11
      | Num x => x


fun remove_card(cards, card, e) =
    case cards of
	[] => raise e
      | xx::[] => if xx = card then [] else raise e
      | xx::yy => if xx = card then yy else xx::remove_card(yy, card, e)


fun all_same_color(cards) =
    case cards of
	[] => true
      | xx::[] => true
      | xx::yy::zz => card_color(xx) = card_color(yy) andalso
		      all_same_color(yy::zz)


fun sum_cards(cards) =
    let fun sum(cards, total) =
	    case cards of
		[] => total
	      | xx::yy => sum(yy, total + card_value(xx))
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
		       
