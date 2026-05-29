CREATE OR REPLACE FUNCTION public.getclassfinanceira(percentual numeric)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    abc character varying;
begin 


      select case when percentual <= 0.8 then 'A'
            when percentual > 0.8 and percentual <= 0.95 then 'B'
            else 'C' end into abc;
           
    
    return abc;

end;

$function$

