CREATE OR REPLACE FUNCTION public.getsaldohorizontefuturo_projetado_filial(p_filial numeric, idprod character varying, p_grupo numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    saldo_estoque numeric;

    compra_transito numeric;

    consumo_transito numeric;

    saldo_futuro numeric;

begin 





    select getconsumo_transito_projetado_filial(p_filial,idprod,amplitude_transito_atual_filial(p_filial,idprod)),getcompra_transito_grupo(p_grupo,idprod)/fator_conversao,coalesce(estoque,0) 

           into consumo_transito,compra_transito,saldo_estoque 

    from produtos_filial where filial = p_filial and idproduto=idprod; 



    

   saldo_futuro = (saldo_estoque-consumo_transito)+compra_transito;

    

    return saldo_futuro;



end;



$function$

