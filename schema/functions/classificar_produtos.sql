CREATE OR REPLACE FUNCTION public.classificar_produtos()
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$  
declare 
rec_prod record;
BEGIN

  FOR rec_prod in(select * from vw_classificacao_financeira)
    LOOP

       UPDATE produtos SET classificacao_financeira = rec_prod.classificacao, classificacao_comprabilidade = cast(get123(rec_prod.idproduto) as integer),classificacao_popularidade=getpqr(rec_prod.idproduto) where idproduto = rec_prod.idproduto;

    END LOOP;

    RETURN 1;
END;
$function$

