CREATE OR REPLACE FUNCTION public.getcompra_transito_grupo(p_grupo numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    compra_transito numeric;

begin 



    select sum(qtde_pendente*pf.fator_conversao) into compra_transito from requisicoes r inner join produtos_filial pf on r.idfilial = pf.filial and r.idproduto = pf.idproduto where r.idproduto = idprod and qtde_pendente > 0 and idfilial in (select filial from grupo_filial where id_grupo=p_grupo);



    if compra_transito isnull then 

    

    compra_transito = 0;

    

    end if;



    

    return compra_transito;



end;



$function$

