CREATE OR REPLACE FUNCTION public.getdesviopadrao(idprod character varying)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
declare 
    desvio float;
begin 

     select coalesce(round(stddev_pop(tempo_ressuprimento)/30,2),0) into desvio from analise_requisicoes where cast(idproduto as  character varying)  = idProd 
        and atraso = 0 and qtde > 0 and data_solicitacao between current_date -365 and current_date;
    
    return desvio;

end;

$function$

