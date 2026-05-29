CREATE OR REPLACE FUNCTION public.first_day(dataref date)
 RETURNS date
 LANGUAGE plpgsql
AS $function$
declare
first_day date;
begin
    first_day = (select (date_trunc('month', $1) - interval '1 month' + interval '1 month')::date);
   
    return first_day;
 end;
$function$

