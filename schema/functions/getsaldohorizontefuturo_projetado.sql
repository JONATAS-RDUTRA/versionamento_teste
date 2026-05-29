CREATE OR REPLACE FUNCTION public.getsaldohorizontefuturo_projetado(idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    saldo_estoque numeric;
    compra_transito numeric;
    consumo_transito numeric;
    saldo_futuro numeric;
begin 


    select getconsumo_transito_projetado(idprod,amplitude_transito_atual(idprod)),getcompra_transito(idprod),coalesce(estoque,0) 
           into consumo_transito,compra_transito,saldo_estoque 
    from produtos where idproduto=idprod; 

    
   saldo_futuro = (saldo_estoque-consumo_transito)+compra_transito;
    
    return saldo_futuro;

end;

$function$

