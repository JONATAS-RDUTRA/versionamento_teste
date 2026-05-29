CREATE OR REPLACE FUNCTION public.get_stddev_heranca_consumo(p_filial numeric, p_produto character varying, p_dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
desvio numeric;
linf numeric;
lisup numeric;

begin
	
	 select limite_inferior ,limite_superior into linf,lisup  from analise_statistica_produtos where filial=p_filial and idproduto=p_produto;
	 
	-- Espaço amostral sai de 365 para 180;
	select coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)
	into desvio
	from (
     select * from (	
	  select to_char(emissao, 'YYYYMM') as mes
			,sum(qtde) as saidas
		from consumos c
		where c.filial = p_filial
			and c.idproduto = p_produto
			and c.emissao between (p_dataref - 180)
				and p_dataref
		group by mes) a where a.saidas between linf and lisup
		) com;
	return desvio;
end;$function$

