CREATE OR REPLACE FUNCTION public.getcompra_transito_filial(p_filial numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    compra_transito numeric;

begin 

    select sum(qtde_pendente*pf.fator_conversao) into compra_transito from requisicoes r inner join produtos_filial pf on r.idfilial = pf.filial and r.idproduto = pf.idproduto where r.idproduto = idprod and qtde_pendente > 0 and idfilial = p_filial;

    if compra_transito isnull then 

    	compra_transito = 0;

    end if;    

    return compra_transito;
end;
$function$

