CREATE OR REPLACE FUNCTION public.get_forecast_grupo(p_grupo numeric, idprod character varying, tempo_dias numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    saldo_estoque numeric;

    compra_transito numeric;

    consumo_futuro numeric;

    saldo_futuro numeric;

begin 





    select sum(getconsumo_provisionado_filial(p.filial,p.idproduto,tempo_dias)*p.fator_conversao),sum(coalesce(estoque*p.fator_conversao,0)) 

           into consumo_futuro,saldo_estoque 

    from produtos_filial p where p.filial  in (select filial from grupo_filial gf where gf.id_grupo=p_grupo) and  p.idproduto=idprod; 



    

   saldo_futuro = (saldo_estoque-consumo_futuro);

    

    return coalesce(saldo_futuro,0);



end;



$function$

