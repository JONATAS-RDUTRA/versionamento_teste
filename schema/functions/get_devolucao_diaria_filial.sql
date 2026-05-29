CREATE OR REPLACE FUNCTION public.get_devolucao_diaria_filial(p_filial numeric, idprod character varying, data_venda date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare

    total numeric;

begin

    select coalesce(round(sum(abs(qtde))::numeric,4),0) into total from consumos where filial= p_filial and idproduto=idprod and emissao=data_venda and qtde < 0;


        return coalesce(total,0);


end;

$function$

