CREATE OR REPLACE FUNCTION public.getcompra_transito(idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    compra_transito numeric;
begin 

    select sum(qtde_pendente) into compra_transito from requisicoes where idproduto = idprod and qtde_pendente > 0 and idfilial in (1,2,3);

    if compra_transito isnull then 
    
    compra_transito = 0;
    
    end if;

    
    return compra_transito;

end;

$function$

