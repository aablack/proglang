fun is_older(a : int*int*int, b : int*int*int) =
    if #1 a = #1 b then
	if #2 a = #2 b then #3 a < #3 b
	else  #2 a < #2 b
    else
	#1 a < #1 b


fun number_in_month(dates:(int*int*int) list, month:int) =
    if null dates then 0
    else number_in_month(tl dates, month) + (if #2 (hd dates) = month then 1 else 0)


fun number_in_months(dates:(int*int*int) list, months:int list) =
    if null months then 0
    else number_in_month(dates, hd months) + number_in_months(dates, tl months)

							   
fun dates_in_month(dates:(int*int*int) list, month:int) =
    if null dates then
       []
    else
	let val filtered_dates = dates_in_month(tl dates, month) in
	    if #2 (hd dates) = month then  hd dates :: filtered_dates
	    else filtered_dates
	end


fun dates_in_months(dates:(int*int*int) list, months:int list) =
    if null months then []
    else dates_in_month(dates, hd months) @ dates_in_months(dates, tl months)


fun get_nth(items:string list, index:int) =
    if index - 1 = 0 then hd items
    else get_nth(tl items, index - 1)


fun date_to_string(date:(int*int*int)) =
    let val months = ["January", "February", "March", "April", "May", "June", "July",
		      "August", "September", "October", "November", "December"];
    in
	get_nth(months, #2 date) ^ " " ^ Int.toString(#3 date) ^ ", " ^ Int.toString(#1 date)
									   
    end


fun number_before_reaching_sum(sum:int, values:int list) =
    let fun get_number(current_sum:int, index:int, values:int list) =
	let val new_sum = current_sum + hd values in
	    if new_sum >= sum then index
	    else get_number(new_sum, index + 1, tl values)
	end
    in
	get_number(0, 0, values)
    end


fun what_month(day:int) =
    let val months=[31,28,31,30,31,30,31,31,30,31,30,31] in
	number_before_reaching_sum(day, months) + 1
    end


fun month_range(day1:int, day2:int) =
    if day1 > day2 then []
    else what_month(day1) :: month_range(day1 + 1, day2)


fun oldest(dates:(int*int*int) list) =
    if null dates then NONE
    else
	let fun oldest_nonempty(dates:(int*int*int) list) =
		if null (tl dates) then hd dates
		else
		    let val date = hd dates in
			if is_older(date, oldest_nonempty(tl dates)) then date
			else oldest_nonempty(tl dates)
		    end
	in
	    SOME(oldest_nonempty(dates))
	end

			     
fun remove_duplicates(values:int list) =
    let fun remove_value(value:int, values:int list) =
	if null values then []
	else if hd values = value then remove_value(value, tl values)
    else (hd values)::remove_value(value, tl values)
    in			 
	if null values then []
	else (hd values) :: remove_duplicates(remove_value(hd values, tl values))
    end	


fun number_in_months_challenge(dates:(int*int*int) list, months:int list) =
    number_in_months(dates, remove_duplicates(months))


fun dates_in_months_challenge(dates:(int*int*int) list, months:int list) =
    dates_in_months(dates, remove_duplicates(months))

		
fun reasonable_date(date:(int*int*int)) =
    let fun days_in_month(year:int, month:int) =
	let fun get_nth(items:int list, index:int) =
	    if index - 1 = 0 then hd items
	    else get_nth(tl items, index - 1)
	in
	    let val days_of_month=[31,28,31,30,31,30,31,31,30,31,30,31]
		val leap_days_of_month=[31,29,31,30,31,30,31,31,30,31,30,31]
	    in
		if year mod 4 = 0 andalso not (year mod 100 = 0)
		then get_nth(leap_days_of_month, month)
		else get_nth(days_of_month, month)
	    end
	end 
    in
	let val year = #1 date val month = #2 date val day = #3 date in
	    year > 0 andalso
	    month > 0 andalso month <= 12 andalso
	    day > 0 andalso day <= days_in_month(year, month)
	end
    end

