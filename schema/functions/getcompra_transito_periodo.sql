CREATE OR REPLACE FUNCTION public.getcompra_transito_periodo(idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    compra_transito_before numeric;
    compra_transito_after numeric;
   
    tot_compra_transito numeric;
   
begin 
	

    select coalesce(sum(qtde_pendente),0) into compra_transito_before from requisicoes where idproduto = idprod
            and qtde_pendente > 0 and data_solicitacao<=first_day(dataref);
    
    select coalesce(sum(qtde),0) into compra_transito_after from requisicoes where idproduto = idprod
            and  data_solicitacao between first_day(dataref) and last_day(dataref) and data_entrega > last_day(dataref);   
           
           
    if compra_transito_before = 0 then
    
    	select coalesce(sum(qtde),0) into compra_transito_before from requisicoes where idproduto = idprod
            and  data_solicitacao<=first_day(dataref) and (data_entrega > last_day(dataref) or data_entrega is null); 
    
    end if;
                
   
    tot_compra_transito = compra_transito_before + compra_transito_after;

    if tot_compra_transito isnull then 
    
    tot_compra_transito = 0;
    
    end if;

    
    return tot_compra_transito;

end;

$function$

