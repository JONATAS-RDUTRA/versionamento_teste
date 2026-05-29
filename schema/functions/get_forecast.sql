CREATE OR REPLACE FUNCTION public.get_forecast(idprod character varying, tempo_dias numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    saldo_estoque numeric;
    compra_transito numeric;
    consumo_futuro numeric;
    saldo_futuro numeric;
begin 


    select getconsumo_provisionado(idprod,tempo_dias),coalesce(estoque,0) 
           into consumo_futuro,saldo_estoque 
    from produtos where idproduto=idprod; 

    
   saldo_futuro = (saldo_estoque-consumo_futuro);
    
    return saldo_futuro;

end;

$function$

