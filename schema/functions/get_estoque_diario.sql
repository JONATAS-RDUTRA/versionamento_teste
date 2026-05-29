CREATE OR REPLACE FUNCTION public.get_estoque_diario(idprod character varying, data_venda date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
    total numeric;
begin

    select sum(qtde) into total from hist_estoque WHERE filial in (1,2,3) and  hist_estoque.idproduto = idprod  AND data = data_venda;

    return coalesce(total,0);

end;

$function$

