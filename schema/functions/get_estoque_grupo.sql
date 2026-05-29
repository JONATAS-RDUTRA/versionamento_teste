CREATE OR REPLACE FUNCTION public.get_estoque_grupo(p_grupo numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
    total numeric;
begin

    select sum(pf.estoque) into total from produtos_filial pf WHERE filial in (select filial from grupo_filial gf where gf.id_grupo=p_grupo) and  idproduto = idprod;

    return coalesce(total,0);

end;

$function$

