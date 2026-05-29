CREATE OR REPLACE FUNCTION public.get_preco_medio_venda_filial(p_filial numeric, idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$ 

declare 

preco_mv3 numeric;
preco_mv6 numeric;
preco_mv  numeric;
preco_unit numeric;


begin
	
	  select coalesce(valor_unitario*fator_conversao,0)  into preco_unit from produtos_filial pf  where pf.filial = p_filial and pf.idproduto = idprod;
	
			
      select round((sum(total)/nullif(sum(total_qtde),0))::numeric,2)  into preco_mv6 from (   
        SELECT
			(qtde * valor_unit) total, 
			qtde as total_qtde
		FROM
			consumos
		WHERE
			consumos.filial = p_filial
			and consumos.idproduto = idprod
			AND emissao BETWEEN (dataref - 180)	AND dataref
		    and qtde > 0) a;


preco_mv = coalesce(round(preco_mv6,2),0);	

if preco_mv = 0 then  preco_mv= preco_unit; end if;
	
	
return preco_mv;
	

end;
$function$

