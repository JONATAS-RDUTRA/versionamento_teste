CREATE OR REPLACE FUNCTION public.trigger_preco_medio_venda()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare

  preco_mv  numeric;
  
begin 

	
	preco_mv = ( select get_preco_medio_venda_filial(new.filial,new.idproduto,new.data_solicitacao));

  
    new.preco_medio_venda = preco_mv;
    new.media_mensal_diaria = round((new.media_mensal /26),2);
    new.venda_diaria_calc =  round((new.media_mensal /26)*preco_mv,2);
    new.ruptura_calc =  round(new.venda_diaria_calc * new.qtde_dias_ruptura,2);
    
RETURN NEW;

end;

$function$

