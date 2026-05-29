CREATE OR REPLACE FUNCTION public.getconsumo_transito_grupo_2(p_grupo numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    cmm_transito numeric;



begin 
	
	
	  select round(((tempo_medio_ressuprimento/30)*consumo_medio_mensal),2)
    		into cmm_transito
      from vw_grupo_compras_produtos_mt vgcp  
      where id_grupo =p_grupo and idproduto=idprod;
	
	


    return coalesce(cmm_transito,0);



end;



$function$

