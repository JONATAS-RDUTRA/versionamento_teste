CREATE OR REPLACE FUNCTION public.gettmr(idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    tmr numeric;
    ressup_manual varchar;
    ressup_dia numeric;
begin 
	
	select
		ressuprimento_manual,
		avg(nullif(ressuprimento_manual_dias,0))
		into 
		ressup_manual,
		ressup_dia
 	from produtos_filial 
	  where idproduto = idprod
	 group by ressuprimento_manual limit 1;

   if ressup_manual='S' then
   
      return ressup_dia;
     
    else
    
	    select round( cast(getTempoRessuprimento(idProd) as numeric)  + cast(getDesvioPadrao(idProd) as numeric),2)*30 into tmr;
    	return tmr;
    
   end if; 
	 
end;

$function$

