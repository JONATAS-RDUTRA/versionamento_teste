CREATE OR REPLACE FUNCTION public.last_day(dataref date)
 RETURNS date
 LANGUAGE plpgsql
AS $function$
declare
last_day date;
begin
    last_day = (select (date_trunc('month', $1) + interval '1 month' - interval '1 day')::date);
   
    return last_day;
 end;
$function$

