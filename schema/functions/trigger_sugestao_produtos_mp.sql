CREATE OR REPLACE FUNCTION public.trigger_sugestao_produtos_mp()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
begin 

	 new.sugestao = round((new.emax + (new.cmm * (new.tp_ressup + new.std_tp_ressup)-new.estoque)-new.cmm),2);
	  
	 if new.sugestao < 0 then new.sugestao = 0; end if;	
	 new.processamento = current_timestamp;

RETURN NEW;
end
$function$

