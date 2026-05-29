CREATE OR REPLACE FUNCTION public.gettemporessuprimento(idprod character varying)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
declare 
    tempo_ressuprimento_mes float;
begin 

     select coalesce(round(avg(tempo_ressuprimento)/30,2),2) into tempo_ressuprimento_mes from analise_requisicoes where cast(idproduto as  character varying)  =idProd   
         and atraso = 0 and qtde > 0 and data_solicitacao between current_date -365 and current_date;

      if tempo_ressuprimento_mes = 0 then
      
        tempo_ressuprimento_mes=2; 
      
      end if;
    
    return tempo_ressuprimento_mes;

end;

$function$

