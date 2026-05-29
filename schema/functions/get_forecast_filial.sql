CREATE OR REPLACE FUNCTION public.get_forecast_filial(p_filial numeric, idprod character varying, tempo_dias numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    saldo_estoque numeric;

    compra_transito numeric;

    consumo_futuro numeric;

    saldo_futuro numeric;
   
    fator numeric;

begin 





    select getconsumo_provisionado_filial(p_filial,idprod,tempo_dias),coalesce(estoque,0),coalesce(fator_conversao,1) 

           into consumo_futuro,saldo_estoque,fator 

    from produtos_filial where filial = p_filial and  idproduto=idprod; 



    

   saldo_futuro = round((saldo_estoque-consumo_futuro)*fator,4);

    

    return saldo_futuro;



end;



$function$

