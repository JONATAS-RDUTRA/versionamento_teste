CREATE OR REPLACE FUNCTION public.get_entradas_filial(p_filial numeric, idprod character varying, data_ent date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare

    total numeric;

begin





   select coalesce(round(sum(qtde)::numeric,4),0) into total from entrada_mercadorias where idfilial = p_filial and idproduto::varchar = idprod and entrada_mercadorias.data_entrada= data_ent;





    return total;



end;



$function$

