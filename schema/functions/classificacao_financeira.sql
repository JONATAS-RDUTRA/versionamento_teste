CREATE OR REPLACE FUNCTION public.classificacao_financeira()
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$  
declare 
rec_prod record;
BEGIN

  FOR rec_prod in(select * from vw_classificacao_financeira_dinamica)
    LOOP

       UPDATE produtos SET classificacao_financeira = rec_prod.classificacao where idproduto = rec_prod.idproduto;

    END LOOP;

    RETURN 1;
END;
$function$

