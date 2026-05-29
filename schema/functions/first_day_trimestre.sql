CREATE OR REPLACE FUNCTION public.first_day_trimestre(dataref date)
 RETURNS date
 LANGUAGE plpgsql
AS $function$
declare
first_day date;
begin
      
	select 
		case 
		when date_part('quarter',dataref)  = 1 then (date_trunc('month', ('01/01'||to_char(dataref,'/yyyy'))::date))::date
		when date_part('quarter',dataref)  = 2 then (date_trunc('month', ('01/04'||to_char(dataref,'/yyyy'))::date))::date
		when date_part('quarter',dataref)  = 3 then (date_trunc('month', ('01/07'||to_char(dataref,'/yyyy'))::date))::date
		when date_part('quarter',dataref)  = 4 then (date_trunc('month', ('01/10'||to_char(dataref,'/yyyy'))::date))::date
		end 
	into first_day;

    return first_day;
 end;
$function$

